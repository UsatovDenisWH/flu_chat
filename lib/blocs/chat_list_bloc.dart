import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di/di_container.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class ChatListBloc extends BlocBase {
  User currentUser;
  IStreamAssembly _streamAssembly;
  Stream<List<ChatItem>> outChatItems;
  final _repository = DiContainer.getRepository();

  final _log = FimberLog("FLU_CHAT");

  ChatListBloc({@required IStreamAssembly streamAssembly}) {
    _streamAssembly = streamAssembly;
    outChatItems = streamAssembly.listChatItems.stream;
    currentUser = _repository.getCurrentUser();
    _log.d("ChatListBloc create");
  }

  void refreshChatList() {
    _repository.retransmissionDataCache(DataCacheEvent.CHATS_REFRESH);
  }

  void onTapChatItem(BuildContext context, ChatItem chatItem) {
    var injector = DiContainer.getInjector();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                (injector.get<MessageListScreenBuilder>())(chatItem)));
  }

  void onTapMenuButton() {
    // TODO
    _log.d("ChatListBloc onTapMenuButton");
  }

  void setFilterChat({@required String query}) {
    _streamAssembly.filterChatItems = query;
    refreshChatList();
    _log.d("ChatListBloc setFilterChat = $query");
  }

  @override
  void dispose() {
    _log.d("ChatListBloc dispose");
  }
}

enum AppBarAction { NONE, SEARCH, MENU }
