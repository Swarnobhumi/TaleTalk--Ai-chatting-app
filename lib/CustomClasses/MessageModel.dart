import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  late final String senderId, senderEmail, recierId, message;
  late final String timestamp;
  late final bool isRead;

  MessageModel({required this.senderId, required this.senderEmail, required this.recierId, required this.message,
      required this.timestamp, required this.isRead});

  Map<String, dynamic> toMap(){
    return {
      'senderId':senderId,
      'senderEmail':senderEmail,
      'recierId':recierId,
      'message':message,
      'timestamp':timestamp,
      'isRead':isRead
    };
  }
}