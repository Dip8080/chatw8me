
import 'package:chatw8me/features/auth/model/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final registrationProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = FirebaseFirestore.instance;
  return (String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'displayName': displayName,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred';
    }
  };
});

final loginProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return (String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred';
    }
  };
});

final logoutProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return () async {
    await firebaseAuth.signOut();
  };
});

final chatRoomProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  return (String userId, String peerId) async {
    QuerySnapshot query = await firestore
        .collection('chatRooms')
        .where('users', arrayContainsAny: [userId, peerId])
        .get();
    
    if (query.docs.isNotEmpty) {
      // Return existing chat room
      return ChatRoom.fromDocument(query.docs.first);
    } else {
      // Create new chat room
      DocumentReference docRef = await firestore.collection('chatRooms').add({
        'users': [userId, peerId],
      });
      return ChatRoom(id: docRef.id, users: [userId, peerId]);
    }
  };
});
