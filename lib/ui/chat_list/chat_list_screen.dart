import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:flutter/material.dart';

// Widget class
class ChatListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatListScreenState();
}

// State class
class _ChatListScreenState extends State<ChatListScreen> {
  ChatListBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of(context);
  }

  _refreshChatList() {
    setState(() {
//      _chatItems = DiContainer().getInjector().get<List<ChatItem>>();
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
            child: StreamBuilder(
          stream: _bloc.outChatItems,
          builder:
              (BuildContext context, AsyncSnapshot<List<ChatItem>> snapshot) {
            if (snapshot.data.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ChatListItem(snapshot.data[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 0));
            }
          },
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: _refreshChatList,
          child: Icon(Icons.refresh, size: 30.0),
          backgroundColor: Colors.blue,
        ),
      );
}
