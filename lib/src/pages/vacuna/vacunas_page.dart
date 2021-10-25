import 'dart:convert';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class VacunasPage extends StatefulWidget {
  final List<InfoVacunas>? vacunas;
  const VacunasPage({
    Key? key,
    required this.vacunas,
  }) : super(key: key);
  static const String nombreRuta = 'VacunasPage';
  @override
  _VacunasPageState createState() => _VacunasPageState();
}

class _VacunasPageState extends State<VacunasPage>
    with SingleTickerProviderStateMixin {
  AnimationController? appBarIcon;

  InfoVacunas? _selectVacunas;
  List<ConfiVacuna>? listaConfiguraciones;
  ConfiVacuna? _selectConfigVacuna;
  List<Lotes>? listaLotes;
  Lotes? _selectLote;
  String uribeneficiario = beneficiarioService.beneficiario!.foto_beneficiario!;
  final TextEditingController controladorDni = TextEditingController();
  bool? genero;
  String? dniTutor;
  String? sexoTutor;
  Uint8List? fotoBeneficiario;
  Uint8List? noImage;

  List<Widget> listaWidget = [];

  @override
  void initState() {
    fotoBeneficiario = base64.decode(uribeneficiario.split(',').last);

    listaConfiguraciones = [];
    listaLotes = [];
    dniTutor = '';
    sexoTutor = 'F';
    genero = false;
    super.initState();
    appBarIcon = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            notificacionesDosisService.dosis!.codigo_mensaje != null
                ? Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: FloatingActionButton(
                            heroTag: 'boton1',
                            child: Icon(FontAwesomeIcons.exclamation,
                                size: getValueForScreenType(
                                    context: context, mobile: 18)),
                            mini: true,
                            onPressed: () {
                              dynamic diasRestantes = int.parse(
                                      notificacionesDosisService.dosis!
                                          .sysvacu03_tiempo_interdosis!) -
                                  int.parse(notificacionesDosisService
                                      .dosis!.dias_transcurridos!);
                              String? fechaProx = notificacionesDosisService
                                          .dosis!.fecha_proxima_dosis! !=
                                      "--"
                                  ? notificacionesDosisService
                                      .dosis!.fecha_proxima_dosis
                                  : 'Sin restricción';
                              diasRestantes = diasRestantes <= 0
                                  ? ' Sin restricción'
                                  : diasRestantes;
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogoAlerta(
                                        envioFuncion2: false,
                                        envioFuncion1: false,
                                        tituloAlerta: 'ATENCIÓN',
                                        descripcionAlerta:
                                            'Información sobre Dosis aplicadas: \n\n ${notificacionesDosisService.dosis!.sysvacu05_nombre} - ${notificacionesDosisService.dosis!.sysvacu04_nombre} \n\n Fecha aplicación: ${notificacionesDosisService.dosis!.sysdesa10_fecha_aplicacion} \n\n Proxima aplicación: $fechaProx \n\n Días restantes: $diasRestantes ',
                                        textoBotonAlerta: 'Listo',
                                        color: SisVacuColor.yelow700,
                                        icon: Icon(
                                          Icons.info,
                                          size: 40.0,
                                          color: SisVacuColor.grey,
                                        ),
                                      ));
                            }),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: Bounce(
                          animate: notificacionesDosisService.existeDosis
                              ? true
                              : false,
                          from: 10,
                          infinite: true,
                          duration: const Duration(milliseconds: 2000),
                          child: Container(
                            child: Text(
                              '1',
                              // notificacionesDosisService.existeDosis  ? '1' : null,
                              style: TextStyle(
                                  color: SisVacuColor.white, fontSize: 7),
                            ),
                            alignment: Alignment.center,
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            FloatingActionButton(
              heroTag: 'boton2',
              child: const Icon(Icons.info_outline),
              mini: true,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => DialogoAlerta(
                          envioFuncion2: false,
                          envioFuncion1: false,
                          tituloAlerta: 'Atención',
                          descripcionAlerta:
                              'Compruebe la integridad de los datos del beneficiario y pase a seleccionar la vacuna con la condición y el lote. Recuerde que cada vacuna respeta la configuración cargada en el Sistema WEB, si no encuentra la condición o lote, probablemente tenga que agregar la configuración ',
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
        appBar: AppBar(
          leading: Center(
            child: InkWell(
              onTap: () {
                if (appBarIcon!.isCompleted) {
                  appBarIcon!.reverse();
                } else {
                  appBarIcon!.forward();
                }
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const ListTile(
                        title: Text('Efectores'),
                      );
                    });
              },
              child: AnimatedIcon(
                progress: appBarIcon!,
                icon: AnimatedIcons.home_menu,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
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
        body: BackgroundHeader(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: const Offset(0, 5),
                              blurRadius: 5)
                        ],
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Datos Beneficiario',
                              style: GoogleFonts.barlow(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20)),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.14,
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                child: beneficiarioService
                                            .beneficiario!.foto_beneficiario !=
                                        ''
                                    ? Image.memory(fotoBeneficiario!)
                                    : Image.asset(
                                        'assets/img/fondo/noimage.jpg')),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Nombre: ',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                    Text(
                                        beneficiarioService
                                            .beneficiario!.sysdesa10_nombre!,
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02),
                                Row(
                                  children: [
                                    Text('Apellido: ',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                    Text(
                                        beneficiarioService
                                            .beneficiario!.sysdesa10_apellido!,
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.02),
                                Row(
                                  children: [
                                    Text('D.N.I.: ',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                    Text(
                                        beneficiarioService
                                            .beneficiario!.sysdesa10_dni!,
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0),
                                        ),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                StreamBuilder(
                  stream: tutorService.tutorStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.02,
                                left: MediaQuery.of(context).size.width * 0.02),
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
                                  color: SisVacuColor.white),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Datos Tutor',
                                        style: GoogleFonts.barlow(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.14,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.14,
                                          child: tutorService
                                                      .tutor!.fotoTutor !=
                                                  null
                                              ? tutorService.tutor!.fotoTutor!
                                                      .isNotEmpty
                                                  ? Image.memory(tutorService
                                                      .tutor!.fotoTutor!)
                                                  : Image.asset(
                                                      'assets/img/fondo/noimage.jpg')
                                              : Image.asset(
                                                  'assets/img/fondo/noimage.jpg')),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Nombre: ',
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0),
                                                  ),
                                                  textAlign: TextAlign.center),
                                              Text(
                                                  tutorService.tutor!
                                                      .sysdesa10_nombre_tutor!,
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.0),
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('Apellido: ',
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0),
                                                  ),
                                                  textAlign: TextAlign.center),
                                              Text(
                                                  tutorService.tutor!
                                                      .sysdesa10_apellido_tutor!,
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.0),
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('D.N.I.: ',
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0),
                                                  ),
                                                  textAlign: TextAlign.center),
                                              Text(
                                                  tutorService.tutor!
                                                      .sysdesa10_dni_tutor!,
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16.0),
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : verificarEdad(context);
                  },
                ),
                //CUANDO EL TUTORSERVICE TENGA DATOS
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
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: const Offset(0, 5),
                              blurRadius: 5)
                        ],
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Seleccione una vacuna',
                              style: GoogleFonts.barlow(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    _selectVacunas == null
                                        ? 'Seleccione'
                                        : _selectVacunas!.sysvacu04_nombre!,
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        fontSize: getValueForScreenType(
                                            context: context,
                                            mobile: 15,
                                            tablet: 20),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                const SizedBox(width: 5),
                                Icon(
                                  _selectVacunas == null
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_left,
                                  color: SisVacuColor.black,
                                ),
                              ],
                            ),
                            onTap: () {
                              (widget.vacunas == null)
                                  ? const Center(
                                      child: Text('Hubo un problema'),
                                    )
                                  : Picker(
                                      title: const Text(
                                        'Vacunas',
                                      ),
                                      itemExtent: 45,
                                      cancelText: "Cancelar",
                                      confirmText: 'Confirmar',
                                      adapter: PickerDataAdapter<InfoVacunas>(
                                        data: widget.vacunas!
                                            .map(
                                                (iv) => PickerItem<InfoVacunas>(
                                                      text: Center(
                                                          child: Text(iv
                                                              .sysvacu04_nombre!)),
                                                      value: iv,
                                                    ))
                                            .toList(),
                                      ),
                                      squeeze: 1,
                                      height: size.height * .2,
                                      onConfirm:
                                          (Picker picker, List value) async {
                                        PickerDataAdapter<InfoVacunas>
                                            pickerAdapter = picker.adapter
                                                as PickerDataAdapter<
                                                    InfoVacunas>;
                                        listaConfiguraciones!.clear();
                                        listaLotes!.clear();
                                        setState(() {
                                          _selectLote = null;
                                          _selectConfigVacuna = null;
                                          _selectVacunas = pickerAdapter
                                              .data[value.first].value;
                                        });
                                        final tempLista =
                                            await configuracionVacunaProvider
                                                .validarConfiguraciones(
                                                    _selectVacunas!
                                                        .id_sysvacu04);
                                                        
                                        tempLista[0].codigo_mensaje == "0"
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogoAlerta(
                                                      envioFuncion2: false,
                                                      envioFuncion1: false,
                                                      tituloAlerta: 'ATENCIÓN!',
                                                      descripcionAlerta:
                                                          tempLista[0].mensaje,
                                                      textoBotonAlerta: 'Listo',
                                                      icon: const Icon(
                                                        Icons.error_outline,
                                                        size: 40,
                                                      ),
                                                      color: Colors.red);
                                                })
                                            : setState(() {
                                                listaConfiguraciones =
                                                    tempLista;
                                              });
                                      }).showModal(context);
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                listaConfiguraciones!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                            left: MediaQuery.of(context).size.width * 0.02),
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
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Seleccione una condición',
                                    style: GoogleFonts.barlow(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _selectConfigVacuna == null
                                              ? 'Seleccione una Condición'
                                              : _selectConfigVacuna!
                                                      .sysvacu01_descripcion! +
                                                  '-' +
                                                  _selectConfigVacuna!
                                                      .sysvacu02_descripcion! +
                                                  '-' +
                                                  _selectConfigVacuna!
                                                      .sysvacu05_nombre!,
                                          style: TextStyle(
                                            fontSize: getValueForScreenType(
                                                context: context,
                                                mobile: 15,
                                                tablet: 20),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: SisVacuColor.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    (listaConfiguraciones == null)
                                        ? const Center(
                                            child: Text('Hubo un problema'),
                                          )
                                        : Picker(
                                            title: const Text(
                                              'Condiciones',
                                            ),
                                            itemExtent: 90,
                                            cancelText: "Cancelar",
                                            confirmText: 'Confirmar',
                                            adapter:
                                                PickerDataAdapter<ConfiVacuna>(
                                              data: listaConfiguraciones!
                                                  .map((iv) =>
                                                      PickerItem<ConfiVacuna>(
                                                        text: Center(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(iv
                                                                  .sysvacu05_nombre! +
                                                              '-' +
                                                              iv.sysvacu01_descripcion! +
                                                              '-' +
                                                              iv.sysvacu02_descripcion!),
                                                        )),
                                                        value: iv,
                                                      ))
                                                  .toList(),
                                            ),
                                            squeeze: 1,
                                            height: size.height * .2,
                                            onConfirm: (Picker picker,
                                                List value) async {
                                              PickerDataAdapter<ConfiVacuna>
                                                  pickerAdapter = picker.adapter
                                                      as PickerDataAdapter<
                                                          ConfiVacuna>;
                                              listaLotes!.clear();
                                              setState(() {
                                                _selectLote = null;
                                                _selectConfigVacuna =
                                                    pickerAdapter
                                                        .data[value.first]
                                                        .value!;
                                              });
                                              final tempLista =
                                                  await lotesVacunaProvider
                                                      .validarLotes(
                                                          _selectVacunas!
                                                              .id_sysvacu04!);
                                              tempLista[0].codigo_mensaje == "0"
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DialogoAlerta(
                                                            envioFuncion2:
                                                                false,
                                                            envioFuncion1:
                                                                false,
                                                            tituloAlerta:
                                                                'ATENCIÓN!',
                                                            descripcionAlerta:
                                                                tempLista[0]
                                                                    .mensaje,
                                                            textoBotonAlerta:
                                                                'Listo',
                                                            icon: const Icon(
                                                              Icons
                                                                  .error_outline,
                                                              size: 40,
                                                            ),
                                                            color: Colors.red);
                                                      })
                                                  : setState(() {
                                                      listaLotes = tempLista;
                                                    });
                                            }).showModal(context);
                                  }),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                listaLotes!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                            left: MediaQuery.of(context).size.width * 0.02),
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
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Seleccione un lote',
                                    style: GoogleFonts.barlow(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectLote == null
                                            ? 'Seleccione un Lote'
                                            : _selectLote!.sysdesa18_lote!,
                                        style: TextStyle(
                                          fontSize: getValueForScreenType(
                                              context: context,
                                              mobile: 15,
                                              tablet: 20),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: SisVacuColor.black,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    (listaLotes == null)
                                        ? const Center(
                                            child: Text('Hubo un problema'),
                                          )
                                        : Picker(
                                            title: const Text(
                                              'Lotes',
                                            ),
                                            itemExtent: 40,
                                            cancelText: "Cancelar",
                                            confirmText: 'Confirmar',
                                            adapter: PickerDataAdapter<Lotes>(
                                              data: listaLotes!
                                                  .map(
                                                      (iv) => PickerItem<Lotes>(
                                                            text: Center(
                                                                child: Text(iv
                                                                    .sysdesa18_lote!)),
                                                            value: iv,
                                                          ))
                                                  .toList(),
                                            ),
                                            squeeze: 1,
                                            height: size.height * .2,
                                            onConfirm:
                                                (Picker picker, List value) {
                                              PickerDataAdapter<Lotes>
                                                  pickerAdapter = picker.adapter
                                                      as PickerDataAdapter<
                                                          Lotes>;
                                              setState(() {
                                                _selectLote = pickerAdapter
                                                    .data[value.first].value!;
                                              });
                                            }).showModal(context);
                                  }),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                BotonCustom(
                    text: 'Registrar Vacunación',
                    onPressed: () {
                      beneficiarioService.beneficiario!.sysdesa10_dni != ''
                          ? int.parse(beneficiarioService
                                      .beneficiario!.sysdesa10_edad!) <
                                  18
                              ? tutorService.existeTutor
                                  ? tutorService.tutor!.sysdesa10_dni_tutor !=
                                          ''
                                      ? _selectVacunas != null
                                          ? _selectConfigVacuna != null
                                              ? _selectLote != null
                                                  // ignore: unnecessary_statements
                                                  ? {
                                                      insertRegistroService.cargarRegistro(
                                                          InsertRegistros(
                                                              id_flxcore03: registradorService
                                                                  .registrador!
                                                                  .id_flxcore03, //Obligatorio
                                                              id_sysdesa12: vacunadorService
                                                                  .vacunador!
                                                                  .id_sysdesa12, //Obligatorio
                                                              id_sysdesa18: _selectLote!
                                                                  .id_sysdesa18, //Obligatorio
                                                              id_sysofic01: registradorService
                                                                  .registrador!
                                                                  .rela_sysofic01, //Obligatorio
                                                              id_sysvacu03: _selectConfigVacuna!
                                                                  .id_sysvacu03, //Obligatorio
                                                              sysdesa10_apellido: beneficiarioService
                                                                  .beneficiario!
                                                                  .sysdesa10_apellido, //Obligatorio
                                                              sysdesa10_cadena_dni:
                                                                  beneficiarioService
                                                                      .beneficiario!
                                                                      .sysdesa10_cadena_dni, //Solo con Escaner
                                                              sysdesa10_dni: beneficiarioService
                                                                  .beneficiario!
                                                                  .sysdesa10_dni, //Obligatorio
                                                              sysdesa10_nombre: beneficiarioService
                                                                  .beneficiario!
                                                                  .sysdesa10_nombre, //Obligatorio
                                                              sysdesa10_nro_tramite:
                                                                  beneficiarioService
                                                                      .beneficiario!
                                                                      .sysdesa10_nro_tramite, //Solo con Escaner
                                                              sysdesa10_sexo: beneficiarioService.beneficiario!.sysdesa10_sexo, //Obligatorio
                                                              sysdesa10_edad: beneficiarioService.beneficiario!.sysdesa10_edad,
                                                              //DatosExtras que no se envian, SOlo para vista
                                                              nombreVacuna: _selectVacunas!.sysvacu04_nombre,
                                                              nombreConfiguracion: _selectConfigVacuna!.sysvacu05_nombre! + '-' + _selectConfigVacuna!.sysvacu01_descripcion! + '-' + _selectConfigVacuna!.sysvacu02_descripcion!,
                                                              nombreLote: _selectLote!.sysdesa18_lote,
                                                              sysdesa10_fecha_nacimiento: beneficiarioService.beneficiario!.sysdesa10_fecha_nacimiento,
                                                              vacunador_registrador: registradorService.registrador!.flxcore03_dni == vacunadorService.vacunador!.id_sysdesa12 ? '1' : '0',
                                                              sysdesa10_apellido_tutor: tutorService.tutor!.sysdesa10_apellido_tutor,
                                                              sysdesa10_dni_tutor: tutorService.tutor!.sysdesa10_dni_tutor,
                                                              sysdesa10_nombre_tutor: tutorService.tutor!.sysdesa10_nombre_tutor,
                                                              sysdesa10_sexo_tutor: tutorService.tutor!.sysdesa10_sexo_tutor)),
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ConfirmarDatos()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false)
                                                    }
                                                  : showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const DialogoAlerta(
                                                            envioFuncion2:
                                                                false,
                                                            envioFuncion1:
                                                                false,
                                                            tituloAlerta:
                                                                'ATENCIÓN!',
                                                            descripcionAlerta:
                                                                'Debe Seleccionar un Lote',
                                                            textoBotonAlerta:
                                                                'Listo',
                                                            icon: Icon(
                                                              Icons
                                                                  .error_outline,
                                                              size: 40,
                                                            ),
                                                            color: Colors.red);
                                                      })
                                              : showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const DialogoAlerta(
                                                        envioFuncion2: false,
                                                        envioFuncion1: false,
                                                        tituloAlerta:
                                                            'ATENCIÓN!',
                                                        descripcionAlerta:
                                                            'Debe Seleccionar una Configuración',
                                                        textoBotonAlerta:
                                                            'Listo',
                                                        icon: Icon(
                                                          Icons.error_outline,
                                                          size: 40,
                                                        ),
                                                        color: Colors.red);
                                                  })
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const DialogoAlerta(
                                                    envioFuncion2: false,
                                                    envioFuncion1: false,
                                                    tituloAlerta: 'ATENCIÓN!',
                                                    descripcionAlerta:
                                                        'Debe Seleccionar una Vacuna',
                                                    textoBotonAlerta: 'Listo',
                                                    icon: Icon(
                                                      Icons.error_outline,
                                                      size: 40,
                                                    ),
                                                    color: Colors.red);
                                              })
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const DialogoAlerta(
                                                envioFuncion2: false,
                                                envioFuncion1: false,
                                                tituloAlerta: 'ATENCIÓN!',
                                                descripcionAlerta:
                                                    'El beneficiario es menor de edad. Debe cargar los datos del Tutor',
                                                textoBotonAlerta: 'Listo',
                                                icon: Icon(
                                                  Icons.error_outline,
                                                  size: 40,
                                                ),
                                                color: Colors.red);
                                          })
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const DialogoAlerta(
                                            envioFuncion2: false,
                                            envioFuncion1: false,
                                            tituloAlerta: 'ATENCIÓN!',
                                            descripcionAlerta:
                                                'El beneficiario es menor de edad. Debe cargar los datos del Tutor',
                                            textoBotonAlerta: 'Listo',
                                            icon: Icon(
                                              Icons.error_outline,
                                              size: 40,
                                            ),
                                            color: Colors.red);
                                      })
                              : _selectVacunas != null
                                  ? _selectConfigVacuna != null
                                      ? _selectLote != null
                                          // ignore: unnecessary_statements
                                          ? {
                                              insertRegistroService.cargarRegistro(
                                                  InsertRegistros(
                                                      id_flxcore03: registradorService
                                                          .registrador!
                                                          .id_flxcore03, //Obligatorio
                                                      id_sysdesa12: vacunadorService
                                                          .vacunador!
                                                          .id_sysdesa12, //Obligatorio
                                                      id_sysdesa18: _selectLote!
                                                          .id_sysdesa18, //Obligatorio
                                                      id_sysofic01: registradorService
                                                          .registrador!
                                                          .rela_sysofic01, //Obligatorio
                                                      id_sysvacu03: _selectConfigVacuna!
                                                          .id_sysvacu03, //Obligatorio
                                                      sysdesa10_apellido:
                                                          beneficiarioService
                                                              .beneficiario!
                                                              .sysdesa10_apellido, //Obligatorio
                                                      sysdesa10_cadena_dni:
                                                          beneficiarioService
                                                              .beneficiario!
                                                              .sysdesa10_cadena_dni, //Solo con Escaner
                                                      sysdesa10_dni: beneficiarioService
                                                          .beneficiario!
                                                          .sysdesa10_dni, //Obligatorio
                                                      sysdesa10_nombre: beneficiarioService
                                                          .beneficiario!
                                                          .sysdesa10_nombre, //Obligatorio
                                                      sysdesa10_nro_tramite: beneficiarioService.beneficiario!.sysdesa10_nro_tramite, //Solo con Escaner
                                                      sysdesa10_sexo: beneficiarioService.beneficiario!.sysdesa10_sexo, //Obligatorio
                                                      sysdesa10_edad: beneficiarioService.beneficiario!.sysdesa10_edad,
                                                      //DatosExtras que no se envian, SOlo para vista
                                                      nombreVacuna: _selectVacunas!.sysvacu04_nombre,
                                                      nombreConfiguracion: _selectConfigVacuna!.sysvacu05_nombre! + '-' + _selectConfigVacuna!.sysvacu01_descripcion! + '-' + _selectConfigVacuna!.sysvacu02_descripcion!,
                                                      nombreLote: _selectLote!.sysdesa18_lote,
                                                      sysdesa10_fecha_nacimiento: beneficiarioService.beneficiario!.sysdesa10_fecha_nacimiento,
                                                      vacunador_registrador: registradorService.registrador!.flxcore03_dni == vacunadorService.vacunador!.id_sysdesa12 ? '1' : '0',
                                                      sysdesa10_apellido_tutor: '',
                                                      sysdesa10_dni_tutor: '',
                                                      sysdesa10_nombre_tutor: '',
                                                      sysdesa10_sexo_tutor: '')),
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ConfirmarDatos()),
                                                  (Route<dynamic> route) =>
                                                      false)
                                            }
                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const DialogoAlerta(
                                                    envioFuncion2: false,
                                                    envioFuncion1: false,
                                                    tituloAlerta: 'ATENCIÓN!',
                                                    descripcionAlerta:
                                                        'Debe Seleccionar un Lote',
                                                    textoBotonAlerta: 'Listo',
                                                    icon: Icon(
                                                      Icons.error_outline,
                                                      size: 40,
                                                    ),
                                                    color: Colors.red);
                                              })
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const DialogoAlerta(
                                                envioFuncion2: false,
                                                envioFuncion1: false,
                                                tituloAlerta: 'ATENCIÓN!',
                                                descripcionAlerta:
                                                    'Debe Seleccionar una Configuracion',
                                                textoBotonAlerta: 'Listo',
                                                icon: Icon(
                                                  Icons.error_outline,
                                                  size: 40,
                                                ),
                                                color: Colors.red);
                                          })
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const DialogoAlerta(
                                            envioFuncion2: false,
                                            envioFuncion1: false,
                                            tituloAlerta: 'ATENCIÓN!',
                                            descripcionAlerta:
                                                'Debe Seleccionar una Vacuna',
                                            textoBotonAlerta: 'Listo',
                                            icon: Icon(
                                              Icons.error_outline,
                                              size: 40,
                                            ),
                                            color: Colors.red);
                                      })
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DialogoAlerta(
                                    envioFuncion2: false,
                                    envioFuncion1: false,
                                    tituloAlerta: 'ATENCIÓN!',
                                    descripcionAlerta:
                                        'Hubo un error con el Beneficiario',
                                    textoBotonAlerta: 'Listo',
                                    icon: Icon(
                                      Icons.error_outline,
                                      size: 40,
                                    ),
                                    color: Colors.red);
                              });
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
                                    '¿Estás seguro que deseas cancelar el registro?',
                                textoBotonAlerta: 'Aceptar',
                                textoBotonAlerta2: 'Cancelar',
                                icon: Icon(
                                  Icons.error,
                                  size: 40,
                                  color: Colors.grey[50],
                                ),
                                color: Colors.red,
                                envioFuncion2: true,
                                funcion2: () => Navigator.of(context).pop(),
                                envioFuncion1: true,
                                funcion1: () {
                                  beneficiarioService
                                      .cargarBeneficiario(Beneficiario());
                                  notificacionesDosisService
                                      .cargarRegistro(NotificacionesDosis());
                                  tutorService.cargarTutor(Tutor(
                                      sysdesa10_apellido_tutor: '',
                                      sysdesa10_nombre_tutor: '',
                                      sysdesa10_dni_tutor: '',
                                      sysdesa10_sexo_tutor: '',
                                      fotoTutor: noImage));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BusquedaBeneficiario()),
                                      (Route<dynamic> route) => false);
                                },
                              ));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verificarEdad(context) {
    return int.parse(beneficiarioService.beneficiario!.sysdesa10_edad!) < 18
        ? Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.02,
                left: MediaQuery.of(context).size.width * 0.02),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                    title: 'Datos del Tutor',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  const Text(
                    "Escanee el Dni del Tutor",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  const EscanerDni(
                    'Tutor',
                    'Escanear',
                    'Escanee el D.N.I. del Tutor',
                    anchoValor: 180,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  const Text(
                    "Si el Tutor NO tiene su D.N.I., ingréselo Manualmente",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  Column(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
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
                    const Text('Seleccione el Sexo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.center),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Femenino'),
                        Switch(
                            activeColor: Colors.blue,
                            inactiveTrackColor: Colors.pink,
                            inactiveThumbColor: Colors.pink,
                            value: genero!,
                            onChanged: (value) {
                              setState(() {
                                genero = value;
                                genero! ? sexoTutor = 'M' : sexoTutor = 'F';
                              });
                            }),
                        const Text('Masculino'),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ColorTextButton('Verificar',
                        iconoBoton: const Icon(
                          Icons.fingerprint,
                          color: Colors.black,
                        ),
                        color: SisVacuColor.verdefuerte,
                        iconoBool: true, onPressed: () {
                      controladorDni.text.length >= 7
                          ? obtenerDatosBeneficiario(
                              context, controladorDni.text, sexoTutor!)
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogoAlerta(
                                    envioFuncion2: false,
                                    envioFuncion1: false,
                                    tituloAlerta: 'Hubo un Error',
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
                    }, anchoValor: 180.0)
                  ]),
                ],
              ),
            ),
          )
        : Container();
  }

  obtenerDatosBeneficiario(
      BuildContext context1, String dni, String sexoPersona) async {
    //Provider con Datos del Beneficiario
    //Cargo Datos de Beneficiario en Singleton, y envio parametros EDAD + DNI para recibir la lista de VACUNAS
    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario('', dni, sexoPersona);
    datosBeneficiario == 0
        ? showDialog(
            context: context,
            builder: (BuildContext context) => DialogoAlerta(
                  envioFuncion2: false,
                  envioFuncion1: false,
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
        : confirmarTutor(datosBeneficiario[0]);
  }

  void confirmarTutor(Beneficiario tutor) async {
    String uriTutor = tutor.foto_beneficiario!;
    Tutor tutorS = Tutor(
        sysdesa10_apellido_tutor: tutor.sysdesa10_apellido,
        sysdesa10_nombre_tutor: tutor.sysdesa10_nombre,
        sysdesa10_dni_tutor: tutor.sysdesa10_dni,
        sysdesa10_sexo_tutor: tutor.sysdesa10_sexo,
        fotoTutor: base64.decode(uriTutor.split(',').last));
    setState(() {
      tutorService.cargarTutor(tutorS);
    });
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
}
