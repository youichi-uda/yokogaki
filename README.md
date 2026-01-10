# yokogaki

Flutter package for Japanese horizontal text (yokogaki - 横書き) layout with advanced typography features including ruby, kenten, warichu, and rich text support.

## Features

- **Kinsoku Processing (禁則処理)**: Japanese line breaking rules
  - Line-start prohibition (行頭禁則, gyoto kinsoku)
  - Line-end prohibition (行末禁則, gyomatsu kinsoku)
  - Hanging characters (ぶら下げ, burasage)
  - Pushing-in characters (追い込み, oikomi)

- **Yakumono Adjustment (約物調整)**: Fine-tune punctuation positioning
  - Half-width yakumono handling
  - Gyoto indent for opening brackets
  - Consecutive yakumono spacing

- **Ruby Text (ルビ/振り仮名)**: Furigana support
  - Place ruby text above base characters
  - Multi-line ruby support (splits across line breaks)
  - Customizable ruby style

- **Kenten (圏点)**: Emphasis marks
  - 6 types of emphasis marks (sesame, circles, triangles)
  - Place marks above characters for emphasis
  - Customizable kenten style
  - Combine with ruby text

- **Warichu (割注)**: Inline annotations
  - Two-line inline annotations
  - Automatically splits text into two rows
  - Displayed inline with main text
  - Combine with ruby and kenten

- **Rich Text**: Multiple styles in one text block (planned)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  yokogaki: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Horizontal Text

```dart
import 'package:flutter/material.dart';
import 'package:yokogaki/yokogaki.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HorizontalText(
      text: 'これは横書きのテストです。',
      style: HorizontalTextStyle(
        baseStyle: TextStyle(fontSize: 24),
      ),
    );
  }
}
```

### With Line Breaking

```dart
HorizontalText(
  text: '吾輩は猫である。名前はまだ無い。どこで生まれたか頓と見当がつかぬ。',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 24),
  ),
  maxWidth: 300,  // Enable line breaking at 300px
)
```

### With Kinsoku Processing

```dart
HorizontalText(
  text: '日本語の横書きレイアウトを実装しました。禁則処理も対応しています。',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 20),
    enableKinsoku: true,  // Enable kinsoku processing (default: true)
  ),
  maxWidth: 350,
)
```

### With Ruby Text (Furigana)

```dart
HorizontalText(
  text: '日本語',
  rubyList: const [
    RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 32),
    rubyStyle: TextStyle(fontSize: 14, color: Colors.red),
  ),
)
```

### Ruby with Line Breaking

```dart
HorizontalText(
  text: '漢字はとても難しいです。',
  rubyList: const [
    RubyText(startIndex: 0, length: 2, ruby: 'かんじ'),
    RubyText(startIndex: 5, length: 2, ruby: 'むずか'),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 24),
    rubyStyle: TextStyle(fontSize: 12, color: Colors.blue),
  ),
  maxWidth: 300,
)
```

### With Kenten (Emphasis Marks)

```dart
HorizontalText(
  text: '重要な部分を強調します。',
  kentenList: const [
    Kenten(startIndex: 0, length: 2, type: KentenType.sesame),
    Kenten(startIndex: 5, length: 2, type: KentenType.filledCircle),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 28),
  ),
)
```

### Kenten Types

```dart
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
    baseStyle: TextStyle(fontSize: 28),
  ),
)
```

### Combined Ruby and Kenten

```dart
HorizontalText(
  text: '重要な日本語を学びます。',
  rubyList: const [
    RubyText(startIndex: 0, length: 2, ruby: 'じゅうよう'),
    RubyText(startIndex: 3, length: 3, ruby: 'にほんご'),
  ],
  kentenList: const [
    Kenten(startIndex: 0, length: 2, type: KentenType.filledCircle),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 26),
    rubyStyle: TextStyle(fontSize: 12, color: Colors.green),
  ),
)
```

### With Warichu (Inline Annotations)

```dart
HorizontalText(
  text: '本文（注釈）の例です。',
  warichuList: const [
    Warichu(startIndex: 3, length: 0, warichu: 'ここに注釈'),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 28),
  ),
)
```

### All Features Combined

```dart
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
    baseStyle: TextStyle(fontSize: 26),
    rubyStyle: TextStyle(fontSize: 12, color: Colors.purple),
  ),
)
```

### Debug Grid

```dart
HorizontalText(
  text: 'グリッド表示テスト',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 32),
  ),
  showGrid: true,  // Show character grid for debugging
)
```

## Example

See the [example](example/) directory for a complete demo app showcasing all features.

## Roadmap

- [x] Basic horizontal text layout
- [x] Kinsoku processing
- [x] Yakumono adjustment
- [x] Line breaking with kinsoku rules
- [x] Ruby text (furigana) support
- [x] Kenten (emphasis marks)
- [x] Warichu (inline annotations)
- [ ] Rich text with multiple styles
- [ ] Text selection support

## Related Packages

- [kinsoku](https://pub.dev/packages/kinsoku): Japanese text processing library (line breaking, character classification)
- [tategaki](https://pub.dev/packages/tategaki): Vertical Japanese text layout

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## References

- [JIS X 4051:2004](https://kikakurui.com/x4/X4051-2004-02.html) - Japanese document composition method
- [W3C Requirements for Japanese Text Layout (JLREQ)](https://w3c.github.io/jlreq/)
- [CSS Text Module Level 3/4](https://www.w3.org/TR/css-text-3/)
