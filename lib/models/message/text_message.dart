import 'package:fluchat/di/di_container.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';

class TextMessage extends BaseMessage {
  String text;
  final User currentUser =
      DiContainer.getRepository().getCurrentUser(); // TODO revove dependency

  TextMessage({int id, User from, DateTime date, this.text = ""})
      : super(id, from, date, MessageType.TEXT);

  @override
  String getText() => this.text;

  @override
  MessageItem toMessageItem() => MessageItem(
      id: this.id,
      isIncoming: from != currentUser,
      date: this.date,
      isReaded: true,
      text: this.getText(),
      messageType: this.messageType);
}
