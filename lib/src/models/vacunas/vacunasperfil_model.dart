import 'dart:convert';

PerfilesVacunacion perfilesVacunacionFromJson(String str) =>
    PerfilesVacunacion.fromJson(json.decode(str));

String perfilesVacunacionToJson(PerfilesVacunacion data) =>
    json.encode(data.toJson());

class PerfilesVacunacion {
  List<PerfilesVacunacion> items = [];
  PerfilesVacunacion({
    this.idSysvacu12,
    this.sysvacu12Descripcion,
    this.codigoMensaje,
    this.mensaje,
  });

  String? idSysvacu12;
  String? sysvacu12Descripcion;
  String? codigoMensaje;
  String? mensaje;

  factory PerfilesVacunacion.fromJson(Map<String, dynamic> json) =>
      PerfilesVacunacion(
        idSysvacu12: json["id_sysvacu12"],
        sysvacu12Descripcion: json["sysvacu12_descripcion"],
        codigoMensaje: json["codigo_mensaje"],
        mensaje: json["mensaje"],
      );

  PerfilesVacunacion.fromJsonMap(Map<String, dynamic> json) {
    idSysvacu12 = json["id_sysvacu12"];
    sysvacu12Descripcion = json["sysvacu12_descripcion"];
    codigoMensaje = json["codigo_mensaje"];
    mensaje = json["mensaje"];
  }

  Map<String, dynamic> toJson() => {
        "id_sysvacu12": idSysvacu12,
        "sysvacu12_descripcion": sysvacu12Descripcion,
        "codigo_mensaje": codigoMensaje,
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
