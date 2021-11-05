import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/services/services.dart';

class _VacunasxPerfiles {
  Future<List<VacunasxPerfil>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final vacunas =
            VacunasxPerfil.fromJsonList(decodedData['vacunas_configuradas']);
        return vacunas.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  //URL PARA PRODUCCIÓN: https://dh.formosa.gob.ar/modulos/webservice/php/version_2_0/wserv_obtener_vacunas_configuradas.php
  Future obtenerVacunasxPerfilesProviders(
      String? id, String? dni, String? sexo) async {
    final url = Uri(
        scheme: scheme,
        host: host,
        path: urlVacuxPerfiles,
        queryParameters: {
          'id_sysvacu12': id,
          'sysdesa10_dni': dni,
          'sysdesa10_sexo': sexo,
        });

    final List<VacunasxPerfil> resp = await procesarRespuestaDos(url);
    if (resp[0].id_sysvacu04 != '') {
      return vacunasxPerfilService.cargarListaVacunasxPerfil(resp);
    } else {
      return 0;
    }
  }
}

final vacunasxPerfiles = _VacunasxPerfiles();
