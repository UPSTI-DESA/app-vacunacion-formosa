import 'package:flutter/material.dart';

import 'widgets.dart';

class ColorTextButton extends StatelessWidget {
  final String text;
  final double? anchoValor;
  final void Function() onPressed;
  final Icon? iconoBoton;
  final bool? iconoBool;
  final Color? color;

  const ColorTextButton(
    this.text, {
    Key? key,
    required this.onPressed,
    required this.anchoValor,
    this.iconoBoton,
    this.iconoBool,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      ancho: anchoValor,
      child: TextButton(
        // splashColor: Colors.blueAccent,
        // color: SisVacuColor.verdefuerte,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color?>(color),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconoBool! ? iconoBoton! : Container(),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: color != null
                    ? (ThemeData.estimateBrightnessForColor(color!) ==
                            Brightness.dark
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface)
                    : Theme.of(context).colorScheme.onSurface,
                letterSpacing: 1.3,
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
