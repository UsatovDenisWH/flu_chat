import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IDataSource {
  List<Chat> loadChats({@required User currentUser});

  bool saveChats({@required List<Chat> chats});

  List<User> loadUsers();

  bool saveUser({@required User currentUser});
}
