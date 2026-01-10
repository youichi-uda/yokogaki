import 'package:flutter/painting.dart';

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
    );
  }
}
