import 'package:flutter/material.dart';

class WaitingDataCPI extends StatefulWidget {
  const WaitingDataCPI({super.key});

  @override
  State<WaitingDataCPI> createState() => _WaitingDataCPIState();
}

class _WaitingDataCPIState extends State<WaitingDataCPI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Esperando datos...",
            style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w200),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Color(0xFF0071E4),
            ),
          ),
        ],
      ),
    );
  }
}
