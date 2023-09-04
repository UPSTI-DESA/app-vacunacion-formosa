import 'package:flutter/material.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/pages/pruebas/insertDataBase.dart';

Route<dynamic> getRutas(RouteSettings settings) {
  switch (settings.name) {
    case LoginBody.nombreRuta:
      return _contruirRuta(settings, const LoginBody(), 2);

    case VacunadorPage.nombreRuta:
      return _contruirRuta(settings, const VacunadorPage(infoCargador: []), 2);

    case BusquedaBeneficiario.nombreRuta:
      return _contruirRuta(settings, const BusquedaBeneficiario(), 4);

    case BusquedaBeneficiarioOffline.nombreRuta:
      return _contruirRuta(settings, const BusquedaBeneficiarioOffline(), 4);

    case VacunasPage.nombreRuta:
      return _contruirRuta(settings, const VacunasPage(), 4);

    case VacunasPageOffline.nombreRuta:
      return _contruirRuta(settings, const VacunasPageOffline(), 4);

    case ConfirmarDatos.nombreRuta:
      return _contruirRuta(settings, const ConfirmarDatos(), 4);

    case PruebaInsert.nombreRuta:
      return _contruirRuta(settings, const PruebaInsert(), 4);

    default:
      return _contruirRuta(settings, const LoginBody(), 4);
  }
}

PageRouteBuilder _contruirRuta(
    RouteSettings settings, Widget builder, int animacion) {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          builder,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation =
            CurvedAnimation(parent: animation, curve: Curves.easeInOut);

        switch (animacion) {
          case 2:
            return ScaleTransition(
                child: child,
                scale: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(curveAnimation));
          case 4:
            return FadeTransition(
                child: child,
                opacity: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(curveAnimation));
          default:
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0.5, 1.0), end: Offset.zero)
                      .animate(curveAnimation),
              child: child,
            );
        }
      },
      settings: settings);
}
