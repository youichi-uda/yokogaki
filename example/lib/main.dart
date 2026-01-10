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
                Kenten(startIndex: 0, length: 2, type: KentenType.sesame),
                Kenten(startIndex: 5, length: 2, type: KentenType.filledCircle),
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
          ],
        ),
      ),
    );
  }
}
