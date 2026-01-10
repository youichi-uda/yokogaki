import 'package:flutter/material.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
import '../rendering/horizontal_text_layouter.dart';

/// Layout information for ruby text
class RubyLayout {
  /// Position to draw the ruby text
  final Offset position;

  /// The ruby text string
  final String ruby;

  /// Font size for ruby
  final double fontSize;

  const RubyLayout({
    required this.position,
    required this.ruby,
    required this.fontSize,
  });
}

/// Ruby text renderer for horizontal text
class RubyRenderer {
  /// Check if a character index has kenten marks
  static bool _hasKenten(int charIndex, List<dynamic>? kentenList) {
    if (kentenList == null || kentenList.isEmpty) return false;

    for (final kenten in kentenList) {
      if (kenten is Kenten) {
        if (charIndex >= kenten.startIndex && charIndex < kenten.endIndex) {
          return true;
        }
      }
    }
    return false;
  }

  /// Layout ruby text for given base text
  ///
  /// [baseText] The base text
  /// [rubyList] List of ruby annotations
  /// [style] Text style configuration
  /// [characterLayouts] Character layouts from HorizontalTextLayouter
  /// [kentenList] Optional list of kenten marks to avoid overlap
  ///
  /// Returns list of ruby layouts
  static List<RubyLayout> layoutRuby(
    String baseText,
    List<RubyText> rubyList,
    HorizontalTextStyle style,
    List<CharacterLayout> characterLayouts, {
    List<dynamic>? kentenList,
  }) {
    final layouts = <RubyLayout>[];
    final baseFontSize = style.baseStyle.fontSize ?? 16.0;
    final rubyFontSize = style.rubyStyle?.fontSize ?? (baseFontSize * 0.5);
    final kentenSize = baseFontSize * 0.3; // Same as in KentenRenderer

    for (final ruby in rubyList) {
      // Find all character layouts in this ruby range
      final baseLayouts = <CharacterLayout>[];
      for (final layout in characterLayouts) {
        // Note: We need to add textIndex to CharacterLayout
        // For now, use index from characterLayouts
        final textIndex = characterLayouts.indexOf(layout);
        if (textIndex >= ruby.startIndex &&
            textIndex < ruby.startIndex + ruby.length) {
          baseLayouts.add(layout);
        }
      }
      if (baseLayouts.isEmpty) continue;

      // Group characters by line (same Y position)
      final lineGroups = <double, List<CharacterLayout>>{};
      for (final layout in baseLayouts) {
        final lineY = layout.position.dy;
        lineGroups.putIfAbsent(lineY, () => []).add(layout);
      }

      // Sort lines by Y position (top to bottom)
      final sortedLines = lineGroups.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Calculate ruby split ratios based on character count per line
      final totalChars = baseLayouts.length;
      int rubyStartIndex = 0;

      for (int lineIdx = 0; lineIdx < sortedLines.length; lineIdx++) {
        final lineEntry = sortedLines[lineIdx];
        final lineY = lineEntry.key;
        final lineChars = lineEntry.value;
        lineChars.sort((a, b) => a.position.dx.compareTo(b.position.dx));

        final lineCharCount = lineChars.length;
        final isLastLine = lineIdx == sortedLines.length - 1;

        // Calculate ruby substring for this line
        int rubyCharCount;
        if (isLastLine) {
          // Last line gets all remaining ruby characters
          rubyCharCount = ruby.ruby.length - rubyStartIndex;
        } else {
          // Calculate proportionally
          rubyCharCount = ((ruby.ruby.length * lineCharCount) / totalChars).round();
        }

        // Make sure we don't exceed the ruby string length
        rubyCharCount = rubyCharCount.clamp(0, ruby.ruby.length - rubyStartIndex);

        if (rubyCharCount == 0) continue;

        final rubySubstring = ruby.ruby.substring(rubyStartIndex, rubyStartIndex + rubyCharCount);

        // Calculate layout for this line's ruby
        final firstChar = lineChars.first;
        final lastChar = lineChars.last;
        final baseX = firstChar.position.dx;
        final baseTextWidth = (lastChar.position.dx - firstChar.position.dx) + baseFontSize;

        // Calculate ruby text width
        final textPainter = TextPainter(
          text: TextSpan(
            text: rubySubstring,
            style: (style.rubyStyle ?? style.baseStyle).copyWith(fontSize: rubyFontSize),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final rubyTextWidth = textPainter.width;

        // Center ruby horizontally with the base text
        final rubyX = baseX + (baseTextWidth - rubyTextWidth) / 2;

        // Check if any character in this line has kenten marks
        bool hasKentenInLine = false;
        for (final charLayout in lineChars) {
          final charIndex = charLayout.textIndex;
          if (_hasKenten(charIndex, kentenList)) {
            hasKentenInLine = true;
            break;
          }
        }

        // Place ruby above the base text
        // If kenten marks exist, place ruby above them
        double rubyY;
        if (hasKentenInLine) {
          // Ruby should be above kenten: lineY - kentenSize - 1 (kenten gap) - rubyFontSize - 2 (ruby gap)
          rubyY = lineY - kentenSize - 1.0 - rubyFontSize - 2.0;
        } else {
          // Ruby directly above text
          rubyY = lineY - rubyFontSize - 2.0; // 2px gap
        }

        layouts.add(RubyLayout(
          position: Offset(rubyX, rubyY),
          ruby: rubySubstring,
          fontSize: rubyFontSize,
        ));

        rubyStartIndex += rubyCharCount;
      }
    }

    return layouts;
  }

  // Reusable TextPainter instance to avoid repeated allocations
  static final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  /// Render ruby text to canvas
  ///
  /// [canvas] The canvas to draw on
  /// [rubyLayouts] List of ruby layouts
  /// [style] Text style for ruby
  static void render(
    Canvas canvas,
    List<RubyLayout> rubyLayouts,
    HorizontalTextStyle style,
  ) {
    for (final layout in rubyLayouts) {
      _textPainter.text = TextSpan(
        text: layout.ruby,
        style: (style.rubyStyle ?? style.baseStyle).copyWith(
          fontSize: layout.fontSize,
        ),
      );

      _textPainter.layout();
      _textPainter.paint(canvas, layout.position);
    }
  }
}
