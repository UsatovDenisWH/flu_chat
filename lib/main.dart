import 'package:fluchat/ui/chat_list/chat_list_route.dart';
import 'package:fluchat/ui/message_list/message_list_route.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flu-chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/chatList",
        routes: {
          "/chatList": (context) => ChatListRoute(),
          "/messageList": (context) => MessageListRoute(),
        },
      );

}
