import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sistema_vacunacion/src/config/config.dart';

import 'package:sistema_vacunacion/src/models/models.dart';
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
        color: Colors.white,
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
    if (barcodeScanRes == null) {
      loadingLoginService.cargarEstado(false);
      return;
    }

    setState(() {
      conSplit = barcodeScanRes.split('@');
      scanBarcode = conSplit.toString();
    });

    int cantidadPosiciones = conSplit.length;

    switch (widget.tipoEscaneo) {
      case 'Registrador':
        capturarTipoDni('Registrador', cantidadPosiciones);
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
                      color: Colors.grey[50],
                    ),
                    color: Colors.red);
              });
          loadingLoginService.cargarEstado(false);
        } else {
          if (respUsuario[0].sysofic01_descripcion != null) {
            registradorService.cargarRegistrador(respUsuario[0]);
            if (datosdecargaprovider.versionApp == 'Ok') {
              Future.delayed(const Duration(milliseconds: 1000), () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VacunadorPage(
                              infoCargador: respUsuario,
                            )),
                    (Route<dynamic> route) => false);
              });
              loadingLoginService.cargarEstado(false);
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
                          color: Colors.grey[50],
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
                        color: Colors.grey[50],
                      ),
                      color: Colors.red);
                });
            loadingLoginService.cargarEstado(false);
          }
        }
        break;
      case 'Vacunador':
        capturarTipoDni('Vacunador', cantidadPosiciones);
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
                      color: Colors.grey[50],
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
                    color: Colors.grey[50],
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
    String uriTutor = datosBeneficiario[0].foto_beneficiario;
    Tutor tutor = Tutor(
        sysdesa10_apellido_tutor: datosBeneficiario[0].sysdesa10_apellido,
        sysdesa10_nombre_tutor: datosBeneficiario[0].sysdesa10_nombre,
        sysdesa10_dni_tutor: datosBeneficiario[0].sysdesa10_dni,
        sysdesa10_sexo_tutor: datosBeneficiario[0].sysdesa10_sexo,
        fotoTutor: base64.decode(uriTutor.split(',').last));
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
  bool _hasPopped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear DNI'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_hasPopped) return;
          final barcodes = capture.barcodes;
          if (barcodes.isEmpty) return;
          final rawValue = barcodes.first.rawValue;
          if (rawValue != null) {
            _hasPopped = true;
            Navigator.of(context).pop(rawValue);
          }
        },
      ),
    );
  }
}
