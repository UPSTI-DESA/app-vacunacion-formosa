import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:sistema_vacunacion/src/config/config.dart';

import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/utils/imagen_base64_util.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class EscanerDni extends StatefulWidget {
  final String textoAyuda;
  final String textoBoton;
  final String tipoEscaneo; //REGISTRADOR / VACUNADOR / BENEFICIARIO
  final double? anchoValor;
  final double? largoValor;
  final bool? iconBool;

  const EscanerDni(
    this.tipoEscaneo,
    this.textoBoton,
    this.textoAyuda, {
    Key? key,
    this.anchoValor,
    this.largoValor,
    this.iconBool,
  }) : super(key: key);

  @override
  _EscanerDniState createState() => _EscanerDniState();
}

class _EscanerDniState extends State<EscanerDni> {
  String scanBarcode = 'Desconocido';
  late List<String> conSplit;
  List<String>? escaneados;
  String? nombrePersona;
  String? apellidoPersona;
  String? dniPersona;
  String? codigo;
  String? numeroTramite;
  String? codigodebarras;
  String sexoPersona = "F";

  final controladorDni = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BotonCustom(
      height: widget.anchoValor ?? 40,
      width: widget.largoValor ?? double.infinity,
      borderRadius: 30,
      iconoBool: widget.iconBool ?? true,
      iconoBoton: Icon(
        FontAwesomeIcons.barcode,
        size: MediaQuery.of(context).size.width * 0.06,
      ),
      text: 'Escanear',
      onPressed: () async {
        loadingLoginService.cargarEstado(true);
        loadingLoginService.cargarPrimerInicio(false);
        scanBarcodeNormal();
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    final String? barcodeScanRes = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const _ScannerPage()),
    );

    if (!mounted) return;

    // -1 equivale a cancelado (igual que el comportamiento original)
    if (barcodeScanRes == null || barcodeScanRes == '-1') {
      loadingLoginService.cargarEstado(false);
      return;
    }

    // Split directo sin setState — capturarTipoDni() ya hace su propio setState
    // con los campos relevantes. Evita un rebuild innecesario del widget.
    conSplit = barcodeScanRes.split('@');
    scanBarcode = conSplit.toString();

    int cantidadPosiciones = conSplit.length;

