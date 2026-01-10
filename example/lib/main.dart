import 'package:flutter/material.dart';
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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                RubyText(startIndex: 0, length: 2, ruby: 'かんじ'),
                RubyText(startIndex: 5, length: 2, ruby: 'むずか'),
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
                Kenten(startIndex: 0, length: 2, type: KentenType.sesame), // 重要
                Kenten(startIndex: 3, length: 2, type: KentenType.filledCircle), // 部分
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
                Kenten(startIndex: 0, length: 2, type: KentenType.sesame),
                Kenten(startIndex: 3, length: 2, type: KentenType.circle),
                Kenten(startIndex: 6, length: 2, type: KentenType.filledCircle),
                Kenten(startIndex: 9, length: 2, type: KentenType.triangle),
                Kenten(startIndex: 12, length: 3, type: KentenType.filledTriangle),
                Kenten(startIndex: 16, length: 3, type: KentenType.doubleCircle),
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
                Kenten(startIndex: 0, length: 2, type: KentenType.filledCircle),
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
                Warichu(startIndex: 3, length: 0, warichu: 'ここに注釈'),
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
                Warichu(startIndex: 7, length: 0, warichu: 'せつめいぶん'),
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
                Kenten(startIndex: 0, length: 2, type: KentenType.sesame),
              ],
              warichuList: const [
                Warichu(startIndex: 3, length: 0, warichu: 'ちゅう'),
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
                      Kenten(startIndex: 0, length: 2, type: KentenType.filledCircle),
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
                Kenten(startIndex: 2, length: 1, type: KentenType.filledCircle),
                Kenten(startIndex: 7, length: 1, type: KentenType.filledCircle),
                Kenten(startIndex: 12, length: 1, type: KentenType.filledCircle),
                Kenten(startIndex: 17, length: 1, type: KentenType.filledCircle),
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
                Kenten(startIndex: 0, length: 2, type: KentenType.sesame), // 吾輩
                Kenten(startIndex: 8, length: 2, type: KentenType.filledCircle), // 名前
                Kenten(startIndex: 19, length: 4, type: KentenType.sesame), // 生まれた
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
                Kenten(startIndex: 0, length: 2, type: KentenType.sesame), // 吾輩
                Kenten(startIndex: 8, length: 2, type: KentenType.filledCircle), // 名前
                Kenten(startIndex: 27, length: 2, type: KentenType.sesame), // 見当
              ],
              style: HorizontalTextStyle(
                baseStyle: const TextStyle(fontSize: 24),
                rubyStyle: const TextStyle(fontSize: 12, color: Colors.red),
                lineSpacing: 16.0,
              ),
              maxWidth: 400,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
