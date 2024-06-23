import 'package:chatw8me/features/auth/data/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersScreen extends StatefulHookConsumerWidget {
  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title ?? ''),
                content: Text(notification.body ?? ''),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    final logout = ref.watch(logoutProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 14.h,
        title: Text('Welcome${user?.displayName},' ,style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: Wrap(
          children: [
            IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(Icons.logout_rounded)),
            Text('logout')
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              if (userId == user?.uid) return Container();

              return Card(
                elevation: 2,
                shadowColor: Colors.green,
                child: ListTile(
                  title: Text(userData['displayName']),
                  onTap: () async {
                    final chatRoom =
                        await ref.read(chatRoomProvider)(user!.uid, userId);
                    context.push('/chat/${chatRoom.id}/${user!.uid}/${userData['displayName']}');
                  },
                  subtitle: Text(
                    'online',
                    style: TextStyle(fontSize: 3.w, color: Colors.green),
                  ),
                  trailing: Card(
                    elevation: 4,
                    child: Container(
                      height: 4.w,
                      width: 4.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
