import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'dart:convert';

import 'package:sistema_vacunacion/src/models/models.dart';

class _UsuariosProviders {
  Future<List<Usuarios>> procesarRespuestaDos(Uri url) async {
    try {
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final usuarios = Usuarios.fromJsonList(decodedData['usuario']);

        return usuarios.items;
      }
    } catch (e) {
      throw "Hubo un error $e";
    }

    throw 'Hubo un error global mas jodido';
  }

  Future validarUsuarios(String dni) async {
    final url =
        Uri(scheme: scheme, host: host, path: urlLogin, queryParameters: {
      'flxcore03_dni': dni,
    });

    final List<Usuarios> resp = await procesarRespuestaDos(url);
    if (resp[0].flxcore03_dni != '') {
      return resp;
    } else {
      return resp;
    }
  }

  Future validarUsuariosNuevo(String? dni) async {
    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path: '/modulos/webservice/php/version_2_0/wserv_login.php',
        queryParameters: {
          'flxcore03_dni': dni,
        });

    final List<Usuarios> resp = await procesarRespuestaDos(url);
    return resp;
  }
}

final usuariosProviers = _UsuariosProviders();
