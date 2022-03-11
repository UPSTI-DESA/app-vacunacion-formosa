// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/vacunas/vacunas_dosis_model.dart';
import 'dart:convert';

class _VacunasDosisProvider {
  Future<List<VacunasDosis>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final dosis = VacunasDosis.fromJsonList(decodedData['dosis_vacunas']);
        return dosis.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  Future obtenerDosisProviders(
      String id_sysvacu04, String id_sysvacu01, String id_sysvacu02) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlDosis, queryParameters: {
      'id_sysvacu04': id_sysvacu04,
      'id_sysvacu01': id_sysvacu01,
      'id_sysvacu02': id_sysvacu02,
    });

    final List<VacunasDosis> resp = await procesarRespuestaDos(url);
    if (resp[0].id_sysvacu05 != '') {
      return resp;
    } else {
      return 0;
    }
  }
}

final vacunasDosisProvider = _VacunasDosisProvider();
