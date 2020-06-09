import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static String getRandomUUID() {
    var uuid = Uuid();
    // Generate a v4 (random) id
    return uuid.v4();
  }

  Image imageFromBase64String(String base64String) =>
      Image.memory(base64Decode(base64String));

  String base64StringFromData(Uint8List data) => base64Encode(data);

  Future<Uint8List> stringFromNetworkImageUrl({@required String url}) async {
    Uint8List byteImage = await networkImageToByte(url);
    return byteImage;
  }

}
