import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';

class _BeneficiariorService {
  Beneficiario? _beneficiario;

  // ignore: close_sinks
  StreamController<Beneficiario?> _beneficiarioStreamController =
      StreamController<Beneficiario?>.broadcast();

  Beneficiario? get beneficiario => this._beneficiario;

  bool get existeBeneficiario => (this._beneficiario != null) ? true : false;

  Stream<Beneficiario?> get beneficiarioStream =>
      _beneficiarioStreamController.stream;

  void cargarBeneficiario(Beneficiario? beneficiario) {
    this._beneficiario = beneficiario;
    this._beneficiarioStreamController.add(beneficiario);
  }

  dispose() {
    this._beneficiarioStreamController.close();
  }
}

final beneficiarioService = _BeneficiariorService();
