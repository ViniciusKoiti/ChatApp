import 'package:flutter/material.dart';

class CrossPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final double density;

  CrossPatternPainter({
    required this.color,
    this.opacity = 0.1,
    this.density = 30.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final horizontalSpacing = size.width / density;
    final verticalSpacing = size.height / density;

    // Desenhar cruzes em um padrão de grade
    for (double x = 0; x < size.width; x += horizontalSpacing) {
      for (double y = 0; y < size.height; y += verticalSpacing) {
        _drawCross(canvas, paint, Offset(x, y), horizontalSpacing * 0.4);
      }
    }
  }

  void _drawCross(Canvas canvas, Paint paint, Offset center, double size) {
    // Linha vertical da cruz
    canvas.drawLine(
      Offset(center.dx, center.dy - size / 2),
      Offset(center.dx, center.dy + size / 2),
      paint,
    );

    // Linha horizontal da cruz
    canvas.drawLine(
      Offset(center.dx - size / 3, center.dy),
      Offset(center.dx + size / 3, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(CrossPatternPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.density != density;
  }
} 