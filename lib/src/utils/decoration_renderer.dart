import 'package:flutter/material.dart';
import '../models/text_decoration.dart';
import '../models/horizontal_text_style.dart';
import '../rendering/horizontal_text_layouter.dart';
import 'text_metrics.dart';

/// Layout information for a text decoration
class DecorationLayout {
  /// Start X position
  final double startX;

  /// End X position
  final double endX;

  /// Y position of the decoration line
  final double y;

  /// Type of decoration
  final TextDecorationLineType type;

  /// Color of the decoration
  final Color color;

  /// Thickness of the line
  final double thickness;

  const DecorationLayout({
    required this.startX,
    required this.endX,
    required this.y,
    required this.type,
    required this.color,
    required this.thickness,
  });
}

/// Renderer for text decorations (underlines, overlines, etc.) in horizontal text
class DecorationRenderer {
  /// Layout decorations for the given text
  static List<DecorationLayout> layoutDecorations(
    String text,
    List<TextDecorationAnnotation> decorationList,
    HorizontalTextStyle style,
    List<CharacterLayout> characterLayouts,
  ) {
    final layouts = <DecorationLayout>[];
    final fontSize = style.baseStyle.fontSize ?? 16.0;
    final defaultColor = style.baseStyle.color ?? Colors.black;

    // Measure text height once outside the loop
    final textHeight = TextMetrics.getTextHeight(style.baseStyle);

    for (final decoration in decorationList) {
      // Find all character layouts in this decoration range
      final charLayouts = <CharacterLayout>[];
      for (final layout in characterLayouts) {
        if (layout.textIndex >= decoration.startIndex &&
            layout.textIndex < decoration.endIndex) {
          charLayouts.add(layout);
        }
      }
      if (charLayouts.isEmpty) continue;

      // Group by line (same Y position)
      final lineGroups = <double, List<CharacterLayout>>{};
      for (final layout in charLayouts) {
        lineGroups.putIfAbsent(layout.position.dy, () => []).add(layout);
      }

      // Create decoration for each line
      for (final entry in lineGroups.entries) {
        final lineY = entry.key;
        final lineChars = entry.value;
        lineChars.sort((a, b) => a.position.dx.compareTo(b.position.dx));

        final firstChar = lineChars.first;
        final lastChar = lineChars.last;

        // Calculate last character width using actual measurement
        final lastCharWidth = TextMetrics.getCharacterWidth(lastChar.character, style);

        final startX = firstChar.position.dx;
        final endX = lastChar.position.dx + lastCharWidth;

        // Calculate Y position based on decoration type
        final isOverline = decoration.type == TextDecorationLineType.overline ||
            decoration.type == TextDecorationLineType.doubleOverline ||
            decoration.type == TextDecorationLineType.wavyOverline ||
            decoration.type == TextDecorationLineType.dottedOverline;

        final thickness = decoration.thickness ?? (fontSize * 0.05).clamp(1.0, 3.0);

        double decorationY;
        if (isOverline) {
          decorationY = lineY + 5.0; // Fixed offset above the text
        } else {
          decorationY = lineY + textHeight - 2.0; // Fixed offset below the text
        }

        layouts.add(DecorationLayout(
          startX: startX,
          endX: endX,
          y: decorationY,
          type: decoration.type,
          color: decoration.color ?? defaultColor,
          thickness: thickness,
        ));
      }
    }

    return layouts;
  }

  /// Render decorations to canvas
  static void render(
    Canvas canvas,
    List<DecorationLayout> decorationLayouts,
    HorizontalTextStyle style,
  ) {
    final fontSize = style.baseStyle.fontSize ?? 16.0;

    for (final layout in decorationLayouts) {
      final paint = Paint()
        ..color = layout.color
        ..strokeWidth = layout.thickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      switch (layout.type) {
        case TextDecorationLineType.underline:
        case TextDecorationLineType.overline:
          // Simple straight line
          canvas.drawLine(
            Offset(layout.startX, layout.y),
            Offset(layout.endX, layout.y),
            paint,
          );
          break;

        case TextDecorationLineType.doubleUnderline:
        case TextDecorationLineType.doubleOverline:
          // Double line
          final gap = layout.thickness * 2;
          final isOverline = layout.type == TextDecorationLineType.doubleOverline;
          final offset = isOverline ? -gap : gap;
          canvas.drawLine(
            Offset(layout.startX, layout.y),
            Offset(layout.endX, layout.y),
            paint,
          );
          canvas.drawLine(
            Offset(layout.startX, layout.y + offset),
            Offset(layout.endX, layout.y + offset),
            paint,
          );
          break;

        case TextDecorationLineType.wavyUnderline:
        case TextDecorationLineType.wavyOverline:
          // Wavy line
          _drawWavyLine(canvas, layout.startX, layout.endX, layout.y, paint, fontSize);
          break;

        case TextDecorationLineType.dottedUnderline:
        case TextDecorationLineType.dottedOverline:
          // Dotted line
          _drawDottedLine(canvas, layout.startX, layout.endX, layout.y, paint, fontSize);
          break;
      }
    }
  }

  /// Draw a wavy horizontal line
  static void _drawWavyLine(
    Canvas canvas,
    double startX,
    double endX,
    double y,
    Paint paint,
    double fontSize,
  ) {
    final path = Path();
    final waveHeight = fontSize * 0.08;
    final waveLength = fontSize * 0.2;

    path.moveTo(startX, y);

    double x = startX;
    bool goUp = true;

    while (x < endX) {
      final nextX = (x + waveLength).clamp(x, endX);
      final controlX = x + (nextX - x) / 2;
      final controlY = goUp ? y - waveHeight : y + waveHeight;

      path.quadraticBezierTo(controlX, controlY, nextX, y);

      x = nextX;
      goUp = !goUp;
    }

    canvas.drawPath(path, paint);
  }

  /// Draw a dotted horizontal line
  static void _drawDottedLine(
    Canvas canvas,
    double startX,
    double endX,
    double y,
    Paint paint,
    double fontSize,
  ) {
    final dotRadius = paint.strokeWidth;
    final dotSpacing = fontSize * 0.15;

    final dotPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;

    double x = startX + dotRadius;
    while (x < endX) {
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      x += dotSpacing;
    }
  }
}
