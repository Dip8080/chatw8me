import 'package:chatw8me/features/auth/data/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context ) {
    final logout = ref.watch(logoutProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()async{
        await logout();
        context.go('/');
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Center(child: Text('this is chat screen'),),
    );
  }
}