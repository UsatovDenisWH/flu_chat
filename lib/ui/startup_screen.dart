import 'dart:async';

import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/startup_bloc.dart';
import 'package:flutter/material.dart';

class StartupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  StartupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);

    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => _bloc.getNextScreen())));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "FLU-CHAT",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              LinearProgressIndicator()
            ],
          )
        ],
      ));
}
