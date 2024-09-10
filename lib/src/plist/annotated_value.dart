import 'dart:typed_data';
import 'plain_format.dart';

class AnnotatedValue {
  final dynamic value;

  final String? annotation;

  AnnotatedValue(this.value, [this.annotation]);

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(other) =>
      other is AnnotatedValue && other.toString() == toString();

  @override
  String toString() {
    return _toString('');
  }

  String _toString(String indent) {
    return _valueToString(indent) + _annotationToString();
  }

  String _annotationToString() {
    if (annotation == null) return '';
    return ' /*${annotation!}*/'; // TODO handle annotation containing '*/'
  }

  String _valueToString(String indent) {
    if (value is Uint8List) {
      return '<${(value as Uint8List).toHex()}>';
    }
    if (value is String) {
      if (RegExp(r'^[\w_$/:\.-]+$').hasMatch(value)) {
        return value;
      }
      var content = (value as String).replaceAllMapped(
          RegExp(r'[\n\r\t\\"]'),
          (match) => '\\${{
                '\n': 'n',
                '\r': 'r',
                '\t': 't',
                '\\': '\\',
                '"': '"',
              }[match.group(0)!]}');
      return '"$content"';
    }
    if (value is List<AnnotatedValue>) {
      return '(\n${(value as List<AnnotatedValue>).map((v) => '$indent  ${(v)._toString('$indent  ')}').join(',\n')}\n$indent)';
    }
    if (value is Map<AnnotatedValue, AnnotatedValue>) {
      return '{\n${(value as Map<AnnotatedValue, AnnotatedValue>).entries.map((e) => '$indent  ${e.key} = ${e.value._toString('$indent  ')};').join('\n')}\n$indent}';
    }
    if (value is DateTime) {
      return (value as DateTime).toIso8601String();
    }
    if (value is bool || value is num) {
      return value.toString();
    }
    throw UnsupportedError('Types ${value.runtimeType} not supported');
  }
}
