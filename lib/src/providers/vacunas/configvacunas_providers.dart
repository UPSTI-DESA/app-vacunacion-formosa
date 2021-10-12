import 'dart:async';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

class _ConfiguracionVacunaProviders {
  Future<List<ConfiVacuna>> procesarRespuestaDos(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final vacunador =
          new ConfiVacuna.fromJsonList(decodedData['configuraciones']);
      return vacunador.items;
    }
    throw '';
  }

  Future validarConfiguraciones(String? idVacu) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/wserv_obtener_configuraciones_vacuna.php',
        queryParameters: {
          'id_sysvacu04': idVacu,
          'sysdesa10_edad': beneficiarioService.beneficiario!.sysdesa10_edad,
          'sysdesa10_dni': beneficiarioService.beneficiario!.sysdesa10_dni,
          'sysdesa10_sexo': beneficiarioService.beneficiario!.sysdesa10_sexo,
        });

    final List<ConfiVacuna> resp = await procesarRespuestaDos(url);
    return resp;
  }
}

final configuracionVacunaProvider = new _ConfiguracionVacunaProviders();
