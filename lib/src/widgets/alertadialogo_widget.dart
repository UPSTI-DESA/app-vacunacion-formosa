import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

/// Dialogo de advertencia o informacion (M3, tarjeta 22).
class DialogoAlerta extends StatelessWidget {
  final String? tituloAlerta;
  final String? descripcionAlerta;
  final String? textoBotonAlerta;
  final String? textoBotonAlerta2;
  final Image? image;
  /// Icono Material o Font Awesome; [IconTheme] aplica tamaño/color al hijo.
  final Widget icon;
  final Color? color;
  final Function? funcion1;
  final Function? funcion2;
  final bool envioFuncion1;
  final bool envioFuncion2;

  const DialogoAlerta({
    Key? key,
    required this.tituloAlerta,
    required this.descripcionAlerta,
    required this.textoBotonAlerta,
    this.image,
    required this.icon,
    required this.color,
    this.funcion1,
    required this.envioFuncion1,
    this.funcion2,
    required this.envioFuncion2,
    this.textoBotonAlerta2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: _cuerpo(context),
    );
  }

  Widget _cuerpo(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;
    final Color acento = color ?? cs.primary;
    final bool dosBotones =
        envioFuncion2 && textoBotonAlerta2 != null && textoBotonAlerta2!.isNotEmpty;

    final Color textoSobreAcento =
        ThemeData.estimateBrightnessForColor(acento) == Brightness.dark
            ? Colors.white
            : cs.onPrimary;

    void accionPrimaria() {
      if (envioFuncion1) {
        funcion1!();
      } else {
        Navigator.of(context).pop();
      }
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
      decoration: AppSuperficies.tarjeta(context, radio: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: acento,
              shape: BoxShape.circle,
            ),
            child: IconTheme(
              data: IconThemeData(color: textoSobreAcento, size: 28),
              child: icon,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            tituloAlerta!,
            textAlign: TextAlign.center,
            style: bar.barlowTituloTarjeta.copyWith(
              height: 1.15,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            descripcionAlerta!,
            textAlign: TextAlign.center,
            style: tt.bodyLarge?.copyWith(
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: AppSuperficies.textoSecundario(context),
            ),
          ),
          const SizedBox(height: 26),
          if (dosBotones)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => funcion2!(),
                    style: AppBotones.estiloOutlinedDialogo(cs),
                    child: Text(
                      textoBotonAlerta2!,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: accionPrimaria,
                    style: FilledButton.styleFrom(
                      backgroundColor: acento,
                      foregroundColor: textoSobreAcento,
                      minimumSize: const Size.fromHeight(48),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: AppBotones.forma,
                    ),
                    child: Text(
                      textoBotonAlerta!,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: textoSobreAcento,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: accionPrimaria,
                style: FilledButton.styleFrom(
                  backgroundColor: acento,
                  foregroundColor: textoSobreAcento,
                  minimumSize: const Size.fromHeight(48),
                  shape: AppBotones.forma,
                ),
                child: Text(
                  textoBotonAlerta!,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: textoSobreAcento,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
