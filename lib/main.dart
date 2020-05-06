import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/di_container.dart';
import 'package:fluchat/models/chat_item.dart';
import 'package:fluchat/ui/chat_list/chat_list_route.dart';
import 'package:fluchat/ui/chat_list/chat_list_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _injector = DiContainer().getInjector();

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flu-chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _injector.get<ChatListScreenBuilder>()

//        BlocProvider<ChatListBloc>(
//            child: ChatListScreen(),
//            bloc: ChatListBloc(_injector.get<List<ChatItem>>()),
//          )


    //_injector.get<ChatListScreenBuilder>()
//        initialRoute: "/chatList",
//        routes: {
//          "/chatList": (context) => _injector.get<ChatListScreenBuilder>() as BlocProvider<ChatListBloc>
//                                    //_injector.get<ChatListRoute>()
//        },
      );
}
