import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

Future<bool> onWillPop(BuildContext context) async {
  final mensajeExit = await showDialog(
      context: context,
      builder: (context) => DialogoAlerta(
            envioFuncion2: true,
            envioFuncion1: true,
            tituloAlerta: '¿Cerrar sesión?',
            descripcionAlerta:
                'Si sale, deberá iniciar sesión otra vez escaneando su documento.',
            textoBotonAlerta: 'Sí, salir',
            textoBotonAlerta2: 'No',
            funcion1: () => Navigator.of(context).pop(true),
            funcion2: () => Navigator.of(context).pop(false),
            color: Theme.of(context).colorScheme.error,
            icon: const Icon(
              Icons.new_releases_outlined,
              size: 40.0,
            ),
          ));
  return mensajeExit ?? false;
}

Widget titulos(BuildContext context, String titulo) {
  return FadeInUpBig(
    from: 25,
    child: Text(
      titulo,
      style: context.sisTipografia.tituloTarjeta.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}
