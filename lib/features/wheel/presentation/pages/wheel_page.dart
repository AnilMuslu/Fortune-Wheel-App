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
  double _angle = 0;
  double _targetAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
        setState(() {
          _angle = _controller.value * _targetAngle;
        });
      });
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
    _targetAngle = 2 * pi * spins + (2 * pi / entries.length) * newIndex;

    _controller.reset();
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
            child: GestureDetector(
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
          ),
        ],
      ),
    );
  }
}
