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
  final center = Offset(size.width / 2, size.height / 2);
  final radius = size.width / 2;
  final paint = Paint()..style = PaintingStyle.fill;

  final anglePerEntry = entries.isEmpty ? 2 * pi : 2 * pi / entries.length;

  for (int i = 0; i < (entries.isEmpty ? 1 : entries.length); i++) {
    final entry = entries.isEmpty ? Entry("No entries yet") : entries[i];

    paint.color = entries.isEmpty
        ? Colors.grey[300]!  // Gri boş çark rengi
        : Color((entry.text.hashCode * 0xFFFFFF) | 0xFF000000);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      anglePerEntry * i,
      anglePerEntry,
      true,
      paint,
    );

    // Metin çizimi
    final textPainter = TextPainter(
      text: TextSpan(
        text: entry.text,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: radius);

    final angle = anglePerEntry * i + anglePerEntry / 2;
    final offset = Offset(
      center.dx + radius / 2 * cos(angle) - textPainter.width / 2,
      center.dy + radius / 2 * sin(angle) - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
