import 'dart:core';

import 'package:fluchat/models/message/base_message.dart';

// item to display in the message list
class MessageItem {
  final int id;
//  final User from;
//  final Chat chat;
  final bool isIncoming;
  final DateTime date;
  final bool isReaded;
  final String text;
  final String image;
  final MessageType messageType;

  MessageItem({
    this.id,
//    this.from,
//    this.chat,
    this.isIncoming,
    this.date,
    this.isReaded,
    this.text,
    this.image,
    this.messageType,
  });
}


