import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/message_list/message_list_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../di_container.dart';

class ChatListItem extends StatelessWidget {
  final _injector = DiContainer().getInjector();
  final ChatItem _chatItem;

  ChatListItem(this._chatItem);

  @override
  Widget build(BuildContext context) {
    final Widget _avatar = Padding(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          if (_chatItem.avatar == null || _chatItem.avatar == "")
            CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.blue[300],
              foregroundColor: Colors.white,
              child: Text(_chatItem.initials, style: TextStyle(fontSize: 20.0)),
            ),
          if (_chatItem.avatar != null && _chatItem.avatar != "")
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

    final Text _header = Text(
      _chatItem.title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      overflow: TextOverflow.ellipsis,
    );

    final Text _lastMessage =
        Text(_chatItem.shortDescription, overflow: TextOverflow.ellipsis);
    final Text _lastMessageTime = Text(_chatItem.lastMessageDate);

    Widget _unreadMessageCount() {
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
              (_chatItem.messageCount > 9999)
                  ? "9999+"
                  : _chatItem.messageCount.toString(),
              style: TextStyle(color: Colors.white),
            ));
      } else {
        return SizedBox(height: 24.0);
      }
    }

    final Widget _textDivider = SizedBox(height: 8.0);

    assert(debugCheckHasMaterial(context));
    return Material(
      child: Container(
        height: 80.0,
        child: InkWell(
          highlightColor: Colors.blue,
          splashColor: Colors.blue,
          onTap: () {
            print("Chat item tapped");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _injector.get<MessageListRoute>(
                        additionalParameters: {"chatItem": _chatItem})));
//            Navigator.pushNamed(context, "/messageList", arguments: _chatItem);
          },
          child: Row(
            children: <Widget>[
              _avatar,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[_header, _textDivider, _lastMessage],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _lastMessageTime,
                    _textDivider,
                    _unreadMessageCount(),
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
