import 'dart:typed_data';

import 'package:pointycastle/digests/md5.dart';

import 'plist/plain_format.dart';
import 'dart:math';

class UuidGenerator {
  final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

  String random() {
    return MD5Digest()
        .process(
            Uint8List.fromList(List.generate(256, (_) => _random.nextInt(256))))
        .toHex()
        .toUpperCase()
        .substring(0, 24);
  }
}
