import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';
import 'dart:convert';

class _BeneficiarioProviders {
  // ignore: missing_return
  Future<List<Beneficiario>> procesarRespuestaDos(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final beneficiario =
          Beneficiario.fromJsonList(decodedData['beneficiario']);
      return beneficiario.items;
    }
    throw 'Ocurrio un error';
  }

  Future obtenerDatosBeneficiario(
      String? barcodeDni, String? dni, String? sexo) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/wserv_obtener_datos_beneficiario.php',
        queryParameters: {
          'sysdesa10_cadena_dni': barcodeDni,
          'sysdesa10_dni': dni,
          'sysdesa10_sexo': sexo
        });

    final List<Beneficiario> resp = await procesarRespuestaDos(url);
    if (resp[0].sysdesa10_dni != '') {
      //Si tiene Valores devuelve una Lista de Tipo Usuarios
      return resp;
    } else {
      //Si no tiene valores devuelve simplemente 0
      return 0;
    }
  }
}

final beneficiarioProviders = new _BeneficiarioProviders();
