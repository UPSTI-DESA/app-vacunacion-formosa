import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/appconst_config.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/models/sistema/notificacionesdosis_models.dart';

class _NotificacionesProviders {
  Future<List<NotificacionesDosis>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final notificaciones = NotificacionesDosis.fromJsonList(
            decodedData['aplicaciones_beneficiario']);
        return notificaciones.items;
      }
    } catch (e) {
      throw 'Hubo un error $e';
    }

    throw 'Hubo un error mas jodido';
  }

  Future validarNotificaciones(String? dni, String? sexo) async {
    final url = Uri(
        scheme: scheme,
        host: host,
        path: urlNoti,
        queryParameters: {'sysdesa10_dni': dni, 'sysdesa10_sexo': sexo});

    final List<NotificacionesDosis> resp = await procesarRespuestaDos(url);
    return resp;
  }
}

final notificacionesProvider = _NotificacionesProviders();
