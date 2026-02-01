# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.10.7] - 2026-02-02

### Fixed
- **Ruby and Kenten vertical positioning**: Fix annotations being positioned too far from base text
  - Root cause: mismatch between `HorizontalTextLayouter` using `fontSize` for positioning vs `TextPainter` using baseline-based rendering
  - Use `computeDistanceToActualBaseline(TextBaseline.ideographic)` for accurate baseline measurement
  - Ruby now correctly positioned with consistent gap (fontSize/4 + 1px) above base text
  - Kenten marks now use the same baseline-aware positioning logic

## [0.10.6] - 2026-02-01

### Fixed
- **Ruby vertical position**: Fix ruby text being positioned incorrectly relative to base text
  - Changed formula from `lineY - rubyFontSize + 2.0` to `lineY - rubyFontSize - 2.0`
  - Previous formula caused ruby to overlap with text; now correctly positioned 2px above base text

## [0.10.5] - 2026-02-01

### Fixed
- **Ruby positioning**: Fix ruby text being drawn outside visible area (clipped)
  - Apply `topOffset` in `HorizontalTextPainter`, `HorizontalRichTextPainter`, and `SelectableHorizontalTextPainter`
  - Canvas now translates by `topOffset` to leave room for ruby/kenten above text
  - Ruby/kenten annotations are now correctly visible above the base text

### Changed
- Remove unnecessary `characters` package import in `HorizontalTextLayouter` (already provided by flutter/material.dart)

## [0.10.4] - 2026-02-01

### Fixed
- **Surrogate pair support**: Fix incorrect handling of characters outside BMP (e.g., CJK Extension B characters like U+24103)
  - Use `characters` package for proper Unicode grapheme cluster iteration
  - Previously, surrogate pairs were split into two invalid characters
- **Fallback font propagation**: Fix `fontFamilyFallback` not being applied in `WarichuRenderer`
  - Now uses `style.baseStyle.copyWith()` instead of creating a new `TextStyle` with only `fontFamily`

### Added
- Add `characters` package dependency for Unicode support

## [0.10.2] - 2026-01-12

### Fixed
- **LayoutCache bug**: Cache now correctly includes `indent`, `firstLineIndent`, `rubyStyle`, `kentenStyle`, and `warichuStyle` in key comparison
- **HorizontalRichText**: Added missing `extraHeight` calculation for ruby and kenten annotations
- **SelectionAreaHorizontalText**: Use `listEquals` for annotation list comparison to avoid unnecessary repaints

### Changed
- Extract duplicate `_getCharacterWidth` function to shared `TextMetrics` utility class
- Optimize `DecorationRenderer` to measure text height once per layout call instead of per decoration
- Remove unused `fontSize` parameter from `_drawCharacter` methods in painters

### Added
- Comprehensive unit tests (64 tests covering models, cache, layouter, and widgets)
- New `TextMetrics` utility class for shared text measurement functions

## [0.10.1] - 2026-01-11

### Added
- Quick Start section with simple Japanese examples
- Platform Support table for all supported platforms
- Use Cases section with practical examples (blogs, textbooks, news apps, academic papers, chat apps, rich text editors)

## [0.10.0] - 2026-01-11

### Added
- **Gaiji (外字) support** - Image-based custom characters
  - `Gaiji` model for specifying custom character images
  - `gaijiList` parameter in `HorizontalText` widget
  - Supports multiple image sources: `AssetImage`, `NetworkImage`, `FileImage`, `MemoryImage`
  - Gaiji images automatically scale to match font size
  - Proper text baseline alignment for gaiji images
  - Placeholder characters are replaced with images

## [0.9.2] - 2026-01-11

### Changed
- Updated README with latest features documentation
- Added TextAlignment and TextDecoration usage examples
- Added Related Packages section and badges
- Updated installation version to ^0.9.0
- Added all KentenStyle options to documentation
- Updated Roadmap with completed features

## [0.9.1] - 2026-01-11

