// ignore_for_file: file_names
import 'dart:async';

class _LoadingLoginService {
  bool? _loading = false;

  final StreamController<bool> _loadingLoginStreamController =
      StreamController<bool>.broadcast();

  bool? get getEstadoLoginState => _loading;

  Stream<bool> get loadingStateStream => _loadingLoginStreamController.stream;

  void cargarEstado(bool estado) {
    _loading = estado;

    _loadingLoginStreamController.add(estado);
  }

  dispose() {
    _loadingLoginStreamController.close();
  }
}

final loadingLoginService = _LoadingLoginService();
