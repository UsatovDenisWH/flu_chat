import 'package:fluchat/models/message_item.dart';
import 'package:flutter/material.dart';

class MessageListItem extends StatelessWidget {
  final MessageItem _messageItem;

  MessageListItem(this._messageItem);

  @override
  Widget build(BuildContext context) {
    Color _bgColor;
    EdgeInsetsGeometry _messagePadding;

    if (_messageItem.isIncoming) {
      _bgColor = Colors.white;
      _messagePadding = EdgeInsets.fromLTRB(8.0, 8.0, 48.0, 8.0);
    } else {
      _bgColor = Colors.greenAccent[100];
      _messagePadding = EdgeInsets.fromLTRB(48.0, 8.0, 8.0, 8.0);
    }

    Widget _messageContainer = Padding(
        padding: _messagePadding,
        child: Container(
          height: 50.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(_messageItem.text),
        ));

    return _messageContainer;
  }
}
