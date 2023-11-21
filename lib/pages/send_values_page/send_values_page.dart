import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stretcherapp/utils/show_snack_bar.dart';
import 'package:stretcherapp/widgets/send_values_page/posicion_actual.dart';
import 'package:stretcherapp/widgets/send_values_page/waiting_connection.dart';

class SendValuesPage extends StatefulWidget {
    const SendValuesPage({super.key, required this.device});
    final BluetoothDevice device;

  @override
  State<SendValuesPage> createState() => _SendValuesPageState();
}

class _SendValuesPageState extends State<SendValuesPage> {

  // ==================== VARIABLES ==================== //
  bool _connected = false;
  bool _firstConnect = true;
  final String SERVICE_UUID          =  "3fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID   =  "beb5486e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_CHARACTERISTIC =  "beb5485e-36e1-4688-b7f5-ea07361b26a8";
  late BluetoothCharacteristic characteristic;
  late BluetoothCharacteristic targetCharacteristic;
  Stream<List<int>>? stream;
  late String received = "";


  // ==================== INIT-STATE ==================== //
  @override
  void initState() {
    super.initState();

    // --------------- LISTENER DE ESTADO DE CONEXION --------------- //
    widget.device.state.listen((state) async{
      if (state == BluetoothDeviceState.connected) { // si dispositivo conectado

        await discoverServices();

        print("CONECTADO");
        setState(() {
          _connected = true;
          _firstConnect = false;
        });
        // Mostrar snackbar
        showSnackBar(context, "¡Conexión establecida!", Colors.green, 2);

      } else if (state == BluetoothDeviceState.disconnected) { // si dispositivo desconectado
        
        print("DESCONECTADO");
        setState(() {
          _connected = false;
        });
        // Mostrar snackbar
        if (!_firstConnect) { // si no es la primera conexión
          showSnackBar(context, "¡Conexión perdida!", Colors.red, 2);
        }
        widget.device.connect();
      }
    });

  }
  // ==================== FIN INIT-STATE ==================== //

  // ========== _buildView PARA GENERAR EL WIDGET DEPENDIENDO DE ESTADO ========== //
  Widget _buildView(bool connected) {
    if (connected) { //si es que el dispositivo esta conectado
      return Center(
        child: PosicionActual(posicion: received));
    } else { // si es que el dispositivo no esta conectado
      return const WaitingConnection(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Posición Camilla"),
        ),
        body: _buildView(_connected) // aqui se aplica el _buildView
      ),
    );
  }

  /* ==================== DISCOVER SERVICES VOID ==================== */
  discoverServices() async {
    // ignore: unnecessary_null_comparison
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(true);
            stream = characteristic.value;
          }
          if (characteristic.uuid.toString() == TARGET_CHARACTERISTIC) {
            targetCharacteristic = characteristic;
          }
        }
      }
    }

    // Recibir y mostrar los datos enviados por el ESP32
    print("stream listen");
    if (_firstConnect) {
      stream?.listen((data) {
        setState(() {
          received = String.fromCharCodes(data);
        });
        print("Posicion actual: $received");
      });
    }
  }
  /* ==================== END DISCOVER SERVICES VOID ==================== */
}