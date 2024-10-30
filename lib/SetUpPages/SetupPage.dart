import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomClasses/StaticVariables.dart';

import 'package:taletalk/SetUpPages/PhoneNumberPage.dart';
import 'package:taletalk/SetUpPages/UserAbout.dart';

class SetUpPage extends StatefulWidget {
  const SetUpPage({super.key});

  @override
  State<SetUpPage> createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  double step1 = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        step1 = 1;
      });
    },);
  }

  Stack blackAndWhiteLottie({required String path, required double width, required double height}){
    return Stack(
      alignment: Alignment.center,
      children: [
        // Add a container to ensure proper clipping and avoid extra rectangular shapes
        ClipOval(
          child: Container(
            color: Colors.grey,  // Optional background to ensure proper circular shape
            width: width,
            height: height,  // Ensure width and height are equal for a circular shape
          ),
        ),

        ClipOval(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Lottie.asset(
              animate: false,
             path,  // Your Lottie file
              width: width,
              height: height,  // Ensure it fits the circular shape
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorCodes.lightBlue,
      appBar: AppBar(
        backgroundColor: ColorCodes.blue1,
        title: Text("TaleTalk", style: GoogleFonts.pacifico(textStyle: const TextStyle(color: Colors.white)),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: StaticVariables.widget,
                  builder: (context, widget, child) {
                    return AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
                      child: widget,
                    );
                  },)
          ),

          //  Step Indicator
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                elevation: 9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Container(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [

                      ValueListenableBuilder(
                          valueListenable: StaticVariables.isStep1Complete,
                          builder: (context, isComplete, child) {
                           return  Lottie.asset(isComplete?"assets/Lottie/tick_lottie.json":"assets/Lottie/authentication_lottie.json", repeat: !isComplete,width: screenWidth*0.15);
                          },
                      ),

                     // First Step Indicator
                     ValueListenableBuilder(
                         valueListenable: StaticVariables.currentColor1,
                         builder: (context, currentColor, child) {
                           return  LinearPercentIndicator(
                             animation: true,
                             barRadius: const Radius.circular(80),
                             animationDuration: 2500,
                             linearStrokeCap: LinearStrokeCap.butt,
                             width: screenWidth*0.23,
                             lineHeight: 9.0,
                             percent: currentColor==Colors.green?1:0 ,
                             progressColor: Colors.green,
                             onAnimationEnd: () {
                               if (StaticVariables.isStep1Complete.value) {
                                 StaticVariables.isAnimationPlaying2.value = true;
                                 StaticVariables.widget.value = const PhoneNumberPage(); // Switch to PhoneNumberPage after animation
                               }
                             },
                           );
                         },),


                      ValueListenableBuilder(
                          valueListenable: StaticVariables.isAnimationPlaying2,
                          builder: (context, isAnimationPlaying, child) {
                            return ValueListenableBuilder(
                                valueListenable: StaticVariables.isStep2Complete,
                                builder: (context, isStepComplete, child) {
                                  return  isAnimationPlaying?  Lottie.asset(
                                    width: screenWidth*0.16,
                                      isStepComplete?"assets/Lottie/tick_lottie.json": "assets/Lottie/phone.json",
                                      animate: isAnimationPlaying,
                                    repeat: !isStepComplete
                                  ):blackAndWhiteLottie(path: "assets/Lottie/phone.json", width: screenWidth*0.15, height: screenHeight*0.07);
                                },
                            );
                          },
                      ),

                      // Second Step Indicator
                      ValueListenableBuilder(
                          valueListenable: StaticVariables.currentColor2,
                          builder: (context, currentColor, child) {
                            return LinearPercentIndicator(
                              barRadius: const Radius.circular(80),
                              animation: true,
                              animationDuration: 2500,
                              animateFromLastPercent: true,
                              linearStrokeCap: LinearStrokeCap.butt,
                              width: screenWidth*0.23,
                              lineHeight: 9.0,
                              percent: currentColor==Colors.green?1:0,
                              progressColor: Colors.green,
                              onAnimationEnd: () {
                                if (StaticVariables.isStep2Complete.value) {
                                  StaticVariables.isAnimationPlaying3.value = true;
                                  StaticVariables.widget.value =  UserInfoPage(); // Switch to AboutPage after animation
                                }
                              },
                            );
                          },
                      ),

                      ValueListenableBuilder(
                          valueListenable: StaticVariables.isAnimationPlaying3,
                          builder: (context, isAnimationPlaying, child) {
                            return ValueListenableBuilder(
                                valueListenable: StaticVariables.isStep3Complete,
                                builder:(context, isStepComplete, child) {
                                  return isAnimationPlaying?
                                  Lottie.asset(
                                  isStepComplete?"assets/Lottie/tick_lottie.json":
                                  "assets/Lottie/about_lottie.json", width: screenWidth*0.16,):
                                  blackAndWhiteLottie(path: "assets/Lottie/about_lottie.json", width: screenWidth*0.15, height: screenHeight*0.07);

                                }, );
                          },
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ) ,
    );
  }
}
