import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late TextEditingController controladorDni;
  late FocusNode focusNode;
  bool estadoVacunador = false;
  bool? animacionNombreVacunado;
  bool? mismoVacunador;
  bool? switchContainer;
  String? stringVacunador;

  @override
  void initState() {
    mismoVacunador = true;
    animacionNombreVacunado = false;
    switchContainer = false;
    stringVacunador = 'No';
    cargarEfectoresService(registradorService.registrador!.flxcore03_dni!);
    super.initState();
    controladorDni = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controladorDni.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            backgroundColor: SisVacuColor.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: SisVacuColor.vercelesteCuaternario,
              title: FadeInLeftBig(
                from: 50,
                child: Text(
                  'Sistema de Vacunación',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w400, color: SisVacuColor.white),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            drawer: const BodyDrawer(),
            body: Stack(
              children: [
                const EncabezadoWave(),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        duration: const Duration(milliseconds: 800),
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02,
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 10.0, left: 15.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      offset: const Offset(0, 5),
                                      blurRadius: 5)
                                ]),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Equipo de trabajo',
                                      style: GoogleFonts.barlow(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                DialogoAlerta(
                                                  envioFuncion2: false,
                                                  envioFuncion1: false,
                                                  tituloAlerta:
                                                      'Información Adicional',
                                                  descripcionAlerta:
                                                      'Seleccione el switch si es la misma persona que registra y realiza la vacunación.\nDe ser necesario, cambie el efector haciendo click en el icono',
                                                  textoBotonAlerta: 'Listo',
                                                  color: SisVacuColor
                                                      .vercelesteCuaternario,
                                                  icon: Icon(Icons.info,
                                                      size: 40.0,
                                                      color: Colors.grey[50]),
                                                ));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.infoCircle,
                                        color:
                                            SisVacuColor.vercelesteCuaternario,
                                      ),
                                      iconSize: 25,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: StreamBuilder(
                                            stream: registradorService
                                                .registradorStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              return Text(
                                                registradorService.registrador!
                                                    .sysofic01_descripcion!,
                                                style: GoogleFonts.nunito(),
                                                textAlign: TextAlign.center,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              useRootNavigator: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StreamBuilder(
                                                    stream: efectoresService
                                                        .listaEfectoresStream,
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<dynamic>
                                                            snapshot) {
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Efectores',
                                                              style: GoogleFonts.nunito(
                                                                  letterSpacing:
                                                                      1.5,
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: ListView
                                                                .builder(
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  efectoresService
                                                                      .listaEfectores!
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return ListTile(
                                                                  leading:
                                                                      FaIcon(
                                                                    FontAwesomeIcons
                                                                        .hospitalAlt,
                                                                    size: 20,
                                                                    color: SisVacuColor
                                                                        .vercelesteCuaternario,
                                                                  ),
                                                                  title:
                                                                      InkWell(
                                                                    highlightColor: SisVacuColor
                                                                        .vercelestePrimario!
                                                                        .withOpacity(
                                                                            0.3),
                                                                    onTap: () {
                                                                      registradorService
                                                                          .editarEfectorUsuario(
                                                                              efectoresService.listaEfectores![index]);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              context);
                                                                    },
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        efectoresService
                                                                            .listaEfectores![index]
                                                                            .sysofic01Descripcion!,
                                                                        style: GoogleFonts.nunito(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              });
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0, left: 15.0),
                                            child: FaIcon(
                                                FontAwesomeIcons.hospitalAlt,
                                                size: getValueForScreenType(
                                                    context: context,
                                                    mobile: 18),
                                                color: SisVacuColor
                                                    .vercelesteCuaternario))),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Registrador: ',
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          registradorService
                                              .registrador!.flxcore03_nombre!
                                              .toUpperCase(),
                                          style: GoogleFonts.nunito(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Vacunador: ',
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                                    style: GoogleFonts.nunito(),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                mismoVacunador!
                                                    ? 'Falta Asignar'
                                                    : registradorService
                                                        .registrador!
                                                        .flxcore03_nombre!,
                                                style: GoogleFonts.nunito(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          mismoVacunador!
                                                              ? FontWeight.w800
                                                              : FontWeight.w500,
                                                      color: mismoVacunador!
                                                          ? Colors.red
                                                          : SisVacuColor.black,
                                                      letterSpacing:
                                                          mismoVacunador!
                                                              ? 3.0
                                                              : 0.0),
                                                ));
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text(
                                              'Es el mismo vacunador?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Si',
                                                  style: GoogleFonts.nunito(
                                                      color: !mismoVacunador!
                                                          ? Colors.black87
                                                          : Colors.grey[300],
                                                      fontWeight:
                                                          !mismoVacunador!
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                  .w100),
                                                ),
                                                Switch(
                                                    activeColor:
                                                        SisVacuColor.red,
                                                    inactiveTrackColor:
                                                        SisVacuColor
                                                            .azulFormosa,
                                                    inactiveThumbColor:
                                                        SisVacuColor
                                                            .azulFormosa,
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
                                                Text(
                                                  'No',
                                                  style: GoogleFonts.nunito(
                                                      color: mismoVacunador!
                                                          ? Colors.black87
                                                          : Colors.grey[300],
                                                      fontWeight:
                                                          mismoVacunador!
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                  .w100),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                              })),
                      const SizedBox(
                        height: 20.0,
                      ),
                      mismoVacunador == false
                          ? Container()
                          : vacunadorService.existeVacunador
                              ? const SizedBox()
                              : FadeIn(
                                  duration: const Duration(milliseconds: 800),
                                  child: _infoVacunador(context)),
                      //Fin de Ocultar
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElasticIn(
                          duration: const Duration(milliseconds: 800),
                          child: BotonCustom(
                              text: 'Siguiente',
                              borderRadius: 20,
                              onPressed: () {
                                mismoVacunador!
                                    ? verificarVacunador()
                                    : {
                                        vacunadorService.cargarVacunador(
                                            Vacunador(
                                                id_sysdesa12: registradorService
                                                    .registrador!.flxcore03_dni,
                                                sysdesa06_nombre:
                                                    registradorService
                                                        .registrador!
                                                        .flxcore03_nombre,
                                                sysdesa06_nro_documento:
                                                    registradorService
                                                        .registrador!
                                                        .flxcore03_dni)),
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BusquedaBeneficiario()),
                                            (Route<dynamic> route) => false),
                                      };
                              })),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _infoVacunador(context) {
    return StreamBuilder(
      stream: vacunadorService.vacunadorStream,
      builder: (BuildContext context, AsyncSnapshot<Vacunador?> snapshot) {
        return vacunadorService.existeVacunador
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.02,
                    left: MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 10.0, left: 15.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 5),
                            blurRadius: 5)
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Registro vacunador',
                            style: GoogleFonts.barlow(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20)),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogoAlerta(
                                        envioFuncion2: false,
                                        envioFuncion1: false,
                                        tituloAlerta: 'Informacion',
                                        descripcionAlerta:
                                            'Registre al vacunador mediante el escaneo del codigo de barras, o ingresando manualmente el numero de D.N.I.',
                                        textoBotonAlerta: 'Listo',
                                        color:
                                            SisVacuColor.vercelesteCuaternario,
                                        icon: Icon(Icons.info,
                                            size: 40.0, color: Colors.grey[50]),
                                      ));
                            },
                            icon: Icon(
                              FontAwesomeIcons.infoCircle,
                              color: SisVacuColor.vercelesteCuaternario,
                            ),
                            iconSize: 25,
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05),
                      const EscanerDni(
                        'Vacunador',
                        'Escanear',
                        'Escanee el D.N.I. del Vacunador',
                        largoValor: 150,
                      ),
                      Column(children: [
                        const SizedBox(
                          height: 20.0,
                        ),

                        CustomInput(
                          autoFocus: true,
                          focusNode: focusNode,
                          icon: Icons.perm_identity,
                          placeholder: 'D.N.I.',
                          keyboardType: TextInputType.phone,
                          textController: controladorDni,
                          funcionTerminar: true,
                          funcion: () {
                            verificarEscencialText(controladorDni.text);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.03,
                        ),
                        // BotonCustom(
                        //     width: 150,
                        //     iconoBool: true,
                        //     iconoBoton: const Icon(
                        //       Icons.people,
                        //       color: Colors.white,
                        //     ),
                        //     text: 'Verificar',
                        //     onPressed: () {
                        //       // FocusScope.of(context).unfocus();
                        //     })
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
      controladorDni.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 2.0,
          backgroundColor: SisVacuColor.red!.withOpacity(0.7),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          content: Text(
            ':(',
            style: GoogleFonts.nunito(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w600, color: SisVacuColor.white)),
          )));
    } else {
      setState(() {
        vacunadorService.cargarVacunador(respUsuario[0]);
        estadoVacunador = true;
      });
      controladorDni.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 2.0,
          backgroundColor: SisVacuColor.vercelestePrimario,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          content: Text(
            'Se agrego al vacunador ',
            style: GoogleFonts.nunito(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w600, color: SisVacuColor.white)),
          )));
    }
  }

  Future<bool> onWillPop() async {
    final mensajeExit = await showDialog(
        context: context,
        builder: (context) => DialogoAlerta(
              envioFuncion2: true,
              envioFuncion1: true,
              tituloAlerta: 'ATENCIÓN',
              descripcionAlerta:
                  'Seguro que desea salir? debera logearse nuevamente',
              textoBotonAlerta: 'SI',
              textoBotonAlerta2: 'NO',
              funcion1: () => Navigator.of(context).pop(true),
              funcion2: () => Navigator.of(context).pop(false),
              color: Colors.red,
              icon: Icon(
                Icons.new_releases_outlined,
                size: 40.0,
                color: Colors.grey[50],
              ),
            ));
    return mensajeExit ?? false;
  }

  cargarEfectoresService(String dni) async {
    efectoresProviders.obtenerDatosEfectores(dni);
  }
}
