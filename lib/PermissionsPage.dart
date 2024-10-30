import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/SetUpPages/SetupPage.dart';

class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool isMessageSend= false;
  bool isCameraGranted = false;
  bool isContactsGranted = false;

  @override
void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TaleTalk',
          style:
              GoogleFonts.pacifico(textStyle: TextStyle(color: Colors.white)),
        ),
        backgroundColor: ColorCodes.blue1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We need your permission to continue',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: ColorCodes.blue1,
              ),
            ),
            SizedBox(height: 20),
            _buildPermissionItem(
              'Camera Access',
              'Allow access to capture photos',
              Icons.camera_alt,
              isCameraGranted,
              () => setState(() => isCameraGranted = !isCameraGranted),
            ),
            _buildPermissionItem(
              'Contacts Access',
              'Allow access to your contacts',
              Icons.contacts,
              isContactsGranted,
              () => setState(() => isContactsGranted = !isContactsGranted),
            ),
            _buildPermissionItem(
              'Message Send',
              'Allow access to send messages for OTP',
              Icons.sms,
              isContactsGranted,
              () => setState(() => isContactsGranted = !isContactsGranted),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorCodes.blue1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _requestPermissions,
                child: Text(
                  'Grant Permissions',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(String title, String description, IconData icon,
      bool isGranted, Function togglePermission) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: ColorCodes.blue1, size: 30),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(description, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          AbsorbPointer(
            absorbing: true,
            child: Switch(
              value: isGranted,
              onChanged: (value) => togglePermission(),
              activeColor: ColorCodes.blue1,
            ),
          ),
        ],
      ),
    );
  }

  void _requestPermissions() async {
    // Request Camera Permission
    if (!isCameraGranted) {
      PermissionStatus cameraStatus = await Permission.camera.request();
      setState(() {
        isCameraGranted = cameraStatus.isGranted;
      });
    }


    // Request Contacts Permission
    if (!isContactsGranted) {
      PermissionStatus contactsStatus = await Permission.contacts.request();
      setState(() {
        isContactsGranted = contactsStatus.isGranted;
      });
    }

    // Request SMS Permission (for sending messages)
    if (!isMessageSend) {
      PermissionStatus smsStatus = await Permission.sms.request();
      setState(() {
        isMessageSend = smsStatus.isGranted;
      });
    }

    // Optionally, you can check if all required permissions are granted
    if (isCameraGranted && isContactsGranted && isMessageSend) {
      print('All permissions granted');
      Timer(Duration(milliseconds: 500), () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SetUpPage(),));
      },);

      // Proceed with the app functionality
    } else {
      openAppSettings();
      // Optionally, show a dialog explaining why these permissions are required
    }
  }



}
