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
          ],
        ),
      ),
    );
  }
}
