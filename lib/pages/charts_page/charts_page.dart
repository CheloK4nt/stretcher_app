// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unused_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:exhalapp/main.dart';
import 'package:exhalapp/pages/homepage/homepage.dart';
import 'package:exhalapp/providers/shared_pref.dart';
import 'package:exhalapp/providers/ui_provider.dart';
import 'package:exhalapp/widgets/charts_page/add_note_button.dart';
import 'package:exhalapp/widgets/charts_page/chart_selector.dart';
import 'package:exhalapp/widgets/charts_page/waiting_data_cpi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'dart:developer' as logdev;

import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

/* MY DATA TO LINE CHART */
class MyData {
  final num xValue;
  final num? yValue;
  MyData(this.xValue, this.yValue);
}
/* END MY DATA DECLARATION */

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key, required this.device, required this.cut_method});
  final BluetoothDevice device;
  final String cut_method;

  @override
  // ignore: library_private_types_in_public_api
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {

  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b"; /* uuid de servicio */
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"; /* caracteristica que hay que recibir */
  final String TARGET_CHARACTERISTIC = "beb5482e-36e1-4688-b7f5-ea07361b26a8"; /* caracteristica a la que se envian datos */
  bool isReady = false;
  bool fillList = true;
  bool isCutPoint = false;
  Stream<List<int>>? stream;
  late BluetoothCharacteristic targetCharacteristic;

/* Normal line chart */
  List<MyData> _dataList = List.empty(growable: true); /* Lista para grafico mmhg */
  List<MyData> _dataList2 = List.empty(growable: true); /* Lista 2 grafico mmhg */
  List<MyData> _dataListX = List.empty(growable: true); /* Lista para grafico kpa */
  List<MyData> _dataListX2 = List.empty(growable: true); /* Lista 2 para grafico kpa */
  List<MyData> _dataListY = List.empty(growable: true); /* Lista para grafico % */
  List<MyData> _dataListY2 = List.empty(growable: true); /* Lista 2 para grafico % */

/* Cut points chart */
  List<MyData> _dataPointList = List.empty(growable: true); /* Lista para grafico mmhg */
  List<MyData> _dataPointList2 = List.empty(growable: true); /* Lista 2 grafico mmhg */
  List<MyData> _dataPointListX = List.empty(growable: true); /* Lista para grafico kpa */
  List<MyData> _dataPointListX2 = List.empty(growable: true); /* Lista 2 para grafico kpa */
  List<MyData> _dataPointListY = List.empty(growable: true); /* Lista para grafico % */
  List<MyData> _dataPointListY2 = List.empty(growable: true); /* Lista 2 para grafico % */

  List _fullDataList = List.empty(growable: true); /* Lista historica de datos */
  String _fullDataString = "";

  int _miliSegundosTranscurridos = 0; /* milisegundos transcurridos desde que empieza el examen */
  int _segundosTranscurridos = 0; /* segundos transcurridos desde que empieza el examen */
  int _minutosTranscurridos = 0; /* minutos transcurridos desde que empieza el examen */

  late Timer _timerMiliSeg;
  late Timer _timerSeg;
  late Timer _timerMin;
  String min="00", seg ="00", mili = "0000";

  String tiempo = "";
  String totales = "";
  String maximoStr = "";
  String corte = "";
  double maximo = 0;

  List notas = List.empty(growable: true);

  @override
  void initState() {   
    super.initState();
    initTimers();
    isReady = true; /* false */
    discoverServices();
  }

  /* TIMER DISPOSE */
  @override
  void dispose() {
    _timerMiliSeg.cancel();
    _timerSeg.cancel();
    _timerMin.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final prefs = UserPrefs();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    final uiProvider = context.watch<UIProvider>().selectedUnity;

    var seriesList = [
      charts.Series<MyData, num>(
        id: 'mySeries',
        domainFn: (MyData data, _) => data.xValue,
        measureFn: (MyData data, _) => data.yValue,
        data: (uiProvider == "Grafico mmHg")?_dataList :_dataListX,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      charts.Series<MyData, num>(
        id: 'mySeries2',
        domainFn: (MyData data, _) => data.xValue,
        measureFn: (MyData data, _) => data.yValue,
        data: (uiProvider == "Grafico mmHg")?_dataPointList :_dataPointListX,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.transparent,
        strokeWidthPxFn: (_, __) => 3,
      ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.device.name),
        ),
        body: StreamBuilder<List<int>>(
            stream: stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.active) {
                /* RECEPCION DE DATOS  */
                var currentValue = _dataParser(snapshot.data!);
                print(currentValue);

                if (_dataList.isEmpty){
                  _addData(0, fillList);
                }
                Future.delayed(Duration.zero,(){
                  setState(() {
                    if (currentValue.contains("x")) {
                      isCutPoint = true;
                      currentValue = currentValue.replaceAll(RegExp("[A-Za-z]"), "");
                    } else {
                      isCutPoint = false;
                    }
                    _addData(double.tryParse(currentValue) ?? 0, fillList);
                  });
                });
                
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Unidades de medida:",
                            style: TextStyle(
                              fontSize: hxw * 0.00007,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ),

                      const ChartSelector(),

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
                                                  
                                  /* ========== CONDICIONAL TIPO DE UNIDAD A MOSTRAR ========== */
                                  (uiProvider == "Grafico mmHg")
                                  ?Text('${currentValue.replaceAll(RegExp("[A-Za-z]"), "")} mmHg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white))
                                  : (uiProvider == "Grafico kpa")
                                    ?Text('${((double.tryParse(currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) * 0.133322).toStringAsFixed(2)} kpa', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white))
                                    :Text('${((double.tryParse(currentValue.replaceAll(RegExp("[A-Za-z]"), "")) ?? 0) / 7.6).toStringAsFixed(2)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
                                  /* ========== FIN CONDICIONAL ========== */
                                                  
                                  /* ========== TERMINAR EXAMEN ========== */
                                  Padding(
                                    padding: EdgeInsets.only(top: height * 0.012),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(
                                          side: BorderSide(
                                            color: Color(0xFF00C0FF),
                                          )
                                        ),
                                        backgroundColor: const Color(0xFFBDEFFF),
                                        foregroundColor: const Color(0xFF00C0FF),
                                      ),
                                      onPressed: () => _stopExamModal(corte),
                                      child: const Text("Terminar exámen"),
                                    ),
                                  ),
                                  /* ========== FIN TERMINAR EXAMEN ========== */
                                ]
                              ),
                            ),
                          ),
                        ),
                      ),
                      /* ==================== FIN VALOR ACTUAL ==================== */

                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.015,
                        ),
                        child: AddNoteBTN(notas: notas, tiempo: "$min:$seg",),
                      ),

                      /* ==================== GRAFICO ==================== */
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(hxw * 0.00003),
                          child: charts.LineChart(
                            seriesList,
                            animate: false,
                            defaultRenderer: charts.LineRendererConfig(
                              includePoints: false,
                              includeArea: true,
                              areaOpacity: 0.35
                            ),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              renderSpec: charts.GridlineRendererSpec(
                                labelStyle: charts.TextStyleSpec(
                                  color: (prefs.darkMode)
                                    ?charts.MaterialPalette.white
                                    :charts.MaterialPalette.black,
                                )
                              ),
                              tickProviderSpec: (uiProvider == "Grafico mmHg") 
                              ?const charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(0, label: "0"),
                                  charts.TickSpec(5, label: "5"),
                                  charts.TickSpec(10, label: "10"),
                                  charts.TickSpec(15, label: "15"),
                                  charts.TickSpec(20, label: "20"),
                                  charts.TickSpec(25, label: "25"),
                                  charts.TickSpec(30, label: "30"),
                                  charts.TickSpec(35, label: "35"),
                                  charts.TickSpec(40, label: "40"),
                                  charts.TickSpec(45, label: "45"),
                                  charts.TickSpec(50, label: "50"),
                                ]
                              )
                              :const charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(0, label: "0"),
                                  charts.TickSpec(2, label: "2"),
                                  charts.TickSpec(4, label: "4"),
                                  charts.TickSpec(6, label: "6"),
                                  charts.TickSpec(8, label: "8"),
                                  charts.TickSpec(10, label: "10"),
                                ]
                              )
                            ),
                            domainAxis: charts.NumericAxisSpec(
                              /* ========== MENOS DE 1 MINUTO ========== */
                              renderSpec: charts.GridlineRendererSpec(
                                labelStyle: charts.TextStyleSpec(
                                  color: (prefs.darkMode)
                                    ?charts.MaterialPalette.white
                                    :charts.MaterialPalette.black,
                                )
                              ),
                              tickProviderSpec: (_minutosTranscurridos < 1)    
                              ? charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(_dataList.last.xValue, label: (_segundosTranscurridos < 10)
                                    ? "⏱ 00:0$_segundosTranscurridos"
                                    : "⏱ 00:$_segundosTranscurridos"
                                  ),
                                ]
                              )
                              /* ================================================== */
                              /* ========== MAS o IGUAL a 1 MINUTO ========== */
                              : charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(_dataList.last.xValue, label: (_minutosTranscurridos < 10)
                                  ?(_segundosTranscurridos < 10)
                                    ? "⏱ 0$_minutosTranscurridos:0$_segundosTranscurridos"
                                    : "⏱ 0$_minutosTranscurridos:$_segundosTranscurridos"
                                  :(_segundosTranscurridos < 10)
                                    ? "⏱ $_minutosTranscurridos:0$_segundosTranscurridos"
                                    : "⏱ $_minutosTranscurridos:$_segundosTranscurridos"
                                  ),
                                ]
                              )
                              /* ================================================== */
                            ),
                          ),
                        ),
                      )
                      /* ==================== FIN GRAFICO ==================== */
                    ],
                  )
                );
              } else {
                return const WaitingDataCPI();
              }
            },
          ),
        )
      );
  }



