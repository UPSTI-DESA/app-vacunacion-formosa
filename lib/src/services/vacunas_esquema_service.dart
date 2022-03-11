import 'dart:async';
import 'package:sistema_vacunacion/src/models/vacunas/vacunas_esquema_model.dart';
import 'package:sistema_vacunacion/src/models/vacunas/vacunas_esquema_model.dart';

class _VacunasEsquemaService {
  VacunasEsquema? _vacunasEsquema;

  List<VacunasEsquema>? _listaVacunasEsquema = [];

  List<VacunasEsquema>? _listaVacunasEsquemaBusqueda = [];

  final StreamController<VacunasEsquema?> _vacunasEsquemaStreamController =
      StreamController<VacunasEsquema?>.broadcast();

  VacunasEsquema? get vacunasEsquema => _vacunasEsquema;

  bool get existevacunasEsquema => (_vacunasEsquema != null) ? true : false;

  Stream<VacunasEsquema?> get vacunasEsquemaStream =>
      _vacunasEsquemaStreamController.stream;

  void cargarvacunasEsquema(VacunasEsquema? esquema) {
    _vacunasEsquema = esquema;
    _vacunasEsquemaStreamController.add(esquema);
  }

  //Manejo de Listas

  final StreamController<List<VacunasEsquema?>>
      _listaVacunasEsquemaStreamController =
      StreamController<List<VacunasEsquema?>>.broadcast();

  List<VacunasEsquema>? get listavacunasEsquema => _listaVacunasEsquema;

  bool get existelistavacunasEsquema =>
      (_listaVacunasEsquema!.isNotEmpty) ? true : false;

  Stream<List<VacunasEsquema?>> get listavacunasEsquemaesStream =>
      _listaVacunasEsquemaStreamController.stream;

  void cargarListavacunasEsquema(List<VacunasEsquema> listavacunasEsquema) {
    _listaVacunasEsquema = listavacunasEsquema;
    _listaVacunasEsquemaStreamController.add(listavacunasEsquema);
    _listaVacunasEsquemaBusquedaStreamController.add(listavacunasEsquema);
  }

  void eliminarListavacunasEsquema() {
    List<VacunasEsquema> vacio = [];
    _listaVacunasEsquema = vacio;
    _listaVacunasEsquemaStreamController.add(vacio);
  }

  //---------------------  Manejo de Busqueda --------------------------///

  final StreamController<List<VacunasEsquema?>>
      _listaVacunasEsquemaBusquedaStreamController =
      StreamController<List<VacunasEsquema?>>.broadcast();

  List<VacunasEsquema>? get listavacunasEsquemaBusqueda =>
      _listaVacunasEsquemaBusqueda;

  bool get existeBusquedaesquema =>
      (_listaVacunasEsquemaBusqueda!.isNotEmpty) ? true : false;

  Stream<List<VacunasEsquema?>> get listaBusquedaStream =>
      _listaVacunasEsquemaBusquedaStreamController.stream;

  void buscaresquema(String busqueda) {
    List<VacunasEsquema> busquedaVacunas = _listaVacunasEsquema!
        .where((element) =>
            element.sysvacu02_descripcion!.toUpperCase().contains(busqueda))
        .toList();
    _listaVacunasEsquemaBusqueda = busquedaVacunas;
    _listaVacunasEsquemaBusquedaStreamController
        .add(_listaVacunasEsquemaBusqueda!);
  }

  void eliminarBusqueda() {
    List<VacunasEsquema> vacio = [];
    _listaVacunasEsquemaBusqueda = vacio;
    _listaVacunasEsquemaBusquedaStreamController.add(vacio);
  }

////------------------------------------------------------------------------------------///////

  dispose() {
    _listaVacunasEsquemaBusquedaStreamController.close();
    _vacunasEsquemaStreamController.close();
    _listaVacunasEsquemaStreamController.close();
  }
}

final vacunasEsquemaService = _VacunasEsquemaService();
