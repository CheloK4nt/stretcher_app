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
import 'package:stretcherapp/widgets/send_values_page/waiting_connection.dart';

class SendValuesPage extends StatefulWidget {
  const SendValuesPage({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<SendValuesPage> createState() => _SendValuesPageState();
}

class _SendValuesPageState extends State<SendValuesPage> {
  final String SERVICE_UUID          =  "3fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID   =  "beb5486e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_CHARACTERISTIC =  "beb5485e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady = false;
  bool tcReady = false;
  String selectedCut = "z";
  late BluetoothCharacteristic targetCharacteristic;
  Stream<List<int>>? stream;
  final dataStreamController = StreamController<String>();
  TextEditingController valueToSendController = TextEditingController();
  String inputValue = '';
  
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
          ?const WaitingConnection()
          :Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                StreamBuilder<List<int>>(
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
            
                    if (snapshot.connectionState == ConnectionState.active) { /* RECEPCION DE DATOS  */
                      var currentValue = _dataParser(snapshot.data!);
                    }
                    return Text("Posicion Actual: ${snapshot.data != null ? _dataParser(snapshot.data!) : null}", style: TextStyle(fontWeight: FontWeight.w400));
                  }
                ),

                Padding(
                  padding: EdgeInsets.all((height * width) * 0.00009),
                  child: Text(
                    "Ingrese valor a enviar",
                    style: TextStyle(
                      fontSize: (height * width) * 0.00008,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
            
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.3),
                  child: TextField(
                    controller: valueToSendController,
                    onChanged: (text) {
                      setState(() {
                        inputValue = text;
                      });
                    },
                  ),
                ),
            
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: ElevatedButton(
                    onPressed: (){
                      writeData(valueToSendController.text);
                    },
                    child: const Text("Enviar"),
                  ),
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

  /* ==================== DATA PARSER ==================== */
  String _dataParser(List<int> dataFromDevice) {
    print(dataFromDevice);
    return utf8.decode(dataFromDevice);
  }
  /* ==================== END DATA PARSER ==================== */

  _Pop() {
    Navigator.of(context).pop(true);
  }
}