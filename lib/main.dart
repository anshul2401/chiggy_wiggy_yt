import 'dart:convert';

import 'package:chiggy_wiggy/admin/api/product_api.dart/user_api.dart';
import 'package:chiggy_wiggy/admin/screens/admin_home_page.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/user_model.dart';
import 'package:chiggy_wiggy/providers/cart_provider.dart';
import 'package:chiggy_wiggy/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My APp',
      theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Color.fromARGB(255, 251, 225, 227)),
      home: SplashScreen(),
    );
  }
}

// now, when user is logged in, we will check it as soon as app opens

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashTimer() async {
    final _auth = FirebaseAuth.instance.currentUser;

    if (_auth != null) {
      var user = await UserApi().getUser(_auth.uid);
      String userString = json.encode(user);

      UserModel userModel = UserModel.fromJson(jsonDecode(userString));
      currentUser = userModel;
    }

    Future.delayed(Duration(seconds: 2)).then((value) {
      currentUser == null
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()))
          : currentUser!.role == 'Admin'
              ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdminHomePage()))
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  void initState() {
    splashTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getTotalHeight(context),
      child: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
