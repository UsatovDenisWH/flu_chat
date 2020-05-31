import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di_container.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class ChatListBloc extends BlocBase {
  User currentUser;
  String _chatFilter;
  final Stream<List<Chat>> _inChatsStream;
  final _chatItemsController = StreamController<List<ChatItem>>();

  Sink<List<ChatItem>> get _inChatItems => _chatItemsController.sink;

  Stream<List<ChatItem>> get outChatItems => _chatItemsController.stream;

  final _repository = DiContainer.getRepository();

  final _log = FimberLog("FLU_CHAT");

  ChatListBloc(this._inChatsStream) {
    _inChatsStream.listen(_forwardChatsToChatItems);
    currentUser = _repository.getCurrentUser();
    _log.d("ChatListBloc create");
  }

  void _forwardChatsToChatItems(List<Chat> chatsList) {
    List<ChatItem> chatItems = [];
    ChatItem item;

    chatsList.forEach((chat) {
      item = chat.toChatItem();
      if (_isPassesFilter(item)) {
        chatItems.add(item);
      }
    });

    _inChatItems.add(chatItems);
  }

  void refreshChatList() {
    _repository.retransmissionDataCache(DataCacheEvent.CHATS_REFRESH);
  }

  void onTapChatItem(BuildContext context, ChatItem chatItem) {
    var chat = DiContainer.getRepository().getChatById(chatItem.id);
    var injector = DiContainer.getInjector();
//    return (injector.get<MessageListScreenBuilder>())(chat);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                (injector.get<MessageListScreenBuilder>())(chat)));
  }

  void onTapMenuButton() {
    // TODO
    _log.d("ChatListBloc onTapMenuButton");
  }

  void setFilterChat({@required String query}) {
    _chatFilter = query;
    refreshChatList();
    _log.d("ChatListBloc setFilterChat = $query");
  }

  bool _isPassesFilter(ChatItem item) {
    if (_chatFilter == null || _chatFilter.isEmpty) {
      return true;
    } else if (item.title.toLowerCase().contains(_chatFilter.toLowerCase())) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _chatItemsController.close();
    _log.d("ChatListBloc dispose");
  }
}

enum AppBarAction { NONE, SEARCH, MENU }
