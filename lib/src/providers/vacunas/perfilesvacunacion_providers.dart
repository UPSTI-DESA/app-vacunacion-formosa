import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/services/services.dart';

class _PerfilesVacunacionProviders {
  Future<List<PerfilesVacunacion>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final perfiles =
            PerfilesVacunacion.fromJsonList(decodedData['perfiles_vacunacion']);
        return perfiles.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  Future obtenerDatosPerfilesVacunacion(String? rela) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/wserv_obtener_perfil_vacunacion.php',
        queryParameters: {
          'rela_flxcore03': rela,
        });

    final List<PerfilesVacunacion> resp = await procesarRespuestaDos(url);
    if (resp[0].codigo_mensaje != '0') {
      return perfilesVacunacionService.cargarlistaPerfilesVacunacion(resp);
    } else {
      return resp;
    }
  }
}

final perfilesProviders = _PerfilesVacunacionProviders();
