import 'package:fluchat/ui/chat_list/chat_list_route.dart';
import 'package:fluchat/ui/message_list/message_list_route.dart';
import 'package:fluchat/utils/data_generator.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'models/chat_item.dart';
import 'models/message_item.dart';

class DiContainer {
  static Injector _injector;

  Injector getInjector() {
    if (_injector == null) {
      _injector = Injector.getInjector();
      _registerServiceBuilders();
      _registerRouteBuilders();
    }
    return _injector;
  }

  void _registerServiceBuilders() {
    // List of chats
    _injector.map<List<ChatItem>>((i) => DataGenerator().getDemoChatItems());

    // List of messages from a specific chat
    _injector.mapWithParams<List<MessageItem>>((i, p) {
      String _chatId = p["chatId"] as String;
      assert(_chatId != null, "Missed settings for MessageList creation");
      return DataGenerator().getDemoTextMessageItems(_chatId);
    });
  }

  void _registerRouteBuilders() {
    // Chats screen
    _injector.map<ChatListRoute>((i) => ChatListRoute(i.get<List<ChatItem>>()));

    // Messages screen
    _injector.mapWithParams<MessageListRoute>((i, p) {
      ChatItem _chatItem = p["chatItem"] as ChatItem;
      assert(_chatItem != null, "Missed settings for MessageListRoute creation");
      final _messageList = i.get<List<MessageItem>>(
          additionalParameters: {"chatId": _chatItem.id});
      return MessageListRoute(_chatItem, _messageList);
    });
  }
}
