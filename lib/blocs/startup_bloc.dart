import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/login_bloc.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di_container.dart';
import 'package:flutter/foundation.dart';

class StartupBloc extends BlocBase {
  IRepository _repository;
  Future<bool> _isRepoInit;

  StartupBloc({@required IRepository repository}) {
    _repository = repository;
    _isRepoInit = _repository.initRepository();
  }

  BlocProvider<BlocBase> getNextScreen() {
    var injector = DiContainer.getInjector();
    BlocProvider<ChatListBloc> chatScreen =
        (injector.get<ChatListScreenBuilder>())();
    BlocProvider<LoginBloc> loginScreen =
        (injector.get<LoginScreenBuilder>())();

    if (_isRepoInit == true) {}
    return loginScreen;
  }

  @override
  void dispose() {}
}
