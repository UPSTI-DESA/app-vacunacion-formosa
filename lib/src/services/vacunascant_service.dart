import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _CantidadVacunadosService {
  CantidadVacunados? cantidadVacunadosState;

  final StreamController<CantidadVacunados>
      _cantidadVacunadosStateStreamController =
      StreamController<CantidadVacunados>.broadcast();

  CantidadVacunados? get getCantidadVacunadosState => cantidadVacunadosState;

  Stream<CantidadVacunados> get cantidadVacunadosStateStream =>
      _cantidadVacunadosStateStreamController.stream;

  void cargarEnviroment(CantidadVacunados enviroment) {
    cantidadVacunadosState = enviroment;

    _cantidadVacunadosStateStreamController.add(enviroment);
  }

  dispose() {
    _cantidadVacunadosStateStreamController.close();
  }
}

final appStateService = _CantidadVacunadosService();
