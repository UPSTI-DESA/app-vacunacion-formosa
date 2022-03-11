// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

VacunasEsquema vacunasEsquemaFromJson(String str) =>
    VacunasEsquema.fromJson(json.decode(str));

String vacunasEsquemaToJson(VacunasEsquema data) => json.encode(data.toJson());

class VacunasEsquema {
  List<VacunasEsquema> items = [];
  VacunasEsquema({
    this.id_sysvacu02,
    this.sysvacu02_codigo,
    this.sysvacu02_descripcion,
    this.sysvacu02_limite_min,
    this.sysvacu02_limite_max,
    this.codigo_mensaje,
    this.mensaje,
  });

  String? id_sysvacu02;
  String? sysvacu02_codigo;
  String? sysvacu02_descripcion;
  String? sysvacu02_limite_min;
  String? sysvacu02_limite_max;
  String? codigo_mensaje;
  String? mensaje;

  factory VacunasEsquema.fromJson(Map<String, dynamic> json) => VacunasEsquema(
        id_sysvacu02: json["id_sysvacu02"],
        sysvacu02_codigo: json["sysvacu02_codigo"],
        sysvacu02_descripcion: json["sysvacu02_descripcion"],
        sysvacu02_limite_min: json["sysvacu02_limite_min"],
        sysvacu02_limite_max: json["sysvacu02_limite_max"],
        codigo_mensaje: json["codigo_mensaje"],
        mensaje: json["mensaje"],
      );

  VacunasEsquema.fromJsonMap(Map<String, dynamic> json) {
    id_sysvacu02 = json["id_sysvacu02"];
    sysvacu02_codigo = json["sysvacu02_codigo"];
    sysvacu02_descripcion = json["sysvacu02_descripcion"];
    sysvacu02_limite_min = json["sysvacu02_limite_min"];
    sysvacu02_limite_max = json["sysvacu02_limite_max"];
    codigo_mensaje = json["codigo_mensaje"];
    mensaje = json["mensaje"];
  }

  Map<String, dynamic> toJson() => {
        "id_sysvacu02": id_sysvacu02,
        "sysvacu02_codigo": sysvacu02_codigo,
        "sysvacu02_descripcion": sysvacu02_descripcion,
        "sysvacu02_limite_min": sysvacu02_limite_min,
        "sysvacu02_limite_max": sysvacu02_limite_max,
        "codigo_mensaje": codigo_mensaje,
        "mensaje": mensaje,
      };

  VacunasEsquema.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final vacunasEsquemaes = VacunasEsquema.fromJsonMap(item);
      items.add(vacunasEsquemaes);
    }
  }
}
