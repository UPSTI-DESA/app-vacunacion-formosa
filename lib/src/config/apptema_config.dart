import 'package:flutter/material.dart';

class SisVacuTheme {
  static SisVacuTheme defaultTheme = SisVacuTheme._(
    id: 1,
    primaryGreen: const Color(0xFF39E489),
    primaryRed: const Color(0xFFFE3D2E),
    verdefuerte: const Color.fromRGBO(118, 214, 203, 1),
    verdeclaro: const Color.fromRGBO(189, 233, 227, 1),
    borderContainers: const Color.fromRGBO(202, 215, 230, 1),
    black: const Color(0xff071C07),
    white: const Color(0xffF2F2F2),
    grey200: Colors.grey[200],
    verceleste: const Color(0xFF00B0C7),
    vercelestePrimario: const Color(0xff005661),
    vercelesteSecundario: const Color(0xff00C6E0),
    vercelesteTerciario: const Color(0xff00D1ED),
    vercelesteCuaternario: const Color(0xff009CAF),
    azulFormosa: const Color(0xff004B8E),
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
        primaryColor: vercelesteCuaternario,
        bannerTheme: const MaterialBannerThemeData(),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: vercelestePrimario),
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
        // inputDecorationTheme: InputDecorationTheme(
        //   enabledBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(
        //       color: verdefuerte!,
        //     ),
        //   ),
        //   errorStyle: TextStyle(color: primaryRed),
        // ),
        backgroundColor: white,
        scaffoldBackgroundColor: white,
        // fontFamily: GoogleFonts.nunito().toString(),
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
  final Color? verceleste;
  final Color? vercelestePrimario;
  final Color? vercelesteSecundario;
  final Color? vercelesteTerciario;
  final Color? vercelesteCuaternario;
  final Color? azulFormosa;
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
    this.verceleste,
    this.vercelestePrimario,
    this.vercelesteSecundario,
    this.vercelesteTerciario,
    this.vercelesteCuaternario,
    this.azulFormosa,
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
