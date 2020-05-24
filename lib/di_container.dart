import 'package:fluchat/blocs/login_bloc.dart';
import 'package:fluchat/blocs/message_list_bloc.dart';
import 'package:fluchat/blocs/startup_bloc.dart';
import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/data/repository.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/user.dart';
import 'package:fluchat/ui/chat_list/chat_list_screen.dart';
import 'package:fluchat/ui/login_screen.dart';
import 'package:fluchat/ui/message_list/message_list_screen.dart';
import 'package:fluchat/ui/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'blocs/chat_list_bloc.dart';
import 'blocs/common/bloc_provider.dart';
import 'data/data_source/dummy_data_source.dart';

typedef BlocProvider<StartupBloc> StartupScreenBuilder();
typedef BlocProvider<LoginBloc> LoginScreenBuilder();
typedef BlocProvider<ChatListBloc> ChatListScreenBuilder();
typedef BlocProvider<MessageListBloc> MessageListScreenBuilder(Chat chat);

class DiContainer {
  static Injector _injector;
  static final IDataSource _dataSource = DummyDataSource();
  static final IRepository _repository = Repository(dataSource: _dataSource);

  static initialize() {
    _injector = Injector.getInjector();
    _registerDataSources();
    _registerServices();
    _registerScreenBuilders();
  }

  static Injector getInjector() {
    if (_injector == null) {
      initialize();
    }
    return _injector;
  }

  static Widget getStartupScreen() {
    if (_injector == null) {
      initialize();
    }
    return (_injector.get<StartupScreenBuilder>())();
  }

  static IRepository getRepository() {
    if (_injector == null) {
      initialize();
    }
    return _injector.get<IRepository>();
  }

  static void _registerDataSources() {
    _injector.map<IDataSource>((i) => _dataSource, isSingleton: true);
    _injector.map<IRepository>((i) => _repository, isSingleton: true);
  }

  static void _registerServices() {
    // List of chats
    _injector.map<Stream<List<Chat>>>((i) => i.get<IRepository>().outListChats,
        isSingleton: true);

    // List of users
    _injector.map<Stream<List<User>>>((i) => i.get<IRepository>().outListUsers,
        isSingleton: true);

    // List of messages
    _injector.map<Stream<List<BaseMessage>>>(
        (i) => i.get<IRepository>().outListMessages,
        isSingleton: true);

/*
    _injector.map<List<ChatItem>>((i) => i.get<IRepository>().getChatItems(),
        isSingleton: true);
*/

/*
    // List of messages from a specific chat
    _injector.mapWithParams<Stream<List<BaseMessage>>>((i, p) {
      Chat chat = p["chat"] as Chat;
      assert(chat != null, "Missed settings for List<MessageItem> creation");
      i.get<IRepository>().setListenerChat(chat: chat);
      return i.get<IRepository>().outListMessages;
    });
*/

/*
    _injector.mapWithParams<List<MessageItem>>((i, p) {
      Chat chat = p["chat"] as Chat;
      assert(chat != null, "Missed settings for List<MessageItem> creation");
      return i.get<IRepository>().getMessageItems(chat: chat);
    });
*/

/*
    _injector.mapWithParams<List<MessageItem>>((i, p) {
      String _chatId = p["chatId"] as String;
      assert(_chatId != null, "Missed settings for MessageList creation");
      return DataGenerator().getDemoTextMessageItems(_chatId);
    });
*/
  }

  static void _registerScreenBuilders() {
    // Startup screen
    _injector.map<StartupScreenBuilder>(
        (i) => () => BlocProvider<StartupBloc>(
              child: StartupScreen(),
              bloc: StartupBloc(repository: i.get<IRepository>()),
            ),
        isSingleton: true);

    // Login screen
    _injector.map<LoginScreenBuilder>(
        (i) => () => BlocProvider<LoginBloc>(
              child: LoginScreen(),
              bloc: LoginBloc(repository: i.get<IRepository>()),
            ),
        isSingleton: true);

    // Chats screen
    _injector.map<ChatListScreenBuilder>(
        (i) => () => BlocProvider<ChatListBloc>(
              child: ChatListScreen(),
              bloc: ChatListBloc(i.get<Stream<List<Chat>>>()),
            ),
        isSingleton: true);

    // Messages screen
    _injector.map<MessageListScreenBuilder>(
        (i) => (Chat chat) => BlocProvider<MessageListBloc>(
              child: MessageListScreen(),
              bloc: MessageListBloc(
                  chat: chat,
                  messagesStream: i.get<Stream<List<BaseMessage>>>()),
            ),
        isSingleton: true);

/*
    _injector.map<MessageListScreenBuilder>(
        (i) => (Chat chat) => BlocProvider<MessageListBloc>(
              child: MessageListScreen(chatItem: chat.toChatItem()),
              bloc: MessageListBloc(i.get<List<MessageItem>>(
                  additionalParameters: {"chat": chat})),
            ),
        isSingleton: true);
*/

/*    _injector.mapWithParams<MessageListRoute>((i, p) {
      ChatItem _chatItem = p["chatItem"] as ChatItem;
      assert(
          _chatItem != null, "Missed settings for MessageListRoute creation");
      final _messageList = i.get<List<MessageItem>>(
          additionalParameters: {"chatId": _chatItem.id});
      return MessageListRoute(_chatItem, _messageList);
    });*/
  }
}
