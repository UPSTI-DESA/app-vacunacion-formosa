import 'dart:async';

import 'package:sistema_vacunacion/src/domain/entities/models.dart';

class _TutorService {
  Tutor? _tutor;

  // ignore: close_sinks
  final StreamController<Tutor?> _tutorStreamController =
      StreamController<Tutor?>.broadcast();

  Tutor? get tutor => _tutor;

  /// Solo cuenta si hay documento: un [Tutor] vacío no debe bloquear el alta de tutor.
  bool get existeTutor {
    final t = _tutor;
    if (t == null) return false;
    final dni = t.sysdesa10_dni_tutor?.trim() ?? '';
    return dni.isNotEmpty;
  }

  Stream<Tutor?> get tutorStream => _tutorStreamController.stream;

  void cargarTutor(Tutor tutor) {
    _tutor = tutor;
    _tutorStreamController.add(tutor);
  }

  void eliminarTutor() {
    _tutor = null;
    _tutorStreamController.add(null);
  }

  dispose() {
    _tutorStreamController.close();
  }
}

final tutorService = _TutorService();
