import 'package:flutter/material.dart';

class SobreNosotrosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTexto = TextStyle(
      letterSpacing: 2.0,
      fontWeight: FontWeight.w300,
      fontSize: 20,
      color: Colors.black,
    );
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
            Color.fromRGBO(189, 233, 227, 1),
            Color.fromRGBO(118, 214, 203, 1),
          ])),
      child: Center(
          child: Container(
        width: size.width * 0.85,
        height: size.height * 0.50,
        margin: EdgeInsets.symmetric(vertical: 30.0),
        padding: EdgeInsets.symmetric(vertical: 50.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0)
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Versión: 2.0.0",
              style: TextStyle(
                  fontSize: 20, color: Colors.black, letterSpacing: 2.0),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Desarrollado Por: ",

              // textAlign: TextAlign.start,
              style: estiloTexto,
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FadeInImage(
                  placeholder: AssetImage('assets/img/fondo/noimage.jpg'),
                  image: AssetImage('assets/img/fondo/logopolo.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.12,
                ),
                FadeInImage(
                  placeholder: AssetImage('assets/img/fondo/noimage.jpg'),
                  image: AssetImage('assets/img/fondo/logoupsti.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.05,
                ),
                FadeInImage(
                  placeholder: AssetImage('assets/img/fondo/noimage.jpg'),
                  image: AssetImage('assets/img/fondo/sisVacunacion.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.10,
                ),
              ],
            ),
          ],
        ),
      )),
    ));
  }
}
