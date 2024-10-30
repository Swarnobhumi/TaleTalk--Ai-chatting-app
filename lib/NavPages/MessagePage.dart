import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomWidgets/MessageContactCards.dart';
import 'package:taletalk/NavPages/ContactPage.dart';

import '../CustomClasses/UserContactModel.dart';
import 'ChattingPage.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isExists = false;
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance;


  Widget buildContactCard(UserContactModel userContactModel, Contact contact) {
    String chatRoomId = [ _auth.currentUser!.uid, userContactModel.userId ].join("_");
    String reverseChatRoomId = [ userContactModel.userId, _auth.currentUser!.uid ].join("_");

    return StreamBuilder(
      stream: _database.ref("Chats/$chatRoomId").orderByKey().limitToLast(1).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> senderRoomSnapshot) {
        return StreamBuilder(
          stream: _database.ref("Chats/$reverseChatRoomId").orderByKey().limitToLast(1).onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> receiverRoomSnapshot) {
            String lastMessage = "No messages yet";
            String profilePic = "";

            if (senderRoomSnapshot.hasData && senderRoomSnapshot.data!.snapshot.value != null) {
              var messages = senderRoomSnapshot.data!.snapshot.value as Map<String, dynamic>;
              lastMessage = messages.values.first['message'];
              setState(() {
                isExists = true;
              });
            } else if (receiverRoomSnapshot.hasData && receiverRoomSnapshot.data!.snapshot.value != null) {
              var messages = receiverRoomSnapshot.data!.snapshot.value as Map<String, dynamic>;
              lastMessage = messages.values.first['message'];
              setState(() {
                isExists = true;
              });
            }else{
              isExists = false;
            }

            return MessageContactCards(
                profilePic: profilePic,
                name: contact.displayName,
                lastMessage: lastMessage,
                unreadMessages: "9",
                messageTime: "9:00"
            );
          },
        );
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<bool> checkIfUserIdExists(String userId) async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref("users/$userId");

    final snapshot = await userRef.get();

    if (snapshot.exists) {
      print("User ID exists in the database.");
      return true;
    } else {
      print("User ID does not exist in the database.");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
              child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: isExists
                  ? ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return MessageContactCards(
                          profilePic: "",
                          lastMessage: "Ki korcho babu ?",
                          messageTime: "8:00 AM",
                          name: "Soumyabrata Ghosh",
                          unreadMessages: "99",
                        );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Conversation", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 17)),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Add your friends relatives into icon", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16))),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactsPage(),));
                                },
                                icon: SvgPicture.asset(
                                    "assets/Svg/three_dot_svg.svg"))
                          ],
                        ),
                      ],
                    ),
            ),
          ))
        ],
      ),
    );
  }
}
