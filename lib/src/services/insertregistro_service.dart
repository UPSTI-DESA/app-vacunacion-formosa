import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _InsertRegistroService {
  InsertRegistros? _registro;

  // ignore: close_sinks
  StreamController<InsertRegistros> _registroStreamController =
      new StreamController<InsertRegistros>.broadcast();

  InsertRegistros? get registro => this._registro;

  bool get existeRegistro => (this._registro != null) ? true : false;

  Stream<InsertRegistros> get registroStream =>
      _registroStreamController.stream;

  void cargarRegistro(InsertRegistros registro) {
    this._registro = registro;
    this._registroStreamController.add(registro);
  }

  dispose() {
    this._registroStreamController.close();
  }
}

final insertRegistroService = new _InsertRegistroService();
