import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtLoadingWidgets extends StatefulWidget {
  const BtLoadingWidgets({super.key, required this.state});
  final BluetoothState? state;

  @override
  State<BtLoadingWidgets> createState() => _BtLoadingWidgetsState();
}

class _BtLoadingWidgetsState extends State<BtLoadingWidgets> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
      
              /* ==================== EXHALAPP LOGO ==================== */
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.3,
                  bottom: height * 0.04,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Image.asset(
                    'assets/images/Logo-EXHALAPP_color.png',
                  ),
                ),
              ),
            /* ==================== END EXHALAPP LOGO ==================== */
            
            /* ==================== BLUETOOTH LOADING ICON ==================== */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Icon(
                      Icons.bluetooth_disabled_outlined,
                      size: height * 0.2,
                      color: Color(0xFFA8A9A9),
                    ),
                    Positioned(
                      left: width * 0.28,
                      bottom: height * 0.073,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF0071E4),
                      ),
                    ),
                  ],
                ),
              ),
            /* ==================== END BLUETOOTH LOADING ICON ==================== */
            
            /* ==================== STATUS TEXT ==================== */
              (widget.state.toString().substring(15) == "turningOn")?
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Adaptador bluetooth se está\n',
                  style: TextStyle(color: Color(0xFF676767,), fontWeight: FontWeight.w300),
                  children: <TextSpan>[
                    TextSpan(text: "encendiendo...", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF676767)))
                  ]
                )
              )
              :
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Adaptador bluetooth se está\n',
                  style: TextStyle(color: Color(0xFF676767), fontWeight: FontWeight.w300),
                  children: <TextSpan>[
                    TextSpan(text: "apagando...", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF676767)))
                  ]
                )
              ),
            /* ==================== END STATUS TEXT ==================== */
            ],
          )
        ),
      ),
    );
  }
}