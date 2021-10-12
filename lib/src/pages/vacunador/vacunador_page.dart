import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

import '../pages.dart';

class VacunadorPage extends StatefulWidget {
  static const String nombreRuta = 'VacunadorEstablecimiento';
  final List<Usuarios?> infoCargador;

  const VacunadorPage({Key? key, required this.infoCargador}) : super(key: key);

  @override
  _VacunadorPageState createState() => _VacunadorPageState();
}

class _VacunadorPageState extends State<VacunadorPage> {
  // ignore: unused_field
  final controladorDni = TextEditingController();
  bool estadoVacunador = false;
  bool? animacionNombreVacunado;
  bool? mismoVacunador;
  bool? switchContainer;
  String? stringVacunador;

  @override
  void dispose() {
    controladorDni.dispose();
    super.dispose();
  }

  @override
  void initState() {
    mismoVacunador = false;
    animacionNombreVacunado = false;
    switchContainer = false;
    stringVacunador = 'No';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: SisVacuColor.verdeclaro,
          appBar: AppBar(
            backgroundColor: SisVacuColor.verdefuerte,
            title: FadeInLeftBig(
              from: 50,
              child: const Text(
                'Sistema de Vacunación',
                style: TextStyle(fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          drawer: const BodyDrawer(),
          floatingActionButton: FloatingActionButton(
            mini: true,
            child: Icon(FontAwesomeIcons.exclamation,
                size: getValueForScreenType(context: context, mobile: 18)),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogoAlerta(
                        envioFuncion2: false,
                        envioFuncion1: false,
                        tituloAlerta: 'Información Adicional',
                        descripcionAlerta:
                            'Termine el registro del equipo de trabajo, seleccionando el switch de mismo vacunados, escaneando el código de barras del D.N.I. o ingresando el número de D.N.I.',
                        textoBotonAlerta: 'Listo',
                        color: SisVacuColor.yelow700,
                        icon: Icon(Icons.info,
                            size: 40.0, color: Colors.grey[50]),
                      ));
            },
          ),
          body: SafeArea(
            child: BackgroundHeader(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    FadeIn(
                      duration: const Duration(milliseconds: 800),
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                            left: MediaQuery.of(context).size.width * 0.02),
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.05),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: SisVacuColor.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TitulosContainerPage(
                                colorTitle: SisVacuColor.black,
                                sizeTitle: 18.0,
                                widthThickness: 1.5,
                                title: 'Equipo de Trabajo',
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Efector: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        registradorService.registrador!
                                            .sysofic01_descripcion!,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Registrador: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        registradorService
                                            .registrador!.flxcore03_nombre!,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Vacunador: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  StreamBuilder(
                                    stream: vacunadorService.vacunadorStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Vacunador?> snapshot) {
                                      return snapshot.hasData
                                          ? Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  vacunadorService.vacunador!
                                                      .sysdesa06_nombre!,
                                                  style: const TextStyle(),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              mismoVacunador!
                                                  ? 'Sin Asignar'
                                                  : registradorService
                                                      .registrador!
                                                      .flxcore03_nombre!,
                                              style: TextStyle(
                                                  color: mismoVacunador!
                                                      ? Colors.red
                                                      : SisVacuColor.black,
                                                  letterSpacing: mismoVacunador!
                                                      ? 3.0
                                                      : 0.0),
                                            );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    FadeIn(
                        duration: const Duration(milliseconds: 800),
                        child: StreamBuilder(
                            stream: vacunadorService.vacunadorStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<Vacunador?> snapshot) {
                              return snapshot.hasData
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: SisVacuColor.white),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TitulosContainerPage(
                                              colorTitle: SisVacuColor.black,
                                              sizeTitle: 18.0,
                                              widthThickness: 1.5,
                                              title: 'Mismo Vacunador',
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text('Si'),
                                                Switch(
                                                    activeColor: Colors.orange,
                                                    inactiveTrackColor:
                                                        Colors.purple,
                                                    inactiveThumbColor:
                                                        Colors.purple,
                                                    value: mismoVacunador!,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        mismoVacunador = value;

                                                        mismoVacunador!
                                                            ? stringVacunador =
                                                                'Si'
                                                            : stringVacunador =
                                                                'No';
                                                      });
                                                    }),
                                                const Text('No'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            })),
                    const SizedBox(
                      height: 20.0,
                    ),
                    mismoVacunador == false
                        ? Container()
                        : FadeIn(
                            duration: const Duration(milliseconds: 800),
                            child: _infoVacunador(context)),
                    //Fin de Ocultar
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElasticIn(
                      duration: const Duration(milliseconds: 800),
                      child: ColorTextButton(
                        'Siguiente',
                        color: SisVacuColor.verdefuerte,
                        onPressed: () {
                          mismoVacunador!
                              ? verificarVacunador()
                              // ignore: unnecessary_statements
                              : {
                                  vacunadorService.cargarVacunador(Vacunador(
                                      id_sysdesa12: registradorService
                                          .registrador!.flxcore03_dni,
                                      sysdesa06_nombre: registradorService
                                          .registrador!.flxcore03_nombre,
                                      sysdesa06_nro_documento:
                                          registradorService
                                              .registrador!.flxcore03_dni)),
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BusquedaBeneficiario()),
                                      (Route<dynamic> route) => false),
                                };
                        },
                        anchoValor: 220,
                        iconoBoton: const Icon(Icons.add_sharp),
                        iconoBool: false,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _infoVacunador(context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: vacunadorService.vacunadorStream,
      builder: (BuildContext context, AsyncSnapshot<Vacunador?> snapshot) {
        return snapshot.hasData
            ? Container()
            : Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.02,
                    left: MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: SisVacuColor.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TitulosContainerPage(
                        colorTitle: SisVacuColor.black,
                        sizeTitle: 18.0,
                        widthThickness: 1.5,
                        title: 'Registro Vacunador',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05),
                      const Text(
                        "Registre al vacunador escaneando el D.N.I.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05),
                      const EscanerDni(
                        'Vacunador',
                        'Escanear',
                        'Escanee el D.N.I. del Vacunador',
                        anchoValor: 180,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05),
                      const Text(
                        "Si el Vacunador NO tiene su D.N.I., ingréselo Manualmente",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05),
                      Column(children: [
                        SizedBox(
                          width: size.width * 0.8,
                          child: TextField(
                            controller: controladorDni,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            style: const TextStyle(color: Colors.blue),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.people),
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              labelText: 'Ingrese el DNI',
                            ),
                            onChanged: (valor) {},
                          ),
                        ),
                        ColorTextButton('Verificar',
                            iconoBoton: const Icon(
                              Icons.fingerprint,
                              color: Colors.black,
                            ),
                            color: SisVacuColor.verdefuerte,
                            iconoBool: true,
                            onPressed: () =>
                                verificarEscencialText(controladorDni.text),
                            anchoValor: 180.0)
                      ]),
                      const SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Future verificarVacunador() async {
    if (vacunadorService.existeVacunador) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BusquedaBeneficiario()),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogoAlerta(
                envioFuncion2: false,
                envioFuncion1: false,
                tituloAlerta: 'ATENCIÓN',
                descripcionAlerta:
                    'Escanee o Ingrese manualmente el D.N.I. del vacunador',
                textoBotonAlerta: 'Listo',
                color: Colors.red,
                icon: Icon(
                  Icons.new_releases_outlined,
                  size: 40.0,
                  color: Colors.grey[50],
                ),
              ));
    }
  }

  verificarEscencialText(String dni) async {
    final respUsuario = await vacunadorProviders.validarVacunador(dni);

    if (respUsuario == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogoAlerta(
                envioFuncion2: false,
                envioFuncion1: false,
                tituloAlerta: 'Error',
                descripcionAlerta:
                    'Puede que no esté habilitado como vacunador, pruebe nuevamente el escaneo, cambie el modo de ingreso o asignese el usuario vacunador en el sistema de gestión.',
                textoBotonAlerta: 'Listo',
                color: Colors.red,
                icon: Icon(
                  Icons.new_releases_outlined,
                  size: 40.0,
                  color: Colors.grey[50],
                ),
              ));
    } else {
      setState(() {
        vacunadorService.cargarVacunador(respUsuario[0]);
        estadoVacunador = true;
      });
    }
  }
}
