import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';

class TextMessage extends BaseMessage {
  String text;

  TextMessage({int id, User from, DateTime date, this.text = ""})
      : super(id, from, date, MessageType.TEXT);

  @override
  String getText() => this.text;

  @override
  MessageItem toMessageItem() => MessageItem(
      id: this.id,
      isIncoming: true,
      date: this.date,
      isReaded: true,
      text: this.getText(),
      messageType: this.messageType);
}
