import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Chat List Screen"),
        ),
        body: SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.all(0),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) => ChatListItem(),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0)
          ),
        ),
      );
}
