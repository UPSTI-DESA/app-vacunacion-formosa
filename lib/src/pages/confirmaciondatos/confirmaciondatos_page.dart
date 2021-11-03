import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/insertregistro_service.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/headers_widgets.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class ConfirmarDatos extends StatefulWidget {
  const ConfirmarDatos({
    Key? key,
  }) : super(key: key);
  static const String nombreRuta = 'ConfirmarDatos';
  @override
  _ConfirmarDatosState createState() => _ConfirmarDatosState();
}

class _ConfirmarDatosState extends State<ConfirmarDatos> {
  late bool habilitarCircular;
  @override
  void initState() {
    habilitarCircular = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                        'Última instancia para comprobar los datos del beneficiario y los datos de la vacuna. Registre la vacunación de ser válidos los datos, de lo contrario cancele y vuelva a empezar.',
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: SisVacuColor.vercelesteCuaternario,
        title: FadeInLeftBig(
          from: 50,
          child: Text(
            'Sistema de Vacunación',
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.white),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Stack(
        children: [
          const EncabezadoWave(),
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TitulosContainerPage(
                              colorTitle: SisVacuColor.black,
                              sizeTitle: 18.0,
                              widthThickness: 1.5,
                              title: 'Datos Beneficiario',
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.05),
                            Row(
                              children: [
                                const Text('Nombre: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        insertRegistroService
                                            .registro!.sysdesa10_nombre!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.02),
                            Row(
                              children: [
                                const Text('Apellido: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        insertRegistroService
                                            .registro!.sysdesa10_apellido!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.02),
                            Row(
                              children: [
                                const Text('D.N.I.: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        insertRegistroService
                                            .registro!.sysdesa10_dni!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    tutorService.existeTutor
                        ? tutorService.tutor!.sysdesa10_dni_tutor == ''
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Container(),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TitulosContainerPage(
                                        colorTitle: SisVacuColor.black,
                                        sizeTitle: 18.0,
                                        widthThickness: 1.5,
                                        title: 'Datos Tutor',
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Row(
                                        children: [
                                          const Text('Nombre: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!
                                                      .sysdesa10_nombre_tutor!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      Row(
                                        children: [
                                          const Text('Apellido: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!
                                                      .sysdesa10_apellido_tutor!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      Row(
                                        children: [
                                          const Text('D.N.I.: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!
                                                      .sysdesa10_dni_tutor!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16.0),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.02,
                                left: MediaQuery.of(context).size.width * 0.02),
                            child: Container(),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TitulosContainerPage(
                              colorTitle: SisVacuColor.black,
                              sizeTitle: 18.0,
                              widthThickness: 1.5,
                              title: 'Datos Vacuna',
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.05),
                            Row(
                              children: [
                                const Text('Vacuna: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.start),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        insertRegistroService
                                            .registro!.nombreVacuna!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.start),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.02),
                            Row(
                              children: [
                                const Text('Configuración: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.start),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        insertRegistroService
                                            .registro!.nombreConfiguracion!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.02),
                            Row(
                              children: [
                                const Text('Lote: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        insertRegistroService
                                            .registro!.nombreLote!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    BotonCustom(
                        text: 'Registrar Vacunación',
                        onPressed: () {
                          enviarDatos(context);
                        }),
                    BotonCustom(
                        text: 'Cancelar Registro',
                        color: SisVacuColor.red,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogoAlerta(
                                    tituloAlerta: "Atención",
                                    descripcionAlerta:
                                        '¿Estas seguro que deseas cancelar el registro?',
                                    textoBotonAlerta: 'Aceptar',
                                    textoBotonAlerta2: 'Cancelar',
                                    icon: Icon(
                                      Icons.info,
                                      size: 40,
                                      color: SisVacuColor.white,
                                    ),
                                    color: Colors.red,
                                    envioFuncion2: true,
                                    funcion2: () => Navigator.of(context).pop(),
                                    envioFuncion1: true,
                                    funcion1: () {
                                      tutorService.cargarTutor(Tutor(
                                          sysdesa10_apellido_tutor: '',
                                          sysdesa10_nombre_tutor: '',
                                          sysdesa10_dni_tutor: '',
                                          sysdesa10_sexo_tutor: '',
                                          fotoTutor: null));
                                      beneficiarioService
                                          .cargarBeneficiario(Beneficiario());
                                      notificacionesDosisService
                                          .eliminarListaDosis();
                                      insertRegistroService
                                          .cargarRegistro(InsertRegistros());
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BusquedaBeneficiario()),
                                          (Route<dynamic> route) => false);
                                    },
                                  ));
                        }),
                  ],
                ),
                habilitarCircular
                    ? Container(
                        height: size.height,
                        width: size.width,
                        color: Colors.black.withOpacity(0.8),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              Text(
                                'Espere porfavor...',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  enviarDatos(BuildContext context2) async {
    setState(() {
      habilitarCircular = true;
    });
    final mensaje = await insertRegistroProvider.insertRegistroProd();
    setState(() {
      habilitarCircular = false;
    });
    mensaje[0].codigo_mensaje == "0"
        ? showDialog(
            context: context,
            builder: (BuildContext context) => DialogoAlerta(
                  envioFuncion2: false,
                  envioFuncion1: false,
                  funcion1: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfirmarDatos()),
                      (Route<dynamic> route) => false),
                  tituloAlerta: 'Atención',
                  descripcionAlerta: mensaje[0].mensaje,
                  textoBotonAlerta: 'Reintentar',
                  color: Colors.red,
                  icon: Icon(
                    Icons.error,
                    size: 40.0,
                    color: Colors.grey[50],
                  ),
                ))
        : showDialog(
            context: context,
            builder: (BuildContext context) => DialogoAlerta(
                  envioFuncion2: false,
                  envioFuncion1: true,
                  funcion1: () => Navigator.pushAndRemoveUntil(
                      //ELIMINAR DATOS DE SINGLETONS
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BusquedaBeneficiario()),
                      (Route<dynamic> route) => false),
                  tituloAlerta: 'Informacion',
                  descripcionAlerta: mensaje[0].mensaje,
                  textoBotonAlerta: 'Listo',
                  color: Colors.green,
                  icon: const Icon(
                    Icons.check_circle,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ));
  }
}
