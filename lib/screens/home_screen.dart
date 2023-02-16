import 'package:chiggy_wiggy/admin/api/banner_api.dart';
import 'package:chiggy_wiggy/admin/screens/admin_home_page.dart';
import 'package:chiggy_wiggy/admin/screens/order_screen.dart';
import 'package:chiggy_wiggy/helper/carousel.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/screens/login_screen.dart';
import 'package:chiggy_wiggy/screens/orders_screen.dart';
import 'package:chiggy_wiggy/screens/product_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// this is our home screen widget and we have to build the drawer here
// thanks for watching
class _HomeScreenState extends State<HomeScreen> {
  String? bannerUrl;
  bool isLoading = false;
  callAPi() async {
    setState(() {
      isLoading = true;
    });
    bannerUrl = await BannerAPi().getBanner();
    setState(() {
      isLoading = false;
    });
    print(bannerUrl);
  }

  @override
  void initState() {
    callAPi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(currentUser);
    return isLoading
        ? getLoading()
        : Scaffold(
            appBar: getHomeScreenAppBar(context),
            drawer: Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20))),
                      height: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: getNormalText('Hello there', Colors.white, 16),
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  title: getNormalText('Home', Colors.black, 16),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Divider(),
                // ListTile(
                //   leading: Icon(
                //     Icons.home,
                //     color: Colors.grey,
                //   ),
                //   title: getNormalText('Admin', Colors.black, 16),
                //   onTap: () {
                //     pushNavigate(context, AdminHomePage());
                //   },
                // ),
                currentUser == null ? Container() : Divider(),
                currentUser == null
                    ? Container()
                    : ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        title: getNormalText('Orders', Colors.black, 16),
                        onTap: () {
                          pushNavigate(context, UserOrderScreen());
                        },
                      ),
                Divider(),
                FirebaseAuth.instance.currentUser == null
                    ? ListTile(
                        leading: Icon(
                          Icons.login,
                          color: Colors.grey,
                        ),
                        title: getNormalText('Login', Colors.black, 16),
                        onTap: () {
                          pushNavigate(context, LoginScreen());
                        },
                      )
                    : ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.grey,
                        ),
                        title: getNormalText('Logout', Colors.black, 16),
                        onTap: () {
                          currentUser = null;
                          FirebaseAuth.instance.signOut();
                          pushAndRemoveNavigate(context, HomeScreen());
                        },
                      ),
                Divider(),
              ],
            )),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTopSection(),
                  Carousel(),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: Image.network(
                      bannerUrl!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: getBoldText(
                      'Explore by categories',
                      Colors.black,
                      18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCatCard(
                              context,
                              'Chicken',
                              'assets/images/chicken.jpg',
                              () {
                                pushNavigate(
                                    context, ProductList(title: 'Chicken'));
                              },
                            ),
                            getCatCard(
                              context,
                              'Mutton',
                              'assets/images/mutton.jpg',
                              () {
                                pushNavigate(
                                    context, ProductList(title: 'Mutton'));
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCatCard(
                              context,
                              'Fish',
                              'assets/images/fish.jpeg',
                              () {
                                pushNavigate(
                                    context, ProductList(title: 'Fish'));
                              },
                            ),
                            getCatCard(
                              context,
                              'Eggs',
                              'assets/images/egg.jpg',
                              () {
                                pushNavigate(
                                    context, ProductList(title: 'Egg'));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: getBoldText(
                        'Popular from Chiggy Wiggy', Colors.black, 18),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
  }

  GestureDetector getCatCard(BuildContext context, String title, String imgUrl,
      VoidCallback voidCallback) {
    return GestureDetector(
      onTap: voidCallback,
      child: Column(
        children: [
          Container(
            width: getTotalWidth(context) / 2.3,
            height: getTotalWidth(context) / 2.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imgUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          getBoldText(title, Colors.black, 16),
        ],
      ),
    );
  }

  Row getTopSection() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                pushNavigate(context, ProductList(title: 'Chicken'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child:
                        Image.asset('assets/images/chicken_darkred_icon.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Chicken',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                pushNavigate(context, ProductList(title: 'Mutton'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/goat_darkred_icon.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Mutton',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                pushNavigate(context, ProductList(title: 'Fish'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/fish_darkred_icon.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Fish',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                pushNavigate(context, ProductList(title: 'Egg'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/egg_icon.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Egg',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
