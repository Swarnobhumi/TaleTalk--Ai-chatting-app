import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:taletalk/CustomClasses/ChatService.dart';
import 'package:taletalk/CustomClasses/ColorCodes.dart';
import 'package:taletalk/CustomClasses/UserContactModel.dart';
import 'package:taletalk/HomePage.dart';

class ChattingPage extends StatefulWidget {
  final UserContactModel userContactModel;
  final Contact contact;

  ChattingPage({required this.userContactModel, required this.contact, super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messagesList = [];
  late DatabaseReference senderRoomRef;
  late DatabaseReference receiverRoomRef;

  @override
  void initState() {
    super.initState();

    String senderRoom = "${_auth.currentUser!.uid}_${widget.userContactModel.userId}";
    String receiverRoom = "${widget.userContactModel.userId}_${_auth.currentUser!.uid}";

    senderRoomRef = _database.ref("Chats/$senderRoom");
    receiverRoomRef = _database.ref("Chats/$receiverRoom");

    // Animation controller setup
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.value = 0.0;
      }
    });

    // Load chat history and listen for new messages
    loadChatHistory();
    listenToChatUpdates();
  }

  void loadChatHistory() {
    String chatRoomId = [_auth.currentUser!.uid, widget.userContactModel.userId].join("_");
    String reverseChatRoomId = [widget.userContactModel.userId, _auth.currentUser!.uid].join("_");

    // Listen to the sender room
    senderRoomRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        // Safely handle the snapshot value
        Map<Object?, Object?> messageData = event.snapshot.value as Map<Object?, Object?>;

        // Convert it to Map<String, dynamic>
        Map<String, dynamic> convertedMessageData = messageData.map(
              (key, value) => MapEntry(key.toString(), value is Map ? Map<String, dynamic>.from(value) : value),
        );

        // Iterate through the converted message data
        convertedMessageData.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            addMessageToList(value); // Pass the value as Map<String, dynamic>
          }
        });
      }
    });

    // Listen to the receiver room as well
    receiverRoomRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<Object?, Object?> messageData = event.snapshot.value as Map<Object?, Object?>;

        Map<String, dynamic> convertedMessageData = messageData.map(
              (key, value) => MapEntry(key.toString(), value is Map ? Map<String, dynamic>.from(value) : value),
        );

        convertedMessageData.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            addMessageToList(value);
          }
        });
      }
    });
  }


  void addMessageToList(Map<String, dynamic> message) {
    // Check for duplicate messages based on a unique property (timestamp)
    if (!messagesList.any((msg) => msg['timestamp'] == message['timestamp'])) {
      setState(() {
        messagesList.insert(0, message); // Insert at the start for proper order
      });
    }
  }

  void listenToChatUpdates() {
    void handleNewMessage(DatabaseReference roomRef) {
      roomRef.onChildAdded.listen((event) {
        if (event.snapshot.value != null) {
          Map<String, dynamic> message = event.snapshot.value as Map<String, dynamic>;
          messagesList.add(message); // Add new message to the list

          // Sort messages by timestamp after adding a new message
          messagesList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

          // Update the state to refresh the UI
          setState(() {});
        }
      });
    }

    // Listen for new messages in both rooms
    handleNewMessage(senderRoomRef);
    handleNewMessage(receiverRoomRef);
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }

  // Message List
  Widget buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      itemCount: messagesList.length,
      itemBuilder: (context, index) {
        var message = messagesList[index];
        bool isMe = message['senderId'] == _auth.currentUser!.uid;
        return buildMessageBubble(message, isMe);
      },
    );
  }

  // Message Bubble
  Widget buildMessageBubble(Map message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['message'],
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // Message Input Field and Send Button
  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      String messageText = messageController.text.trim();
      messageController.clear();

      Map<String, dynamic> message = {
        'senderId': _auth.currentUser!.uid,
        'message': messageText,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Push to Firebase
      senderRoomRef.push().set(message);

      // Directly add to local messages list
      // Avoiding any duplicate check since it’s a new message
      setState(() {
        messagesList.insert(0, message);
      });

      _controller.forward(from: 0.0);

      // Scroll to the newest message
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top menu bar
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.keyboard_arrow_left, color: ColorCodes.blue1),
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(widget.userContactModel.profilePic),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        truncateWithEllipsis(20, widget.contact.displayName),
                        style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                      IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset("assets/Svg/three_dot_svg.svg")),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ColorCodes.lightBlue,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: buildMessagesList(),
            ),
          ),

          // Message Input and Send Button
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: ColorCodes.blue1,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(30)),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter message',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: sendMessage,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Lottie.asset(
                          "assets/Lottie/message_send_lottie.json",
                          width: MediaQuery.of(context).size.width * 0.14,
                          animate: false,
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller.duration = composition.duration;
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
