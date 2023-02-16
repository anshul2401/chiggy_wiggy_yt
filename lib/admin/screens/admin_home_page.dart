import 'package:chiggy_wiggy/admin/screens/order_screen.dart';
import 'package:chiggy_wiggy/admin/screens/product_screen.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _page = 0;
  List<Widget> pages = [
    OrderScreen(),
    ProductScreen(),
  ];
  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar:
          BottomNavigationBar(onTap: onPageChange, currentIndex: _page, items: [
        BottomNavigationBarItem(
          label: 'Orders',
          icon: Icon(Icons.shopping_bag),
        ),
        BottomNavigationBarItem(
          label: 'Products',
          icon: Icon(Icons.onetwothree),
        )
      ]),
    );
  }
}
