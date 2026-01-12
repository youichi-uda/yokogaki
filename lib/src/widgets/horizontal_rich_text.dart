import 'package:flutter/material.dart';
import '../models/horizontal_text_style.dart';
import '../models/horizontal_text_span.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
import '../models/warichu.dart';
import '../rendering/horizontal_rich_text_painter.dart';
import '../rendering/horizontal_text_layouter.dart';

/// A widget for displaying horizontal Japanese rich text with multiple styles
///
/// Supports all features of HorizontalText plus:
/// - Multiple text styles in one widget
/// - Per-span ruby, kenten, and warichu annotations
class HorizontalRichText extends StatelessWidget {
  /// The text span hierarchy
  final HorizontalTextSpan span;

  /// Base style configuration for the text
  final HorizontalTextStyle style;

  /// Maximum width for line breaking (0 = no limit)
  final double maxWidth;

  /// Whether to show a debug grid
  final bool showGrid;

  const HorizontalRichText({
    super.key,
    required this.span,
    this.style = const HorizontalTextStyle(),
    this.maxWidth = 0,
    this.showGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get default text color from theme
    final defaultColor = style.baseStyle.color ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        const Color(0xFF000000);

    // Flatten the span hierarchy
    final spanDataList = span.toTextSpanData();

    // Calculate combined text and annotations
    final combinedText = StringBuffer();
    final allRuby = <RubyText>[];
    final allKenten = <Kenten>[];
    final allWarichu = <Warichu>[];
    final styleRanges = <StyleRange>[];

    int currentOffset = 0;
    for (final spanData in spanDataList) {
      combinedText.write(spanData.text);

      // Add style range if custom style is specified
      if (spanData.style != null) {
        // Apply default color if not specified in span style
        final effectiveSpanStyle = spanData.style!.color == null
            ? spanData.style!.copyWith(color: defaultColor)
            : spanData.style!;

        styleRanges.add(StyleRange(
          startIndex: currentOffset,
          endIndex: currentOffset + spanData.text.length,
          style: effectiveSpanStyle,
        ));
      }

      // Add annotations with offset
      final offsetData = spanData.withOffset(currentOffset);
      allRuby.addAll(offsetData.rubyList);
      allKenten.addAll(offsetData.kentenList);
      allWarichu.addAll(offsetData.warichuList);

      currentOffset += spanData.text.length;
    }

    // Merge default color with base style
    final effectiveStyle = style.copyWith(
      baseStyle: style.baseStyle.copyWith(color: defaultColor),
    );

    // Calculate the size needed for the text
    final baseSize = HorizontalTextLayouter.calculateSize(
      text: combinedText.toString(),
      style: effectiveStyle,
      maxWidth: maxWidth,
    );

    // Add extra height for ruby and kenten
    final fontSize = effectiveStyle.baseStyle.fontSize ?? 16.0;
    double extraHeight = 0.0;

    if (allRuby.isNotEmpty) {
      final rubyFontSize = effectiveStyle.rubyStyle?.fontSize ?? (fontSize * 0.5);
      extraHeight = rubyFontSize + 4.0; // ruby height + gap
    }

    if (allKenten.isNotEmpty) {
      final kentenSize = fontSize * 0.3;
      final kentenHeight = kentenSize + 8.0; // kenten size + gap
      extraHeight = extraHeight > kentenHeight ? extraHeight : kentenHeight;
    }

    // If both ruby and kenten exist, use the larger one
    if (allRuby.isNotEmpty && allKenten.isNotEmpty) {
      final rubyFontSize = effectiveStyle.rubyStyle?.fontSize ?? (fontSize * 0.5);
      final kentenSize = fontSize * 0.3;
      extraHeight = rubyFontSize + kentenSize + 10.0; // both + gaps
    }

    final size = Size(baseSize.width, baseSize.height + extraHeight);

    return CustomPaint(
      size: size,
      painter: HorizontalRichTextPainter(
        text: combinedText.toString(),
        style: effectiveStyle,
        maxWidth: maxWidth,
        showGrid: showGrid,
        rubyList: allRuby,
        kentenList: allKenten,
        warichuList: allWarichu,
        styleRanges: styleRanges,
      ),
    );
  }
}

/// Represents a style range within the text
class StyleRange {
  final int startIndex;
  final int endIndex;
  final TextStyle style;

  const StyleRange({
    required this.startIndex,
    required this.endIndex,
    required this.style,
  });

  /// Check if this range contains the given index
  bool contains(int index) {
    return index >= startIndex && index < endIndex;
  }
}
