import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _VacunasporPerfiles {
  VacunasxPerfil? _vacunasxperfil;

  List<VacunasxPerfil>? _listavacunasxperfil;

  final StreamController<VacunasxPerfil?> _vacunasxperfilStreamController =
      StreamController<VacunasxPerfil?>.broadcast();

  VacunasxPerfil? get vacunasxPerfil => _vacunasxperfil;

  bool get existeVacunasxPerfil => (_vacunasxperfil != null) ? true : false;

  Stream<VacunasxPerfil?> get efectoresStream =>
      _vacunasxperfilStreamController.stream;
  //Manejo de Listas

  final StreamController<List<VacunasxPerfil?>>
      _listavacunasxperfilStreamController =
      StreamController<List<VacunasxPerfil?>>.broadcast();

  List<VacunasxPerfil>? get listavacunasxPerfil => _listavacunasxperfil;

  bool get existelistaVacunasxPerfiles =>
      (_listavacunasxperfil!.isNotEmpty) ? true : false;

  Stream<List<VacunasxPerfil?>> get listaVacunasxPerfilesStream =>
      _listavacunasxperfilStreamController.stream;

  void cargarVacunasxPerfil(VacunasxPerfil? perfiles) {
    _vacunasxperfil = perfiles;
    _vacunasxperfilStreamController.add(perfiles);
  }

  void cargarListaVacunasxPerfil(List<VacunasxPerfil> listavacunasxPerfil) {
    _listavacunasxperfil = listavacunasxPerfil;
    _listavacunasxperfilStreamController.add(listavacunasxPerfil);
  }

  dispose() {
    _vacunasxperfilStreamController.close();
    _listavacunasxperfilStreamController.close();
  }
}

final vacunasxPerfilService = _VacunasporPerfiles();
