import 'dart:typed_data';

import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'package:xcodeproj/src/plist/annotated_value.dart';
import 'package:xcodeproj/src/plist/plain_format_parser.dart';

void main() {
  group('PList plain format parser', () {
    var grammar = PListGrammarDefinition();

    void shouldSucceed(Parser parser, String v, [dynamic expectedValue]) {
      var r = parser.parse(v);

      expect(r.isSuccess, isTrue);
      expect(r.value, expectedValue ?? v);
    }

    group('Parsing unquoted strings', () {
      var parser = grammar.unquotedString();

      test('Parsing string without special characters', () {
        shouldSucceed(parser, 'TEST');
      });
      test('Parsing string that starts with `\$`', () {
        shouldSucceed(parser, '\$PROJECT_DIR/mogenerator/mogenerator');
      });
      test('Parsing string with any valid char', () {
        var abc = 'abcdefghijklmnopqrstuvwxyz';
        shouldSucceed(parser, '$abc${abc.toUpperCase()}_\$/:.-');
      });
    });
    group('Parsing quoted strings', () {
      var parser = grammar.quotedString();

      test('Parsing single quoted string', () {
        shouldSucceed(parser, '\'"hello" \\\'world\\\'\'', '"hello" \'world\'');
      });

      test('Parsing double quoted string', () {
        var string = '"\\"hello\\" \'world\'"';
        shouldSucceed(parser, string, '"hello" \'world\'');
        var parsed = parser.parse(string).value;
        expect(AnnotatedValue(parsed).toString(), string);
      });
    });
    group('Parsing data', () {
      var parser = grammar.data();
      test('Parsing data', () {
        shouldSucceed(parser, '<0001 aB AB Cf 99 7 c >',
            Uint8List.fromList([0, 1, 0xab, 0xab, 0xcf, 0x99, 0x7c]));
      });
    });
    group('Parsing comments', () {
      var parser = grammar.comment();
      test('Parsing single line comment', () {
        shouldSucceed(parser, '// this is a single line comment',
            ' this is a single line comment');
      });
      test('Parsing multi line comment', () {
        shouldSucceed(parser, '/* this is a \n multi line comment\n*/',
            ' this is a \n multi line comment\n');
      });
    });

    group('Parsing annotated value', () {
      var parser = grammar.build(arguments: grammar.annotatedValue().children);

      test('Parsing annotated value with single annotation', () {
        shouldSucceed(
            parser, 'a /*annotation*/', AnnotatedValue('a', 'annotation'));
        shouldSucceed(parser, 'b /*another annotation*/',
            AnnotatedValue('b', 'another annotation'));
      });
      test('Parsing annotated value with multiple annotations', () {
        shouldSucceed(parser, 'a /*annotation1*/ /*annotation2*/',
            AnnotatedValue('a', 'annotation2'));
        shouldSucceed(parser, 'b //annotation3\n//annotation4\n',
            AnnotatedValue('b', 'annotation4'));
      });
      test('Parsing annotated value without annotations', () {
        shouldSucceed(parser, 'a ', AnnotatedValue('a'));
        shouldSucceed(parser, 'b   ', AnnotatedValue('b'));
      });
    });

    group('Parsing arrays', () {
      final array = grammar.array();

      var parser = grammar.build(arguments: array.children);
      test('Parsing empty array', () {
        shouldSucceed(parser, '()', []);
      });

      test('Parsing array without trailing comma', () {
        shouldSucceed(parser, '(\n\tIDENTIFIER,\nANOTHER_IDENTIFIER)', [
          AnnotatedValue('IDENTIFIER'),
          AnnotatedValue('ANOTHER_IDENTIFIER')
        ]);
      });

      test('Parsing array with trailing comma', () {
        shouldSucceed(
            parser, '( A, B, )', [AnnotatedValue('A'), AnnotatedValue('B')]);
        shouldSucceed(
            parser, '(A,B,)', [AnnotatedValue('A'), AnnotatedValue('B')]);
        shouldSucceed(parser, '( A , B, /* comment!*/ )',
            [AnnotatedValue('A'), AnnotatedValue('B')]);
        shouldSucceed(parser, '''(
                A,
                B,
              )''', [AnnotatedValue('A'), AnnotatedValue('B')]);
        shouldSucceed(parser, '''(
                A,
                B,
                // comment! C,
              )''', [AnnotatedValue('A'), AnnotatedValue('B')]);
      });
    });

    group('Parsing dictionaries', () {
      var parser = grammar.build(arguments: grammar.dictionary().children);
      test('Parsing an empty dictionary', () {
        shouldSucceed(parser, '{}', {});
        shouldSucceed(parser, '\t\n\t{\n\t\n}', {});
      });

      test('Parsing a dictionary without comments', () {
        shouldSucceed(parser, '{a = "a";"b" = b;"c" = "c";   d = d;}', {
          AnnotatedValue('a'): AnnotatedValue('a'),
          AnnotatedValue('b'): AnnotatedValue('b'),
          AnnotatedValue('c'): AnnotatedValue('c'),
          AnnotatedValue('d'): AnnotatedValue('d'),
        });
      });
      test('Parsing a dictionary with comments', () {
        shouldSucceed(parser, '{ /* comment */ k  = v; }',
            {AnnotatedValue('k'): AnnotatedValue('v')});
        shouldSucceed(parser, '{ k  = /* comment */ v; }',
            {AnnotatedValue('k'): AnnotatedValue('v')});
        shouldSucceed(parser, '{ k  = v /* comment */ /* annotation */ ; }',
            {AnnotatedValue('k'): AnnotatedValue('v', ' annotation ')});
        shouldSucceed(parser, '{ k  = v; /* comment */ }',
            {AnnotatedValue('k'): AnnotatedValue('v')});
      });
    });
  });
}
