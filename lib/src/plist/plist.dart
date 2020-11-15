import 'dart:io';

import 'package:xcodeproj/src/plist/plain_format.dart';
import 'package:xcodeproj/src/plist/xml_format.dart';
import 'package:path/path.dart' as path_lib;

class PList {
  final String path;

  final Map<String, dynamic> content;

  PList.load(this.path) : content = _load(File(path).readAsStringSync());

  static Map _load(String content) {
    if (content.startsWith('bplist')) {
      throw UnsupportedError('binary plist not supported');
    }

    if (content.startsWith('<?xml')) {
      return xmlPList.decode(content);
    }
    return plainPList.decode(content);
  }

  void save({String format}) {
    format ??= _formatFromExtension(path);

    switch (format) {
      case 'xml':
        File(path).writeAsStringSync(xmlPList.encode(content));
        break;
      case 'plain':
        File(path).writeAsStringSync(plainPList.encode(content));
        break;
    }
  }

  String _formatFromExtension(String path) {
    switch (path_lib.extension(path)) {
      case 'plist':
      case 'entitlements':
        return 'xml';
      case 'pbxproj':
        return 'plain';
    }
    throw UnsupportedError('Cannot determine the format for file $path');
  }
}
