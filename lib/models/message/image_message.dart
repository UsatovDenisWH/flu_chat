import 'package:fluchat/di/di_container.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';

class ImageMessage extends BaseMessage {
  String image;
  final User currentUser =
      DiContainer.getRepository().getCurrentUser(); // TODO revove dependency

  ImageMessage({int id, User from, DateTime date, this.image = ""})
      : super(id, from, date, MessageType.IMAGE);

  @override
  String getImage() => this.image;

  @override
  MessageItem toMessageItem() => MessageItem(
      id: this.id,
      isIncoming: from != currentUser,
      date: this.date,
      isReaded: true,
      image: this.image,
      messageType: this.messageType);
}
