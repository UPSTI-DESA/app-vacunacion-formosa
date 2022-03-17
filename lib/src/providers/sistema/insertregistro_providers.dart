import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

class _InsertRegistro {
  Future<List<MensajeServidor>> insertRegistroProd() async {
    List<InsertRegistros> listaRegistros = [];
    listaRegistros.add(insertRegistroService.registro!);
    String registro = insertRegistrosToJson(listaRegistros);

    final url = Uri(
        scheme: scheme,
        host: host,
        path: urlPruebaInsert,
        queryParameters: {'insertvacunado': registro});
    // ignore: unused_local_variable
    final cargarRegistro = await procesarRespuestaUri(url);
    return cargarRegistro;
  }

  // ignore: missing_return
  Future<List<MensajeServidor>> procesarRespuestaUri(Uri uri) async {
    try {
      final resp = await http.post(uri);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final mensaje = MensajeServidor.fromJsonList(decodedData['mensajes']);
        return mensaje.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw 'Ocurrio un error mas jodido';
  }

  Future<List<MensajeServidor>?> procesarRespuestaConExepciones(Uri uri) async {
    try {
      final resp = await http.post(uri);
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        final mensaje = MensajeServidor.fromJsonList(decodedData['mensajes']);
        return mensaje.items;
      }
    } catch (e) {
      throw 'Ocurrio un error $e';
    }

    throw ('Tiempo de espera agotado');
  }
}

final insertRegistroProvider = _InsertRegistro();
