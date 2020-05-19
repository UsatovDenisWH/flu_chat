import 'file:///E:/Soft/AndroidStudioProjects/flu_chat/lib/data/data_source/dummy_data_source.dart';
import 'package:fluchat/data/repository.dart';
import 'package:fluchat/models/message/base_message.dart';
import 'package:fluchat/models/chat/chat.dart';
import 'package:fluchat/models/message/image_message.dart';
import 'package:fluchat/models/message/text_message.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
/*
  test("Method getInterlocutors()", () {
    User currentUser = User(firstName: "Василий Соловьев");
    Repository.setCurrentUser(currentUser);
    User anotherUser = User(firstName: "Геннадий Веточкин");
    User thirdUser = User(firstName: "Николай Макаров");

    var chat = Chat(members: <User>[thirdUser, currentUser, anotherUser]);
    var interlocutors = chat.getInterlocutors();
//    print(interlocutors[0].firstName + " " + interlocutors[0].lastName);
    expect("${interlocutors[0].firstName}  ${interlocutors[0].lastName}".trim(),
        "Николай Макаров");
  });
*/

  test("Creating single chat", () async {
    User currentUser = User(firstName: "Василий Соловьев");
    Repository.setCurrentUser(currentUser);
//    SharedPreferences.setMockInitialValues({
//      "currentUser_id": currentUser.id,
//      "currentUser_firstName": currentUser.firstName,
//      "currentUser_lastName": currentUser.lastName,
//      "currentUser_avatar": currentUser.avatar
//    });
    Repository.initRepository(DummyDataSource());
    User anotherUser = User(
        firstName: "  Акакий  Акакиевич      ",
        avatar: "https://pixabay.com/images/id-5077020/");
    List<BaseMessage> messages = [
      ImageMessage(
          id: 1,
          from: currentUser,
          date: DateTime.now(),
          image: "https://pixabay.com/images/id-5077020/"),
      TextMessage(
          id: 2,
          from: anotherUser,
          date: DateTime.now(),
          text: "Привет! Как дела?")
    ];

    var chat = Chat(members: <User>[currentUser, anotherUser]);
    chat.messages.addAll(messages);
    chat.chatMode = ChatMode.ADMIN_MODE;
    chat.setIdReadMessage(value: 1);
    chat.setUserRole(value: UserRole.ADMIN);
    chat.setIsArchiveChat(value: true);
    chat.setIsSilentMode(value: true);
    var chatItem = chat.toChatItem();

    expect(chat.chatMode, ChatMode.ADMIN_MODE);
    expect(chatItem.avatar, "https://pixabay.com/images/id-5077020/");
    expect(chatItem.initials, "АА");
    expect(chatItem.title, "Акакий Акакиевич");
    expect(chatItem.shortDescription, "Привет! Как дела?");
    expect(chatItem.chatType, ChatType.SINGLE_CHAT);
    expect(chatItem.chatMode, ChatMode.ADMIN_MODE);
    expect(chatItem.unreadMessageCount, 1);
    expect(chatItem.isArchiveChat, true);
    expect(chatItem.isSilentMode, true);

//    print("id = ${chatItem.id}");
//    print("avatar = ${chatItem.avatar}");
//    print("initials = ${chatItem.initials}");
//    print("title = ${chatItem.title}");
//    print("shortDescription = ${chatItem.shortDescription}");
//    print("lastMessageDate = ${chatItem.lastMessageDate}");
//    print("isOnline = ${chatItem.isOnline}");
//    print("chatType = ${chatItem.chatType}");
//    print("chatMode = ${chatItem.chatMode}");
//    print("unreadMessageCount = ${chatItem.unreadMessageCount}");
//    print("isArchiveChat = ${chatItem.isArchiveChat}");
//    print("isSilentMode = ${chatItem.isSilentMode}");
//    print("userRole = ${chatItem.userRole}");
  });

  test("Creating group chat", () {
    User currentUser = User(firstName: "Василий Соловьев");
    Repository.setCurrentUser(currentUser);
    User anotherUser = User(firstName: "  Акакий  Акакиевич      ");
    User thirdUser = User(firstName: "Николай Макаров");

    var chatItem = Chat(
            members: <User>[currentUser, anotherUser, thirdUser],
            title: "Групповой чат")
        .toChatItem();

    expect(chatItem.avatar, null);
    expect(chatItem.initials, "");
    expect(chatItem.title, "Групповой чат");
    expect(chatItem.isOnline, false);
    expect(chatItem.chatType, ChatType.GROUP_CHAT);

    /*print("id = ${chatItem.id}");
    print("avatar = ${chatItem.avatar}");
    print("initials = ${chatItem.initials}");
    print("title = ${chatItem.title}");
    print("shortDescription = ${chatItem.shortDescription}");
    print("unreadMessageCount = ${chatItem.unreadMessageCount}");
    print("lastMessageDate = ${chatItem.lastMessageDate}");
    print("isOnline = ${chatItem.isOnline}");
    print("chatType = ${chatItem.chatType}");*/
  });
}
