import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';

class ImageMessage extends BaseMessage {
  String image;

  ImageMessage({int id, User from, DateTime date, this.image = ""})
      : super(id, from, date, MessageType.IMAGE);

  @override
  String getImage() => this.image;

  @override
  MessageItem toMessageItem() => MessageItem(
      id: this.id,
      isIncoming: true,
      date: this.date,
      isReaded: true,
      text: "\u{26F1} \u{1F307} Это изображение :)",
      messageType: this.messageType);
}
