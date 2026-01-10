import 'package:flutter/material.dart';
import 'package:kinsoku/kinsoku.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../utils/layout_cache.dart';

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
  /// [useCache] Whether to use layout cache (default: true)
  ///
  /// Returns list of character layouts
  static List<CharacterLayout> layout({
    required String text,
    required HorizontalTextStyle style,
    double maxWidth = 0,
    bool useCache = true,
  }) {
    if (text.isEmpty) {
      return [];
    }

    // Check cache first
    if (useCache) {
      final cacheKey = LayoutCacheKey(
        text: text,
        style: style,
        maxWidth: maxWidth,
      );
      final cached = LayoutCache.get(cacheKey);
      if (cached != null) {
        return cached.layouts;
      }
    }

    final layouts = <CharacterLayout>[];
    final fontSize = style.baseStyle.fontSize ?? 16.0;

    // Apply indent (字下げ) - shift starting X position
    final indentOffset = style.indent * fontSize;
    double currentX = indentOffset; // Horizontal position (increases to the right)
    double currentY = 0.0; // Vertical position (increases downward for new lines)
    int lineStartIndex = 0;
    bool shouldBreakAfterCurrentChar = false; // Flag for burasage (hanging)

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      // Check if we need to break the line
      if (maxWidth > 0 && currentX + fontSize > maxWidth) {
        if (style.enableKinsoku) {
          // First check if current character can hang at line end (burasage)
          if (KinsokuProcessor.canHangAtLineEnd(char)) {
            // Allow character to hang - draw it, then break after
            shouldBreakAfterCurrentChar = true;
          } else {
            // Cannot hang - need to find proper break position
            int breakPos = KinsokuProcessor.findBreakPosition(text.substring(lineStartIndex, i + 1), i - lineStartIndex);
            int actualBreakPos = lineStartIndex + breakPos;

            // If break position is before current position, need to move some characters to next line
            if (actualBreakPos < i) {
              // Remove layouts from actualBreakPos onwards
              layouts.removeWhere((layout) => layout.textIndex >= actualBreakPos);

              // Reset current position to beginning of new line
              currentX = indentOffset;
              currentY += fontSize + style.lineSpacing;
              lineStartIndex = actualBreakPos;

              // Re-layout characters from actualBreakPos to i-1 on the new line
              for (int j = actualBreakPos; j < i; j++) {
                final reChar = text[j];
                layouts.add(CharacterLayout(
                  character: reChar,
                  position: Offset(currentX, currentY),
                  textIndex: j,
                ));
                double charWidth = YakumonoAdjuster.isHalfWidthYakumono(reChar) && style.enableHalfWidthYakumono
                    ? fontSize * 0.5
                    : fontSize;
                currentX += charWidth + style.characterSpacing;
              }
            } else {
              // Break at current position
              currentX = indentOffset;
              currentY += fontSize + style.lineSpacing;
              lineStartIndex = i;
            }
          }
        } else {
          // Simple line breaking without kinsoku
          currentX = indentOffset;
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

      // Check if we should break after this character (burasage case)
      if (shouldBreakAfterCurrentChar) {
        currentX = indentOffset;
        currentY += fontSize + style.lineSpacing;
        lineStartIndex = i + 1;
        shouldBreakAfterCurrentChar = false;
      }
    }

    // Apply line alignment (jizuki, tenzuki, center)
    if (maxWidth > 0 && layouts.isNotEmpty) {
      // Group layouts by line (Y coordinate)
      final lineGroups = <double, List<int>>{};
      for (int i = 0; i < layouts.length; i++) {
        final y = layouts[i].position.dy;
        lineGroups.putIfAbsent(y, () => []).add(i);
      }

      // Adjust X position for each line based on alignment
      for (final indices in lineGroups.values) {
        if (indices.isEmpty) continue;

        // Find the maximum X coordinate in this line
        double maxX = 0.0;
        for (final idx in indices) {
          final layout = layouts[idx];
          // Calculate character width
          double charWidth = YakumonoAdjuster.isHalfWidthYakumono(layout.character) &&
                             style.enableHalfWidthYakumono
              ? fontSize * 0.5
              : fontSize;
          double xEnd = layout.position.dx + charWidth;
          if (xEnd > maxX) {
            maxX = xEnd;
          }
        }

        // Calculate X offset based on alignment
        double xOffset = 0.0;
        switch (style.alignment) {
          case TextAlignment.start:
            // Left alignment (天付き) - no offset
            xOffset = 0.0;
            break;
          case TextAlignment.center:
            // Center alignment - offset to center
            xOffset = (maxWidth - maxX) / 2;
            break;
          case TextAlignment.end:
            // Right alignment (地付き) - offset to right
            xOffset = maxWidth - maxX;
            break;
        }

        // Apply offset to all characters in this line
        for (final idx in indices) {
          final layout = layouts[idx];
          layouts[idx] = CharacterLayout(
            character: layout.character,
            position: Offset(layout.position.dx + xOffset, layout.position.dy),
            ruby: layout.ruby,
            textIndex: layout.textIndex,
          );
        }
      }
    }

    // Store in cache if enabled
    if (useCache) {
      final cacheKey = LayoutCacheKey(
        text: text,
        style: style,
        maxWidth: maxWidth,
      );
      final size = _calculateSizeFromLayouts(layouts, style);
      LayoutCache.put(
        cacheKey,
        LayoutCacheValue(layouts: layouts, size: size),
      );
    }

    return layouts;
  }

  /// Calculate the total size needed for the text
  static Size calculateSize({
    required String text,
    required HorizontalTextStyle style,
    double maxWidth = 0,
    bool useCache = true,
  }) {
    if (text.isEmpty) {
      return Size.zero;
    }

    // Check cache first
    if (useCache) {
      final cacheKey = LayoutCacheKey(
        text: text,
        style: style,
        maxWidth: maxWidth,
      );
      final cached = LayoutCache.get(cacheKey);
      if (cached != null) {
        return cached.size;
      }
    }

    // Layout will also store in cache
    final layouts = layout(text: text, style: style, maxWidth: maxWidth, useCache: useCache);
    return _calculateSizeFromLayouts(layouts, style);
  }

  /// Calculate size from existing layouts
  static Size _calculateSizeFromLayouts(
    List<CharacterLayout> layouts,
    HorizontalTextStyle style,
  ) {
    if (layouts.isEmpty) {
      return Size.zero;
    }

    final fontSize = style.baseStyle.fontSize ?? 16.0;

    // Measure actual text height using TextPainter
    final textPainter = TextPainter(
      text: TextSpan(text: 'あ', style: style.baseStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final actualTextHeight = textPainter.height;

    // Find the rightmost and bottommost positions
    double maxX = 0.0;
    double maxY = 0.0;

    for (final layout in layouts) {
      final charWidth = YakumonoAdjuster.isHalfWidthYakumono(layout.character)
          ? fontSize * 0.5
          : fontSize;
      maxX = (layout.position.dx + charWidth).clamp(maxX, double.infinity);
      maxY = (layout.position.dy + actualTextHeight).clamp(maxY, double.infinity);
    }

    return Size(maxX, maxY);
  }
}
