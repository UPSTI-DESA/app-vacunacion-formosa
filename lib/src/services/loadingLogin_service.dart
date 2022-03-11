// ignore_for_file: file_names
import 'dart:async';

class _LoadingLoginService {
  bool? _loading = false;
  bool? _primerInicio = true;
  bool? _loadingPerfil = true;
  bool? _loadingConfiguracion = true;
  bool? _loadingLotes = true;
  bool? _loadingCondicion = true;
  bool? _loadingEsquema = true;

  final StreamController<bool> _loadingLoginStreamController =
      StreamController<bool>.broadcast();

  bool? get getEstadoLoginState => _loading;

  Stream<bool> get loadingStateStream => _loadingLoginStreamController.stream;

  void cargarEstado(bool estado) {
    _loading = estado;

    _loadingLoginStreamController.add(estado);
  }

//--------------- Manejo Primer condicion -----------//

  final StreamController<bool> _loadingEsquemaStreamController =
      StreamController<bool>.broadcast();

  bool? get getLoadingEsquemaState => _loadingEsquema;

  Stream<bool> get loadingEsquemaStateStream =>
      _loadingEsquemaStreamController.stream;

  void cargarEsquema(bool estado) {
    _loadingEsquema = estado;

    _loadingEsquemaStreamController.add(estado);
  }

//--------------- Manejo Primer condicion -----------//

  final StreamController<bool> _loadingCondicionStreamController =
      StreamController<bool>.broadcast();

  bool? get getLoadingCondicionState => _loadingCondicion;

  Stream<bool> get loadingCondicionStateStream =>
      _loadingCondicionStreamController.stream;

  void cargarCondicion(bool estado) {
    _loadingCondicion = estado;

    _loadingCondicionStreamController.add(estado);
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
//--------------- Manejo Carga Perfiles -----------//

  final StreamController<bool> _cargaPerfilesStreamController =
      StreamController<bool>.broadcast();

  bool? get getCargaPerfilState => _loadingPerfil;

  Stream<bool> get cargaPerfilStateStream =>
      _cargaPerfilesStreamController.stream;

  void cargaPerfil(bool estado) {
    _loadingPerfil = estado;
    _cargaPerfilesStreamController.add(estado);
  }

  //--------------- Manejo Carga Configuraciones -----------//

  final StreamController<bool> _cargaConfiguracionesStreamController =
      StreamController<bool>.broadcast();

  bool? get getCargaConfiguracionState => _loadingConfiguracion;

  Stream<bool> get cargarConfiguracionStateStream =>
      _cargaConfiguracionesStreamController.stream;

  void cargaConfiguracion(bool estado) {
    _loadingConfiguracion = estado;
    _cargaConfiguracionesStreamController.add(estado);
  }

  //--------------- Manejo Carga Lotes -----------//

  final StreamController<bool> _cargarLotesStreamController =
      StreamController<bool>.broadcast();

  bool? get getCargaLotesState => _loadingLotes;

  Stream<bool> get cargaLotesStateStream => _cargarLotesStreamController.stream;

  void cargaLotes(bool estado) {
    _loadingLotes = estado;
    _cargarLotesStreamController.add(estado);
  }

  dispose() {
    _cargaPerfilesStreamController.close();
    _cargaConfiguracionesStreamController.close();
    _cargarLotesStreamController.close();
    _loadingLoginStreamController.close();
    _primerInicioStreamController.close();
  }
}

final loadingLoginService = _LoadingLoginService();
