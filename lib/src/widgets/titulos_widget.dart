import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_vacunacion/src/config/config.dart';

class TitulosContainerPage extends StatelessWidget {
  final String? title;
  final Color? colorTitle;
  final double? sizeTitle;
  final double? widthThickness;

  const TitulosContainerPage({
    Key? key,
    this.title,
    this.colorTitle,
    this.sizeTitle,
    this.widthThickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUpBig(
          from: 25,
          child: Row(
            children: [
              Text(
                title!,
                style: GoogleFonts.barlow(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20)),
              ),
            ],
          ),
        ),
        FadeInDownBig(
          from: 25,
          child: Divider(
            color: SisVacuColor.vercelesteTerciario,
            thickness: widthThickness,
          ),
        ),
      ],
    );
  }
}
