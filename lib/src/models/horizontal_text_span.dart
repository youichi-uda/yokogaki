import 'package:flutter/painting.dart';
import 'ruby_text.dart';
import 'kenten.dart';
import 'warichu.dart';

/// Base class for horizontal text spans
///
/// A span can be either a simple text span with a single style,
/// or a group of child spans
abstract class HorizontalTextSpan {
  const HorizontalTextSpan();

  /// Convert this span to a flat list of TextSpanData
  List<TextSpanData> toTextSpanData();

  /// Get the total text length of this span
  int get textLength;
}

/// A simple text span with a single style
class SimpleHorizontalTextSpan extends HorizontalTextSpan {
  final String text;
  final TextStyle? style;
  final List<RubyText> rubyList;
  final List<Kenten> kentenList;
  final List<Warichu> warichuList;

  const SimpleHorizontalTextSpan({
    required this.text,
    this.style,
    this.rubyList = const [],
    this.kentenList = const [],
    this.warichuList = const [],
  });

  @override
  List<TextSpanData> toTextSpanData() {
    return [
      TextSpanData(
        text: text,
        style: style,
        rubyList: rubyList,
        kentenList: kentenList,
        warichuList: warichuList,
      ),
    ];
  }

  @override
  int get textLength => text.length;
}

/// A group of child spans
class GroupHorizontalTextSpan extends HorizontalTextSpan {
  final List<HorizontalTextSpan> children;

  const GroupHorizontalTextSpan({
    required this.children,
  });

  @override
  List<TextSpanData> toTextSpanData() {
    final result = <TextSpanData>[];
    for (final child in children) {
      result.addAll(child.toTextSpanData());
    }
    return result;
  }

  @override
  int get textLength {
    int total = 0;
    for (final child in children) {
      total += child.textLength;
    }
    return total;
  }
}

/// Flattened text span data with annotations
class TextSpanData {
  final String text;
  final TextStyle? style;
  final List<RubyText> rubyList;
  final List<Kenten> kentenList;
  final List<Warichu> warichuList;

  const TextSpanData({
    required this.text,
    this.style,
    this.rubyList = const [],
    this.kentenList = const [],
    this.warichuList = const [],
  });

  /// Create a copy with updated indices
  TextSpanData withOffset(int offset) {
    return TextSpanData(
      text: text,
      style: style,
      rubyList: rubyList.map((ruby) => RubyText(
        startIndex: ruby.startIndex + offset,
        length: ruby.length,
        ruby: ruby.ruby,
      )).toList(),
      kentenList: kentenList.map((kenten) => Kenten(
        startIndex: kenten.startIndex + offset,
        length: kenten.length,
        type: kenten.type,
      )).toList(),
      warichuList: warichuList.map((warichu) => Warichu(
        startIndex: warichu.startIndex + offset,
        length: warichu.length,
        warichu: warichu.warichu,
      )).toList(),
    );
  }
}
