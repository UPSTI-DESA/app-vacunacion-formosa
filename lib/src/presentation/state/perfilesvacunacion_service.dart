import 'package:sistema_vacunacion/src/domain/entities/models.dart';

import 'estado.dart';

class _PerfilesVacunacionrService {
  final perfilesVacunacionEstado = Estado<PerfilesVacunacion?>(null);
  final listaPerfilesVacunacionEstado = Estado<List<PerfilesVacunacion>>([]);

  /// Mensaje cuando la lista quedó vacía por error de API o sin datos (para la UI).
  final mensajeListaPerfilesVaciaEstado = Estado<String?>(null);

  PerfilesVacunacion? get efectores => perfilesVacunacionEstado.value;

  bool get existeEfectores => perfilesVacunacionEstado.value != null;

  List<PerfilesVacunacion> get listaPerfilesVacunacion =>
      listaPerfilesVacunacionEstado.value;

  String? get mensajeListaPerfilesVacia => mensajeListaPerfilesVaciaEstado.value;

  bool get existelistaPerfilesVacunacion =>
      listaPerfilesVacunacionEstado.value.isNotEmpty;

  void cargarPerfilesVacu(PerfilesVacunacion? perfiles) {
    perfilesVacunacionEstado.value = perfiles;
  }

  void cargarlistaPerfilesVacunacion(
    List<PerfilesVacunacion> listaPerfilesVacunacion, {
    String? mensajeSiListaVacia,
  }) {
    mensajeListaPerfilesVaciaEstado.value = listaPerfilesVacunacion.isEmpty
        ? mensajeSiListaVacia
        : null;
    listaPerfilesVacunacionEstado.value = listaPerfilesVacunacion;
  }

  void reiniciar() {
    perfilesVacunacionEstado.reiniciar();
    listaPerfilesVacunacionEstado.reiniciar();
    mensajeListaPerfilesVaciaEstado.reiniciar();
  }
}

final perfilesVacunacionService = _PerfilesVacunacionrService();
