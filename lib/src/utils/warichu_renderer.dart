import 'dart:ui';
import 'package:flutter/painting.dart';
import '../models/warichu.dart';
import '../models/horizontal_text_style.dart';
import '../rendering/horizontal_text_layouter.dart';

/// Layout information for warichu (inline annotation)
class WarichuLayout {
  /// Position to draw the first line of warichu
  final Offset topLinePosition;

  /// Position to draw the second line of warichu
  final Offset bottomLinePosition;

  /// First line text
  final String topLine;

  /// Second line text
  final String bottomLine;

  /// Font size for warichu text
  final double fontSize;

  const WarichuLayout({
    required this.topLinePosition,
    required this.bottomLinePosition,
    required this.topLine,
    required this.bottomLine,
    required this.fontSize,
  });
}

/// Utility class for laying out and rendering warichu (inline annotations)
class WarichuRenderer {
  /// Layout warichu annotations based on character layouts
  static List<WarichuLayout> layoutWarichu(
    String text,
    List<Warichu> warichuList,
    HorizontalTextStyle style,
    List<CharacterLayout> layouts,
  ) {
    final warichuLayouts = <WarichuLayout>[];
    final baseFontSize = style.baseStyle.fontSize ?? 16.0;
    final warichuFontSize = baseFontSize * 0.5; // Warichu is typically 50% of base size

    for (final warichu in warichuList) {
      // Find the first character layout for this warichu range
      CharacterLayout? firstCharLayout;
      for (final charLayout in layouts) {
        final charIndex = charLayout.textIndex;
        if (charIndex >= warichu.startIndex && charIndex < warichu.endIndex) {
          firstCharLayout = charLayout;
          break;
        }
      }

      if (firstCharLayout == null) continue;

      // Split warichu text into two lines
      // For simplicity, we split at the middle character
      final warichuText = warichu.warichu;
      final midPoint = (warichuText.length / 2).ceil();
      final topLine = warichuText.substring(0, midPoint);
      final bottomLine = warichuText.substring(midPoint);

      // Position warichu text vertically centered within the line height
      // For horizontal text:
      // - Top line: Y position slightly above center
      // - Bottom line: Y position slightly below center
      final baseY = firstCharLayout.position.dy;
      final lineGap = 2.0; // Gap between top and bottom lines

      final topLineY = baseY + (baseFontSize - warichuFontSize * 2 - lineGap) / 2;
      final bottomLineY = topLineY + warichuFontSize + lineGap;

      warichuLayouts.add(WarichuLayout(
        topLinePosition: Offset(firstCharLayout.position.dx, topLineY),
        bottomLinePosition: Offset(firstCharLayout.position.dx, bottomLineY),
        topLine: topLine,
        bottomLine: bottomLine,
        fontSize: warichuFontSize,
      ));
    }

    return warichuLayouts;
  }

  // Reusable TextPainter instance to avoid repeated allocations
  static final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  /// Render warichu annotations to the canvas
  static void render(
    Canvas canvas,
    List<WarichuLayout> warichuLayouts,
    HorizontalTextStyle style,
  ) {
    final baseColor = style.baseStyle.color ?? const Color(0xFF000000);
    final warichuColor = baseColor.withValues(alpha: 0.8); // Slightly lighter

    for (final layout in warichuLayouts) {
      final warichuStyle = TextStyle(
        fontSize: layout.fontSize,
        color: warichuColor,
        fontFamily: style.baseStyle.fontFamily,
      );

      // Draw top line
      _textPainter.text = TextSpan(
        text: layout.topLine,
        style: warichuStyle,
      );
      _textPainter.layout();
      _textPainter.paint(canvas, layout.topLinePosition);

      // Draw bottom line
      _textPainter.text = TextSpan(
        text: layout.bottomLine,
        style: warichuStyle,
      );
      _textPainter.layout();
      _textPainter.paint(canvas, layout.bottomLinePosition);
    }
  }
}
