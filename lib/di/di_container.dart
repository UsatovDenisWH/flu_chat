import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/login_bloc.dart';
import 'package:fluchat/blocs/message_list_bloc.dart';
import 'package:fluchat/blocs/startup_bloc.dart';
import 'package:fluchat/data/data_source/dummy_data_source.dart';
import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/data/repository.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/di/stream_assembly.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_screen.dart';
import 'package:fluchat/ui/login_screen.dart';
import 'package:fluchat/ui/message_list/message_list_screen.dart';
import 'package:fluchat/ui/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

typedef BlocProvider<StartupBloc> StartupScreenBuilder();
typedef BlocProvider<LoginBloc> LoginScreenBuilder();
typedef BlocProvider<ChatListBloc> ChatListScreenBuilder();
typedef BlocProvider<MessageListBloc> MessageListScreenBuilder(
    ChatItem chatItem);

class DiContainer {
  static Injector _injector;
  static final _log = FimberLog("FLU_CHAT");

  static initialize() {
    _injector = Injector.getInjector();
    _registerServices();
    _registerScreenBuilders();
  }

  static Injector getInjector() {
    _log.d("DiContainer getInjector()");
    assert(_injector != null);
    return _injector;
  }

  static Widget getStartupScreen() {
    _log.d("DiContainer getStartupScreen()");
    assert(_injector != null);
    return (_injector.get<StartupScreenBuilder>())();
  }

  static IRepository getRepository() {
    _log.d("DiContainer getRepository()");
    assert(_injector != null);
    return _injector.get<IRepository>();
  }

  static void _registerServices() {
    _injector.map<IStreamAssembly>((i) => StreamAssembly(), isSingleton: true);

    _injector.map<IDataSource>(
        (i) => DummyDataSource(streamAssembly: i.get<IStreamAssembly>()),
        isSingleton: true);

    _injector.map<IRepository>(
        (i) => Repository(
            dataSource: i.get<IDataSource>(),
            streamAssembly: i.get<IStreamAssembly>()),
        isSingleton: true);
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
              bloc: ChatListBloc(streamAssembly: i.get<IStreamAssembly>()),
            ),
        isSingleton: true);

    // Messages screen
    _injector.map<MessageListScreenBuilder>(
        (i) => (ChatItem chatItem) => BlocProvider<MessageListBloc>(
              child: MessageListScreen(),
              bloc: MessageListBloc(
                  chatItem: chatItem, streamAssembly: i.get<IStreamAssembly>()),
            ),
        isSingleton: true);
  }
}
