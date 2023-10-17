
import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:stretcherapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  bool _darkMode = false;
  final prefs = UserPrefs();

  @override
  void initState() {
    super.initState();
    _darkMode = prefs.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: _darkMode,
      title: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        child: const Text(
          'Modo oscuro',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      subtitle: const Text(
        'El modo oscuro no fuerza tanto tu visión por la noche y reduce el consumo de batería.',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      onChanged: (value){
        setState(() {
          _darkMode = value;
          prefs.darkMode = value;
          context.read<ThemeProvider>().swapTheme();
        });
      },
    );
  }
}