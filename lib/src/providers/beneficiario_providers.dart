import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

class _BeneficiarioProviders {
  // ignore: missing_return
  Future<List<Beneficiario>> procesarRespuestaDos(Uri url) async {
    try {
      // Timeout de 30 segundos: evita que la app quede colgada indefinidamente
      // si el servidor no responde. TimeoutException es capturada por el catch.
      final resp = await http.get(url).timeout(const Duration(seconds: 30));
      if (resp.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(resp.bodyBytes));
        final beneficiario =
            Beneficiario.fromJsonList(decodedData['beneficiario']);
        return beneficiario.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error';
  }

  Future obtenerDatosBeneficiario(
      String? barcodeDni, String? dni, String? sexo) async {
    final url = Uri(
        scheme: scheme,
        host: host,
        path: urlBenef,
        queryParameters: {
          'sysdesa10_cadena_dni': barcodeDni,
          'sysdesa10_dni': dni,
          'sysdesa10_sexo': sexo
        });

    final List<Beneficiario> resp = await procesarRespuestaDos(url);

    // Guard: la API siempre devuelve al menos 1 item (con campos vacios si no
    // encuentra datos). Si llega vacio es una respuesta inesperada del servidor.
    if (resp.isEmpty) throw 'No se encontraron datos para el beneficiario.';

    return resp;
  }
}

final beneficiarioProviders = _BeneficiarioProviders();
