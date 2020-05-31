import 'package:fluchat/utils/utils.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String avatar;
  DateTime lastVisit;
  bool isOnline;

  User(
      {@required String firstName,
      String lastName,
      String avatar,
      DateTime lastVisit,
      bool isOnline,
      String id}) {
    this.id = id ?? Utils.getRandomUUID();
    // Delete double inner spaces + outer spaces
    firstName = firstName ?? "User default";
    this.firstName = firstName.replaceAll(RegExp(r"\s+"), " ").trim();
    lastName = lastName ?? "";
    this.lastName = lastName.replaceAll(RegExp(r"\s+"), " ").trim();
    if (avatar != null && avatar.isNotEmpty) this.avatar = avatar.trim();
    this.lastVisit = null;
    this.isOnline = null; // TODO implement changing status
  }

  String getFullName() {
    // Delete double inner spaces + outer spaces
    return "${this.firstName} ${this.lastName}"
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
  }

  String toInitials() {
    var fullName = getFullName();
    var splitString = fullName.split(RegExp(r"\s+"));
    var result = "";
    var count = 0;

    for (var s in splitString) {
      result += s.substring(0, 1).toUpperCase();
      if (++count == 2) break;
    }
    return result;
  }
}
