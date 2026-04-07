import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

class BaseButton extends StatelessWidget {
  final Widget child;
  final double? ancho;

  const BaseButton({
    Key? key,
    required this.child,
    required this.ancho,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width * .9;
    double fixedWidth = ancho!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.05,
        width: fixedWidth <= mediaQueryWidth ? fixedWidth : mediaQueryWidth,
        child: child,
      ),
    );
  }
}
