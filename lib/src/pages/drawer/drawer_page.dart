import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/drawer/components/sobrenosotros_page.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BodyDrawer extends StatefulWidget {
  final List<Vacunador>? infoVacunador;

  const BodyDrawer({Key? key, this.infoVacunador}) : super(key: key);

  @override
  _BodyDrawerState createState() => _BodyDrawerState();
}

class _BodyDrawerState extends State<BodyDrawer> {
  DateTime fecha = DateTime.now();
  DateFormat? dateFormat;

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();

  @override
  void initState() {
    dateFormat = DateFormat.EEEE('es');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _scafoldKey,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                  Color(0xff009CAF),
                  Color(0xff0F8DED),
                  Color(0xff1F7CFB),
                ])),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.036,
                  ),
                  containerFoto(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text('Bienvenido',
                      style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                            letterSpacing: 4.0,
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.036,
                  ),
                  Text(registradorService.registrador!.flxcore03_nombre!,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.036,
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Expanded(
            child: Container(
              color: SisVacuColor.white,
              child: ListView(
                padding: const EdgeInsets.only(top: 0.0),
                children: [
                  ListTile(
                      leading: Icon(
                        FontAwesomeIcons.solidEdit,
                        color: SisVacuColor.vercelesteCuaternario,
                        size: MediaQuery.of(context).size.width / 20.0,
                      ),
                      title: Text('Editar equipo de trabajo',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          )),
                      onTap: () {
                        vacunadorService.cargarVacunador(null);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                // ignore: missing_required_param
                                builder: (context) => const VacunadorPage(
                                      infoCargador: [],
                                    )));
                      }),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.info,
                      color: SisVacuColor.vercelesteCuaternario,
                      size: MediaQuery.of(context).size.width / 20.0,
                    ),
                    title: Text('Sobre Nosotros',
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        )),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SobreNosotrosPage())),
                  ),
                  ListTile(
                      leading: Icon(
                        FontAwesomeIcons.solidFilePdf,
                        color: SisVacuColor.vercelesteCuaternario,
                        size: MediaQuery.of(context).size.width / 20.0,
                      ),
                      title: Text('Descargar PDF',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          )),
                      onTap: () {
                        _launchPDF();
                      }),
                  ListTile(
                      leading: Icon(
                        FontAwesomeIcons.powerOff,
                        color: SisVacuColor.red,
                        size: MediaQuery.of(context).size.width / 20.0,
                      ),
                      title: Text('Cerrar Sesión',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          )),
                      onTap: () {
                        datosdecargaprovider.nombreVacunador = '';
                        datosdecargaprovider.dniVacunador = '';
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginBody(),
                            ));
                      }),
                ],
              ),
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: FadeInImage(
              placeholder: const AssetImage('assets/img/fondo/noimage.jpg'),
              image: const AssetImage(
                'assets/img/fondo/logo_polo_upsti_azul.png',
              ),
              // fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  containerFoto(context) {
    return CircleAvatar(
      radius: 60,
      child: SizedBox(
        width: MediaQuery.of(context).size.height * 0.12,
        height: MediaQuery.of(context).size.height * 0.12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    'assets/img/fondo/escudoColor.png',
                    fit: BoxFit.fill,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _launchPDF() async {
    const url =
        'https://drive.google.com/file/d/1qD3x3xvzmIVuJlR_UtMzdX619A4F7gAz/view?usp=sharing';
    await launch(url);
  }
}
