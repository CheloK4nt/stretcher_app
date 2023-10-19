// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../providers/shared_pref.dart';
import '../../widgets/charts_page/waiting_data_cpi.dart';
import '../homepage/homepage.dart';

class SendValuesPage extends StatefulWidget {
  const SendValuesPage({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<SendValuesPage> createState() => _SendValuesPageState();
}

class _SendValuesPageState extends State<SendValuesPage> {
  final String SERVICE_UUID = "3fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5486e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_CHARACTERISTIC = "beb5485e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady = false;
  bool tcReady = false;
  bool verify = true;
  bool normalWidgets = true;
  String isConnected = "desconectado";
  Stream<List<int>>? stream;
  late BluetoothCharacteristic targetCharacteristic;

  @override
  void initState() {   
    super.initState();
    isReady = true; /* false */
    discoverServices();
  }

  @override
  Widget build(BuildContext context) {

    final prefs = UserPrefs();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.device.name),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.1, top: height * 0.01, bottom: height * 0.01),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(hxw * 0.00002),
                  color: (prefs.darkMode)
                    ?const Color(0xFF2b2b47)
                    :const Color(0xFF0050a1)
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(hxw * 0.00002),
                    child: Text(
                      "TEXTO",
                      style: TextStyle(
                        fontSize: hxw * 0.00008,
                        fontWeight: FontWeight.w200
                      ),
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
        body: StreamBuilder<List<int>>(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (verify == true) {
                verifyConnection();
              }

              if (snapshot.connectionState == ConnectionState.active) { /* RECEPCION DE DATOS  */
                var currentValue = _dataParser(snapshot.data!);

                Future.delayed(Duration.zero,(){
                  setState(() {
                    if (currentValue.contains("x")) {
                      currentValue = currentValue.replaceAll(RegExp("[A-Za-z]"), "");
                    } else {
                      //codigo
                    }
                  });
                });
                return (normalWidgets)
                ?Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(currentValue),

                      /* ==================== VALOR ACTUAL ==================== */
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.07,
                        ),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(hxw * 0.00005)
                          ),
                          color: const Color(0xFF0071E4),
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: height * 0.05,
                                left: width * 0.1,
                                right: width * 0.1,
                                bottom: height * 0.03,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Valor Actual:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                                  
                                  Text(currentValue),
                                                  
                                ]
                              ),
                            ),
                          ),
                        ),
                      ),
                      /* ==================== FIN VALOR ACTUAL ==================== */
                    ],
                  )
                )
                :const WaitingDataCPI();
              } else {
                return const WaitingDataCPI();
              }
            },
          ),
        ),
    );
  }

  /* ==================== DISCOVER SERVICES ==================== */
  discoverServices() async {
    isReady = false;
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;
            setState(() {
              isReady = true;
            });
          }
          if (characteristic.uuid.toString() == TARGET_CHARACTERISTIC) {
            targetCharacteristic = characteristic;
          }
        }
      }
    }
    isConnected = "conectado";
    if (!isReady) {
      _Pop();
    }
  }
  /* ==================== END DISCOVER SERVICES ==================== */

  /* ==================== DISCONNECT FROM DEVICE VOID ==================== */
  disconnectFromDevice() {
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }
    widget.device.disconnect();
  }
  /* ==================== END DISCONNECT FROM DEVICE VOID ==================== */

  /* ==================== WRITE DATA VOID ==================== */
  writeData(String data) async {
    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;

    if (data == "0") {
      List<int> bytes = utf8.encode(data);
      await targetCharacteristic.write(bytes);
    } else {
      if (connectedDevices.contains(widget.device)) {
        List<int> bytes = utf8.encode(data);
        await targetCharacteristic.write(bytes);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (Route route) => false);
        const snack = SnackBar(
            backgroundColor: Colors.amber,
            content: Center(
              child: Text(
                'No se pudo establecer conexión...',
                style: TextStyle(color: Colors.white),
              )
            ),
            duration: Duration(seconds: 3),
          );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    }
  }
  /* ==================== END WRITE DATA VOID ==================== */

  /* ==================== DISCONNECT AND GO BACK DIALOG  ==================== */
  Future<bool> _onWillPop() {

    final prefs = UserPrefs();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((height * width) * 0.0001),
          side: BorderSide(
            color: (prefs.darkMode)
              ?const Color(0xFF0071E4)
              :const Color(0xFFD3D3D3)
          )
        ),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: (prefs.darkMode)
          ?const Color(0xFF474864)
          :Colors.white,
        title: Text(
          '¿Estás seguro?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Quieres desconectar el dispositivo y volver atrás?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF0071E4)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((height*width) * 0.00007)
                )
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No')
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 75, 62)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((height*width) * 0.00007)
                )
              ),
            ),
            onPressed: () {
              writeData("0");
              setState(() {
                verify = false;
              });
              disconnectFromDevice();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (Route route) => false);
            },
            child: const Text('Si')
          ),
        ],
      ),
    ).then((value) => false);
  }
  /* ==================== END DISCONNECT AND GO BACK DIALOG  ==================== */

  /* ==================== VERIFY CONNECTION ==================== */
  verifyConnection() async {
    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;
    if (connectedDevices.contains(widget.device)) {
      if (isConnected == "se desconecto") {
        discoverServices();
        writeData("1");

        setState(() {
          normalWidgets = true;
        });
      }
    } else {
      if (isConnected != "se desconecto") {
        
        if (ModalRoute.of(context)?.isCurrent == false) { /* SI HAY UN ALERTDIALOG ACTIVO */
          Navigator.pop(context);
        }

        setState(() {
          normalWidgets = false;
        });
        isConnected = "se desconecto";
        const snack = SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 85, 7),
          content: Center(
            child: Text(
              'Se ha perdido la conexión...',
              style: TextStyle(color: Colors.white),
            )
          ),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);

        const snackReconnect = SnackBar(
          backgroundColor: Colors.amber,
          content: Center(
            child: Text(
              'Intentando reconectar...',
              style: TextStyle(color: Colors.white),
            )
          ),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackReconnect);
      }
    }
  }
  /* ==================== END VERIFY CONNECTION ==================== */

  /* ==================== POP ==================== */
  _Pop() {
    Navigator.of(context).pop(true);
  }
  /* ==================== END POP ==================== */

  /* ==================== DATA PARSER ==================== */
  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }
  /* ==================== END DATA PARSER ==================== */
}