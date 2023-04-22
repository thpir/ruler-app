import 'package:flutter/material.dart';

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    focusColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 18
      ),
      bodyText2: TextStyle(
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
      headline6: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 18
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'Roboto',
        fontSize: 16
      ),
    ),
    fontFamily: 'Roboto'
  );
}