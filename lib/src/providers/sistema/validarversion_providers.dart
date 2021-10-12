import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';

class _ValidacionVersion {
  Future<List<Version>> procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final version = new Version.fromJsonList(decodedData['versiones']);

    return version.items;
  }

  Future validarVersion() async {
    final url = Uri(
      scheme: 'https',
      host: 'dh.formosa.gob.ar',
      path: '/modulos/webservice/php/wserv_versiones_app.php',
    );

    final List<Version> resp = await procesarRespuesta(url);
    if (resp.isNotEmpty) {
      return resp[0].sysappl01_version;
    } else {
      return 0;
    }
  }

  Future validarVersionNuevaVersion(String nombreapp, String versionApp) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path: '/modulos/webservice/php/version_2_0/wserv_versiones_app.php',
        queryParameters: {
          'sysappl01_nombre': nombreapp,
          'sysappl01_version': versionApp,
        });

    final List<Version> resp = await procesarRespuesta(url);
    if (resp.isNotEmpty) {
      return resp[0].sysappl01_version;
    } else {
      return 0;
    }
  }
}

final validacionVersionProvider = new _ValidacionVersion();
