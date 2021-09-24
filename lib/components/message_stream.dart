import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class MassageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(
            'messages',
          )
          .orderBy(
            'timestamp',
            descending: false,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final _messages = snapshot.data.docs.reversed;
        List<MessageBubble> _messageBubbles = [];
        for (var message in _messages) {
          final _messageText = message['text'];
          final _messageSender = message['sender'];

          final _currentUser = loggedInUser.email;

          if (_currentUser == _messageSender) {
            //The massage from the logged in user.
          }

          final _messageBubble = MessageBubble(
            sender: _messageSender,
            text: _messageText,
            isMe: _currentUser == _messageSender,
          );
          _messageBubbles.add(_messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: _messageBubbles,
          ),
        );
      },
    );
  }
}
