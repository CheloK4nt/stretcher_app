import 'package:exhalapp/pages/bt_permission_page/bt_permission_page.dart';
import 'package:exhalapp/providers/shared_pref.dart';
import 'package:exhalapp/providers/theme_provider.dart';
import 'package:exhalapp/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPrefs();
  await prefs.initPrefs();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp( 
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UIProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs.darkMode)),
        ],
        child: const MonitorEBCApp()
      )
    );
  });
}

class MonitorEBCApp extends StatelessWidget {
  const MonitorEBCApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          theme: value.getTheme(),
          home: const BTPermissionPage(),
        );
      }
    );
  }
}

