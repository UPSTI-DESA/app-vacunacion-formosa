import 'package:flutter/material.dart';

class SizeConfiguracion {
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    // APIs granulares: solo se invalida si cambia tamaño u orientación, no todo MediaQuery (p. ej. IME).
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;
    orientation = MediaQuery.orientationOf(context);
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfiguracion.screenHeight;
  return (inputHeight) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfiguracion.screenWidth;
  return (inputWidth) * screenWidth;
}
