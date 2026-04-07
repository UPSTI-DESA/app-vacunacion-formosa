import 'package:flutter/material.dart';

import 'app_spacing_config.dart';

/// Sistema unificado de botones: misma forma y roles de color (Material 3).
class AppBotones {
  AppBotones._();

  static RoundedRectangleBorder get forma => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
      );

  /// Etiqueta sin color propio: hereda el `foregroundColor` del botón (mismo que el ícono).
  static TextStyle etiquetaBoton(
    TextTheme tt, {
    TextStyle? base,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    final TextStyle s = base ?? tt.titleSmall ?? const TextStyle();
    return TextStyle(
      inherit: true,
      fontFamily: s.fontFamily,
      fontFamilyFallback: s.fontFamilyFallback,
      fontSize: fontSize ?? s.fontSize,
      height: s.height,
      letterSpacing: s.letterSpacing,
      fontWeight: fontWeight,
    );
  }

  /// Ayuda: contorno primario + ícono primario (se distingue del resto de iconos planos).
  static ButtonStyle estiloIconoAyuda(ColorScheme cs) => IconButton.styleFrom(
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

  /// Acción secundaria en diálogos (cancelar, volver).
  static ButtonStyle estiloOutlinedDialogo(ColorScheme cs) =>
      OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: cs.onSurface,
        side: BorderSide(
          color: cs.outline.withValues(alpha: 0.6),
          width: 1,
        ),
        shape: forma,
      );

  /// Cancelar flujo o acción destructiva (siempre [ColorScheme.error]).
  static ButtonStyle estiloOutlinedPeligro(ColorScheme cs) =>
      OutlinedButton.styleFrom(
        foregroundColor: cs.error,
        side: BorderSide(
          color: cs.error.withValues(alpha: 0.5),
          width: 1.5,
        ),
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: forma,
      );

  /// CTA rellena a altura fija (hereda colores del tema si no se sobrescriben).
  static ButtonStyle estiloFilledCta({double alturaMinima = 48}) =>
      FilledButton.styleFrom(
        minimumSize: Size.fromHeight(alturaMinima),
        shape: forma,
      );

  /// Variante con icono + etiqueta.
  static ButtonStyle estiloFilledIconCta({
    double alturaMinima = 48,
    EdgeInsetsGeometry? padding,
  }) =>
      FilledButton.styleFrom(
        minimumSize: Size.fromHeight(alturaMinima),
        padding: padding,
        shape: forma,
      );

  /// Botones sobre fondo oscuro (post-escaneo): borde claro legible.
  static ButtonStyle estiloOutlinedSobreOscuro() => OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: forma,
      );

  static ButtonStyle estiloTextoSobreOscuro() => TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: Colors.white70,
        shape: forma,
      );
}
