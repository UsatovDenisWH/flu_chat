import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/di/i_stream_assembly.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:fluchat/models/user/user_item.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:rxdart/rxdart.dart';

class StreamAssembly implements IStreamAssembly {
  final changeInDataSource = PublishSubject<DataSourceEvent>();
  final listChats = BehaviorSubject<List<Chat>>();
  final listUsers = BehaviorSubject<List<User>>();
  final listMessages = PublishSubject<List<BaseMessage>>();
  final listChatItems = BehaviorSubject<List<ChatItem>>();
  final listUserItems = BehaviorSubject<List<UserItem>>();
  final listMessageItems = PublishSubject<List<MessageItem>>();

  String filterChatItems;
  String filterUserItems;
  String filterMessageItems;

  final _log = FimberLog("FLU_CHAT");

  StreamAssembly() {
    filterChatItems = "";
    filterUserItems = "";
    filterMessageItems = "";

    listChats
        .map(_convertChatsToChatItems)
        .map(_filterChatItems)
        .listen(listChatItems.add);
    listUsers
        .map(_convertUsersToUserItems)
        .map(_filterUserItems)
        .listen(listUserItems.add);
    listMessages
        .map(_convertMessagesToMessageItems)
        .map(_filterMessageItems)
        .listen(listMessageItems.add);

    _log.d("StreamAssembly create");
  }

  List<ChatItem> _filterChatItems(List<ChatItem> inChatItems) {
    List<ChatItem> outChatItems;

    if (filterChatItems.isEmpty) {
      outChatItems = inChatItems;
    } else {
      outChatItems = [];
      inChatItems.forEach((item) {
        if (item.title.toLowerCase().contains(filterChatItems.toLowerCase())) {
          outChatItems.add(item);
        }
      });
    }
    return outChatItems;
  }

  List<UserItem> _filterUserItems(List<UserItem> inUserItems) {
    List<UserItem> outUserItems;

    if (filterUserItems.isEmpty) {
      outUserItems = inUserItems;
    } else {
      outUserItems = [];
      inUserItems.forEach((item) {
        if (item.fullName
            .toLowerCase()
            .contains(filterUserItems.toLowerCase())) {
          outUserItems.add(item);
        }
      });
    }
    return outUserItems;
  }

  List<MessageItem> _filterMessageItems(List<MessageItem> inMessageItems) {
    List<MessageItem> outMessageItems;

    if (filterMessageItems.isEmpty) {
      outMessageItems = inMessageItems;
    } else {
      outMessageItems = [];
      inMessageItems.forEach((item) {
        if (item.text
            .toLowerCase()
            .contains(filterMessageItems.toLowerCase())) {
          outMessageItems.add(item);
        }
      });
    }
    return outMessageItems;
  }

  List<ChatItem> _convertChatsToChatItems(List<Chat> chats) {
    _log.d("StreamAssembly _convertChatsToChatItems()");
    List<ChatItem> chatItems = [];
    ChatItem item;

    chats.forEach((chat) {
      item = chat.toChatItem();
      chatItems.add(item);
    });
    return chatItems;
  }

  List<UserItem> _convertUsersToUserItems(List<User> users) {
    _log.d("StreamAssembly _convertUsersToUserItems()");
    List<UserItem> userItems = [];
    UserItem item;

    users.forEach((user) {
      item = user.toUserItem();
      userItems.add(item);
    });
    return userItems;
  }

  List<MessageItem> _convertMessagesToMessageItems(List<BaseMessage> messages) {
    _log.d("StreamAssembly _convertMessagesToMessageItems()");
    List<MessageItem> messageItems = [];
    MessageItem item;

    messages.forEach((message) {
      item = message.toMessageItem();
      messageItems.add(item);
    });
    return messageItems;
  }

  @override
  void dispose() {
    changeInDataSource.close();
    listChats.close();
    listUsers.close();
    listMessages.close();
    listChatItems.close();
    listUserItems.close();
    listMessageItems.close();
    _log.d("StreamAssembly dispose");
  }
}
