// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/vacunas/vacunas_condicion_model.dart';
import 'dart:convert';
import 'package:sistema_vacunacion/src/services/vacunas_condicion_service.dart';

class _VacunasCondicion {
  Future<List<VacunasCondicion>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final condicion =
            VacunasCondicion.fromJsonList(decodedData['condicion_vacunas']);
        return condicion.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  Future obtenerCondicionesProviders(
      String? sysvacu04, String? sysdesa10_edad) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlCondicion, queryParameters: {
      'id_sysvacu04': sysvacu04,
      'sysdesa10_edad': sysdesa10_edad,
    });

    final List<VacunasCondicion> resp = await procesarRespuestaDos(url);
    if (resp[0].id_sysvacu01 != '') {
      return resp;
    } else {
      return 0;
    }
  }
}

final vacunasCondicion = _VacunasCondicion();
