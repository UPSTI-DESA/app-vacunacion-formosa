import 'dart:convert';
import 'dart:typed_data';

/// Devuelve true si el texto tiene señales de mojibake (UTF-8 leído como Latin-1)
/// o contiene el carácter de reemplazo Unicode (U+FFFD).
bool _pareceMojibake(String str) {
  return str.contains('Ã') || str.contains('Â') || str.contains('\uFFFD');
}

/// Corrupción al **elegir** decodificación PDF417 (lector). No incluye `//`: un solo
/// campo corrupto con `//` no debe marcar toda la cadena como mala y romper el `@`.
bool cadenaDecodificadaPdf417PareceCorrupta(String s) {
  if (s.isEmpty) return false;
  if (s.contains('\uFFFD')) return true;
  return _pareceMojibake(s);
}

/// Nombre/apellido del **servidor** con tildes rotas; aquí sí consideramos `//`.
bool textoNombreDesdeServidorPareceCorrupto(String s) {
  if (s.isEmpty) return false;
  if (s.contains('\uFFFD')) return true;
  if (_pareceMojibake(s)) return true;
  if (s.contains('//')) return true;
  return false;
}

/// Decodifica el contenido del PDF417 del DNI argentino.
///
/// El payload suele ir en **ISO-8859-1 (Latin-1)**; `flutter_zxing` expone el
/// texto como UTF-8 desde nativo y eso puede corromper tildes y eñes. Si hay
/// [rawBytes], se intenta `latin1` y UTF-8 y se elige la variante coherente con
/// el formato `@` del DNI y sin signos de corrupción.
String decodificarCadenaPdf417Argentino(Uint8List? rawBytes, String? textoPlugin) {
  final fallback = (textoPlugin ?? '').trim();
  if (rawBytes == null || rawBytes.isEmpty) {
    return fallback;
  }

  final latin1Str = latin1.decode(rawBytes, allowInvalid: true);
  String? utf8Str;
  try {
    utf8Str = utf8.decode(rawBytes, allowMalformed: false);
  } catch (_) {
    utf8Str = null;
  }

  bool tieneArrobas(String s) => s.contains('@');

  if (tieneArrobas(fallback) && !cadenaDecodificadaPdf417PareceCorrupta(fallback)) {
    return fallback;
  }
  if (tieneArrobas(latin1Str) && !cadenaDecodificadaPdf417PareceCorrupta(latin1Str)) {
    return latin1Str;
  }
  if (utf8Str != null &&
      tieneArrobas(utf8Str) &&
      !cadenaDecodificadaPdf417PareceCorrupta(utf8Str)) {
    return utf8Str;
  }

  if (tieneArrobas(latin1Str)) return latin1Str;
  if (utf8Str != null && tieneArrobas(utf8Str)) return utf8Str;
  return fallback.isNotEmpty ? fallback : latin1Str;
}

/// Decodifica el body de una respuesta HTTP de manera robusta.
///
/// **Flujo:**
/// 1. Intenta [utf8.decode] (lo correcto según estándar HTTP/JSON).
/// 2. Si lanza [FormatException] (servidor envía ISO-8859-1 / Latin-1), cae a
///    [latin1.decode]. Latin-1 mapea 1:1 con U+0000–U+00FF, por lo que nunca
///    pierde información y siempre retorna una String válida en Dart.
///
/// Usar esta función en lugar de `utf8.decode(resp.bodyBytes)` directamente
/// garantiza que la app tolera servidores con codificación heterogénea sin
/// mostrar caracteres '?' ni lanzar excepciones.
String decodificarRespuestaHTTP(List<int> bytes) {
  try {
    return utf8.decode(bytes);
  } catch (_) {
    // El servidor envió Latin-1 / ISO-8859-1. Latin-1 → Unicode es 1:1.
    return latin1.decode(bytes);
  }
}

/// Normaliza cadenas que llegan del servidor con encoding incorrecto.
///
/// **Casos que corrige:**
/// - Mojibake clásico (ej. `Ã¡` en lugar de `á`): ocurre cuando bytes UTF-8
///   son interpretados como Latin-1. Se reaplica la conversión inversa.
/// - Carácter de reemplazo U+FFFD (`?`): ocurre cuando el servidor envía
///   un byte inválido para UTF-8 dentro del JSON. En ese caso la información
///   ya está perdida — se elimina el carácter para evitar mostrar '?'.
///
/// Si el texto ya es UTF-8 correcto, se devuelve sin modificación.
String fixEncoding(dynamic value) {
  if (value == null) return '';
  final str = value.toString();
  if (str.isEmpty) return str;

  // Valores con %XX dentro del JSON (algunos backends codifican tildes así).
  if (str.contains('%') && RegExp(r'%[0-9A-Fa-f]{2}').hasMatch(str)) {
    try {
      final decodificado =
          Uri.decodeQueryComponent(str.replaceAll('+', ' '));
      if (decodificado.isNotEmpty && decodificado != str) {
        return decodificado;
      }
    } catch (_) {}
  }

  if (!_pareceMojibake(str)) return str;

  // Caso 1: mojibake clásico (Ã, Â). La re-codificación Latin-1→UTF-8
  // recupera el texto original siempre que no haya U+FFFD mezclado.
  if (!str.contains('\uFFFD')) {
    try {
      return utf8.decode(latin1.encode(str), allowMalformed: false);
    } catch (_) {
      return str;
    }
  }

  // Caso 2: el string tiene U+FFFD (bytes originales irrecuperables).
  // Primero intentamos arreglar la parte de mojibake (Ã/Â), luego
  // eliminamos cualquier U+FFFD residual para no mostrar '?' al usuario.
  String resultado = str;
  if (str.contains('Ã') || str.contains('Â')) {
    // Reemplazamos U+FFFD por placeholder ASCII, hacemos la corrección
    // de mojibake y luego limpiamos.
    final sinFFFD = str.replaceAll('\uFFFD', '');
    try {
      resultado = utf8.decode(latin1.encode(sinFFFD), allowMalformed: false);
    } catch (_) {
      resultado = sinFFFD;
    }
  }
  return resultado.replaceAll('\uFFFD', '');
}
