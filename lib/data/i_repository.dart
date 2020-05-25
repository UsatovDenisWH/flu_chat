import 'dart:async';

import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IRepository {
  IDataSource _dataSource;
  User _currentUser;
  Chat _listenerChat;
  List<Chat> _chats;
  List<User> _users;
  Future<bool> isInitialized;

  final _listChats = StreamController<List<Chat>>.broadcast();
  final _listUsers = StreamController<List<User>>.broadcast();
  final _listMessages = StreamController<List<BaseMessage>>.broadcast();

  Sink<List<Chat>> get _inListChats => _listChats.sink;

  Stream<List<Chat>> get outListChats => _listChats.stream;

  Sink<List<User>> get _inListUsers => _listUsers.sink;

  Stream<List<User>> get outListUsers => _listUsers.stream;

  Sink<List<BaseMessage>> get _inListMessages => _listMessages.sink;

  Stream<List<BaseMessage>> get outListMessages => _listMessages.stream;

  Future<bool> initRepository();

  User getCurrentUser();

  void setCurrentUser({@required User user});

  Chat getChatById(String chatId);

  void addChat({@required Chat chat});

  void updateChat({@required Chat chat});

  void deleteChat({@required Chat chat});

  void setListenerChat({@required Chat chat});

  void addMessage({@required Chat chat, @required BaseMessage message});

  void updateMessage({@required Chat chat, @required BaseMessage message});

  void deleteMessage({@required Chat chat, @required BaseMessage message});

  void onChangeInDataSource(DataSourceEvent event);

  void dispose();
}
