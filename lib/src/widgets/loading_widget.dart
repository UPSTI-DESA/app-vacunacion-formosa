import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class LoadingEstrellas extends StatelessWidget {
  const LoadingEstrellas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .15,
          height: MediaQuery.of(context).size.width * .15,
          child: Roulette(
            duration: const Duration(seconds: 10),
            spins: 0.5,
            child: const Image(
              image: AssetImage('assets/img/fondo/estrellasNuevas.png'),
            ),
          ),
        ),
        // Text(
        //   'Cargando...',
        //   style: GoogleFonts.nunito(
        //       textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        // )
      ],
    );
  }
}
