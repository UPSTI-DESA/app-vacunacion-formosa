import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sistema_vacunacion/src/config/appsize_config.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

import 'package:url_launcher/url_launcher.dart';

import '../pages.dart';

class LoginBody extends StatefulWidget {
  static const String nombreRuta = '/Login';

  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  //Cambiar este Valor cada vez que se vuelve a Buildear, tanto aqui como en el SV
  final String versionApp = '1.0.0'; //Version Actual de la APP
  final String nombreApp =
      'Sistema de vacunación general'; //Nombre de la APP enviamos

  // ignore: unused_field
  final String _scanBarcode = 'Desconocido';
  List<String>? conSplit;
  List<String>? escaneados;
  String? nombrePersona;
  String? apellidoPersona;
  String? dniPersona;
  String sexoPersona = "F";
  final controladorDni = TextEditingController();

  @override
  void dispose() {
    controladorDni.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validarVersionNueva();
    SizeConfiguracion().init(context);
    return Scaffold(
      floatingActionButton: enviromentService.envState!.enviroment == 'DEV'
          ? FloatingActionButton.extended(
              heroTag: 'botonDesa',
              icon: const Icon(Icons.perm_data_setting_sharp),
              splashColor: Colors.red,
              label: const Text('MBDM'),
              isExtended: true,
              tooltip: 'PARA SU USO EN DESA!',
              //Esta condicion haabilita un boton flotante en el login para su ingreso sin escanear un dni.
              onPressed: () async {
                final respUsuario = await usuariosProviers.validarUsuariosNuevo(
                    '36355149'); //Se inserta un numero de dni de un usuario que esta habilitado dentro del sistema de gestion
                registradorService.cargarRegistrador(respUsuario[0]);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        // ignore: missing_required_param
                        builder: (context) => VacunadorPage(
                              infoCargador: respUsuario,
                            )),
                    (Route<dynamic> route) => false);
              },
            )
          : null,
      body: Stack(alignment: Alignment.center, children: <Widget>[
        _fondoBackground(),
        _loginFormulario(context),
      ]),
    );
  }

  //Funcion para Validar la Version de la App local con la Activa en Servidor
  validarVersion() async {
    final versionSv = await validacionVersionProvider.validarVersion();
    if (versionSv == versionApp) {
      datosdecargaprovider.versionApp = 'Ok';
    } else {
      mostrarAlertaActualizacion(context, 'Debe Actualizar la Aplicación');
      datosdecargaprovider.versionApp = 'No';
    }
  }

  validarVersionNueva() async {
    final versionSv = await validacionVersionProvider
        .validarVersionNuevaVersion(nombreApp, versionApp);
    if (versionSv == versionApp) {
      datosdecargaprovider.versionApp = 'Ok';
    } else {
      mostrarAlertaActualizacion(context, 'Debe Actualizar la Aplicación');
      datosdecargaprovider.versionApp = 'No';
    }
  }

  Widget _fondoBackground() {
    return BackgroundComplete(
      child: Container(),
    );
  }

  Widget _loginFormulario(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.28,
          bottom: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Bounce(
            from: 80,
            delay: Duration(milliseconds: 600),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: SisVacuColor.white),
              child: Column(
                children: <Widget>[
                  FadeInDown(
                    from: 40,
                    delay: Duration(milliseconds: 1400),
                    child: Icon(FontAwesomeIcons.hospital,
                        color: SisVacuColor.verdefuerte,
                        size: MediaQuery.of(context).size.height * 0.12),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.08),
                  FadeInRight(
                    from: 40,
                    delay: Duration(milliseconds: 1100),
                    child: Text(
                      'Registro de Vacunación',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.034,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                  FadeInLeft(
                    from: 40,
                    delay: Duration(milliseconds: 1100),
                    child: Text(
                      'Escanee su D.N.I. para continuar',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.022,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  ElasticIn(
                    delay: Duration(milliseconds: 1500),
                    child: EscanerDni(
                      'Registrador',
                      'Escanear',
                      'Escane el dni para verificar su identidad',
                      anchoValor: MediaQuery.of(context).size.width * 0.7,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                FadeInLeft(
                  from: 40,
                  delay: Duration(milliseconds: 1100),
                  child: Text(
                    'Para uso interno, del ministerio de desarrollo humano',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0),
                  ),
                ),
                // FadeInLeft(
                //   from: 40,
                //   delay: Duration(milliseconds: 1100),
                //   child: Text(
                //     'Para uso interno, del ministerio de desarrollo humano',
                //     style: TextStyle(
                //         fontSize: MediaQuery.of(context).size.height * 0.018,
                //         fontWeight: FontWeight.w600,
                //         letterSpacing: 2.0),
                //   ),
                // ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BounceInUp(
              from: 30,
              delay: Duration(milliseconds: 800),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/fondo/noimage.jpg'),
                image: AssetImage('assets/img/fondo/AZUL_TODOS_UNIDOS.png'),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.065,
                // width: MediaQuery.of(context).size.height / 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mostrarAlertaActualizacion(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Informacion Importante'),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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
}
