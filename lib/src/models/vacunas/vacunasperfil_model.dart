// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

PerfilesVacunacion perfilesVacunacionFromJson(String str) =>
    PerfilesVacunacion.fromJson(json.decode(str));

String perfilesVacunacionToJson(PerfilesVacunacion data) =>
    json.encode(data.toJson());

class PerfilesVacunacion {
  List<PerfilesVacunacion> items = [];
  PerfilesVacunacion({
    this.id_sysvacu12,
    this.sysvacu12_descripcion,
    this.codigo_mensaje,
    this.mensaje,
  });

  String? id_sysvacu12;
  String? sysvacu12_descripcion;
  String? codigo_mensaje;
  String? mensaje;

  Map<String, dynamic> toMap() {
    return {
      'id': int.parse(id_sysvacu12!),
      'id_sysvacu12': id_sysvacu12,
      'sysvacu12_descripcion': sysvacu12_descripcion,
    };
  }

  factory PerfilesVacunacion.fromJson(Map<String, dynamic> json) =>
      PerfilesVacunacion(
        id_sysvacu12: json["id_sysvacu12"],
        sysvacu12_descripcion: json["sysvacu12_descripcion"],
        codigo_mensaje: json["codigo_mensaje"],
        mensaje: json["mensaje"],
      );

  PerfilesVacunacion.fromJsonMap(Map<String, dynamic> json) {
    id_sysvacu12 = json["id_sysvacu12"];
    sysvacu12_descripcion = json["sysvacu12_descripcion"];
    codigo_mensaje = json["codigo_mensaje"];
    mensaje = json["mensaje"];
  }

  Map<String, dynamic> toJson() => {
        "id_sysvacu12": id_sysvacu12,
        "sysvacu12_descripcion": sysvacu12_descripcion,
        "codigo_mensaje": codigo_mensaje,
        "mensaje": mensaje,
      };

  PerfilesVacunacion.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final informacion = PerfilesVacunacion.fromJsonMap(item);
      items.add(informacion);
    }
  }
}

Future<void> insertPerfil(PerfilesVacunacion perfil) async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'vacunacion_database.db'),
    version: 1,
  );
  final Database db = await database;
  await db.insert(
    'perfiles',
    perfil.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<PerfilesVacunacion>> getPerfiles() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'vacunacion_database.db'),
    version: 1,
  );
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('dogs');
  return List.generate(maps.length, (i) {
    return PerfilesVacunacion(
      id_sysvacu12: maps[i]['id_sysvacu12'],
      sysvacu12_descripcion: maps[i]['sysvacu12_descripcion'],
    );
  });
}
