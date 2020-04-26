import 'package:fluchat/models/chat_item.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
//  final String id;
//  final String avatar;
//  final String initials;
//  final String title;
//  final String shortDescription;
//  final int messageCount;
//  final String lastMessageDate;
//  final bool isOnline;
//  final ChatType chatType;
//  final String author;
  final ChatItem _chatItem;

  ChatListItem(this._chatItem);

  @override
  Widget build(BuildContext context) {
    final Widget avatar = Padding(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          if (_chatItem.avatar == "")
            CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.blue[300],
              foregroundColor: Colors.white,
              child: Text(_chatItem.initials, style: TextStyle(fontSize: 20.0)),
            ),
          if (_chatItem.avatar != "")
            CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.blue[300],
              // TODO catch loading error
              backgroundImage: NetworkImage(_chatItem.avatar),
            ),
          if (_chatItem.isOnline)
            CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 6.0,
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
    );

    final Text header = Text(
      _chatItem.title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
    );

    final Text lastMessage = Text(_chatItem.shortDescription);
    final Text lastMessageTime = Text(_chatItem.lastMessageDate);

    Widget unreadMessageCount() {
      if (_chatItem.messageCount > 0) {
        return Container(
            constraints: BoxConstraints(minWidth: 24.0),
            decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            padding: EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(
              _chatItem.messageCount.toString(),
              style: TextStyle(color: Colors.white),
            ));
      } else {
        return SizedBox(height: 24.0);
      }
    }

    final Widget textDivider = SizedBox(height: 8.0);

    assert(debugCheckHasMaterial(context));
    return Material(
      child: Container(
        height: 80.0,
        child: InkWell(
          highlightColor: Colors.blue,
          splashColor: Colors.blue,
          onTap: () {
            print("Chat item tapped");
            Navigator.pushNamed(context, "/messageList", arguments: _chatItem);
          },
          child: Row(
            children: <Widget>[
              avatar,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[header, textDivider, lastMessage],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    lastMessageTime,
                    textDivider,
                    unreadMessageCount(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
