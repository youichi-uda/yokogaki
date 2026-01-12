import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinsoku/kinsoku.dart';
import 'package:yokogaki/src/utils/layout_cache.dart';
import 'package:yokogaki/src/models/horizontal_text_style.dart';
import 'package:yokogaki/src/rendering/horizontal_text_layouter.dart';

void main() {
  setUp(() {
    LayoutCache.clear();
  });

  group('LayoutCacheKey', () {
    test('should be equal when all properties match', () {
      const style = HorizontalTextStyle();
      const key1 = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);

      expect(key1, equals(key2));
      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('should not be equal when text differs', () {
      const style = HorizontalTextStyle();
      const key1 = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);
      const key2 = LayoutCacheKey(text: '違う', style: style, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when maxWidth differs', () {
      const style = HorizontalTextStyle();
      const key1 = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 200);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when indent differs', () {
      const style1 = HorizontalTextStyle(indent: 1);
      const style2 = HorizontalTextStyle(indent: 2);
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when firstLineIndent differs', () {
      const style1 = HorizontalTextStyle(firstLineIndent: 1);
      const style2 = HorizontalTextStyle(firstLineIndent: 2);
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when rubyStyle differs', () {
      const style1 = HorizontalTextStyle(
        rubyStyle: TextStyle(fontSize: 8),
      );
      const style2 = HorizontalTextStyle(
        rubyStyle: TextStyle(fontSize: 10),
      );
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when kentenStyle differs', () {
      const style1 = HorizontalTextStyle(
        kentenStyle: TextStyle(color: Colors.red),
      );
      const style2 = HorizontalTextStyle(
        kentenStyle: TextStyle(color: Colors.blue),
      );
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when warichuStyle differs', () {
      const style1 = HorizontalTextStyle(
        warichuStyle: TextStyle(fontWeight: FontWeight.bold),
      );
      const style2 = HorizontalTextStyle(
        warichuStyle: TextStyle(fontWeight: FontWeight.normal),
      );
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should be equal when optional styles are both null', () {
      const style1 = HorizontalTextStyle();
      const style2 = HorizontalTextStyle();
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, equals(key2));
    });

    test('should not be equal when alignment differs', () {
      const style1 = HorizontalTextStyle(alignment: TextAlignment.start);
      const style2 = HorizontalTextStyle(alignment: TextAlignment.end);
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when characterSpacing differs', () {
      const style1 = HorizontalTextStyle(characterSpacing: 0.0);
      const style2 = HorizontalTextStyle(characterSpacing: 5.0);
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when lineSpacing differs', () {
      const style1 = HorizontalTextStyle(lineSpacing: 0.0);
      const style2 = HorizontalTextStyle(lineSpacing: 10.0);
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });

    test('should not be equal when enableKinsoku differs', () {
      const style1 = HorizontalTextStyle(enableKinsoku: true);
      const style2 = HorizontalTextStyle(enableKinsoku: false);
      const key1 = LayoutCacheKey(text: 'テスト', style: style1, maxWidth: 100);
      const key2 = LayoutCacheKey(text: 'テスト', style: style2, maxWidth: 100);

      expect(key1, isNot(equals(key2)));
    });
  });

  group('LayoutCache', () {
    test('should return null for missing key', () {
      const style = HorizontalTextStyle();
      const key = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);

      expect(LayoutCache.get(key), isNull);
    });

    test('should store and retrieve value', () {
      const style = HorizontalTextStyle();
      const key = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);
      final value = LayoutCacheValue(
        layouts: [
          CharacterLayout(
            character: 'テ',
            position: const Offset(0, 0),
            textIndex: 0,
          ),
        ],
        size: const Size(16, 16),
      );

      LayoutCache.put(key, value);
      final retrieved = LayoutCache.get(key);

      expect(retrieved, isNotNull);
      expect(retrieved!.layouts.length, 1);
      expect(retrieved.size, const Size(16, 16));
    });

    test('should clear cache', () {
      const style = HorizontalTextStyle();
      const key = LayoutCacheKey(text: 'テスト', style: style, maxWidth: 100);
      final value = LayoutCacheValue(
        layouts: [],
        size: Size.zero,
      );

      LayoutCache.put(key, value);
      expect(LayoutCache.get(key), isNotNull);

      LayoutCache.clear();
      expect(LayoutCache.get(key), isNull);
    });

    test('should report correct stats', () {
      const style = HorizontalTextStyle();
      final value = LayoutCacheValue(layouts: [], size: Size.zero);

      for (int i = 0; i < 5; i++) {
        final key = LayoutCacheKey(text: 'テスト$i', style: style, maxWidth: 100);
        LayoutCache.put(key, value);
      }

      final stats = LayoutCache.getStats();
      expect(stats['size'], 5);
      expect(stats['maxSize'], 100);
    });

    test('should evict oldest entries when cache is full', () {
      const style = HorizontalTextStyle();
      final value = LayoutCacheValue(layouts: [], size: Size.zero);

      // Fill cache beyond max size
      for (int i = 0; i < 105; i++) {
        final key = LayoutCacheKey(text: 'テスト$i', style: style, maxWidth: 100);
        LayoutCache.put(key, value);
      }

      final stats = LayoutCache.getStats();
      expect(stats['size'], 100); // Should be capped at maxSize

      // Oldest entries should be evicted
      const oldKey = LayoutCacheKey(text: 'テスト0', style: style, maxWidth: 100);
      expect(LayoutCache.get(oldKey), isNull);

      // Newest entries should still exist
      const newKey = LayoutCacheKey(text: 'テスト104', style: style, maxWidth: 100);
      expect(LayoutCache.get(newKey), isNotNull);
    });

    test('should update LRU order on get', () {
      const style = HorizontalTextStyle();
      final value = LayoutCacheValue(layouts: [], size: Size.zero);

      // Add entries
      for (int i = 0; i < 100; i++) {
        final key = LayoutCacheKey(text: 'テスト$i', style: style, maxWidth: 100);
        LayoutCache.put(key, value);
      }

      // Access first entry to move it to end
      const firstKey = LayoutCacheKey(text: 'テスト0', style: style, maxWidth: 100);
      LayoutCache.get(firstKey);

      // Add new entries to trigger eviction
      for (int i = 100; i < 105; i++) {
        final key = LayoutCacheKey(text: 'テスト$i', style: style, maxWidth: 100);
        LayoutCache.put(key, value);
      }

      // First entry should still exist (was recently accessed)
      expect(LayoutCache.get(firstKey), isNotNull);

      // Entry 1 should be evicted (wasn't accessed)
      const secondKey = LayoutCacheKey(text: 'テスト1', style: style, maxWidth: 100);
      expect(LayoutCache.get(secondKey), isNull);
    });
  });
}
