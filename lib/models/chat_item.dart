
// item to display in the chat list
class ChatItem {
  final String id;
  final String avatar;
  final String initials;
  final String title;
  final String shortDescription;
  final int messageCount;
  final String lastMessageDate;
  final bool isOnline;
  final ChatType chatType;
  final String author;

  ChatItem({
      this.id,
      this.avatar,
      this.initials,
      this.title,
      this.shortDescription,
      this.messageCount,
      this.lastMessageDate,
      this.isOnline,
      this.chatType,
      this.author
  });
}

enum ChatType {
  SINGLE,
  GROUP,
  ARCHIVE
}
