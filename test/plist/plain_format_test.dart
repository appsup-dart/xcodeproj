import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:xcodeproj/src/plist/plain_format.dart';

void main() {
  group('PList plain format', () {
    var now = DateTime.now();
    var binary = Uint8List.fromList(List.generate(300, (i) => i % 256));
    var value = {
      'hello': 'world',
      'bool': true,
      'not': false,
      'int': 3,
      'double': 1.0,
      'datetime': now,
      'binary': binary,
      'array': [3]
    };
    var plain = '''// !\$*UTF8*\$!
{
  hello = world;
  bool = true;
  not = false;
  int = 3;
  double = 1.0;
  datetime = ${now.toIso8601String()};
  binary = <${binary.toHex()}>;
  array = (3);
}''';
    test('Encoding plist to plain', () {
      var encoded = plainPList.encode(value);
      expect(encoded.split('\n').first, r'// !$*UTF8*$!');
      expect(plainPList.decode(encoded), value);
    });

    test('Decoding plist from plain', () {
      expect(plainPList.decode(plain), value);
    });
  });
}
