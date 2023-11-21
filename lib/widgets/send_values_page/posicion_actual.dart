import 'package:flutter/material.dart';

class PosicionActual extends StatefulWidget {
  const PosicionActual({super.key, required this.posicion});
  final String posicion;

  @override
  State<PosicionActual> createState() => _PosicionActualState();
}

class _PosicionActualState extends State<PosicionActual> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFF0071E4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PosicionActualTitle(),
            const SizedBox(height: 8, width: 8,),
            (widget.posicion != "" && widget.posicion != null)? PosicionActualValor(valor: widget.posicion) :const PosicionActualValor(valor: "--"),
          ],
        ),
      ),
    );
  }
}

class PosicionActualTitle extends StatelessWidget {
  const PosicionActualTitle({super.key});

  @override
  Widget build(BuildContext context) {

    return Text("Posición Actual",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: MediaQuery.textScaleFactorOf(context) * 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PosicionActualValor extends StatefulWidget {
  const PosicionActualValor({super.key, required this.valor});
  final String valor;

  @override
  State<PosicionActualValor> createState() => _PosicionActualValorState();
}

class _PosicionActualValorState extends State<PosicionActualValor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.valor,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF0071E4),
            fontSize: MediaQuery.textScaleFactorOf(context) * 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
