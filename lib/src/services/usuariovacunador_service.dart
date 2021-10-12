import 'dart:async';
import 'package:sistema_vacunacion/src/models/usuarios/usuariovacunador_models.dart';

class _VacunadorService {
  Vacunador? _vacunador;

  // ignore: close_sinks
  StreamController<Vacunador?> _vacunadorStreamController =
      new StreamController<Vacunador?>.broadcast();

  Vacunador? get vacunador => this._vacunador;

  bool get existeVacunador => (this._vacunador != null) ? true : false;

  Stream<Vacunador?> get vacunadorStream => _vacunadorStreamController.stream;

  void cargarVacunador(Vacunador? vacunador) {
    this._vacunador = vacunador;
    this._vacunadorStreamController.add(vacunador);
  }

  dispose() {
    this._vacunadorStreamController.close();
  }
}

final vacunadorService = new _VacunadorService();
