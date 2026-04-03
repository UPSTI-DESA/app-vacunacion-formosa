/// Escala de espaciado base 4/8 pt para márgenes y gutters coherentes.
class AppEspaciado {
  AppEspaciado._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Radio habitual de tarjetas y contenedores.
  static const double radioTarjeta = 8;

  /// Radio de campos tipo “pill”.
  static const double radioCampo = 20;
}

/// Duraciones cortas para feedback UI (Material respeta animaciones reducidas del sistema).
class AppMotion {
  AppMotion._();

  static const Duration rapida = Duration(milliseconds: 180);
  static const Duration estandar = Duration(milliseconds: 260);
  static const Duration entrada = Duration(milliseconds: 320);
}
