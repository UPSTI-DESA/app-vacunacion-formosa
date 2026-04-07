import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Estilos Barlow precalculados al armar [ThemeData] (no en cada [build]).
///
/// Nunito ya viene del [TextTheme] principal (`GoogleFonts.nunitoTextTheme`).
@immutable
class SisVacuTipografia extends ThemeExtension<SisVacuTipografia> {
  const SisVacuTipografia({
    required this.barlowTituloTarjeta,
    required this.barlowSubtituloTarjeta,
    required this.barlowDrawerEncabezado,
  });

  /// Títulos de tarjeta tipo «Resumen», 22 / w700.
  final TextStyle barlowTituloTarjeta;

  /// Subtítulos Barlow (p. ej. «Ingreso manual del D.N.I.»), 18 / w700.
  final TextStyle barlowSubtituloTarjeta;

  /// Rótulo «Bienvenido» en drawer, 13 / w600, tracking amplio.
  final TextStyle barlowDrawerEncabezado;

  /// Construcción única junto al tema (llama a Google Fonts una vez por variante).
  factory SisVacuTipografia.crear() {
    return SisVacuTipografia(
      barlowTituloTarjeta: GoogleFonts.barlow(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      barlowSubtituloTarjeta: GoogleFonts.barlow(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      barlowDrawerEncabezado: GoogleFonts.barlow(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.2,
      ),
    );
  }

  @override
  SisVacuTipografia copyWith({
    TextStyle? barlowTituloTarjeta,
    TextStyle? barlowSubtituloTarjeta,
    TextStyle? barlowDrawerEncabezado,
  }) {
    return SisVacuTipografia(
      barlowTituloTarjeta:
          barlowTituloTarjeta ?? this.barlowTituloTarjeta,
      barlowSubtituloTarjeta:
          barlowSubtituloTarjeta ?? this.barlowSubtituloTarjeta,
      barlowDrawerEncabezado:
          barlowDrawerEncabezado ?? this.barlowDrawerEncabezado,
    );
  }

  @override
  SisVacuTipografia lerp(
    ThemeExtension<SisVacuTipografia>? other,
    double t,
  ) {
    if (other is! SisVacuTipografia) return this;
    return SisVacuTipografia(
      barlowTituloTarjeta: TextStyle.lerp(
            barlowTituloTarjeta,
            other.barlowTituloTarjeta,
            t,
          ) ??
          barlowTituloTarjeta,
      barlowSubtituloTarjeta: TextStyle.lerp(
            barlowSubtituloTarjeta,
            other.barlowSubtituloTarjeta,
            t,
          ) ??
          barlowSubtituloTarjeta,
      barlowDrawerEncabezado: TextStyle.lerp(
            barlowDrawerEncabezado,
            other.barlowDrawerEncabezado,
            t,
          ) ??
          barlowDrawerEncabezado,
    );
  }
}

extension SisVacuTipografiaContext on BuildContext {
  /// Tipografía Barlow del tema; falla en desarrollo si falta el registro.
  SisVacuTipografia get sisTipografia {
    final ext = Theme.of(this).extension<SisVacuTipografia>();
    assert(
      ext != null,
      'ThemeData debe incluir SisVacuTipografia en extensions',
    );
    return ext!;
  }
}
