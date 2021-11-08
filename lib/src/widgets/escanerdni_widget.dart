import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_vacunacion/src/config/config.dart';

import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/loadingLogin_service.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'No se puede procesar.';
    }
    if (!mounted) return;

    //CAPTURO EL RESULTADO DEL ESCANER Y CON LA FUNCION SPLIT ELIMINO LOS @ Y SEPARO CADA PARTE EN UN ARRAY
    //PARA ASI, LUEGO PODER ACCEDER A ELLAS

    setState(() {
      // _scanBarcode = barcodeScanRes;
      conSplit = barcodeScanRes.split('@');
      scanBarcode = conSplit.toString();
    });

    int cantidadPosiciones = conSplit.length;

    switch (widget.tipoEscaneo) {
      case 'Registrador':
        capturarTipoDni('Registrador', cantidadPosiciones);
        //final respUsuario = await usuariosProviers.validarUsuarios(dniPersona);
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
            //Singleton Registrador
            registradorService.cargarRegistrador(respUsuario[0]);
            if (datosdecargaprovider.versionApp == 'Ok') {
              Future.delayed(const Duration(milliseconds: 1000), () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        // ignore: missing_required_param
                        builder: (context) => VacunadorPage(
                              infoCargador: respUsuario, //agrege
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
        if (respUsuario == 0) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Error',
                    descripcionAlerta:
                        'Hubo un problema al escanear el D.N.I. intente nuevamente o pruebe otro metodo de ingreso.',
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

    //identificarNTramite();
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
    //Provider con Datos del Beneficiario
    //Cargo Datos de Beneficiario en Singleton, y envio parametros EDAD + DNI para recibir la lista de VACUNAS

    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario(codigodebarras, dni, sexoPersona);
    setState(() {
      beneficiarioService.cargarBeneficiario(datosBeneficiario[0]);
    });
    //Recuperamos la lista de Vacunas

    final notificaciones =
        await notificacionesProvider.validarNotificaciones(dni, sexoPersona);
    notificaciones[0].codigo_mensaje == '1'
        // ignore: unnecessary_statements
        ? {
            notificacionesDosisService.cargarListaDosis(notificaciones),
            //Provider.of<ModeloNotificacion>(context, listen: false).numero = 1
          }
        : notificacionesDosisService.cargarRegistro(NotificacionesDosis());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const VacunasPage()),
        (Route<dynamic> route) => false);
  }

  void mostrarAlertaActualizacion(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informacion Importante'),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: _launchURL,
              )
            ],
          );
        });
  }

//Funcion para redirigir al Link de Descarga de la Ultima Aplicacion Disponible
  _launchURL() async {
    const url =
        'https://drive.google.com/drive/u/0/folders/1Ia3CGOuCSbnpgt_4qNOGKlzkzc4FvuO4';
    await launch(url);
  }

  capturarTipoDni(String tipoEscaneo, int cantidadPosiciones) {
//Si la cantidad de posiciones es 8 Significa que es el DNI NUEVO
    if (cantidadPosiciones == 8) {
      setState(() {
        nombrePersona = conSplit[2];
        apellidoPersona = conSplit[1];
        dniPersona = conSplit[4];
        sexoPersona = conSplit[3];
        numeroTramite = conSplit[0];
        codigodebarras = conSplit.toString();
        // if (tipoEscaneo == 'Beneficiario') {
        //   // beneficiarioService.cargarBeneficiario(Beneficiario(
        //   //     dni: conSplit[4].replaceAll(' ', ''),
        //   //     nombre: conSplit[1] + ' ' + conSplit[2],
        //   //     codigoBarras: conSplit.toString(),
        //   //     numeroTramite: conSplit[0],
        //   //     sexoPersona: conSplit[3]));
        // }
      });
    } else if (cantidadPosiciones == 17) {
      //Si la cantidad de posiciones es 17 la persona posee DNI VIEJO
      setState(() {
        nombrePersona = conSplit[5];
        apellidoPersona = conSplit[4];
        dniPersona = conSplit[1];
        dniPersona = dniPersona!
            .replaceAll(' ', ''); //Elimino espacios que contiene el DNI
        sexoPersona = conSplit[8];
        numeroTramite = conSplit[10];
        codigodebarras = conSplit.toString();

        // if (tipoEscaneo == 'Beneficiario') {
        //   beneficiarioService.cargarBeneficiario(Beneficiario(
        //       dni: conSplit[1].replaceAll(' ', ''),
        //       nombre: conSplit[4] + ' ' + conSplit[5],
        //       codigoBarras: conSplit.toString(),
        //       numeroTramite: conSplit[10],
        //       sexoPersona: conSplit[8]));
        // }
      });
    } else if (cantidadPosiciones == 9) {
      //Si la cantidad de posiciones es 9 la persona posee DNI NUEVO BIS
      setState(() {
        nombrePersona = conSplit[2];
        apellidoPersona = conSplit[1];
        dniPersona = conSplit[4];
        dniPersona = dniPersona!
            .replaceAll(' ', ''); //Elimino espacios que contiene el DNI
        sexoPersona = conSplit[3];
        numeroTramite = conSplit[0];
        codigodebarras = conSplit.toString();

        // if (tipoEscaneo == 'Beneficiario') {
        //   beneficiarioService.cargarBeneficiario(Beneficiario(
        //       dni: conSplit[4].replaceAll(' ', ''),
        //       nombre: conSplit[1] + ' ' + conSplit[2],
        //       codigoBarras: conSplit.toString(),
        //       numeroTramite: conSplit[0],
        //       sexoPersona: conSplit[3]));
        // }
      });
    }
  }

  void mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informacion incorrecta'),
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
