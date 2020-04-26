import 'dart:math';

import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:flutter/material.dart';

class ChatListRoute extends StatelessWidget {
  // Generator of chat list items
  final List<ChatItem> _chatItems = List.generate(20, (int i) {
    i++;

    String _avatar;
    if (Random().nextInt(5) % 5 != 0) {
      _avatar = "https://picsum.photos/250?image=${i * Random().nextInt(33)}";
    } else {
      _avatar = "";
    }

    return ChatItem(
      id: "$i",
      avatar: _avatar,
      initials: "АК",
      title: "Андрюха Куролесов $i",
      shortDescription: "Привет! Как дела?",
      messageCount: i % 5 * Random().nextInt(100),
      lastMessageDate: "19:49",
      isOnline: Random().nextBool(),
      chatType: ChatType.SINGLE,
      author: "Гена Лодочкин",
    );
  });

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
