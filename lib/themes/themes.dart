import 'package:flutter/material.dart';

var theme = ValueNotifier(0);

final themes = [
  ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(170, 46, 37, 1),
    backgroundColor: const Color.fromRGBO(170, 46, 37, 1),
    primaryColor: const Color.fromRGBO(246, 104, 94, 1),
    accentColor: Colors.white,
    fontFamily: "Euclid"
  ),
  ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(23, 105, 170, 1.0),
    backgroundColor: const Color.fromRGBO(23, 105, 170, 1.0),
    primaryColor: const Color.fromRGBO(33, 150, 243, 1.0),
    accentColor: Colors.white,
    fontFamily: "Euclid"
  ),
  ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(0, 105, 95, 1.0),
    backgroundColor: const Color.fromRGBO(0, 105, 95, 1.0),
    primaryColor: const Color.fromRGBO(0, 150, 136, 1.0),
    accentColor: Colors.white,
    fontFamily: "Euclid"
  ),
  ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(109, 27, 123, 1.0),
    backgroundColor: const Color.fromRGBO(109, 27, 123, 1.0),
    primaryColor: const Color.fromRGBO(159, 39, 176, 1.0),
    accentColor: Colors.white,
    fontFamily: "Euclid"
  ),
  ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(53, 122, 56, 1.0),
    backgroundColor: const Color.fromRGBO(53, 122, 56, 1.0),
    primaryColor: const Color.fromRGBO(76, 175, 80, 1.0),
    accentColor: Colors.white,
    fontFamily: "Euclid"
  ),
];