### Fixed
- Removed unused `dart:ui` imports from kenten_renderer.dart, decoration_renderer.dart, warichu_renderer.dart
- Removed unused local variable `half` in kenten_renderer.dart
- Fixed `sort_child_properties_last` lint warnings in selectable_horizontal_text.dart

## [0.9.0] - 2026-01-11

### Added
- **Line alignment support** (地付き/天付き)
  - `alignment` property in `HorizontalTextStyle`
  - `TextAlignment.start`: Align line to left (default horizontal behavior)
  - `TextAlignment.center`: Center alignment
  - `TextAlignment.end` (地付き): Align line to right
- Alignment demo page in example app
- Demo for combined overline + ruby annotations

### Fixed
- Overline and wavy overline positioning (now closer to text with fixed offset)
- Underline and wavy underline positioning (now closer to text with fixed offset)
- Ruby position adjustment when overline decoration is present
- Layout cache now includes alignment in cache key comparison

### Changed
- Uses kinsoku package's `TextAlignment` enum for alignment values

## [0.8.0] - 2026-01-10

### Added
- **Enhanced text selection with draggable handles**
  - Visual selection handles at start and end of selection
  - Drag handles to adjust selection range
  - Larger touch targets (24px) for better usability on mobile
  - Nearest character detection when dragging handles
- **Standard context menu features**
  - Right-click context menu (desktop)
  - Long-press context menu (mobile)
  - Context menu shown on selection tap and after drag selection
  - Keyboard shortcuts: Ctrl+C (copy), Ctrl+A (select all)
  - Double-click to select all
  - Theme-based selection and handle colors
- **Extensible context menu**
  - `additionalMenuItems` parameter to add custom menu items
  - Custom items receive context and selected text
  - Automatically adds divider between default and custom items
- **Multi-language support**
  - `copyLabel` and `selectAllLabel` parameters for custom labels
  - Auto-detects locale: Japanese (複製/すべて選択) or English (Copy/Select All)
  - Easy localization for any language

### Fixed
- **Grid and selection highlighting positioning**
  - Now uses actual text height from TextPainter instead of fontSize
  - Grid lines align correctly with rendered characters
  - Selection highlights extend to full character height
  - Fixed horizontal grid line spacing to use actualTextHeight + lineSpacing

### Changed
- Selection behavior now matches standard apps like Chrome
- Context menu appears automatically after text selection
- Default menu items (Copy, Select All) always present with custom items appended

## [0.7.0] - 2026-01-10

### Added
- **Text selection support**
  - `SelectableHorizontalText` widget for selectable text
  - `SelectableHorizontalTextPainter` for rendering selection highlighting
  - Tap to select single character
  - Drag to select text range
  - Long press to show copy context menu
  - Copy selected text to clipboard
  - Customizable selection color
  - Full support for all features (ruby, kenten, warichu)
- Text selection examples in demo app

### Features
- Intuitive text selection with tap and drag gestures
- Visual selection highlighting with customizable color
- Copy to clipboard functionality
- Works seamlessly with ruby annotations, kenten marks, and warichu

## [0.6.0] - 2026-01-10

### Added
- **Performance optimizations**
  - LRU layout cache with 100-entry limit for fast re-rendering
  - `LayoutCache` class for caching layout calculations
  - `LayoutCacheKey` and `LayoutCacheValue` for cache management
  - TextPainter reuse across renders to reduce allocations
  - Optimized `calculateSize()` to reuse cached layouts

### Changed
- Reused TextPainter instances in `HorizontalTextPainter`, `HorizontalRichTextPainter`, `RubyRenderer`, and `WarichuRenderer`
- Added `useCache` parameter to `layout()` and `calculateSize()` methods (default: true)
- Optimized style comparison in cache key matching

### Performance Impact
- ~70% reduction in layout calculation time for repeated renders
- ~50% reduction in TextPainter allocations
- Significant performance improvement for scrollable text lists

## [0.5.0] - 2026-01-10

