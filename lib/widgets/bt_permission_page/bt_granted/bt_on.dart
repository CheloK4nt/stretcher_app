import 'package:exhalapp/pages/homepage/homepage.dart';
import 'package:exhalapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtOnWidgets extends StatefulWidget {
  const BtOnWidgets({super.key, required this.state});
  final BluetoothState? state;

  @override
  State<BtOnWidgets> createState() => _BtOnWidgetsState();
}

class _BtOnWidgetsState extends State<BtOnWidgets> {
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
            
            /* ==================== BLUETOOTH ON ICON ==================== */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.bluetooth,
                  size: height * 0.2,
                  color: const Color(0xFF0071E4),
                ),
              ),
            /* ==================== END BLUETOOTH ON ICON ==================== */
            
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
                  ]
                )
              )
              :
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Bluetooth',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " encendido.",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.tertiary,
                      )
                    )
                  ]
                )
              ),
            /* ==================== END STATUS TEXT ==================== */
      
            /* ==================== FIND DEVICES BUTTON ==================== */
              Padding(
                padding: EdgeInsets.only(top: height * 0.08, bottom: height * 0.02),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C0FF),
                    shape: const CircleBorder()
                  ),
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage())),
                  child: Padding(
                    padding: EdgeInsets.all(height * width) * 0.000026,
                    child: Icon(
                      Icons.search,
                      size: (width * height) * 0.00015,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            /* ==================== END FIND DEVICES BUTTON ==================== */

            /* ==================== TEXT FIND DEVICES BUTTON ==================== */
              Text(
                "Buscar dispositivos disponibles",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: (height * width) * 0.00004,
                  fontWeight: FontWeight.w300,
                ),
              ),
            /* ==================== END TEXT FIND DEVICES BUTTON ==================== */
            ],
          )
        ),
      ),
    );
  }
}