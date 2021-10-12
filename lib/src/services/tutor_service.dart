import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _TutorService {
  Tutor? _tutor;

  // ignore: close_sinks
  StreamController<Tutor> _tutorStreamController =
      StreamController<Tutor>.broadcast();

  Tutor? get tutor => this._tutor;

  bool get existeTutor => (this._tutor != null) ? true : false;

  Stream<Tutor> get tutorStream => _tutorStreamController.stream;

  void cargarTutor(Tutor tutor) {
    this._tutor = tutor;
    this._tutorStreamController.add(tutor);
  }

  dispose() {
    this._tutorStreamController.close();
  }
}

final tutorService = _TutorService();
