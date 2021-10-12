import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sistema_vacunacion/src/models/models.dart';

class _LotesVacunaProviders {
  // ignore: missing_return
  Future<List<Lotes>> procesarRespuestaDos(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final lotes = new Lotes.fromJsonList(decodedData['lotes_vacunas']);
      return lotes.items;
    }
    throw '';
  }

  Future validarLotes(String? idVacu) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/wserv_obtener_lotes_vacunas.php',
        queryParameters: {
          'id_sysvacu04': idVacu,
        });

    final List<Lotes> resp = await procesarRespuestaDos(url);
    return resp;
  }
}

final lotesVacunaProvider = new _LotesVacunaProviders();
