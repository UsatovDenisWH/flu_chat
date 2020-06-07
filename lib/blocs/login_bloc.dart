import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di/di_container.dart';
import 'package:fluchat/models/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class LoginBloc extends BlocBase {
  IRepository _repository;
  User _currentUser;

  final _log = FimberLog("FLU_CHAT");

  LoginBloc({@required IRepository repository}) {
    _repository = repository;
    _currentUser = _repository.getCurrentUser();
    _log.d("LoginBloc create");
  }

  User getCurrentUser() => _currentUser;

  bool loginUser(
      {@required String firstName, String lastName, String password}) {
    // TODO add check username, password
    if (_currentUser == null ||
        _currentUser.firstName != firstName ||
        _currentUser.lastName != lastName) {
      _repository.setCurrentUser(
          user: User(firstName: firstName, lastName: lastName));
      _currentUser = _repository.getCurrentUser();
    }
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
  void dispose() {
    _log.d("LoginBloc dispose");
  }
}
