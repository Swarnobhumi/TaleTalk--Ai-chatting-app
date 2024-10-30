import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomClasses/StaticVariables.dart';
import 'package:taletalk/SetUpPages/PhoneNumberPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogin = false;
  bool isLoginBtnClicked = false;



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (isLogin) {
      Timer(
        Duration(milliseconds: 1200),
        () {
          StaticVariables.isStep1Complete.value = true;
          StaticVariables.currentColor1.value = Colors.green;
        },
      );
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isLogin
              ? Lottie.asset("assets/Lottie/email_login_succesful_lottie.json",
                  width: 300)
              : Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                              width: 70,
                              height: 70,
                              child: OverflowBox(
                                  maxWidth: screenWidth * 0.4,
                                  maxHeight: screenWidth * 0.4,
                                  child: Lottie.asset(
                                      "assets/Lottie/email_link_lottie.json",
                                      width: screenWidth * 1))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                              width: 70,
                              height: 70,
                              child: OverflowBox(
                                  maxWidth: screenWidth * 0.3,
                                  maxHeight: screenWidth * 0.3,
                                  child: Lottie.asset(
                                      "assets/Lottie/link_lottie.json",
                                      width: screenWidth * 1,
                                      repeat: false))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.4), // Shadow color with opacity
                                    spreadRadius:
                                        10, // How far the shadow spreads
                                    blurRadius: 20, // The amount of blur
                                    offset: Offset(0,
                                        4), // The offset of the shadow (x, y)
                                  ),
                                ]),
                            child: Image.asset(
                              "assets/Icons/app_logo_remove_bg.png",
                              width: screenWidth * 0.27,
                              height: screenWidth * 0.27,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    Text(
                      "Sign In With Your Account",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 20)),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    //Sign In Button
                    AbsorbPointer(
                      absorbing: isLoginBtnClicked,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            isLoginBtnClicked = true;
                          });
                          List<String> scopes = <String>[
                            'email',
                            'https://www.googleapis.com/auth/contacts.readonly',
                          ];

                          final GoogleSignIn _googleSignIn =
                              GoogleSignIn(scopes: scopes);
                          try {
                            final GoogleSignInAccount? googleUser =
                                await _googleSignIn.signIn();
                            final GoogleSignInAuthentication googleAuth =
                                await googleUser!.authentication;

                            final AuthCredential credential =
                                GoogleAuthProvider.credential(
                              accessToken: googleAuth.accessToken,
                              idToken: googleAuth.idToken,
                            );

                            final UserCredential userCredential =
                                await _auth.signInWithCredential(credential);
                            final User? user = userCredential.user;

                            setState(() {
                              if (user != null) {
                                StaticVariables.user = user;
                                isLogin = true;
                              }
                            });
                          } catch (e) {
                            setState(() {
                              isLoginBtnClicked = false;
                            });
                            print("Sign in error $e");
                          }
                        },

                        // Button Login
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            width: isLoginBtnClicked ? 60 : screenWidth * 0.7,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: ColorCodes.blue1),
                            child: isLoginBtnClicked

                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )

                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Sign In With Google",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17)),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
