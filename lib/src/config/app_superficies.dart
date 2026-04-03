import 'package:flutter/material.dart';

/// Tarjetas y sombras coherentes con tema claro/oscuro.
class AppSuperficies {
  AppSuperficies._();

  /// Tarjeta estándar (radio 8) con sombra suave según brillo.
  static BoxDecoration tarjeta(BuildContext context, {double radio = 8}) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final sombraAlpha = tema.brightness == Brightness.dark ? 0.42 : 0.09;
    return BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(radio),
      boxShadow: [
        BoxShadow(
          color: cs.shadow.withValues(alpha: sombraAlpha),
          offset: const Offset(0, 4),
          blurRadius: 8,
        ),
      ],
    );
  }

  /// Texto secundario legible sobre superficie.
  static Color textoSecundario(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72);
  }

  /// Color para pasos / chips no seleccionados (progreso, toggles).
  static Color indicadorApagado(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38);
  }

  /// Icono sobre acento de marca (AppBar, botones primarios).
  static Color textoSobreAcentoMarca() => Colors.white;

  /// Contenedor tipo “pill” para buscadores (antes blueGrey[50]).
  static BoxDecoration campoBusqueda(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final a = tema.brightness == Brightness.dark ? 0.28 : 0.07;
    return BoxDecoration(
      color: cs.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: cs.shadow.withValues(alpha: a),
          offset: const Offset(0, 5),
          blurRadius: 5,
        ),
      ],
    );
  }
}
