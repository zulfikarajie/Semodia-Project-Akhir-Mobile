import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SpeedometerPage extends StatefulWidget {
  const SpeedometerPage({Key? key}) : super(key: key);

  @override
  State<SpeedometerPage> createState() => _SpeedometerPageState();
}

class _SpeedometerPageState extends State<SpeedometerPage> {
  double _speed = 0.0;
  List<double> _lastAccel = [0, 0, 0];
  StreamSubscription? _accelSub;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEvents.listen((event) {
      // Hitung perubahan percepatan (delta)
      double delta = sqrt(
        pow(event.x - _lastAccel[0], 2) +
        pow(event.y - _lastAccel[1], 2) +
        pow(event.z - _lastAccel[2], 2)
      );
      _lastAccel = [event.x, event.y, event.z];
      setState(() {
        // Kalikan delta agar lebih "terlihat" sebagai speedometer
        _speed = (delta * 10).clamp(0, 100);
      });
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SPEEDOMETER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kecepatan (estimasi)',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            Text(
              '${_speed.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 24),
            Icon(Icons.speed, size: 80, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              'Gerakkan HP untuk melihat perubahan!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}