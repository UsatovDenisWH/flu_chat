import 'package:dio/dio.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("_getUsersFromRestService()_new_URL", () async {
    var benchmarkTimer = Stopwatch();
    benchmarkTimer.start();

    final List<User> _users = List<User>();
    print("_getUsersFromRestService() start");

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
      print(error.toString());
    }
    jsonUsers = response.data["results"] as List<dynamic>;
    newUsers = Iterable<int>.generate(jsonUsers.length)
        .toList()
        .map((int index) => User(
            firstName: jsonUsers[index]["name"]["first"] as String,
            lastName: jsonUsers[index]["name"]["last"] as String,
            avatar: jsonUsers[index]["picture"]["large"] as String))
        .toList();
    _users.addAll(newUsers);

    print("_getUsersFromRestService() end");
    benchmarkTimer.stop();
    print("Elapsed time: ${benchmarkTimer.elapsedMilliseconds}");
    print("Add users: ${_users.length}");
    _users.forEach((element) {
      print("${element.firstName} ${element.lastName}");
    });
  });

  test("_getUsersFromRestService()", () async {
    var benchmarkTimer = Stopwatch();
    benchmarkTimer.start();
    print("_getUsersFromRestService() start");

    final List<User> _users = List<User>();
    List<User> newUsers;
    List<dynamic> jsonUsers;

    var dio = Dio();
    dio.options.connectTimeout = 2000;
    dio.options.receiveTimeout = 2000;
    Response response;
    String nextUrl = "https://swapi.dev/api/people/";
    do {
      print(nextUrl);
      try {
        response = await dio.get(nextUrl);
      } on Exception catch (error, stackTrace) {
        print(error.toString());
      }
      nextUrl = response.data["next"] as String;
      jsonUsers = response.data["results"] as List<dynamic>;
      newUsers = Iterable<int>.generate(jsonUsers.length)
          .toList()
          .map((int index) =>
              User(firstName: jsonUsers[index]["name"] as String))
          .toList();
      _users.addAll(newUsers);
    } while (nextUrl != null);

    print("_getUsersFromRestService() end");
    benchmarkTimer.stop();
    print("Elapsed time: ${benchmarkTimer.elapsedMilliseconds}");
    print("Add users: ${_users.length}");
    _users.forEach((element) {
      print(element.firstName);
    });
  });

  test("_getQuotesFromRestService()", () async {
    var benchmarkTimer = Stopwatch();
    benchmarkTimer.start();

    List<String> _quotes;
    var dio = Dio();
    Response response;
    String nextUrl =
        "https://quote-garden.herokuapp.com/api/v2/quotes?page=1&limit=100";
    response = await dio.get(nextUrl);
    List<dynamic> jsonQuotes = response.data["quotes"] as List<dynamic>;
    _quotes = Iterable<int>.generate(jsonQuotes.length)
        .toList()
        .map((int index) =>
            "\"${jsonQuotes[index]["quoteText"] as String}\" ${jsonQuotes[index]["quoteAuthor"] as String}")
        .toList();

    benchmarkTimer.stop();
    print("Elapsed time: ${benchmarkTimer.elapsedMilliseconds}");
    print("Add quotes: ${_quotes.length}");
    _quotes.forEach(print);
  });
}
