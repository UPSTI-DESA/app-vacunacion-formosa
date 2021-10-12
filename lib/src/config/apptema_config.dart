import 'package:flutter/material.dart';

class SisVacuTheme {
  static SisVacuTheme defaultTheme = SisVacuTheme._(
    id: 1,
    primaryGreen: const Color(0xFF39E489),
    primaryRed: const Color(0xFFFE3D2E),
    verdefuerte: const Color.fromRGBO(118, 214, 203, 1),
    verdeclaro: const Color.fromRGBO(189, 233, 227, 1),
    borderContainers: const Color.fromRGBO(202, 215, 230, 1),
    black: Colors.black87,
    white: Colors.white,
    grey200: Colors.grey[200],
    blue: Colors.blue,
    yellow700: Colors.yellow[700],
    pink: Colors.pink,
    orange: Colors.orange,
    purple: Colors.purple,
    red: Colors.red,
    inputsColor: const Color.fromRGBO(199, 224, 211, 0.57),
    brightness: Brightness.light,
  );

  ThemeData get theme => ThemeData(
        brightness: brightness,
        primaryColor: verdefuerte,
        bannerTheme: const MaterialBannerThemeData(),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: verdefuerte),
        accentColor: verdefuerte,
        accentColorBrightness: brightness,
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          subtitle1: TextStyle(),
          subtitle2: TextStyle(),
        ).apply(
          bodyColor: black,
          displayColor: white,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: verdefuerte,
        ),
        errorColor: primaryRed,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: verdefuerte!,
            ),
          ),
          errorStyle: TextStyle(color: primaryRed),
        ),
        backgroundColor: white,
        scaffoldBackgroundColor: verdeclaro,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
      );

  final int? id;
  final Color? primaryGreen;
  final Color? primaryRed;
  final Color? verdefuerte;
  final Color? verdeclaro;
  final Color? black;
  final Color? white;
  final Color? grey200;
  final Color? blue;
  final Color? yellow700;
  final Color? pink;
  final Color? orange;
  final Color? purple;
  final Color? red;
  final Color? inputsColor;
  final Brightness? brightness;
  final Color? borderContainers;

  const SisVacuTheme._({
    this.id,
    this.primaryGreen,
    this.primaryRed,
    this.verdefuerte,
    this.verdeclaro,
    this.black,
    this.white,
    this.grey200,
    this.blue,
    this.yellow700,
    this.pink,
    this.orange,
    this.purple,
    this.red,
    this.inputsColor,
    this.brightness,
    this.borderContainers,
  });
}
