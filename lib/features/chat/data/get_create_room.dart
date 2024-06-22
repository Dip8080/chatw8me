import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getChatRoomId(String userId1, String userId2) async {
  final firestore = FirebaseFirestore.instance;

  final querySnapshot = await firestore
      .collection('chatRooms')
      .where('users', arrayContains: userId1)
      .get();

  for (var doc in querySnapshot.docs) {
    List<dynamic> users = doc['users'];
    if (users.contains(userId2)) {
      return doc.id; // Return existing chat room ID
    }
  }

  // Create a new chat room
  final newChatRoom = await firestore.collection('chatRooms').add({
    'users': [userId1, userId2],
  });

  return newChatRoom.id; // Return new chat room ID
}
