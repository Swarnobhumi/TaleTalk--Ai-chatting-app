import 'dart:async';
import 'dart:math';

import 'package:another_telephony/telephony.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:taletalk/CustomWidgets/SNumPadButton.dart';

import '../CustomClasses/ColorCodes.dart';
import '../CustomClasses/StaticVariables.dart';
import '../CustomWidgets/ShowSnackBar.dart';
import '../HomePage.dart';
import 'OtpPage.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  Color color = Colors.white;
  double opacity = 0, opacity1 = 1, opacity2 = 0;
  bool userCanModify = true;

  final TextEditingController _textEditingController = TextEditingController();
  ValueNotifier<int> number = ValueNotifier<int>(0);



  bool lockNumButton = false, lockBtnConfirm = true;

  bool isSelect1 = false,
      isSelect2 = false,
      isSelect3 = false,
      isSelect4 = false,
      isSelect5 = false,
      isSelect6 = false,
      isSelect7 = false,
      isSelect8 = false,
      isSelect9 = false,
      isSelect0 = false;

  setUnSelectButton() {
    setState(() {
      isSelect1 = false;
      isSelect2 = false;
      isSelect3 = false;
      isSelect4 = false;
      isSelect5 = false;
      isSelect6 = false;
      isSelect7 = false;
      isSelect8 = false;
      isSelect9 = false;
      isSelect0 = false;
    });
  }

  final Telephony telephony = Telephony.instance;
  Future<void> sendSms(String message, String recipient) async {

    telephony.sendSms(
      to: recipient,
      message: message,
    );

  }

  String generateRandomCode() {
    final Random random = Random();
    int randomNumber = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
    return randomNumber.toString();
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      // Query Firestore collection to find the document with the specified email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .where('email', isEqualTo: email)
          .get();

      // Check if any documents were returned
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  Future<bool> isMobileRegistered(String mobile) async {
    try {
      // Query Firestore collection to find the document with the specified email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .where('phoneNumber', isEqualTo: int.parse(mobile))
          .get();

      // Check if any documents were returned
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 600), () {
      setState(() {
        color = ColorCodes.lightBlue;
        opacity = 1.0;
      });
    });

    number.addListener(() {
      _textEditingController.text = number.value == 0 ? '' : number.value.toString();
      if (number.value.toString().length == 10) {
        setState(() {
          opacity1 = 0;
          lockNumButton = true;
          opacity2 = 1;
          lockBtnConfirm = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = number.value == 0 ? '' : number.value.toString();

    return PopScope(
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
          body: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            color: color,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Company Logo
                    Align(
                      alignment: Alignment.topLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child:   Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(StaticVariables.user?.photoURL ?? ''),
                            radius: 45,
                          ),
                        ),
                      ),
                    ),

                    // Link Logo
                    Lottie.asset("assets/Lottie/link_lottie.json",
                        repeat: false,
                        animate: true,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2),

                    // Call Logo
                    Align(
                        alignment: Alignment.topRight,
                        child: Lottie.asset("assets/Lottie/phone.json",
                            repeat: true,
                            animate: true,
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3)),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),

                // Enter your number
                AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 600),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Enter Your Phone Number",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: ColorCodes.blue1,
                                fontWeight: FontWeight.w500)),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),

                // Phone number field
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                    ),
                    Icon(FontAwesomeIcons.phone, color: ColorCodes.blue1,),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.68,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 2, color: ColorCodes.blue1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          readOnly: true,
                          controller: _textEditingController,
                          style: GoogleFonts.poppins(
                            textStyle:
                            TextStyle(letterSpacing: 3, fontSize: 20),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          onTapOutside: (event) {
                            if (number.value.toString().length == 10) {
                              setState(() {
                                opacity1 = 0;
                              });
                            }
                          },
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 25,
                ),

                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: number.value.toString().length == 10
                      ? AnimatedOpacity(
                    opacity: opacity2,
                    duration: Duration(milliseconds: 400),
                    child: AbsorbPointer(
                      absorbing: lockBtnConfirm,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button Confirm
                          AnimatedButton(
                              width: 150,
                              height: 50,
                              text: "Confirm",
                              selectedBackgroundColor: ColorCodes.blue1,
                              selectedTextColor: Colors.white,
                              selectedText: "Welcome",
                              textStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: ColorCodes.blue1,
                                      fontSize: 18)),
                              backgroundColor: ColorCodes.lightBlue,
                              borderColor: ColorCodes.blue1,
                              borderWidth: 2,
                              borderRadius: 30,
                              onPress: () {
                                Timer(Duration(milliseconds: 500), () async {
                                  isEmailRegistered(StaticVariables.user.email!).then((isEmail) {
                                    isMobileRegistered(_textEditingController.text.toString()).then((isMobile) {
                                      if(isEmail && isMobile){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));

                                      }else if(isMobile &&  !isEmail){
                                        ShowSnackBar(title: "Error" ,
                                            message: "This Mobile number belongs to another mail, please login at that email",
                                            contentType: ContentType.failure,
                                            buildContext: context);
                                      }else if(!isMobile &&  isEmail){
                                        ShowSnackBar(title: "Error" ,
                                            message: "Your account does not have this mobile number.",
                                            contentType: ContentType.failure,
                                            buildContext: context);
                                      }else{
                                        SmsAutoFill().getAppSignature.then((value) {
                                          String code = generateRandomCode();
                                          sendSms(
                                              "<#> Your Login Code Is ${code} for TaleTalk App. Thank you for using and Do not share it anyone ${value}",
                                              "+91${_textEditingController.text}");

                                          StaticVariables.widget.value = OtpPage(receivedOtp: code,);
                                          StaticVariables.phoneNumber = int.parse(_textEditingController.text);
                                        },);
                                      }
                                    },);

                                  },);


                                });

                              }),

                          SizedBox(
                            width: 20,
                          ),

                          // Edit Button
                          InkWell(
                            key: ValueKey(1),
                            onTap: () {
                              setState(() {
                                // Clear the number and allow user to edit
                                setUnSelectButton();
                                number.value = 0;
                                lockNumButton = false;
                                lockBtnConfirm = true;
                                opacity1 = 1;
                                opacity2 = 0;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorCodes.blue1,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                      : // Number Pad
                  AnimatedOpacity(
                    key: ValueKey(2),
                    opacity: opacity1,
                    duration: Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 1,
                              isSelect: isSelect1,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect1 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 1
                                        : int.tryParse(
                                        number.value.toString() +
                                            1.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 2,
                              isSelect: isSelect2,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect2 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 2
                                        : int.tryParse(
                                        number.value.toString() +
                                            2.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 3,
                              isSelect: isSelect3,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect3 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 3
                                        : int.tryParse(
                                        number.value.toString() +
                                            3.toString()))!;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 4,
                              isSelect: isSelect4,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect4 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 4
                                        : int.tryParse(
                                        number.value.toString() +
                                            4.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 5,
                              isSelect: isSelect5,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect5 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 5
                                        : int.tryParse(
                                        number.value.toString() +
                                            5.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 6,
                              isSelect: isSelect6,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect6 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 6
                                        : int.tryParse(
                                        number.value.toString() +
                                            6.toString()))!;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 7,
                              isSelect: isSelect7,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect7 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 7
                                        : int.tryParse(
                                        number.value.toString() +
                                            7.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 8,
                              isSelect: isSelect8,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect8 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 8
                                        : int.tryParse(
                                        number.value.toString() +
                                            8.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 9,
                              isSelect: isSelect9,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect9 = true;
                                  if (number.value
                                      .toString()
                                      .length < 10 &&
                                      userCanModify) {
                                    number.value = (number.value == 0
                                        ? 9
                                        : int.tryParse(
                                        number.value.toString() +
                                            9.toString()))!;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SNumPadButton(
                              lockButton: lockNumButton,
                              digit: 0,
                              isSelect: isSelect0,
                              voidCallback: () {
                                setState(() {
                                  setUnSelectButton();
                                  isSelect0 = true;
                                  if (number.value  .toString().length < 10 && userCanModify) {
                                    number.value = (number.value == 0
                                        ? 0
                                        : int.tryParse(
                                        number.value.toString() +
                                            0.toString()))!;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.height*0.08,
                              height: MediaQuery.of(context).size.height*0.08,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    setUnSelectButton();
                                    String currentValue = number.value.toString();
                                    if (currentValue.isNotEmpty) {
                                      if (currentValue.length == 1) {
                                        number.value = 0;
                                      } else {
                                        number.value = int.parse(currentValue.substring(0, currentValue.length - 1));
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.backspace,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
