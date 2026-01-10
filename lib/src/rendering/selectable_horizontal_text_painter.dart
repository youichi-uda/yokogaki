import 'package:flutter/material.dart';
import 'package:kinsoku/kinsoku.dart';
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
  final Color handleColor;
  final bool showHandles;
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
    this.handleColor = const Color(0xFF2196F3),
    this.showHandles = true,
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

    // Draw selection handles
    if (showHandles && selectionStart != null && selectionEnd != null) {
      _drawSelectionHandles(canvas, layouts, fontSize);
    }
  }

  void _drawSelectionHandles(Canvas canvas, List<CharacterLayout> layouts, double fontSize) {
    final start = selectionStart! < selectionEnd! ? selectionStart! : selectionEnd!;
    final end = selectionStart! < selectionEnd! ? selectionEnd! : selectionStart!;

    if (end - start == 0) return;

    // Find start and end character layouts
    CharacterLayout? startLayout;
    CharacterLayout? endLayout;

    for (final layout in layouts) {
      if (layout.textIndex == start) {
        startLayout = layout;
      }
      if (layout.textIndex == end - 1) {
        endLayout = layout;
      }
    }

    // Measure actual text height
    final textPainter = TextPainter(
      text: TextSpan(text: 'あ', style: style.baseStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final actualTextHeight = textPainter.height;

    const handleRadius = 6.0;
    const handleLineHeight = 20.0;

    // Draw start handle
    if (startLayout != null) {
      _drawHandle(
        canvas,
        Offset(startLayout.position.dx, startLayout.position.dy),
        actualTextHeight,
        handleRadius,
        handleLineHeight,
        isStart: true,
      );
    }

    // Draw end handle
    if (endLayout != null) {
      final charWidth = YakumonoAdjuster.isHalfWidthYakumono(endLayout.character)
          ? fontSize * 0.5
          : fontSize;
      _drawHandle(
        canvas,
        Offset(endLayout.position.dx + charWidth, endLayout.position.dy),
        actualTextHeight,
        handleRadius,
        handleLineHeight,
        isStart: false,
      );
    }
  }

  void _drawHandle(
    Canvas canvas,
    Offset position,
    double textHeight,
    double radius,
    double lineHeight,
    {required bool isStart}
  ) {
    final paint = Paint()
      ..color = handleColor
      ..style = PaintingStyle.fill;

    // Draw vertical line
    final lineStart = Offset(position.dx, position.dy);
    final lineEnd = Offset(position.dx, position.dy + textHeight);
    canvas.drawLine(
      lineStart,
      lineEnd,
      Paint()
        ..color = handleColor
        ..strokeWidth = 2.0,
    );

    // Draw circle handle at bottom
    final handleCenter = Offset(
      position.dx,
      position.dy + textHeight + radius,
    );
    canvas.drawCircle(handleCenter, radius, paint);

    // Draw white border
    canvas.drawCircle(
      handleCenter,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawSelection(Canvas canvas, List<CharacterLayout> layouts, double fontSize) {
    final start = selectionStart! < selectionEnd! ? selectionStart! : selectionEnd!;
    final end = selectionStart! < selectionEnd! ? selectionEnd! : selectionStart!;

    final paint = Paint()
      ..color = selectionColor
      ..style = PaintingStyle.fill;

    // Measure actual text height using TextPainter
    final textPainter = TextPainter(
      text: TextSpan(text: 'あ', style: style.baseStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final actualTextHeight = textPainter.height;

    for (final layout in layouts) {
      final index = layout.textIndex;
      if (index >= start && index < end) {
        final charWidth = YakumonoAdjuster.isHalfWidthYakumono(layout.character)
            ? fontSize * 0.5
            : fontSize;
        final rect = Rect.fromLTWH(
          layout.position.dx,
          layout.position.dy,
          charWidth,
          actualTextHeight,
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

    // Measure actual text height using TextPainter
    final textPainter = TextPainter(
      text: TextSpan(text: 'あ', style: style.baseStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final actualTextHeight = textPainter.height;

    // Draw vertical lines (columns)
    for (double x = 0; x <= size.width; x += fontSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines (rows) using actual text height + line spacing
    final lineHeight = actualTextHeight + style.lineSpacing;
    for (double y = 0; y <= size.height; y += lineHeight) {
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
        selectionColor != oldDelegate.selectionColor ||
        handleColor != oldDelegate.handleColor ||
        showHandles != oldDelegate.showHandles;
  }
}
