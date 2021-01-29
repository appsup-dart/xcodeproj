import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'plist/plain_format.dart';
import 'dart:math';

class UuidGenerator {
  final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

  String random() {
    return md5
        .convert(
            Uint8List.fromList(List.generate(256, (_) => _random.nextInt(256))))
        .bytes
        .toHex()
        .toUpperCase()
        .substring(0, 24);
  }
}
