import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _PerfilesVacunacionrService {
  PerfilesVacunacion? _perfilesVacunacion;

  List<PerfilesVacunacion>? _listaPerfilesVacunacion;

  final StreamController<PerfilesVacunacion?>
      _perfilesVacunacionStreamController =
      StreamController<PerfilesVacunacion?>.broadcast();

  PerfilesVacunacion? get efectores => _perfilesVacunacion;

  bool get existeEfectores => (_perfilesVacunacion != null) ? true : false;

  Stream<PerfilesVacunacion?> get efectoresStream =>
      _perfilesVacunacionStreamController.stream;
  //Manejo de Listas

  final StreamController<List<PerfilesVacunacion?>>
      _listaPerfilesVacunacionStreamController =
      StreamController<List<PerfilesVacunacion?>>.broadcast();

  List<PerfilesVacunacion>? get listaPerfilesVacunacion =>
      _listaPerfilesVacunacion;

  bool get existelistaPerfilesVacunacion =>
      (_listaPerfilesVacunacion!.isNotEmpty) ? true : false;

  Stream<List<PerfilesVacunacion?>> get listaPerfilesVacunacionStream =>
      _listaPerfilesVacunacionStreamController.stream;

  void cargarEfectores(PerfilesVacunacion? perfiles) {
    _perfilesVacunacion = perfiles;
    _perfilesVacunacionStreamController.add(perfiles);
  }

  void cargarlistaPerfilesVacunacion(
      List<PerfilesVacunacion> listaPerfilesVacunacion) {
    _listaPerfilesVacunacion = listaPerfilesVacunacion;
    _listaPerfilesVacunacionStreamController.add(listaPerfilesVacunacion);
  }

  dispose() {
    _perfilesVacunacionStreamController.close();
    _listaPerfilesVacunacionStreamController.close();
  }
}

final perfilesVacunacionService = _PerfilesVacunacionrService();
