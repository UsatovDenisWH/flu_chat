import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';

abstract class BaseMessage {
  final int id;
  final User from;
  final DateTime date;
  final MessageType messageType;

  BaseMessage(this.id, this.from, this.date, this.messageType);

  String getText() => null;

  String getImage() => null;

  String getInfoText() => null;

  MessageItem toMessageItem();
}

enum MessageType { TEXT, IMAGE , VIDEO }
