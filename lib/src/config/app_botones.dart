import 'package:flutter/material.dart';

import 'app_spacing_config.dart';

class AppBotones {
  AppBotones._();

  static const double iconoTamano = 20.0;

  static const double fontSizeBoton = 15.0;

  static const FontWeight fontWeightBoton = FontWeight.w600;

  static RoundedRectangleBorder get forma => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
      );

  static TextStyle etiquetaBoton(
    TextTheme tt, {
    double? fontSize,
  }) {
    final TextStyle s = tt.titleSmall ?? const TextStyle();
    return TextStyle(
      fontSize: fontSize ?? fontSizeBoton,
      fontWeight: fontWeightBoton,
      height: s.height,
      letterSpacing: s.letterSpacing,
    );
  }

  static ButtonStyle estiloBase({
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
  }) =>
      ButtonStyle(
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: fontSize ?? fontSizeBoton,
            fontWeight: fontWeight ?? fontWeightBoton,
          ),
        ),
        iconSize: WidgetStateProperty.all(iconoTamano),
        padding: WidgetStateProperty.all(
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );

  static ButtonStyle estiloIconoAyuda(ColorScheme cs) =>
      IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.padded,
        foregroundColor: cs.primary,
        backgroundColor: cs.surfaceContainerLow,
        side: BorderSide(
          color: cs.primary.withValues(alpha: 0.55),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
        ),
      );

  static ButtonStyle estiloOutlined(ColorScheme cs) =>
      OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        foregroundColor: cs.onSurface,
        side: BorderSide(
          color: cs.outline.withValues(alpha: 0.6),
          width: 1,
        ),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloOutlinedPeligro(ColorScheme cs) =>
      OutlinedButton.styleFrom(
        foregroundColor: cs.error,
        side: BorderSide(
          color: cs.error.withValues(alpha: 0.5),
          width: 1.5,
        ),
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloFilled(ColorScheme cs) =>
      FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloFilledPrimario(ColorScheme cs) =>
      FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloTexto(ColorScheme cs) =>
      TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: cs.primary,
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloTextoPequeno(ColorScheme cs) =>
      TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: cs.primary,
        shape: forma,
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.sm,
          vertical: AppEspaciado.xs,
        ),
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloOutlinedSobreOscuro() =>
      OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloTextoSobreOscuro() =>
      TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: Colors.white70,
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloFilledCta() =>
      FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloFilledIconCta({
    double? fontSize,
    EdgeInsetsGeometry? padding,
  }) =>
      FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSize ?? fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloOutlinedSecundario() =>
      OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );

  static ButtonStyle estiloOutlinedAccion(ColorScheme cs) =>
      OutlinedButton.styleFrom(
        foregroundColor: cs.error,
        side: BorderSide(color: cs.error.withValues(alpha: 0.6)),
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: forma,
        textStyle: TextStyle(
          fontSize: fontSizeBoton,
          fontWeight: fontWeightBoton,
        ),
        iconSize: iconoTamano,
      );
}