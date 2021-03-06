import 'dart:async';

import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository implements IRepository {
  IDataSource _dataSource;
  User _currentUser;
  String _currentChatId;
  List<Chat> _chats;
  List<User> _users;
  Future<bool> isInitialized;

  Sink<List<Chat>> _inListChats;
  Sink<List<User>> _inListUsers;
  Sink<List<BaseMessage>> _inListMessages;

  final _log = FimberLog("FLU_CHAT");
  final _CURRENT_USER_ID = "CURRENT_USER_ID";
  final _CURRENT_USER_FIRST_NAME = "CURRENT_USER_FIRST_NAME";
  final _CURRENT_USER_LAST_NAME = "CURRENT_USER_LAST_NAME";
  final _CURRENT_USER_AVATAR = "CURRENT_USER_AVATAR";

  Repository(
      {@required IDataSource dataSource,
      @required IStreamAssembly streamAssembly}) {
    _dataSource = dataSource;
    streamAssembly.changeInDataSource.listen(onChangeInDataSource);
    this._inListChats = streamAssembly.listChats.sink;
    this._inListUsers = streamAssembly.listUsers.sink;
    this._inListMessages = streamAssembly.listMessages.sink;
    isInitialized = initRepository();
    _log.d("Repository create");
  }

  @override
  Future<bool> initRepository() async {
    _log.d("Repository initRepository() start");
    try {
      _users = await _dataSource.loadUsers();
    } on Exception catch (error, stackTrace) {
      _users = List<User>();
      _handleException(error, stackTrace);
    }

    try {
      _currentUser = await _loadUserFromSPrefs();
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
    }

    try {
      _chats = await _dataSource.loadChats(currentUser: _currentUser);
    } on Exception catch (error, stackTrace) {
      _chats = List<Chat>();
      _handleException(error, stackTrace);
    }

    _inListChats.add(_chats);
    _inListUsers.add(_users);
    _log.d("Repository initRepository() end");
    return true;
  }

  @override
  User getCurrentUser() {
    _log.d("Repository getCurrentUser()");
    return _currentUser;
  }

  @override
  void setCurrentUser({@required User user}) {
    _log.d("Repository setCurrentUser()");

    var oldCurrentUser = _currentUser;
    _currentUser = user;

    _dataSource.updateUser(user: user);
    if (oldCurrentUser == null)
      onChangeInDataSource(DataSourceEvent.CHATS_REFRESH);

    try {
      _saveUserToSPrefs(user: _currentUser);
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
    }
  }

  @override
  Chat getChatById(String chatId) {
    var result = _chats.where((element) => element.id == chatId);
    return result.toList()[0];
  }

  @override
  void addChat({@required Chat chat}) {
    // local changes
    _chats.add(chat);

    // data sources changes
    _dataSource.addChat(chat: chat);
  }

  @override
  void updateChat({@required Chat chat}) {
    // local changes
    var chatIndex = _chats.indexWhere((e) => e.id == chat.id);
    _chats[chatIndex] = chat;

    // data sources changes
    _dataSource.updateChat(chat: chat);
  }

  @override
  void deleteChat({@required Chat chat}) {
    // local changes
    var chatIndex = _chats.indexWhere((e) => e.id == chat.id);
    _chats.removeAt(chatIndex);

    // data sources changes
    _dataSource.deleteChat(chat: chat);
  }

  @override
  void setCurrentChat({@required String chatId}) {
    _currentChatId = chatId;
    if (_currentChatId != null) {
      _inListMessages.add(getChatById(_currentChatId).messages);
    }
  }

  @override
  void addMessage({@required Chat chat, @required BaseMessage message}) {
    // local changes
    var chatIndex = _chats.indexWhere((e) => e.id == chat.id);
    _chats[chatIndex].messages.add(message);

    // data sources changes
    _dataSource.updateChat(chat: _chats[chatIndex]);
  }

  @override
  void updateMessage({@required Chat chat, @required BaseMessage message}) {
    // local changes
    var chatIndex = _chats.indexWhere((e) => e.id == chat.id);
    var messageIndex =
        _chats[chatIndex].messages.indexWhere((e) => e.id == message.id);
    _chats[chatIndex].messages[messageIndex] = message;

    // data sources changes
    _dataSource.updateChat(chat: _chats[chatIndex]);
  }

  @override
  void deleteMessage({@required Chat chat, @required BaseMessage message}) {
    // local changes
    var chatIndex = _chats.indexWhere((e) => e.id == chat.id);
    var messageIndex =
        _chats[chatIndex].messages.indexWhere((e) => e.id == message.id);
    _chats[chatIndex].messages.removeAt(messageIndex);

    // data sources changes
    _dataSource.updateChat(chat: _chats[chatIndex]);
  }

  @override
  void onChangeInDataSource(DataSourceEvent event) async {
    if (event == DataSourceEvent.CHATS_REFRESH) {
      _chats = await _dataSource.loadChats(currentUser: _currentUser);
      _inListChats.add(_chats);
      _log.d("Repository onChangeInDataSource CHATS_REFRESH");
    } else if (event == DataSourceEvent.USERS_REFRESH) {
      _users = await _dataSource.loadUsers();
      _inListUsers.add(_users);
      _log.d("Repository onChangeInDataSource USERS_REFRESH");
    }

    if (_currentChatId != null) {
      _inListMessages.add(getChatById(_currentChatId).messages);
      _log.d("Repository onChangeInDataSource _inListMessages.add");
    }
  }

  void retransmissionDataCache(DataCacheEvent event) {
    if (event == DataCacheEvent.CHATS_REFRESH) {
      _inListChats.add(_chats);
      _log.d("Repository retransmissionDataCache CHATS_REFRESH");
    } else if (event == DataCacheEvent.USERS_REFRESH) {
      _inListUsers.add(_users);
      _log.d("Repository retransmissionDataCache USERS_REFRESH");
    } else if (event == DataCacheEvent.MESSAGE_REFRESH &&
        _currentChatId != null) {
      _inListMessages.add(getChatById(_currentChatId).messages);
      _log.d("Repository retransmissionDataCache MESSAGE_REFRESH");
    }
  }

  @override
  void dispose() {
    _log.d("Repository dispose");
  }

  Future<User> _loadUserFromSPrefs() async {
    _log.d("Repository _loadUserFromSPrefs() start");
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString(_CURRENT_USER_ID);
    String firstName = prefs.getString(_CURRENT_USER_FIRST_NAME);
    String lastName = prefs.getString(_CURRENT_USER_LAST_NAME);
    String avatar = prefs.getString(_CURRENT_USER_AVATAR);
    if (id == null || firstName == null) {
      throw Exception("No data in SharedPreferences");
    }
    DateTime lastVisit = DateTime.now();
    bool isOnline = true;
    User user = User(
        firstName: firstName,
        lastName: lastName,
        avatar: avatar,
        lastVisit: lastVisit,
        isOnline: isOnline,
        id: id);
    _log.d("Repository _loadUserFromSPrefs() end");
    return user;
  }

  Future<void> _saveUserToSPrefs({@required User user}) async {
    _log.d("Repository _saveUserToSPrefs() start");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_CURRENT_USER_ID, user.id);
    prefs.setString(_CURRENT_USER_FIRST_NAME, user.firstName);
    prefs.setString(_CURRENT_USER_LAST_NAME, user.lastName ?? "");
    prefs.setString(_CURRENT_USER_AVATAR, user.avatar ?? "");
    _log.d("Repository _saveUserToSPrefs() end");
  }

  void _handleException(Exception error, StackTrace stackTrace) {
    _log.d("Error in class Repository", ex: error, stacktrace: stackTrace);
  }
}
