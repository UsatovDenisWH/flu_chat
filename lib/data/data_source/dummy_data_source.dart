import 'dart:async';

import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:fluchat/utils/rest_data_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class DummyDataSource implements IDataSource {
  Sink<DataSourceEvent> _inChangeInDataSource;

  static List<Chat> _demoChats;
  static List<User> _demoUsers;

  final _log = FimberLog("FLU_CHAT");

  DummyDataSource({@required IStreamAssembly streamAssembly}) {
    this._inChangeInDataSource = streamAssembly.changeInDataSource.sink;
  }

  @override
  Future<List<Chat>> loadChats({@required User currentUser}) async {
    if (currentUser == null) {
      return List<Chat>();
    } else if (_demoChats == null) {
      _demoChats =
          await RestDataGenerator.getDemoChats(currentUser: currentUser);
    }
    return _demoChats;
  }

  @override
  Future<bool> addChat({@required Chat chat}) async {
    bool result;
    try {
      await Future.delayed(Duration(milliseconds: 500), () {
        _demoChats.add(chat);
        result = true;
      });
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
      result = false;
    }
    if (result) _inChangeInDataSource.add(DataSourceEvent.CHATS_REFRESH);
    return result;
  }

  @override
  Future<bool> updateChat({@required Chat chat}) async {
    bool result;
    try {
      await Future.delayed(Duration(milliseconds: 500), () {
        var chatIndex = _demoChats.indexWhere((e) => e.id == chat.id);
        _demoChats[chatIndex] = chat;
        result = true;
      });
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
      result = false;
    }
    if (result) _inChangeInDataSource.add(DataSourceEvent.CHATS_REFRESH);
    return result;
  }

  @override
  Future<bool> deleteChat({@required Chat chat}) async {
    bool result;
    try {
      await Future.delayed(Duration(milliseconds: 500), () {
        var chatIndex = _demoChats.indexWhere((e) => e.id == chat.id);
        _demoChats.removeAt(chatIndex);
        result = true;
      });
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
      result = false;
    }
    if (result) _inChangeInDataSource.add(DataSourceEvent.CHATS_REFRESH);
    return result;
  }

  @override
  Future<List<User>> loadUsers() async {
    if (_demoUsers == null) {
      _demoUsers = await RestDataGenerator.getDemoUsers();
    }
    return _demoUsers;
  }

  @override
  Future<bool> updateUser({@required User user}) async {
    bool result;
    try {
      var userIndex = _demoUsers.indexWhere((e) => e.id == user.id);
      if (userIndex != -1) {
        // if this user FOUND - update him
        _demoUsers[userIndex] = user;
      } else {
        // if this user NOT found - add him
        _demoUsers.add(user);
      }
      result = true;
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
      result = false;
    }
    if (result) {
      _inChangeInDataSource.add(DataSourceEvent.CHATS_REFRESH);
      _inChangeInDataSource.add(DataSourceEvent.USERS_REFRESH);
    }
    return result;
  }

  @override
  void dispose() {}

  void _handleException(Exception error, StackTrace stackTrace) {
    _log.d("Error in class DummyDataSource", ex: error, stacktrace: stackTrace);
  }
}
