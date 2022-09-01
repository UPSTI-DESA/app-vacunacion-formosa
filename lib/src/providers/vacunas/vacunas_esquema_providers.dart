// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/models/vacunas/vacunas_esquema_model.dart';

class _VacunasEsquemaProvider {
  Future<List<VacunasEsquema>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final esquemas =
            VacunasEsquema.fromJsonList(decodedData['esquema_vacunas']);
        return esquemas.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  Future obtenerEsquemasProviders(
      String? id_sysvacu04, String? id_sysvacu01) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlEsquema, queryParameters: {
      'id_sysvacu04': id_sysvacu04,
      'id_sysvacu01': id_sysvacu01,
    });

    final List<VacunasEsquema> resp = await procesarRespuestaDos(url);
    if (resp[0].id_sysvacu02 != '') {
      return resp;
    } else {
      return resp;
    }
  }
}

final vacunasEsquemaProvider = _VacunasEsquemaProvider();
