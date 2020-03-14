import 'package:flutter/material.dart';

//This file contains the main theme settings

//Return the ThemeData with Brightness
ThemeData getMainThemeWithBrightness(BuildContext context, Brightness appBrightness) {
  double size = 300;
  try {
    size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  } catch (e) {
    size = 300;
  }

  return ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.black,
    primarySwatch: Colors.blue,
    fontFamily: 'Poppins',

    appBarTheme: AppBarTheme(color: Color.fromARGB(255, 3, 4, 6), iconTheme: IconThemeData(color: Colors.white)),

    disabledColor: Color.fromARGB(255, 178, 191, 202),

    iconTheme: IconThemeData(
        color: appBrightness == Brightness.light ? Color.fromARGB(255, 51, 72, 84) : Color.fromARGB(255, 178, 191, 202),
        opacity: 1.0,
        size: size * 0.06),

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: size * 0.075,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
      headline2: TextStyle(
          fontSize: size * 0.07,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
      subtitle1: TextStyle(
          fontSize: size * 0.06,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
      subtitle2: TextStyle(
          fontSize: size * 0.055,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
      caption: TextStyle(
          fontSize: size * 0.05,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
      bodyText1: TextStyle(
          fontSize: size * 0.05,
          fontFamily: "Poppins",
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
      bodyText2: TextStyle(
          fontSize: size * 0.040,
          fontFamily: "Poppins",
          color: appBrightness == Brightness.light ? Colors.black : Colors.white),
    ),
    primaryTextTheme: appBrightness == Brightness.light
        ? Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.black)
        : Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
    brightness: appBrightness,
  );
}
