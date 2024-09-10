import 'dart:typed_data';

import 'package:petitparser/petitparser.dart';

import 'annotated_value.dart';
import 'plain_format.dart';

class PListGrammarDefinition extends GrammarDefinition {
  @override
  Parser start() => ref0(annotatedValue).end();

  Parser<String> unquotedString() =>
      (word() | anyOf(r'_$/:\.-')).plus().flatten();

  Parser<String> singleQuotedString() => _quotedString(char("'"));
  Parser<String> doubleQuotedString() => _quotedString(char('"'));
  Parser<String> quotedString() =>
      (singleQuotedString() | doubleQuotedString()).cast();

  Parser<String> _quotedString(Parser quote) => (quote &
          ((quote | anyOf('\n\r\\')).neg() |
                  (char(r'\') &
                          any().map(
                              (v) => {'n': '\n', 'r': '\r', 't': '\t'}[v] ?? v))
                      .pick(1))
              .star()
              .map((l) => l.join()) &
          quote)
      .pick(1)
      .cast();

  Parser<Uint8List> data() => (char('<') &
              (digit() | pattern('a-f') | pattern('A-F') | char(' '))
                  .star()
                  .flatten() &
              char('>'))
          .pick(1)
          .cast<String>()
          .map((v) => v.replaceAll(' ', ''))
          .map((v) {
        if (v.length % 2 != 0) {
          throw FormatException('Data has an uneven number of hex digits');
        }
        return Hex.parse(v);
      });

  Parser<String> singleLineComment() =>
      (string('//') & newline().neg().star().flatten()).pick(1).cast();

  Parser<String> multiLineComment() =>
      (string('/*') & string('*/').neg().star().flatten() & string('*/'))
          .pick(1)
          .cast();

  Parser<String> comment() => (singleLineComment() | multiLineComment()).cast();

  Parser value() =>
      ref0(dictionary) | array() | data() | quotedString() | unquotedString();

  Parser<AnnotatedValue> annotatedValue() =>
      (value() & comment().trim().star()).map((l) {
        var v = l[0];
        var annotations = l[1];
        var annotation = annotations.isEmpty ? null : annotations.last;
        return AnnotatedValue(v, annotation);
      });

  Parser<Map<AnnotatedValue, AnnotatedValue>> dictionary() => (token('{') &
          keyValue()
              .plusSeparated(token(';'))
              .map((l) =>
                  Map<AnnotatedValue, AnnotatedValue>.fromEntries(l.elements))
              .optionalWith(<AnnotatedValue, AnnotatedValue>{}) &
          token(';').optional() &
          token('}'))
      .pick(1)
      .cast();

  Parser<MapEntry<AnnotatedValue, AnnotatedValue>> keyValue() =>
      (ref0(annotatedValue) & token('=') & ref0(annotatedValue))
          .map((l) => MapEntry<AnnotatedValue, AnnotatedValue>(l[0], l[2]));

  Parser<List<AnnotatedValue>> array() => (token('(') &
          (ref0(annotatedValue)
              .plusSeparated(token(','))
              .map((l) => l.elements)
              .optionalWith(<AnnotatedValue>[])) &
          token(',').optional() &
          token(')'))
      .pick(1)
      .cast();

  Parser newline() => pattern('\n\r');

  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim(whitespace() | comment());
    } else if (input is String) {
      return token(input.toParser());
    } else if (input is Parser Function()) {
      return token(ref0(input));
    }
    throw ArgumentError.value(input, 'invalid token parser');
  }
}
