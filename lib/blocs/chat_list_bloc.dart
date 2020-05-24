import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/di_container.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/material.dart';

class ChatListBloc extends BlocBase {
  User currentUser;
  final Stream<List<Chat>> _inChatsStream;
  final _chatItemsController = StreamController<List<ChatItem>>();

  Sink<List<ChatItem>> get _inChatItems => _chatItemsController.sink;

  Stream<List<ChatItem>> get outChatItems => _chatItemsController.stream;

  final _repository = DiContainer.getRepository();
  final _injector = DiContainer.getInjector();

  ChatListBloc(this._inChatsStream) {
    _inChatsStream.listen(_forwardChatsToChatItems);
    currentUser = _repository.getCurrentUser();
  }

  void _forwardChatsToChatItems(List<Chat> chatsList) {
    List<ChatItem> chatItems = [];
    chatsList.forEach((chat) {
      chatItems.add(chat.toChatItem());
    });

    _inChatItems.add(chatItems);
  }

  void refreshChatList(){
    _repository.onChangeInDataSource(true);
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

  @override
  void dispose() {
    _chatItemsController.close();
  }
}
