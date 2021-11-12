import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _VacunasLotes {
  Lotes? _vacunasLotes;

  List<Lotes>? _listavacunaslotes = [];

  List<Lotes>? _listavacunaslotesBusqueda = [];

  final StreamController<Lotes?> _vacunasLotesStreamController =
      StreamController<Lotes?>.broadcast();

  Lotes? get vacunasLotes => _vacunasLotes;

  bool get existeVacunasLotes => (_vacunasLotes != null) ? true : false;

  Stream<Lotes?> get lotesStream => _vacunasLotesStreamController.stream;

  void cargarVacunasLotes(Lotes? lotes) {
    _vacunasLotes = lotes;
    _vacunasLotesStreamController.add(lotes);
  }

  //Manejo de Listas

  final StreamController<List<Lotes?>> _listavacunaslotesStreamController =
      StreamController<List<Lotes?>>.broadcast();

  List<Lotes>? get listavacunasLotes => _listavacunaslotes;

  bool get existelistaVacunasLotes =>
      (_listavacunaslotes!.isNotEmpty) ? true : false;

  Stream<List<Lotes?>> get listaVacunasLotesStream =>
      _listavacunaslotesStreamController.stream;

  void cargarListaVacunasLotes(List<Lotes> listavacunaslotes) {
    _listavacunaslotes = listavacunaslotes;
    _listavacunaslotesStreamController.add(listavacunaslotes);
    _listavacunaslotesBusquedaStreamController.add(listavacunaslotes);
  }

  void eliminarListaVacunasLotes() {
    List<Lotes> vacio = [];
    _listavacunaslotes = vacio;
    _listavacunaslotesStreamController.add(vacio);
  }

  //---------------------  Manejo de Busqueda --------------------------///

  final StreamController<List<Lotes?>>
      _listavacunaslotesBusquedaStreamController =
      StreamController<List<Lotes?>>.broadcast();

  List<Lotes>? get listavacunasLotesBusqueda => _listavacunaslotesBusqueda;

  bool get existeBusquedaxLotes =>
      (_listavacunaslotesBusqueda!.isNotEmpty) ? true : false;

  Stream<List<Lotes?>> get listaBusquedaLotesStream =>
      _listavacunaslotesBusquedaStreamController.stream;

  void buscarLotes(String lotes) {
    List<Lotes> busquedaLotes = _listavacunaslotes!
        .where(
            (element) => element.sysdesa18_lote!.toUpperCase().contains(lotes))
        .toList();
    _listavacunaslotesBusqueda = busquedaLotes;
    _listavacunaslotesBusquedaStreamController.add(_listavacunaslotesBusqueda!);
  }

  void eliminarBusquedaLotes() {
    List<Lotes> vacio = [];
    _listavacunaslotesBusqueda = vacio;
    _listavacunaslotesBusquedaStreamController.add(vacio);
  }

////------------------------------------------------------------------------------------///////

  dispose() {
    _listavacunaslotesBusquedaStreamController.close();
    _vacunasLotesStreamController.close();
    _listavacunaslotesStreamController.close();
  }
}

final vacunasLotesService = _VacunasLotes();
