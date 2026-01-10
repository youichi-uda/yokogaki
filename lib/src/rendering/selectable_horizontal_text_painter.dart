import 'package:flutter/material.dart';
import '../models/horizontal_text_style.dart';
import '../models/ruby_text.dart';
import '../models/kenten.dart';
import '../models/warichu.dart';
import 'horizontal_text_layouter.dart';
import '../utils/ruby_renderer.dart';
import '../utils/kenten_renderer.dart';
import '../utils/warichu_renderer.dart';

/// Custom painter for selectable horizontal Japanese text
class SelectableHorizontalTextPainter extends CustomPainter {
  final String text;
  final HorizontalTextStyle style;
  final double maxWidth;
  final bool showGrid;
  final List<RubyText> rubyList;
  final List<Kenten> kentenList;
  final List<Warichu> warichuList;
  final int? selectionStart;
  final int? selectionEnd;
  final Color selectionColor;
  final void Function(List<CharacterLayout>)? onLayoutsCalculated;

  SelectableHorizontalTextPainter({
    required this.text,
    required this.style,
    this.maxWidth = 0,
    this.showGrid = false,
    this.rubyList = const [],
    this.kentenList = const [],
    this.warichuList = const [],
    this.selectionStart,
    this.selectionEnd,
    this.selectionColor = const Color(0x6633B5E5),
    this.onLayoutsCalculated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    // Layout the text
    final layouts = HorizontalTextLayouter.layout(
      text: text,
      style: style,
      maxWidth: maxWidth,
    );

    // Notify parent of layouts for hit testing
    onLayoutsCalculated?.call(layouts);

    final fontSize = style.baseStyle.fontSize ?? 16.0;

    // Draw grid if enabled (for debugging)
    if (showGrid) {
      _drawGrid(canvas, size, fontSize);
    }

    // Draw selection background
    if (selectionStart != null && selectionEnd != null) {
      _drawSelection(canvas, layouts, fontSize);
    }

    // Layout ruby text if any
    final rubyLayouts = rubyList.isNotEmpty
        ? RubyRenderer.layoutRuby(
            text,
            rubyList,
            style,
            layouts,
            kentenList: kentenList,
          )
        : <RubyLayout>[];

    // Layout kenten marks if any
    final kentenLayouts = kentenList.isNotEmpty
        ? KentenRenderer.layoutKenten(text, kentenList, style, layouts)
        : <KentenLayout>[];

    // Layout warichu annotations if any
    final warichuLayouts = warichuList.isNotEmpty
        ? WarichuRenderer.layoutWarichu(text, warichuList, style, layouts)
        : <WarichuLayout>[];

    // Draw each character
    for (final layout in layouts) {
      _drawCharacter(canvas, layout, fontSize);
    }

    // Draw ruby text
    if (rubyLayouts.isNotEmpty) {
      RubyRenderer.render(canvas, rubyLayouts, style);
    }

    // Draw kenten marks
    if (kentenLayouts.isNotEmpty) {
      KentenRenderer.render(canvas, kentenLayouts, style);
    }

    // Draw warichu annotations
    if (warichuLayouts.isNotEmpty) {
      WarichuRenderer.render(canvas, warichuLayouts, style);
    }
  }

  void _drawSelection(Canvas canvas, List<CharacterLayout> layouts, double fontSize) {
    final start = selectionStart! < selectionEnd! ? selectionStart! : selectionEnd!;
    final end = selectionStart! < selectionEnd! ? selectionEnd! : selectionStart!;

    final paint = Paint()
      ..color = selectionColor
      ..style = PaintingStyle.fill;

    for (final layout in layouts) {
      final index = layout.textIndex;
      if (index >= start && index < end) {
        final rect = Rect.fromLTWH(
          layout.position.dx,
          layout.position.dy,
          fontSize,
          fontSize,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  // Reusable TextPainter instance to avoid repeated allocations
  static final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  void _drawCharacter(Canvas canvas, CharacterLayout layout, double fontSize) {
    _textPainter.text = TextSpan(
      text: layout.character,
      style: style.baseStyle,
    );

    _textPainter.layout();
    _textPainter.paint(canvas, layout.position);
  }

  void _drawGrid(Canvas canvas, Size size, double fontSize) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    // Draw vertical lines (columns)
    for (double x = 0; x <= size.width; x += fontSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines (rows)
    for (double y = 0; y <= size.height; y += fontSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SelectableHorizontalTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        style != oldDelegate.style ||
        maxWidth != oldDelegate.maxWidth ||
        showGrid != oldDelegate.showGrid ||
        rubyList != oldDelegate.rubyList ||
        kentenList != oldDelegate.kentenList ||
        warichuList != oldDelegate.warichuList ||
        selectionStart != oldDelegate.selectionStart ||
        selectionEnd != oldDelegate.selectionEnd ||
        selectionColor != oldDelegate.selectionColor;
  }
}
