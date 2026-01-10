/// Kenten (emphasis marks) annotation for horizontal text
///
/// Kenten are emphasis dots or marks displayed above characters
class Kenten {
  /// Starting index of the base text in the full string
  final int startIndex;

  /// Length of the base text
  final int length;

  /// Type of kenten mark to display
  final KentenType type;

  const Kenten({
    required this.startIndex,
    required this.length,
    this.type = KentenType.sesame,
  });

  /// End index of the base text (exclusive)
  int get endIndex => startIndex + length;

  @override
  String toString() {
    return 'Kenten(startIndex: $startIndex, length: $length, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Kenten &&
        other.startIndex == startIndex &&
        other.length == length &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(startIndex, length, type);
}

/// Types of kenten marks
enum KentenType {
  /// Sesame dot (胡麻点 gomaten) - most common
  sesame,

  /// Circle (白丸 shiromaru)
  circle,

  /// Filled circle (黒丸 kuromaru)
  filledCircle,

  /// Triangle (三角 sankaku)
  triangle,

  /// Filled triangle (黒三角 kurosankaku)
  filledTriangle,

  /// Double circle (二重丸 nijumaru)
  doubleCircle,
}
