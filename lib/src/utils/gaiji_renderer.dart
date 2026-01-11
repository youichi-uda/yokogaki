import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Layout information for a resolved gaiji
class GaijiLayout {
  /// Position to draw the gaiji
  final Offset position;

  /// Width of the gaiji image
  final double width;

  /// Height of the gaiji image
  final double height;

  /// The resolved image to draw
  final ui.Image image;

  /// Text index this gaiji replaces
  final int textIndex;

  const GaijiLayout({
    required this.position,
    required this.width,
    required this.height,
    required this.image,
    required this.textIndex,
  });
}

/// Renderer for gaiji (外字) images
class GaijiRenderer {
  /// Draw a gaiji image at the specified position
  ///
  /// For horizontal text, the image is aligned to the bottom of the character cell,
  /// matching how text baselines work.
  static void drawGaiji(
    Canvas canvas,
    GaijiLayout layout,
    double fontSize,
    TextStyle? textStyle,
  ) {
    // Measure actual character metrics to find where the glyph body starts
    final textPainter = TextPainter(
      text: TextSpan(text: 'あ', style: textStyle ?? TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Get the text height to calculate offset
    final textHeight = textPainter.height;

    // The actual character body starts after some ascent space
    // Japanese characters are typically centered, so offset by (textHeight - fontSize) / 2
    final topOffset = (textHeight - fontSize) / 2;

    // Source rectangle (entire image)
    final srcRect = Rect.fromLTWH(
      0,
      0,
      layout.image.width.toDouble(),
      layout.image.height.toDouble(),
    );

    // Destination rectangle - align with character body
    final dstRect = Rect.fromLTWH(
      layout.position.dx,
      layout.position.dy + topOffset,
      layout.width,
      layout.height,
    );

    // Draw the image
    canvas.drawImageRect(
      layout.image,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  /// Draw multiple gaiji images
  static void drawGaijiList(
    Canvas canvas,
    List<GaijiLayout> layouts,
    double fontSize,
    TextStyle? textStyle,
  ) {
    for (final layout in layouts) {
      drawGaiji(canvas, layout, fontSize, textStyle);
    }
  }
}
