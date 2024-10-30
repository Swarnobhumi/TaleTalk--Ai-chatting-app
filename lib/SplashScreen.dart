import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomClasses/StaticVariables.dart';
import 'package:taletalk/HomePage.dart';
import 'package:taletalk/WelcomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<bool> isDataAvailable()async{
    var box = await Hive.openBox("User");
    print("Data is: ${box.get("userInfo")}");
    if( await Hive.boxExists("User")){
      if(box.containsKey("userInfo") && box.get("userInfo")!=null){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () {
      isDataAvailable().then((value) {
        if(value){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
        }else{
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
        }
      },);
    },);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCodes.lightBlue,
      appBar: AppBar(
        backgroundColor: ColorCodes.lightBlue,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Column(
                    children: [
                       Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(80),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.4), // Shadow color with opacity
                               spreadRadius: 10,  // How far the shadow spreads
                               blurRadius: 20,   // The amount of blur
                               offset: Offset(0, 4),  // The offset of the shadow (x, y)
                             ),
                           ],
                         ),
                         child: Image.asset(
                          "assets/Icons/app_logo_remove_bg.png",
                           width: MediaQuery.of(context).size.width * 0.3,
                                       ),
                       ),
                      SizedBox(height: 10,),
                ],
              ))
            ],
          ),

         Positioned(
           left: 0,
           right: 0,
           bottom: MediaQuery.of(context).size.height*0.06,
              child: Column(
                children: [
                  Text("from", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14)),),
                  SizedBox(height:18,),
                  Image.asset("assets/Icons/company_logo.png", width: MediaQuery.of(context).size.width*0.22,),
                  Text("P.R.O.G", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 17)),),
                ],
              ))
        ],
      ),
    );
  }
}
