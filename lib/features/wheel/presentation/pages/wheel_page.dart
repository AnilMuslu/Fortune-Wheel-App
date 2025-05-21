import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/entry_list.dart';
import '../widgets/wheel_painter.dart';
import '../../application/wheel_provider.dart';
import 'dart:math';

class WheelPage extends ConsumerStatefulWidget {
  const WheelPage({super.key});

  @override
  ConsumerState<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends ConsumerState<WheelPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  double _targetAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();  
  }

  void spinWheel() {
    final entries = ref.read(entriesProvider);
    if (entries.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one entry before spinning.")),
      );
      return;
    } // hiçbir şey yapma

    final random = Random();
    final newIndex = random.nextInt(entries.length);

    const spins = 5;
    final anglePerEntry = 2 * pi / entries.length;

    // Kazanan dilim saat 3 yönüne denk gelsin istiyoruz -> 0 radian (canvas'ın pozisyonuna göre)
    _targetAngle = spins * 2 * pi + (2 * pi - (anglePerEntry * newIndex + anglePerEntry / 2));

    _controller.reset();
    
    final curvedAnimation = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeOutCubic, // Daha yumuşak duruş için easeOutCubic
    );

    _animation = Tween<double>(
      begin: _angle,
      end: _targetAngle,
    ).animate(curvedAnimation)
      ..addListener((){
        setState(() {
          _angle = _animation.value;
        });
      });

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(entriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Fortune Wheel'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: EntryList(),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: spinWheel,
                  child: CustomPaint(
                    painter: WheelPainter(entries: entries, angle: _angle),
                    child: const Center(
                      child: Text(
                        'SPIN',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Saat 3 yönünde gösterge üçgeni
                Positioned(
                  right: 16,
                  child: CustomPaint(
                    size: const Size(20, 20),
                    painter: TrianglePainter(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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