import 'package:flutter/material.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
import '../models/warichu.dart';
import '../rendering/horizontal_text_painter.dart';
import '../rendering/horizontal_text_layouter.dart';

/// A widget for displaying horizontal Japanese text with advanced typography
///
/// Supports:
/// - Kinsoku processing (禁則処理 - Japanese line breaking rules)
/// - Yakumono adjustment (約物調整 - punctuation positioning)
/// - Kerning (character spacing adjustments)
/// - Ruby text (furigana)
/// - Line breaking with proper character handling
class HorizontalText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Style configuration for the text
  final HorizontalTextStyle style;

  /// Maximum width for line breaking (0 = no limit)
  final double maxWidth;

  /// Whether to show a debug grid
  final bool showGrid;

  /// Ruby text annotations
  final List<RubyText> rubyList;

  /// Kenten (emphasis marks) annotations
  final List<Kenten> kentenList;

  /// Warichu (inline annotations) annotations
  final List<Warichu> warichuList;

  const HorizontalText({
    super.key,
    required this.text,
    this.style = const HorizontalTextStyle(),
    this.maxWidth = 0,
    this.showGrid = false,
    this.rubyList = const [],
    this.kentenList = const [],
    this.warichuList = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Get default text color from theme if not specified
    final defaultColor = style.baseStyle.color ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        const Color(0xFF000000);

    // Merge default color with user style
    final effectiveStyle = style.copyWith(
      baseStyle: style.baseStyle.copyWith(color: defaultColor),
    );

    // Calculate the size needed for the text
    final baseSize = HorizontalTextLayouter.calculateSize(
      text: text,
      style: effectiveStyle,
      maxWidth: maxWidth,
    );

    // Add extra height for ruby and kenten
    final fontSize = effectiveStyle.baseStyle.fontSize ?? 16.0;
    double extraHeight = 0.0;

    if (rubyList.isNotEmpty) {
      final rubyFontSize = effectiveStyle.rubyStyle?.fontSize ?? (fontSize * 0.5);
      extraHeight = rubyFontSize + 4.0; // ruby height + gap
    }

    if (kentenList.isNotEmpty) {
      final kentenSize = fontSize * 0.3;
      final kentenHeight = kentenSize + 8.0; // kenten size + gap
      extraHeight = extraHeight > kentenHeight ? extraHeight : kentenHeight;
    }

    // If both ruby and kenten exist, use the larger one
    if (rubyList.isNotEmpty && kentenList.isNotEmpty) {
      final rubyFontSize = effectiveStyle.rubyStyle?.fontSize ?? (fontSize * 0.5);
      final kentenSize = fontSize * 0.3;
      extraHeight = rubyFontSize + kentenSize + 10.0; // both + gaps
    }

    final size = Size(baseSize.width, baseSize.height + extraHeight);

    return CustomPaint(
      size: size,
      painter: HorizontalTextPainter(
        text: text,
        style: effectiveStyle,
        maxWidth: maxWidth,
        showGrid: showGrid,
        rubyList: rubyList,
        kentenList: kentenList,
        warichuList: warichuList,
      ),
    );
  }
}
