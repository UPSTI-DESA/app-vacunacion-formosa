import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

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
          child: Text(
            title!,
            style: TextStyle(
                color: colorTitle,
                fontSize: sizeTitle,
                fontWeight: FontWeight.w300),
          ),
        ),
        FadeInDownBig(
          from: 25,
          child: Divider(
            thickness: widthThickness,
          ),
        ),
      ],
    );
  }
}
