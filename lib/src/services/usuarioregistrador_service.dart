import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _RegistradorService {
  Usuarios? _registrador;

  // ignore: close_sinks
  final StreamController<Usuarios?> _registradorStreamController =
      StreamController<Usuarios?>.broadcast();

  Usuarios? get registrador => _registrador;

  bool get existeRegistrador => (_registrador != null) ? true : false;

  Stream<Usuarios?> get registradorStream =>
      _registradorStreamController.stream;

  void cargarRegistrador(Usuarios? registrador) {
    _registrador = registrador;
    _registradorStreamController.add(registrador);
  }

  dispose() {
    _registradorStreamController.close();
  }
}

final registradorService = _RegistradorService();
