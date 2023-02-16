import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController t1 = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    t1.text = '+91';
    super.initState();
  }

  bool isLoading = false;

  sendOtp(String mobile) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mobile,
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        setState(() {
          isLoading = false;
        });
        getSnackbar(e.message.toString(), context);
      },
      codeSent: (String verificationId, int? resendToken) {
        pushNavigate(
            context,
            OTPScreen(
              mobileNum: mobile,
              varificationId: verificationId,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

// lets change disgn a bit
// missing plugin => restat app
// okay we will see the issue and resolve
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
                              // getBoldText('Chiggy Wiggy', MyColors.primaryColor, 25),

                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getBoldText(
                                        'Mobile number', Colors.black, 17),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.length != 13) {
                                            return 'Enter a valid phone number';
                                          }
                                          return null;
                                        },
                                        controller: t1,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(Icons.phone_android),
                                          enabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              getButton('Send OTP', MyColors.primaryColor, () {
                                if (_formKey.currentState!.validate()) {
                                  sendOtp(t1.text);
                                }
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
