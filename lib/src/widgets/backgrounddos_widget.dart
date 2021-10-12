import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BackgroundComplete extends StatelessWidget {
  final Widget? child;
  final File? image;

  const BackgroundComplete({
    Key? key,
    this.child,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildPhotoBackground(context, image),
        child!,
      ],
    );
  }

  Widget _buildPhotoBackground(BuildContext context, File? image) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: image != null
              ? Image.file(
                  image,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  getValueForScreenType(
                    context: context,
                    mobile: 'assets/img/fondo/bkgroundCompleta.png',
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }
}
