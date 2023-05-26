import 'package:flutter/material.dart';

/* ==================== VALUE MMHG ==================== */
class ValueMmhg extends StatefulWidget {
  const ValueMmhg({super.key, required this.currentValue});
  final String currentValue;

  @override
  State<ValueMmhg> createState() => _ValueMmhgState();
}

class _ValueMmhgState extends State<ValueMmhg> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    return Text(
      '${widget.currentValue.replaceAll(RegExp("[A-Za-z]"), "")} mmHg',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: hxw * 0.00008,
        color: Colors.white
      ),
    );
  }
}
/* ==================== END VALUE MMHG ==================== */

/* ==================== VALUE KPA ==================== */
class ValueKpa extends StatefulWidget {
  const ValueKpa({super.key, required this.currentValue});
  final String currentValue;

  @override
  State<ValueKpa> createState() => _ValueKpaState();
}

class _ValueKpaState extends State<ValueKpa> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    return Text(
      '${((double.tryParse(widget.currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) * 0.133322).toStringAsFixed(2)} kpa',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: hxw * 0.00008,
        color: Colors.white
      ),
    );
  }
}
/* ==================== END VALUE KPA ==================== */


/* ==================== VALUE PERCENT ==================== */
class ValuePercent extends StatefulWidget {
  const ValuePercent({super.key, required this.currentValue});
  final String currentValue;

  @override
  State<ValuePercent> createState() => _ValuePercentState();
}

class _ValuePercentState extends State<ValuePercent> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    return Text(
      '${((double.tryParse(widget.currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) / 7.6).toStringAsFixed(2)}%',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: hxw * 0.00008,
        color: Colors.white
      ),
    );
  }
}
/* ==================== END VALUE PERCENT ==================== */