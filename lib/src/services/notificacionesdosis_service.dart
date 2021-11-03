import 'dart:async';

import 'package:sistema_vacunacion/src/models/sistema/notificacionesdosis_models.dart';

class _NotificacionesDosisService {
  NotificacionesDosis? _notiDosis;

  final StreamController<NotificacionesDosis?> _notiDosisStreamController =
      StreamController<NotificacionesDosis?>.broadcast();

  NotificacionesDosis? get dosis => _notiDosis;

  bool get existeDosis => (_notiDosis != null) ? true : false;

  Stream<NotificacionesDosis?> get dosisStream =>
      _notiDosisStreamController.stream;

  void cargarRegistro(NotificacionesDosis? dosis) {
    _notiDosis = dosis;
    _notiDosisStreamController.add(dosis);
  }
  // ----------------------- Manejo de Listas de Notificaciones ---------------------- //

  List<NotificacionesDosis> _listaDosisAplicadas = [];

  final StreamController<List<NotificacionesDosis>?>
      _listaDosisAplicadasStreamController =
      StreamController<List<NotificacionesDosis>?>.broadcast();

  List<NotificacionesDosis> get listaDosisAplicadas => _listaDosisAplicadas;

  Stream<List<NotificacionesDosis>?> get listaDosisAplicadasStream =>
      _listaDosisAplicadasStreamController.stream;

  void cargarListaDosis(List<NotificacionesDosis> dosisAplicadas) {
    _listaDosisAplicadas = dosisAplicadas;
    _listaDosisAplicadasStreamController.add(dosisAplicadas);
  }

  void eliminarListaDosis() {
    _listaDosisAplicadas = [];
    _listaDosisAplicadasStreamController.add(_listaDosisAplicadas);
  }

  dispose() {
    _notiDosisStreamController.close();
    _listaDosisAplicadasStreamController.close();
  }
}

final notificacionesDosisService = _NotificacionesDosisService();
