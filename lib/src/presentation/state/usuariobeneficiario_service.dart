import 'package:sistema_vacunacion/src/domain/entities/models.dart';
import 'package:sistema_vacunacion/src/presentation/state/tutor_service.dart';

import 'estado.dart';

class _BeneficiariorService {
  final beneficiarioEstado = Estado<Beneficiario?>(null);

  /// Edad en años leída del PDF417 del DNI al escanear (texto para UI y APIs).
  final edadEstado = Estado<String?>(null);
  final fechaNacEstado = Estado<String?>(null);

  Beneficiario? get beneficiario => beneficiarioEstado.value;

  String? get edadAniosDesdePdf417Escaneado => edadEstado.value;

  String? get fechaNacimientoDesdePdf417Escaneado => fechaNacEstado.value;

  bool get existeBeneficiario => beneficiarioEstado.value != null;

  void cargarBeneficiario(
    Beneficiario? beneficiario, {
    String? edadAniosDesdePdf417Escaneado,
    String? fechaNacimientoDesdePdf417Escaneado,
  }) {
    // Un beneficiario nuevo no debe arrastrar tutor de otro registro en memoria.
    tutorService.reiniciar();
    edadEstado.value = edadAniosDesdePdf417Escaneado;
    fechaNacEstado.value = fechaNacimientoDesdePdf417Escaneado;
    beneficiarioEstado.value = beneficiario;
  }

  void reiniciar() {
    beneficiarioEstado.reiniciar();
    edadEstado.reiniciar();
    fechaNacEstado.reiniciar();
  }
}

final beneficiarioService = _BeneficiariorService();
