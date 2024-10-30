import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletalk/SetUpPages/LoginPage.dart';

class StaticVariables{
  static ValueNotifier<Color> currentColor1 = ValueNotifier<Color>(Colors.grey);
  static ValueNotifier<bool> isAnimationPlaying1 = ValueNotifier<bool>(true);

  static ValueNotifier<Color> currentColor2 = ValueNotifier<Color>(Colors.grey);
  static ValueNotifier<bool> isAnimationPlaying2 = ValueNotifier<bool>(false);

  static ValueNotifier<bool> isAnimationPlaying3 = ValueNotifier<bool>(false);

  static ValueNotifier<bool> isStep1Complete = ValueNotifier<bool>(false);
  static ValueNotifier<bool> isStep2Complete = ValueNotifier<bool>(false);
  static ValueNotifier<bool> isStep3Complete = ValueNotifier<bool>(false);

  static ValueNotifier<Widget> widget = ValueNotifier<Widget>(const LoginPage());
  static int phoneNumber = 8905568478;
  static String otp = "";
  static String verificationId = "";
  static late User user;

  static ValueNotifier<String> title = ValueNotifier<String>("TaleTalk");


  static void setColor1(Color newColor) {
    currentColor1.value = newColor;
  }

  static void startAnimation1() {
    isAnimationPlaying1.value = true;
  }

  static void stopAnimation1() {
    isAnimationPlaying1.value = false;
  }

  static void setColor2(Color newColor) {
    currentColor2.value = newColor;
  }

  static void startAnimation2() {
    isAnimationPlaying2.value = true;
  }

  static void stopAnimation2() {
    isAnimationPlaying2.value = false;
  }

  static void startAnimation3() {
    isAnimationPlaying3.value = true;
  }

  static void stopAnimation3() {
    isAnimationPlaying3.value = false;
  }
}