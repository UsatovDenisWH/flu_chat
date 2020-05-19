import 'package:fluchat/data/data_source/i_data_source.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository implements IRepository {
  User _currentUser = User(firstName: "Repository", lastName: "Default");
  IDataSource _dataSource;
  List<Chat> _chats;
  List<User> _users;

  Repository({@required IDataSource dataSource}) {
    _dataSource = dataSource;
//    initRepository();
  }

  Future<bool> initRepository() {
    _loadUserFromSPrefs().then((value) {
      if (value != null) {
        _currentUser = value;
      }
    }).catchError(_handleSPrefsError);

    _chats = _dataSource.loadChats(currentUser: _currentUser);
    _users = _dataSource.loadUsers();
    return Future<bool>.value(true);
  }

  User getCurrentUser() => _currentUser;

  setCurrentUser({@required User user}) {
    _currentUser = user;
    _saveUserToSPrefs(user: _currentUser).catchError(_handleSPrefsError);
  }

  List<ChatItem> getChatItems() {
    List<ChatItem> chatItems = [];
    _chats.forEach((chat) {
      chatItems.add(chat.toChatItem());
    });
    return chatItems;
  }

  @override
  List<MessageItem> getMessageItems({@required Chat chat}) {
    List<MessageItem> messageItems = [];
    List<BaseMessage> chatMessages = chat.messages;
    // TODO
    return messageItems;
  }

  Future<User> _loadUserFromSPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("flutter.currentUser_id");
    String firstName = prefs.getString("flutter.currentUser_firstName");
    String lastName = prefs.getString("flutter.currentUser_lastName");
    String avatar = prefs.getString("flutter.currentUser_avatar");
    DateTime lastVisit = DateTime.now();
    bool isOnline = true;
    User user = User(
        firstName: firstName,
        lastName: lastName,
        avatar: avatar,
        lastVisit: lastVisit,
        isOnline: isOnline,
        id: id);
    return user;
  }

  Future<void> _saveUserToSPrefs({@required User user}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("flutter.currentUser_id", user.id);
    prefs.setString("flutter.currentUser_firstName", user.firstName);
    prefs.setString("flutter.currentUser_lastName", user.lastName ?? "");
    prefs.setString("flutter.currentUser_avatar", user.avatar ?? "");
  }

  _handleSPrefsError(error) {
    print("Error in Repository.sPrefs: ${error.toString()}");
  }

}
