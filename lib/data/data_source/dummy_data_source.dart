import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';
import 'package:fluchat/utils/data_generator.dart';
import 'package:flutter/foundation.dart';

class DummyDataSource implements IDataSource {
  @override
  List<Chat> loadChats({@required User currentUser}) {
    return DataGenerator.getDemoChats(currentUser: currentUser);
  }

  @override
  List<User> loadUsers() {
    // TODO: implement loadUsers
    return null;
  }

  @override
  bool saveChats({@required List<Chat> chats}) {
    // TODO: implement saveChats
    return true;
  }

  @override
  bool saveUser({@required User currentUser}) {
    // TODO: implement saveUser
    return true;
  }
}
