import 'package:exhalapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataCard extends StatefulWidget {
  const DataCard({super.key, required this.valor});
  final String valor;

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  @override
  Widget build(BuildContext context) {

    final prefs = UserPrefs();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hxw = width * height;

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(hxw * 0.000061),
              topRight: Radius.circular(hxw * 0.000061),
            )
          ),
          color: (prefs.darkMode)
            ?const Color(0xFF474864)
            :const Color(0xFFE0E0E0),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(hxw * 0.000061),
              topLeft: Radius.circular(hxw * 0.000061),
            ),
            splashColor: const Color(0xFFC8E3FF),
            highlightColor: const Color(0xFFC8E3FF),
            onTap: () => {
              Fluttertoast.cancel(),
              Fluttertoast.showToast(
                msg: "Hubo una cantidad total de ${widget.valor} datos.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER
              ),
            },
            child: SizedBox(
              width: width * 0.39,
              height: height * 0.15,
              child: Column(
                children: [
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.01,
                      height * 0.03,
                      width * 0.01,
                      0,
                    ),
                    child: Image.asset(
                      'assets/images/datos_totales.png',
                      height: height * 0.05,
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(hxw * 0.000025),
                    child: Text(widget.valor,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: hxw * 0.000101,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          width: width * 0.39,
          height: height * 0.04,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0071E4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(hxw * 0.000061),
                bottomRight: Radius.circular(hxw * 0.000061),
              )
            ),
            child:  Center(
              child: Text(
                "Datos totales",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hxw * 0.000045,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
