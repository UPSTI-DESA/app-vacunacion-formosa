import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

class _InsertRegistro {
  Future<List<MensajeServidor>> insertRegistroProd() async {
    List<InsertRegistros> listaRegistros = [];
    listaRegistros.add(insertRegistroService.registro!);
    String registro = insertRegistrosToJson(listaRegistros);

    final url = Uri(
        scheme: 'https',
        host: 'dh.formosa.gob.ar',
        path: '/modulos/webservice/php/version_2_0/wserv_registrar_vacuna.php',
        queryParameters: {'insertvacunado': registro});
    // ignore: unused_local_variable
    final cargarRegistro = await procesarRespuestaUri(url);
    return cargarRegistro;
  }

  // ignore: missing_return
  Future<List<MensajeServidor>> procesarRespuestaUri(Uri uri) async {
    final resp = await http.post(uri);
    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final mensaje = MensajeServidor.fromJsonList(decodedData['mensajes']);
      return mensaje.items;
    }
    throw '';
  }

  Future<List<MensajeServidor>?> procesarRespuestaConExepciones(Uri uri) async {
    {
      final resp = await http.post(uri);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final mensaje = MensajeServidor.fromJsonList(decodedData['mensajes']);
        return mensaje.items;
      }
    }
    throw ('Tiempo de espera agotado');
  }
}

final insertRegistroProvider = _InsertRegistro();
