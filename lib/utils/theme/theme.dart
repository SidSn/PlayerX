import 'package:flutter/material.dart';
import 'package:player_x/utils/const/colors.dart';

final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    primaryColorDark: bgColor,
    primaryColorLight: Colors.white,
    textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
        )));

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primaryColor: Colors.white,
    primaryColorDark: bgColor,
    focusColor: Colors.grey,
    primaryColorLight: Colors.black,
    appBarTheme:
        const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
    textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
        headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        headlineSmall:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        titleLarge:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black)));
