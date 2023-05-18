import 'package:flutter/material.dart';

class BTGrantedScaffold extends StatefulWidget {
  const BTGrantedScaffold({super.key});

  @override
  State<BTGrantedScaffold> createState() => _BTGrantedScaffoldState();
}

class _BTGrantedScaffoldState extends State<BTGrantedScaffold> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          /* ==================== EXHALAPP LOGO ==================== */
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.3,
                bottom: height * 0.17,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Image.asset(
                  'assets/images/Logo-EXHALAPP_color.png',
                ),
              ),
            ),
          /* ==================== END EXHALAPP LOGO ==================== */
          ],
        )
      ),
    );
  }
}