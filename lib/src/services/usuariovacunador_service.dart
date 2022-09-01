import 'dart:async';
import 'package:sistema_vacunacion/src/models/usuarios/usuariovacunador_models.dart';

class _VacunadorService {
  Vacunador? _vacunador;

  final StreamController<Vacunador?> _vacunadorStreamController =
      StreamController<Vacunador?>.broadcast();

  Vacunador? get vacunador => _vacunador;

  bool get existeVacunador => (_vacunador != null) ? true : false;

  Stream<Vacunador?> get vacunadorStream => _vacunadorStreamController.stream;

  int _enTerreno = 0;

  final StreamController<int> _esTerrenoStreamController =
      StreamController<int>.broadcast();

  Stream<int?> get esTerrenoStream => _esTerrenoStreamController.stream;

  void cargarTerreno(int esEnTerreno) {
    _enTerreno = esEnTerreno;
    _esTerrenoStreamController.add(_enTerreno);
  }

  void cargarVacunador(Vacunador? vacunador) {
    _vacunador = vacunador;
    _vacunadorStreamController.add(vacunador);
  }

  void eliminarVacunador() {
    _vacunador = null;
    _vacunadorStreamController.add(_vacunador!);
  }

  dispose() {
    _vacunadorStreamController.close();
    _esTerrenoStreamController.close();
  }
}

final vacunadorService = _VacunadorService();
