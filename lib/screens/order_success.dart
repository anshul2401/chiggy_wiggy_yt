import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/screens/home_screen.dart';
import 'package:flutter/material.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({super.key});

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  // now we will go to home page on back press
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pushAndRemoveNavigate(context, HomeScreen());
        return Future.delayed(Duration(seconds: 0));
      },
      child: Scaffold(
        bottomSheet: Container(
          height: 50,
          child: GestureDetector(
            onTap: () {
              pushAndRemoveNavigate(context, HomeScreen());
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: getBoldText('HOME', Colors.white, 15),
            ),
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 120,
            ),
            SizedBox(
              height: 20,
            ),
            getBoldText('Order Placed', Colors.black, 24)
          ],
        )),
      ),
    );
  }
}
