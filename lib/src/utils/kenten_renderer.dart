import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:kinsoku/kinsoku.dart';
import '../models/kenten.dart';
import '../models/horizontal_text_style.dart';
import '../rendering/horizontal_text_layouter.dart';

/// Get actual character width
double _getCharacterWidth(String character, HorizontalTextStyle style) {
  final fontSize = style.baseStyle.fontSize ?? 16.0;

  // Check half-width yakumono
  if (YakumonoAdjuster.isHalfWidthYakumono(character) && style.enableHalfWidthYakumono) {
    return fontSize * 0.5;
  }

  // For ASCII characters, measure actual width
  if (character.codeUnitAt(0) < 128) {
    final textPainter = TextPainter(
      text: TextSpan(text: character, style: style.baseStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  // Default to full width
  return fontSize;
}

/// Layout information for a single kenten mark
class KentenLayout {
  /// Position to draw the kenten mark
  final Offset position;

  /// Style of kenten mark
  final KentenStyle style;

  /// Size of the kenten mark
  final double size;

  const KentenLayout({
    required this.position,
    required this.style,
    required this.size,
  });
}

/// Utility class for laying out and rendering kenten (emphasis marks)
class KentenRenderer {
  /// Layout kenten marks based on character layouts
  static List<KentenLayout> layoutKenten(
    String text,
    List<Kenten> kentenList,
    HorizontalTextStyle style,
    List<CharacterLayout> layouts,
  ) {
    final kentenLayouts = <KentenLayout>[];
    final fontSize = style.baseStyle.fontSize ?? 16.0;
    final kentenSize = fontSize * 0.3; // Kenten marks are typically 30% of base font size

    for (final kenten in kentenList) {
      // Find character layouts for this kenten range
      for (final charLayout in layouts) {
        final charIndex = charLayout.textIndex;
        if (charIndex >= kenten.startIndex && charIndex < kenten.endIndex) {
          // Get actual character width
          final charWidth = _getCharacterWidth(charLayout.character, style);

          // For ASCII characters, use a bit more gap
          final isAscii = charLayout.character.codeUnitAt(0) < 128;
          final kentenGap = isAscii ? 2.0 : 8.0;

          // Position kenten mark above the character
          // For horizontal text: above = Y - kentenSize - gap
          final kentenPosition = Offset(
            charLayout.position.dx + (charWidth - kentenSize) / 2, // Center horizontally based on actual width
            charLayout.position.dy - kentenSize + kentenGap,
          );

          kentenLayouts.add(KentenLayout(
            position: kentenPosition,
            style: kenten.style,
            size: kentenSize,
          ));
        }
      }
    }

    return kentenLayouts;
  }

  /// Render kenten marks to the canvas
  static void render(
    Canvas canvas,
    List<KentenLayout> kentenLayouts,
    HorizontalTextStyle style,
  ) {
    final paint = Paint()
      ..color = style.baseStyle.color ?? const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = style.baseStyle.color ?? const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final layout in kentenLayouts) {
      _drawKentenMark(
        canvas,
        layout.position,
        layout.style,
        layout.size,
        paint,
        strokePaint,
      );
    }
  }

  /// Draw a single kenten mark
  static void _drawKentenMark(
    Canvas canvas,
    Offset position,
    KentenStyle style,
    double size,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final center = Offset(position.dx + size / 2, position.dy + size / 2);
    final radius = size / 2;

    switch (style) {
      case KentenStyle.sesame:
        // Sesame dot - small filled circle
        canvas.drawCircle(center, radius * 0.6, fillPaint);
        break;

      case KentenStyle.circle:
        // Open circle
        canvas.drawCircle(center, radius * 0.7, strokePaint);
        break;

      case KentenStyle.filledCircle:
        // Filled circle
        canvas.drawCircle(center, radius * 0.7, fillPaint);
        break;

      case KentenStyle.triangle:
        // Open triangle
        _drawTriangle(canvas, center, size * 0.8, strokePaint);
        break;

      case KentenStyle.filledTriangle:
        // Filled triangle
        _drawTriangle(canvas, center, size * 0.8, fillPaint);
        break;

      case KentenStyle.doubleCircle:
        // Double circle
        canvas.drawCircle(center, radius * 0.7, strokePaint);
        canvas.drawCircle(center, radius * 0.4, strokePaint);
        break;

      case KentenStyle.x:
        // X mark
        _drawX(canvas, center, size * 0.7, strokePaint);
        break;

      case KentenStyle.filledDiamond:
        // Filled diamond
        _drawDiamond(canvas, center, size * 0.8, fillPaint);
        break;

      case KentenStyle.diamond:
        // Hollow diamond
        _drawDiamond(canvas, center, size * 0.8, strokePaint);
        break;

      case KentenStyle.filledSquare:
        // Filled square
        _drawSquare(canvas, center, size * 0.7, fillPaint);
        break;

      case KentenStyle.square:
        // Hollow square
        _drawSquare(canvas, center, size * 0.7, strokePaint);
        break;

      case KentenStyle.filledStar:
        // Filled star
        _drawStar(canvas, center, size * 0.8, fillPaint);
        break;

      case KentenStyle.star:
        // Hollow star
        _drawStar(canvas, center, size * 0.8, strokePaint);
        break;
    }
  }

  /// Draw a triangle pointing upward
  static void _drawTriangle(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final path = Path();
    final height = size * 0.866; // sqrt(3)/2 for equilateral triangle

    // Top point
    path.moveTo(center.dx, center.dy - height / 2);
    // Bottom right
    path.lineTo(center.dx + size / 2, center.dy + height / 2);
    // Bottom left
    path.lineTo(center.dx - size / 2, center.dy + height / 2);
    path.close();

    if (paint.style == PaintingStyle.fill) {
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  /// Draw an X mark
  static void _drawX(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final half = size / 2;
    canvas.drawLine(
      Offset(center.dx - half, center.dy - half),
      Offset(center.dx + half, center.dy + half),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + half, center.dy - half),
      Offset(center.dx - half, center.dy + half),
      paint,
    );
  }

  /// Draw a diamond shape
  static void _drawDiamond(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final half = size / 2;
    final path = Path()
      ..moveTo(center.dx, center.dy - half) // Top
      ..lineTo(center.dx + half, center.dy) // Right
      ..lineTo(center.dx, center.dy + half) // Bottom
      ..lineTo(center.dx - half, center.dy) // Left
      ..close();
    canvas.drawPath(path, paint);
  }

  /// Draw a square shape
  static void _drawSquare(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final half = size / 2;
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    if (paint.style == PaintingStyle.fill) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }

  /// Draw a 5-pointed star
  static void _drawStar(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final path = Path();
    final outerRadius = size / 2;
    final innerRadius = outerRadius * 0.4;
    const points = 5;
    const startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = startAngle + (i * math.pi / points);

      if (i == 0) {
        path.moveTo(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      } else {
        path.lineTo(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
