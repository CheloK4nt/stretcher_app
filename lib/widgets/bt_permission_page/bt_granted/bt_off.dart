import 'dart:io';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:exhalapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtOffWidgets extends StatefulWidget {
  const BtOffWidgets({super.key, required this.state});
  final BluetoothState? state;

  @override
  State<BtOffWidgets> createState() => _BtOffWidgetsState();
}

class _BtOffWidgetsState extends State<BtOffWidgets> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final prefs = UserPrefs();

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
                    (prefs.darkMode)
                      ?'assets/images/Logo-EXHALAPP_blanco.png'
                      :'assets/images/Logo-EXHALAPP_color.png'
                  ),
                ),
              ),
            /* ==================== END EXHALAPP LOGO ==================== */
            
            /* ==================== BLUETOOTH OFF ICON ==================== */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Icon(
                      Icons.bluetooth_disabled_outlined,
                      size: height * 0.2,
                      color: const Color(0xFFA8A9A9),
                    ),
                    Positioned(
                      left: width * 0.28,
                      bottom: height * 0.073,
                      child: 
                      Icon(
                        Icons.highlight_off,
                        size: height * 0.05,
                        color: const Color(0xFF7A7A7A),
                      ),
                    )
                  ],
                ),
              ),
            /* ==================== END BLUETOOTH OFF ICON ==================== */
            
            /* ==================== STATUS TEXT ==================== */
              (widget.state.toString().substring(15) == "turningOn")?
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Adaptador bluetooth se está\n',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w300,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "encendiendo...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              )
              :
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Debe encender el adaptador\n',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w300
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Bluetooth.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            /* ==================== END STATUS TEXT ==================== */
      
            /* ==================== BLUETOOTH ON BUTTON ==================== */
              Padding(
                padding: EdgeInsets.all(height * 0.02),
                child: SizedBox(
                  width: width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0071E4),
                      padding: EdgeInsets.all(height * 0.018),
                      shape: const StadiumBorder(),
                      side: const BorderSide(width: 2, color: Color(0xFF00C0FF))),
                    onPressed: Platform.isAndroid
                      ? () async {
                        BluetoothEnable.enableBluetooth;
                      }
                      : null,
                    child: const Text(
                      "Encender BT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            /* ==================== END BLUETOOTH ON BUTTON ==================== */
            ],
          )
        ),
      ),
    );
  }
}