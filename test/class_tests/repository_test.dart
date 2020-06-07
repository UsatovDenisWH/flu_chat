import 'package:fluchat/models/user/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    User currentUser = User(firstName: "Василий Соловьев");
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{
          "flutter.currentUser_id": currentUser.id,
          "flutter.currentUser_firstName": currentUser.firstName,
          "flutter.currentUser_lastName": currentUser.lastName,
          "flutter.currentUser_avatar": currentUser.avatar
        }; // set initial values here if desired
      }
      return null;
    });
  });

//  test("Init repo DummyDataSource", () async {
//    User currentUser = User(firstName: "Василий Соловьев");
////    SharedPreferences.setMockInitialValues({
////      "currentUser_id": currentUser.id,
////      "currentUser_firstName": currentUser.firstName,
////      "currentUser_lastName": currentUser.lastName,
////      "currentUser_avatar": currentUser.avatar
////    });
//    Repository.initRepository(DummyDataSource());
//    var user = Repository().getCurrentUser();
//    print(user.toString());
//  });
}
