import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

Future<bool> onWillPop(BuildContext context) async {
  final mensajeExit = await showDialog(
      context: context,
      builder: (context) => DialogoAlerta(
            envioFuncion2: true,
            envioFuncion1: true,
            tituloAlerta: 'ATENCIÓN',
            descripcionAlerta:
                'Seguro que desea salir? debera logearse nuevamente',
            textoBotonAlerta: 'SI',
            textoBotonAlerta2: 'NO',
            funcion1: () => Navigator.of(context).pop(true),
            funcion2: () => Navigator.of(context).pop(false),
            color: Colors.red,
            icon: Icon(
              Icons.new_releases_outlined,
              size: 40.0,
              color: Colors.grey[50],
            ),
          ));
  return mensajeExit ?? false;
}

Widget titulos(String titulo) {
  return FadeInUpBig(
    from: 25,
    child: Text(
      titulo,
      style: GoogleFonts.barlow(
          textStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
    ),
  );
}
