import 'dart:convert';

/// Corrige el mojibake en strings que vienen del servidor.
/// El servidor envía los datos codificados en Latin-1 pero el contenido
/// real es UTF-8, lo que produce caracteres como "Ã±" en lugar de "ñ".
/// Esta función revierte ese error re-codificando el string correctamente.
String fixEncoding(dynamic value) {
  if (value == null) return '';
  final str = value.toString();
  try {
    return utf8.decode(latin1.encode(str));
  } catch (_) {
    return str;
  }
}
