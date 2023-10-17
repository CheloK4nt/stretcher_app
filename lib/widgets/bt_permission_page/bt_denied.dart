import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BTDeniedScaffold extends StatefulWidget {
  const BTDeniedScaffold({super.key});

  @override
  State<BTDeniedScaffold> createState() => _BTDeniedScaffoldState();
}

class _BTDeniedScaffoldState extends State<BTDeniedScaffold> {

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
                    bottom: height * 0.17,
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
        
              /* ==================== PERMISSION TEXT ==================== */
                SizedBox(
                  width: width * 0.595,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Debe conceder permisos de "Dispositivos cercanos" para poder acceder a las funciones.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: (height * width) * 0.000045,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              /* ==================== END PERMISSION TEXT ==================== */
        
              /* ==================== PERMISSION BUTTON ==================== */
                Padding(
                  padding: EdgeInsets.only(top: height * 0.022),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0071E4),
                      padding: EdgeInsets.all(height * 0.018),
                      shape: const StadiumBorder(),
                      side: const BorderSide(width: 2, color: Color(0xFF00C0FF))),
                    onPressed: () async {
                      await Permission.bluetoothScan.request();
                      if (await Permission.bluetoothScan.isDenied) {
                        openAppSettings();
                      }
                    },
                  child: const Text("Conceder permiso", style: TextStyle(color: Colors.white),)),
                ),
              /* ==================== END PERMISSION BUTTON ==================== */
              ],
            )
          ),
        ),
      );
  }
}