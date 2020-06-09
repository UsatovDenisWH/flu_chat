import 'dart:async';

import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di/di_container.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/message/text_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class MessageListBloc extends BlocBase {
  ChatItem currentChatItem;
  Stream<List<MessageItem>> outMessageItems;
  final IRepository _repository = DiContainer.getRepository();
  final _log = FimberLog("FLU_CHAT");

  MessageListBloc(
      {@required ChatItem chatItem, @required IStreamAssembly streamAssembly}) {
    currentChatItem = chatItem;
    outMessageItems = streamAssembly.listMessageItems.stream;
    _repository.setCurrentChat(chatId: currentChatItem.id);
    _log.d("MessageListBloc create");
  }

  @override
  void dispose() {
    _repository.setCurrentChat(chatId: null);
    _log.d("MessageListBloc dispose");
  }

  void addTextMessage(String message) {
    var chat = _repository.getChatById(currentChatItem.id);
    var lastMessageId = chat.getLastMessage().id;
    var currentUser = _repository.getCurrentUser();
    var textMessage = TextMessage(
        id: ++lastMessageId,
        from: currentUser,
        date: DateTime.now(),
        text: message);
    _repository.addMessage(chat: chat, message: textMessage);
  }
}
