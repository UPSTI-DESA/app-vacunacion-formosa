import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

/// Botón de acción principal reutilizable (Material 3).
///
/// Usa [FilledButton] para ripple, estados deshabilitados accesibles y
/// altura mínima táctil de 48 dp (WCAG / Material).
class BotonCustom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? iconoBoton;
  final bool? iconoBool;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final bool enabled;

  const BotonCustom({
    Key? key,
    required this.text,
    required this.onPressed,
    this.iconoBoton,
    this.iconoBool = false,
    this.borderRadius,
    this.height,
    this.width,
    this.color,
    this.enabled = true,
  }) : super(key: key);

  static const double _alturaMinimaTactil = 48;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bool usaColorPrimarioTema = color == null;
    final Color fondoActivo = color ?? cs.primary;
    final bool habilitado = enabled;
    final double altoSolicitado = height ?? _alturaMinimaTactil;
    final double alto = altoSolicitado < _alturaMinimaTactil
        ? _alturaMinimaTactil
        : altoSolicitado;

    final Color contenido = !habilitado
        ? cs.onSurface.withValues(alpha: 0.38)
        : (usaColorPrimarioTema
            ? cs.onPrimary
            : (ThemeData.estimateBrightnessForColor(fondoActivo) ==
                    Brightness.dark
                ? Colors.white
                : const Color(0xFF0D1B1E)));

    final bool mostrarIcono = (iconoBool ?? false) && iconoBoton != null;

    final Widget boton = FilledButton(
      onPressed: habilitado ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: habilitado ? fondoActivo : null,
        foregroundColor: habilitado ? contenido : null,
        disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: Size(48, alto),
        padding: EdgeInsets.symmetric(
          horizontal: mostrarIcono ? 16 : 20,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppEspaciado.radioBoton,
          ),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (mostrarIcono) ...[
            // Font Awesome (FaIcon) no siempre hereda el IconTheme del FilledButton;
            // forzamos el mismo tono que el texto ([contenido]).
            IconTheme(
              data: IconThemeData(color: contenido, size: 22),
              child: iconoBoton!,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppBotones.etiquetaBoton(
                Theme.of(context).textTheme,
                base: Theme.of(context).textTheme.titleMedium,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );

    final double? w = width;
    if (w != null && w != double.infinity) {
      return SizedBox(width: w, child: boton);
    }
    return SizedBox(width: w ?? double.infinity, child: boton);
  }
}
