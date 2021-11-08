import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _BeneficiariorService {
  Beneficiario? _beneficiario;

  // ignore: close_sinks
  final StreamController<Beneficiario?> _beneficiarioStreamController =
      StreamController<Beneficiario?>.broadcast();

  Beneficiario? get beneficiario => _beneficiario;

  bool get existeBeneficiario => (_beneficiario != null) ? true : false;

  Stream<Beneficiario?> get beneficiarioStream =>
      _beneficiarioStreamController.stream;

  void cargarBeneficiario(Beneficiario? beneficiario) {
    _beneficiario = beneficiario;
    _beneficiarioStreamController.add(beneficiario);
  }

  void eliminarBeneficiario() {
    _beneficiario = null;
    _beneficiarioStreamController.add(_beneficiario!);
  }

  dispose() {
    _beneficiarioStreamController.close();
  }
}

final beneficiarioService = _BeneficiariorService();