    switch (widget.tipoEscaneo) {
      case 'Registrador':
        capturarTipoDni('Registrador', cantidadPosiciones);

        // Si el formato del codigo de barras no es reconocido (8, 9 o 17 partes),
        // dniPersona queda null. Mostrar error y abortar antes de llamar a la API.
        if (dniPersona == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Error de lectura',
                    descripcionAlerta:
                        'El formato del documento no fue reconocido. Intente nuevamente.',
                    textoBotonAlerta: 'Listo',
                    icon: Icon(Icons.error_outline,
                        size: 40, color: Colors.white),
                    color: Colors.red,
                  ));
          loadingLoginService.cargarEstado(false);
          break;
        }

        final respUsuario =
            await usuariosProviers.validarUsuariosNuevo(dniPersona);
        if (respUsuario[0].flxcore03_dni == '') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Error',
                    descripcionAlerta: respUsuario[0].mensaje,
                    textoBotonAlerta: 'Listo',
                    icon: Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                    color: Colors.red);
              });
          loadingLoginService.cargarEstado(false);
        } else {
          if (respUsuario[0].sysofic01_descripcion != null) {
            registradorService.cargarRegistrador(respUsuario[0]);
            if (datosdecargaprovider.versionApp == 'Ok') {
              loadingLoginService.cargarEstado(false);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VacunadorPage(
                            infoCargador: respUsuario,
                          )),
                  (Route<dynamic> route) => false);
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogoAlerta(
                        envioFuncion2: false,
                        envioFuncion1: false,
                        tituloAlerta: 'ATENCIÓN',
                        descripcionAlerta: 'Debe actualizar la aplicacion',
                        textoBotonAlerta: 'Listo',
                        icon: Icon(
                          Icons.android_outlined,
                          size: 40.0,
                          color: Colors.white,
                        ),
                        color: Colors.green);
                  });
              loadingLoginService.cargarEstado(false);
            }
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogoAlerta(
                      envioFuncion2: false,
                      envioFuncion1: false,
                      tituloAlerta: 'ERROR',
                      descripcionAlerta:
                          'Hubo un problema con la lectura del documento, reintente o contacte a servicio tecnico',
                      textoBotonAlerta: 'Listo',
                      icon: Icon(
                        Icons.error_outline,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      color: Colors.red);
                });
            loadingLoginService.cargarEstado(false);
          }
        }
        break;
      case 'Vacunador':
        capturarTipoDni('Vacunador', cantidadPosiciones);

        // Misma guarda que Registrador: abortar si el formato no fue reconocido.
        if (dniPersona == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Error de lectura',
                    descripcionAlerta:
                        'El formato del documento no fue reconocido. Intente nuevamente.',
                    textoBotonAlerta: 'Listo',
                    icon: Icon(Icons.error_outline,
                        size: 40, color: Colors.white),
                    color: Colors.red,
                  ));
          loadingLoginService.cargarEstado(false);
          break;
        }

        final respUsuario =
            await vacunadorProviders.validarVacunador(dniPersona);
        if (respUsuario[0].codigo_mensaje == '0') {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Error',
                    descripcionAlerta: respUsuario[0].mensaje,
                    textoBotonAlerta: 'Listo',
                    color: Colors.red,
                    icon: Icon(
                      Icons.new_releases_outlined,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  ));
          loadingLoginService.cargarEstado(false);
        } else {
          setState(() {
            vacunadorService.cargarVacunador(respUsuario[0]);
          });
          loadingLoginService.cargarEstado(false);
        }
        break;

      case 'Beneficiario':
        capturarTipoDni('Beneficiario', cantidadPosiciones);
        mostrarVerificacionPersonaporEscaner();
        break;

      case 'Tutor':
        capturarTipoDni('Tutor', cantidadPosiciones);

        // Misma guarda: si el formato no fue reconocido, dniPersona es null
        // y obtenerDatosTutor crashearia en datosBeneficiario[0].
        if (dniPersona == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Error de lectura',
                    descripcionAlerta:
                        'El formato del documento no fue reconocido. Intente nuevamente.',
                    textoBotonAlerta: 'Listo',
                    icon: Icon(Icons.error_outline,
                        size: 40, color: Colors.white),
                    color: Colors.red,
                  ));
          loadingLoginService.cargarEstado(false);
          break;
        }

        obtenerDatosTutor(dniPersona);
        break;

      default:
    }
  }

  void mostrarVerificacionPersonaporEscaner() {
    showDialog(
        context: context,
        builder: (context) {
          return dniPersona == null
              ? DialogoAlerta(
                  envioFuncion2: false,
                  envioFuncion1: false,
                  tituloAlerta: 'Hubo un Error',
                  descripcionAlerta: 'Se quiso enviar datos nulos.',
                  textoBotonAlerta: 'Listo',
                  color: Colors.red,
                  icon: Icon(
                    Icons.error,
                    size: 40.0,
                    color: Colors.white,
                  ),
                )
              : DialogoAlerta(
                  color: SisVacuColor.vercelesteCuaternario,
                  icon: const Icon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                  ),
                  tituloAlerta: "Verificar Datos",
                  textoBotonAlerta: 'Verificar',
                  textoBotonAlerta2: 'Cancelar',
                  descripcionAlerta: "Dni: $dniPersona , Sexo: $sexoPersona",
                  funcion1: () => obtenerDatosBeneficiario(dniPersona),
                  funcion2: () => Navigator.of(context).pop(),
                  envioFuncion1: true,
                  envioFuncion2: true,
                );
        });
  }

  obtenerDatosTutor(String? dni) async {
    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario(codigodebarras, dni, sexoPersona);
    final uriTutor = datosBeneficiario[0].foto_beneficiario;
    final Tutor tutor = Tutor(
        sysdesa10_apellido_tutor: datosBeneficiario[0].sysdesa10_apellido,
        sysdesa10_nombre_tutor: datosBeneficiario[0].sysdesa10_nombre,
        sysdesa10_dni_tutor: datosBeneficiario[0].sysdesa10_dni,
        sysdesa10_sexo_tutor: datosBeneficiario[0].sysdesa10_sexo,
        fotoTutor: decodificarImagenBase64(uriTutor));
    tutorService.cargarTutor(tutor);
  }

  obtenerDatosBeneficiario(String? dni) async {
    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario(codigodebarras, dni, sexoPersona);
    setState(() {
      beneficiarioService.cargarBeneficiario(datosBeneficiario[0]);
    });

    final notificaciones =
        await notificacionesProvider.validarNotificaciones(dni, sexoPersona);
    notificaciones[0].codigo_mensaje == '1'
        ? {
            notificacionesDosisService.cargarListaDosis(notificaciones),
          }
        : notificacionesDosisService.cargarRegistro(NotificacionesDosis());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const VacunasPage()),
        (Route<dynamic> route) => false);
  }

  // Parsea el codigo de barras del DNI argentino segun su formato.
  // El DNI argentino tiene 3 formatos validos separados por '@':
  //   - 8  partes: DNI nuevo (post 2009)
  //   - 9  partes: DNI nuevo variante
  //   - 17 partes: DNI viejo (pre 2009)
  // Si el formato no es reconocido, dniPersona queda null. El llamador
  // (scanBarcodeNormal) verifica null antes de continuar con la API.
  capturarTipoDni(String tipoEscaneo, int cantidadPosiciones) {
    if (cantidadPosiciones == 8) {
      setState(() {
        nombrePersona = conSplit[2];
        apellidoPersona = conSplit[1];
        dniPersona = conSplit[4];
        sexoPersona = conSplit[3];
        numeroTramite = conSplit[0];
        codigodebarras = conSplit.toString();
      });
    } else if (cantidadPosiciones == 17) {
      setState(() {
        nombrePersona = conSplit[5];
        apellidoPersona = conSplit[4];
        dniPersona = conSplit[1];
        dniPersona = dniPersona!.replaceAll(' ', '');
        sexoPersona = conSplit[8];
        numeroTramite = conSplit[10];
        codigodebarras = conSplit.toString();
      });
    } else if (cantidadPosiciones == 9) {
      setState(() {
        nombrePersona = conSplit[2];
        apellidoPersona = conSplit[1];
        dniPersona = conSplit[4];
        dniPersona = dniPersona!.replaceAll(' ', '');
        sexoPersona = conSplit[3];
        numeroTramite = conSplit[0];
        codigodebarras = conSplit.toString();
      });
    } else {
      // Formato desconocido: dniPersona permanece null.
      // scanBarcodeNormal() detecta null y muestra dialogo de error.
      dniPersona = null;
    }
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Información incorrecta'),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}

class _ScannerPage extends StatefulWidget {
  const _ScannerPage();

  @override
  State<_ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<_ScannerPage> {
  // Guard para evitar múltiples pops — onScan puede dispararse varias veces
  // mientras el widget todavía está en el árbol al momento de navegar.
  // Sin este flag: Navigator.pop se llama N veces → "dead thread" en el handler de Camera2.
  bool _detected = false;

  // Referencia al controller de la cámara para detenerla explícitamente
  // antes de hacer pop. Esto cierra el stream de imágenes limpiamente
  // y evita los "Device error code 4/5" y "LegacyMessageQueue dead thread".
  CameraController? _cameraController;

  void _onDetected(String rawValue) async {
    if (_detected || !mounted) return;
    _detected = true;

    // 1. Detener el stream de la cámara antes de cualquier navegación.
    //    Esto evita que frames pendientes intenten procesar después del dispose.
    await _cameraController?.stopImageStream();

    if (!mounted) return;
    Navigator.of(context).pop(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Escanear DNI',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ReaderWidget(
        // ── Formato ────────────────────────────────────────────────────────────
        // PDF417 es el único formato del DNI argentino. Restringirlo elimina
        // todas las pasadas de ZXing para otros formatos (QR, EAN, etc.).
        codeFormat: Format.pdf417,

        // ── Resolución ─────────────────────────────────────────────────────────
        // high (1080p) es el balance óptimo para PDF417.
        // veryHigh/ultraHigh mejoran DNIs muy deteriorados pero aumentan latencia.
        resolution: ResolutionPreset.high,

        // ── Velocidad de escaneo ────────────────────────────────────────────────
        // Intervalo entre intentos. Default del paquete: 1000ms.
        // 200ms = 5 intentos/segundo. Bajar a 100ms es posible pero calienta CPU.
        scanDelay: const Duration(milliseconds: 200),

        // ── Área de detección ──────────────────────────────────────────────────
        // 90% del ancho de pantalla. PDF417 es un código horizontal y ancho,
        // necesita área generosa. No conviene bajar de 0.7.
        cropPercent: 0.9,

        // ── Algoritmos extra de ZXing ──────────────────────────────────────────
        // tryHarder: DESACTIVADO. Activa modo exhaustivo que hace cada intento
        // más lento. Solo activar para DNIs muy dañados o con mala iluminación.
        tryHarder: false,

        // tryDownscale: DESACTIVADO. Agrega una segunda pasada reduciendo la imagen.
        // Solo ayuda cuando el código ocupa menos del 30% de pantalla.
        tryDownscale: false,

        // tryInverted: innecesario para DNI argentino (siempre fondo claro).
        tryInverted: false,

        // ── Lifecycle ──────────────────────────────────────────────────────────
        // Capturamos el controller para poder detener el stream antes de navegar.
        onControllerCreated: (controller, _) {
          _cameraController = controller;
        },

        showFlashlight: true,
        showGallery: false,

        // ── Callback al detectar ───────────────────────────────────────────────
        // result.text = string crudo separado por '@'.
        // capturarTipoDni() espera 8 partes (DNI nuevo), 9 (DNI nuevo bis) o 17 (DNI viejo).
        onScan: (Code result) {
          if (result.isValid && result.text != null) {
            _onDetected(result.text!);
          }
        },
      ),
    );
  }
}
