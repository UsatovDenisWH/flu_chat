import 'dart:async';

import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';
import 'package:fluchat/utils/data_generator.dart';
import 'package:flutter/foundation.dart';

class DummyDataSource implements IDataSource {
  final _changeInDataSource = StreamController<bool>.broadcast();

  Sink<bool> get _inChangeInDataSource => _changeInDataSource.sink;

  Stream<bool> get outChangeInDataSource => _changeInDataSource.stream;

  @override
  Future<List<Chat>> loadChats({@required User currentUser}) async {
    return await DataGenerator.getDemoChats(currentUser: currentUser);
  }

  @override
  Future<bool> addChat({@required Chat chat}) {
    // TODO
    _inChangeInDataSource.add(true);
  }

  @override
  Future<bool> updateChat({@required Chat chat}) {
    // TODO
    _inChangeInDataSource.add(true);
  }

  @override
  Future<bool> deleteChat({@required Chat chat}) {
    // TODO
    _inChangeInDataSource.add(true);
  }

  @override
  Future<List<User>> loadUsers() async {
    return await DataGenerator.getDemoUsers();
  }

  @override
  Future<bool> addUser({@required User user}) {
    // TODO
  }

  @override
  Future<bool> updateUser({@required User user}) {
    // TODO
  }

  @override
  Future<bool> deleteUser({@required User user}) {
    // TODO
  }

  void dispose() {
    _changeInDataSource.close();
  }
}
