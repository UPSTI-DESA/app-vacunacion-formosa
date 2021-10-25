import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

class _CantidadVacunadosFecha {
  Future<List<CantidadVacunados>> procesarRespuestaDos(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final cantidadVacunas =
          CantidadVacunados.fromJsonList(decodedData['usuario']);
      return cantidadVacunas.items;
    }
    throw '';
  }

  Future cantidadVacunas() async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/wserv_cantidad_vacunas_registradas.php',
        queryParameters: {
          'id_sysdesa12': vacunadorService.vacunador!.id_sysdesa12,
          'vacunador_registrador':
              registradorService.registrador!.flxcore03_dni ==
                      vacunadorService.vacunador!.id_sysdesa12
                  ? '1'
                  : '0',
        });

    final List<CantidadVacunados> resp = await procesarRespuestaDos(url);
    return resp;
  }
}

final cantidadVacunadosProvider = _CantidadVacunadosFecha();
