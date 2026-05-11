import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

class DialogoAlerta extends StatelessWidget {
  final String? tituloAlerta;
  final String? descripcionAlerta;
  final String? textoBotonAlerta;
  final String? textoBotonAlerta2;
  final Image? image;
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
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppEspaciado.xl,
        vertical: AppEspaciado.xl,
      ),
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
      padding: const EdgeInsets.fromLTRB(
        AppEspaciado.xl,
        AppEspaciado.lg,
        AppEspaciado.xl,
        AppEspaciado.xl,
      ),
      decoration: AppSuperficies.tarjetaBlanca(context, radio: AppEspaciado.radioCampo),
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
              data: IconThemeData(
                color: textoSobreAcento,
                size: AppTamanoIcono.grande,
              ),
              child: icon,
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          Text(
            tituloAlerta!,
            textAlign: TextAlign.center,
            style: bar.tituloTarjeta.copyWith(
              height: 1.15,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppEspaciado.sm),
          Text(
            descripcionAlerta!,
            textAlign: TextAlign.center,
            style: tt.bodyLarge?.copyWith(
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: AppSuperficies.textoSecundario(context),
            ),
          ),
          const SizedBox(height: AppEspaciado.xl),
          if (dosBotones)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => funcion2!(),
                    style: AppBotones.estiloOutlinedDialogo(cs),
                    child: Text(textoBotonAlerta2!),
                  ),
                ),
                const SizedBox(width: AppEspaciado.md),
                Expanded(
                  child: FilledButton(
                    onPressed: accionPrimaria,
                    style: AppBotones.estiloFilledCta().copyWith(
                      backgroundColor: WidgetStateProperty.all(acento),
                      foregroundColor: WidgetStateProperty.all(textoSobreAcento),
                    ),
                    child: Text(textoBotonAlerta!),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: accionPrimaria,
                style: AppBotones.estiloFilledCta().copyWith(
                  backgroundColor: WidgetStateProperty.all(acento),
                  foregroundColor: WidgetStateProperty.all(textoSobreAcento),
                ),
                child: Text(textoBotonAlerta!),
              ),
            ),
        ],
      ),
    );
  }
}