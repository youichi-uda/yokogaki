import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yokogaki/src/utils/text_metrics.dart';
import 'package:yokogaki/src/models/horizontal_text_style.dart';

void main() {
  group('TextMetrics', () {
    group('getCharacterWidth', () {
      test('should return half width for half-width yakumono when enabled', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          enableHalfWidthYakumono: true,
        );

        // 。and 、are half-width yakumono
        final width = TextMetrics.getCharacterWidth('。', style);
        expect(width, 8.0); // fontSize * 0.5
      });

      test('should return full width for half-width yakumono when disabled', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
          enableHalfWidthYakumono: false,
        );

        final width = TextMetrics.getCharacterWidth('。', style);
        expect(width, 16.0); // Full fontSize
      });

      test('should return full width for regular Japanese characters', () {
        const style = HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 16),
        );

        final width = TextMetrics.getCharacterWidth('あ', style);
        expect(width, 16.0); // Full fontSize
      });

      test('should use default fontSize when not specified', () {
        const style = HorizontalTextStyle();

        final width = TextMetrics.getCharacterWidth('あ', style);
        expect(width, 16.0); // Default fontSize is 16
      });
    });

    testWidgets('getTextHeight should return positive value', (tester) async {
      const style = TextStyle(fontSize: 24);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final height = TextMetrics.getTextHeight(style);
              expect(height, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
