import 'dart:convert';
import 'dart:typed_data';

import 'package:xml/xml.dart';

const xmlPList = XmlPListCodec();

class XmlPListCodec extends Codec<Object?, String> {
  const XmlPListCodec();
  @override
  Converter<String, Object> get decoder => const XmlPListDecoder();

  @override
  Converter<Object, String> get encoder => const XmlPlistEncoder();
}

class XmlPListDecoder extends Converter<String, Object> {
  const XmlPListDecoder();
  @override
  Object convert(String input) {
    var doc = XmlDocument.parse(input);
    var plist = doc.rootElement;
    if (plist.name.local != 'plist') {
      throw FormatException('The root element should be a plist');
    }
    return _fromXmlElement(plist.children.whereType<XmlElement>().first);
  }

  dynamic _fromXmlElement(XmlElement node) {
    switch (node.name.local) {
      case 'dict':
        var dict = <String, dynamic>{};
        String? key;
        for (var n in node.children) {
          if (n is XmlElement) {
            if (n.name.local == 'key') {
              key = n.innerText;
            } else {
              if (key == null) {
                return FormatException('Missing key element.');
              }
              dict[key] = _fromXmlElement(n);
              key = null;
            }
          }
        }
        return dict;

      case 'array':
        return node.children
            .whereType<XmlElement>()
            .map(_fromXmlElement)
            .toList();
      case 'true':
        return true;
      case 'false':
        return false;
      case 'real':
        return double.parse(node.innerText);
      case 'integer':
        return int.parse(node.innerText);
      case 'string':
        return node.innerText;
      case 'data':
        return base64.decode(node.innerText.replaceAll(RegExp(r'\s'), ''));
      case 'date':
        return DateTime.parse(node.innerText);
    }
  }
}

class XmlPlistEncoder extends Converter<Object, String> {
  const XmlPlistEncoder();

  @override
  String convert(Object input) {
    var doc = XmlDocument([
      XmlDeclaration([
        XmlAttribute(XmlName('version'), '1.0'),
        XmlAttribute(XmlName('encoding'), 'UTF-8'),
      ]),
      XmlDoctype(
          'plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"'),
      XmlElement(XmlName('plist'), [XmlAttribute(XmlName('version'), '1.0')],
          [_toXmlElement(input)])
    ]);

    return doc.toXmlString(
        pretty: true,
        preserveWhitespace: (node) =>
            node is XmlElement && node.name.local == 'data');
  }

  XmlElement _toXmlElement(Object value) {
    if (value is Map) {
      var e = XmlElement(XmlName('dict'));

      value.forEach((key, value) {
        e.children.add(XmlElement(XmlName('key'))..innerText = key);
        e.children.add(_toXmlElement(value));
      });
      return e;
    }
    if (value is Uint8List) {
      return XmlElement(XmlName('data'))
        ..innerText = '\n' +
            RegExp('.{1,76}')
                .allMatches(base64.encode(value))
                .map((m) => m.group(0))
                .join('\n') +
            '\n';
    }
    if (value is List) {
      var e = XmlElement(XmlName('array'));

      value.forEach((value) {
        e.children.add(_toXmlElement(value));
      });
      return e;
    }
    if (value is bool) {
      return XmlElement(XmlName('$value'));
    }
    if (value is double) {
      return XmlElement(XmlName('real'))..innerText = '$value';
    }
    if (value is int) {
      return XmlElement(XmlName('integer'))..innerText = '$value';
    }
    if (value is String) {
      return XmlElement(XmlName('string'))..innerText = value;
    }
    if (value is DateTime) {
      return XmlElement(XmlName('date'))..innerText = value.toIso8601String();
    }
    throw UnsupportedError('Type ${value.runtimeType} not supported');
  }
}
