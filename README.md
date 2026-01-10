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

- **Ruby Text (ルビ/振り仮名)**: Furigana support (planned)
- **Kenten (圏点)**: Emphasis marks (planned)
- **Warichu (割注)**: Inline annotations (planned)
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
- [ ] Ruby text (furigana) support
- [ ] Kenten (emphasis marks)
- [ ] Warichu (inline annotations)
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
