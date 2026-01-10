import 'dart:collection';
import 'package:flutter/material.dart';
import '../rendering/horizontal_text_layouter.dart';
import '../models/horizontal_text_style.dart';

/// Cache key for layout results
class LayoutCacheKey {
  final String text;
  final HorizontalTextStyle style;
  final double maxWidth;

  const LayoutCacheKey({
    required this.text,
    required this.style,
    required this.maxWidth,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LayoutCacheKey &&
        other.text == text &&
        _stylesEqual(other.style, style) &&
        other.maxWidth == maxWidth;
  }

  @override
  int get hashCode => Object.hash(
        text,
        _styleHashCode(style),
        maxWidth,
      );

  /// Compare two HorizontalTextStyle instances for equality
  bool _stylesEqual(HorizontalTextStyle a, HorizontalTextStyle b) {
    return a.baseStyle.fontSize == b.baseStyle.fontSize &&
        a.baseStyle.color == b.baseStyle.color &&
        a.baseStyle.fontFamily == b.baseStyle.fontFamily &&
        a.lineSpacing == b.lineSpacing &&
        a.characterSpacing == b.characterSpacing &&
        a.adjustYakumono == b.adjustYakumono &&
        a.enableKinsoku == b.enableKinsoku &&
        a.enableHalfWidthYakumono == b.enableHalfWidthYakumono &&
        a.enableGyotoIndent == b.enableGyotoIndent &&
        a.enableKerning == b.enableKerning &&
        a.alignment == b.alignment;
  }

  /// Calculate hash code for HorizontalTextStyle
  int _styleHashCode(HorizontalTextStyle style) {
    return Object.hash(
      style.baseStyle.fontSize,
      style.baseStyle.color,
      style.baseStyle.fontFamily,
      style.lineSpacing,
      style.characterSpacing,
      style.adjustYakumono,
      style.enableKinsoku,
      style.enableHalfWidthYakumono,
      style.enableGyotoIndent,
      style.enableKerning,
      style.alignment,
    );
  }
}

/// Cached layout result
class LayoutCacheValue {
  final List<CharacterLayout> layouts;
  final Size size;

  const LayoutCacheValue({
    required this.layouts,
    required this.size,
  });
}

/// LRU cache for layout results
class LayoutCache {
  static const int maxCacheSize = 100;
  static final LinkedHashMap<LayoutCacheKey, LayoutCacheValue> _cache =
      LinkedHashMap<LayoutCacheKey, LayoutCacheValue>();

  /// Get cached layout result
  static LayoutCacheValue? get(LayoutCacheKey key) {
    final value = _cache.remove(key);
    if (value != null) {
      // Move to end (most recently used)
      _cache[key] = value;
    }
    return value;
  }

  /// Store layout result in cache
  static void put(LayoutCacheKey key, LayoutCacheValue value) {
    _cache.remove(key);
    _cache[key] = value;

    // Remove oldest entries if cache is full
    while (_cache.length > maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
  }

  /// Clear the cache
  static void clear() {
    _cache.clear();
  }

  /// Get cache statistics
  static Map<String, int> getStats() {
    return {
      'size': _cache.length,
      'maxSize': maxCacheSize,
    };
  }
}
