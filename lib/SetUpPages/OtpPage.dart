import 'dart:async';

import 'package:another_telephony/telephony.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:taletalk/CustomClasses/StaticVariables.dart';
import 'package:taletalk/HomePage.dart';

import '../CustomWidgets/ShowSnackBar.dart';

class OtpPage extends StatefulWidget {
  late String? receivedOtp;




  OtpPage({super.key, required this.receivedOtp});



  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage>with CodeAutoFill {
  TextEditingController _textEditingController = TextEditingController();
  late bool isLock = true, isOtpCorrect = false;
  final Telephony telephony = Telephony.instance;
  double opacityBtnConfirm = 0;
  late String otp;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  listenForCode();
  }

  @override
  void codeUpdated() {
    setState(() {
      _textEditingController.text = code!;
    });
  }

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: MediaQuery.of(context).size.width*0.13,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(1, 20, 37, 1.0)),
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(191, 229, 246, 1.0),
      ),
    );


    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(0, 86, 131, 1.0)),
      borderRadius: BorderRadius.circular(8)
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(0, 86, 131, 1.0),
      ),
    );

    if(isOtpCorrect){
      Timer(Duration(milliseconds: 400), () {
        StaticVariables.isStep2Complete.value = true;
        StaticVariables.currentColor2.value = Colors.green;
      },);
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: isOtpCorrect?Lottie.asset("assets/Lottie/phone_link_success_lottie.json", repeat: false):AnimatedContainer(
        duration: Duration(milliseconds: 400),
        child: Column(
          children: [
            Lottie.asset(
              "assets/Lottie/authentication_lottie.json",
              width: MediaQuery.of(context).size.height*0.27,
              height:  MediaQuery.of(context).size.height*0.27
            ),
            Text("Verify Your Phone Number", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),),
            SizedBox(height: 10,),
            Text("We Have Send An OTP into XXXXXX${StaticVariables.phoneNumber.toString().substring(6)}", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),),
             SizedBox(height: 30,),
             Pinput(
               length: 6,
               defaultPinTheme: defaultPinTheme,
               focusedPinTheme: focusedPinTheme,
               submittedPinTheme: submittedPinTheme,
               controller: _textEditingController ,
               onCompleted: (pin) {
                 setState(() {
                   isLock = false;
                   opacityBtnConfirm = 1;
                   otp = pin;
                 });
               },
               onChanged: (pin) {
                 setState(() {
                   if(pin.length<6 && isLock ==false){
                      opacityBtnConfirm = 0;
                      isLock = true;
                   }
                 });

               },

             ),

            SizedBox(height: MediaQuery.of(context).size.height*0.04,),

            // btnConfirm
            AbsorbPointer(
              absorbing: isLock,
              child: Visibility(
                visible: opacityBtnConfirm==1?true:false,
                child: InkWell(
                  onTap: ()async{
                    print("Otp is ${widget.receivedOtp}");
                       if(otp==widget.receivedOtp) {
                         setState(() {
                           isOtpCorrect = true;
                         });




                       }else{
                         ShowSnackBar(title: "Error", message: "Please enter current otp.", contentType: ContentType.failure, buildContext: context);
                       }

                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xff005784),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Text("Confirm", style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

}
