import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _TutorService {
  Tutor? _tutor;

  // ignore: close_sinks
  final StreamController<Tutor> _tutorStreamController =
      StreamController<Tutor>.broadcast();

  Tutor? get tutor => _tutor;

  bool get existeTutor => (_tutor != null) ? true : false;

  Stream<Tutor> get tutorStream => _tutorStreamController.stream;

  void cargarTutor(Tutor tutor) {
    _tutor = tutor;
    _tutorStreamController.add(tutor);
  }

  void eliminarTutor() {
    _tutor = null;

    _tutorStreamController.add(_tutor!);
  }

  dispose() {
    _tutorStreamController.close();
  }
}

final tutorService = _TutorService();
