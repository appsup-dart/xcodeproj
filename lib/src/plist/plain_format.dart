import 'dart:convert';
import 'dart:typed_data';

import 'package:xcodeproj/src/plist/annotated_value.dart';

import 'plain_format_parser.dart';

const plainPList = PlainPListCodec();

class PlainPListCodec extends Codec<Object?, String> {
  const PlainPListCodec();
  @override
  Converter<String, Object?> get decoder => const PlainPListDecoder();

  @override
  Converter<Object, String> get encoder => const PlainPlistEncoder();
}

class PlainPListDecoder extends Converter<String, Object?> {
  const PlainPListDecoder();
  @override
  Object? convert(String input) {
    return _fromAnnotatedValue(
        PListGrammarDefinition().build().parse(input).value);
  }

  Object? _fromAnnotatedValue(AnnotatedValue value) {
    if (value.value is List<AnnotatedValue>) {
      return value.value.map(_fromAnnotatedValue).toList();
    }
    if (value.value is Map<AnnotatedValue, AnnotatedValue>) {
      return value.value.map(
          (k, v) => MapEntry(_fromAnnotatedValue(k), _fromAnnotatedValue(v)));
    }
    if (value.value is String) {
      switch (value.value) {
        case 'true':
          return true;
        case 'false':
          return false;
      }
      try {
        return num.parse(value.value);
      } on FormatException {
        //ignore
      }
      try {
        return DateTime.parse(value.value);
      } on FormatException {
        //ignore
      }
    }
    return value.value;
  }
}

class PlainPlistEncoder extends Converter<Object, String> {
  const PlainPlistEncoder();

  @override
  String convert(Object input) {
    return '// !\$*UTF8*\$!\n${_toAnnotatedValue(input)}';
  }

  AnnotatedValue _toAnnotatedValue(Object object) {
    if (object is Uint8List) {
      return AnnotatedValue(object);
    }
    if (object is List) {
      return AnnotatedValue(object.map((v) => _toAnnotatedValue(v)).toList());
    }
    if (object is Map) {
      var m = {...object}..removeWhere((k, v) => v == null);
      return AnnotatedValue(m.map((k, v) =>
          MapEntry<AnnotatedValue, AnnotatedValue>(
              _toAnnotatedValue(k), _toAnnotatedValue(v))));
    }
    return AnnotatedValue(object);
  }
}

extension Hex on List<int> {
  String toHex() {
    return map((v) => (v < 16 ? '0' : '') + v.toRadixString(16)).join();
  }

  static Uint8List parse(String v) {
    v = v.replaceAll(RegExp(r'\s'), '');
    if (v.length % 2 != 0) {
      throw FormatException('Length should be even');
    }
    return Uint8List.fromList(List.generate(v.length ~/ 2,
        (i) => int.parse(v.substring(i * 2, i * 2 + 2), radix: 16)));
  }
}
