import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/services/vacunadoscant_service.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

import '../pages.dart';

class BusquedaBeneficiario extends StatefulWidget {
  BusquedaBeneficiario({Key? key}) : super(key: key);
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

    // _incrementoVacunados();

    return Scaffold(
      drawer: BodyDrawer(),
      appBar: AppBar(
        backgroundColor: SisVacuColor.verdefuerte,
        centerTitle: true,
        title: FadeInRightBig(
          from: 50,
          child: Text(
            'Sistema de Vacunación',
            style: TextStyle(fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // drawer: BodyDrawer(),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: FloatingActionButton(
                    heroTag: 'boton1',
                    child: Icon(FontAwesomeIcons.syringe),
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
                      // _incrementoVacunados();
                    }),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: Bounce(
                  // animate:
                  //     notificacionesDosisService.existeDosis ? true : false,
                  from: 10,
                  infinite: true,
                  duration: Duration(milliseconds: 2000),
                  child: Container(
                    child: StreamBuilder(
                      stream: cantidadVacunasService.cantidadvacunadosStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
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
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                  ),
                ),
              )
            ],
          ),
          FloatingActionButton(
            heroTag: 'boton2',
            child: Icon(FontAwesomeIcons.exclamation,
                size: getValueForScreenType(context: context, mobile: 18)),
            mini: true,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogoAlerta(
                        envioFuncion2: false,
                        envioFuncion1: false,
                        tituloAlerta: 'Información',
                        descripcionAlerta:
                            'Si el beneficiario posee su dni presione el botón "Escanear", enfoque la cámara al código de barras. Si no posee su D.N.I., tipeelo en el campo manual y seleccione el sexo',
                        textoBotonAlerta: 'Listo',
                        color: SisVacuColor.yelow700,
                        icon: Icon(
                          Icons.info,
                          size: 40.0,
                          color: SisVacuColor.grey,
                        ),
                      ));
            },
          ),
        ],
      ),

      body: BackgroundHeader(
        child: Container(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
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
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: SisVacuColor.white),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TitulosContainerPage(
                                        colorTitle: SisVacuColor.black,
                                        sizeTitle: 18.0,
                                        widthThickness: 1.5,
                                        title: 'Modo Escaner',
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Text(
                                          'Escanee el código  de barras del D.N.I. del beneficiario',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.center),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      EscanerDni(
                                        'Beneficiario',
                                        'Escanee',
                                        "textoAyuda",
                                        anchoValor: 180,
                                      )
                                    ],
                                  ),
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
                                    color: SisVacuColor.white),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TitulosContainerPage(
                                      colorTitle: SisVacuColor.black,
                                      sizeTitle: 18.0,
                                      widthThickness: 1.5,
                                      title: 'Modo Ingreso Manual',
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Text(
                                        'Ingrese el número de D.N.I. del beneficiario y seleccione el sexo',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0),
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
                                        style: TextStyle(color: Colors.blue),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.fingerprint),
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          labelText: 'Ingrese el DNI',
                                        ),
                                        onChanged: (valor) {
                                          setState(() {
                                            dniBeneficiario = valor;
                                          });
                                          print(dniBeneficiario);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Container(
                                      child: Text('Seleccione el Sexo',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.center),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Femenino'),
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
                                              print(sexoBeneficiario);
                                            }),
                                        Text('Masculino'),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    ColorTextButton(
                                      'Verificar',
                                      color: SisVacuColor.verdefuerte,
                                      onPressed: () {
                                        dniBeneficiario != '' &&
                                                dniBeneficiario!.length >= 7 &&
                                                dniBeneficiario != null
                                            ? showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Center(
                                                        child: Text(
                                                            "Verificar Datos")),
                                                    content: Text(
                                                        "D.N.I.: $dniBeneficiario , Sexo: $sexoBeneficiario"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            obtenerDatosBeneficiario(
                                                                context,
                                                                dniBeneficiario,
                                                                sexoBeneficiario);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              loading = true;
                                                            });

                                                            retornarLoading(
                                                                context,
                                                                'Espere por favor');
                                                          },
                                                          child:
                                                              Icon(Icons.send))
                                                    ],
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
                                                      textoBotonAlerta: 'Listo',
                                                      color: Colors.red,
                                                      icon: Icon(
                                                        Icons.error,
                                                        size: 40.0,
                                                        color: Colors.grey[50],
                                                      ),
                                                    ));
                                      },
                                      anchoValor: 180,
                                      iconoBoton: Icon(Icons.add_sharp),
                                      iconoBool: false,
                                    ),
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
                        Text('Modo Escaner'),
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
                        Text('Modo Manual'),
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
        // ignore: unnecessary_statements
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
                            builder: (context) => BusquedaBeneficiario()),
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
                  ),
                  content: LinearProgressIndicator());
            })
        : Container();
  }

  // _incrementoVacunados() async {
  //   final cantidadVacunas = await cantidadVacunados.cantidadVacunas();

  //   cantidadVacunasService.cargarCantidadVacunados(cantidadVacunas[0]);
  //   print(cantidadVacunasService.cantidadvacunados!.cantidad_aplicaciones);
  // }
}
