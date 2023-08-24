import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final String senderId;
  final String senderName; // New property to store the sender's name
  final Timestamp timestamp;

  Message({
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messenger'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // Return a loading indicator or an empty container while data is being fetched.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageContent = message['content'];
                  final messageSenderId = message['senderId'];
                  final messageSenderName = message['senderName'];
                  final messageTimestamp = message['timestamp'];
                  final messageWidget = _buildMessageBubble(
                    Message(
                      content: messageContent,
                      senderId: messageSenderId,
                      senderName: messageSenderName,
                      timestamp: messageTimestamp,
                    ),
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  reverse: true, // Show the latest messages at the bottom
                  children: messageWidgets,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.senderId == _auth.currentUser!.uid;
    final bubbleColor = isMe ? Colors.blue[400] : Colors.grey[200];
    final textColor = isMe ? Colors.white : Colors.black;
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final borderRadius = isMe
        ? BorderRadius.only(
      topLeft: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    )
        : BorderRadius.only(
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              message.content,
              style: TextStyle(color: textColor),
            ),
          ),
          SizedBox(height: 4),
          Text(
            message.senderName, // Show the sender's name directly
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _sendMessage();
            },
            child: Icon(Icons.send),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[400],
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final user = _auth.currentUser;
    if (user != null && _messageController.text.isNotEmpty) {
      final messageContent = _messageController.text.trim();
      final messageSenderId = user.uid;
      final messageTimestamp = Timestamp.now();

      // Get the current user's name from Firestore
      final userSnapshot = await _firestore.collection('users').doc(messageSenderId).get();
      final messageSenderName = userSnapshot.get('name'); // Use get() to retrieve the 'name' field

      await _firestore.collection('messages').add({
        'content': messageContent,
        'senderId': messageSenderId,
        'senderName': messageSenderName,
        'timestamp': messageTimestamp,
      });

      _messageController.clear();
    }
  }
}
