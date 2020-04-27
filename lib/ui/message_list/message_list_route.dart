import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/message_list/message_list_item.dart';
import 'package:flutter/material.dart';

class MessageListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatItem chatItem = ModalRoute.of(context).settings.arguments as ChatItem;

    String titleSubscription;
    if (chatItem.isOnline) {
      titleSubscription = "В сети";
    } else {
      // TODO replace "chatItem.lastMessageDate" with "user.lastSeen"
      titleSubscription = "был: ${chatItem.lastMessageDate}";
    }

    AppBar _appBar = AppBar(
        titleSpacing: 0.0,
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            if (chatItem.avatar == "")
              CircleAvatar(
                radius: 22.0,
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
                child:
                    Text(chatItem.initials, style: TextStyle(fontSize: 16.0)),
              ),
            if (chatItem.avatar != "")
              CircleAvatar(
                backgroundColor: Colors.blue[300],
                radius: 22.0,
                // TODO catch loading error
                backgroundImage: NetworkImage(chatItem.avatar),
              ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    chatItem.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    titleSubscription,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ]),
        ),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (BuildContext context) {}),
        ]);

    Widget _body = SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.all(0),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) =>
                    MessageListItem(),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1)),
          ),
          Container(
            height: 48.0,
            color: Colors.white70,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.tag_faces),
                  onPressed: () {
                    print("emodzi pressed");
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Сообщение"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    print("emodzi pressed");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    print("emodzi pressed");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: _appBar,
      body: _body,
      /*Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // _appBar(),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    // Display your list,
                  ],
                  reverse: true,
                ),
              ),
              Text("smt"),
            ],
          ),
        ],
      ),*/
    );
  }
}
