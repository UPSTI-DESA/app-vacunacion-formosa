// ignore_for_file: file_names
import 'dart:async';

class _LoadingLoginService {
  bool? _loading = false;
  bool? _primerInicio = true;
  bool? _loadingPerfil = true;
  bool? _loadingLotes = true;
  bool? _loadingCondicion = true;
  bool? _loadingEsquema = true;
  bool? _loadingDosis = true;
  bool? _loadingVerificar = true;

  final StreamController<bool> _loadingLoginStreamController =
      StreamController<bool>.broadcast();

  bool? get getEstadoLoginState => _loading;

  Stream<bool> get loadingStateStream => _loadingLoginStreamController.stream;

  void cargarEstado(bool estado) {
    _loading = estado;

    _loadingLoginStreamController.add(estado);
  }
  //--------------- Manejo Primer Dosis -----------//

  final StreamController<bool> _loadingVerificarStreamController =
      StreamController<bool>.broadcast();

  bool? get getLoadingVerificarState => _loadingVerificar;

  Stream<bool> get loadingVerificarStateStream =>
      _loadingVerificarStreamController.stream;

  void cargarVerificar(bool estado) {
    _loadingVerificar = estado;

    _loadingVerificarStreamController.add(estado);
  }

  //--------------- Manejo Primer Dosis -----------//

  final StreamController<bool> _loadingDosisStreamController =
      StreamController<bool>.broadcast();

  bool? get getLoadingDosisState => _loadingDosis;

  Stream<bool> get loadingDosisStateStream =>
      _loadingDosisStreamController.stream;

  void cargarDosis(bool estado) {
    _loadingDosis = estado;

    _loadingDosisStreamController.add(estado);
  }

//--------------- Manejo Primer Esquema -----------//

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
    _cargarLotesStreamController.close();
    _loadingLoginStreamController.close();
    _primerInicioStreamController.close();
  }
}

final loadingLoginService = _LoadingLoginService();
