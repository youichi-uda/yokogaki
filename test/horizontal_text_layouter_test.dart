import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yokogaki/src/rendering/horizontal_text_layouter.dart';
import 'package:yokogaki/src/models/horizontal_text_style.dart';
import 'package:yokogaki/src/utils/layout_cache.dart';

void main() {
  setUp(() {
    LayoutCache.clear();
  });

  group('HorizontalTextLayouter', () {
    group('layout', () {
      test('should return empty list for empty text', () {
        const style = HorizontalTextStyle();
        final layouts = HorizontalTextLayouter.layout(
          text: '',
          style: style,
        );

        expect(layouts, isEmpty);
      });

      test('should create layout for each character', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あいう',
          style: style,
          useCache: false,
        );

        expect(layouts.length, 3);
        expect(layouts[0].character, 'あ');
        expect(layouts[1].character, 'い');
        expect(layouts[2].character, 'う');
      });

      test('should assign correct textIndex to each character', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'テスト',
          style: style,
          useCache: false,
        );

        expect(layouts[0].textIndex, 0);
        expect(layouts[1].textIndex, 1);
        expect(layouts[2].textIndex, 2);
      });

      test('should position characters horizontally', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          characterSpacing: 0,
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あい',
          style: style,
          useCache: false,
        );

        // First character at origin
        expect(layouts[0].position.dx, 0);
        expect(layouts[0].position.dy, 0);

        // Second character should be to the right
        expect(layouts[1].position.dx, 16); // fontSize
        expect(layouts[1].position.dy, 0);
      });

      test('should apply indent to all lines', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          indent: 2,
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あ',
          style: style,
          useCache: false,
        );

        // With indent=2, first character should be at 2 * fontSize = 32
        expect(layouts[0].position.dx, 32);
      });

      test('should apply firstLineIndent only to first line', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          firstLineIndent: 1,
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あ\nい',
          style: style,
          useCache: false,
        );

        // First line with firstLineIndent
        expect(layouts[0].position.dx, 16); // 1 * fontSize

        // Second line without firstLineIndent
        expect(layouts[1].position.dx, 0);
      });

      test('should apply both indent and firstLineIndent to first line', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          indent: 1,
          firstLineIndent: 2,
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あ\nい',
          style: style,
          useCache: false,
        );

        // First line: indent + firstLineIndent = 1 + 2 = 3 characters
        expect(layouts[0].position.dx, 48); // 3 * fontSize

        // Second line: only indent = 1 character
        expect(layouts[1].position.dx, 16); // 1 * fontSize
      });

      test('firstLineIndent should not affect lines after line wrap', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          firstLineIndent: 2,
          enableKinsoku: false, // Disable kinsoku for predictable wrapping
        );
        // With firstLineIndent=2, first line starts at X=32
        // maxWidth=48 means only ~1 character fits (48-32=16)
        final layouts = HorizontalTextLayouter.layout(
          text: 'あいう',
          style: style,
          maxWidth: 48,
          useCache: false,
        );

        // First line has firstLineIndent = 2 * 16 = 32
        expect(layouts[0].position.dx, 32);

        // Find characters on second line
        final firstLineY = layouts[0].position.dy;
        final secondLineLayouts = layouts.where(
          (l) => l.position.dy > firstLineY,
        ).toList();

        // Second line should NOT have firstLineIndent (should be less than first line)
        if (secondLineLayouts.isNotEmpty) {
          expect(secondLineLayouts[0].position.dx, lessThan(32));
        }
      });

      test('indent should apply to all lines including wrapped ones', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          indent: 1,
          enableKinsoku: false,
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あい',
          style: style,
          maxWidth: 32, // Allow only 1 char per line with indent
          useCache: false,
        );

        // First line: starts at indent = 16
        expect(layouts[0].position.dx, 16);

        // Second line: also starts at indent = 16 (same indent as first line)
        // Both lines should have the same starting X position
        expect(layouts[1].position.dx, layouts[0].position.dx);
      });

      test('should apply characterSpacing between characters', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          characterSpacing: 4,
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あい',
          style: style,
          useCache: false,
        );

        // Second character should be at fontSize + characterSpacing
        expect(layouts[1].position.dx, 20); // 16 + 4
      });

      test('should skip newline characters', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あ\nい',
          style: style,
          useCache: false,
        );

        // Should have 2 character layouts (newline is skipped)
        expect(layouts.length, 2);
        expect(layouts[0].character, 'あ');
        expect(layouts[1].character, 'い');
      });

      test('should wrap text when exceeding maxWidth', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );
        final layouts = HorizontalTextLayouter.layout(
          text: 'あいうえお',
          style: style,
          maxWidth: 48, // 3 characters wide
          useCache: false,
        );

        // First 3 characters should be on first line (Y=0)
        expect(layouts[0].position.dy, 0);
        expect(layouts[1].position.dy, 0);
        expect(layouts[2].position.dy, 0);

        // Remaining characters should be on second line
        expect(layouts[3].position.dy, greaterThan(0));
        expect(layouts[4].position.dy, greaterThan(0));
      });

      test('should use cache when enabled', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );

        // First call should populate cache
        HorizontalTextLayouter.layout(
          text: 'テスト',
          style: style,
          useCache: true,
        );

        final stats = LayoutCache.getStats();
        expect(stats['size'], 1);

        // Second call should use cache
        HorizontalTextLayouter.layout(
          text: 'テスト',
          style: style,
          useCache: true,
        );

        // Cache size should still be 1
        expect(LayoutCache.getStats()['size'], 1);
      });

      test('should not use cache when disabled', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );

        HorizontalTextLayouter.layout(
          text: 'テスト',
          style: style,
          useCache: false,
        );

        expect(LayoutCache.getStats()['size'], 0);
      });
    });

    group('calculateSize', () {
      test('should return zero size for empty text', () {
        const style = HorizontalTextStyle();
        final size = HorizontalTextLayouter.calculateSize(
          text: '',
          style: style,
        );

        expect(size, Size.zero);
      });

      test('should calculate correct size for single character', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );
        final size = HorizontalTextLayouter.calculateSize(
          text: 'あ',
          style: style,
          useCache: false,
        );

        expect(size.width, 16);
        expect(size.height, greaterThan(0));
      });

      test('should calculate correct width for multiple characters', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );
        final size = HorizontalTextLayouter.calculateSize(
          text: 'あいう',
          style: style,
          useCache: false,
        );

        expect(size.width, 48); // 3 * fontSize
      });
    });
  });
}
