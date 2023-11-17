import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, Color backgroundColor, int seconds) {

  final snackBar = SnackBar(
    content: Center(child: Text(text)),
    backgroundColor: backgroundColor,
    duration: Duration(seconds: seconds), 
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}