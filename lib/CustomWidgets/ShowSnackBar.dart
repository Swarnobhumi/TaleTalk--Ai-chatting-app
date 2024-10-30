import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowSnackBar{
   late final BuildContext buildContext;
  late final String title;
  late final String message;
  late final ContentType contentType;

  ShowSnackBar({required  this.buildContext, required this.title, required this.message, required this.contentType}){
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 30,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 1),

      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        messageTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15)),
      ),
    );

    ScaffoldMessenger.of(buildContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
  }

