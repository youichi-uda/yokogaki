import 'package:flutter/material.dart';
import 'package:kinsoku/kinsoku.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';

/// Layout information for a single character
class CharacterLayout {
  /// The character string
  final String character;

  /// Position to draw the character
  final Offset position;

  /// Ruby text for this character (if any)
  final RubyText? ruby;

  /// Index in the original text
  final int textIndex;

  CharacterLayout({
    required this.character,
    required this.position,
    this.ruby,
    required this.textIndex,
  });
}

/// Layouter for horizontal Japanese text with kinsoku processing
class HorizontalTextLayouter {
  /// Layout text horizontally with optional ruby
  ///
  /// [text] The text to layout
  /// [style] Style configuration
  /// [maxWidth] Maximum width for line breaking (0 = no limit)
  ///
  /// Returns list of character layouts
  static List<CharacterLayout> layout({
    required String text,
    required HorizontalTextStyle style,
    double maxWidth = 0,
  }) {
    if (text.isEmpty) {
      return [];
    }

    final layouts = <CharacterLayout>[];
    final fontSize = style.baseStyle.fontSize ?? 16.0;

    double currentX = 0.0; // Horizontal position (increases to the right)
    double currentY = 0.0; // Vertical position (increases downward for new lines)
    int lineStartIndex = 0;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      // Check if we need to break the line
      if (maxWidth > 0 && currentX + fontSize > maxWidth) {
        if (style.enableKinsoku) {
          // Find the best break position using kinsoku rules
          int breakPos = KinsokuProcessor.findBreakPosition(text.substring(lineStartIndex, i + 1), i - lineStartIndex);
          int actualBreakPos = lineStartIndex + breakPos;

          // Check if current character can hang at line end
          bool shouldHang = false;
          if (actualBreakPos == i && KinsokuProcessor.canHangAtLineEnd(char)) {
            shouldHang = true;
          }

          if (!shouldHang) {
            // Move to next line
            currentX = 0.0;
            currentY += fontSize + style.lineSpacing;
            lineStartIndex = i;
          } else {
            // shouldHang is true - let the character hang, but move to next line for subsequent characters
            currentX = 0.0;
            currentY += fontSize + style.lineSpacing;
            lineStartIndex = i + 1;
          }
        } else {
          // Simple line breaking without kinsoku
          currentX = 0.0;
          currentY += fontSize + style.lineSpacing;
          lineStartIndex = i;
        }
      }

      // Calculate character position
      Offset position = Offset(currentX, currentY);

      // Create layout
      layouts.add(CharacterLayout(
        character: char,
        position: position,
        textIndex: i,
      ));

      // Advance horizontal position
      double charWidth = YakumonoAdjuster.isHalfWidthYakumono(char) && style.enableHalfWidthYakumono
          ? fontSize * 0.5
          : fontSize;

      currentX += charWidth + style.characterSpacing;
    }

    return layouts;
  }

  /// Calculate the total size needed for the text
  static Size calculateSize({
    required String text,
    required HorizontalTextStyle style,
    double maxWidth = 0,
  }) {
    if (text.isEmpty) {
      return Size.zero;
    }

    final layouts = layout(text: text, style: style, maxWidth: maxWidth);
    if (layouts.isEmpty) {
      return Size.zero;
    }

    final fontSize = style.baseStyle.fontSize ?? 16.0;

    // Find the rightmost and bottommost positions
    double maxX = 0.0;
    double maxY = 0.0;

    for (final layout in layouts) {
      final charWidth = YakumonoAdjuster.isHalfWidthYakumono(layout.character)
          ? fontSize * 0.5
          : fontSize;
      maxX = (layout.position.dx + charWidth).clamp(maxX, double.infinity);
      maxY = (layout.position.dy + fontSize).clamp(maxY, double.infinity);
    }

    return Size(maxX, maxY);
  }
}
