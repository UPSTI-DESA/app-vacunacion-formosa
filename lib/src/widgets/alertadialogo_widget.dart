import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class DialogoAlerta extends StatelessWidget {
  final String? tituloAlerta,
      descripcionAlerta,
      textoBotonAlerta,
      textoBotonAlerta2;
  final Image? image;
  final Icon icon;
  final Color? color;
  final Function? funcion1;
  final Function? funcion2;
  final bool envioFuncion1;
  final bool envioFuncion2;

  const DialogoAlerta({
    required this.tituloAlerta,
    required this.descripcionAlerta,
    required this.textoBotonAlerta,
    this.image,
    required this.icon,
    required this.color,
    this.funcion1,
    required this.envioFuncion1,
    this.funcion2,
    required this.envioFuncion2,
    this.textoBotonAlerta2,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contenidoDialogo(context),
    );
  }

  contenidoDialogo(BuildContext context) {
    const double padding = 16.0;
    const double avatarRadius = 40.0;
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                )
              ]),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(
              this.tituloAlerta!,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.0),
            Text(descripcionAlerta!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16.0,
                )),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                envioFuncion2
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                          onPressed: () {
                            funcion2!();
                          },
                          child: Text(textoBotonAlerta2!),
                        ))
                    : Container(),
                Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        envioFuncion1
                            ? funcion1!()
                            : Navigator.of(context).pop();
                      },
                      child: Text(textoBotonAlerta!),
                    ))
              ],
            ),
          ])),
      Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            child: Pulse(
                infinite: true, duration: Duration(seconds: 2), child: icon),
            backgroundColor: color,
            radius: avatarRadius,
          ))
    ]);
  }
}
