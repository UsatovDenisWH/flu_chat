import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';

class ImageMessage extends BaseMessage {
  String image;

  ImageMessage(
      {int id, User from, DateTime date, this.image = ""})
      : super(id, from, date, MessageType.IMAGE);

  @override
  String getImage() => this.image;
}
