import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entry.dart';

class WheelPainter extends CustomPainter {
  final List<Entry> entries;
  final double angle;
  final List<Color> colors = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.amberAccent,
  ];

  WheelPainter({required this.entries, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    final sweepAngle = 2 * pi / entries.length;
    var startAngle = angle;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < entries.length; i++) {
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: entries[i].text,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius * 0.7);

      final x = center.dx + radius * 0.6 * cos(startAngle + sweepAngle / 2);
      final y = center.dy + radius * 0.6 * sin(startAngle + sweepAngle / 2);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(startAngle + sweepAngle / 2 + pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
