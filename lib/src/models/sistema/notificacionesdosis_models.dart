import 'dart:convert';

List<NotificacionesDosis> notificacionDosisFromJson(String str) =>
    List<NotificacionesDosis>.from(
        json.decode(str).map((x) => NotificacionesDosis.fromJson(x)));

String notificacionDosisToJson(List<NotificacionesDosis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificacionesDosis {
  List<NotificacionesDosis> items = [];
  NotificacionesDosis(
      {
      // ignore: non_constant_identifier_names
      this.sysvacu04_nombre,
      // ignore: non_constant_identifier_names
      this.sysvacu05_nombre,
      // ignore: non_constant_identifier_names
      this.sysdesa10_fecha_aplicacion,
      // ignore: non_constant_identifier_names
      this.fecha_proxima_dosis,
      // ignore: non_constant_identifier_names
      this.dias_transcurridos,
      // ignore: non_constant_identifier_names
      this.sysvacu03_tiempo_interdosis,
      // ignore: non_constant_identifier_names
      this.codigo_mensaje,
      this.mensaje});

  // ignore: non_constant_identifier_names
  String? sysvacu04_nombre;
  // ignore: non_constant_identifier_names
  String? sysvacu05_nombre;
  // ignore: non_constant_identifier_names
  String? sysdesa10_fecha_aplicacion;
  // ignore: non_constant_identifier_names
  String? fecha_proxima_dosis;
  // ignore: non_constant_identifier_names
  String? dias_transcurridos;
  // ignore: non_constant_identifier_names
  String? sysvacu03_tiempo_interdosis;
  // ignore: non_constant_identifier_names
  String? codigo_mensaje;
  String? mensaje;

  factory NotificacionesDosis.fromJson(Map<String, dynamic> json) =>
      NotificacionesDosis(
        sysvacu04_nombre: json["sysvacu04_nombre"],
        sysvacu05_nombre: json["sysvacu05_nombre"],
        sysdesa10_fecha_aplicacion: json["sysdesa10_fecha_aplicacion"],
        fecha_proxima_dosis: json["fecha_proxima_dosis"],
        dias_transcurridos: json["dias_transcurridos"],
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
