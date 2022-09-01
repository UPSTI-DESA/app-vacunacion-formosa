import 'dart:async';
import 'package:sistema_vacunacion/src/models/vacunas/vacunas_condicion_model.dart';

class _VacunasCondicionService {
  VacunasCondicion? _vacunasCondicion;

  List<VacunasCondicion>? _listaVacunasCondicion = [];

  List<VacunasCondicion>? _listaVacunasCondicionBusqueda = [];

  final StreamController<VacunasCondicion?> _vacunasCondicionStreamController =
      StreamController<VacunasCondicion?>.broadcast();

  VacunasCondicion? get vacunasCondicion => _vacunasCondicion;

  bool get existeVacunasCondicion => (_vacunasCondicion != null) ? true : false;

  Stream<VacunasCondicion?> get vacunasCondicionStream =>
      _vacunasCondicionStreamController.stream;

  void cargarVacunasCondicion(VacunasCondicion? condicion) {
    _vacunasCondicion = condicion;
    _vacunasCondicionStreamController.add(condicion);
  }

  //Manejo de Listas

  final StreamController<List<VacunasCondicion?>>
      _listaVacunasCondicionStreamController =
      StreamController<List<VacunasCondicion?>>.broadcast();

  List<VacunasCondicion>? get listaVacunasCondicion => _listaVacunasCondicion;

  bool get existelistaVacunasCondicion =>
      (_listaVacunasCondicion!.isNotEmpty) ? true : false;

  Stream<List<VacunasCondicion?>> get listaVacunasCondicionesStream =>
      _listaVacunasCondicionStreamController.stream;

  void cargarListaVacunasCondicion(
      List<VacunasCondicion> listaVacunasCondicion) {
    _listaVacunasCondicion = listaVacunasCondicion;
    _listaVacunasCondicionStreamController.add(listaVacunasCondicion);
    _listaVacunasCondicionBusquedaStreamController.add(listaVacunasCondicion);
  }

  void eliminarListaVacunasCondicion() {
    List<VacunasCondicion> vacio = [];
    _listaVacunasCondicion = vacio;
    _listaVacunasCondicionStreamController.add(vacio);
  }

  //---------------------  Manejo de Busqueda --------------------------///

  final StreamController<List<VacunasCondicion?>>
      _listaVacunasCondicionBusquedaStreamController =
      StreamController<List<VacunasCondicion?>>.broadcast();

  List<VacunasCondicion>? get listaVacunasCondicionBusqueda =>
      _listaVacunasCondicionBusqueda;

  bool get existeBusquedaCondicion =>
      (_listaVacunasCondicionBusqueda!.isNotEmpty) ? true : false;

  Stream<List<VacunasCondicion?>> get listaBusquedaStream =>
      _listaVacunasCondicionBusquedaStreamController.stream;

  void buscarCondicion(String busqueda) {
    List<VacunasCondicion> busquedaVacunas = _listaVacunasCondicion!
        .where((element) =>
            element.sysvacu01_descripcion!.toUpperCase().contains(busqueda))
        .toList();
    _listaVacunasCondicionBusqueda = busquedaVacunas;
    _listaVacunasCondicionBusquedaStreamController
        .add(_listaVacunasCondicionBusqueda!);
  }

  void eliminarBusqueda() {
    List<VacunasCondicion> vacio = [];
    _listaVacunasCondicionBusqueda = vacio;
    _listaVacunasCondicionBusquedaStreamController.add(vacio);
  }

////------------------------------------------------------------------------------------///////

  dispose() {
    _listaVacunasCondicionBusquedaStreamController.close();
    _vacunasCondicionStreamController.close();
    _listaVacunasCondicionStreamController.close();
  }
}

final vacunasCondicionService = _VacunasCondicionService();
