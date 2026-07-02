import 'package:sistema_vacunacion/src/domain/entities/models.dart';

import 'estado.dart';

class _InsertRegistroService {
  final registroEstado = Estado<InsertRegistros?>(null);

  InsertRegistros? get registro => registroEstado.value;

  bool get existeRegistro => registroEstado.value != null;

  void cargarRegistro(InsertRegistros registro) {
    registroEstado.value = registro;
  }

  void agregarFecha(DateTime fechaDeCarga) {
    registroEstado.value = registroEstado.value!
      ..fecha_aplicacion = fechaDeCarga.toString();
  }

  void reiniciar() {
    registroEstado.reiniciar();
  }
}

final insertRegistroService = _InsertRegistroService();
