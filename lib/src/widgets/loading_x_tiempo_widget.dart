import 'package:flutter/material.dart';

import 'loading_widget.dart';

void mostrarLoadingEstrellasXTiempo(context, int tiempoMili) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(Duration(milliseconds: tiempoMili), () {
          Navigator.of(context).pop(true);
        });
        return const LoadingEstrellas();
      });
}
