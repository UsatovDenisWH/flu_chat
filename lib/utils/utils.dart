import 'package:uuid/uuid.dart';

class Utils {
  static String getRandomUUID() {
    var uuid = Uuid();
    // Generate a v4 (random) id
    return uuid.v4();
  }
}
