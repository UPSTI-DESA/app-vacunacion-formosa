import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

class _VacunadorProviders {
  // ignore: missing_return
  Future<List<Vacunador>> procesarRespuestaDos(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final vacunador = Vacunador.fromJsonList(decodedData['vacunador']);
      return vacunador.items;
    }
    throw '';
  }

  Future validarVacunador(String? dni) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path: '/modulos/webservice/php/wserv_vacunador.php',
        queryParameters: {
          'sysdesa06_nro_documento': dni,
        });

    final List<Vacunador> resp = await procesarRespuestaDos(url);
    if (resp[0].id_sysdesa12 != '') {
      //Si tiene Valores devuelve una Lista de Tipo Usuarios
      return resp;
    } else {
      //Si no tiene valores devuelve simplemente 0
      return 0;
    }
  }
}

final vacunadorProviders = _VacunadorProviders();
