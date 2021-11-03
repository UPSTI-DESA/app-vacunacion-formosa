import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sistema_vacunacion/src/models/sistema/notificacionesdosis_models.dart';

class _NotificacionesProviders {
  Future<List<NotificacionesDosis>> procesarRespuestaDos(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final notificaciones = NotificacionesDosis.fromJsonList(
          decodedData['aplicaciones_beneficiario']);
      return notificaciones.items;
    }
    throw '';
  }

  Future validarNotificaciones(String? dni, String? sexo) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path:
            '/modulos/webservice/php/version_2_0/obtener_aplicaciones_beneficiario.php',
        queryParameters: {'sysdesa10_dni': dni, 'sysdesa10_sexo': sexo});

    final List<NotificacionesDosis> resp = await procesarRespuestaDos(url);
    return resp;
  }
}

final notificacionesProvider = _NotificacionesProviders();
