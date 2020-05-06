import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:flutter/material.dart';
import '../../di_container.dart';

// Widget class
class ChatListRoute extends StatefulWidget {
  final List<ChatItem> _chatItems;

  ChatListRoute(this._chatItems);

  @override
  State<StatefulWidget> createState() => _ChatListRouteState(_chatItems);
}

// State class
class _ChatListRouteState extends State<ChatListRoute> {
  List<ChatItem> _chatItems;

  _ChatListRouteState(this._chatItems);

  _refreshChatList() {
    setState(() {
      _chatItems = DiContainer().getInjector().get<List<ChatItem>>();
    });
  }

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
        floatingActionButton: FloatingActionButton(
          onPressed: _refreshChatList,
          child: Icon(Icons.refresh, size: 30.0),
          backgroundColor: Colors.blue,
        ),
      );
}
