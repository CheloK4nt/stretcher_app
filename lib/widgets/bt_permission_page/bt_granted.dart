import 'dart:ffi';

import 'package:exhalapp/widgets/bt_permission_page/bt_granted/bt_loading.dart';
import 'package:exhalapp/widgets/bt_permission_page/bt_granted/bt_off.dart';
import 'package:exhalapp/widgets/bt_permission_page/bt_granted/bt_on.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BTGrantedScaffold extends StatefulWidget {
  const BTGrantedScaffold({super.key});

  @override
  State<BTGrantedScaffold> createState() => _BTGrantedScaffoldState();
}

class _BTGrantedScaffoldState extends State<BTGrantedScaffold> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<BluetoothState>(
      stream: FlutterBluePlus.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        /* ==================== IF BLUETOOTH ADAPTER IS OFF ===================== */
        if (state == BluetoothState.off) {
          return BtOffWidgets(state: state);
        /* ==================== END IF BLUETOOTH ADAPTER IS OFF ===================== */

        /* ==================== IF BLUETOOTH ADAPTER IS ON ===================== */
        } else if (state == BluetoothState.on) {
          return BtOnWidgets(state: state);
        /* ==================== END IF BLUETOOTH ADAPTER IS ON ===================== */

        } else {
          return BtLoadingWidgets(state: state);
        }
      },
    );
  }
}
