import 'package:flutter/material.dart';

class WaitingConnection extends StatefulWidget {
  const WaitingConnection({super.key});

  @override
  State<WaitingConnection> createState() => _WaitingConnectionState();
}

class _WaitingConnectionState extends State<WaitingConnection> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Estableciendo conexión...",
            style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: EdgeInsets.all((height * width) * 0.0001),
            child: const CircularProgressIndicator(
              color: Color(0xFF0071E4),
            ),
          ),
        ],
      ),
    );
  }
}