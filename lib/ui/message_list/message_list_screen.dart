import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/message_list_bloc.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/message/message_item.dart';
import 'package:fluchat/ui/message_list/message_list_item.dart';
import 'package:flutter/material.dart';

// Widget class
class MessageListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageListScreenState();
}

// State class
class _MessageListScreenState extends State<MessageListScreen> {
  MessageListBloc _bloc;
  ChatItem _currentChatItem;
  Stream<List<MessageItem>> _messageItemStream;

//  List<MessageItem> _messageItems;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _currentChatItem = _bloc.currentChatItem;
    _messageItemStream = _bloc.outMessageItems;
  }

  _addMessage(String message) {
    setState(() {
      print("onSubmitted: $message");
      // TODO change on add in MessageListItem
      /*     _messageItems.add(MessageItem(
        id: 11,
        //    this.from,
        //    this.chat,
        isIncoming: false,
        date: DateTime.now(),
        isReaded: true,
        text: message,
        messageType: MessageType.TEXT,
      ));*/
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleSubscription;
    if (_currentChatItem.isOnline != null && _currentChatItem.isOnline) {
      titleSubscription = "в сети";
    } else {
      // TODO replace "_chatItem.lastMessageDate" with "user.lastSeen"
      titleSubscription = "был: ${_currentChatItem.lastMessageDate}";
    }

    Widget _rowDivider = SizedBox(width: 8.0);
    Widget _columnDivider = SizedBox(height: 4.0);

    AppBar _appBar = AppBar(
        titleSpacing: 0.0,
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            if (_currentChatItem.avatar == null ||
                _currentChatItem.avatar == "")
              CircleAvatar(
                radius: 22.0,
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
                child: Text(_currentChatItem.initials,
                    style: TextStyle(fontSize: 16.0)),
              ),
            if (_currentChatItem.avatar != null &&
                _currentChatItem.avatar != "")
              CircleAvatar(
                backgroundColor: Colors.blue[300],
                radius: 22.0,
                // TODO catch loading error
                backgroundImage: NetworkImage(_currentChatItem.avatar),
              ),
            _rowDivider,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _currentChatItem.title,
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
      child: StreamBuilder(
        stream: _messageItemStream,
        initialData: List<MessageItem>(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MessageItem>> snapshot) {
          if (snapshot.data.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                padding: EdgeInsets.all(0),
                controller: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    MessageListItem(snapshot.data[index], _bloc));
          }
        },
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
/*                _scrollController.animateTo(_messageItems.length * 50.0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOutQuad);*/
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
