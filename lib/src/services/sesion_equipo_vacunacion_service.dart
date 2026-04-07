/// Preferencias de la sesión de vacunación definidas en «Equipo de trabajo»
/// (p. ej. si la aplicación es en terreno). Persisten hasta cerrar sesión.
class _SesionEquipoVacunacionService {
  /// `true` = vacunación en terreno; `false` = en establecimiento fijo.
  bool _enTerreno = true;

  bool get enTerreno => _enTerreno;

  void establecerEnTerreno(bool valor) {
    _enTerreno = valor;
  }

  /// Vuelve valores por defecto al salir de la cuenta.
  void reiniciar() {
    _enTerreno = true;
  }
}

final sesionEquipoVacunacionService = _SesionEquipoVacunacionService();
