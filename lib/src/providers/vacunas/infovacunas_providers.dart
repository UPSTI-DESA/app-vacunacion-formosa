import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';

import 'dart:convert';

import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

class _InfoVacunasProviders {
  Future<List<InfoVacunas>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final informacion =
            InfoVacunas.fromJsonList(decodedData['vacunas_configuradas']);
        return informacion.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  // ignore: missing_return
  Future<List<InfoVacunas>> obtenerRespuestaVacunas(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final vacunas =
          InfoVacunas.fromJsonList(decodedData['vacunas_configuradas']);
      return vacunas.items;
    }
    throw '';
  }

  Future validarVacunas() async {
    final url =
        Uri(scheme: scheme, host: host, path: urlInfoVacu, queryParameters: {
      'sysdesa10_dni': beneficiarioService.beneficiario!.sysdesa10_dni,
      'sysdesa10_sexo': beneficiarioService.beneficiario!.sysdesa10_sexo,
    });

    final List<InfoVacunas> resp = await obtenerRespuestaVacunas(url);
    if (resp[0].id_sysvacu04 != '') {
      return resp;
    } else {
      return resp;
    }
  }
}

final infoVacunasProviers = _InfoVacunasProviders();
