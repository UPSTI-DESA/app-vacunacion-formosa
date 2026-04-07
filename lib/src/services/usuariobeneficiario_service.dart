import 'dart:async';

import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/tutor_service.dart';

class _BeneficiariorService {
  Beneficiario? _beneficiario;

  /// Edad en años leída del PDF417 del DNI al escanear (texto para UI y APIs).
  String? _edadAniosDesdePdf417Escaneado;
  String? _fechaNacimientoDesdePdf417Escaneado;

  // ignore: close_sinks
  final StreamController<Beneficiario?> _beneficiarioStreamController =
      StreamController<Beneficiario?>.broadcast();

  Beneficiario? get beneficiario => _beneficiario;

  String? get edadAniosDesdePdf417Escaneado => _edadAniosDesdePdf417Escaneado;

  String? get fechaNacimientoDesdePdf417Escaneado =>
      _fechaNacimientoDesdePdf417Escaneado;

  bool get existeBeneficiario => (_beneficiario != null) ? true : false;

  Stream<Beneficiario?> get beneficiarioStream =>
      _beneficiarioStreamController.stream;

  void cargarBeneficiario(
    Beneficiario? beneficiario, {
    String? edadAniosDesdePdf417Escaneado,
    String? fechaNacimientoDesdePdf417Escaneado,
  }) {
    // Un beneficiario nuevo no debe arrastrar tutor de otro registro en memoria.
    tutorService.eliminarTutor();
    _edadAniosDesdePdf417Escaneado = edadAniosDesdePdf417Escaneado;
    _fechaNacimientoDesdePdf417Escaneado = fechaNacimientoDesdePdf417Escaneado;
    _beneficiario = beneficiario;
    _beneficiarioStreamController.add(beneficiario);
  }

  void eliminarBeneficiario() {
    _beneficiario = null;
    _edadAniosDesdePdf417Escaneado = null;
    _fechaNacimientoDesdePdf417Escaneado = null;
    // El StreamController es de tipo Beneficiario? (nullable), por lo que
    // se agrega null directamente en lugar de forzar _beneficiario! que era null.
    _beneficiarioStreamController.add(null);
  }

  dispose() {
    _beneficiarioStreamController.close();
  }
}

final beneficiarioService = _BeneficiariorService();
