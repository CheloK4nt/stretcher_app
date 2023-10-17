import 'package:stretcherapp/pages/charts_page/start_exam_page.dart';
import 'package:stretcherapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {

    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de dispositivos"),
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.instance.scanResults,
            initialData: const [],
            builder: (c, snapshot) => Column(
              children: snapshot.data!.map(
                (r) => ScanResultTile(
                  result: r,
                  onTap: () async {
                    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;
                    if (!connectedDevices.contains(r.device)) {
                      r.device.connect();
                    }
                    if (context.mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StartExamPage(device: r.device)));
                    }
                  }
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}