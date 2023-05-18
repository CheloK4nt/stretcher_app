import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0071E4),
      body: Center(
        child: Image.asset(
          "assets/images/ISO_EXHALAPP.png",
          scale: 1.8,
        ),
      ),
    );
  }
}