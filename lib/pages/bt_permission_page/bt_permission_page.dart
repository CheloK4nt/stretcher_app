import 'package:exhalapp/pages/homepage/bt_off_screen.dart';
import 'package:exhalapp/pages/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BTPermissionPage extends StatefulWidget {
  const BTPermissionPage({super.key});
  @override
  State<BTPermissionPage> createState() => _BTPermissionPageState();

}

class _BTPermissionPageState extends State<BTPermissionPage> {

  bool btPermission = false;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    getBtPermission();

    if (btPermission == true) {
      return StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return HomePage();
          } else {
            return BluetoothOffScreen();
          }
          // return BluetoothOffScreen(state: state); /* Si bluetooth está apagado */
        }
      );
    } else {
      return Scaffold(
        body: Center(
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
                    'assets/images/Logo-EXHALAPP_color.png',
                  ),
                ),
              ),
              /* ==================== END EXHALAPP LOGO ==================== */

              /* ==================== PERMISSION TEXT ==================== */
              SizedBox(
                width: width*0.595,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Debe conceder permisos de "Dispositivos cercanos" para poder acceder a las funciones.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF676767),
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
                    padding: EdgeInsets.all(height * 0.018),
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 2,
                      color: Color(0xFF00C0FF)
                    )
                  ),
                  onPressed: () async {
                    await Permission.bluetoothScan.request();
                    if (await Permission.bluetoothScan.isDenied) {
                      openAppSettings();
                    }
                  },
                  child: const Text("Conceder permiso")
                ),
              ),
              /* ==================== END PERMISSION BUTTON ==================== */
            ],
          )
        ),
      );
    }
  }

  void getBtPermission() async {
    if (await Permission.bluetoothScan.isGranted) {
      setState(() {
        btPermission = true;
      });
    } else {
      setState(() {
        btPermission = false;
      });
    }
  }
}