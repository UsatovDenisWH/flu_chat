import 'package:fluchat/utils/utils.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String avatar;
  DateTime lastVisit;
  bool isOnline;

  User({@required String firstName, String lastName = "", String avatar = ""}) {
    this.id = Utils.getRandomUUID();
    // Delete outer spaces + double inner spaces
    this.firstName = firstName.replaceAll(RegExp(r"\s+"), " ").trim();
    this.lastName = lastName.replaceAll(RegExp(r"\s+"), " ").trim();
    this.avatar = avatar.trim();
    this.lastVisit = DateTime.now();
    this.isOnline = true; // TODO implement changing status
  }

  String getFullName() {
    var _withoutOuterSpace = "${this.firstName} ${this.lastName}".trim();
    var _withoutInnerSpace = _withoutOuterSpace.split(RegExp(r"\s+")).join(" ");
    return _withoutInnerSpace;
  }

  String toInitials() {
    var _fullName = getFullName();
    var _splitString = _fullName.split(RegExp(r"\s+"));
    var _text = "";

    var count = 0;
    for (var s in _splitString) {
      _text += s.substring(0, 1).toUpperCase();
      if (++count == 2) break;
    }

    return _text;
  }
}
