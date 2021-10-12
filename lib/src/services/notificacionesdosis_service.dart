import 'dart:async';

import 'package:sistema_vacunacion/src/models/sistema/notificacionesdosis_models.dart';

class _NotificacionesDosisService {
  NotificacionesDosis? _notiDosis;

  // AnimationController _bounceController;

  // ignore: close_sinks
  StreamController<NotificacionesDosis?> _notiDosisStreamController =
      new StreamController<NotificacionesDosis?>.broadcast();

  NotificacionesDosis? get dosis => this._notiDosis;

  bool get existeDosis => (this._notiDosis != null) ? true : false;

  Stream<NotificacionesDosis?> get dosisStream =>
      _notiDosisStreamController.stream;

  void cargarRegistro(NotificacionesDosis? dosis) {
    this._notiDosis = dosis;
    this._notiDosisStreamController.add(dosis);
  }

  dispose() {
    this._notiDosisStreamController.close();
  }
}

final notificacionesDosisService = new _NotificacionesDosisService();
