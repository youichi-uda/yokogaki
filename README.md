# yokogaki

[![pub package](https://img.shields.io/pub/v/yokogaki.svg)](https://pub.dev/packages/yokogaki)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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
  - Multiple styles: sesame, circles, triangles, squares, stars, diamonds, X marks
  - Place marks above characters for emphasis
  - Customizable kenten style
  - Combine with ruby text

- **Warichu (割注)**: Inline annotations
  - Two-line inline annotations
  - Automatically splits text into two rows
  - Displayed inline with main text
  - Combine with ruby and kenten

- **Text Decoration (上線/下線)**: Underline and overline support
  - Single line, double line, wavy line, dotted line
  - Works with ruby (automatic position adjustment)

- **Text Alignment (地付き)**: Line-level alignment
  - `TextAlignment.start`: Align to left (default)
  - `TextAlignment.center`: Center alignment
  - `TextAlignment.end` (地付き): Align to right

- **Text Indentation (字下げ)**: Character-based indentation
  - `indent`: Indent all lines (全行字下げ)
  - `firstLineIndent`: Indent first line only (段落字下げ)

- **Rich Text**: Multiple styles in one text block
  - Span-based architecture for hierarchical text
  - Mix multiple colors, fonts, sizes, and weights
  - Per-span ruby, kenten, and warichu annotations
  - Powerful text composition with `SimpleHorizontalTextSpan` and `GroupHorizontalTextSpan`

- **Text Selection**: Interactive text selection
  - Tap to select single character
  - Drag to select text range
  - Draggable selection handles
  - Context menu with copy/select all
  - Keyboard shortcuts (Ctrl+C, Ctrl+A)
  - Customizable selection color
  - Full support for all typography features

## Related Packages

This package is part of the Japanese text layout suite:

| Package | Description |
|---------|-------------|
| [kinsoku](https://pub.dev/packages/kinsoku) | Core text processing (line breaking, character classification) |
| [tategaki](https://pub.dev/packages/tategaki) | Vertical text layout (縦書き) |
| **yokogaki** | Horizontal text layout (this package) |

## Quick Start

3ステップで横書きテキストを表示:

```dart
// 1. Import
import 'package:yokogaki/yokogaki.dart';

// 2. Widget内で使用
HorizontalText(
  text: 'こんにちは、世界！',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 24),
  ),
)
```

ルビ付きの例:

```dart
HorizontalText(
  text: '日本語',
  rubyList: const [RubyText(startIndex: 0, length: 3, ruby: 'にほんご')],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 32),
    rubyStyle: TextStyle(fontSize: 14),
  ),
)
```

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Supported | All features |
| iOS | ✅ Supported | All features |
| Web | ✅ Supported | All features |
| Windows | ✅ Supported | All features |
| macOS | ✅ Supported | All features |
| Linux | ✅ Supported | All features |

**Requirements:**
- Flutter: ≥1.17.0
- Dart SDK: ≥3.10.3

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  yokogaki: ^0.10.1
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

### With Kenten (Emphasis Marks)

```dart
HorizontalText(
  text: '重要な部分を強調します。',
  kentenList: const [
    Kenten(startIndex: 0, length: 2, style: KentenStyle.sesame),
    Kenten(startIndex: 5, length: 2, style: KentenStyle.filledCircle),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 28),
  ),
)
```

Available kenten styles:
- `KentenStyle.sesame` - ゴマ点 (•)
- `KentenStyle.filledCircle` - 黒丸 (●)
- `KentenStyle.circle` - 白丸 (○)
- `KentenStyle.filledTriangle` - 黒三角 (▲)
- `KentenStyle.triangle` - 白三角 (△)
- `KentenStyle.doubleCircle` - 二重丸 (◎)
- `KentenStyle.filledSquare` - 黒四角 (■)
- `KentenStyle.square` - 白四角 (□)
- `KentenStyle.filledDiamond` - 黒菱形 (◆)
- `KentenStyle.diamond` - 白菱形 (◇)
- `KentenStyle.filledStar` - 黒星 (★)
- `KentenStyle.star` - 白星 (☆)
- `KentenStyle.x` - バツ (×)

### With Text Decoration (Underline/Overline)

```dart
HorizontalText(
  text: '下線と上線のテストです。',
  decorationList: const [
    TextDecorationAnnotation(
      startIndex: 0,
      endIndex: 2,
      type: TextDecorationLineType.underline,
    ),
    TextDecorationAnnotation(
      startIndex: 3,
      endIndex: 5,
      type: TextDecorationLineType.overline,
    ),
    TextDecorationAnnotation(
      startIndex: 6,
      endIndex: 8,
      type: TextDecorationLineType.wavyUnderline,
    ),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 28),
  ),
)
```

### With Text Alignment (地付き)

```dart
HorizontalText(
  text: '右揃えの例です。',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 24),
    alignment: TextAlignment.end, // 地付き - align to right
  ),
  maxWidth: 400,
)
```

### With First Line Indent (段落字下げ)

Traditional Japanese paragraph indentation where only the first line is indented:

```dart
HorizontalText(
  text: '吾輩は猫である。名前はまだ無い。どこで生まれたか頓と見当がつかぬ。',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 20),
    firstLineIndent: 1, // First line indented by 1 character
  ),
  maxWidth: 300,
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

### Combined Ruby and Kenten

```dart
HorizontalText(
  text: '重要な日本語を学びます。',
  rubyList: const [
    RubyText(startIndex: 0, length: 2, ruby: 'じゅうよう'),
    RubyText(startIndex: 3, length: 3, ruby: 'にほんご'),
  ],
  kentenList: const [
    Kenten(startIndex: 0, length: 2, style: KentenStyle.filledCircle),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 26),
    rubyStyle: TextStyle(fontSize: 12, color: Colors.green),
  ),
)
```

### Rich Text - Multiple Styles

```dart
HorizontalRichText(
  span: GroupHorizontalTextSpan(
    children: [
      SimpleHorizontalTextSpan(
        text: 'これは',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
      SimpleHorizontalTextSpan(
        text: '重要',
        style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
        kentenList: const [
          Kenten(startIndex: 0, length: 2, style: KentenStyle.filledCircle),
        ],
      ),
      SimpleHorizontalTextSpan(
        text: 'な',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
      SimpleHorizontalTextSpan(
        text: 'テキスト',
        style: TextStyle(fontSize: 24, color: Colors.blue, fontStyle: FontStyle.italic),
      ),
      SimpleHorizontalTextSpan(
        text: 'です。',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ],
  ),
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 24),
  ),
)
```

### Selectable Text

```dart
SelectableHorizontalText(
  text: 'これは選択可能なテキストです。',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 24),
  ),
  maxWidth: 350,
)
```

### SelectionArea Integration (Selection API)

Use `SelectionAreaHorizontalText` inside `SelectionArea` to enable unified text selection across multiple widgets:

```dart
SelectionArea(
  child: Column(
    children: [
      SelectableText('通常のテキスト'),
      SelectionAreaHorizontalText(
        text: '日本語の横書きテキスト',
        rubyList: [
          RubyText(startIndex: 0, length: 3, ruby: 'にほんご'),
        ],
        style: HorizontalTextStyle(
          baseStyle: TextStyle(fontSize: 24),
          rubyStyle: TextStyle(fontSize: 12),
        ),
      ),
    ],
  ),
)
```

This allows seamless text selection that spans across multiple selectable widgets.

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

## Use Cases / ユースケース

### ブログ・記事表示

一般的なWebコンテンツの表示:

```dart
HorizontalText(
  text: '今日は天気がよかったので、散歩に出かけました。'
      '公園では桜が満開で、とても綺麗でした。',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(
      fontSize: 16,
      height: 1.8,
      fontFamily: 'NotoSansJP',
    ),
  ),
  maxWidth: 600,
)
```

### 教科書・教材

ルビと圏点を使った学習教材:

```dart
HorizontalText(
  text: '日本国憲法は国民主権を基本原理とする。',
  rubyList: const [
    RubyText(startIndex: 0, length: 4, ruby: 'にほんこくけんぽう'),
    RubyText(startIndex: 5, length: 4, ruby: 'こくみんしゅけん'),
    RubyText(startIndex: 10, length: 4, ruby: 'きほんげんり'),
  ],
  kentenList: const [
    Kenten(startIndex: 5, length: 4, style: KentenStyle.filledCircle),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 20),
    rubyStyle: TextStyle(fontSize: 10, color: Colors.grey),
  ),
  maxWidth: 500,
)
```

### 新聞・ニュースアプリ

注釈付きのニュース記事:

```dart
HorizontalText(
  text: '政府は新たな経済政策を発表した。',
  warichuList: const [
    Warichu(startIndex: 7, length: 0, warichu: '経済成長と物価安定を目指す'),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 18),
  ),
  maxWidth: 400,
)
```

### 論文・学術文書

上線・下線による強調:

```dart
HorizontalText(
  text: '本研究の結論は以下の通りである。',
  decorationList: const [
    TextDecorationAnnotation(
      startIndex: 4,
      endIndex: 6,
      type: TextDecorationLineType.underline,
    ),
  ],
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 16),
  ),
)
```

### チャット・メッセージアプリ

選択可能なメッセージ表示:

```dart
SelectableHorizontalText(
  text: 'こんにちは！今日の予定はどうですか？',
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 16),
  ),
  maxWidth: 280,
)
```

### リッチテキストエディタ

複数スタイルの組み合わせ:

```dart
HorizontalRichText(
  span: GroupHorizontalTextSpan(
    children: [
      SimpleHorizontalTextSpan(
        text: '重要：',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      SimpleHorizontalTextSpan(
        text: '明日は会議があります。',
        style: TextStyle(fontSize: 16),
      ),
    ],
  ),
  style: HorizontalTextStyle(
    baseStyle: TextStyle(fontSize: 16),
  ),
)
```

## Performance

yokogaki v0.6.0+ includes significant performance optimizations:

- **LRU Layout Cache**: Automatic caching of layout calculations with 100-entry limit
- **TextPainter Reuse**: Reduced memory allocations by reusing TextPainter instances
- **Smart Invalidation**: Only recalculates when text, style, or width actually changes

Performance improvements:
- ~70% faster layout calculation for repeated renders
- ~50% fewer TextPainter allocations
- Excellent performance for scrollable lists of Japanese text

## Roadmap

- [x] Basic horizontal text layout
- [x] Kinsoku processing
- [x] Yakumono adjustment
- [x] Line breaking with kinsoku rules
- [x] Ruby text (furigana) support
- [x] Kenten (emphasis marks)
- [x] Warichu (inline annotations)
- [x] Rich text with multiple styles
- [x] Performance optimizations
- [x] Text selection support
- [x] Text decoration (underline/overline)
- [x] Text alignment (地付き)
- [x] Selection API integration (SelectionArea support)

All planned features are now complete!

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## References

- [JIS X 4051:2004](https://kikakurui.com/x4/X4051-2004-02.html) - Japanese document composition method
- [W3C Requirements for Japanese Text Layout (JLREQ)](https://w3c.github.io/jlreq/)
- [CSS Text Module Level 3/4](https://www.w3.org/TR/css-text-3/)
