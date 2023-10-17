import 'package:stretcherapp/pages/homepage/homepage.dart';
import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

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
                  onPressed: () async {
                    if (await Permission.location.isGranted) {
                      Location location = Location();
                      bool isOn = await location.serviceEnabled(); 
                      if (!isOn) { //if defvice is off
                        bool isturnedon = await location.requestService();
                        if (isturnedon) {
                          /* print("GPS device is turned ON"); */
                        }else{
                          /* print("GPS Device is still OFF"); */
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
                      }
                    } else {
                      locationPermissionDialog();
                    }
                  },
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

/* ==================== LOCATION PERMISSION DIALOG ==================== */
  Future<bool> locationPermissionDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        icon: const Icon(Icons.location_on_outlined),
        title: const Text('Ubicación'),
        content: const Text(
          'Primero debe conceder permiso de ubicación(precisa) en su dispositivo para encontrar dispositivos cercanos.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFBDEFFF)),
              overlayColor: MaterialStateProperty.all(const Color.fromARGB(255, 113, 170, 187)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFF0071E4))
                ),
              ),
            ),
            onPressed: () async {
              await Permission.location.request();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(false);
              if (await Permission.location.isDenied) {
                openAppSettings();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Conceder Permiso",
                style: TextStyle(
                  color: Color(0xFF2F2F2F),
                ),
              ),
            )
          ),
        ],
      ),
    ).then((value) => false);
  }
/* ==================== END LOCATION PERMISSION DIALOG ==================== */
}