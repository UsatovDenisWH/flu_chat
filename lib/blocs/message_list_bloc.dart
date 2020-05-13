
import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/message_item.dart';

class MessageListBloc extends BlocBase {

  final _messageItemsController = StreamController<List<MessageItem>>();
  Sink<List<MessageItem>> get _inMessageItems => _messageItemsController.sink;
  Stream<List<MessageItem>> get outMessageItems => _messageItemsController.stream;

  final ChatItem _chatItem;
  List<MessageItem> _messageItems;

  MessageListBloc({ChatItem chatItem}) : this._chatItem = chatItem {
    _inMessageItems.add(_messageItems);
  }

  @override
  void dispose() {
    _messageItemsController.close();
  }

}