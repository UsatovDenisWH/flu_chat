import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/user.dart';

class Repository {
  static User _currentUser;
  static List<Chat> _chats;
  static List<User> _users;

  static User getCurrentUser() => _currentUser;

  static setCurrentUser(User user) {
    // TODO: remove method,  for test only
    _currentUser = user;
  }

  static List<Chat> getChats() => _chats;

  static List<User> getUsers() => _users;
}
