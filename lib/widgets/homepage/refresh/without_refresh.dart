import 'package:exhalapp/pages/homepage/screens/find_devices_screen.dart';
import 'package:exhalapp/pages/homepage/screens/options_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class WithoutRefreshHome extends StatefulWidget {
  const WithoutRefreshHome({super.key});

  @override
  State<WithoutRefreshHome> createState() => _WithoutRefreshHomeState();
}

class _WithoutRefreshHomeState extends State<WithoutRefreshHome> {
  @override
  Widget build(BuildContext context) {

    int selectedIndex = 0;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    final screens = [const FindDevicesScreen(), const OptionsScreen()];

    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    return Scaffold(
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
                      print(selectedIndex);
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
                          child: Text(
                            "Detener búsqueda",
                            style: TextStyle(
                              fontSize: hxw * 0.000045,
                              fontWeight: FontWeight.w400,
                            ),
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
                              // locationPermissionDialog();
                            }
                          }
                      );
                    }
                  }
                )
                : null
                /* ==================== END FLOATING ACTION BUTTON ==================== */
              );
  }
}