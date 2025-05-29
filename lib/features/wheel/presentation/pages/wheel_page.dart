import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/entry_list.dart';
import '../../application/wheel_provider.dart';
import 'dart:math';
import '../widgets/wheel_canvas.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Fortune Wheel'),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: EntryList()),

          Expanded(
            child: WheelCanvas(
              angle: _angle,
              onSpin: spinWheel,
            ),
          ),
        ],
      ),
    );
  }
}