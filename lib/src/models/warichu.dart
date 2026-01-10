/// Warichu (inline annotation) for horizontal text
///
/// Warichu is a two-line annotation displayed inline with the main text,
/// typically used for brief explanatory notes or alternative readings
class Warichu {
  /// Starting index of the base text in the full string
  final int startIndex;

  /// Length of the base text
  final int length;

  /// Warichu text to display (will be split into two lines)
  final String warichu;

  const Warichu({
    required this.startIndex,
    required this.length,
    required this.warichu,
  });

  /// End index of the base text (exclusive)
  int get endIndex => startIndex + length;

  @override
  String toString() {
    return 'Warichu(startIndex: $startIndex, length: $length, warichu: $warichu)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Warichu &&
        other.startIndex == startIndex &&
        other.length == length &&
        other.warichu == warichu;
  }

  @override
  int get hashCode => Object.hash(startIndex, length, warichu);
}
