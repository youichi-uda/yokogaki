import 'package:flutter/painting.dart';
import 'package:kinsoku/kinsoku.dart';

/// Style configuration for horizontal text layout
class HorizontalTextStyle {
  /// Base text style for characters
  final TextStyle baseStyle;

  /// Spacing between lines (vertical spacing in horizontal text)
  final double lineSpacing;

  /// Spacing between characters (horizontal spacing in horizontal text)
  final double characterSpacing;

  /// Whether to adjust yakumono (punctuation) positioning
  final bool adjustYakumono;

  /// Text style for ruby (furigana) text
  final TextStyle? rubyStyle;

  /// Text style for kenten (emphasis marks)
  final TextStyle? kentenStyle;

  /// Text style for warichu (inline annotations)
  final TextStyle? warichuStyle;

  /// Enable kinsoku processing (line breaking rules)
  /// When enabled, characters in burasageAllowed (。、）」】』〉》) will hang,
  /// and other gyoto kinsoku characters (ー) will be pushed in (oikomi).
  /// Default: true
  final bool enableKinsoku;

  /// Enable half-width yakumono processing
  final bool enableHalfWidthYakumono;

  /// Enable gyoto indent (indenting opening brackets at line start)
  final bool enableGyotoIndent;

  /// Enable kerning (advanced character spacing)
  final bool enableKerning;

  /// Line alignment
  /// - [TextAlignment.start]: Left alignment (天付き)
  /// - [TextAlignment.center]: Center alignment
  /// - [TextAlignment.end]: Right alignment (地付き)
  final TextAlignment alignment;

  /// Text indent in character units (字下げ) - applies to ALL lines
  ///
  /// For horizontal text, this shifts the starting position right by
  /// `indent * fontSize` pixels for every line.
  ///
  /// Example: `indent: 2` shifts all lines right by 2 character widths.
  ///
  /// See also: [firstLineIndent] for Japanese-style paragraph indentation.
  final int indent;

  /// First line indent in character units (段落字下げ)
  ///
  /// For horizontal text, this shifts only the FIRST line's starting position
  /// right by `firstLineIndent * fontSize` pixels. Subsequent lines start at
  /// the normal position (affected only by [indent] if set).
  ///
  /// This is the traditional Japanese paragraph indentation style where only
  /// the first line of a paragraph is indented.
  ///
  /// Example: `firstLineIndent: 1` shifts only the first line right by 1 character width.
  final int firstLineIndent;

  const HorizontalTextStyle({
    this.baseStyle = const TextStyle(),
    this.lineSpacing = 0.0,
    this.characterSpacing = 0.0,
    this.adjustYakumono = true,
    this.rubyStyle,
    this.kentenStyle,
    this.warichuStyle,
    this.enableKinsoku = true,
    this.enableHalfWidthYakumono = true,
    this.enableGyotoIndent = true,
    this.enableKerning = true,
    this.alignment = TextAlignment.center,
    this.indent = 0,
    this.firstLineIndent = 0,
  });

  /// Create a copy with modified properties
  HorizontalTextStyle copyWith({
    TextStyle? baseStyle,
    double? lineSpacing,
    double? characterSpacing,
    bool? adjustYakumono,
    TextStyle? rubyStyle,
    TextStyle? kentenStyle,
    TextStyle? warichuStyle,
    bool? enableKinsoku,
    bool? enableHalfWidthYakumono,
    bool? enableGyotoIndent,
    bool? enableKerning,
    TextAlignment? alignment,
    int? indent,
    int? firstLineIndent,
  }) {
    return HorizontalTextStyle(
      baseStyle: baseStyle ?? this.baseStyle,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      characterSpacing: characterSpacing ?? this.characterSpacing,
      adjustYakumono: adjustYakumono ?? this.adjustYakumono,
      rubyStyle: rubyStyle ?? this.rubyStyle,
      kentenStyle: kentenStyle ?? this.kentenStyle,
      warichuStyle: warichuStyle ?? this.warichuStyle,
      enableKinsoku: enableKinsoku ?? this.enableKinsoku,
      enableHalfWidthYakumono: enableHalfWidthYakumono ?? this.enableHalfWidthYakumono,
      enableGyotoIndent: enableGyotoIndent ?? this.enableGyotoIndent,
      enableKerning: enableKerning ?? this.enableKerning,
      alignment: alignment ?? this.alignment,
      indent: indent ?? this.indent,
      firstLineIndent: firstLineIndent ?? this.firstLineIndent,
    );
  }
}
