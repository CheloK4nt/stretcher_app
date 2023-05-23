import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData? _selectedTheme;

  ThemeData dark = ThemeData.dark().copyWith(
    // ignore: prefer_const_constructors
    brightness: Brightness.dark,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3A3C5F),
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF323347),
    ),

    dialogTheme: const DialogTheme(
      alignment: Alignment.center,
      backgroundColor: Color(0xFFBDEFFF),
      iconColor: Color(0xFF0071E4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Color(0xFF00C0FF)),
      ),
      titleTextStyle: TextStyle(
        color: Color(0xFF676767),
        fontWeight: FontWeight.bold
      ),
      contentTextStyle: TextStyle(
        color: Color(0xFF676767),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFFF2F2F2),
      iconColor: Color(0xFF0071E4),
    ),

    scaffoldBackgroundColor: const Color(0xFF222439),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states){
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF0071E4);
        } else {
          return Colors.grey;
        }
      }),
      trackColor: MaterialStateProperty.resolveWith((states){
        if (states.contains(MaterialState.selected)) {
          return const Color.fromARGB(238, 0, 58, 116);
        } else {
          return const Color(0xFF3A3C5F);
        }
      })
    ),

    colorScheme: const ColorScheme.dark(
      tertiary: Color(0xFFF8F8F8),
    )

  );

  ThemeData light = ThemeData.light().copyWith(
    // ignore: prefer_const_constructors
    brightness: Brightness.light,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0071E4),
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0071E4),
    ),

    dialogTheme: const DialogTheme(
      alignment: Alignment.center,
      backgroundColor: Color(0xFFBDEFFF),
      iconColor: Color(0xFF0071E4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Color(0xFF00C0FF)),
      ),
      titleTextStyle: TextStyle(
        color: Color(0xFF676767),
        fontWeight: FontWeight.bold
      ),
      contentTextStyle: TextStyle(
        color: Color(0xFF676767),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      textColor: Color.fromARGB(255, 75, 75, 75),
      iconColor: Color(0xFF0071E4),
    ),

    scaffoldBackgroundColor: Colors.white,

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states){
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF0071E4);
        } else {
          return Colors.grey;
        }
      }),
      trackColor: MaterialStateProperty.resolveWith((states){
        if (states.contains(MaterialState.selected)) {
          return const Color.fromARGB(238, 0, 58, 116);
        } else {
          return const Color.fromARGB(255, 227, 230, 230);
        }
      })
    ),

    colorScheme: const ColorScheme.light(
      tertiary: Color(0xFF676767),
    )

    
    
    // colorScheme: const ColorScheme.light(
    //   brightness: Brightness.light,
    //   primary: Colors.blue,
    //   onPrimary: Colors.white,
    //   secondary: Colors.blue,
    //   onSecondary: Colors.white,
    //   error: Colors.blue,
    //   onError: Colors.white,
    //   background: Colors.blue,
    //   onBackground: Colors.white,
    //   surface: Colors.blue,
    //   onSurface: Colors.white,
    // )  
  );

  ThemeProvider(bool isDark){
    _selectedTheme = (isDark) ? dark : light;
  }

  Future<void> swapTheme() async {
    if (_selectedTheme == dark){
      _selectedTheme = light;
    } else {
      _selectedTheme = dark;
    }
    notifyListeners();
  }

  ThemeData? getTheme() => _selectedTheme;
}