import 'dart:math';

import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/message_item.dart';

class DataGenerator {
  // Generator of chat list items
  List<ChatItem> getDemoChatItems() => List.generate(20, (int i) {
        i++;

        String _avatar;
        if (Random().nextInt(5) % 5 != 0) {
          _avatar =
              "https://picsum.photos/250?image=${i * Random().nextInt(33)}";
        } else {
          _avatar = "";
        }

        return ChatItem(
          id: "$i",
          avatar: _avatar,
          initials: "АК",
          title: "Андрюха Куролесов $i",
          shortDescription: "Привет! Как дела?",
          unreadMessageCount: i % 5 * Random().nextInt(100),
          lastMessageDate: "19:49",
          isOnline: Random().nextBool(),
          chatType: ChatType.SINGLE_CHAT,
        );
      });

// Generator of message list items
  List<MessageItem> getDemoTextMessageItems(String chatId) =>
      List.generate(10, (int i) {
        i++;
        return MessageItem(
          id: i.toString(),
//  final User from;
//  final Chat chat;
          isIncoming: Random().nextBool(),
          date: DateTime.now(),
          isReaded: Random().nextBool(),
          text: "Это чат $chatId. Привет $i!",
          messageType: MessageType.TEXT,
        );
      });
}
