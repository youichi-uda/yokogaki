import 'dart:ui';
import 'package:flutter/painting.dart';
import '../models/kenten.dart';
import '../models/horizontal_text_style.dart';
import '../rendering/horizontal_text_layouter.dart';

/// Layout information for a single kenten mark
class KentenLayout {
  /// Position to draw the kenten mark
  final Offset position;

  /// Type of kenten mark
  final KentenType type;

  /// Size of the kenten mark
  final double size;

  const KentenLayout({
    required this.position,
    required this.type,
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
          // Position kenten mark above the character
          // For horizontal text: above = Y - kentenSize - gap
          final kentenPosition = Offset(
            charLayout.position.dx + (fontSize - kentenSize) / 2, // Center horizontally
            charLayout.position.dy - kentenSize - 1, // Above character with 1px gap
          );

          kentenLayouts.add(KentenLayout(
            position: kentenPosition,
            type: kenten.type,
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
        layout.type,
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
    KentenType type,
    double size,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final center = Offset(position.dx + size / 2, position.dy + size / 2);
    final radius = size / 2;

    switch (type) {
      case KentenType.sesame:
        // Sesame dot - small filled circle
        canvas.drawCircle(center, radius * 0.6, fillPaint);
        break;

      case KentenType.circle:
        // Open circle
        canvas.drawCircle(center, radius * 0.7, strokePaint);
        break;

      case KentenType.filledCircle:
        // Filled circle
        canvas.drawCircle(center, radius * 0.7, fillPaint);
        break;

      case KentenType.triangle:
        // Open triangle
        _drawTriangle(canvas, center, size * 0.8, strokePaint);
        break;

      case KentenType.filledTriangle:
        // Filled triangle
        _drawTriangle(canvas, center, size * 0.8, fillPaint);
        break;

      case KentenType.doubleCircle:
        // Double circle
        canvas.drawCircle(center, radius * 0.7, strokePaint);
        canvas.drawCircle(center, radius * 0.4, strokePaint);
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
}
