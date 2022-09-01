import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _InsertRegistroService {
  InsertRegistros? _registro;

  final StreamController<InsertRegistros> _registroStreamController =
      StreamController<InsertRegistros>.broadcast();

  InsertRegistros? get registro => _registro;

  bool get existeRegistro => (_registro != null) ? true : false;

  Stream<InsertRegistros> get registroStream =>
      _registroStreamController.stream;

  void cargarRegistro(InsertRegistros registro) {
    _registro = registro;
    _registroStreamController.add(registro);
  }

  void agregarFecha(DateTime fechaDeCarga) {
    _registro!.fecha_aplicacion = fechaDeCarga.toString();
    _registroStreamController.add(_registro!);
  }

  dispose() {
    _registroStreamController.close();
  }
}

final insertRegistroService = _InsertRegistroService();
