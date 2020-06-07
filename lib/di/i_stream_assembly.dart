
import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:fluchat/models/user/user_item.dart';
import 'package:rxdart/rxdart.dart';

abstract class IStreamAssembly {
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

  void dispose();
}
