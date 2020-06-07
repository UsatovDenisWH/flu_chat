import 'package:fluchat/blocs/message_list_bloc.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:flutter/material.dart';

class MessageListItem extends StatelessWidget {
  final MessageItem _messageItem;
  final MessageListBloc _bloc;

  MessageListItem(this._messageItem, this._bloc);

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

    if (_messageItem.messageType == MessageType.TEXT) {
      Widget textMessage = Padding(
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
      return textMessage;
    } else if (_messageItem.messageType == MessageType.IMAGE) {
      Widget imageMessage = Padding(
          padding: messagePadding,
          child: Container(
            height: 50.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Изображение: \u{26F1} \u{1F307}"),
          ));
      return imageMessage;
    } else if (_messageItem.messageType == MessageType.VIDEO) {
      Widget videoMessage = Padding(
          padding: messagePadding,
          child: Container(
            height: 50.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Видео: \u{9028} \u{1F3A5} \u{1F3AC}"),
          ));
      return videoMessage;
    }
  }
}
