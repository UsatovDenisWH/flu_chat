import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di_container.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginBloc extends BlocBase {
  IRepository _repository;
  User _currentUser;

  LoginBloc({@required IRepository repository}) {
    _repository = repository;
    _currentUser = _repository.getCurrentUser();
  }

  User getCurrentUser() => _currentUser;

  bool loginUser(
      {@required String firstName, String lastName, String password}) {
    _repository.setCurrentUser(
        user: User(firstName: firstName, lastName: lastName));
    return true;
  }

  BlocProvider<BlocBase> getNextScreen() {
    var injector = DiContainer.getInjector();
    BlocProvider<ChatListBloc> chatScreen =
        (injector.get<ChatListScreenBuilder>())();
    BlocProvider<LoginBloc> loginScreen =
        (injector.get<LoginScreenBuilder>())();

    return chatScreen;
  }

  @override
  void dispose() {}
}
