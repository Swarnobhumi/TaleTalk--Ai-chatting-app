import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomClasses/StaticVariables.dart';
import 'package:taletalk/CustomClasses/UserDataModel.dart';
import 'package:taletalk/CustomWidgets/ShowSnackBar.dart';
import 'package:taletalk/HomePage.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  final shake1= GlobalKey<ShakeWidgetState>();
  final shake2= GlobalKey<ShakeWidgetState>();
  final shake3= GlobalKey<ShakeWidgetState>();
  final shake4= GlobalKey<ShakeWidgetState>();
  bool isSubmitBtnClicked = false;
  String  lottiePath = "assets/Lottie/data_entry_lottie.json";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _nameController.text = StaticVariables.user.displayName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isSubmitBtnClicked){
      Timer(Duration(seconds: 2), () {
        setState(() {
          lottiePath = "assets/Lottie/phone_link_success_lottie.json";
        });
      },);
      Timer(Duration(milliseconds: 200), () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
      },);
    }

    return Scaffold(
      backgroundColor: ColorCodes.lightBlue,

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: isSubmitBtnClicked?Center(child: Lottie.asset(lottiePath, repeat: false, width: MediaQuery.of(context).size.width*1)):Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Icon
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(StaticVariables.user.photoURL!),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: ColorCodes.blue1),
                              child: Icon(Icons.edit, color: Colors.white, size: 18,)),
                          onPressed: () {
                            // Add functionality to select new image
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Name Input
                ShakeMe(
                  key: shake1,
                  shakeCount: 3,
                  shakeOffset: 10,
                  shakeDuration: Duration(milliseconds: 500),

                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Gender Selection
                ShakeMe(
                  key: shake2,
                  shakeCount: 3,
                  shakeOffset: 10,
                  shakeDuration: Duration(milliseconds: 500),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    value: _selectedGender,
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Date of Birth Picker
                ShakeMe(
                  key: shake3,
                  shakeCount: 3,
                  shakeOffset: 10,
                  shakeDuration: Duration(milliseconds: 500),
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: _selectedDate == null
                            ? ''
                            : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'),
                  ),
                ),
                SizedBox(height: 20),

                // About Input
                ShakeMe(
                  key: shake4,
                  shakeCount: 3,
                  shakeOffset: 10,
                  shakeDuration: Duration(milliseconds: 500),
                  child: TextFormField(
                    controller: _aboutController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'About',
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async{

                       if(_nameController.text.isEmpty){
                           shake1.currentState?.shake();
                       }if(_selectedGender == null || _selectedGender!.isEmpty){
                         shake2.currentState?.shake();
                       }if(_selectedDate==null || _selectedDate!.year>2009){

                         shake3.currentState?.shake();
                       } if(_aboutController.text.isEmpty){
                      shake4.currentState?.shake();
                       }

                       if(_nameController.text.isNotEmpty && _selectedGender!.isNotEmpty && _selectedDate!=null && _aboutController.text.isNotEmpty){
                         setState(() {
                           isSubmitBtnClicked = true;
                         });

                         UserDataModel userDataModel = UserDataModel(
                             name: _nameController.text,
                             gender: _selectedGender!,
                             date_of_birth: _selectedDate.toString(),
                             about: _aboutController.text,
                             email: StaticVariables.user.email!,
                             profilePic: StaticVariables.user.photoURL!,
                             phoneNumber: StaticVariables.phoneNumber,
                             userId: FirebaseAuth.instance.currentUser!.uid,
                         );

                         try {
                           FirebaseFirestore firestore = FirebaseFirestore
                               .instance;
                           CollectionReference users = firestore.collection(
                               'users');

                           users.add(userDataModel.toMap()).then((value) {
                             print("Data Added");
                           },
                               onError: () {
                                 print("error");
                               }
                           );
                         }catch (error){
                           print("Data Not Added $error");
                         }

                         // Hive storage
                         try {
                           var box = await Hive.openBox("User");
                           await box.put("userInfo", userDataModel.toMap());
                           print("Data Add ${box.get("userInfo")}");
                         } catch (error) {
                           print("Hive Error: $error");
                         }


                       }

                    },
                    icon: Icon(Icons.save, color: Colors.white,),
                    label: Text('Submit', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorCodes.blue1,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
