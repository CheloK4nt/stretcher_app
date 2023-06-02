import 'package:exhalapp/pages/homepage/screens/find_devices_screen.dart';
import 'package:exhalapp/pages/homepage/screens/options_screen.dart';
import 'package:exhalapp/widgets/bt_permission_page/bt_granted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  // ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now().subtract(const Duration(days: 1));

  @override
  Widget build(BuildContext context){

    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    final screens = [const FindDevicesScreen(), const OptionsScreen()];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    return WillPopScope(

      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if(cantExit){
          const snack = SnackBar(content: Center(child: Text('Presiona "atrás" otra vez para salir.')),duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        }else{
          return true;
        }
      },
      child: StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.off) {
            return const BTGrantedScaffold();
          } else {
            return (selectedIndex == 0)
/* ======================================= WITH REFRESH INDICATOR ======================================= */
            ?
            RefreshIndicator(
              backgroundColor: const Color(0xFFBDEFFF),
              color: const Color(0xFF0071E4),
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              edgeOffset: height * 0.11,
              displacement: height * 0.1,
              key: refreshIndicatorKey,
              onRefresh: () => FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4)),
              child: Scaffold(
                body: IndexedStack(
                  index: selectedIndex,
                  children: screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Theme.of(context).primaryColorLight,
                  type: BottomNavigationBarType.shifting,
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  items: [
            
                    /* -------------------- DEVICES BOTTOM NAVIGATION BAR ITEM -------------------- */
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all((height * width) * 0.000026),
                        child: Icon(
                          Icons.settings_bluetooth_outlined,
                          size: (height * width) * 0.00008,
                        ),
                      ),
                      activeIcon: Icon(
                        Icons.bluetooth_searching,
                        size: (height * width) * 0.0001,
                      ),
                      label: "Dispositivos",
                      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor
                    ),
                    /* -------------------- END DEVICES BOTTOM NAVIGATION BAR ITEM -------------------- */
            
                    /* -------------------- OPTIONS BOTTOM NAVIGATION BAR ITEM -------------------- */
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all((height * width) * 0.000026),
                        child: Icon(
                          Icons.settings_outlined,
                          size: (height * width) * 0.00008,
                        ),
                      ),
                      activeIcon: Icon(
                        Icons.settings,
                        size: (height * width) * 0.0001,
                      ),
                      label: "Opciones",
                      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor
                    ),
                    /* -------------------- END OPTIONS BOTTOM NAVIGATION BAR ITEM -------------------- */
                  ]
                ),
            
                /* ==================== FLOATING ACTION BUTTON ==================== */
                floatingActionButton: (selectedIndex == 0)
                ? StreamBuilder<bool>(
                  stream: FlutterBluePlus.instance.isScanning,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (snapshot.data!) {
                      return SizedBox(
                        height: height * 0.05,
                        width:  width * 0.5,
                        child: FloatingActionButton(
                          shape: const StadiumBorder(
                            side: BorderSide(
                              color: Color(0xFF00C0FF)
                            )
                          ),
                          isExtended: true,
                          onPressed: () {
                            FlutterBluePlus.instance.stopScan();
                          },
                          backgroundColor: const Color(0xFFBDEFFF),
                          foregroundColor: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Detener búsqueda",
                                style: TextStyle(
                                  fontSize: hxw * 0.000045,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width:  width * 0.4,
                                child: const LinearProgressIndicator(
                                  backgroundColor: Colors.white,
                                  minHeight: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return FloatingActionButton( /* VER LOCALIZACION DEL FAB */
                        backgroundColor: const Color(0xFF00C0FF),
                          child: const Icon(Icons.search, color: Colors.white,),
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
                                refreshIndicatorKey.currentState?.show();
                              }
                            } else {
                              locationPermissionDialog();
                            }
                          }
                      );
                    }
                  }
                )
                : null
                /* ==================== END FLOATING ACTION BUTTON ==================== */
              ),
            )
/* ======================================= END WITH REFRESH INDICATOR ======================================= */

/* ======================================= WITHOUT REFRESH INDICATOR ======================================= */
            :Scaffold(
                body: IndexedStack(
                  index: selectedIndex,
                  children: screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Theme.of(context).primaryColorLight,
                  type: BottomNavigationBarType.shifting,
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  items: [
            
                    /* -------------------- DEVICES BOTTOM NAVIGATION BAR ITEM -------------------- */
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all((height * width) * 0.000026),
                        child: Icon(
                          Icons.settings_bluetooth_outlined,
                          size: (height * width) * 0.00008,
                        ),
                      ),
                      activeIcon: Icon(
                        Icons.bluetooth_searching,
                        size: (height * width) * 0.0001,
                      ),
                      label: "Dispositivos",
                      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor
                    ),
                    /* -------------------- END DEVICES BOTTOM NAVIGATION BAR ITEM -------------------- */
            
                    /* -------------------- OPTIONS BOTTOM NAVIGATION BAR ITEM -------------------- */
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.all((height * width) * 0.000026),
                        child: Icon(
                          Icons.settings_outlined,
                          size: (height * width) * 0.00008,
                        ),
                      ),
                      activeIcon: Icon(
                        Icons.settings,
                        size: (height * width) * 0.0001,
                      ),
                      label: "Opciones",
                      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor
                    ),
                    /* -------------------- END OPTIONS BOTTOM NAVIGATION BAR ITEM -------------------- */
                  ]
                ),
              );
/* ======================================= END WITHOUT REFRESH INDICATOR ======================================= */
          }
        }
      )
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
          'Debe conceder permiso de ubicación(precisa) en su dispositivo para encontrar dispositivos cercanos.',
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
  