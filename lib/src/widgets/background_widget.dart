import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';

class BackgroundHeader extends StatelessWidget {
  final Widget? child;
  final File? image;

  const BackgroundHeader({
    Key? key,
    this.child,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildPhotoBackground(context, image),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.485,
          child: _whiteBackground(context),
        ),
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
                    mobile: 'assets/img/fondo/bkgroundApp.png',
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _whiteBackground(context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: SisVacuColor.white,
        ),
      ],
    );
  }
}
