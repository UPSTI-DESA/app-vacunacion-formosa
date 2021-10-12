import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _CantidadVacunasService {
  CantidadVacunados? _cantidadVacunados;

  final StreamController<CantidadVacunados?>
      _cantidadVacunadosStreamController =
      StreamController<CantidadVacunados?>.broadcast();

  CantidadVacunados? get cantidadvacunados => _cantidadVacunados;

  bool get existeCantidadvacunados =>
      (_cantidadVacunados != null) ? true : false;

  Stream<CantidadVacunados?> get cantidadvacunadosStream =>
      _cantidadVacunadosStreamController.stream;

  void cargarCantidadVacunados(CantidadVacunados? cantidadVacunados) {
    _cantidadVacunados = cantidadVacunados;
    _cantidadVacunadosStreamController.add(cantidadVacunados);
  }

  dispose() {
    _cantidadVacunadosStreamController.close();
  }
}

final cantidadVacunasService = _CantidadVacunasService();
