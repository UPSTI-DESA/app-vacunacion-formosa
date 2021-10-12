import 'dart:convert';

List<InsertRegistros> insertRegistrosFromJson(String str) =>
    List<InsertRegistros>.from(
        json.decode(str).map((x) => InsertRegistros.fromJson(x)));

String insertRegistrosToJson(List<InsertRegistros?> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x!.toJson())));

class InsertRegistros {
  List<InsertRegistros> items = [];
  InsertRegistros({
    // ignore: non_constant_identifier_names
    this.id_flxcore03, //Cargador
    // ignore: non_constant_identifier_names
    this.id_sysvacu03, //Vacuna
    // ignore: non_constant_identifier_names
    this.id_sysofic01, //EFector
    // ignore: non_constant_identifier_names
    this.id_sysdesa18,
    // ignore: non_constant_identifier_names
    this.id_sysdesa12,
    // ignore: non_constant_identifier_names
    this.sysdesa10_nombre,
    // ignore: non_constant_identifier_names
    this.sysdesa10_apellido,
    // ignore: non_constant_identifier_names
    this.sysdesa10_dni,
    // ignore: non_constant_identifier_names
    this.sysdesa10_sexo,
    // ignore: non_constant_identifier_names
    this.sysdesa10_nro_tramite,
    // ignore: non_constant_identifier_names
    this.sysdesa10_cadena_dni, //VAcunador

    // ignore: non_constant_identifier_names
    this.sysdesa10_edad,
    // ignore: non_constant_identifier_names
    this.sysdesa10_fecha_nacimiento,
    // ignore: non_constant_identifier_names
    this.vacunador_registrador,

    //this.id_sysdesa06,                        //Beneficiario
    this.nombreConfiguracion,
    this.nombreLote,
    this.nombreVacuna,
    // ignore: non_constant_identifier_names
    this.codigo_mensaje,
    // ignore: non_constant_identifier_names
    this.mensaje,
    // ignore: non_constant_identifier_names
    this.sysdesa10_apellido_tutor,
    // ignore: non_constant_identifier_names
    this.sysdesa10_nombre_tutor,
    // ignore: non_constant_identifier_names
    this.sysdesa10_dni_tutor,
    // ignore: non_constant_identifier_names
    this.sysdesa10_sexo_tutor,
  });

  // ignore: non_constant_identifier_names
  String? id_flxcore03;
  // ignore: non_constant_identifier_names
  String? id_sysvacu03;
  // ignore: non_constant_identifier_names
  String? id_sysofic01;
  // ignore: non_constant_identifier_names
  String? id_sysdesa12;
  // ignore: non_constant_identifier_names
  String? id_sysdesa18;
  // ignore: non_constant_identifier_names
  String? sysdesa10_nombre;
  // ignore: non_constant_identifier_names
  String? sysdesa10_apellido;
  // ignore: non_constant_identifier_names
  String? sysdesa10_dni;
  // ignore: non_constant_identifier_names
  String? sysdesa10_sexo;
  // ignore: non_constant_identifier_names
  String? sysdesa10_nro_tramite;
  // ignore: non_constant_identifier_names
  String? sysdesa10_cadena_dni;
  //String id_sysdesa06;
  // ignore: non_constant_identifier_names
  String? sysdesa10_edad;

  // ignore: non_constant_identifier_names
  String? sysdesa10_fecha_nacimiento;

  // ignore: non_constant_identifier_names
  String? vacunador_registrador;

  //DATOS TUTOR
  // ignore: non_constant_identifier_names
  String? sysdesa10_apellido_tutor;
  // ignore: non_constant_identifier_names
  String? sysdesa10_nombre_tutor;
  // ignore: non_constant_identifier_names
  String? sysdesa10_dni_tutor;
  // ignore: non_constant_identifier_names
  String? sysdesa10_sexo_tutor;

  String? nombreVacuna;
  String? nombreConfiguracion;
  String? nombreLote;
  // ignore: non_constant_identifier_names
  String? codigo_mensaje;
  // ignore: non_constant_identifier_names
  String? mensaje;

