import 'package:exhalapp/widgets/homepage/options_screen/dark_mode_sw.dart';
import 'package:exhalapp/widgets/homepage/options_screen/open_app_settings.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('Configuraciones'),
        ),
        body: ListView(
          children: const [
            DarkModeSwitch(),
            Divider(thickness: 2,),
            OpenAppSettings(),
            Divider(thickness: 2,),
          ],
        ),
      )
    );
  }
}