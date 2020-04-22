import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  final Widget _avatar = Padding(
    padding: EdgeInsets.all(8.0),
    child: Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        CircleAvatar(
          radius: 32.0,
          backgroundColor: Colors.blue[300],
          foregroundColor: Colors.black54,
          child: Icon(
            Icons.tag_faces,
            size: 48.0,
          ),
        ),
        CircleAvatar(
          radius: 10.0,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 7.0,
            backgroundColor: Colors.green,
          ),
        ),
      ],
    ),
  );

  final Text _header = Text(
    "Заголовок",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
  );

  final Text _lastMessage = Text("Последнее сообщение");
  final Text _lastMessageTime = Text("17:11");

  final Widget _unreadMessageCount = Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          color: Colors.green[300],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text("4242"));

  final Widget _textDivider = Container(
    color: Colors.transparent,
    height: 8.0,
  );

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Material(
      child: Container(
        child: InkWell(
          highlightColor: Colors.cyanAccent,
          splashColor: Colors.cyan,
          onTap: () {
            print("Tapped");
          },
          child: Row(
            children: <Widget>[
              _avatar,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[_header, _textDivider, _lastMessage],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _lastMessageTime,
                    _textDivider,
                    _unreadMessageCount
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
