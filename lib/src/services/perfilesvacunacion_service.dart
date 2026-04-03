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

  /// Mensaje cuando la lista quedó vacía por error de API o sin datos (para la UI).
  String? _mensajeListaPerfilesVacia;

  String? get mensajeListaPerfilesVacia => _mensajeListaPerfilesVacia;

  bool get existelistaPerfilesVacunacion =>
      (_listaPerfilesVacunacion!.isNotEmpty) ? true : false;

  Stream<List<PerfilesVacunacion?>> get listaPerfilesVacunacionStream =>
      _listaPerfilesVacunacionStreamController.stream;

  void cargarPerfilesVacu(PerfilesVacunacion? perfiles) {
    _perfilesVacunacion = perfiles;
    _perfilesVacunacionStreamController.add(perfiles);
  }

  void cargarlistaPerfilesVacunacion(
    List<PerfilesVacunacion> listaPerfilesVacunacion, {
    String? mensajeSiListaVacia,
  }) {
    _listaPerfilesVacunacion = listaPerfilesVacunacion;
    _mensajeListaPerfilesVacia = listaPerfilesVacunacion.isEmpty
        ? mensajeSiListaVacia
        : null;
    _listaPerfilesVacunacionStreamController.add(listaPerfilesVacunacion);
  }

  void eliminarListaPerfiles() {
    List<PerfilesVacunacion> vacio = [];
    _listaPerfilesVacunacion = vacio;
    _mensajeListaPerfilesVacia = null;
    _listaPerfilesVacunacionStreamController.add(vacio);
  }

  dispose() {
    _perfilesVacunacionStreamController.close();
    _listaPerfilesVacunacionStreamController.close();
  }
}

final perfilesVacunacionService = _PerfilesVacunacionrService();
