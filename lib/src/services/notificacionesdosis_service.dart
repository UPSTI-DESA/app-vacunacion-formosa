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

  dispose() {
    _notiDosisStreamController.close();
  }
}

final notificacionesDosisService = _NotificacionesDosisService();
