import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/ui/message_list/message_list_item.dart';
import 'package:flutter/material.dart';

// Widget class
class MessageListScreen extends StatefulWidget {
  ChatItem _chatItem;
  List<MessageItem> _messageItems;

  MessageListScreen(this._chatItem, this._messageItems);

  @override
  State<StatefulWidget> createState() =>
      _MessageListScreenState(_chatItem, _messageItems);
}

// State class
class _MessageListScreenState extends State<MessageListScreen> {
  ChatItem _chatItem;
  List<MessageItem> _messageItems;

  _MessageListScreenState(this._chatItem, this._messageItems);

  _addMessage(String message) {
    setState(() {
      print("onSubmitted: $message");
      // TODO change on add in MessageListItem
      _messageItems.add(MessageItem(
        id: "11",
        //    this.from,
        //    this.chat,
        isIncoming: false,
        date: DateTime.now(),
        isReaded: true,
        text: message,
        messageType: MessageType.TEXT,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleSubscription;
    if (_chatItem.isOnline) {
      titleSubscription = "в сети";
    } else {
      // TODO replace "_chatItem.lastMessageDate" with "user.lastSeen"
      titleSubscription = "был: ${_chatItem.lastMessageDate}";
    }

    Widget _rowDivider = SizedBox(width: 8.0);
    Widget _columnDivider = SizedBox(height: 4.0);

    AppBar _appBar = AppBar(
        titleSpacing: 0.0,
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            if (_chatItem.avatar == null || _chatItem.avatar == "")
              CircleAvatar(
                radius: 22.0,
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
                child:
                    Text(_chatItem.initials, style: TextStyle(fontSize: 16.0)),
              ),
            if (_chatItem.avatar != null && _chatItem.avatar != "")
              CircleAvatar(
                backgroundColor: Colors.blue[300],
                radius: 22.0,
                // TODO catch loading error
                backgroundImage: NetworkImage(_chatItem.avatar),
              ),
            _rowDivider,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _chatItem.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  _columnDivider,
                  Text(
                    titleSubscription,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ]),
        ),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (BuildContext context) {}),
        ]);

    ScrollController _scrollController = ScrollController();

    Widget _listView = Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        controller: _scrollController,
        itemCount: _messageItems.length,
        itemBuilder: (BuildContext context, int index) =>
            MessageListItem(_messageItems[index]),
      ),
    );

    TextEditingController _textController = TextEditingController();

    Widget _addMessagePanel = Container(
      height: 48.0,
      color: Colors.white70,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.tag_faces),
            color: Colors.black38,
            onPressed: () {
              print("emodzi pressed");
            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Сообщение"),
              controller: _textController,
              onSubmitted: (String message) {
                _addMessage(message);
                _textController.clear();
                // every item have height ~50 pixels
                _scrollController.animateTo(_messageItems.length * 50.0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOutQuad);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file),
            color: Colors.black38,
            onPressed: () {
              print("attach pressed");
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            color: Colors.black38,
            onPressed: () {
              print("camera pressed");
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: _appBar,
      body: SafeArea(
        child: Column(
          children: <Widget>[_listView, _addMessagePanel],
        ),
      ),
    );
  }
}
