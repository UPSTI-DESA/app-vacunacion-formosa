import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sistema_vacunacion/src/config/appsize_config.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/loadingLogin_service.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/headers_widgets.dart';
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
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
          body: Stack(
            children: [
              const EncabezadoWave(),
              _LoginFormulario(context: context),
            ],
          ),
        ),
        StreamBuilder(
          stream: loadingLoginService.loadingStateStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return loadingLoginService.getEstadoLoginState!
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(.7),
                    child: const Center(child: LoadingEstrellas()))
                : loadingLoginService.getEstadoPrimerInicioState!
                    ? Container()
                    : FutureBuilder(
                        future:
                            Future.delayed(const Duration(milliseconds: 1000)),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.black.withOpacity(.7),
                                  child:
                                      const Center(child: LoadingEstrellas()))
                              : Container();
                        },
                      );
          },
        ),
      ],
    );
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
}

class _LoginFormulario extends StatelessWidget {
  const _LoginFormulario({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.15,
          bottom: MediaQuery.of(context).size.height * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: Column(
              children: <Widget>[
                FadeInDownBig(
                  from: 40,
                  child: Image(
                    image: const AssetImage('assets/logo/VacunApp2.png'),
                    fit: BoxFit.cover,
                    //height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * .55,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                FadeInLeft(
                  from: 40,
                  delay: const Duration(milliseconds: 1100),
                  child: Text('Escanee su D.N.I. para continuar',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                            color: Colors.black87,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0),
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                ElasticIn(
                  delay: const Duration(milliseconds: 1500),
                  child: EscanerDni(
                    'Registrador',
                    'Escanear',
                    'Escane el dni para verificar su identidad',
                    iconBool: false,
                    anchoValor: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: FadeInLeft(
                    from: 40,
                    delay: const Duration(milliseconds: 1100),
                    child: Text(
                        'Para uso interno, del ministerio de desarrollo humano',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BounceInUp(
              from: 20,
              delay: const Duration(milliseconds: 800),
              child: Image(
                image:
                    const AssetImage('assets/img/fondo/AZUL_TODOS_UNIDOS.png'),
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
}
