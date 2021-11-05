// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

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
