import 'dart:async';
import 'package:sistema_vacunacion/src/models/vacunas/vacunas_dosis_model.dart';

class _VacunasDosisService {
  VacunasDosis? _vacunasDosis;

  List<VacunasDosis>? _listaVacunasDosis = [];

  List<VacunasDosis>? _listaVacunasDosisBusqueda = [];

  final StreamController<VacunasDosis?> _vacunasDosisStreamController =
      StreamController<VacunasDosis?>.broadcast();

  VacunasDosis? get vacunasDosis => _vacunasDosis;

  bool get existeVacunasDosis => (_vacunasDosis != null) ? true : false;

  Stream<VacunasDosis?> get vacunasDosisStream =>
      _vacunasDosisStreamController.stream;

  void cargarVacunasDosis(VacunasDosis? dosis) {
    _vacunasDosis = dosis;
    _vacunasDosisStreamController.add(dosis);
  }

  //Manejo de Listas

  final StreamController<List<VacunasDosis?>>
      _listaVacunasDosisStreamController =
      StreamController<List<VacunasDosis?>>.broadcast();

  List<VacunasDosis>? get listaVacunasDosis => _listaVacunasDosis;

  bool get existelistaVacunasDosis =>
      (_listaVacunasDosis!.isNotEmpty) ? true : false;

  Stream<List<VacunasDosis?>> get listaVacunasDosisStream =>
      _listaVacunasDosisStreamController.stream;

  void cargarListaVacunasDosis(List<VacunasDosis> listaVacunasDosis) {
    _listaVacunasDosis = listaVacunasDosis;
    _listaVacunasDosisStreamController.add(listaVacunasDosis);
    _listaVacunasDosisBusquedaStreamController.add(listaVacunasDosis);
  }

  void eliminarListaVacunasDosis() {
    List<VacunasDosis> vacio = [];
    _listaVacunasDosis = vacio;
    _listaVacunasDosisStreamController.add(vacio);
  }

  //---------------------  Manejo de Busqueda --------------------------///

  final StreamController<List<VacunasDosis?>>
      _listaVacunasDosisBusquedaStreamController =
      StreamController<List<VacunasDosis?>>.broadcast();

  List<VacunasDosis>? get listaVacunasDosisBusqueda =>
      _listaVacunasDosisBusqueda;

  bool get existeBusquedaDosis =>
      (_listaVacunasDosisBusqueda!.isNotEmpty) ? true : false;

  Stream<List<VacunasDosis?>> get listaBusquedaStream =>
      _listaVacunasDosisBusquedaStreamController.stream;

  void buscarDosis(String busqueda) {
    List<VacunasDosis> busquedaVacunas = _listaVacunasDosis!
        .where((element) =>
            element.sysvacu05_nombre!.toUpperCase().contains(busqueda))
        .toList();
    _listaVacunasDosisBusqueda = busquedaVacunas;
    _listaVacunasDosisBusquedaStreamController.add(_listaVacunasDosisBusqueda!);
  }

  void eliminarBusqueda() {
    List<VacunasDosis> vacio = [];
    _listaVacunasDosisBusqueda = vacio;
    _listaVacunasDosisBusquedaStreamController.add(vacio);
  }

////------------------------------------------------------------------------------------///////

  dispose() {
    _listaVacunasDosisBusquedaStreamController.close();
    _vacunasDosisStreamController.close();
    _listaVacunasDosisStreamController.close();
  }
}

final vacunasDosisService = _VacunasDosisService();
