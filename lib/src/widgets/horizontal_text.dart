import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
import '../models/warichu.dart';
import '../models/text_decoration.dart';
import '../models/gaiji.dart';
import '../rendering/horizontal_text_painter.dart';
import '../rendering/horizontal_text_layouter.dart';

/// A widget for displaying horizontal Japanese text with advanced typography
///
/// Supports:
/// - Kinsoku processing (禁則処理 - Japanese line breaking rules)
/// - Yakumono adjustment (約物調整 - punctuation positioning)
/// - Kerning (character spacing adjustments)
/// - Ruby text (furigana)
/// - Gaiji (外字 - custom character images)
/// - Line breaking with proper character handling
class HorizontalText extends StatefulWidget {
  /// The text to display
  final String text;

  /// Style configuration for the text
  final HorizontalTextStyle style;

  /// Maximum width for line breaking (0 = no limit)
  final double maxWidth;

  /// Whether to show a debug grid
  final bool showGrid;

  /// Ruby text annotations
  final List<RubyText> rubyList;

  /// Kenten (emphasis marks) annotations
  final List<Kenten> kentenList;

  /// Warichu (inline annotations) annotations
  final List<Warichu> warichuList;

  /// Text decoration (underline, overline, etc.) annotations
  final List<TextDecorationAnnotation> decorationList;

  /// Gaiji (外字) image-based custom characters
  final List<Gaiji> gaijiList;

  const HorizontalText({
    super.key,
    required this.text,
    this.style = const HorizontalTextStyle(),
    this.maxWidth = 0,
    this.showGrid = false,
    this.rubyList = const [],
    this.kentenList = const [],
    this.warichuList = const [],
    this.decorationList = const [],
    this.gaijiList = const [],
  });

  @override
  State<HorizontalText> createState() => _HorizontalTextState();
}

class _HorizontalTextState extends State<HorizontalText> {
  /// Resolved gaiji images
  final Map<int, ui.Image> _resolvedImages = {};

  /// Image streams for gaiji
  final Map<int, ImageStream> _imageStreams = {};

  /// Image stream listeners for proper disposal
  final Map<int, ImageStreamListener> _imageStreamListeners = {};

  @override
  void initState() {
    super.initState();
    _resolveGaijiImages();
  }

  @override
  void didUpdateWidget(HorizontalText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gaijiList != oldWidget.gaijiList) {
      _disposeImageStreams();
      _resolvedImages.clear();
      _resolveGaijiImages();
    }
  }

  @override
  void dispose() {
    _disposeImageStreams();
    super.dispose();
  }

  void _disposeImageStreams() {
    for (final entry in _imageStreams.entries) {
      final listener = _imageStreamListeners[entry.key];
      if (listener != null) {
        entry.value.removeListener(listener);
      }
    }
    _imageStreams.clear();
    _imageStreamListeners.clear();
  }

  void _resolveGaijiImages() {
    if (widget.gaijiList.isEmpty) return;

    for (int i = 0; i < widget.gaijiList.length; i++) {
      final gaiji = widget.gaijiList[i];
      final stream = gaiji.image.resolve(ImageConfiguration.empty);
      _imageStreams[i] = stream;

      final listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (mounted) {
            setState(() {
              _resolvedImages[i] = info.image;
            });
          }
        },
        onError: (exception, stackTrace) {
          // Handle image loading error silently
        },
      );
      _imageStreamListeners[i] = listener;
      stream.addListener(listener);
    }
  }

  Map<int, ui.Image>? _getResolvedImages() {
    if (widget.gaijiList.isEmpty) return null;
    if (_resolvedImages.isEmpty) return null;
    return _resolvedImages;
  }

  @override
  Widget build(BuildContext context) {
    // Get default text color from theme if not specified
    final defaultColor = widget.style.baseStyle.color ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        const Color(0xFF000000);

    // Merge default color with user style
    final effectiveStyle = widget.style.copyWith(
      baseStyle: widget.style.baseStyle.copyWith(color: defaultColor),
    );

    // Calculate the size needed for the text
    final baseSize = HorizontalTextLayouter.calculateSize(
      text: widget.text,
      style: effectiveStyle,
      maxWidth: widget.maxWidth,
    );

    // Add extra height for ruby and kenten
    final fontSize = effectiveStyle.baseStyle.fontSize ?? 16.0;
    double extraHeight = 0.0;

    if (widget.rubyList.isNotEmpty) {
      final rubyFontSize = effectiveStyle.rubyStyle?.fontSize ?? (fontSize * 0.5);
      extraHeight = rubyFontSize + 4.0; // ruby height + gap
    }

    if (widget.kentenList.isNotEmpty) {
      final kentenSize = fontSize * 0.3;
      final kentenHeight = kentenSize + 8.0; // kenten size + gap
      extraHeight = extraHeight > kentenHeight ? extraHeight : kentenHeight;
    }

    // If both ruby and kenten exist, use the larger one
    if (widget.rubyList.isNotEmpty && widget.kentenList.isNotEmpty) {
      final rubyFontSize = effectiveStyle.rubyStyle?.fontSize ?? (fontSize * 0.5);
      final kentenSize = fontSize * 0.3;
      extraHeight = rubyFontSize + kentenSize + 10.0; // both + gaps
    }

    final size = Size(baseSize.width, baseSize.height + extraHeight);

    return CustomPaint(
      size: size,
      painter: HorizontalTextPainter(
        text: widget.text,
        style: effectiveStyle,
        maxWidth: widget.maxWidth,
        showGrid: widget.showGrid,
        rubyList: widget.rubyList,
        kentenList: widget.kentenList,
        warichuList: widget.warichuList,
        decorationList: widget.decorationList,
        gaijiList: widget.gaijiList,
        resolvedGaijiImages: _getResolvedImages(),
        topOffset: extraHeight,
      ),
    );
  }
}