/* ------------------------------------------------------------------------------------------------------------------------------------------ */

  /* ==================== AGREGAR DATOS A LINE CHART ==================== */
  void _addData(valor, fillList) {

    if (valor > maximo) { /* aqui se declara el valor maximo */
      maximo = valor;
    }

    if (_dataList.length < 300) { /* si la catidad de datos es menor a 300, agrega los datos a las listas */
      _dataList.add(MyData(_dataList.length, valor)); /* lista mmhg */
      _dataListX.add(MyData(_dataListX.length, (valor * 0.133322))); /* lista kpa */
      _dataListY.add(MyData(_dataListY.length, (valor / 7.6))); /* lista % */

      if (isCutPoint == false) { /* si el dato no es punto de corte, se rellena la lista con null */
        _dataPointList.add(MyData(_dataPointList.length, null));
        _dataPointListX.add(MyData(_dataPointListX.length, null));
        _dataPointListY.add(MyData(_dataPointListY.length, null));
      } else { /* en cambio, si es punto de corte, se agrega el dato a la lista respectiva */
        _dataPointList.add(MyData(_dataPointList.length, valor));
        _dataPointListX.add(MyData(_dataPointListX.length, (valor * 0.133322)));
        _dataPointListY.add(MyData(_dataPointListY.length, (valor / 7.6)));
      }

    } else { /* en cambio, si la cantidad de datos es maor a 300, elimina el primer dato en la lista y agrega al final el nuevo dato para simular la animacion */
      for (var element in _dataList.getRange(_dataList.length - 299, _dataList.length)) {
        _dataList2.add(MyData(_dataList2.length, element.yValue));
        _dataListX2.add(MyData(_dataListX2.length, (element.yValue! * 0.133322)));
        _dataListY2.add(MyData(_dataListY2.length, (element.yValue! / 7.6)));
      }

      for (var element in _dataPointList.getRange(_dataPointList.length - 299, _dataList.length)) {
        _dataPointList2.add(MyData(_dataPointList2.length, element.yValue));
        if (element.yValue == null) {
          _dataPointListX2.add(MyData(_dataPointListX2.length, (null)));
          _dataPointListY2.add(MyData(_dataPointListY2.length, (null)));
        } else {
          _dataPointListX2.add(MyData(_dataPointListX2.length, (element.yValue! * 0.133322)));
          _dataPointListY2.add(MyData(_dataPointListY2.length, (element.yValue! / 7.6)));
        }
      }

      /* se reemplazan las listas para simular el movimiento */
      _dataList = _dataList2;
      _dataPointList = _dataPointList2;
      _dataListX = _dataListX2;
      _dataPointListX = _dataPointListX2;
      _dataListY = _dataListY2;
      _dataPointListY = _dataPointListY2;

      _dataList.add(MyData(_dataList.length, valor));
      _dataListX.add(MyData(_dataListX.length, (valor * 0.133322)));
      _dataListY.add(MyData(_dataListY.length, (valor / 7.6)));

      if (isCutPoint == false) {
        _dataPointList.add(MyData(_dataPointList.length, null));
        _dataPointListX.add(MyData(_dataPointListX.length, null));
        _dataPointListY.add(MyData(_dataPointListY.length, null));
      } else {
        _dataPointList.add(MyData(_dataPointList.length, valor));
        _dataPointListX.add(MyData(_dataPointListX.length, (valor * 0.133322)));
        _dataPointListY.add(MyData(_dataPointListY.length, (valor / 7.6)));
      }

      _dataList2 = [];
      _dataPointList2 = [];
      _dataListX2 = [];
      _dataPointListX2 = [];
      _dataListY2 = [];  
      _dataPointListY2 = [];  
    }
    if (fillList == true) {
      _fullDataList.add("$min$seg$mili-$valor");
      _fullDataString = "$_fullDataString$min$seg$mili-$valor;\n";
    }
  }
  /* ==================== FIN AGREGAR DATOS A LINE CHART ==================== */

  /* ==================== WRITE DATA ==================== */
  void writeData(String data) async {
    // ignore: unnecessary_null_comparison
    if(targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
  }
  /* ==================== END WRITE DATA ==================== */

  /* ==================== DISCOVER SERVICES ==================== */
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
          }
        }
      }
    }

    if (!isReady) {
      _Pop();
    }
  }
  /* ==================== END DISCOVER SERVICES ==================== */

  /* ==================== DISCONNECT FROM DEVICE ==================== */
  disconnectFromDevice() {
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }
    widget.device.disconnect();
  }
  /* ==================== END DISCONNECT FROM DEVICE ==================== */

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

  /* ==================== MODAL TERMINAR EXAMEN ==================== */
  _stopExamModal(corte) {

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
          'Finalizar exámen',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Desea finalizar el exámen?',
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

              corte = getCutString();
              tiempo = _getTiempoTotal(_minutosTranscurridos, _segundosTranscurridos);
              totales = _fullDataList.length.toString();
              maximoStr = maximo.toStringAsFixed(2);
              disconnectFromDevice();

              fillList = false;
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              //   builder: (context) => ExportPage(fullDataString: _fullDataString, fullDataList: _fullDataList, corte: corte, tiempo: tiempo, totales: totales, maximo: maximoStr, notas: notas,)
              // ), (Route route) => false);
            },
            child: const Text('Terminar')
          ),
        ],
      ),
    ).then((value) => false);
  }
  /* ==================== FIN MODAL TERMINAR EXAMEN ==================== */

