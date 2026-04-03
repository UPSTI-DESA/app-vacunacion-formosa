import 'dart:convert';

/// Indica si el texto parece UTF-8 mal leído como Latin-1 (mojibake).
bool _pareceMojibakeUtf8MalDecodificado(String str) {
  return str.contains('Ã') ||
      str.contains('Â') ||
      str.contains('\uFFFD');
}

/// Normaliza cadenas que vienen del servidor en JSON.
///
/// Los providers deben usar siempre `utf8.decode(resp.bodyBytes)` (no
/// `response.body`) antes de `json.decode` para no perder acentos en HTTP.
///
/// Esta función **solo** reaplica la corrección clásica (Latin-1 → bytes → UTF-8)
/// cuando el texto muestra mojibake típico (`Ã±`, `Ã¡`, etc.). Si el texto ya
/// es UTF-8 correcto, se devuelve igual (sin excepciones ni cambios).
String fixEncoding(dynamic value) {
  if (value == null) return '';
  final str = value.toString();
  if (str.isEmpty) return str;
  if (!_pareceMojibakeUtf8MalDecodificado(str)) {
    return str;
  }
  try {
    return utf8.decode(latin1.encode(str), allowMalformed: false);
  } catch (_) {
    return str;
  }
}
