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

  // Çarkı döndürmek için önce canvas'ı merkeze çevir, sonra döndür
  canvas.translate(center.dx, center.dy);
  canvas.rotate(angle); // Burada açı uygulanıyor
  canvas.translate(-center.dx, -center.dy);

  final anglePerEntry = entries.isEmpty ? 2 * pi : 2 * pi / entries.length;

  for (int i = 0; i < (entries.isEmpty ? 1 : entries.length); i++) {
    final entry = entries.isEmpty ? Entry("No entries yet") : entries[i];

    // Dilimin rengini belirle
    paint.color = entries.isEmpty
        ? Colors.grey[300]!
        : Color((entry.text.hashCode * 0xFFFFFF) | 0xFF000000);

    // Dilimi çiz
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

    final labelAngle = anglePerEntry * i + anglePerEntry / 2;

    /// Metin çiziminden önce canvas durumunu kaydet
    canvas.save();

    // canvas'ı merkeze taşı, sonra dilim açısına döndür
    canvas.translate(center.dx, center.dy);
    canvas.rotate(labelAngle); // metin çizim yönü

    // Metni çizeceğimiz konuma gidip düz bir şekilde çizeriz
    final offset = Offset(
      radius / 2 - textPainter.width / 2, // x: merkezin sağında
      -textPainter.height / 2,            // y: merkez hizasında
    );
    textPainter.paint(canvas, offset);

    // canvas'ı eski haline döndür
    canvas.restore();
  }
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
