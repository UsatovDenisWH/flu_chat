import 'package:fluchat/ui/chat_list/chat_list_screen.dart';
import 'package:fluchat/ui/message_list/message_list_route.dart';
import 'package:fluchat/utils/data_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'blocs/chat_list_bloc.dart';
import 'blocs/common/bloc_provider.dart';
import 'models/chat/chat_item.dart';
import 'models/message/message_item.dart';

typedef BlocProvider<ChatListBloc> ChatListScreenBuilder();

class DiContainer {
  static Injector _injector;

  static Injector getInjector() {
    if (_injector == null) {
      _injector = Injector.getInjector();
      _registerServices();
      _registerScreenBuilders();
    }
    return _injector;
  }

  static Widget getStartScreen() {
    if (_injector == null) {
      getInjector();
    }
    return (_injector.get<ChatListScreenBuilder>())();
  }

  static void _registerServices() {
    // List of chats
    _injector.map<List<ChatItem>>((i) => DataGenerator().getDemoChatItems(),
        isSingleton: true);

    // List of messages from a specific chat
    _injector.mapWithParams<List<MessageItem>>((i, p) {
      String _chatId = p["chatId"] as String;
      assert(_chatId != null, "Missed settings for MessageList creation");
      return DataGenerator().getDemoTextMessageItems(_chatId);
    });
  }

  static void _registerScreenBuilders() {
    // Chats screen
    _injector.map<ChatListScreenBuilder>(
        (i) => () => BlocProvider<ChatListBloc>(
              child: ChatListScreen(),
              bloc: ChatListBloc(i.get<List<ChatItem>>()),
            ),
        isSingleton: true);

    // Messages screen
    _injector.mapWithParams<MessageListRoute>((i, p) {
      ChatItem _chatItem = p["chatItem"] as ChatItem;
      assert(
          _chatItem != null, "Missed settings for MessageListRoute creation");
      final _messageList = i.get<List<MessageItem>>(
          additionalParameters: {"chatId": _chatItem.id});
      return MessageListRoute(_chatItem, _messageList);
    });
  }
}
