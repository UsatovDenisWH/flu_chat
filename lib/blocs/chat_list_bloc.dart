
import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/models/chat/chat_item.dart';

class ChatListBloc extends BlocBase {

  final _chatItemsController = StreamController<List<ChatItem>>();
  Sink<List<ChatItem>> get _inChatItems => _chatItemsController.sink;
  Stream<List<ChatItem>> get outChatItems => _chatItemsController.stream;

  List<ChatItem> _chatItems;

  ChatListBloc(this._chatItems) {
    _inChatItems.add(_chatItems);
  }

  @override
  void dispose() {
    _chatItemsController.close();
  }

}