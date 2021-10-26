import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/providers/efectores_providers.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/efectores_servide.dart';
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

class _VacunadorPageState extends State<VacunadorPage>
    with SingleTickerProviderStateMixin {
  AnimationController? animacionIcono;

  final controladorDni = TextEditingController();
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

    animacionIcono = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
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
              backgroundColor: SisVacuColor.azulCuaternario,
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
            body: SafeArea(
              child: BackgroundHeader(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Equipo de trabajo',
                            style: GoogleFonts.barlow(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20)),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogoAlerta(
                                        envioFuncion2: false,
                                        envioFuncion1: false,
                                        tituloAlerta: 'Información Adicional',
                                        descripcionAlerta:
                                            'Seleccione el switch si es la misma persona que registra y realiza la vacunación.',
                                        textoBotonAlerta: 'Listo',
                                        color: SisVacuColor.azulTerciario,
                                        icon: Icon(Icons.info,
                                            size: 40.0, color: Colors.grey[50]),
                                      ));
                            },
                            icon: Icon(
                              FontAwesomeIcons.infoCircle,
                              color: SisVacuColor.azulSecundario,
                            ),
                            iconSize: 25,
                          ),
                        ],
                      ),
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
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.05),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            registradorService.registrador!
                                                .sysofic01_descripcion!,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (animacionIcono!.isCompleted) {
                                          animacionIcono!.reverse();
                                        } else {
                                          animacionIcono!.forward();
                                        }
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StreamBuilder(
                                                  stream: efectoresService
                                                      .listaEfectoresStream,
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                    return ListView.builder(
                                                      itemCount:
                                                          efectoresService
                                                              .listaEfectores!
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Text(efectoresService
                                                            .listaEfectores![
                                                                index]
                                                            .sysofic01Descripcion!);
                                                      },
                                                    );
                                                  });
                                            });
                                      },
                                      child: AnimatedIcon(
                                        progress: animacionIcono!,
                                        icon: AnimatedIcons.menu_home,
                                        size: 20,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Registrador: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Vacunador: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                                    letterSpacing:
                                                        mismoVacunador!
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
              ),
            ),
          ),
        ));
  }

  Widget _infoVacunador(context) {
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
                                        color: SisVacuColor.azulCuaternario,
                                        icon: Icon(Icons.info,
                                            size: 40.0, color: Colors.grey[50]),
                                      ));
                            },
                            icon: Icon(
                              FontAwesomeIcons.infoCircle,
                              color: SisVacuColor.azulSecundario,
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
                          icon: Icons.perm_identity,
                          placeholder: 'D.N.I.',
                          keyboardType: TextInputType.phone,
                          textController: controladorDni,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.03,
                        ),
                        BotonCustom(
                            width: 150,
                            iconoBool: true,
                            iconoBoton: const Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            text: 'Verificar',
                            onPressed: () {
                              // FocusScope.of(context).unfocus();
                              verificarEscencialText(controladorDni.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      elevation: 2.0,
                                      backgroundColor:
                                          SisVacuColor.azulTerciario,
                                      behavior: SnackBarBehavior.floating,
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      content: Text(
                                        'Se agrego al vacunador ',
                                        style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: SisVacuColor.white)),
                                      )));
                            })
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
