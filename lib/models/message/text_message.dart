import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';

class TextMessage extends BaseMessage {
  String text;

  TextMessage({int id, User from, DateTime date, this.text = ""})
      : super(id, from, date, MessageType.TEXT);

  @override
  String getText() => this.text;
}