  factory InsertRegistros.fromJson(Map<String, dynamic> json) =>
      InsertRegistros(
        id_flxcore03: json["id_flxcore03"],
        id_sysvacu03: json["id_sysvacu03"],
        id_sysofic01: json["id_sysofic01"],
        id_sysdesa18: json["id_sysdesa18"],
        id_sysdesa12: json["id_sysdesa12"],
        sysdesa10_nombre: json["sysdesa10_nombre"],
        sysdesa10_apellido: json["sysdesa10_apellido"],
        sysdesa10_dni: json["sysdesa10_dni"],
        sysdesa10_sexo: json["sysdesa10_sexo"],
        sysdesa10_nro_tramite: json["sysdesa10_nro_tramite"],
        sysdesa10_cadena_dni: json["sysdesa10_cadena_dni"],
        sysdesa10_edad: json["sysdesa10_edad"],
        nombreVacuna: json["nombreVacuna"],
        nombreConfiguracion: json["nombreConfiguracion"],
        nombreLote: json["nombreLote"],
        sysdesa10_fecha_nacimiento: json["sysdesa10_fecha_nacimiento"],
        vacunador_registrador: json["vacunador_registrador"],
        codigo_mensaje: json["codigo_mensaje"],
        mensaje: json["mensaje"],
        sysdesa10_apellido_tutor: json["sysdesa10_apellido_tutor"],
        sysdesa10_nombre_tutor: json["sysdesa10_nombre_tutor"],
        sysdesa10_dni_tutor: json["sysdesa10_dni_tutor"],
        sysdesa10_sexo_tutor: json["sysdesa10_sexo_tutor"],

        // id_sysdesa06: json["id_sysdesa06"],
      );

  InsertRegistros.fromJsonMap(Map<String, dynamic> json) {
    id_flxcore03 = json["id_flxcore03"];
    id_sysvacu03 = json["id_sysvacu03"];
    id_sysofic01 = json["id_sysofic01"];
    id_sysdesa18 = json["id_sysdesa18"];
    id_sysdesa12 = json["id_sysdesa12"];
    sysdesa10_nombre = json["sysdesa10_nombre"];
    sysdesa10_apellido = json["sysdesa10_apellido"];
    sysdesa10_dni = json["sysdesa10_dni"];
    sysdesa10_sexo = json["sysdesa10_sexo"];
    sysdesa10_nro_tramite = json["sysdesa10_nro_tramite"];
    sysdesa10_cadena_dni = json["sysdesa10_cadena_dni"];
    sysdesa10_edad = json["sysdesa10_edad"];
    nombreVacuna = json["nombreVacuna"];
    nombreConfiguracion = json["nombreConfiguracion"];
    nombreLote = json["nombreLote"];
    sysdesa10_fecha_nacimiento = json["sysdesa10_fecha_nacimiento"];
    vacunador_registrador = json["vacunador_registrador"];
    codigo_mensaje = json["vacunador_registrador"];
    mensaje = json["mensaje"];
    sysdesa10_apellido_tutor = json["sysdesa10_apellido_tutor"];
    sysdesa10_nombre_tutor = json["sysdesa10_nombre_tutor"];
    sysdesa10_dni_tutor = json["sysdesa10_dni_tutor"];
    sysdesa10_sexo_tutor = json["sysdesa10_sexo_tutor"];

    // id_sysdesa06 = json["id_sysdesa06"];
  }

  InsertRegistros.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final insertRegistro = InsertRegistros.fromJsonMap(item);
      items.add(insertRegistro);
    }
  }

  Map<String, dynamic> toJson() => {
        "id_flxcore03": id_flxcore03,
        "id_sysvacu03": id_sysvacu03,
        "id_sysofic01": id_sysofic01,
        "id_sysdesa18": id_sysdesa18,
        "id_sysdesa12": id_sysdesa12,
        "sysdesa10_nombre": sysdesa10_nombre,
        "sysdesa10_apellido": sysdesa10_apellido,
        "sysdesa10_dni": sysdesa10_dni,
        "sysdesa10_sexo": sysdesa10_sexo,
        "sysdesa10_nro_tramite": sysdesa10_nro_tramite,
        "sysdesa10_cadena_dni": sysdesa10_cadena_dni,
        "sysdesa10_edad": sysdesa10_edad,
        "nombreVacuna": nombreVacuna,
        "nombreConfiguracion": nombreConfiguracion,
        "nombreLote": nombreLote,
        "sysdesa10_fecha_nacimiento": sysdesa10_fecha_nacimiento,
        "vacunador_registrador": vacunador_registrador,
        "codigo_mensaje": codigo_mensaje,
        "mensaje": mensaje,
        "sysdesa10_apellido_tutor": sysdesa10_apellido_tutor,
        "sysdesa10_nombre_tutor": sysdesa10_nombre_tutor,
        "sysdesa10_dni_tutor": sysdesa10_dni_tutor,
        "sysdesa10_sexo_tutor": sysdesa10_sexo_tutor,
        //  "id_sysdesa06": id_sysdesa06,
      };
}
