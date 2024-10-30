import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MessageDesign extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  const MessageDesign({Key? key, required this.chatId, required this.currentUserId}) : super(key: key);

  @override
  _MessageDesignState createState() => _MessageDesignState();
}

class _MessageDesignState extends State<MessageDesign> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],

    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder(
      stream: _messagesRef.child('chats/${widget.chatId}/messages').onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Retrieve messages from the snapshot and sort them by timestamp
        final messages = <Widget>[];
        final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          data.entries
              .map((entry) => entry.value)
              .toList()
              .sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp']));

          data.forEach((messageId, messageData) {
            final isRead = messageData['isRead'] as bool;
            final isSentByCurrentUser = messageData['senderId'] == widget.currentUserId;
            messages.add(_buildMessageBubble(
              messageData['messageText'] as String,
              isSentByCurrentUser,
              isRead: isSentByCurrentUser ? isRead : null,
            ));
          });
        }

        return ListView(children: messages);
      },
    );
  }

  Widget _buildMessageBubble(String message, bool isSentByCurrentUser, {bool? isRead}) {
    return Align(
      alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSentByCurrentUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            if (isSentByCurrentUser && isRead != null) ...[
              SizedBox(width: 5),
              Icon(
                isRead ? Icons.done_all : Icons.check,
                color: isRead ? Colors.blue : Colors.grey,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String messageText) async {
    final newMessageRef = _messagesRef.child('chats/${widget.chatId}/messages').push();

    final messageData = {
      'senderId': widget.currentUserId,
      'receiverId': "receiverIdHere",  // set receiverId here
      'messageText': messageText,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'isRead': false,
    };

    await newMessageRef.set(messageData);
  }

  void _markMessageAsRead(String messageId) async {
    await _messagesRef.child('chats/${widget.chatId}/messages/$messageId').update({'isRead': true});
  }
}
