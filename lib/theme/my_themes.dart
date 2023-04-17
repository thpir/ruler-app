import 'package:flutter/material.dart';

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    focusColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headline6: const TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.grey[800]),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    focusColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: TextTheme(
      headline6: const TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.grey[300]),
    ),
  );
}