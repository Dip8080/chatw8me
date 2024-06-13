import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> users;

  ChatRoom({required this.id, required this.users});

  factory ChatRoom.fromDocument(DocumentSnapshot doc) {
    return ChatRoom(
      id: doc.id,
      users: List<String>.from(doc['users']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users,
    };
  }
}
