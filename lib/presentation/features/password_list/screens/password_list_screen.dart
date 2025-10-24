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
import '../../../themes/sizes.dart';
import 'package:provider/provider.dart';
import 'package:brelock/presentation/theme_provider.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:brelock/presentation/features/breach_check/screens/breach_check_screen.dart';
import 'package:brelock/presentation/features/analytics/screens/analytics_screen.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  bool isSelected = false;
  bool isFavorite = false;
  List<Map<String, dynamic>> services = [];

  List<Folder> folders = [];
  List<Password> passwords = [];
  List<Password> filteredPasswords = [];
  bool isLoading = true;
  UuidValue? selectedFolderId;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadFolders();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() {});
    });

    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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

  Future<void> _loadFolders() async {
    try {
      final loadedFolders = await folderInteractor.getAll(current_consumer).timeout(Duration(seconds: 10));
      setState(() {
        folders = loadedFolders;
        selectedFolderId = folders[0].id;
        _loadPasswords(selectedFolderId!);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Ошибка загрузки папок: $e');
    }
  }

  Future<void> _loadPasswords(UuidValue selectedFolderId) async{
    final loadedPasswords = await passwordInteractor.getByIds((await folderInteractor.getById(selectedFolderId)).passwordsIds);
    Future.delayed(Duration(milliseconds: 700), (){
      if (mounted) {
        setState(() {
          passwords = loadedPasswords;
          filteredPasswords = List.from(passwords);
        });
      }
    });
  }

  void _refreshData() {
    if (mounted && selectedFolderId != null) {
      _loadPasswords(selectedFolderId!);
    }
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
        body: FocusScope(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                Future.delayed(Duration(milliseconds: 100), () {
                  _refreshData();
                });
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
                else if (!isSearching)
                  _buildNormalContent()
                else
                  _buildSearchResults(),
              ],
            ),
          ),
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
                  print("SECOND RULE OF FIGHT CLUB IS ${folders.length}");
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddCategoryScreen(),
                    isScrollControlled: true,
                  ).then((value) {
                    if (value == true) {
                      _loadFolders().then((_) {
                        setState(() {});
                      });
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
                              Text(_truncateEmail(current_consumer.email!))
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
                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant,
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
                  /*trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.safe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), */
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
                Divider(), // Добавить разделитель если нужно
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: Sizes.spacingMd),

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
                  if (selectedFolderId == folders[index].id) {
                  } else {
                    selectedFolderId = folders[index].id;
                    _loadPasswords(selectedFolderId!);
                  }
                });
              },
              onDoubleTap: () async{
                await consumerInteractor.deleteFolder(folders[index], current_consumer);
                await folderInteractor.delete(folders[index]);

                await _loadFolders();

                if (selectedFolderId == folders[index].id) {
                  if (folders.isNotEmpty) {
                    selectedFolderId = folders.first.id;
                    await _loadPasswords(selectedFolderId!);
                  } else {
                    selectedFolderId = null;
                    passwords.clear();
                    filteredPasswords.clear();
                  }
                }

                setState(() {});
              },
            ),
          ),
        ),

        SizedBox(height: Sizes.spacingMd),

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

  void _showExitDialog(BuildContext context) {}

  String _truncateEmail(String email) {
    if (email.length <= 20) {
      return email;
    }
    return '${email.substring(0, 20)}...';
  }
}