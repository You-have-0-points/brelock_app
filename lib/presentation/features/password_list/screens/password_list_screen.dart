// lib/presentation/features/password_list/screens/password_list_screen.dart
import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/folder.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/usecases/folder_interactor.dart';
import 'package:brelock/presentation/features/add_items/add_category/screens/add_category_screen.dart';
import 'package:brelock/presentation/features/add_items/add_password/add_password_screen.dart';
import 'package:brelock/presentation/features/password_list/widget/category_card.dart';
import 'package:brelock/presentation/features/password_list/widget/service_card.dart';
import 'package:brelock/presentation/features/settings/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:brelock/presentation/theme_provider.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:brelock/presentation/features/breach_check/screens/breach_check_screen.dart';
import 'package:brelock/presentation/features/analytics/screens/analytics_screen.dart';
import 'package:brelock/services/local_storage_service.dart';
import 'package:brelock/presentation/features/login/screens/login_screen.dart';
import 'package:brelock/services/connectivity_service.dart';
import '../../../themes/sizes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  List<Folder> folders = [];
  List<Password> passwords = [];
  List<Password> filteredPasswords = [];
  bool isLoading = true;
  UuidValue? selectedFolderId;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool _isOnline = true;
  bool _showOfflineBanner = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkConnectivity();

    ConnectivityService.connectivityStream.listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
        _showOfflineBanner = !_isOnline;
      });
    });

    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    final isConnected = await ConnectivityService.isConnected();
    setState(() {
      _isOnline = isConnected;
      _showOfflineBanner = !isConnected;
    });
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredPasswords = List.from(passwords);
      });
    } else {
      setState(() {
        isSearching = true;
        filteredPasswords = passwords.where((password) {
          return password.serviceName.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      isSearching = false;
    });
  }

  // В lib/presentation/features/password_list/screens/password_list_screen.dart
// Обновите метод _loadData:
  Future<void> _loadData() async {
    try {
      print('🔄 Starting data loading...');
      final isConnected = await ConnectivityService.isConnected();

      if (!isConnected) {
        print('📴 Offline mode - loading from cache');
        await _loadDataFromCache();
      } else {
        print('📡 Online mode - loading from network');
        await _loadDataFromNetwork();
      }

    } catch (e) {
      print('❌ Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadDataFromNetwork() async {
    try {
      // Загружаем папки из сети
      final loadedFolders = await folderInteractor.getAll(current_consumer);
      print('📁 Loaded ${loadedFolders.length} folders from network');

      setState(() {
        folders = loadedFolders;
      });

      // Сохраняем в кэш
      await _cacheFolders(loadedFolders);

      // Выбираем первую папку по умолчанию
      if (folders.isNotEmpty) {
        setState(() {
          selectedFolderId = folders[0].id;
        });
        await _loadPasswordsForSelectedFolder(); // Этот метод теперь сам кэширует пароли
      } else {
        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {
      print('❌ Error loading data from network: $e');
      // При ошибке сети пытаемся загрузить из кэша
      await _loadDataFromCache();
    }
  }

  Future<void> _loadDataFromCache() async {
    try {
      // Загружаем папки из кэша
      final cachedFolders = await LocalStorageService.getCachedFolders();
      if (cachedFolders != null && cachedFolders.isNotEmpty) {
        // Преобразуем данные кэша в объекты Folder
        final loadedFolders = await _convertCachedFolders(cachedFolders);
        print('📁 Loaded ${loadedFolders.length} folders from cache');

        setState(() {
          folders = loadedFolders;
        });

        if (folders.isNotEmpty) {
          setState(() {
            selectedFolderId = folders[0].id;
          });
          await _loadPasswordsForSelectedFolderFromCache();
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('❌ No cached folders found');
        setState(() {
          isLoading = false;
          folders = [];
        });
      }
    } catch (e) {
      print('❌ Error loading data from cache: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadPasswordsForSelectedFolderFromCache() async {
    if (selectedFolderId == null) {
      setState(() {
        passwords = [];
        filteredPasswords = [];
        isLoading = false;
      });
      return;
    }

    try {
      print('📚 Loading passwords from cache for folder: $selectedFolderId');

      final cachedPasswords = await LocalStorageService.getCachedAllPasswords();

      if (cachedPasswords != null && cachedPasswords.isNotEmpty) {
        print('📖 Found ${cachedPasswords.length} passwords in cache');

        // Получаем текущую папку чтобы знать какие password_ids в ней
        final folder = await folderInteractor.getById(selectedFolderId!);
        final folderPasswordIds = folder.passwordsIds;

        print('📋 Folder requires passwords with IDs: $folderPasswordIds');

        // Фильтруем пароли по folderPasswordIds
        final filteredPasswords = <Password>[];

        for (final passwordData in cachedPasswords) {
          try {
            final password = passwordTranslator.toEntity(passwordData);
            // Проверяем, есть ли этот пароль в текущей папке
            if (folderPasswordIds.contains(password.id)) {
              filteredPasswords.add(password);
            }
          } catch (e) {
            print('❌ Error converting cached password: $e');
          }
        }

        print('✅ Filtered ${filteredPasswords.length} passwords for current folder');

        setState(() {
          passwords = filteredPasswords;
          this.filteredPasswords = List.from(filteredPasswords);
          isLoading = false;
        });

      } else {
        print('❌ No passwords found in cache');
        setState(() {
          passwords = [];
          filteredPasswords = [];
          isLoading = false;
        });
      }

    } catch (e) {
      print('❌ Error loading passwords from cache: $e');
      setState(() {
        passwords = [];
        filteredPasswords = [];
        isLoading = false;
      });
    }
  }

// Вспомогательные методы для работы с кэшем
  Future<List<Folder>> _convertCachedFolders(List<Map<String, dynamic>> cachedFolders) async {
    final folders = <Folder>[];
    for (final folderData in cachedFolders) {
      try {
        final folder = folderTranslator.toEntity(folderData);
        folders.add(folder);
      } catch (e) {
        print('Error converting cached folder: $e');
      }
    }
    return folders;
  }

  Future<List<Password>> _filterPasswordsByFolder(List<Map<String, dynamic>> cachedPasswords, UuidValue folderId) async {
    final passwords = <Password>[];
    for (final passwordData in cachedPasswords) {
      try {
        final password = passwordTranslator.toEntity(passwordData);
        // Здесь нужно проверить, принадлежит ли пароль к выбранной папке
        // Это требует дополнительной логики, которая зависит от структуры данных
        passwords.add(password);
      } catch (e) {
        print('Error converting cached password: $e');
      }
    }
    return passwords;
  }

  Future<void> _cacheFolders(List<Folder> folders) async {
    try {
      final foldersData = folders.map((folder) => folderTranslator.toDocument(folder)).toList();
      await LocalStorageService.cacheFolders(foldersData);
      print('✅ Folders cached successfully');
    } catch (e) {
      print('❌ Error caching folders: $e');
    }
  }

  Future<void> _loadPasswordsForSelectedFolder() async {
    if (selectedFolderId == null) {
      setState(() {
        passwords = [];
        filteredPasswords = [];
        isLoading = false;
      });
      return;
    }

    try {
      print('🔍 Loading passwords for folder: $selectedFolderId');

      // Получаем папку с актуальными password_ids
      final folder = await folderInteractor.getById(selectedFolderId!);
      print('📋 Folder "${folder.name}" has ${folder.passwordsIds.length} password IDs');

      // Загружаем пароли
      final loadedPasswords = await passwordInteractor.getByIds(folder.passwordsIds);
      print('🔑 Loaded ${loadedPasswords.length} passwords');

      // Сохраняем ВСЕ пароли пользователя в кэш
      await _cacheAllPasswordsForUser();

      setState(() {
        passwords = loadedPasswords;
        filteredPasswords = List.from(passwords);
        isLoading = false;
      });

    } catch (e) {
      print('❌ Error loading passwords: $e');
      // При ошибке пытаемся загрузить из кэша
      await _loadPasswordsForSelectedFolderFromCache();
    }
  }

  Future<void> _cacheAllPasswordsForUser() async {
    try {
      // Загружаем все пароли пользователя
      final allPasswords = await passwordInteractor.getAll(current_consumer.id!);
      print('💾 Caching ${allPasswords.length} passwords for user');

      // Конвертируем в Map для кэширования
      final passwordsData = allPasswords.map((password) => passwordTranslator.toDocument(password)).toList();

      // Сохраняем в кэш
      await LocalStorageService.cacheAllPasswords(passwordsData);

    } catch (e) {
      print('❌ Error caching passwords: $e');
    }
  }

  void _refreshData() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      _loadData();
    }
  }

  void _logout() async {
    await LocalStorageService.clearUserCredentials();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = ColorScheme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _showExitDialog(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 150,
        body: Column(
          children: [
            if (_showOfflineBanner)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Режим офлайн',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: FocusScope(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _refreshData();
                    }
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        surfaceTintColor: colorScheme.background,
                        title: Text(l10n!.appTitle),
                        centerTitle: true,
                        floating: true,
                        pinned: true,
                        snap: true,
                        automaticallyImplyLeading: false,
                        leading: isSearching
                            ? null
                            : IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(88),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              Sizes.spacingMd,
                              Sizes.spacingMd,
                              Sizes.spacingMd,
                              Sizes.spacingMd,
                            ),
                            child: TextFormField(
                              controller: searchController,
                              autofocus: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search_outlined),
                                hintText: l10n!.searchPasswords,
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: _clearSearch,
                                )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (isSearching && filteredPasswords.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  l10n.nothingFound,
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  l10n.tryDifferentQuery,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (isSearching)
                        _buildSearchResults()
                      else
                        _buildNormalContent(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: isSearching ? null : SpeedDial(
          useRotationAnimation: true,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spaceBetweenChildren: Sizes.spacingMd,
          childPadding: EdgeInsets.symmetric(vertical: 0),
          icon: Icons.add,
          activeIcon: Icons.close,
          activeBackgroundColor: colorScheme.background,
          activeForegroundColor: Colors.black,
          curve: Curves.bounceInOut,
          children: [
            SpeedDialChild(
                child: Icon(Icons.password_rounded),
                label: l10n.password,
                shape: StadiumBorder(),
                onTap: () {
                  if (selectedFolderId == null && folders.isNotEmpty) {
                    selectedFolderId = folders[0].id;
                  }
                  Navigator.push( context,
                      MaterialPageRoute(
                          builder: (context) => AddPasswordScreen(selectedFolderId: selectedFolderId)
                      )
                  ).then((_) {
                    _refreshData();
                  });
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.folder),
                label: l10n.categoryName,
                shape: StadiumBorder(),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddCategoryScreen(),
                    isScrollControlled: true,
                  ).then((value) {
                    if (value == true) {
                      _refreshData();
                    }
                  });
                }
            ),
          ],
        ),
        drawer: isSearching ? null : Drawer(
          backgroundColor: colorScheme.background,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/app_logo.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: Sizes.spacingMd),
                              Text(_truncateEmail(current_consumer.email!)),
                              SizedBox(height: Sizes.spacingSm),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: Sizes.spacingMd),
                              Consumer<ThemeProvider>(
                                builder: (context, themeProvider, child) {
                                  return IconButton(
                                    icon: Icon(
                                      themeProvider.themeMode == ThemeMode.dark
                                          ? Icons.light_mode_outlined
                                          : Icons.dark_mode_outlined,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      themeProvider.toggleTheme(themeProvider.themeMode != ThemeMode.dark);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
                ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text(l10n.settings),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SettingsScreen()
                      )).then((_) {
                        _refreshData();
                      });
                    }
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text(l10n.breachCheck),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BreachCheckScreen()
                    ));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.analytics_outlined),
                  title: Text('Аналитика паролей'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AnalyticsScreen()
                    ));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Выйти'),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalContent() {
    if (isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Загрузка данных...'),
            ],
          ),
        ),
      );
    }

    if (folders.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Нет папок',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Создайте папку для хранения паролей',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: Sizes.spacingMd),

        // Папки
        SizedBox(
          height: 30,
          child: ListView.builder(
            key: ValueKey(folders.length),
            itemCount: folders.length,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => CategoryCard(
              categoryName: folders[index].name,
              isSelected: selectedFolderId == folders[index].id,
              onTap: () {
                setState(() {
                  selectedFolderId = folders[index].id;
                  isLoading = true;
                });
                _loadPasswordsForSelectedFolder();
              },
              onDoubleTap: () async{
                await consumerInteractor.deleteFolder(folders[index], current_consumer);
                await folderInteractor.delete(folders[index]);
                _refreshData();
              },
            ),
          ),
        ),

        SizedBox(height: Sizes.spacingMd),

        // Пароли
        if (passwords.isEmpty)
          Container(
            padding: EdgeInsets.all(Sizes.spacingLg),
            child: Column(
              children: [
                Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет паролей в этой папке',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Добавьте первый пароль в эту папку',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...passwords.map((password) => Column(
            children: [
              ServiceCard(
                serviceName: password.serviceName.name,
                isFavorite: password.isFavourite,
                serviceIcon: Icons.lock_outline_rounded,
                password: password,
                onFavoriteIconTap: () async{
                  Folder? favouriteFolder = await folderRepository.getByName("Избранное", current_consumer);
                  setState(() {
                    password.isFavourite = !password.isFavourite;
                    passwordRepository.update(password);

                    if(password.isFavourite){
                      folderInteractor.addPasswordToFolder(favouriteFolder!.id, password);
                    }else{
                      folderInteractor.deletePasswordFromFolder(favouriteFolder!.id, password);
                    }
                  });
                },
                onPasswordDeleted: _refreshData,
              ),
              SizedBox(height: Sizes.spacingMd),
            ],
          )).toList(),
      ]),
    );
  }

  Widget _buildSearchResults() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => Column(
          children: [
            if (index == 0) SizedBox(height: Sizes.spacingLg),
            ServiceCard(
              serviceName: filteredPasswords[index].serviceName.name,
              isFavorite: filteredPasswords[index].isFavourite,
              serviceIcon: Icons.lock_outline_rounded,
              password: filteredPasswords[index],
              onFavoriteIconTap: () {
                setState(() {
                  filteredPasswords[index].isFavourite = !filteredPasswords[index].isFavourite;
                  passwordRepository.update(filteredPasswords[index]);
                });
              },
              onPasswordDeleted: _refreshData,
            ),
            if (index < filteredPasswords.length - 1)
              SizedBox(height: Sizes.spacingMd),
          ],
        ),
        childCount: filteredPasswords.length,
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выйти из приложения?'),
        content: Text('Вы уверены, что хотите выйти из приложения?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text('Выйти'),
          ),
        ],
      ),
    );
  }

  String _truncateEmail(String email) {
    if (email.length <= 20) {
      return email;
    }
    return '${email.substring(0, 20)}...';
  }
}