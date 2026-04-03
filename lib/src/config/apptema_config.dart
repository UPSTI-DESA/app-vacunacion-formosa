import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_spacing_config.dart';

/// Colores de marca (no cambian con el brillo; se usan en acentos y AppBar).
class SisVacuMarca {
  SisVacuMarca._();

  static const Color vercelesteCuaternario = Color(0xff009CAF);
  static const Color vercelestePrimario = Color(0xff005661);
  static const Color verceleste = Color(0xFF00B0C7);
  static const Color vercelesteTerciario = Color(0xff00D1ED);
  static const Color verdefuerte = Color.fromRGBO(118, 214, 203, 1);
  static const Color primaryRed = Color(0xFFFE3D2E);
  static const Color primaryGreen = Color(0xFF39E489);
  static const Color azulFormosa = Color(0xff004B8E);
}

class SisVacuTheme {
  /// Tema claro por defecto (paleta legacy + [SisVacuColor]).
  static final SisVacuTheme light = SisVacuTheme._claro();

  /// Instancia oscura solo referencial; el [ThemeData] oscuro sale de [temaOscuro].
  static final SisVacuTheme dark = SisVacuTheme._oscuro();

  @Deprecated('Usar SisVacuTheme.light')
  static SisVacuTheme get defaultTheme => light;

  ThemeData get theme => _construirThemeData(_esquemaClaro());
  ThemeData get temaOscuro => _construirThemeData(_esquemaOscuro());

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

  factory SisVacuTheme._claro() {
    return SisVacuTheme._(
      id: 1,
      primaryGreen: SisVacuMarca.primaryGreen,
      primaryRed: SisVacuMarca.primaryRed,
      verdefuerte: SisVacuMarca.verdefuerte,
      verdeclaro: const Color.fromRGBO(189, 233, 227, 1),
      borderContainers: const Color.fromRGBO(202, 215, 230, 1),
      black: const Color(0xff071C07),
      white: const Color(0xffF2F2F2),
      grey200: Colors.grey[200],
      verceleste: SisVacuMarca.verceleste,
      vercelestePrimario: SisVacuMarca.vercelestePrimario,
      vercelesteSecundario: const Color(0xff00C6E0),
      vercelesteTerciario: SisVacuMarca.vercelesteTerciario,
      vercelesteCuaternario: SisVacuMarca.vercelesteCuaternario,
      azulFormosa: SisVacuMarca.azulFormosa,
      yellow700: Colors.yellow[700],
      pink: Colors.pink,
      orange: Colors.orange,
      purple: Colors.purple,
      red: Colors.red,
      inputsColor: const Color.fromRGBO(199, 224, 211, 0.57),
      brightness: Brightness.light,
    );
  }

  /// Referencia para futuras extensiones; [SisVacuColor] sigue enlazado a [light].
  factory SisVacuTheme._oscuro() {
    return SisVacuTheme._(
      id: 2,
      primaryGreen: SisVacuMarca.primaryGreen,
      primaryRed: SisVacuMarca.primaryRed,
      verdefuerte: SisVacuMarca.verdefuerte,
      verdeclaro: const Color.fromRGBO(60, 90, 86, 1),
      borderContainers: const Color(0xFF3D4A55),
      black: const Color(0xFFE8E8E8),
      white: const Color(0xFF121212),
      grey200: Colors.grey[700],
      verceleste: const Color(0xFF4DD0E1),
      vercelestePrimario: const Color(0xFF80DEEA),
      vercelesteSecundario: const Color(0xFF4DD0E1),
      vercelesteTerciario: const Color(0xFF6FF4FF),
      vercelesteCuaternario: const Color(0xFF5BC8D8),
      azulFormosa: const Color(0xFF6BA3D6),
      yellow700: Colors.yellow[400],
      pink: Colors.pink[200],
      orange: Colors.orange[300],
      purple: Colors.purple[200],
      red: Colors.red[300],
      inputsColor: const Color.fromRGBO(80, 120, 100, 0.45),
      brightness: Brightness.dark,
    );
  }

  ColorScheme _esquemaClaro() {
    return ColorScheme.light(
      primary: vercelesteCuaternario!,
      onPrimary: Colors.white,
      secondary: verdefuerte!,
      onSecondary: black!,
      surface: const Color(0xFFF7F7F7),
      onSurface: black!,
      error: primaryRed!,
      onError: Colors.white,
      tertiary: vercelesteTerciario,
      outline: borderContainers,
    );
  }

  ColorScheme _esquemaOscuro() {
    return ColorScheme.fromSeed(
      seedColor: SisVacuMarca.vercelesteCuaternario,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF5DD4E8),
      onPrimary: const Color(0xFF001920),
      primaryContainer: const Color(0xFF004C5C),
      onPrimaryContainer: const Color(0xFFB8EEF7),
      secondary: const Color(0xFF7FD0C2),
      onSecondary: const Color(0xFF001F1A),
      tertiary: const Color(0xFF68D6EE),
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFECECEC),
      onSurfaceVariant: const Color(0xFFB8C0C6),
      surfaceContainerLowest: const Color(0xFF0C0C0C),
      surfaceContainerLow: const Color(0xFF181818),
      surfaceContainer: const Color(0xFF1E1E1E),
      surfaceContainerHigh: const Color(0xFF2C2C2C),
      surfaceContainerHighest: const Color(0xFF383838),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      outline: const Color(0xFF8E9AA3),
      outlineVariant: const Color(0xFF5A656E),
    );
  }

  ThemeData _construirThemeData(ColorScheme colorScheme) {
    final bool oscuro = colorScheme.brightness == Brightness.dark;
    final TextTheme textoBase = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    ).textTheme;
    final TextTheme nunito = GoogleFonts.nunitoTextTheme(textoBase).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      primaryColor: SisVacuMarca.vercelesteCuaternario,
      scaffoldBackgroundColor: colorScheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: nunito,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: SisVacuMarca.vercelesteCuaternario,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.nunito(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: oscuro ? 0 : 1,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppEspaciado.radioTarjeta),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline
            .withValues(alpha: oscuro ? 0.35 : 0.45),
        thickness: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: SisVacuMarca.vercelestePrimario,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppEspaciado.sm)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: oscuro ? 0.6 : 0.85,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.lg,
          vertical: AppEspaciado.sm,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SisVacuMarca.verceleste;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SisVacuMarca.verceleste.withValues(alpha: 0.45);
          }
          return colorScheme.surfaceContainerHigh;
        }),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppEspaciado.sm)),
        ),
      ),
      bannerTheme: const MaterialBannerThemeData(),
    );
  }
}
