import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {

  final Padding _avatar = Padding(
    padding: EdgeInsets.all(8.0),
    child: CircleAvatar(
      radius: 32.0,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.black,
      child: Icon(
        Icons.tag_faces,
        size: 48.0,
      ),
    ),
  );

  final Text _header = Text(
    "Заголовок",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  );
  final Text _lastMessage = Text("Последнее сообщение");
  final Text _lastMessageTime = Text("17:11");
  final Text _unreadMessageCount = Text("42");

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Material(
      child: Container(
        child: InkWell(
          highlightColor: Colors.cyanAccent,
          splashColor: Colors.cyan,
          onTap: () {print("Tapped");},
          child: Row(
            children: <Widget>[
              _avatar,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[_header, _lastMessage],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[_lastMessageTime, _unreadMessageCount],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: _avatar,
        title: Text("Chat item"),
        subtitle: Text("Text"),
        trailing: Icon(Icons.more_vert),
      );*/
}
