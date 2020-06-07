import 'package:fluchat/di/di_container.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/image_message.dart';
import 'package:fluchat/models/message/text_message.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:fluchat/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluchat/extensions/datetime_extension.dart';

class Chat {
  String id;
  String title;
  String avatar;
  List<User> members;
  List<BaseMessage> messages;
  ChatType chatType;
  ChatMode chatMode;

  // Map<User.id, User Properties>
  Map<String, Map<UserProperty, dynamic>> usersPropertiesMap;

  Chat(
      {@required this.members,
      this.title,
      this.avatar,
      this.messages,
      this.chatType,
      this.chatMode,
      this.usersPropertiesMap}) {
    this.id = Utils.getRandomUUID();
    this.messages ??= List();
    this.chatType ??= _getChatType();
    this.chatMode ??= ChatMode.NORMAL_MODE;
    this.usersPropertiesMap ??= Map();
    // TODO add validation this.members.length > 1
    // TODO add validation this.title.isNotEmpty for ChatType.GROUP_CHAT
  }

  setIdReadMessage({@required int value}) {
    var _property = UserProperty.ID_READ_MESSAGE;
    _setUserProperty(property: _property, value: value);
  }

  setIdDeliveredMessage({@required int value}) {
    var _property = UserProperty.ID_DELIVERED_MESSAGE;
    _setUserProperty(property: _property, value: value);
  }

  setIsArchiveChat({@required bool value}) {
    var _property = UserProperty.IS_ARCHIVE_CHAT;
    _setUserProperty(property: _property, value: value);
  }

  setIsSilentMode({@required bool value}) {
    var _property = UserProperty.IS_SILENT_MODE;
    _setUserProperty(property: _property, value: value);
  }

  setUserRole({@required UserRole value}) {
    var _property = UserProperty.USER_ROLE;
    _setUserProperty(property: _property, value: value);
  }

  ChatItem toChatItem() {
    var interlocutors = _getInterlocutors();
    String avatar;
    String initials;
    String title;
    String shortDescription = "Сообщений ещё нет";
    bool isOnline;
    String lastMessageDate = _getLastMessageDate().humanizeDiff();

    BaseMessage lastMessage = _getLastMessage();
    if (lastMessage != null) {
      if (lastMessage.runtimeType == TextMessage) {
        shortDescription = lastMessage.getText();
      } else if (lastMessage.runtimeType == ImageMessage) {
        shortDescription = "\u{1F4F7}" + " Фото";
      }
    }

    if (this.chatType == ChatType.SINGLE_CHAT) {
      var user = interlocutors[0];
      avatar = user.avatar;
      initials = user.toInitials();
      title = user.getFullName();
      isOnline = user.isOnline;
    } else {
      // ChatType.GROUP_CHAT
      avatar = this.avatar;
      initials = "";
      title = this.title;
      isOnline = false;
      if (lastMessage != null) {
        shortDescription =
            lastMessage.from.getFullName() + ": " + shortDescription;
      }
    }

    return ChatItem(
        id: this.id,
        avatar: avatar ?? "",
        initials: initials ?? "",
        title: title ?? "",
        shortDescription: shortDescription ?? "",
        lastMessageDate: lastMessageDate,
        // TODO add humanize format in string
        isOnline: isOnline ?? false,
        chatType: this.chatType,
        chatMode: this.chatMode,
        unreadMessageCount: _getUnreadMessageCount(),
        isArchiveChat: _isArchiveChat(),
        isSilentMode: _isSilentMode(),
        userRole: _getUserRole());
  }

  ChatType _getChatType() {
    if (this.members.length <= 2) {
      return ChatType.SINGLE_CHAT;
    } else {
      return ChatType.GROUP_CHAT;
    }
  }

  BaseMessage _getLastMessage() {
    if (messages.isNotEmpty) {
      return messages.last;
    } else {
      return null;
    }
  }

  DateTime _getLastMessageDate() => _getLastMessage()?.date;

  List<User> _getInterlocutors() {
    var currentUser = DiContainer.getRepository().getCurrentUser();
    var chatMembers = List<User>.from(members);
    chatMembers.remove(currentUser);
    return chatMembers;
  }

  int _getUnreadMessageCount() {
    int readMessageId;
    if (usersPropertiesMap.isNotEmpty) {
      var currentUser = DiContainer.getRepository().getCurrentUser();
      var userId = currentUser.id;
      readMessageId =
          usersPropertiesMap[userId][UserProperty.ID_READ_MESSAGE] as int;
    }
    readMessageId ??= 0;
    var lastMessageId = _getLastMessage()?.id ?? 0;
    return lastMessageId - readMessageId;
  }

  bool _isArchiveChat() {
    bool isArchiveChat;
    if (usersPropertiesMap.isNotEmpty) {
      var currentUser = DiContainer.getRepository().getCurrentUser();
      var userId = currentUser.id;
      isArchiveChat =
          usersPropertiesMap[userId][UserProperty.IS_ARCHIVE_CHAT] as bool;
    }
    return isArchiveChat ?? false;
  }

  bool _isSilentMode() {
    bool isSilentMode;
    if (usersPropertiesMap.isNotEmpty) {
      var currentUser = DiContainer.getRepository().getCurrentUser();
      var userId = currentUser.id;
      isSilentMode =
          usersPropertiesMap[userId][UserProperty.IS_SILENT_MODE] as bool;
    }
    return isSilentMode ?? false;
  }

  UserRole _getUserRole() {
    UserRole userRole;
    if (usersPropertiesMap.isNotEmpty) {
      var currentUser = DiContainer.getRepository().getCurrentUser();
      var userId = currentUser.id;
      userRole = usersPropertiesMap[userId][UserProperty.USER_ROLE] as UserRole;
    }
    return userRole ?? UserRole.USER;
  }

  void _setUserProperty({@required UserProperty property, @required value}) {
    var currentUser = DiContainer.getRepository().getCurrentUser();
    var userId = currentUser.id;
    if (!usersPropertiesMap.containsKey(userId)) {
      usersPropertiesMap[userId] = Map();
    }
    usersPropertiesMap[userId][property] = value;
  }
}

enum ChatType { SINGLE_CHAT, GROUP_CHAT }

enum ChatMode { NORMAL_MODE, ADMIN_MODE }

enum UserProperty {
  ID_READ_MESSAGE, // int
  ID_DELIVERED_MESSAGE, // int
  IS_ARCHIVE_CHAT, // bool
  IS_SILENT_MODE, // bool
  USER_ROLE // enum UserRole
}

enum UserRole { USER, ADMIN }
