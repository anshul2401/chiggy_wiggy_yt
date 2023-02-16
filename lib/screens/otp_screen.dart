import 'package:chiggy_wiggy/admin/api/product_api.dart/user_api.dart';
import 'package:chiggy_wiggy/admin/screens/admin_home_page.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/user_model.dart';
import 'package:chiggy_wiggy/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNum, varificationId;
  const OTPScreen({
    super.key,
    required this.mobileNum,
    required this.varificationId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController t1 = TextEditingController();
  bool isLoading = false;
  setUser(var fetchUser) {
    print('hhh');
    setState(() {
      isLoading = false;
    });
    currentUser = fetchUser;
    currentUser!.role == 'Admin'
        ? pushAndRemoveNavigate(context, AdminHomePage())
        : pushAndRemoveNavigate(context, HomeScreen());
  }

  verifyOtp(String otp) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      isLoading = true;
    });
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.varificationId, smsCode: otp);

    var result = await auth.signInWithCredential(phoneAuthCredential);

    var fetchUser;
    fetchUser = await UserApi().getUser(result.user!.uid);
    fetchUser != null
        ? setUser(fetchUser)
        : UserApi()
            .addUser(
            UserModel(
                id: result.user!.uid,
                name: '',
                phoneNum: widget.mobileNum,
                address: [],
                favProduct: [],
                role: 'User'),
          )
            .then((value) {
            currentUser = UserModel(
                id: result.user!.uid,
                name: '',
                phoneNum: widget.mobileNum,
                address: [],
                favProduct: [],
                role: 'User');
            setState(() {
              isLoading = false;
            });
            currentUser!.role == 'Admin'
                ? pushAndRemoveNavigate(context, AdminHomePage())
                : pushAndRemoveNavigate(context, HomeScreen());
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            getSnackbar(e, context);
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  color: Colors.grey,
                                  blurRadius: 5),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: MediaQuery.of(context).size.width / 2,
                                  child:
                                      Image.asset('assets/images/logo3.jpeg')),
                              getBoldText(
                                  'An OTP has been sent to ${widget.mobileNum}',
                                  Colors.black,
                                  17),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  controller: t1,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.onetwothree),
                                    enabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              getButton('Login', MyColors.primaryColor, () {
                                verifyOtp(t1.text);
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
