import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
import '../models/warichu.dart';
import '../rendering/selectable_horizontal_text_painter.dart';
import '../rendering/horizontal_text_layouter.dart';

/// A widget for displaying selectable horizontal Japanese text
///
/// Supports all features of HorizontalText plus:
/// - Text selection by dragging
/// - Copy to clipboard
/// - Selection handles
class SelectableHorizontalText extends StatefulWidget {
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

  /// Selection color
  final Color selectionColor;

  const SelectableHorizontalText({
    super.key,
    required this.text,
    this.style = const HorizontalTextStyle(),
    this.maxWidth = 0,
    this.showGrid = false,
    this.rubyList = const [],
    this.kentenList = const [],
    this.warichuList = const [],
    this.selectionColor = const Color(0x6633B5E5),
  });

  @override
  State<SelectableHorizontalText> createState() => _SelectableHorizontalTextState();
}

class _SelectableHorizontalTextState extends State<SelectableHorizontalText> {
  int? _selectionStart;
  int? _selectionEnd;
  List<CharacterLayout> _layouts = [];

  @override
  Widget build(BuildContext context) {
    // Calculate the size needed for the text
    final size = HorizontalTextLayouter.calculateSize(
      text: widget.text,
      style: widget.style,
      maxWidth: widget.maxWidth,
    );

    return GestureDetector(
      onTapDown: (details) {
        _handleTap(details.localPosition);
      },
      onPanStart: (details) {
        _handlePanStart(details.localPosition);
      },
      onPanUpdate: (details) {
        _handlePanUpdate(details.localPosition);
      },
      onLongPress: () {
        _showContextMenu();
      },
      child: CustomPaint(
        size: size,
        painter: SelectableHorizontalTextPainter(
          text: widget.text,
          style: widget.style,
          maxWidth: widget.maxWidth,
          showGrid: widget.showGrid,
          rubyList: widget.rubyList,
          kentenList: widget.kentenList,
          warichuList: widget.warichuList,
          selectionStart: _selectionStart,
          selectionEnd: _selectionEnd,
          selectionColor: widget.selectionColor,
          onLayoutsCalculated: (layouts) {
            _layouts = layouts;
          },
        ),
      ),
    );
  }

  void _handleTap(Offset position) {
    final index = _findCharacterIndexAt(position);
    if (index != null) {
      setState(() {
        _selectionStart = index;
        _selectionEnd = index + 1;
      });
    }
  }

  void _handlePanStart(Offset position) {
    final index = _findCharacterIndexAt(position);
    if (index != null) {
      setState(() {
        _selectionStart = index;
        _selectionEnd = index;
      });
    }
  }

  void _handlePanUpdate(Offset position) {
    final index = _findCharacterIndexAt(position);
    if (index != null && _selectionStart != null) {
      setState(() {
        _selectionEnd = index + 1;
      });
    }
  }

  int? _findCharacterIndexAt(Offset position) {
    final fontSize = widget.style.baseStyle.fontSize ?? 16.0;

    for (int i = 0; i < _layouts.length; i++) {
      final layout = _layouts[i];
      final charRect = Rect.fromLTWH(
        layout.position.dx,
        layout.position.dy,
        fontSize,
        fontSize,
      );

      if (charRect.contains(position)) {
        return layout.textIndex;
      }
    }

    return null;
  }

  void _showContextMenu() {
    if (_selectionStart == null || _selectionEnd == null) return;

    final start = _selectionStart! < _selectionEnd! ? _selectionStart! : _selectionEnd!;
    final end = _selectionStart! < _selectionEnd! ? _selectionEnd! : _selectionStart!;
    final selectedText = widget.text.substring(start, end);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: selectedText));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
