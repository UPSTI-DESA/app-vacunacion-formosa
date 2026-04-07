import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';
import 'package:sistema_vacunacion/src/utils/encoding_utils.dart';

class _VacunadorProviders {
  Future<List<Vacunador>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url).timeout(const Duration(seconds: 30));
      if (resp.statusCode == 200) {
        final decodedData = json.decode(decodificarRespuestaHTTP(resp.bodyBytes));
        final vacunador = Vacunador.fromJsonList(decodedData['vacunador']);
        return vacunador.items;
      }
    } catch (e) {
      throw "Hubo un error $e";
    }

    throw 'Hubo un error';
  }

  Future validarVacunador(String? dni) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlVacunador, queryParameters: {
      'sysdesa06_nro_documento': dni,
    });

    final List<Vacunador> resp = await procesarRespuestaDos(url);

    // Guard: respuesta vacia es inesperada — la API retorna al menos 1 item.
    // codigo_mensaje == '0' indica error de validacion (vacunador no encontrado).
    if (resp.isEmpty) throw 'No se encontraron datos del vacunador.';

    return resp;
  }
}

final vacunadorProviders = _VacunadorProviders();
