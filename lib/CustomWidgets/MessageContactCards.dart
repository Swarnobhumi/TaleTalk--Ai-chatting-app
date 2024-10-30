import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CustomClasses/ColorCodes.dart';

class MessageContactCards extends StatelessWidget {
  String profilePic, name, lastMessage, unreadMessages, messageTime;


  MessageContactCards({super.key, required this.profilePic, required this.name, required this.lastMessage,
      required this.unreadMessages, required this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 9,
        child: Container(
          width: MediaQuery.of(context).size.width*0.9,
          height: 90,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
          ),
          child: Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width*0.03),

              // ProfilePic
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(profilePic),
              ),

              SizedBox(width: MediaQuery.of(context).size.width*0.04,),
              // UserName & Last Message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(name, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize:16)),),
                  Text(lastMessage, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize:16)),),
                ],
              ),

              // MessageDate & Unread Message Count
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(11),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: ColorCodes.blue1,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(child: Text(unreadMessages, style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(11),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(messageTime)),
                    )

                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
