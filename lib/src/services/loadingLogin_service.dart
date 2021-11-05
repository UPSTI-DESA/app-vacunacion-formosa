// ignore_for_file: file_names
import 'dart:async';

class _LoadingLoginService {
  bool? _loading = false;
  bool? _primerInicio = true;

  final StreamController<bool> _loadingLoginStreamController =
      StreamController<bool>.broadcast();

  bool? get getEstadoLoginState => _loading;

  Stream<bool> get loadingStateStream => _loadingLoginStreamController.stream;

  void cargarEstado(bool estado) {
    _loading = estado;

    _loadingLoginStreamController.add(estado);
  }
//--------------- Manejo Primer Inicio -----------//

  final StreamController<bool> _primerInicioStreamController =
      StreamController<bool>.broadcast();

  bool? get getEstadoPrimerInicioState => _primerInicio;

  Stream<bool> get primerInicioStateStream =>
      _primerInicioStreamController.stream;

  void cargarPrimerInicio(bool estado) {
    _primerInicio = estado;

    _primerInicioStreamController.add(estado);
  }

  dispose() {
    _loadingLoginStreamController.close();
    _primerInicioStreamController.close();
  }
}

final loadingLoginService = _LoadingLoginService();
