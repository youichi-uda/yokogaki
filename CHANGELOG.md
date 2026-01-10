# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
