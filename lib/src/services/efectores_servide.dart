import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _EfectoresrService {
  Efectores? _efectores;

  List<Efectores>? _listaEfectores;

  final StreamController<Efectores?> _efectoresStreamController =
      StreamController<Efectores?>.broadcast();

  Efectores? get efectores => _efectores;

  bool get existeEfectores => (_efectores != null) ? true : false;

  Stream<Efectores?> get efectoresStream => _efectoresStreamController.stream;
  //Manejo de Listas

  final StreamController<List<Efectores?>> _listaEfectoresStreamController =
      StreamController<List<Efectores?>>.broadcast();

  List<Efectores>? get listaEfectores => _listaEfectores;

  bool get existeListaEfectores => (_listaEfectores!.isNotEmpty) ? true : false;

  Stream<List<Efectores?>> get listaEfectoresStream =>
      _listaEfectoresStreamController.stream;

  void cargarEfectores(Efectores? efectores) {
    _efectores = efectores;
    _efectoresStreamController.add(efectores);
  }

  void cargarListaEfectores(List<Efectores> listaEfectores) {
    _listaEfectores = listaEfectores;
    _listaEfectoresStreamController.add(listaEfectores);
  }

  dispose() {
    _efectoresStreamController.close();
    _listaEfectoresStreamController.close();
  }
}

final efectoresService = _EfectoresrService();
