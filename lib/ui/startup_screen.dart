import 'dart:async';

import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/startup_bloc.dart';
import 'package:flutter/cupertino.dart';
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
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "FLU-CHAT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
          FutureBuilder<bool>(
            future: _bloc.isRepoInit,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data) {
                Future.microtask(() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            _bloc.getNextScreen())));
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 40.0)
                ],
              );
            },
          ),
        ],
      );
}
