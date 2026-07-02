import 'dart:async';

enum DevLogTipo { apiRequest, apiResponse, apiError, estadoCambiado, info }

class DevLogEntry {
  final DateTime timestamp;
  final DevLogTipo tipo;
  final String tag;
  final String mensaje;
  final Map<String, dynamic>? datos;

  DevLogEntry({
    required this.timestamp,
    required this.tipo,
    required this.tag,
    required this.mensaje,
    this.datos,
  });
}

class _DevLogService {
  final List<DevLogEntry> _logs = [];
  // ignore: close_sinks
  final StreamController<List<DevLogEntry>> _ctrl =
      StreamController<List<DevLogEntry>>.broadcast();

  Stream<List<DevLogEntry>> get logsStream => _ctrl.stream;
  List<DevLogEntry> get logs => List.unmodifiable(_logs);

  void log(
    DevLogTipo tipo,
    String tag,
    String mensaje, {
    Map<String, dynamic>? datos,
  }) {
    _logs.insert(
      0,
      DevLogEntry(
        timestamp: DateTime.now(),
        tipo: tipo,
        tag: tag,
        mensaje: mensaje,
        datos: datos,
      ),
    );
    if (_logs.length > 200) _logs.removeLast();
    _ctrl.add(List.unmodifiable(_logs));
  }

  void limpiar() {
    _logs.clear();
    _ctrl.add(List.unmodifiable(_logs));
  }
}

final devLogService = _DevLogService();
