import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _CantidadVacunasService {
  CantidadVacunados? _cantidadVacunados;

  StreamController<CantidadVacunados?> _cantidadVacunadosStreamController =
      new StreamController<CantidadVacunados?>.broadcast();

  CantidadVacunados? get cantidadvacunados => this._cantidadVacunados;

  bool get existeCantidadvacunados =>
      (this._cantidadVacunados != null) ? true : false;

  Stream<CantidadVacunados?> get cantidadvacunadosStream =>
      _cantidadVacunadosStreamController.stream;

  void cargarCantidadVacunados(CantidadVacunados? cantidadVacunados) {
    this._cantidadVacunados = cantidadVacunados;
    this._cantidadVacunadosStreamController.add(cantidadVacunados);
  }

  dispose() {
    this._cantidadVacunadosStreamController.close();
  }
}

final cantidadVacunasService = new _CantidadVacunasService();
