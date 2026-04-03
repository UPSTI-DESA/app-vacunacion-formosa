import 'package:flutter/material.dart';

class EncabezadoWave extends StatelessWidget {
  const EncabezadoWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final color = cs.primary.withValues(alpha: oscuro ? 0.32 : 0.22);
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoWavePainter(color),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoWavePainter(color),
          ),
        ),
      ],
    );
  }
}

class _EncabezadoWavePainter extends CustomPainter {
  _EncabezadoWavePainter(this.fillColor);

  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;

    final direccion = Path();

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
  bool shouldRepaint(covariant _EncabezadoWavePainter oldDelegate) =>
      oldDelegate.fillColor != fillColor;
}

class EncabezadoDos extends StatelessWidget {
  const EncabezadoDos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final color = cs.primary.withValues(alpha: oscuro ? 0.48 : 0.55);
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoDosPainter(color),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.49,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoDosPainter(color),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoDosPainter(color),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.47,
          width: MediaQuery.of(context).size.width,
          child: CustomPaint(
            painter: _EncabezadoDosPainter(color),
          ),
        ),
      ],
    );
  }
}

class _EncabezadoDosPainter extends CustomPainter {
  _EncabezadoDosPainter(this.fillColor);

  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 20;

    final direccion = Path();

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
  bool shouldRepaint(covariant _EncabezadoDosPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor;
}

class EncabezadoCircular extends StatelessWidget {
  const EncabezadoCircular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context)
        .colorScheme
        .primary
        .withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.45);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: _EncabezadoCircularPainter(color),
      ),
    );
  }
}

class _EncabezadoCircularPainter extends CustomPainter {
  _EncabezadoCircularPainter(this.fillColor);

  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;

    final direccion = Path();

    direccion.lineTo(0, size.height * 0.80);

    direccion.quadraticBezierTo(
        size.width * 0.5, size.height * 0.90, size.width, size.height * 0.80);

    direccion.lineTo(size.width, size.height * 0.06);

    direccion.quadraticBezierTo(
        size.width * 0.55, size.height * 0.14, size.width * 0.25, 0);

    canvas.drawPath(direccion, lapiz);
  }

  @override
  bool shouldRepaint(covariant _EncabezadoCircularPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor;
}
