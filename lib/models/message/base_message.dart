import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';

abstract class BaseMessage {
  final int id;
  final User from;
  final DateTime date;

  BaseMessage(this.id, this.from, this.date);

  String getText() => null;

  String getImage() => null;

  String getInfoText() => null;
}
