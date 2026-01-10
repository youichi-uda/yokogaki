# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
