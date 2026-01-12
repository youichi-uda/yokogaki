import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yokogaki/yokogaki.dart';

void main() {
  group('HorizontalText widget', () {
    testWidgets('should render without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalText(
              text: 'テスト',
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalText), findsOneWidget);
    });

    testWidgets('should render with custom style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalText(
              text: 'スタイルテスト',
              style: HorizontalTextStyle(
                baseStyle: TextStyle(fontSize: 24, color: Colors.blue),
                lineSpacing: 8,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalText), findsOneWidget);
    });

    testWidgets('should render with ruby annotations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalText(
              text: '漢字',
              rubyList: [
                RubyText(startIndex: 0, length: 2, ruby: 'かんじ'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalText), findsOneWidget);
    });

    testWidgets('should render with kenten annotations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalText(
              text: '強調',
              kentenList: [
                Kenten(startIndex: 0, length: 2),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalText), findsOneWidget);
    });

    testWidgets('should render with warichu annotations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalText(
              text: '本文*',
              warichuList: [
                Warichu(startIndex: 2, length: 1, text: '注釈文'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalText), findsOneWidget);
    });

    testWidgets('should render with decoration annotations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalText(
              text: '下線テスト',
              decorationList: [
                TextDecorationAnnotation(
                  startIndex: 0,
                  length: 2,
                  type: TextDecorationLineType.underline,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalText), findsOneWidget);
    });
  });

  group('HorizontalRichText widget', () {
    testWidgets('should render without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalRichText(
              span: SimpleHorizontalTextSpan(text: 'リッチテキスト'),
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalRichText), findsOneWidget);
    });

    testWidgets('should render with multiple spans', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalRichText(
              span: GroupHorizontalTextSpan(
                children: [
                  SimpleHorizontalTextSpan(
                    text: '赤',
                    style: TextStyle(color: Colors.red),
                  ),
                  SimpleHorizontalTextSpan(
                    text: '青',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalRichText), findsOneWidget);
    });

    testWidgets('should render with span-level annotations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalRichText(
              span: SimpleHorizontalTextSpan(
                text: '漢字',
                rubyList: [
                  RubyText(startIndex: 0, length: 2, ruby: 'かんじ'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalRichText), findsOneWidget);
    });
  });

  group('SelectableHorizontalText widget', () {
    testWidgets('should render without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SelectableHorizontalText(
              text: '選択可能テキスト',
            ),
          ),
        ),
      );

      expect(find.byType(SelectableHorizontalText), findsOneWidget);
    });

    testWidgets('should have focus node', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SelectableHorizontalText(
              text: 'フォーカステスト',
            ),
          ),
        ),
      );

      // Find the SelectableHorizontalText widget (which contains a Focus internally)
      expect(find.byType(SelectableHorizontalText), findsOneWidget);
      // At least one Focus widget should exist
      expect(find.byType(Focus), findsWidgets);
    });
  });

  group('SelectionAreaHorizontalText widget', () {
    testWidgets('should render without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionArea(
              child: const SelectionAreaHorizontalText(
                text: 'セレクションエリア',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SelectionAreaHorizontalText), findsOneWidget);
    });

    testWidgets('should work outside SelectionArea', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SelectionAreaHorizontalText(
              text: 'スタンドアローン',
            ),
          ),
        ),
      );

      expect(find.byType(SelectionAreaHorizontalText), findsOneWidget);
    });
  });
}
