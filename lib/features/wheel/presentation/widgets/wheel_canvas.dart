import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/wheel_provider.dart';
import 'spin_button.dart';
import 'wheel_painter.dart';

class WheelCanvas extends ConsumerWidget {
  final double angle;
  final VoidCallback onSpin;

  const WheelCanvas({
    super.key,
    required this.angle,
    required this.onSpin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: WheelPainter(entries: entries, angle: angle),
          size: Size.infinite,
        ),
        SpinButton(onPressed: onSpin),
        Positioned(
          right: 16,
          child: CustomPaint(
            size: Size(20, 20),
            painter: TrianglePainter(),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
