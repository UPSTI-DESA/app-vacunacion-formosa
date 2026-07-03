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
    // ponytail: mutación in-place, misma referencia; el setter de Estado
    // compara por identidad y no notifica solo. Forzar notifyListeners().
    registroEstado.value!.fecha_aplicacion = fechaDeCarga.toString();
    registroEstado.notificar();
  }

  void reiniciar() {
    registroEstado.reiniciar();
  }
}

final insertRegistroService = _InsertRegistroService();
