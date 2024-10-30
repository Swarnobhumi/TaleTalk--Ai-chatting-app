import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taletalk/CustomClasses/MessageModel.dart';

class ChatService extends ChangeNotifier{

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

 static Future<void> sendMessage({required String receiverId, required String message}) async{

    MessageModel messageModel = MessageModel(
        senderId: _firebaseAuth.currentUser!.uid,
        senderEmail: _firebaseAuth.currentUser!.email!,
        recierId: receiverId,
        message: message,
        timestamp: Timestamp.now().toString(),
        isRead: false
    );

    List<String> ids1 = [_firebaseAuth.currentUser!.uid, receiverId];
    List<String> ids2 = [receiverId, _firebaseAuth.currentUser!.uid];
    ids1.sort(); // Sort alphabetically to ensure consistent chatRoomId
    ids2.sort(); // Sort alphabetically to ensure consistent chatRoomId
    String senderRoomId = ids1.join("_");
    String receiverRoomId = ids2.join("_");
    await _firebaseDatabase.ref("Chats").child(senderRoomId).push().set(messageModel.toMap());
  }


  // void _markMessageAsRead(String messageId) async {
  //   await _firebaseDatabase.ref("Chats").child('$chatRoomId/messages/$messageId').update({'isRead': true});
  // }

}