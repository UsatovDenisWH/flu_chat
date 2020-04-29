import 'dart:math';

import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:fluchat/utils/data_generator.dart';
import 'package:flutter/material.dart';

class ChatListRoute extends StatelessWidget {
  // Get chat items
  final List<ChatItem> _chatItems = DataGenerator.getDemoChatItems();


  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                print("Button menu tapped");
              },
            ),
          ),
          title: Text("Flu-chat"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                print("Button search tapped");
              },
            ),
          ],
        ),
        body: SafeArea(
          child: ListView.separated(
              padding: EdgeInsets.all(0),
              itemCount: _chatItems.length,
              itemBuilder: (BuildContext context, int index) =>
                  ChatListItem(_chatItems[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 0)),
        ),
      );
}
