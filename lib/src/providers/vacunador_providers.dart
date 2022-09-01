import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

class _VacunadorProviders {
  Future<List<Vacunador>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final vacunador = Vacunador.fromJsonList(decodedData['vacunador']);
        return vacunador.items;
      }
    } catch (e) {
      throw "Hubo un error $e";
    }

    throw 'Hubo un error global mas jodido';
  }

  Future validarVacunador(String? dni) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlVacunador, queryParameters: {
      'sysdesa06_nro_documento': dni,
    });

    final List<Vacunador> resp = await procesarRespuestaDos(url);
    if (resp[0].id_sysdesa12 != '') {
      //Si tiene Valores devuelve una Lista de Tipo Usuarios
      return resp;
    } else {
      //Si no tiene valores devuelve simplemente 0
      return resp;
    }
  }
}

final vacunadorProviders = _VacunadorProviders();
