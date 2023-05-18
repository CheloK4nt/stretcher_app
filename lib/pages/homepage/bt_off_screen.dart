import 'package:flutter/material.dart';

class BluetoothOffScreen extends StatefulWidget {
  const BluetoothOffScreen({super.key});

  @override
  State<BluetoothOffScreen> createState() => _BluetoothOffScreenState();
}

class _BluetoothOffScreenState extends State<BluetoothOffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("BT Off Screen"),
      ),
    );
  }
}