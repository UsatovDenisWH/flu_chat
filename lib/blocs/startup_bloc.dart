import 'package:fluchat/blocs/chat_list_bloc.dart';
import 'package:fluchat/blocs/common/base_bloc.dart';
import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/login_bloc.dart';
import 'package:fluchat/data/i_repository.dart';
import 'package:fluchat/di_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class StartupBloc extends BlocBase {
  IRepository _repository;
  Future<bool> isRepoInit;

  final _log = FimberLog("FLU_CHAT");

  StartupBloc({@required IRepository repository}) {
    _repository = repository;
    isRepoInit = _repository.initRepository();
    _log.d("StartupBloc create");
  }

  BlocProvider<BlocBase> getNextScreen() {
    var injector = DiContainer.getInjector();
    BlocProvider<ChatListBloc> chatScreen =
        (injector.get<ChatListScreenBuilder>())();
    BlocProvider<LoginBloc> loginScreen =
        (injector.get<LoginScreenBuilder>())();

    if (isRepoInit == true) {}
    return loginScreen;
  }

  @override
  void dispose() {
    _log.d("StartupBloc dispose");
  }
}
