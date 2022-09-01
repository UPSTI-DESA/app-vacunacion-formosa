import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

class _BeneficiarioProviders {
  // ignore: missing_return
  Future<List<Beneficiario>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
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
    if (resp[0].sysdesa10_dni != '') {
      return resp;
    } else {
      return resp;
    }
  }
}

final beneficiarioProviders = _BeneficiarioProviders();
