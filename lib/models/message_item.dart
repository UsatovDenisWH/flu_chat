import 'dart:core';

// item to display in the message list
class MessageItem {
  final String id;
//  final User from;
//  final Chat chat;
  final bool isIncoming;
  final DateTime date;
  final bool isReaded;
  final String text;
  final MessageType messageType;

  MessageItem({
    this.id,
//    this.from,
//    this.chat,
    this.isIncoming,
    this.date,
    this.isReaded,
    this.text,
    this.messageType,
  });
}

enum MessageType { TEXT, IMAGE, VIDEO }
