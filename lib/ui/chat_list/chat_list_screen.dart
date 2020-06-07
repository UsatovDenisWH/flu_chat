import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/models/chat/chat_item.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:fluchat/ui/chat_list/chat_list_item.dart';
import 'package:flutter/material.dart';

// Widget class
class ChatListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatListBloc _bloc;
  User _currentUser;
  Stream<List<ChatItem>> _chatItemStream;
  AppBar _appBar;
  TextEditingController _searchQueryController = TextEditingController();
  String _searchQuery;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _currentUser = _bloc.currentUser;
    _chatItemStream = _bloc.outChatItems;
    _bloc.refreshChatList();
    _appBar = _defaultAppBar();
    _searchQueryController.addListener(_updateSearchQuery);
  }

  void _setAppBar({@required AppBarAction action}) {
    setState(() {
      if (action == AppBarAction.SEARCH) {
        _appBar = _searchAppBar();
      } else {
        _appBar = _defaultAppBar();
      }
    });
  }

  AppBar _defaultAppBar() => AppBar(
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _setAppBar(action: AppBarAction.MENU);
              _bloc.onTapMenuButton();
            },
          ),
        ),
        title: Text(_currentUser.getFullName()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _setAppBar(action: AppBarAction.SEARCH);
            },
          ),
        ],
      );

  AppBar _searchAppBar() => AppBar(
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _clearSearchQuery();
              _setAppBar(action: AppBarAction.NONE);
            },
          ),
        ),
        title: TextField(
          controller: _searchQueryController,
          autofocus: true,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
          ),
          style: TextStyle(color: Colors.white, fontSize: 20.0),
//          onChanged: (query) => _updateSearchQuery,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearchQuery,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar,
        body: SafeArea(
            child: StreamBuilder(
          stream: _chatItemStream,
          initialData: List<ChatItem>(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ChatItem>> snapshot) {
            if (snapshot.data.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ChatListItem(snapshot.data[index], _bloc),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 0));
            }
          },
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: _refreshChatList,
          child: Icon(Icons.refresh, size: 30.0),
          backgroundColor: Colors.blue,
        ),
      );

  void _updateSearchQuery() {
    var newQuery = _searchQueryController.text;
    setState(() {
      _searchQuery = newQuery;
    });
    _bloc.setFilterChat(query: newQuery);
  }

  void _clearSearchQuery() {
    _searchQueryController.clear();
    _updateSearchQuery();
  }

  void _refreshChatList() {
    setState(() {
      _bloc.refreshChatList();
    });
  }
}

// State class
