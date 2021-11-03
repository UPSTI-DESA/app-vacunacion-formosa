import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _RegistradorService {
  Usuarios? _registrador;

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

  //---------------- Editar el Efector de un Registrador ---------------------------//

  void editarEfectorUsuario(Efectores nuevoEfector) {
    _registrador!.rela_sysofic01 = nuevoEfector.relaSysofic01;
    _registrador!.sysofic01_descripcion = nuevoEfector.sysofic01Descripcion;
    _registradorStreamController.add(_registrador);
  }

  dispose() {
    _registradorStreamController.close();
  }
}

final registradorService = _RegistradorService();
