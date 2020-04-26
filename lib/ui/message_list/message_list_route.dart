import 'package:fluchat/models/chat_item.dart';
import 'package:flutter/material.dart';

class MessageListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatItem chatItem = ModalRoute.of(context).settings.arguments as ChatItem;

    String titleSubscription;
    if (chatItem.isOnline) {
      titleSubscription = "В сети";
    } else {
      // TODO change "chatItem.lastMessageDate" on "user.lastSeen"
      titleSubscription = "был: ${chatItem.lastMessageDate}";
    }

    return Scaffold(
      appBar: AppBar(
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
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
          ]),
      body: Stack(
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
      ),
    );
  }
}
