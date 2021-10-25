import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SobreNosotrosPage extends StatelessWidget {
  const SobreNosotrosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const estiloTexto = TextStyle(
      letterSpacing: 2.0,
      fontWeight: FontWeight.w300,
      fontSize: 20,
      color: Colors.black,
    );
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
            Color(0xff009CAF),
            Color(0xff0F8DED),
            Color(0xff1F7CFB),
          ])),
      child: Center(
          child: Container(
        width: size.width * 0.85,
        height: size.height * 0.50,
        margin: const EdgeInsets.symmetric(vertical: 30.0),
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0)
            ]),
        child: Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Text("Versión: 2.5.0",
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600),
                )),
            const SizedBox(
              height: 40.0,
            ),
            Text(
              "Desarrollado Por: ",

              // textAlign: TextAlign.start,
              style: GoogleFonts.nunito(textStyle: estiloTexto),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FadeInImage(
                  placeholder: const AssetImage('assets/img/fondo/noimage.jpg'),
                  image: const AssetImage('assets/img/fondo/logopolo.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.12,
                ),
                FadeInImage(
                  placeholder: const AssetImage('assets/img/fondo/noimage.jpg'),
                  image: const AssetImage('assets/img/fondo/logoupsti.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.05,
                ),
                FadeInImage(
                  placeholder: const AssetImage('assets/img/fondo/noimage.jpg'),
                  image: const AssetImage('assets/img/fondo/sisVacunacion.png'),
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
