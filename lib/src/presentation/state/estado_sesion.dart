import 'estado.dart';

/// Estados que pertenecen al ciclo "por beneficiario": nacen y mueren con cada
/// persona atendida. Registrar acá cada Estado de ese ciclo (ver Fase 2).
final List<Estado> estadosPorBeneficiario = [];

/// Reinicia todo el ciclo corto de una. Se llama al iniciar un beneficiario nuevo.
void reiniciarCicloBeneficiario() {
  for (final e in estadosPorBeneficiario) {
    e.reiniciar();
  }
}
