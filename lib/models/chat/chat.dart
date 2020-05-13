import 'package:fluchat/data/repository.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/image_message.dart';
import 'package:fluchat/models/message/text_message.dart';
import 'package:fluchat/models/user.dart';
import 'package:fluchat/utils/utils.dart';
import 'package:flutter/material.dart';

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

  void setIdReadMessage({@required int value}) {
    var _property = UserProperty.ID_READ_MESSAGE;
    _setUserProperty(property: _property, value: value);
  }

  void setIdDeliveredMessage({@required int value}) {
    var _property = UserProperty.ID_DELIVERED_MESSAGE;
    _setUserProperty(property: _property, value: value);
  }

  void setIsArchiveChat({@required bool value}) {
    var _property = UserProperty.IS_ARCHIVE_CHAT;
    _setUserProperty(property: _property, value: value);
  }

  void setIsSilentMode({@required bool value}) {
    var _property = UserProperty.IS_SILENT_MODE;
    _setUserProperty(property: _property, value: value);
  }

  void setUserRole({@required UserRole value}) {
    var _property = UserProperty.USER_ROLE;
    _setUserProperty(property: _property, value: value);
  }

  ChatItem toChatItem() {
    var _interlocutors = _getInterlocutors();
    String _avatar;
    String _initials;
    String _title;
    String _shortDescription = "Сообщений ещё нет";
    bool _isOnline;
    String _lastMessageDate = _getLastMessageDate().toString();

    BaseMessage _lastMessage = _getLastMessage();
    if (_lastMessage != null) {
      if (_lastMessage.runtimeType == TextMessage) {
        _shortDescription = _lastMessage.getText();
      } else if (_lastMessage.runtimeType == ImageMessage) {
        _shortDescription = "\u{1F4F7}" + " Фото";
      }
    }

    if (this.chatType == ChatType.SINGLE_CHAT) {
      var _user = _interlocutors[0];
      _avatar = _user.avatar;
      _initials = _user.toInitials();
      _title = _user.getFullName();
      _isOnline = _user.isOnline;
    } else {
      // ChatType.GROUP_CHAT
      _avatar = this.avatar;
      _initials = "";
      _title = this.title;
      _isOnline = false;
      if (_lastMessage != null) {
        _shortDescription =
            _lastMessage.from.getFullName() + ": " + _shortDescription;
      }
    }

    return ChatItem(
        id: this.id,
        avatar: _avatar,
        initials: _initials,
        title: _title,
        shortDescription: _shortDescription,
        lastMessageDate: _lastMessageDate,
        isOnline: _isOnline,
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
    var _currentUser = Repository.getCurrentUser();
    var _chatMembers = List<User>.from(members);
    _chatMembers.remove(_currentUser);
    return _chatMembers;
  }

  int _getUnreadMessageCount() {
    int _readMessageId;
    if (usersPropertiesMap.isNotEmpty) {
      var _userId = Repository.getCurrentUser().id;
      _readMessageId =
          usersPropertiesMap[_userId][UserProperty.ID_READ_MESSAGE] as int;
    }
    _readMessageId ??= 0;
    var _lastMessageId = _getLastMessage()?.id ?? 0;
    return _lastMessageId - _readMessageId;
  }

  bool _isArchiveChat() {
    bool _isArchiveChat;
    if (usersPropertiesMap.isNotEmpty) {
      var _userId = Repository.getCurrentUser().id;
      _isArchiveChat =
          usersPropertiesMap[_userId][UserProperty.IS_ARCHIVE_CHAT] as bool;
    }
    return _isArchiveChat ?? false;
  }

  bool _isSilentMode() {
    bool _isSilentMode;
    if (usersPropertiesMap.isNotEmpty) {
      var _userId = Repository.getCurrentUser().id;
      _isSilentMode =
          usersPropertiesMap[_userId][UserProperty.IS_SILENT_MODE] as bool;
    }
    return _isSilentMode ?? false;
  }

  UserRole _getUserRole() {
    UserRole _userRole;
    if (usersPropertiesMap.isNotEmpty) {
      var _userId = Repository.getCurrentUser().id;
      _userRole =
          usersPropertiesMap[_userId][UserProperty.USER_ROLE] as UserRole;
    }
    return _userRole ?? UserRole.USER;
  }

  void _setUserProperty({@required UserProperty property, @required value}) {
    var _currentUserId = Repository.getCurrentUser().id;
    if (!usersPropertiesMap.containsKey(_currentUserId)) {
      usersPropertiesMap[_currentUserId] = Map();
    }
    usersPropertiesMap[_currentUserId][property] = value;
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
