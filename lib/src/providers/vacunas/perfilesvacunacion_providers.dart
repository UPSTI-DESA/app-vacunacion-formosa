import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/services/services.dart';

class _PerfilesVacunacionProviders {
  Future<List<PerfilesVacunacion>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(resp.bodyBytes));
        final perfiles =
            PerfilesVacunacion.fromJsonList(decodedData['perfiles_vacunacion']);
        return perfiles.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  /// Siempre actualiza el servicio para que la UI no quede en carga infinita.
  Future<void> obtenerDatosPerfilesVacunacion(String? rela) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlPerfiVacu, queryParameters: {
      'rela_flxcore03': rela,
    });

    try {
      final List<PerfilesVacunacion> resp = await procesarRespuestaDos(url);
      if (resp.isEmpty) {
        perfilesVacunacionService.cargarlistaPerfilesVacunacion([]);
        return;
      }
      // Mismo criterio que en vacunas: codigo_mensaje "0" indica error del backend.
      if (resp.first.codigo_mensaje == '0') {
        final texto = resp.first.mensaje?.trim();
        perfilesVacunacionService.cargarlistaPerfilesVacunacion(
          [],
          mensajeSiListaVacia: (texto != null && texto.isNotEmpty)
              ? texto
              : 'No se pudieron obtener los perfiles de vacunaci\u00F3n.',
        );
        return;
      }
      perfilesVacunacionService.cargarlistaPerfilesVacunacion(resp);
    } catch (_) {
      perfilesVacunacionService.cargarlistaPerfilesVacunacion(
        [],
        mensajeSiListaVacia:
            'No se pudo conectar con el servidor. Revise su conexi\u00F3n e intente de nuevo.',
      );
    }
  }
}

final perfilesProviders = _PerfilesVacunacionProviders();