/* ==================== OBTENER STRING TIEMPO TOTAL ==================== */
  _getTiempoTotal(_minutosTranscurridos, _segundosTranscurridos){
    if (_minutosTranscurridos < 10) {
      tiempo = "0$_minutosTranscurridos";
      if (_segundosTranscurridos < 10){
        tiempo = "$tiempo:0$_segundosTranscurridos";
      } else {
        tiempo = "$tiempo:$_segundosTranscurridos";
      }
    } else {
      tiempo = "$_minutosTranscurridos";
      if (_segundosTranscurridos < 10){
        tiempo = "$tiempo:0$_segundosTranscurridos";
      } else {
        tiempo = "$tiempo:$_segundosTranscurridos";
      }
    }
    return tiempo;
  }
/* ==================== FIN OBTENER STRING TIEMPO TOTAL ==================== */

/* ==================== GET CUT STRING ==================== */
  getCutString (){
    if (widget.cut_method == "1") {
      corte = "MAX.";
    } else {
      corte = "C50";
    }
    return corte;
  }
  /* ==================== END GET CUT STRING ==================== */

  /* ==================== INIT TIMERS ==================== */
  void initTimers (){
    _timerMiliSeg = Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      setState(() {
        _miliSegundosTranscurridos++;
        if (_miliSegundosTranscurridos == 1000) {
          _miliSegundosTranscurridos = 0;
        }

        if (_miliSegundosTranscurridos < 10){
          mili = "000$_miliSegundosTranscurridos";
        } else if (_miliSegundosTranscurridos < 100){
          mili = "00$_miliSegundosTranscurridos";
        } else if (_miliSegundosTranscurridos < 1000){
          mili = "0$_miliSegundosTranscurridos";
        } else {
          mili = "$_miliSegundosTranscurridos";
        }
      });
    });

    _timerSeg = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _segundosTranscurridos++;
        if (_segundosTranscurridos == 60) {
          _segundosTranscurridos = 0;
        }

        if (_segundosTranscurridos < 10){
          seg = "0$_segundosTranscurridos";
        } else if (_segundosTranscurridos < 60){
          seg = "$_segundosTranscurridos";
        }
      });
    });

    _timerMin = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      setState(() {
        _minutosTranscurridos++;

        if (_minutosTranscurridos < 10){
          min = "0$_minutosTranscurridos";
        } else if (_minutosTranscurridos < 60){
          min = "$_minutosTranscurridos";
        }
      });
    });
  }
  /* ==================== END INIT TIMERS ==================== */

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }
}