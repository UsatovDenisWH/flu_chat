import 'dart:async';

import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository implements IRepository {
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

  Repository({@required IDataSource dataSource}) {
    _dataSource = dataSource;
    _dataSource.outChangeInDataSource.listen(onChangeInDataSource);
    isInitialized = initRepository();
  }

  @override
  Future<bool> initRepository() async {
    try {
      _currentUser = await _loadUserFromSPrefs();
    } on Exception catch (error) {
      _currentUser = User(firstName: "Repository Default");
      _handleException(error);
    }

    try {
      _chats = await _dataSource.loadChats(currentUser: _currentUser);
    } on Exception catch (error) {
      _chats = List<Chat>();
      _handleException(error);
    }

    try {
      _users = await _dataSource.loadUsers();
    } on Exception catch (error) {
      _users = List<User>();
      _handleException(error);
    }

    _inListChats.add(_chats);
    _inListUsers.add(_users);
    return true;
  }

  @override
  User getCurrentUser() => _currentUser;

  @override
  void setCurrentUser({@required User user}) {
    _currentUser = user;
    _saveUserToSPrefs(user: _currentUser).catchError(_handleException);
    _dataSource.updateUser(user: user);
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
  void setListenerChat({@required Chat chat}) {
    _listenerChat = chat;
    _inListMessages.add(_listenerChat.messages);
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
    } else if (event == DataSourceEvent.USERS_REFRESH) {
      _users = await _dataSource.loadUsers();
      _inListUsers.add(_users);
    }

    if (_listenerChat != null) {
      _inListMessages.add(_listenerChat.messages);
    }
  }

  @override
  void dispose() {
    _listChats.close();
    _listUsers.close();
    _listMessages.close();
  }

  Future<User> _loadUserFromSPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("flutter.currentUser_id");
    String firstName = prefs.getString("flutter.currentUser_firstName");
    String lastName = prefs.getString("flutter.currentUser_lastName");
    String avatar = prefs.getString("flutter.currentUser_avatar");
    DateTime lastVisit = DateTime.now();
    bool isOnline = true;
    User user = User(
        firstName: firstName,
        lastName: lastName,
        avatar: avatar,
        lastVisit: lastVisit,
        isOnline: isOnline,
        id: id);
    return user;
  }

  Future<void> _saveUserToSPrefs({@required User user}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("flutter.currentUser_id", user.id);
    prefs.setString("flutter.currentUser_firstName", user.firstName);
    prefs.setString("flutter.currentUser_lastName", user.lastName ?? "");
    prefs.setString("flutter.currentUser_avatar", user.avatar ?? "");
  }

  void _handleException(error) {
    print("Error in class Repository: ${error.toString()}");
  }
}
