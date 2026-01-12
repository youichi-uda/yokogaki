import 'package:flutter/painting.dart';
import 'package:kinsoku/kinsoku.dart';
import '../models/horizontal_text_style.dart';

/// Shared text metrics utilities
class TextMetrics {
  // Reusable TextPainter instance to avoid repeated allocations
  static final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  /// Get actual character width, accounting for half-width yakumono and ASCII
  static double getCharacterWidth(String character, HorizontalTextStyle style) {
    final fontSize = style.baseStyle.fontSize ?? 16.0;

    // Check half-width yakumono
    if (YakumonoAdjuster.isHalfWidthYakumono(character) && style.enableHalfWidthYakumono) {
      return fontSize * 0.5;
    }

    // For ASCII characters, measure actual width
    if (character.codeUnitAt(0) < 128) {
      _textPainter.text = TextSpan(text: character, style: style.baseStyle);
      _textPainter.layout();
      return _textPainter.width;
    }

    // Default to full width
    return fontSize;
  }

  /// Measure text height for a given style
  static double getTextHeight(TextStyle style) {
    _textPainter.text = TextSpan(text: 'あ', style: style);
    _textPainter.layout();
    return _textPainter.height;
  }
}
