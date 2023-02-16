import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/models/product_model.dart';
import 'package:chiggy_wiggy/providers/cart_provider.dart';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';

getTotalWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

getTotalHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// this is the app bar we used for the home screen

getHomeScreenAppBar(BuildContext context) {
  return AppBar(
    // leading: IconButton(
    //   icon: Icon(Icons.menu),
    //   onPressed: () {},
    // ),
    actions: [
      IconButton(
          onPressed: () {
            pushNavigate(context, CartScreen());
          },
          icon: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart),
              ),
              Provider.of<CartProvider>(context).totalCartItem() == 0
                  ? Container(
                      height: 0,
                    )
                  : Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: getNormalText(
                          Provider.of<CartProvider>(context)
                              .totalCartItem()
                              .toString(),
                          MyColors.primaryColor,
                          12),
                    ),
            ],
          ))
    ],
    toolbarHeight: 80,
    elevation: 0,
    title: Text('Chiggy Wiggy'),
    flexibleSpace: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          color: MyColors.primaryColor,
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 20,
        )
      ],
    ),
  );
}

getOtherScreenAppBar(String title, BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    elevation: 0,
    title: Text(title),
    flexibleSpace: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          color: MyColors.primaryColor,
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          height: 20,
        )
      ],
    ),
  );
}
// now we willl devide this page in tabs in three sections, pending, complete and cancelled

getBoldText(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color),
    textAlign: TextAlign.start,
  );
}

getNormalText(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size, color: color),
    textAlign: TextAlign.start,
  );
}

pushNavigate(BuildContext context, Widget widget) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

pushAndRemoveNavigate(BuildContext context, Widget widget) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: ((context) => widget)), (route) => false);
}

getButton(String text, Color color, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: getNormalText(text, Colors.white, 14)),
  );
}

Widget getLoading() {
  return Center(
    child: Container(
      width: 50,
      child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,

          /// Required, The loading type of the widget
          colors: const [Colors.red],

          /// Optional, The color collections
          strokeWidth: 2,

          /// Optional, The stroke of the line, only applicable to widget which contains line
          backgroundColor: Colors.transparent,

          /// Optional, Background of the widget
          pathBackgroundColor: Colors.black

          /// Optional, the stroke backgroundColor
          ),
    ),
  );
}

getSnackbar(String text, BuildContext context) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: getNormalText(text, Colors.white, 14)));
}
