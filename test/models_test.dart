import 'package:flutter_test/flutter_test.dart';
import 'package:yokogaki/yokogaki.dart';

void main() {
  group('RubyText', () {
    test('should calculate endIndex correctly', () {
      const ruby = RubyText(startIndex: 0, length: 3, ruby: 'かんじ');
      expect(ruby.endIndex, 3);
    });

    test('should implement equality correctly', () {
      const ruby1 = RubyText(startIndex: 0, length: 3, ruby: 'かんじ');
      const ruby2 = RubyText(startIndex: 0, length: 3, ruby: 'かんじ');
      const ruby3 = RubyText(startIndex: 1, length: 3, ruby: 'かんじ');

      expect(ruby1, equals(ruby2));
      expect(ruby1, isNot(equals(ruby3)));
    });

    test('should have correct hashCode', () {
      const ruby1 = RubyText(startIndex: 0, length: 3, ruby: 'かんじ');
      const ruby2 = RubyText(startIndex: 0, length: 3, ruby: 'かんじ');

      expect(ruby1.hashCode, equals(ruby2.hashCode));
    });
  });

  group('Kenten', () {
    test('should calculate endIndex correctly', () {
      const kenten = Kenten(startIndex: 0, length: 5);
      expect(kenten.endIndex, 5);
    });

    test('should use sesame style by default', () {
      const kenten = Kenten(startIndex: 0, length: 1);
      expect(kenten.style, KentenStyle.sesame);
    });

    test('should implement equality correctly', () {
      const kenten1 = Kenten(startIndex: 0, length: 3, style: KentenStyle.filledCircle);
      const kenten2 = Kenten(startIndex: 0, length: 3, style: KentenStyle.filledCircle);
      const kenten3 = Kenten(startIndex: 0, length: 3, style: KentenStyle.circle);

      expect(kenten1, equals(kenten2));
      expect(kenten1, isNot(equals(kenten3)));
    });
  });

  group('Warichu', () {
    test('should calculate endIndex correctly', () {
      const warichu = Warichu(startIndex: 0, length: 1, text: '注釈テスト');
      expect(warichu.endIndex, 1);
    });

    test('should split text at middle when splitIndex is null', () {
      const warichu = Warichu(startIndex: 0, length: 1, text: '注釈テスト');
      expect(warichu.firstLine, '注釈テ');
      expect(warichu.secondLine, 'スト');
    });

    test('should split text at specified index', () {
      const warichu = Warichu(startIndex: 0, length: 1, text: '注釈テスト', splitIndex: 2);
      expect(warichu.firstLine, '注釈');
      expect(warichu.secondLine, 'テスト');
    });

    test('should implement equality correctly', () {
      const warichu1 = Warichu(startIndex: 0, length: 1, text: 'テスト');
      const warichu2 = Warichu(startIndex: 0, length: 1, text: 'テスト');
      const warichu3 = Warichu(startIndex: 0, length: 1, text: '異なる');

      expect(warichu1, equals(warichu2));
      expect(warichu1, isNot(equals(warichu3)));
    });
  });

  group('TextDecorationAnnotation', () {
    test('should calculate endIndex correctly', () {
      const decoration = TextDecorationAnnotation(startIndex: 0, length: 5);
      expect(decoration.endIndex, 5);
    });

    test('should use underline type by default', () {
      const decoration = TextDecorationAnnotation(startIndex: 0, length: 1);
      expect(decoration.type, TextDecorationLineType.underline);
    });

    test('should implement equality correctly', () {
      const decoration1 = TextDecorationAnnotation(
        startIndex: 0,
        length: 3,
        type: TextDecorationLineType.wavyUnderline,
      );
      const decoration2 = TextDecorationAnnotation(
        startIndex: 0,
        length: 3,
        type: TextDecorationLineType.wavyUnderline,
      );
      const decoration3 = TextDecorationAnnotation(
        startIndex: 0,
        length: 3,
        type: TextDecorationLineType.underline,
      );

      expect(decoration1, equals(decoration2));
      expect(decoration1, isNot(equals(decoration3)));
    });
  });

  group('HorizontalTextStyle', () {
    test('should have correct default values', () {
      const style = HorizontalTextStyle();

      expect(style.lineSpacing, 0.0);
      expect(style.characterSpacing, 0.0);
      expect(style.adjustYakumono, true);
      expect(style.enableKinsoku, true);
      expect(style.enableHalfWidthYakumono, true);
      expect(style.enableGyotoIndent, true);
      expect(style.enableKerning, true);
      expect(style.alignment, TextAlignment.center);
      expect(style.indent, 0);
      expect(style.firstLineIndent, 0);
    });

    test('copyWith should create new instance with updated values', () {
      const style = HorizontalTextStyle(indent: 1);
      final copied = style.copyWith(indent: 2, firstLineIndent: 1);

      expect(copied.indent, 2);
      expect(copied.firstLineIndent, 1);
      expect(style.indent, 1); // Original should be unchanged
    });

    test('copyWith should preserve unmodified values', () {
      const style = HorizontalTextStyle(
        lineSpacing: 5.0,
        characterSpacing: 2.0,
        indent: 1,
        firstLineIndent: 2,
      );
      final copied = style.copyWith(indent: 3);

      expect(copied.lineSpacing, 5.0);
      expect(copied.characterSpacing, 2.0);
      expect(copied.indent, 3);
      expect(copied.firstLineIndent, 2);
    });

    test('copyWith should handle all properties', () {
      const style = HorizontalTextStyle();
      final copied = style.copyWith(
        lineSpacing: 10.0,
        characterSpacing: 5.0,
        adjustYakumono: false,
        enableKinsoku: false,
        enableHalfWidthYakumono: false,
        enableGyotoIndent: false,
        enableKerning: false,
        alignment: TextAlignment.end,
        indent: 2,
        firstLineIndent: 1,
      );

      expect(copied.lineSpacing, 10.0);
      expect(copied.characterSpacing, 5.0);
      expect(copied.adjustYakumono, false);
      expect(copied.enableKinsoku, false);
      expect(copied.enableHalfWidthYakumono, false);
      expect(copied.enableGyotoIndent, false);
      expect(copied.enableKerning, false);
      expect(copied.alignment, TextAlignment.end);
      expect(copied.indent, 2);
      expect(copied.firstLineIndent, 1);
    });

    test('indent and firstLineIndent should be independent', () {
      const style1 = HorizontalTextStyle(indent: 2, firstLineIndent: 0);
      const style2 = HorizontalTextStyle(indent: 0, firstLineIndent: 2);
      const style3 = HorizontalTextStyle(indent: 2, firstLineIndent: 2);

      expect(style1.indent, 2);
      expect(style1.firstLineIndent, 0);
      expect(style2.indent, 0);
      expect(style2.firstLineIndent, 2);
      expect(style3.indent, 2);
      expect(style3.firstLineIndent, 2);
    });
  });

  group('HorizontalTextSpan', () {
    test('SimpleHorizontalTextSpan should calculate textLength correctly', () {
      const span = SimpleHorizontalTextSpan(text: 'テスト');
      expect(span.textLength, 3);
    });

    test('GroupHorizontalTextSpan should calculate textLength correctly', () {
      const span = GroupHorizontalTextSpan(
        children: [
          SimpleHorizontalTextSpan(text: 'こんにちは'),
          SimpleHorizontalTextSpan(text: '世界'),
        ],
      );
      expect(span.textLength, 7);
    });

    test('toTextSpanData should flatten span hierarchy', () {
      const span = GroupHorizontalTextSpan(
        children: [
          SimpleHorizontalTextSpan(text: 'A'),
          SimpleHorizontalTextSpan(text: 'B'),
        ],
      );

      final data = span.toTextSpanData();
      expect(data.length, 2);
      expect(data[0].text, 'A');
      expect(data[1].text, 'B');
    });

    test('TextSpanData.withOffset should update indices correctly', () {
      final data = TextSpanData(
        text: 'テスト',
        rubyList: [const RubyText(startIndex: 0, length: 2, ruby: 'てすと')],
        kentenList: [const Kenten(startIndex: 1, length: 1)],
        warichuList: [const Warichu(startIndex: 2, length: 1, text: '注')],
      );

      final offset = data.withOffset(10);

      expect(offset.rubyList[0].startIndex, 10);
      expect(offset.kentenList[0].startIndex, 11);
      expect(offset.warichuList[0].startIndex, 12);
    });
  });
}
