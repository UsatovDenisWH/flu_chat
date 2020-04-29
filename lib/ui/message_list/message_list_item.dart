import 'package:fluchat/models/message_item.dart';
import 'package:flutter/material.dart';

class MessageListItem extends StatelessWidget {
//  final String id;
////  final User from;
////  final Chat chat;
//  final bool isIncoming;
//  final DateTime date;
//  final bool isReaded;
//  final String text;
//  final MessageType messageType;

  final MessageItem _messageItem;

  MessageListItem(this._messageItem);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    EdgeInsetsGeometry messagePadding;

    if (_messageItem.isIncoming) {
      bgColor = Colors.white;
      messagePadding = EdgeInsets.fromLTRB(8.0, 8.0, 48.0, 8.0);
    } else {
      bgColor = Colors.greenAccent[100];
      messagePadding = EdgeInsets.fromLTRB(48.0, 8.0, 8.0, 8.0);
    }

    Widget textBox = Padding(
        padding: messagePadding,
        child: Container(
          height: 50.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(_messageItem.text),
        ));

    return textBox;
  }
}
