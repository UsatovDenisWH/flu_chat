import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/di_container.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:flutter/foundation.dart';

class MessageListBloc extends BlocBase {
  Chat currentChat;
  Stream<List<BaseMessage>> _inMessagesStream;
  final _repository = DiContainer.getRepository();
  final _messageItemsController = StreamController<List<MessageItem>>();

  Sink<List<MessageItem>> get _inMessageItems => _messageItemsController.sink;

  Stream<List<MessageItem>> get outMessageItems =>
      _messageItemsController.stream;

  MessageListBloc({@required Chat chat, @required Stream<List<BaseMessage>> messagesStream}) {
    currentChat = chat;
    _inMessagesStream = messagesStream;
    _inMessagesStream.listen(_forwardMessagesToMessageItems);
    _repository.setListenerChat(chat: currentChat);
  }

  void _forwardMessagesToMessageItems(List<BaseMessage> messageList) {
    List<MessageItem> messageItems = [];

    messageList.forEach((message) {
      if (message.messageType == MessageType.TEXT) {
        messageItems.add(MessageItem(
            id: message.id,
            // TODO
            isIncoming: true,
            date: message.date,
            // TODO
            isReaded: true,
            text: message.getText(),
            messageType: message.messageType));
      } else if (message.messageType == MessageType.IMAGE) {
        messageItems.add(MessageItem(
            id: message.id,
            // TODO
            isIncoming: true,
            date: message.date,
            // TODO
            isReaded: true,
            // TODO image: message.getImage(),
            messageType: message.messageType));
      } else if (message.messageType == MessageType.VIDEO) {}
    });

    _inMessageItems.add(messageItems);
  }

  @override
  void dispose() {
    _messageItemsController.close();
    _repository.setListenerChat(chat: null);
  }
}
