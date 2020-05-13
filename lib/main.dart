import 'package:fluchat/di_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flu-chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DiContainer.getStartScreen());
}
