import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/appconst_config.dart';

import 'dart:convert';

import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

class _ConfiguracionVacunaProviders {
  Future<List<ConfiVacuna>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final configuracionVacunas =
            ConfiVacuna.fromJsonList(decodedData['configuraciones']);
        return configuracionVacunas.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw Error();
  }

  Future validarConfiguraciones(String? idVacu) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlConfigVacu, queryParameters: {
      'id_sysvacu04': idVacu,
      'sysdesa10_edad': beneficiarioService.beneficiario!.sysdesa10_edad,
      'sysdesa10_dni': beneficiarioService.beneficiario!.sysdesa10_dni,
      'sysdesa10_sexo': beneficiarioService.beneficiario!.sysdesa10_sexo,
    });

    final List<ConfiVacuna> resp = await procesarRespuestaDos(url);
    if (resp.isNotEmpty) {
      return resp;
    } else {
      return resp;
    }
  }
}

final configuracionVacunaProvider = _ConfiguracionVacunaProviders();
