import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yokogaki/yokogaki.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yokogaki Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansJpTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextAlignment _alignment = TextAlignment.center;

  String get _alignmentLabel {
    switch (_alignment) {
      case TextAlignment.start:
        return '天付き（左揃え）';
      case TextAlignment.center:
        return '中央揃え';
      case TextAlignment.end:
        return '地付き（右揃え）';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yokogaki - 横書き Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Horizontal Text',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: 'これは横書きのテストです。',
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Character Spacing Test (字間テスト)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('characterSpacing: 0', style: TextStyle(color: Colors.grey)),
            Container(
              color: Colors.yellow.withValues(alpha: 0.3),
              child: HorizontalText(
                text: 'あいうえお',
                style: HorizontalTextStyle(
                  baseStyle: const TextStyle(fontSize: 24),
                  characterSpacing: 0,
                ),
                showGrid: true,
              ),
            ),
            const SizedBox(height: 8),
            const Text('characterSpacing: 8', style: TextStyle(color: Colors.grey)),
            Container(
              color: Colors.yellow.withValues(alpha: 0.3),
              child: HorizontalText(
                text: 'あいうえお',
                style: HorizontalTextStyle(
                  baseStyle: const TextStyle(fontSize: 24),
                  characterSpacing: 8,
                ),
                showGrid: true,
              ),
            ),
            const SizedBox(height: 8),
            const Text('characterSpacing: 16', style: TextStyle(color: Colors.grey)),
            Container(
              color: Colors.yellow.withValues(alpha: 0.3),
              child: HorizontalText(
                text: 'あいうえお',
                style: HorizontalTextStyle(
                  baseStyle: const TextStyle(fontSize: 24),
                  characterSpacing: 16,
                ),
                showGrid: true,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'With Line Breaking (maxWidth: 300)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: 'これは横書きのテストです。日本語の横書きレイアウトを実装しました。禁則処理も対応しています。',
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
              maxWidth: 300,
            ),
            const SizedBox(height: 32),
            const Text(
              'With Grid (Debug Mode)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: 'グリッド表示テスト',
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 32),
              ),
              showGrid: true,
            ),
            const SizedBox(height: 32),
            const Text(
              'With Punctuation (Kinsoku)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '吾輩は猫である。名前はまだ無い。どこで生まれたか頓と見当がつかぬ。',
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
              maxWidth: 350,
            ),
            const SizedBox(height: 32),
            const Text(
              'With Ruby (Furigana)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '日本語',
              rubyList: const [
                RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 32),
                rubyStyle: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Ruby with Line Breaking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '漢字はとても難しいです。',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'かんじ'), // 漢字
                RubyText(startIndex: 6, length: 1, ruby: 'むずか'), // 難
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
                rubyStyle: TextStyle(fontSize: 12, color: Colors.blue),
              ),
              maxWidth: 300,
            ),
            const SizedBox(height: 32),
            const Text(
              'With Kenten (Emphasis Marks)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '重要な部分を強調します。',
              kentenList: const [
                Kenten(startIndex: 0, length: 2, style: KentenStyle.sesame), // 重要
                Kenten(startIndex: 3, length: 2, style: KentenStyle.filledCircle), // 部分
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Kenten Types Showcase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: 'ゴマ 白丸 黒丸 三角 黒三角 二重丸',
              kentenList: const [
                Kenten(startIndex: 0, length: 2, style: KentenStyle.sesame),
                Kenten(startIndex: 3, length: 2, style: KentenStyle.circle),
                Kenten(startIndex: 6, length: 2, style: KentenStyle.filledCircle),
                Kenten(startIndex: 9, length: 2, style: KentenStyle.triangle),
                Kenten(startIndex: 12, length: 3, style: KentenStyle.filledTriangle),
                Kenten(startIndex: 16, length: 3, style: KentenStyle.doubleCircle),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Combined: Ruby + Kenten',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '重要な日本語を学びます。',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'じゅうよう'),
                RubyText(startIndex: 3, length: 3, ruby: 'にほんご'),
                RubyText(startIndex: 7, length: 2, ruby: 'まな'),
              ],
              kentenList: const [
                Kenten(startIndex: 0, length: 2, style: KentenStyle.filledCircle),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 26),
                rubyStyle: TextStyle(fontSize: 12, color: Colors.green),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'With Warichu (Inline Annotations)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '本文（注釈）の例です。',
              warichuList: const [
                Warichu(startIndex: 3, length: 0, text: 'ここに注釈'),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Warichu with Longer Text',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '日本語の文章（説明文）があります。',
              warichuList: const [
                Warichu(startIndex: 7, length: 0, text: 'せつめいぶん'),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'All Features Combined',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '重要（注）な文章です。',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'じゅうよう'),
              ],
              kentenList: const [
                Kenten(startIndex: 0, length: 2, style: KentenStyle.sesame),
              ],
              warichuList: const [
                Warichu(startIndex: 3, length: 0, text: 'ちゅう'),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 26),
                rubyStyle: TextStyle(fontSize: 12, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Rich Text - Multiple Styles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalRichText(
              span: GroupHorizontalTextSpan(
                children: [
                  SimpleHorizontalTextSpan(
                    text: 'これは',
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SimpleHorizontalTextSpan(
                    text: '重要',
                    style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                    kentenList: const [
                      Kenten(startIndex: 0, length: 2, style: KentenStyle.filledCircle),
                    ],
                  ),
                  SimpleHorizontalTextSpan(
                    text: 'な',
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SimpleHorizontalTextSpan(
                    text: 'テキスト',
                    style: const TextStyle(fontSize: 24, color: Colors.blue, fontStyle: FontStyle.italic),
                  ),
                  SimpleHorizontalTextSpan(
                    text: 'です。',
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ],
              ),
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Rich Text - With Ruby',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            HorizontalRichText(
              span: GroupHorizontalTextSpan(
                children: [
                  SimpleHorizontalTextSpan(
                    text: '日本語',
                    style: const TextStyle(fontSize: 28, color: Colors.black),
                    rubyList: const [
                      RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
                    ],
                  ),
                  SimpleHorizontalTextSpan(
                    text: 'は',
                    style: const TextStyle(fontSize: 28, color: Colors.black),
                  ),
                  SimpleHorizontalTextSpan(
                    text: '美しい',
                    style: const TextStyle(fontSize: 28, color: Colors.pink, fontWeight: FontWeight.bold),
                    rubyList: const [
                      RubyText(startIndex: 0, length: 3, ruby: 'うつく'),
                    ],
                  ),
                  SimpleHorizontalTextSpan(
                    text: 'です。',
                    style: const TextStyle(fontSize: 28, color: Colors.black),
                  ),
                ],
              ),
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
                rubyStyle: const TextStyle(fontSize: 14, color: Colors.deepOrange),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Selectable Text - Drag to Select',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap or drag to select text. Long press to copy.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SelectableHorizontalText(
              text: 'これは選択可能なテキストです。ドラッグして選択してください。',
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
              maxWidth: 350,
            ),
            const SizedBox(height: 32),
            const Text(
              'Selectable Text - With Ruby',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SelectableHorizontalText(
              text: '日本語の選択可能なテキスト',
              rubyList: const [
                RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
                RubyText(startIndex: 4, length: 4, ruby: 'せんたくかのう'),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
                rubyStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Line Spacing Test - Long Text',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Testing how kenten and ruby affect line spacing with multi-line text',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Debug: Character indices',
              style: TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '01234567890123456789',
              rubyList: const [
                RubyText(startIndex: 0, length: 1, ruby: '0'),
                RubyText(startIndex: 5, length: 1, ruby: '5'),
                RubyText(startIndex: 10, length: 1, ruby: 'A'),
                RubyText(startIndex: 15, length: 1, ruby: 'F'),
              ],
              kentenList: const [
                Kenten(startIndex: 2, length: 1, style: KentenStyle.filledCircle),
                Kenten(startIndex: 7, length: 1, style: KentenStyle.filledCircle),
                Kenten(startIndex: 12, length: 1, style: KentenStyle.filledCircle),
                Kenten(startIndex: 17, length: 1, style: KentenStyle.filledCircle),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24, color: Colors.grey),
                rubyStyle: const TextStyle(fontSize: 12, color: Colors.red),
                lineSpacing: 16.0,
              ),
              maxWidth: 400,
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Kenten only:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '吾輩は猫である。名前はまだ無い。どこで生まれたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。',
              kentenList: const [
                Kenten(startIndex: 0, length: 2, style: KentenStyle.sesame), // 吾輩
                Kenten(startIndex: 8, length: 2, style: KentenStyle.filledCircle), // 名前
                Kenten(startIndex: 19, length: 4, style: KentenStyle.sesame), // 生まれた
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
                lineSpacing: 16.0,
              ),
              maxWidth: 400,
            ),
            const SizedBox(height: 24),
            const Text(
              '2. Ruby only:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '吾輩は猫である。名前はまだ無い。どこで生まれたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'わがはい'), // 吾輩
                RubyText(startIndex: 3, length: 1, ruby: 'ねこ'), // 猫
                RubyText(startIndex: 8, length: 2, ruby: 'なまえ'), // 名前
                RubyText(startIndex: 27, length: 2, ruby: 'けんとう'), // 見当
                RubyText(startIndex: 37, length: 2, ruby: 'うすぐら'), // 薄暗
                RubyText(startIndex: 63, length: 2, ruby: 'きおく'), // 記憶
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
                rubyStyle: const TextStyle(fontSize: 12, color: Colors.red),
                lineSpacing: 16.0,
              ),
              maxWidth: 400,
            ),
            const SizedBox(height: 24),
            const Text(
              '3. Ruby + Kenten combined:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '吾輩は猫である。名前はまだ無い。どこで生まれたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'わがはい'), // 吾輩
                RubyText(startIndex: 3, length: 1, ruby: 'ねこ'), // 猫
                RubyText(startIndex: 8, length: 2, ruby: 'なまえ'), // 名前
                RubyText(startIndex: 27, length: 2, ruby: 'けんとう'), // 見当
                RubyText(startIndex: 37, length: 2, ruby: 'うすぐら'), // 薄暗
                RubyText(startIndex: 63, length: 2, ruby: 'きおく'), // 記憶
              ],
              kentenList: const [
                Kenten(startIndex: 0, length: 2, style: KentenStyle.sesame), // 吾輩
                Kenten(startIndex: 8, length: 2, style: KentenStyle.filledCircle), // 名前
                Kenten(startIndex: 27, length: 2, style: KentenStyle.sesame), // 見当
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
                rubyStyle: const TextStyle(fontSize: 12, color: Colors.red),
                lineSpacing: 16.0,
              ),
              maxWidth: 400,
            ),
            const SizedBox(height: 32),
            const Text(
              'Text Alignment (地付き)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Current: $_alignmentLabel',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _alignment = TextAlignment.start;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _alignment == TextAlignment.start
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  child: const Text('天付き'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _alignment = TextAlignment.center;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _alignment == TextAlignment.center
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  child: const Text('中央'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _alignment = TextAlignment.end;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _alignment == TextAlignment.end
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  child: const Text('地付き'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.grey.shade50,
              ),
              child: HorizontalText(
                text: '吾輩は猫である。\n名前はまだ無い。\nどこで生まれたか\n頓と見当がつかぬ。',
                style: HorizontalTextStyle(
                  baseStyle: const TextStyle(fontSize: 24),
                  alignment: _alignment,
                ),
                maxWidth: 350,
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 500,
              child: Text(
                '説明：\n'
                '• 天付き：各行を左端に揃えます\n'
                '• 中央揃え：各行を中央に配置します\n'
                '• 地付き：各行を右端に揃えます',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Text Decorations (下線・上線)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Underline Types:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('下線', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      HorizontalText(
                        text: '重要な文章',
                        decorationList: const [
                          TextDecorationAnnotation(
                            startIndex: 0,
                            length: 2,
                            type: TextDecorationLineType.underline,
                          ),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('二重下線', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      HorizontalText(
                        text: '重要な文章',
                        decorationList: const [
                          TextDecorationAnnotation(
                            startIndex: 0,
                            length: 2,
                            type: TextDecorationLineType.doubleUnderline,
                          ),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('波下線', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      HorizontalText(
                        text: '重要な文章',
                        decorationList: const [
                          TextDecorationAnnotation(
                            startIndex: 0,
                            length: 2,
                            type: TextDecorationLineType.wavyUnderline,
                          ),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('点線下線', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      HorizontalText(
                        text: '重要な文章',
                        decorationList: const [
                          TextDecorationAnnotation(
                            startIndex: 0,
                            length: 2,
                            type: TextDecorationLineType.dottedUnderline,
                          ),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '2. Overline Types:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('上線', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      HorizontalText(
                        text: '重要な文章',
                        decorationList: const [
                          TextDecorationAnnotation(
                            startIndex: 0,
                            length: 2,
                            type: TextDecorationLineType.overline,
                          ),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('波上線', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      HorizontalText(
                        text: '重要な文章',
                        decorationList: const [
                          TextDecorationAnnotation(
                            startIndex: 0,
                            length: 2,
                            type: TextDecorationLineType.wavyOverline,
                          ),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '3. Colored Decoration:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '赤い下線と青い下線の例',
              decorationList: const [
                TextDecorationAnnotation(
                  startIndex: 0,
                  length: 2,
                  type: TextDecorationLineType.underline,
                  color: Colors.red,
                  thickness: 2.0,
                ),
                TextDecorationAnnotation(
                  startIndex: 5,
                  length: 2,
                  type: TextDecorationLineType.underline,
                  color: Colors.blue,
                  thickness: 2.0,
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '4. Combined with Ruby:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '東京は首都です',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'とうきょう'),
                RubyText(startIndex: 3, length: 2, ruby: 'しゅと'),
              ],
              decorationList: const [
                TextDecorationAnnotation(
                  startIndex: 3,
                  length: 2,
                  type: TextDecorationLineType.underline,
                  color: Colors.red,
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
                rubyStyle: const TextStyle(fontSize: 14, color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '5. Ruby + Overline:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '重要な言葉を強調',
              rubyList: const [
                RubyText(startIndex: 0, length: 2, ruby: 'じゅうよう'),
                RubyText(startIndex: 3, length: 2, ruby: 'ことば'),
                RubyText(startIndex: 6, length: 2, ruby: 'きょうちょう'),
              ],
              decorationList: const [
                TextDecorationAnnotation(
                  startIndex: 0,
                  length: 2,
                  type: TextDecorationLineType.overline,
                  color: Colors.blue,
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
                rubyStyle: const TextStyle(fontSize: 14, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '6. Ruby + Wavy Overline:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '日本語の勉強は楽しい',
              rubyList: const [
                RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
                RubyText(startIndex: 4, length: 2, ruby: 'べんきょう'),
                RubyText(startIndex: 7, length: 2, ruby: 'たの'),
              ],
              decorationList: const [
                TextDecorationAnnotation(
                  startIndex: 4,
                  length: 2,
                  type: TextDecorationLineType.wavyOverline,
                  color: Colors.orange,
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
                rubyStyle: const TextStyle(fontSize: 14, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'SelectionArea Integration (Selection API)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use with SelectionArea to select across multiple widgets',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectableText(
                      '通常の SelectableText',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: SelectionAreaHorizontalText(
                        text: '日本語の横書きテキスト',
                        rubyList: const [
                          RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
                          RubyText(startIndex: 4, length: 3, ruby: 'よこがき'),
                        ],
                        style: HorizontalTextStyle(
                          baseStyle: const TextStyle(fontSize: 24, color: Colors.black),
                          rubyStyle: const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SelectableText(
                      '上下のテキストをドラッグで一括選択できます。',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Gaiji (外字 - Custom Character Images)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Replace placeholder characters with custom images. Example: 挿 → 插 (old form)',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            HorizontalText(
              text: '「〓入」の旧字体の例',
              gaijiList: const [
                Gaiji(
                  startIndex: 1, // 「〓」の位置
                  image: AssetImage('assets/image.png'),
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Long text with gaiji in middle:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '日本語の文章の中に〓入という旧字体を使った例文です。',
              gaijiList: const [
                Gaiji(
                  startIndex: 9, // 「〓」の位置（0から数えて9番目）
                  image: AssetImage('assets/image.png'),
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
              showGrid: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Multi-line text (maxWidth: 300):',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: '昔々あるところに、〓入という技術を持つ職人がいました。その職人は毎日丁寧に仕事をしていました。',
              gaijiList: const [
                Gaiji(
                  startIndex: 9, // 「〓」の位置（0から数えて9番目）
                  image: AssetImage('assets/image.png'),
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
              maxWidth: 300,
              showGrid: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Small font (18px):',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: 'この文章には〓入という外字が含まれています。',
              gaijiList: const [
                Gaiji(
                  startIndex: 6, // 「〓」の位置
                  image: AssetImage('assets/image.png'),
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 18),
              ),
              showGrid: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gaiji after line break (2nd line):',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: 'あいうえおかきくけこ〓入さしすせそ', // 〓は10番目
              gaijiList: const [
                Gaiji(
                  startIndex: 10, // 「〓」の位置（0から数えて10番目）
                  image: AssetImage('assets/image.png'),
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 28),
              ),
              maxWidth: 200, // 狭いmaxWidthで強制的に改行
              showGrid: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gaiji on 3rd line:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            HorizontalText(
              text: 'あいうえおかきくけこさしすせそたちつてと〓入なにぬねの', // 〓は20番目
              gaijiList: const [
                Gaiji(
                  startIndex: 20, // 「〓」の位置（0から数えて20番目）
                  image: AssetImage('assets/image.png'),
                ),
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
              ),
              maxWidth: 200, // 狭いmaxWidthで複数行に
              showGrid: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
