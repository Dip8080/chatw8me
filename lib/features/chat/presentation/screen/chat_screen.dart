import 'package:chatw8me/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Fetch chat messages based on chat room ID
final chatMessagesProvider =
    StreamProvider.family.autoDispose((ref, String chatRoomId) {
  return FirebaseFirestore.instance
      .collection('chatRooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();
});

class ChatScreen extends HookConsumerWidget {
  final String chatRoomId;
  final String currentUserId;
  final String otherUserId;

  ChatScreen({
    required this.chatRoomId,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final messages = ref.watch(chatMessagesProvider(chatRoomId));
    final messageController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        title: Stack(
          children: [
            Container(
              width: 100.w,
          
              child: Text('$otherUserId' , style: TextStyle(fontWeight: FontWeight.bold),)),
            Positioned(
              left: 15.w,
              bottom: 1.h,
              child: Container(
                width: 3.w,
                height: 3.h,
                child: CircleAvatar(
                  backgroundColor: AppColors.lightPrimary,
                ),
              ))
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              data: (snapshot) {
                final docs = snapshot.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final isMe = data['userId'] == user?.uid;
                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['message'],
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    final message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('chatRooms')
                          .doc(chatRoomId)
                          .collection('messages')
                          .add({
                        'userId': user?.uid,
                        'message': message,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
