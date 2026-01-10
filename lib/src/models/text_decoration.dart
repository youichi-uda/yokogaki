import 'package:flutter/painting.dart';

/// Types of text decoration lines for horizontal text
enum TextDecorationLineType {
  /// Underline (下線) - line below the character
  underline,

  /// Double underline (二重下線)
  doubleUnderline,

  /// Wavy underline (波線)
  wavyUnderline,

  /// Dotted underline (点線)
  dottedUnderline,

  /// Overline (上線) - line above the character
  overline,

  /// Double overline (二重上線)
  doubleOverline,

  /// Wavy overline (波上線)
  wavyOverline,

  /// Dotted overline (点上線)
  dottedOverline,
}

/// Text decoration annotation for horizontal text
///
/// Unlike kenten (emphasis dots), decorations are lines drawn above/below characters
class TextDecorationAnnotation {
  /// Starting index of the text to decorate
  final int startIndex;

  /// Length of the text to decorate
  final int length;

  /// Type of decoration line
  final TextDecorationLineType type;

  /// Color of the decoration line (null = use text color)
  final Color? color;

  /// Thickness of the decoration line (null = auto based on font size)
  final double? thickness;

  const TextDecorationAnnotation({
    required this.startIndex,
    required this.length,
    this.type = TextDecorationLineType.underline,
    this.color,
    this.thickness,
  });

  /// End index of the decorated text (exclusive)
  int get endIndex => startIndex + length;

  @override
  String toString() {
    return 'TextDecorationAnnotation(startIndex: $startIndex, length: $length, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextDecorationAnnotation &&
        other.startIndex == startIndex &&
        other.length == length &&
        other.type == type &&
        other.color == color &&
        other.thickness == thickness;
  }

  @override
  int get hashCode => Object.hash(startIndex, length, type, color, thickness);
}
