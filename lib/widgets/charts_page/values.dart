import 'package:stretcherapp/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentValue extends StatefulWidget {
  const CurrentValue({super.key, required this.currentValue, required this.function});
  final String currentValue;
  final Function()? function;

  @override
  State<CurrentValue> createState() => _CurrentValueState();
}

class _CurrentValueState extends State<CurrentValue> {
  @override
  Widget build(BuildContext context) {

    final uiProvider = context.watch<UIProvider>().selectedUnity;
    
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = width * height;

    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.07,
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(hxw * 0.00005)
        ),
        color: const Color(0xFF0071E4),
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              top: height * 0.05,
              left: width * 0.1,
              right: width * 0.1,
              bottom: height * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Valor Actual:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                                
                /* ========== CONDICIONAL TIPO DE UNIDAD A MOSTRAR ========== */
                (uiProvider == "Grafico mmHg")
                ?ValueMmhg(currentValue: widget.currentValue)
                : (uiProvider == "Grafico kpa")
                  ?ValueKpa(currentValue: widget.currentValue)
                  :ValuePercent(currentValue: widget.currentValue),
                /* ========== FIN CONDICIONAL ========== */
                                
                /* ========== TERMINAR EXAMEN ========== */
                Padding(
                  padding: EdgeInsets.only(top: height * 0.012),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Color(0xFF00C0FF),
                        )
                      ),
                      backgroundColor: const Color(0xFFBDEFFF),
                      foregroundColor: const Color(0xFF00C0FF),
                    ),
                    onPressed: () => widget.function,
                    child: const Text("Terminar exámen"),
                  ),
                ),
                /* ========== FIN TERMINAR EXAMEN ========== */
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class MeasureUnits extends StatefulWidget {
  const MeasureUnits({super.key});

  @override
  State<MeasureUnits> createState() => _MeasureUnitsState();
}

class _MeasureUnitsState extends State<MeasureUnits> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = width * height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("Unidades de medida:",
          style: TextStyle(
            fontSize: hxw * 0.00007,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}

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
      '${((double.tryParse(widget.currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) * 1).toStringAsFixed(0)} mmHg',
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
      '${((double.tryParse(widget.currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) * 0.133322).toStringAsFixed(0)} kpa',
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
      '${((double.tryParse(widget.currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) / 7.6).toStringAsFixed(0)}%',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: hxw * 0.00008,
        color: Colors.white
      ),
    );
  }
}
/* ==================== END VALUE PERCENT ==================== */