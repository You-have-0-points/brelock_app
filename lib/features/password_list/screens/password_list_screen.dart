import 'package:brelock/features/add_items/add_category/screens/add_category_screen.dart';
import 'package:brelock/features/add_items/add_password/add_password_screen.dart';
import 'package:brelock/features/password_list/widget/category_card.dart';
import 'package:brelock/features/password_list/widget/service_card.dart';
import 'package:brelock/features/settings/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../themes/sizes.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {

  bool isSelected = false; //пример чисто для демонстрации, под списки надо будет менять
  bool isFavorite = false;

  //По хорошему тут у нас будет постоянно приходить инфа о том избранный ли сервис из бд через changenotifier
  //Хоть будет лето, всё что касается взаимодейтсвия ui и бд, можешь давать таски

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 150,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: colorScheme.background,
            title: Text("Brelock"),
            centerTitle: true,
            floating: true,
            pinned: true,
            snap: true,
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
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_outlined),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Sizes.spacingMd)),
          SliverToBoxAdapter(
              child: SizedBox(height: 30,
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                      CategoryCard(categoryName: "Папка", isSelected: isSelected, onTap: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                      }),
                    itemCount: 15
                ),
              )
          ),
          SliverToBoxAdapter(child: SizedBox(height: Sizes.spacingMd)),
          SliverList.separated(
            itemBuilder:
                (context, index) =>
                ServiceCard(
                    serviceName: "Google",
                    isFavorite: isFavorite,
                    serviceIconURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/225px-Google_%22G%22_logo.svg.png",
                    onFavoriteIconTap: () { setState(() {
                      isFavorite = !isFavorite;
                    });}
                ),
            separatorBuilder:
                (context, index) => SizedBox(height: Sizes.spacingMd),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
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
              label: "Пароль",
              shape: StadiumBorder(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddPasswordScreen()));
              }
          ),
          SpeedDialChild(
              child: Icon(Icons.folder),
              label: "Категория",
              shape: StadiumBorder(),
              //onTap: () {
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryScreen()));
              //}
              onTap: () {
                showModalBottomSheet(context: context, builder: (context) =>
                    AddCategoryScreen(),
                  isScrollControlled: true,
                );
              }
          ),
        ],
      ),
      drawer: Drawer(

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
                            Icon(Icons.account_circle_outlined, size: 80),
                            SizedBox(height: Sizes.spacingMd,),
                            Text("Example@gmail.com")
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: Sizes.spacingMd,),
                            Icon(Icons.light_mode_outlined, size: 32)
                          ],
                        ),
                      ],
                    ),
                    //decoration: BoxDecoration(color: Colors.green),
                  )
              ),
              ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text("Настройки"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SettingsScreen()));
                  }
              ),
              Divider(
                height: 1,
                color: colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
