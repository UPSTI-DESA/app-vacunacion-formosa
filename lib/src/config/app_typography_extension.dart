import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class SisVacuTipografia extends ThemeExtension<SisVacuTipografia> {
  const SisVacuTipografia({
    required this.tituloTarjeta,
    required this.subtituloTarjeta,
    required this.encabezadoDrawer,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.textoChip,
  });

  final TextStyle tituloTarjeta;
  final TextStyle subtituloTarjeta;
  final TextStyle encabezadoDrawer;
  final TextStyle textoPrincipal;
  final TextStyle textoSecundario;
  final TextStyle textoChip;

  factory SisVacuTipografia.crear() {
    final TextTheme base = GoogleFonts.nunitoTextTheme();
    return SisVacuTipografia(
      tituloTarjeta: base.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ) ??
          const TextStyle(),
      subtituloTarjeta: base.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ) ??
          const TextStyle(),
      encabezadoDrawer: base.labelMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
            height: 1.2,
          ) ??
          const TextStyle(),
      textoPrincipal: base.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ) ??
          const TextStyle(),
      textoSecundario: base.bodySmall?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ) ??
          const TextStyle(),
      textoChip: base.labelMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ) ??
          const TextStyle(),
    );
  }

  @override
  SisVacuTipografia copyWith({
    TextStyle? tituloTarjeta,
    TextStyle? subtituloTarjeta,
    TextStyle? encabezadoDrawer,
    TextStyle? textoPrincipal,
    TextStyle? textoSecundario,
    TextStyle? textoChip,
  }) {
    return SisVacuTipografia(
      tituloTarjeta: tituloTarjeta ?? this.tituloTarjeta,
      subtituloTarjeta: subtituloTarjeta ?? this.subtituloTarjeta,
      encabezadoDrawer: encabezadoDrawer ?? this.encabezadoDrawer,
      textoPrincipal: textoPrincipal ?? this.textoPrincipal,
      textoSecundario: textoSecundario ?? this.textoSecundario,
      textoChip: textoChip ?? this.textoChip,
    );
  }

  @override
  SisVacuTipografia lerp(
    ThemeExtension<SisVacuTipografia>? other,
    double t,
  ) {
    if (other is! SisVacuTipografia) return this;
    return SisVacuTipografia(
      tituloTarjeta: TextStyle.lerp(tituloTarjeta, other.tituloTarjeta, t) ?? tituloTarjeta,
      subtituloTarjeta: TextStyle.lerp(subtituloTarjeta, other.subtituloTarjeta, t) ?? subtituloTarjeta,
      encabezadoDrawer: TextStyle.lerp(encabezadoDrawer, other.encabezadoDrawer, t) ?? encabezadoDrawer,
      textoPrincipal: TextStyle.lerp(textoPrincipal, other.textoPrincipal, t) ?? textoPrincipal,
      textoSecundario: TextStyle.lerp(textoSecundario, other.textoSecundario, t) ?? textoSecundario,
      textoChip: TextStyle.lerp(textoChip, other.textoChip, t) ?? textoChip,
    );
  }
}

extension SisVacuTipografiaContext on BuildContext {
  SisVacuTipografia get sisTipografia {
    final ext = Theme.of(this).extension<SisVacuTipografia>();
    assert(
      ext != null,
      'ThemeData debe incluir SisVacuTipografia en extensions',
    );
    return ext!;
  }
}