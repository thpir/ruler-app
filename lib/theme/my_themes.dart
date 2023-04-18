import 'package:flutter/material.dart';

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    focusColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headline6: TextStyle(color: Colors.black),
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 18
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 16
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    focusColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: const TextTheme(
      headline6: TextStyle(color: Colors.white),
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 18
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 16
      ),
    ),
  );
}