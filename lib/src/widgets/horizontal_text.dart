import 'package:flutter/material.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
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

  const HorizontalText({
    super.key,
    required this.text,
    this.style = const HorizontalTextStyle(),
    this.maxWidth = 0,
    this.showGrid = false,
    this.rubyList = const [],
    this.kentenList = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the size needed for the text
    final size = HorizontalTextLayouter.calculateSize(
      text: text,
      style: style,
      maxWidth: maxWidth,
    );

    return CustomPaint(
      size: size,
      painter: HorizontalTextPainter(
        text: text,
        style: style,
        maxWidth: maxWidth,
        showGrid: showGrid,
        rubyList: rubyList,
        kentenList: kentenList,
      ),
    );
  }
}
