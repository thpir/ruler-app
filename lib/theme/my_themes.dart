import 'package:flutter/material.dart';

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    focusColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 18
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontSize: 16
      ),
    ),
    fontFamily: 'Roboto'
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    focusColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 18
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontSize: 16
      ),
    ),
    fontFamily: 'Roboto'
  );
}