import 'package:exhalapp/pages/bt_permission_page/bt_permission_page.dart';
import 'package:exhalapp/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BTPermissionPage(),
    );
  }
}
