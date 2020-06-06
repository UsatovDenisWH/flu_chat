import 'package:fluchat/blocs/common/bloc_provider.dart';
import 'package:fluchat/blocs/login_bloc.dart';
import 'package:fluchat/models/user.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;
  User _currentUser;

  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _currentUser = _bloc.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    firstNameController.text = _currentUser?.firstName ?? "";
    lastNameController.text = _currentUser?.lastName ?? "";

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [Colors.redAccent, Colors.yellowAccent],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
                Flexible(
                  flex: 8,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "*First name",
                        labelText: "*First name"),
                    controller: firstNameController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
                Flexible(
                  flex: 8,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Last name",
                        labelText: "Last name"),
                    controller: lastNameController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            RaisedButton(
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Colors.white)),
              onPressed: () {
                _submitCredential(firstNameController.text.toString(),
                    lastNameController.text.toString());
              },
              child: Text("Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.normal)),
            )
          ],
        )
      ],
    ));
  }

  void _submitCredential(String firstName, String lastName) {
    // TODO check firstName length
    bool result = _bloc.loginUser(firstName: firstName, lastName: lastName);
    // TODO handle result
    if (result) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => _bloc.getNextScreen()));
    }
  }
}
