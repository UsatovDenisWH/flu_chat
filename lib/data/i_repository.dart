import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IRepository {
  User _currentUser;
  IDataSource _dataSource;
  List<Chat> _chats;
  List<User> _users;

  Future<bool> initRepository();

  User getCurrentUser();

  setCurrentUser({@required User user});

  List<ChatItem> getChatItems();

  List<MessageItem> getMessageItems({@required Chat chat});
}
