import 'package:stretcherapp/widgets/bt_permission_page/bt_denied.dart';
import 'package:stretcherapp/widgets/bt_permission_page/bt_granted.dart';
import 'package:flutter/material.dart';
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
    
    getBtPermission();

    /* ==================== IF BT PERMISSION IS DENIED ==================== */
    if (btPermission == false) {
      return const BTDeniedScaffold();
    /* ==================== END IF BT PERMISSION IS DENIED ==================== */

    /* ==================== IF BT PERMISSION IS GRANTED ==================== */
    } else {
      return const BTGrantedScaffold();
    }
    /* ==================== END IF BT PERMISSION IS GRANTED ==================== */
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
