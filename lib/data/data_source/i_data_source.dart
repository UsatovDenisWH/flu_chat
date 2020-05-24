import 'dart:async';
import 'dart:core';

import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IDataSource {
  final _changeInDataSource = StreamController<bool>.broadcast();

  Sink<bool> get _inChangeInDataSource => _changeInDataSource.sink;

  Stream<bool> get outChangeInDataSource => _changeInDataSource.stream;

  Future<List<Chat>> loadChats({@required User currentUser});

  Future<bool> addChat({@required Chat chat});

  Future<bool> updateChat({@required Chat chat});

  Future<bool> deleteChat({@required Chat chat});

  Future<List<User>> loadUsers();

  Future<bool> addUser({@required User user});

  Future<bool> updateUser({@required User user});

  Future<bool> deleteUser({@required User user});

  void dispose();
}
