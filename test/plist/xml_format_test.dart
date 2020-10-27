import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:xcodeproj/src/plist/xml_format.dart';

void main() {
  group('PList xml format', () {
    var now = DateTime.now();
    var value = {
      'hello': 'world',
      'bool': true,
      'not': false,
      'int': 3,
      'double': 1.0,
      'datetime': now,
      'binary': Uint8List.fromList(List.generate(300, (i) => i % 256)),
      'array': [3]
    };
    var xml = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>hello</key>
    <string>world</string>
    <key>bool</key>
    <true/>
    <key>not</key>
    <false/>
    <key>int</key>
    <integer>3</integer>
    <key>double</key>
    <real>1.0</real>
    <key>datetime</key>
    <date>${now.toIso8601String()}</date>
    <key>binary</key>
    <data>
AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4
OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3Bx
cnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmq
q6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj
5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/wABAgMEBQYHCAkKCwwNDg8QERITFBUWFxgZGhsc
HR4fICEiIyQlJicoKSor
</data>
    <key>array</key>
    <array>
      <integer>3</integer>
    </array>
  </dict>
</plist>''';
    test('Encoding plist to xml', () {
      expect(xmlPList.encode(value), xml);
    });

    test('Decoding plist from xml', () {
      expect(xmlPList.decode(xml), value);
    });
  });
}
