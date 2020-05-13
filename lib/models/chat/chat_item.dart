import 'package:fluchat/models/chat/chat.dart';

class ChatItem {
  final String id;
  final String avatar;
  final String initials;
  final String title;
  final String shortDescription;
  final String lastMessageDate;
  final bool isOnline;
  final ChatType chatType;
  final ChatMode chatMode;
  final int unreadMessageCount;
  final bool isArchiveChat;
  final bool isSilentMode;
  final UserRole userRole;

  ChatItem(
      {this.id,
      this.avatar,
      this.initials,
      this.title,
      this.shortDescription,
      this.lastMessageDate,
      this.isOnline,
      this.chatType,
      this.chatMode,
      this.unreadMessageCount,
      this.isArchiveChat,
      this.isSilentMode,
      this.userRole});
}
