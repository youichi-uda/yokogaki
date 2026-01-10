/// Styles for kenten (emphasis dots)
enum KentenStyle {
  /// Sesame dots (ゴマ点)
  sesame,

  /// Filled circle (黒丸)
  filledCircle,

  /// Hollow circle (白丸)
  circle,

  /// Double circle (二重丸)
  doubleCircle,

  /// Filled triangle (黒三角)
  filledTriangle,

  /// Hollow triangle (白三角)
  triangle,

  /// X mark (×印)
  x,

  /// Filled diamond (黒菱形)
  filledDiamond,

  /// Hollow diamond (白菱形)
  diamond,

  /// Filled square (黒四角)
  filledSquare,

  /// Hollow square (白四角)
  square,

  /// Filled star (黒星)
  filledStar,

  /// Hollow star (白星)
  star,
}

/// Kenten (emphasis marks) annotation for horizontal text
///
/// Kenten are emphasis dots or marks displayed above characters
class Kenten {
  /// Starting index of the base text in the full string
  final int startIndex;

  /// Length of the base text
  final int length;

  /// Style of kenten to use
  final KentenStyle style;

  const Kenten({
    required this.startIndex,
    required this.length,
    this.style = KentenStyle.sesame,
  });

  /// End index of the base text (exclusive)
  int get endIndex => startIndex + length;

  @override
  String toString() {
    return 'Kenten(startIndex: $startIndex, length: $length, style: $style)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Kenten &&
        other.startIndex == startIndex &&
        other.length == length &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(startIndex, length, style);
}
