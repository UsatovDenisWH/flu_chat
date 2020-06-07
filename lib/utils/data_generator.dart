import 'dart:math';

import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/image_message.dart';
import 'package:fluchat/models/message/text_message.dart';
import 'package:fluchat/models/user/user.dart';

class DataGenerator {
  static List<Chat> getDemoChats({User currentUser}) {
    var currentlyUser = currentUser ?? User(firstName: "DataGenerator default");
    return List.generate(10, (int i) {
      i++;
      var avatar = "";
      if (Random().nextInt(5) % 5 != 0) {
        avatar = "https://picsum.photos/250?image=${i * Random().nextInt(33)}";
      }
      var anotherUser = User(
          firstName: "Штурмовик $i",
          avatar: avatar,
          isOnline: Random().nextBool());

      List<BaseMessage> messages = [
        ImageMessage(
            id: 1,
            from: currentlyUser,
            date: DateTime.now(),
            image: "https://pixabay.com/images/id-5077020/"),
        TextMessage(
            id: 2,
            from: anotherUser,
            date: DateTime.now(),
            text: "Привет! Как дела?")
      ];

      return Chat(
          members: <User>[currentlyUser, anotherUser], messages: messages);
    });
  }

  static List<User> getDemoUsers() => List.generate(10, (int i) {
        i++;
        var avatar = "";
        if (Random().nextInt(5) % 5 != 0) {
          avatar =
              "https://picsum.photos/250?image=${i * Random().nextInt(33)}";
        }
        return User(
            firstName: "Демо№$i",
            avatar: avatar,
            isOnline: Random().nextBool());
      });

/*
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

  List<MessageItem> getDemoTextMessageItems(String chatId) =>
      List.generate(10, (int i) {
        i++;
        return MessageItem(
          id: i,
          isIncoming: Random().nextBool(),
          date: DateTime.now(),
          isReaded: Random().nextBool(),
          text: "Это чат $chatId. Привет $i!",
          messageType: MessageType.TEXT,
        );
      });
*/

}
