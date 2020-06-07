
import 'package:fluchat/models/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("User.toInitials()", () {
    var user = User(firstName: "Zed");
    var userInitials = user.toInitials();
    expect(userInitials, "Z");

    user = User(firstName: "bad  Zed");
    userInitials = user.toInitials();
    expect(userInitials, "BZ");

    user = User(firstName: "", lastName: "lee");
    userInitials = user.toInitials();
    expect(userInitials, "L");

    user = User(firstName: "", lastName: "lee  shee");
    userInitials = user.toInitials();
    expect(userInitials, "LS");

    user = User(firstName: " dirty ", lastName: " mary ");
    userInitials = user.toInitials();
    expect(userInitials, "DM");

    user = User(firstName: "Harley  Davidson", lastName: "Cowboy  Marlboro");
    userInitials = user.toInitials();
    expect(userInitials, "HD");
  });

}