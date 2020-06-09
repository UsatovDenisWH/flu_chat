import 'dart:async';
import 'dart:core';

import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter/foundation.dart';

abstract class IDataSource {
  Sink<DataSourceEvent> _inChangeInDataSource;

  IDataSource({@required IStreamAssembly streamAssembly});

  Future<List<Chat>> loadChats({@required User currentUser});

  Future<bool> addChat({@required Chat chat});

  Future<bool> updateChat({@required Chat chat});

  Future<bool> deleteChat({@required Chat chat});

  Future<List<User>> loadUsers();

  Future<bool> updateUser({@required User user});

  void dispose();
}

enum DataSourceEvent { CHATS_REFRESH, USERS_REFRESH }
