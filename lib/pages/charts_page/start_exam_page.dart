// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:stretcherapp/pages/charts_page/charts_page.dart';
import 'package:stretcherapp/pages/charts_page/hidden_charts_page.dart';
import 'package:stretcherapp/pages/homepage/homepage.dart';
import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  final String SERVICE_UUID =           "3fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID =    "beb5486e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_CHARACTERISTIC =  "beb5485e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady = false;
  bool tcReady = false;
  String selectedCut = "x";
  late BluetoothCharacteristic targetCharacteristic;
  Stream<List<int>>? stream;
  final dataStreamController = StreamController<String>();
  
  @override
  void initState() {   
    super.initState();
    isReady = false;
    tryConnect();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.name),
        ),
        body: Container(
          child: !isReady
          ?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Estableciendo conexión...",
                  style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: EdgeInsets.all((height * width) * 0.0001),
                  child: const CircularProgressIndicator(
                    color: Color(0xFF0071E4),
                  ),
                ),
              ],
            ),
          )
          :Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all((height * width) * 0.00009),
                  child: Text(
                    "Seleccione valor a enviar",
                    style: TextStyle(
                      fontSize: (height * width) * 0.00008,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),

            /* ========== SELECTOR MODO DE CORTE ========== */
                Wrap(
                  spacing: 5,
                  children: [
                /* ========== BOTON CORTE MAX ========== */
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: (){
                        setState(() {
                        selectedCut = "1";
                        });
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: (selectedCut == "1")?Colors.blue :const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        child: Text(
                          "1",
                          style: TextStyle(color: (selectedCut == "1")?Colors.white :const Color(0xFF7A7A7A)),
                        ),
                      ),
                    ),
                /* ========== FIN BOTON CORTE MAX ========== */
          
                /* ========== BOTON CORTE C50 ========== */
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: (){
                        setState(() {
                          selectedCut = "0";
                        });
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: (selectedCut == "0")?Colors.blue :const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        child: Text(
                          "0",
                          style: TextStyle(color: (selectedCut == "0")?Colors.white :const Color(0xFF7A7A7A)),
                        ),
                      ),
                    ),
                /* ========== FIN BOTON CORTE C50 ========== */
                  ],
                ),
            /* ========== FIN SELECTOR MODO DE CORTE ========== */
                StreamBuilder<String>(
                  stream: dataStreamController.stream,
                  initialData: "",
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(top: height * 0.04),
                      child: (tcReady == true)
                      ?ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular((height * width) * 0.00006),
                          ),
                          backgroundColor: const Color(0xFFBDEFFF),
                          foregroundColor: const Color(0xFF009ACC),
                          // disabledBackgroundColor: const Color.fromARGB(255, 183, 183, 183),
                          // disabledForegroundColor: const Color.fromARGB(255, 84, 84, 84),
                          disabledForegroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          side: BorderSide(
                            color: (selectedCut != "x")?Colors.blue :Colors.transparent,
                          ),
                          elevation: (selectedCut != "x")?5 :0,
                        ),
                        onPressed: (selectedCut != "x")
                        ?(){
                          writeData(selectedCut);
                        }
                        :null,
                        child: Text("Iniciar examen\nData recibida: ${snapshot.data}", style: TextStyle(fontWeight: FontWeight.w400),),
                      )
                      :const LinearProgressIndicator(
                        color: Color(0xFF0071E4),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/* ----------------------------------------------------------------------------------------------------- */

  /* ==================== tryCONNECT TO DEVICE VOID ==================== */
  void tryConnect() async{
    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;

    if (connectedDevices.contains(widget.device)) {
      discoverServices();
    } else {
      await connectToDevice();
    }
  }
  /* ==================== END tryCONNECT TO DEVICE VOID ==================== */

  /* ==================== CONNECT TO DEVICE VOID ==================== */
  connectToDevice() async {
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }

    Timer(const Duration(seconds: 8), () {
      if (mounted && !isReady) {
        writeData('0');
        disconnectFromDevice();
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
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    });

    await widget.device.connect();
    discoverServices();
  }
  /* ==================== END CONNECT TO DEVICE VOID ==================== */

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

  /* ==================== DISCOVER SERVICES VOID ==================== */
  discoverServices() async {
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
            setState(() {
              tcReady = true;
              isReady = true;
            });
          }
        }
      }
    }

    if (!isReady) {
      _Pop();
    }
  }
  /* ==================== END DISCOVER SERVICES VOID ==================== */

  /* ==================== WRITE DATA VOID ==================== */
  writeData(String data) async {
    print("ENVIAR DATO: $data");
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

    // Recibir y mostrar los datos enviados por el ESP32
    stream?.listen((data) {
      String received = String.fromCharCodes(data);
      dataStreamController.add(received);
    });

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

  _Pop() {
    Navigator.of(context).pop(true);
  }
}