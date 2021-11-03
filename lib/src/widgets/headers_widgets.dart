import 'package:flutter/material.dart';
import 'package:sistema_vacunacion/src/config/appcolor_config.dart';

class EncabezadoWave extends StatelessWidget {
  const EncabezadoWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoWavePainter(),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoWavePainter(),
          ),
        ),
      ],
    );
  }
}

class _EncabezadoWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint();

    //Propiedades
    lapiz.color = SisVacuColor.vercelesteCuaternario!
        .withOpacity(0.2); //Color.fromRGBO(19, 44, 74, 1);
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 0.5;

    final direccion = Path();

    //Dibujar con el path y el lapiz
    direccion.lineTo(0, size.height * 0.75);

    direccion.quadraticBezierTo(size.width * 0.30, size.height * 0.80,
        size.width * 0.5, size.height * 0.75);

    direccion.quadraticBezierTo(
        size.width * 0.75, size.height * 0.70, size.width, size.height * 0.75);

    direccion.lineTo(size.width, size.height * 0.1);

    direccion.quadraticBezierTo(
        size.width * 0.65, size.height * 0.08, size.width * 0.45, 0);

    canvas.drawPath(direccion, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class EncabezadoDos extends StatelessWidget {
  const EncabezadoDos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: _EncabezadoDosPainter(),
      ),
    );
  }
}

class _EncabezadoDosPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint();

    //Propiedades
    lapiz.color = Colors.blue; //Color.fromRGBO(19, 44, 74, 1);
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 20;

    final direccion = Path();

    //Dibujar con el path y el lapiz
    direccion.lineTo(0, size.height * 0.75);

    direccion.quadraticBezierTo(size.width * 0.27, size.height * 0.70,
        size.width * 0.5, size.height * 0.75);

    direccion.quadraticBezierTo(
        size.width * 0.75, size.height * 0.80, size.width, size.height * 0.75);

    direccion.lineTo(size.width, size.height * 0.06);

    direccion.quadraticBezierTo(
        size.width * 0.55, size.height * 0.14, size.width * 0.25, 0);

    canvas.drawPath(direccion, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class EncabezadoCircular extends StatelessWidget {
  const EncabezadoCircular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: _EncabezadoCircularPainter(),
      ),
    );
  }
}

class _EncabezadoCircularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint();

    //Propiedades
    lapiz.color = Colors.blue; //Color.fromRGBO(19, 44, 74, 1);
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 10;

    final direccion = Path();

    //Dibujar con el path y el lapiz
    direccion.lineTo(0, size.height * 0.80);

    direccion.quadraticBezierTo(
        size.width * 0.5, size.height * 0.90, size.width, size.height * 0.80);

    direccion.lineTo(size.width, size.height * 0.06);

    direccion.quadraticBezierTo(
        size.width * 0.55, size.height * 0.14, size.width * 0.25, 0);

    canvas.drawPath(direccion, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
