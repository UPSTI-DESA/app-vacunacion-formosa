import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

//TODO:FALTA CAMBIAR
class _VacunasLotes {
  VacunasxPerfil? _vacunasxperfil;

  List<VacunasxPerfil>? _listavacunasxperfil = [];

  List<VacunasxPerfil>? _listavacunasxperfilBusqueda = [];

  final StreamController<VacunasxPerfil?> _vacunasxperfilStreamController =
      StreamController<VacunasxPerfil?>.broadcast();

  VacunasxPerfil? get vacunasxPerfil => _vacunasxperfil;

  bool get existeVacunasxPerfil => (_vacunasxperfil != null) ? true : false;

  Stream<VacunasxPerfil?> get efectoresStream =>
      _vacunasxperfilStreamController.stream;

  void cargarVacunasxPerfil(VacunasxPerfil? perfiles) {
    _vacunasxperfil = perfiles;
    _vacunasxperfilStreamController.add(perfiles);
  }

  //Manejo de Listas

  final StreamController<List<VacunasxPerfil?>>
      _listavacunasxperfilStreamController =
      StreamController<List<VacunasxPerfil?>>.broadcast();

  List<VacunasxPerfil>? get listavacunasxPerfil => _listavacunasxperfil;

  bool get existelistaVacunasxPerfiles =>
      (_listavacunasxperfil!.isNotEmpty) ? true : false;

  Stream<List<VacunasxPerfil?>> get listaVacunasxPerfilesStream =>
      _listavacunasxperfilStreamController.stream;

  void cargarListaVacunasxPerfil(List<VacunasxPerfil> listavacunasxPerfil) {
    _listavacunasxperfil = listavacunasxPerfil;
    _listavacunasxperfilStreamController.add(listavacunasxPerfil);
    _listavacunasxperfilBusquedaStreamController.add(listavacunasxPerfil);
  }

  void eliminarListaVacunasxPerfil() {
    List<VacunasxPerfil> vacio = [];
    _listavacunasxperfil = vacio;
    _listavacunasxperfilStreamController.add(vacio);
  }

  //---------------------  Manejo de Busqueda --------------------------///

  final StreamController<List<VacunasxPerfil?>>
      _listavacunasxperfilBusquedaStreamController =
      StreamController<List<VacunasxPerfil?>>.broadcast();

  List<VacunasxPerfil>? get listavacunasxPerfilBusqueda =>
      _listavacunasxperfilBusqueda;

  bool get existeBusquedaxPerfiles =>
      (_listavacunasxperfilBusqueda!.isNotEmpty) ? true : false;

  Stream<List<VacunasxPerfil?>> get listaBusquedaStream =>
      _listavacunasxperfilBusquedaStreamController.stream;

  void buscarVacuna(String busqueda) {
    List<VacunasxPerfil> busquedaVacunas = _listavacunasxperfil!
        .where((element) =>
            element.sysvacu04_nombre!.toUpperCase().contains(busqueda))
        .toList();
    _listavacunasxperfilBusqueda = busquedaVacunas;
    _listavacunasxperfilBusquedaStreamController
        .add(_listavacunasxperfilBusqueda!);
  }

  void eliminarBusqueda() {
    List<VacunasxPerfil> vacio = [];
    _listavacunasxperfilBusqueda = vacio;
    _listavacunasxperfilBusquedaStreamController.add(vacio);
  }

////------------------------------------------------------------------------------------///////

  dispose() {
    _listavacunasxperfilBusquedaStreamController.close();
    _vacunasxperfilStreamController.close();
    _listavacunasxperfilStreamController.close();
  }
}

final vacunasLotesService = _VacunasLotes();
