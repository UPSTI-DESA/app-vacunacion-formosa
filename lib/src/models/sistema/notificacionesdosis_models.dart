// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<NotificacionesDosis> notificacionDosisFromJson(String str) =>
    List<NotificacionesDosis>.from(
        json.decode(str).map((x) => NotificacionesDosis.fromJson(x)));

String notificacionDosisToJson(List<NotificacionesDosis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificacionesDosis {
  List<NotificacionesDosis> items = [];
  NotificacionesDosis(
      {this.sysvacu04_nombre,
      this.sysvacu05_nombre,
      this.sysdesa10_fecha_aplicacion,
      this.fecha_proxima_dosis,
      this.dias_transcurridos,
      this.sysdesa18_lote,
      this.sysvacu03_tiempo_interdosis,
      this.codigo_mensaje,
      this.mensaje});

  String? sysvacu04_nombre;
  String? sysvacu05_nombre;
  String? sysdesa10_fecha_aplicacion;
  String? fecha_proxima_dosis;
  String? dias_transcurridos;

  String? sysdesa18_lote;
  String? sysvacu03_tiempo_interdosis;
  String? codigo_mensaje;
  String? mensaje;

  factory NotificacionesDosis.fromJson(Map<String, dynamic> json) =>
      NotificacionesDosis(
        sysvacu04_nombre: json["sysvacu04_nombre"],
        sysvacu05_nombre: json["sysvacu05_nombre"],
        sysdesa10_fecha_aplicacion: json["sysdesa10_fecha_aplicacion"],
        fecha_proxima_dosis: json["fecha_proxima_dosis"],
        dias_transcurridos: json["dias_transcurridos"],
        sysdesa18_lote: json["sysdesa18_lote"],
        sysvacu03_tiempo_interdosis: json["sysvacu03_tiempo_interdosis"],
        codigo_mensaje: json["codigo_mensaje"],
        mensaje: json["mensaje"],
      );

  NotificacionesDosis.fromJsonMap(Map<String, dynamic> json) {
    sysvacu04_nombre = json["sysvacu04_nombre"];
    sysvacu05_nombre = json["sysvacu05_nombre"];
    sysdesa10_fecha_aplicacion = json["sysdesa10_fecha_aplicacion"];
    fecha_proxima_dosis = json["fecha_proxima_dosis"];
    dias_transcurridos = json["dias_transcurridos"];
    sysdesa18_lote = json["sysdesa18_lote"];
    sysvacu03_tiempo_interdosis = json["sysvacu03_tiempo_interdosis"];
    codigo_mensaje = json["codigo_mensaje"];
    mensaje = json["mensaje"];
  }

  Map<String?, dynamic> toJson() => {
        sysvacu04_nombre: sysvacu04_nombre,
        sysvacu05_nombre: sysvacu05_nombre,
        sysdesa10_fecha_aplicacion: sysdesa10_fecha_aplicacion,
        sysdesa10_fecha_aplicacion: sysdesa10_fecha_aplicacion,
        fecha_proxima_dosis: fecha_proxima_dosis,
        dias_transcurridos: dias_transcurridos,
        sysdesa18_lote: sysdesa18_lote,
        sysvacu03_tiempo_interdosis: sysvacu03_tiempo_interdosis,
        codigo_mensaje: codigo_mensaje,
        mensaje: mensaje,
      };

  NotificacionesDosis.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final notificacionesDosis = NotificacionesDosis.fromJsonMap(item);
      items.add(notificacionesDosis);
    }
  }
}
