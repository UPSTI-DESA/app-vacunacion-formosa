import 'package:flutter/material.dart';

import 'config.dart';

class SisVacuColor {
  static SisVacuTheme theme = SisVacuTheme.defaultTheme;

  static Color? get primaryGreen => theme.primaryGreen;
  static Color? get primaryRed => theme.primaryRed;
  static Color? get verdefuerte => theme.verdefuerte; //Color general del tema
  static Color? get verdeclaro => theme.verdeclaro; //Color general del tema
  static Color? get black => theme.black;
  static Color? get white => theme.white;
  static Color? get grey => theme.grey200;
  static Color? get inputsColor => theme.inputsColor;
  static Color? get borderContainer => theme.borderContainers;
  static Color? get blue => theme.blue; //Switch
  static Color? get yelow700 =>
      theme.yellow700; //Para los dialogos alerta de ATENCIÓN
  static Color? get pink => theme.pink; //Switch
  static Color? get orange => theme.orange; //Switch
  static Color? get purple => theme.purple; //Switch
  static Color? get red => theme.red; //Para los dialogos alerta de error
}
