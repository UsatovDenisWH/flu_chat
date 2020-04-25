import 'dart:math';

import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatListRoute extends StatelessWidget {
  final List<ChatItem> _chatItems = List.generate(20, (int i) {
    i++;
    return ChatItem(
      id: "$i",
      avatar: "https://picsum.photos/250?image=${i + 10}",
      initials: "АК",
      title: "Андрюха Куролесов $i",
      shortDescription: "Hi! Как дела?",
      messageCount: i % 5,
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
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          title: Text("Flu-chat"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                print("Button search pressed");
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
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
