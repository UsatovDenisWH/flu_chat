import 'dart:async';

import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter/foundation.dart';

abstract class IRepository {
  IDataSource _dataSource;
  User _currentUser;
  String _currentChatId;
  List<Chat> _chats;
  List<User> _users;
  Future<bool> isInitialized;

  Sink<List<Chat>> _inListChats;
  Sink<List<User>> _inListUsers;
  Sink<List<BaseMessage>> _inListMessages;

  IRepository(
      {@required IDataSource dataSource,
      @required IStreamAssembly streamAssembly});

  Future<bool> initRepository();

  User getCurrentUser();

  void setCurrentUser({@required User user});

  Chat getChatById(String chatId);

  void addChat({@required Chat chat});

  void updateChat({@required Chat chat});

  void deleteChat({@required Chat chat});

  void setCurrentChat({@required String chatId});

  void addMessage({@required Chat chat, @required BaseMessage message});

  void updateMessage({@required Chat chat, @required BaseMessage message});

  void deleteMessage({@required Chat chat, @required BaseMessage message});

  void onChangeInDataSource(DataSourceEvent event);

  void retransmissionDataCache(DataCacheEvent event);

  void dispose();
}

enum DataCacheEvent { CHATS_REFRESH, USERS_REFRESH, MESSAGE_REFRESH }
