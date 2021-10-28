import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/services/vacunadoscant_service.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

import '../pages.dart';

class BusquedaBeneficiario extends StatefulWidget {
  const BusquedaBeneficiario({Key? key}) : super(key: key);
  static const String nombreRuta = 'BusquedaBeneficiario';

  @override
  _BusquedaBeneficiarioState createState() => _BusquedaBeneficiarioState();
}

class _BusquedaBeneficiarioState extends State<BusquedaBeneficiario> {
  late bool genero;
  late bool modo;
  bool loading = false;
  String? dniBeneficiario;
  String? sexoBeneficiario;
  TextEditingController? dniController;

  @override
  void initState() {
    genero = false;
    modo = false;
    dniBeneficiario = '';
    sexoBeneficiario = 'F';
    dniController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int duracionAnimacion = 1000;

    int duracionDelay = 0;

    _incrementoVacunados();

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: const BodyDrawer(),
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
          actions: [
            Bounce(
              from: 10,
              infinite: true,
              duration: const Duration(milliseconds: 2000),
              child: Container(
                child: StreamBuilder(
                  stream: cantidadVacunasService.cantidadvacunadosStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Text(
                        cantidadVacunasService
                            .cantidadvacunados!.cantidad_aplicaciones!,
                        style: TextStyle(
                            color: SisVacuColor.white,
                            fontSize: getValueForScreenType(
                                context: context, mobile: 15)),
                      );
                    }
                  },
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        // drawer: BodyDrawer(),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: FloatingActionButton(
                      heroTag: 'boton1',
                      child: const Icon(FontAwesomeIcons.syringe),
                      mini: true,
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogoAlerta(
                                  envioFuncion2: false,
                                  envioFuncion1: false,
                                  tituloAlerta: 'Información Vacuna',
                                  descripcionAlerta:
                                      'Muy pronto Historial de vacunados',
                                  textoBotonAlerta: 'Listo',
                                  color: SisVacuColor.orange,
                                  icon: Icon(
                                    FontAwesomeIcons.info,
                                    size: getValueForScreenType(
                                        context: context, mobile: 30),
                                    color: SisVacuColor.white,
                                  ),
                                ));
                        _incrementoVacunados();
                      }),
                ),
                // Positioned(
                //   // top: 0.0,
                //   right: 2.0,
                //   child: Bounce(
                //     from: 10,
                //     infinite: true,
                //     duration: const Duration(milliseconds: 2000),
                //     child: Container(
                //       child: StreamBuilder(
                //         stream: cantidadVacunasService.cantidadvacunadosStream,
                //         builder: (BuildContext context, AsyncSnapshot snapshot) {
                //           if (snapshot.connectionState ==
                //               ConnectionState.waiting) {
                //             return const Center(
                //                 child: CircularProgressIndicator());
                //           } else {
                //             return Text(
                //               '100',
                //               style: TextStyle(
                //                   color: SisVacuColor.white,
                //                   fontSize: getValueForScreenType(
                //                       context: context, mobile: 15)),
                //             );
                //           }
                //         },
                //       ),
                //       alignment: Alignment.center,
                //       width: MediaQuery.of(context).size.width * 0.1,
                //       height: MediaQuery.of(context).size.height * 0.1,
                //       decoration: const BoxDecoration(
                //           color: Colors.redAccent, shape: BoxShape.circle),
                //     ),
                //   ),
                // )
              ],
            ),
          ],
        ),

        body: BackgroundHeader(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    modo
                        ? Container()
                        : FadeInLeft(
                            duration: Duration(milliseconds: duracionAnimacion),
                            delay: Duration(milliseconds: duracionDelay),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.02,
                                  left:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 5.0,
                                    right: 10.0,
                                    left: 15.0,
                                    bottom: 5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          offset: const Offset(0, 5),
                                          blurRadius: 5)
                                    ],
                                    color: Colors.white),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        FadeInUpBig(
                                          from: 25,
                                          child: Text(
                                            'Modo Escaner',
                                            style: GoogleFonts.barlow(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20)),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4),
                                        FadeInDownBig(
                                          from: 25,
                                          child: IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      DialogoAlerta(
                                                        envioFuncion2: false,
                                                        envioFuncion1: false,
                                                        tituloAlerta:
                                                            'Información',
                                                        descripcionAlerta:
                                                            'Si el beneficiario posee su dni presione el botón "Escanear", enfoque la cámara al código de barras. Si no posee su D.N.I., tipeelo en el campo manual y seleccione el sexo',
                                                        textoBotonAlerta:
                                                            'Listo',
                                                        color: SisVacuColor
                                                            .yelow700,
                                                        icon: Icon(
                                                          Icons.info,
                                                          size: 40.0,
                                                          color:
                                                              SisVacuColor.grey,
                                                        ),
                                                      ));
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.infoCircle,
                                              color:
                                                  SisVacuColor.azulSecundario,
                                            ),
                                            iconSize: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Text(
                                        'Escanee el código  de barras del D.N.I. del beneficiario',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    const EscanerDni(
                                      'Beneficiario',
                                      'Escanee',
                                      "textoAyuda",
                                      anchoValor: 40,
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    modo
                        ? FadeInRight(
                            duration: Duration(milliseconds: duracionAnimacion),
                            delay: Duration(milliseconds: duracionDelay),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.02,
                                  left:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          offset: const Offset(0, 5),
                                          blurRadius: 5)
                                    ],
                                    color: Colors.white),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        FadeInUpBig(
                                          from: 25,
                                          child: Text(
                                            'Modo ingreso manual',
                                            style: GoogleFonts.barlow(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Text(
                                        'Ingrese el número de D.N.I. del beneficiario y seleccione el sexo',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: TextField(
                                        controller: dniController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 8,
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.fingerprint),
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          labelText: 'Ingrese el DNI',
                                        ),
                                        onChanged: (valor) {
                                          setState(() {
                                            dniBeneficiario = valor;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Text('Seleccione el Sexo',
                                        style: GoogleFonts.barlow(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Femenino',
                                          style: GoogleFonts.nunito(
                                              color: !genero
                                                  ? Colors.black87
                                                  : Colors.grey[300],
                                              fontWeight: !genero
                                                  ? FontWeight.w700
                                                  : FontWeight.w100),
                                        ),
                                        Switch(
                                            activeColor: Colors.blue,
                                            inactiveTrackColor: Colors.pink,
                                            inactiveThumbColor: Colors.pink,
                                            value: genero,
                                            onChanged: (value) {
                                              setState(() {
                                                genero = value;
                                                genero
                                                    ? sexoBeneficiario = 'M'
                                                    : sexoBeneficiario = 'F';
                                              });
                                            }),
                                        Text(
                                          'Masculino',
                                          style: GoogleFonts.nunito(
                                              color: genero
                                                  ? Colors.black87
                                                  : Colors.grey[300],
                                              fontWeight: genero
                                                  ? FontWeight.w700
                                                  : FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    BotonCustom(
                                        text: 'Verificar',
                                        onPressed: () {
                                          final dniOk = dniBeneficiario != '' &&
                                              dniBeneficiario!.length >= 7 &&
                                              dniBeneficiario != null;

                                          (dniOk)
                                              ? showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DialogoAlerta(
                                                      tituloAlerta:
                                                          'Verificar Datos',
                                                      descripcionAlerta:
                                                          'D.N.I.: $dniBeneficiario , Sexo: $sexoBeneficiario',
                                                      textoBotonAlerta:
                                                          'Verificar',
                                                      textoBotonAlerta2:
                                                          'Cancelar',
                                                      funcion1: () {
                                                        obtenerDatosBeneficiario(
                                                            context,
                                                            dniBeneficiario,
                                                            sexoBeneficiario);
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          loading = true;
                                                        });

                                                        retornarLoading(context,
                                                            'Espere por favor');
                                                      },
                                                      funcion2: () {
                                                        Navigator.pop(context);
                                                      },
                                                      envioFuncion1: true,
                                                      envioFuncion2: true,
                                                      icon: const Icon(
                                                        FontAwesomeIcons.check,
                                                        color: Colors.white,
                                                      ),
                                                      color:
                                                          SisVacuColor.yelow700,
                                                    );
                                                  })
                                              : showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      DialogoAlerta(
                                                        envioFuncion2: false,
                                                        envioFuncion1: false,
                                                        tituloAlerta:
                                                            'Hubo un Error',
                                                        descripcionAlerta:
                                                            'Ingrese el D.N.I. y seleccione el sexo.',
                                                        textoBotonAlerta:
                                                            'Listo',
                                                        color: Colors.red,
                                                        icon: Icon(
                                                          Icons.error,
                                                          size: 40.0,
                                                          color:
                                                              Colors.grey[50],
                                                        ),
                                                      ));
                                        })
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Modo Escaner',
                          style: GoogleFonts.nunito(
                              color: !modo ? Colors.black87 : Colors.grey[300],
                              fontWeight:
                                  !modo ? FontWeight.w700 : FontWeight.w100),
                        ),
                        Switch(
                            activeColor: Colors.orange,
                            inactiveTrackColor: Colors.purple,
                            inactiveThumbColor: Colors.purple,
                            value: modo,
                            onChanged: (value) {
                              setState(() {
                                modo = value;
                                dniBeneficiario = '';
                                dniController!.text = '';
                              });
                            }),
                        Text(
                          'Modo Manual',
                          style: GoogleFonts.nunito(
                              color: modo ? Colors.black87 : Colors.grey[300],
                              fontWeight:
                                  modo ? FontWeight.w700 : FontWeight.w100),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  obtenerDatosBeneficiario(
      BuildContext context1, String? dni, String? sexoPersona) async {
    //Provider con Datos del Beneficiario
    //Cargo Datos de Beneficiario en Singleton, y envio parametros EDAD + DNI para recibir la lista de VACUNAS
    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario('', dni, sexoPersona);
    final notificaciones =
        await notificacionesProvider.validarNotificaciones(dni, sexoPersona);
    notificaciones[0].codigo_mensaje == '1'
        ? {
            notificacionesDosisService.cargarRegistro(notificaciones[0]),
            //Provider.of<ModeloNotificacion>(context, listen: false).numero = 1
          }
        : notificacionesDosisService.cargarRegistro(NotificacionesDosis());
    //Provider.of<ModeloNotificacion>(context, listen: false).numero = ;

    datosBeneficiario == 0
        ? showDialog(
            context: context,
            builder: (BuildContext context) => DialogoAlerta(
                  envioFuncion2: false,
                  envioFuncion1: true,
                  funcion1: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BusquedaBeneficiario()),
                        (Route<dynamic> route) => false);
                  },
                  tituloAlerta: 'Hubo un Error',
                  descripcionAlerta:
                      'El D.N.I. o Sexo de la persona es incorrecto, verifique y vuelva a intentarlo',
                  textoBotonAlerta: 'Listo',
                  color: Colors.red,
                  icon: Icon(
                    Icons.error,
                    size: 40.0,
                    color: Colors.grey[50],
                  ),
                ))
        : confirmarBeneficiario(datosBeneficiario[0]);
  }

  void confirmarBeneficiario(Beneficiario? beneficiario) async {
    setState(() {
      beneficiarioService.cargarBeneficiario(beneficiario);
    });

    final listaVacunas = await infoVacunasProviers.validarVacunas();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => VacunasPage(
                  vacunas: listaVacunas,
                )),
        (Route<dynamic> route) => false);
  }

  void retornarLoading(BuildContext context, String mensaje) {
    loading
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text(
                    mensaje,
                    style: GoogleFonts.nunito(),
                  ),
                  content: const LinearProgressIndicator());
            })
        : Container();
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

  _incrementoVacunados() async {
    final cantidadVacunas = await cantidadVacunadosProvider.cantidadVacunas();

    cantidadVacunasService.cargarCantidadVacunados(cantidadVacunas[0]);
  }
}
