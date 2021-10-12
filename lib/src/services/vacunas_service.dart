import 'dart:async';
import 'package:sistema_vacunacion/src/models/models.dart';

class _VacunasService {
  InfoVacunas? _vacunas;

  // ignore: close_sinks
  final StreamController<InfoVacunas> _vacunasStreamController =
      StreamController<InfoVacunas>.broadcast();

  InfoVacunas? get vacunas => _vacunas;

  bool get existeVacunas => (_vacunas != null) ? true : false;

  Stream<InfoVacunas> get vacunasStream => _vacunasStreamController.stream;

  void cargarVacunador(InfoVacunas vacunador) {
    _vacunas = vacunador;
    _vacunasStreamController.add(vacunador);
  }

  dispose() {
    _vacunasStreamController.close();
  }
}

final vacunasService = _VacunasService();
