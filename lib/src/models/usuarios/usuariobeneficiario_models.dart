import 'dart:convert';

List<Beneficiario> infoBeneficiarioFromJson(String str) =>
    List<Beneficiario>.from(
        json.decode(str).map((x) => Beneficiario.fromJson(x)));

String infoBeneficiarioToJson(List<Beneficiario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Beneficiario {
  List<Beneficiario> items = [];
  Beneficiario({
    // ignore: non_constant_identifier_names
    this.sysdesa10_apellido,
    // ignore: non_constant_identifier_names
    this.sysdesa10_nombre,
    // ignore: non_constant_identifier_names
    this.sysdesa10_cuil,
    // ignore: non_constant_identifier_names
    this.sysdesa10_dni,
    // ignore: non_constant_identifier_names
    this.sysdesa10_sexo,
    // ignore: non_constant_identifier_names
    this.sysdesa10_nro_tramite,
    // ignore: non_constant_identifier_names
    this.sysdesa10_fecha_nacimiento,
    // ignore: non_constant_identifier_names
    this.sysdesa10_edad,
    // ignore: non_constant_identifier_names
    this.sysdesa10_cadena_dni,
    // ignore: non_constant_identifier_names
    this.codigo_mensaje,
    // ignore: non_constant_identifier_names
    this.mensaje,
    // ignore: non_constant_identifier_names
    this.foto_beneficiario,
  });
  // ignore: non_constant_identifier_names
  String? sysdesa10_apellido;
  // ignore: non_constant_identifier_names
  String? sysdesa10_nombre;
  // ignore: non_constant_identifier_names
  String? sysdesa10_cuil;
  // ignore: non_constant_identifier_names
  String? sysdesa10_dni;
  // ignore: non_constant_identifier_names
  String? sysdesa10_sexo;
  // ignore: non_constant_identifier_names
  String? sysdesa10_nro_tramite;
  // ignore: non_constant_identifier_names
  String? sysdesa10_fecha_nacimiento;
  // ignore: non_constant_identifier_names
  String? sysdesa10_edad;
  // ignore: non_constant_identifier_names
  String? sysdesa10_cadena_dni;
  // ignore: non_constant_identifier_names
  String? codigo_mensaje;

  dynamic mensaje;
  // ignore: non_constant_identifier_names
  String? foto_beneficiario;

  // ignore: non_constant_identifier_names

  factory Beneficiario.fromJson(Map<String, dynamic> json) => Beneficiario(
        sysdesa10_apellido: json["sysdesa10_apellido"],
        sysdesa10_nombre: json["sysdesa10_nombre"],
        sysdesa10_cuil: json["sysdesa10_cuil"],
        sysdesa10_dni: json["sysdesa10_dni"],
        sysdesa10_sexo: json["sysdesa10_sexo"],
        sysdesa10_nro_tramite: json["sysdesa10_nro_tramite"],
        sysdesa10_fecha_nacimiento: json["sysdesa10_fecha_nacimiento"],
        sysdesa10_edad: json["sysdesa10_edad"],
        sysdesa10_cadena_dni: json["sysdesa10_cadena_dni"],
        codigo_mensaje: json["codigo_mensaje"],
        mensaje: json["mensaje"],
        foto_beneficiario: json["foto_beneficiario"],
      );
  Beneficiario.fromJsonMap(Map<String, dynamic> json) {
    sysdesa10_apellido = json["sysdesa10_apellido"];
    sysdesa10_nombre = json["sysdesa10_nombre"];
    sysdesa10_cuil = json["sysdesa10_cuil"];
    sysdesa10_dni = json["sysdesa10_dni"];
    sysdesa10_sexo = json["sysdesa10_sexo"];
    sysdesa10_nro_tramite = json["sysdesa10_nro_tramite"];
    sysdesa10_fecha_nacimiento = json["sysdesa10_fecha_nacimiento"];
    sysdesa10_edad = json["sysdesa10_edad"];
    sysdesa10_cadena_dni = json["sysdesa10_cadena_dni"];
    codigo_mensaje = json["codigo_mensaje"];
    mensaje = json["mensaje"];
    foto_beneficiario = json["foto_beneficiario"];
  }
  Map<dynamic, dynamic> toJson() => {
        sysdesa10_apellido: sysdesa10_apellido,
        sysdesa10_nombre: sysdesa10_nombre,
        sysdesa10_cuil: sysdesa10_cuil,
        sysdesa10_dni: sysdesa10_dni,
        sysdesa10_sexo: sysdesa10_sexo,
        sysdesa10_nro_tramite: sysdesa10_nro_tramite,
        sysdesa10_fecha_nacimiento: sysdesa10_fecha_nacimiento,
        sysdesa10_edad: sysdesa10_edad,
        sysdesa10_cadena_dni: sysdesa10_cadena_dni,
        codigo_mensaje: codigo_mensaje,
        mensaje: mensaje,
        foto_beneficiario: foto_beneficiario,
      };
  Beneficiario.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final informacion = Beneficiario.fromJsonMap(item);
      items.add(informacion);
    }
  }
}