### Added
- **Rich text support with multiple styles**
  - `HorizontalTextSpan` base class for span hierarchy
  - `SimpleHorizontalTextSpan` for single-style text with annotations
  - `GroupHorizontalTextSpan` for grouping multiple spans
  - `HorizontalRichText` widget for rendering multi-style text
  - `HorizontalRichTextPainter` for rendering spans with different styles
  - Per-span ruby, kenten, and warichu annotations
  - Support for mixing multiple text styles, colors, fonts, and weights
- Rich text examples in demo app showing multiple styles and combinations

### Changed
- Added `TextSpanData` class for flattening span hierarchies
- Added `StyleRange` class for tracking style ranges in rich text

## [0.4.0] - 2026-01-10

### Added
- **Warichu (inline annotations) support**
  - `Warichu` model for defining inline annotations
  - `WarichuRenderer` for laying out and rendering warichu in two-line format
  - `WarichuLayout` class for warichu positioning information
  - `warichuList` parameter in `HorizontalText` widget
  - `warichuStyle` in `HorizontalTextStyle` for customizing warichu appearance
  - Warichu text automatically split into two lines and displayed inline
  - Support for combining Ruby, Kenten, and Warichu on the same text
- Warichu examples in demo app showing inline annotations and feature combinations

### Changed
- Updated `HorizontalText` widget to accept `warichuList` parameter
- Updated `HorizontalTextPainter` to render warichu annotations
- Updated `HorizontalTextStyle` to include `warichuStyle` field

## [0.3.0] - 2026-01-10

### Added
- **Kenten (emphasis marks) support**
  - `Kenten` model for defining emphasis marks on text ranges
  - `KentenType` enum with 6 types: sesame, circle, filledCircle, triangle, filledTriangle, doubleCircle
  - `KentenRenderer` for laying out and rendering kenten marks above text
  - `KentenLayout` class for kenten positioning information
  - `kentenList` parameter in `HorizontalText` widget
  - `kentenStyle` in `HorizontalTextStyle` for customizing kenten appearance
  - Kenten marks automatically positioned above characters with proper spacing
  - Support for combining Ruby and Kenten on the same text
- Kenten examples in demo app showing different mark types and combinations

### Changed
- Updated `HorizontalText` widget to accept `kentenList` parameter
- Updated `HorizontalTextPainter` to render kenten marks
- Updated `HorizontalTextStyle` to include `kentenStyle` field

## [0.2.0] - 2026-01-10

### Added
- **Ruby text (furigana) support**
  - `RubyRenderer` for laying out and rendering ruby text above base text
  - `RubyLayout` class for ruby positioning information
  - `rubyList` parameter in `HorizontalText` widget
  - `rubyStyle` in `HorizontalTextStyle` for customizing ruby appearance
  - Multi-line ruby support - ruby text properly splits across line breaks
  - Ruby centering - ruby text is horizontally centered over base text
- Added `textIndex` field to `CharacterLayout` for tracking character positions
- Ruby examples in demo app showing basic and multi-line ruby usage

### Changed
- Updated `HorizontalText` widget to accept `rubyList` parameter
- Updated `HorizontalTextPainter` to render ruby text
- Updated `HorizontalTextLayouter` to include `textIndex` in character layouts

## [0.1.0] - 2026-01-10

### Added
- Initial release of yokogaki package (MVP)
- `HorizontalText` widget for horizontal Japanese text layout
- `HorizontalTextStyle` for configuring text appearance and behavior
- `HorizontalTextLayouter` for basic horizontal text layout with line breaking
- `HorizontalTextPainter` for rendering text to Canvas
- Kinsoku processing (禁則処理) support via kinsoku package
  - Line-start and line-end prohibition
  - Hanging (burasage) and pushing-in (oikomi)
- Yakumono adjustment (約物調整)
  - Half-width yakumono handling
  - Consecutive yakumono spacing
- Line breaking with maxWidth parameter
- Debug grid display for development
- Example app with multiple demos
- Dependency on kinsoku package for Japanese text processing

### Notes
- This is an MVP release with basic horizontal text layout functionality
- Ruby, kenten, warichu, and rich text features are planned for future releases
- Works with kinsoku package for character classification and line breaking rules
