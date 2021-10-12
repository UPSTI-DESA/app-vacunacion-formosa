import 'dart:async';
import 'package:sistema_vacunacion/src/models/usuarios/usuariovacunador_models.dart';

class _VacunadorService {
  Vacunador? _vacunador;

  final StreamController<Vacunador?> _vacunadorStreamController =
      StreamController<Vacunador?>.broadcast();

  Vacunador? get vacunador => _vacunador;

  bool get existeVacunador => (_vacunador != null) ? true : false;

  Stream<Vacunador?> get vacunadorStream => _vacunadorStreamController.stream;

  void cargarVacunador(Vacunador? vacunador) {
    _vacunador = vacunador;
    _vacunadorStreamController.add(vacunador);
  }

  dispose() {
    _vacunadorStreamController.close();
  }
}

final vacunadorService = _VacunadorService();
