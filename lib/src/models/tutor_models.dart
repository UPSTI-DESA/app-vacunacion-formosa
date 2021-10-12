import 'dart:typed_data';

class Tutor {
  // ignore: non_constant_identifier_names
  String? sysdesa10_apellido_tutor;
  // ignore: non_constant_identifier_names
  String? sysdesa10_nombre_tutor;
  // ignore: non_constant_identifier_names
  String? sysdesa10_dni_tutor;
  // ignore: non_constant_identifier_names
  String? sysdesa10_sexo_tutor;
  Uint8List? fotoTutor;

  Tutor(
      // ignore: non_constant_identifier_names
      {required this.sysdesa10_apellido_tutor,
      // ignore: non_constant_identifier_names
      required this.sysdesa10_nombre_tutor,
      // ignore: non_constant_identifier_names
      required this.sysdesa10_dni_tutor,
      // ignore: non_constant_identifier_names
      required this.sysdesa10_sexo_tutor,
      required this.fotoTutor});
}
