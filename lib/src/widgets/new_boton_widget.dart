import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonCustom extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Icon? iconoBoton;
  final bool? iconoBool;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Color? color;

  const BotonCustom(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.iconoBoton,
      this.iconoBool = false,
      this.borderRadius,
      this.height,
      this.width,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color fondo = color ?? Theme.of(context).colorScheme.primary;
    final Color textoIcono =
        ThemeData.estimateBrightnessForColor(fondo) == Brightness.dark
            ? Colors.white
            : const Color(0xFF0D1B1E);

    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(borderRadius ?? 32)),
        width: width ?? double.infinity,
        height: height ?? 40,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconoBool!
                  ? IconTheme(
                      data: IconThemeData(color: textoIcono, size: 24),
                      child: iconoBoton!,
                    )
                  : Container(),
              const SizedBox(
                width: 10.0,
              ),
              Text(text,
                  style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textoIcono,
                          fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}
