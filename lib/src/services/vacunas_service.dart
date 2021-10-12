import 'dart:async';
import 'package:sistema_vacunacion/src/models/models.dart';

class _VacunasService {
  InfoVacunas? _vacunas;

  // ignore: close_sinks
  StreamController<InfoVacunas> _vacunasStreamController =
      new StreamController<InfoVacunas>.broadcast();

  InfoVacunas? get vacunas => this._vacunas;

  bool get existeVacunas => (this._vacunas != null) ? true : false;

  Stream<InfoVacunas> get vacunasStream => _vacunasStreamController.stream;

  void cargarVacunador(InfoVacunas vacunador) {
    this._vacunas = vacunador;
    this._vacunasStreamController.add(vacunador);
  }

  dispose() {
    this._vacunasStreamController.close();
  }
}

final vacunasService = new _VacunasService();
