import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_vacunacion/src/config/appcolor_config.dart';

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
      decoration: BoxDecoration(color: SisVacuColor.white),
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
            Text("Versión: 2.5.1",
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
                Image(
                  image: const AssetImage('assets/img/fondo/logopolo.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.12,
                ),
                Image(
                  image: const AssetImage('assets/img/fondo/logoupsti.png'),
                  fit: BoxFit.cover,
                  height: size.height * 0.05,
                ),
                Image(
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
