import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/message/image_message.dart';
import 'package:fluchat/models/message/text_message.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class RestDataGenerator {
  static final List<User> _users = List<User>();
  static final List<String> _quotes = List<String>();

  static final _log = FimberLog("FLU_CHAT");

  static Future<List<Chat>> getDemoChats({User currentUser}) async {
    _log.d("getDemoChats()");
    if (_users.isEmpty) {
      var newUsers = await _getUsersFromRestService();
      _users.addAll(newUsers);
    }
    if (_quotes.isEmpty) {
      var newQuotes = await _getQuotesFromRestService();
      _quotes.addAll(newQuotes);
    }

    var currentlyUser =
        currentUser ?? User(firstName: "RestDataGenerator default");
    List<int> listRandoms = [];
    int userIndex;
    User anotherUser;
    int quoteIndex;

    return List.generate(10, (int i) {
      i++;
      do {
        userIndex = Random().nextInt(_users.length);
      } while (listRandoms.contains(userIndex));
      listRandoms.add(userIndex);
      anotherUser = _users[userIndex];

      quoteIndex = Random().nextInt(_quotes.length);
      var dateMessage = DateTime.now().subtract(Duration(
          days: Random().nextInt(30),
          hours: Random().nextInt(24),
          minutes: Random().nextInt(60)));
      List<BaseMessage> messages = [
        ImageMessage(
            id: 1,
            from: anotherUser,
            date: dateMessage,
            image: "https://i.picsum.photos/id/${i + userIndex}/300/200.jpg"),
        TextMessage(
            id: 2,
            from: anotherUser,
            date: dateMessage,
            text: _quotes[quoteIndex])
      ];

      return Chat(
          members: <User>[currentlyUser, anotherUser], messages: messages);
    });
  }

  static Future<List<User>> getDemoUsers() async {
    _log.d("getDemoUsers()");
    if (_users.isEmpty) {
      var newUsers = await _getUsersFromRestService();
      _users.addAll(newUsers);
    }

    return List.generate(10, (int i) {
      i++;
      var userIndex = Random().nextInt(_users.length);
      return _users[userIndex];
    });
  }

  static Future<List<User>> _getUsersFromRestService() async {
    _log.d("_getUsersFromRestService() start");
    List<User> newUsers;
    List<dynamic> jsonUsers;

    var dio = Dio();
    dio.options.connectTimeout = 2000;
    dio.options.receiveTimeout = 2000;
    Response response;
    String url = "https://randomuser.me/api/?results=100";
    try {
      response = await dio.get(url);
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
    }
    jsonUsers = response.data["results"] as List<dynamic>;
    newUsers = Iterable<int>.generate(jsonUsers.length)
        .toList()
        .map((int index) => User(
            firstName: jsonUsers[index]["name"]["first"] as String,
            lastName: jsonUsers[index]["name"]["last"] as String,
            avatar: jsonUsers[index]["picture"]["large"] as String))
        .toList();

    _log.d("_getUsersFromRestService() end");
    return newUsers;
  }

  static Future<List<String>> _getQuotesFromRestService() async {
    _log.d("_getQuotesFromRestService() start");
    var dio = Dio();
    dio.options.connectTimeout = 2000;
    dio.options.receiveTimeout = 2000;
    Response response;
    String nextUrl =
        "https://quote-garden.herokuapp.com/api/v2/quotes?page=1&limit=100";
    try {
      response = await dio.get(nextUrl);
    } on Exception catch (error, stackTrace) {
      _handleException(error, stackTrace);
    }
    List<dynamic> jsonQuotes = response.data["quotes"] as List<dynamic>;
    List<String> newQuotes = Iterable<int>.generate(jsonQuotes.length)
        .toList()
        .map((int index) =>
            "\"${jsonQuotes[index]["quoteText"] as String}\" ${jsonQuotes[index]["quoteAuthor"] as String}")
        .toList();

    _log.d("_getQuotesFromRestService() end");
    return newQuotes;
  }

  static void _handleException(Exception error, StackTrace stackTrace) {
    _log.d("Error in class RestDataGenerator",
        ex: error, stacktrace: stackTrace);
  }
}
