import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _CantidadVacunadosService {
  CantidadVacunados? cantidadVacunadosState;

  StreamController<CantidadVacunados> _cantidadVacunadosStateStreamController =
      StreamController<CantidadVacunados>.broadcast();

  CantidadVacunados? get getCantidadVacunadosState =>
      this.cantidadVacunadosState;

  Stream<CantidadVacunados> get cantidadVacunadosStateStream =>
      _cantidadVacunadosStateStreamController.stream;

  void cargarEnviroment(CantidadVacunados enviroment) {
    this.cantidadVacunadosState = enviroment;

    this._cantidadVacunadosStateStreamController.add(enviroment);
  }

  dispose() {
    this._cantidadVacunadosStateStreamController.close();
  }
}

final appStateService = _CantidadVacunadosService();
