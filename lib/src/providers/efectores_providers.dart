import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/services/efectores_servide.dart';

class _EfectorsProviders {
  Future<List<Efectores>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final efectores = Efectores.fromJsonList(decodedData['usuario']);
        return efectores.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  Future obtenerDatosEfectores(String? dni) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/wserv_efector_registrador.php',
        queryParameters: {
          'flxcore03_dni': dni,
        });

    final List<Efectores> resp = await procesarRespuestaDos(url);
    if (resp[0].flxcore03Dni != '') {
      return efectoresService.cargarListaEfectores(resp);
    } else {
      return 0;
    }
  }
}

final efectoresProviders = _EfectorsProviders();
