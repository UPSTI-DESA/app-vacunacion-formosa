import 'dart:convert';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/providers/vacunas/perfilesvacunacion_providers.dart';
import 'package:sistema_vacunacion/src/services/loadingLogin_service.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/headers_widgets.dart';
import 'package:sistema_vacunacion/src/widgets/loading_x_tiempo_widget.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class VacunasPage extends StatefulWidget {
  const VacunasPage({
    Key? key,
  }) : super(key: key);
  static const String nombreRuta = 'VacunasPage';
  @override
  _VacunasPageState createState() => _VacunasPageState();
}

class _VacunasPageState extends State<VacunasPage> {
  VacunasxPerfil? _selectVacunas;
  PerfilesVacunacion? _selectPerfil;
  List<InfoVacunas>? listaVacunas;
  List<ConfiVacuna>? listaConfiguraciones;
  ConfiVacuna? _selectConfigVacuna;
  List<Lotes>? listaLotes;
  Lotes? _selectLote;
  String uribeneficiario = beneficiarioService.beneficiario!.foto_beneficiario!;
  final TextEditingController controladorDni = TextEditingController();
  final TextEditingController controladorBusqueda = TextEditingController();
  final TextEditingController controladorBusquedaConfig =
      TextEditingController();
  final TextEditingController controladorBusquedaLotes =
      TextEditingController();
  late FocusNode focusNode;
  late bool genero;
  String? dniTutor;
  String? sexoTutor;
  Uint8List? fotoBeneficiario;
  Uint8List? noImage;

  List<Widget> listaWidget = [];

  // Future scrollToItem(int index) async {
  //   itemController.scrollTo(
  //       index: index, duration: const Duration(milliseconds: 50));
  // }

  @override
  void initState() {
    fotoBeneficiario = base64.decode(uribeneficiario.split(',').last);

    listaConfiguraciones = [];
    listaVacunas = [];
    listaLotes = [];
    dniTutor = '';
    sexoTutor = 'F';
    genero = false;
    super.initState();
    focusNode = FocusNode();
    cargarPerfilesService(registradorService.registrador!.id_flxcore03!);

    // itemListener.itemPositions.addListener(() {
    //   final indices = itemListener.itemPositions.value
    //       .where((item) {

    //         final isTopVisible = item.itemLeadingEdge >= 0;
    //         final isBottomVisible = item.itemTrailingEdge <= 1;

    //         return isTopVisible && isBottomVisible;
    //       })
    //       .map((e) => e.index)
    //       .toList();

    // });
  }

  @override
  void dispose() {
    focusNode.dispose();
    controladorDni.dispose();
    controladorBusqueda.dispose();
    controladorBusquedaConfig.dispose();
    controladorBusquedaLotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Text(
                              'Vacunas Aplicadas',
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            StreamBuilder(
                              stream: notificacionesDosisService
                                  .listaDosisAplicadasStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return notificacionesDosisService
                                        .listaDosisAplicadas.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: notificacionesDosisService
                                            .listaDosisAplicadas.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(
                                                notificacionesDosisService
                                                        .listaDosisAplicadas[
                                                            index]
                                                        .sysvacu05_nombre! +
                                                    ' - ' +
                                                    notificacionesDosisService
                                                        .listaDosisAplicadas[
                                                            index]
                                                        .sysvacu04_nombre!),
                                            subtitle: Text(
                                                'Fecha de Aplicación: - ' +
                                                    notificacionesDosisService
                                                        .listaDosisAplicadas[
                                                            index]
                                                        .sysdesa10_fecha_aplicacion!),
                                          );
                                        },
                                      )
                                    : const Text('No posee dosis aplicadas');
                              },
                            ),
                          ],
                        );
                      });
                },
                child: FaIcon(FontAwesomeIcons.hospitalUser,
                    size: getValueForScreenType(context: context, mobile: 20),
                    color: SisVacuColor.white!.withOpacity(1.0))),
          ),
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
        body: Stack(
          children: [
            const EncabezadoWave(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                              FadeInUpBig(
                                from: 25,
                                child: Text(
                                  'Datos Beneficiario',
                                  style: GoogleFonts.barlow(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('Nombre: ',
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.0),
                                              ),
                                              textAlign: TextAlign.center),
                                          Text(
                                              beneficiarioService.beneficiario!
                                                  .sysdesa10_nombre!,
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w400,
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
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.0),
                                              ),
                                              textAlign: TextAlign.center),
                                          Text(
                                              beneficiarioService.beneficiario!
                                                  .sysdesa10_apellido!,
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w400,
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
                                ),
                              ],
                            ),
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
                                    color: SisVacuColor.white),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        FadeInUpBig(
                                          from: 25,
                                          child: Text(
                                            'Datos Tutor',
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text('Nombre: ',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                    Text(
                                                        tutorService.tutor!
                                                            .sysdesa10_nombre_tutor!,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Apellido: ',
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16.0),
                                                      ),
                                                    ),
                                                    Text(
                                                        tutorService.tutor!
                                                            .sysdesa10_apellido_tutor!,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                Row(
                                                  children: [
                                                    Text('D.N.I.: ',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                    Text(
                                                        tutorService.tutor!
                                                            .sysdesa10_dni_tutor!,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                              FadeInUpBig(
                                from: 25,
                                child: Text(
                                  'Seleccione un Perfil',
                                  style: GoogleFonts.barlow(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ignore: sized_box_for_whitespace
                          StreamBuilder(
                            stream: perfilesVacunacionService
                                .listaPerfilesVacunacionStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return perfilesVacunacionService
                                              .listaPerfilesVacunacion !=
                                          null &&
                                      perfilesVacunacionService
                                          .listaPerfilesVacunacion!.isNotEmpty
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .1,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        reverse: true,
                                        itemExtent: 90,
                                        itemCount: perfilesVacunacionService
                                            .listaPerfilesVacunacion!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                loadingLoginService
                                                    .cargaPerfil(true);
                                                listaConfiguraciones!.clear();
                                                listaLotes!.clear();
                                                setState(() {
                                                  _selectLote = null;
                                                  _selectConfigVacuna = null;
                                                  _selectPerfil =
                                                      perfilesVacunacionService
                                                              .listaPerfilesVacunacion![
                                                          index];
                                                  _selectVacunas = null;
                                                });
                                                final tempLista =
                                                    await vacunasxPerfiles
                                                        .obtenerVacunasxPerfilesProviders(
                                                            _selectPerfil!
                                                                .id_sysvacu12,
                                                            beneficiarioService
                                                                .beneficiario!
                                                                .sysdesa10_dni,
                                                            beneficiarioService
                                                                .beneficiario!
                                                                .sysdesa10_sexo);
                                                tempLista != null
                                                    ? tempLista[0]
                                                                .codigo_mensaje ==
                                                            "0"
                                                        ? showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DialogoAlerta(
                                                                  envioFuncion2:
                                                                      false,
                                                                  envioFuncion1:
                                                                      false,
                                                                  tituloAlerta:
                                                                      'ATENCIÓN!',
                                                                  descripcionAlerta:
                                                                      tempLista[
                                                                              0]
                                                                          .mensaje,
                                                                  textoBotonAlerta:
                                                                      'Listo',
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .error_outline,
                                                                    size: 40,
                                                                  ),
                                                                  color: Colors
                                                                      .red);
                                                            })
                                                        : {
                                                            loadingLoginService
                                                                    .getCargaPerfilState!
                                                                ? mostrarLoadingEstrellasXTiempo(
                                                                    context,
                                                                    850)
                                                                : () {},
                                                            loadingLoginService
                                                                .cargaPerfil(
                                                                    false)
                                                          }
                                                    : {
                                                        loadingLoginService
                                                                .getCargaPerfilState!
                                                            ? mostrarLoadingEstrellasXTiempo(
                                                                context, 850)
                                                            : () {},
                                                        loadingLoginService
                                                            .cargaPerfil(false)
                                                      };
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: _selectPerfil ==
                                                            perfilesVacunacionService
                                                                    .listaPerfilesVacunacion![
                                                                index]
                                                        ? <BoxShadow>[
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                offset:
                                                                    const Offset(
                                                                        0, 5),
                                                                blurRadius: 5)
                                                          ]
                                                        : null,
                                                    color: _selectPerfil ==
                                                            perfilesVacunacionService
                                                                    .listaPerfilesVacunacion![
                                                                index]
                                                        ? SisVacuColor
                                                            .vercelesteCuaternario!
                                                            .withOpacity(.75)
                                                        : SisVacuColor.white!
                                                            .withOpacity(.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                //height: MediaQuery.of(context).size.height * .2,
                                                child: Center(
                                                  child: Text(
                                                    perfilesVacunacionService
                                                        .listaPerfilesVacunacion![
                                                            index]
                                                        .sysvacu12_descripcion!,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.nunito(
                                                        fontWeight: _selectPerfil ==
                                                                perfilesVacunacionService
                                                                        .listaPerfilesVacunacion![
                                                                    index]
                                                            ? FontWeight.w700
                                                            : FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const LoadingEstrellas();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                  StreamBuilder(
                    stream: loadingLoginService.cargaPerfilStateStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return loadingLoginService.getCargaPerfilState!
                          ? Container()
                          : StreamBuilder(
                              stream: vacunasxPerfilService
                                  .listaVacunasxPerfilesStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return vacunasxPerfilService
                                        .listavacunasxPerfil!.isNotEmpty
                                    ? Padding(
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
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.08),
                                                    offset: const Offset(0, 5),
                                                    blurRadius: 5)
                                              ],
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  FadeInUpBig(
                                                    from: 20,
                                                    child: Text(
                                                      'Seleccione una vacuna',
                                                      style: GoogleFonts.barlow(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      20)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              GestureDetector(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          _selectVacunas == null
                                                              ? 'Seleccione'
                                                              : _selectVacunas!
                                                                  .sysvacu04_nombre!,
                                                          style: GoogleFonts
                                                              .nunito(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize:
                                                                  getValueForScreenType(
                                                                      context:
                                                                          context,
                                                                      mobile:
                                                                          15,
                                                                      tablet:
                                                                          20),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )),
                                                      const SizedBox(width: 5),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color:
                                                            SisVacuColor.black,
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    loadingLoginService
                                                        .cargaConfiguracion(
                                                            true);
                                                    vacunasxPerfilService
                                                            .listavacunasxPerfil!
                                                            .isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                                'Hubo un problema'),
                                                          )
                                                        : showModalBottomSheet(
                                                            useRootNavigator:
                                                                true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StreamBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            dynamic>
                                                                        snapshot) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            .005,
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                5,
                                                                            bottom:
                                                                                5,
                                                                            right:
                                                                                20),
                                                                        margin: EdgeInsets.only(
                                                                            right: MediaQuery.of(context).size.width *
                                                                                0.04,
                                                                            left:
                                                                                MediaQuery.of(context).size.width * 0.04),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.blueGrey[50],
                                                                            borderRadius: BorderRadius.circular(20),
                                                                            boxShadow: <BoxShadow>[
                                                                              BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 5), blurRadius: 5)
                                                                            ]),
                                                                        child: TextField(
                                                                            autocorrect: false,
                                                                            controller: controladorBusqueda,
                                                                            keyboardType: TextInputType.text,
                                                                            decoration: const InputDecoration(
                                                                              prefixIcon: Icon(Icons.medical_services_rounded),
                                                                              focusedBorder: InputBorder.none,
                                                                              border: InputBorder.none,
                                                                              hintText: 'Buscar Vacuna...',
                                                                            ),
                                                                            focusNode: focusNode,
                                                                            onChanged: (value) {
                                                                              vacunasxPerfilService.buscarVacuna(value.toUpperCase());

                                                                              if (value.length >= 3) {
                                                                                focusNode.unfocus();
                                                                              }
                                                                            }),
                                                                      ),
                                                                      StreamBuilder(
                                                                        stream:
                                                                            vacunasxPerfilService.listaBusquedaStream,
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<dynamic>
                                                                                snapshot) {
                                                                          return controladorBusqueda.text.isEmpty
                                                                              ? SizedBox(
                                                                                  height: MediaQuery.of(context).size.height * .45,
                                                                                  child: ListView.builder(
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    itemCount: vacunasxPerfilService.listavacunasxPerfil!.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return InkWell(
                                                                                        onTap: () async {
                                                                                          listaConfiguraciones!.clear();
                                                                                          listaLotes!.clear();
                                                                                          setState(() {
                                                                                            _selectLote = null;
                                                                                            _selectConfigVacuna = null;
                                                                                            _selectVacunas = vacunasxPerfilService.listavacunasxPerfil![index];
                                                                                          });
                                                                                          // controladorBusqueda.clear();
                                                                                          final tempLista = await configuracionVacunaProvider.validarConfiguraciones(_selectVacunas!.id_sysvacu04);
                                                                                          tempLista[0].codigo_mensaje == "0"
                                                                                              ? showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return DialogoAlerta(
                                                                                                        envioFuncion2: false,
                                                                                                        envioFuncion1: false,
                                                                                                        tituloAlerta: 'ATENCIÓN!',
                                                                                                        descripcionAlerta: tempLista[0].mensaje,
                                                                                                        textoBotonAlerta: 'Listo',
                                                                                                        icon: const Icon(
                                                                                                          Icons.error_outline,
                                                                                                          size: 40,
                                                                                                        ),
                                                                                                        color: Colors.red);
                                                                                                  })
                                                                                              : {
                                                                                                  Navigator.of(context).pop(),
                                                                                                  loadingLoginService.getCargaConfiguracionState! ? mostrarLoadingEstrellasXTiempo(context, 800) : () {},
                                                                                                  setState(() {
                                                                                                    listaConfiguraciones = tempLista;
                                                                                                    vacunasConfiguracionService.cargarListaVacunasConfiguracion(tempLista);
                                                                                                  }),
                                                                                                  loadingLoginService.cargaConfiguracion(false),
                                                                                                };
                                                                                        },
                                                                                        child: ListTile(
                                                                                          title: Text(vacunasxPerfilService.listavacunasxPerfil![index].sysvacu04_nombre!),
                                                                                          leading: const Icon(Icons.medical_services_outlined),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              : SizedBox(
                                                                                  height: MediaQuery.of(context).size.height * .45,
                                                                                  child: ListView.builder(
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    itemCount: vacunasxPerfilService.listavacunasxPerfilBusqueda!.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return InkWell(
                                                                                        onTap: () async {
                                                                                          listaConfiguraciones!.clear();
                                                                                          listaLotes!.clear();
                                                                                          setState(() {
                                                                                            _selectLote = null;
                                                                                            _selectConfigVacuna = null;
                                                                                            _selectVacunas = vacunasxPerfilService.listavacunasxPerfilBusqueda![index];
                                                                                          });
                                                                                          final tempLista = await configuracionVacunaProvider.validarConfiguraciones(_selectVacunas!.id_sysvacu04);
                                                                                          tempLista[0].codigo_mensaje == "0"
                                                                                              ? showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return DialogoAlerta(
                                                                                                        envioFuncion2: false,
                                                                                                        envioFuncion1: false,
                                                                                                        tituloAlerta: 'ATENCIÓN!',
                                                                                                        descripcionAlerta: tempLista[0].mensaje,
                                                                                                        textoBotonAlerta: 'Listo',
                                                                                                        icon: const Icon(
                                                                                                          Icons.error_outline,
                                                                                                          size: 40,
                                                                                                        ),
                                                                                                        color: Colors.red);
                                                                                                  })
                                                                                              : {
                                                                                                  Navigator.of(context).pop(),
                                                                                                  loadingLoginService.getCargaConfiguracionState! ? mostrarLoadingEstrellasXTiempo(context, 800) : () {},
                                                                                                  setState(() {
                                                                                                    listaConfiguraciones = tempLista;
                                                                                                    vacunasConfiguracionService.cargarListaVacunasConfiguracion(tempLista);
                                                                                                  }),
                                                                                                  loadingLoginService.cargaConfiguracion(false),
                                                                                                  Navigator.of(context).pop()
                                                                                                };
                                                                                        },
                                                                                        child: ListTile(
                                                                                          title: Text(vacunasxPerfilService.listavacunasxPerfilBusqueda![index].sysvacu04_nombre!),
                                                                                          trailing: const Icon(Icons.medical_services_outlined),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                );
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            );
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                  StreamBuilder(
                    stream: loadingLoginService.cargarConfiguracionStateStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return loadingLoginService.getCargaConfiguracionState!
                          ? Container()
                          : StreamBuilder(
                              stream: vacunasConfiguracionService
                                  .listaVacunasConfiguracionesStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return vacunasConfiguracionService
                                        .listavacunasConfiguracion!.isNotEmpty
                                    ? Padding(
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
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.08),
                                                    offset: const Offset(0, 5),
                                                    blurRadius: 5)
                                              ],
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  FadeInUpBig(
                                                    from: 20,
                                                    child: Text(
                                                      'Seleccione una Configuracion',
                                                      style: GoogleFonts.barlow(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      20)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              GestureDetector(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            _selectConfigVacuna ==
                                                                    null
                                                                ? 'Seleccione'
                                                                : _selectConfigVacuna!
                                                                        .sysvacu05_nombre! +
                                                                    '-' +
                                                                    _selectConfigVacuna!
                                                                        .sysvacu02_descripcion!,
                                                            style: GoogleFonts
                                                                .nunito(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize:
                                                                    getValueForScreenType(
                                                                        context:
                                                                            context,
                                                                        mobile:
                                                                            15,
                                                                        tablet:
                                                                            20),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                            width: 5),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: SisVacuColor
                                                              .black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    vacunasConfiguracionService
                                                            .listavacunasConfiguracion!
                                                            .isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                                'Hubo un problema'),
                                                          )
                                                        : showModalBottomSheet(
                                                            useRootNavigator:
                                                                true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StreamBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            dynamic>
                                                                        snapshot) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            .005,
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                5,
                                                                            bottom:
                                                                                5,
                                                                            right:
                                                                                20),
                                                                        margin: EdgeInsets.only(
                                                                            right: MediaQuery.of(context).size.width *
                                                                                0.04,
                                                                            left:
                                                                                MediaQuery.of(context).size.width * 0.04),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.blueGrey[50],
                                                                            borderRadius: BorderRadius.circular(20),
                                                                            boxShadow: <BoxShadow>[
                                                                              BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 5), blurRadius: 5)
                                                                            ]),
                                                                        child: TextField(
                                                                            autocorrect: false,
                                                                            controller: controladorBusquedaConfig,
                                                                            keyboardType: TextInputType.text,
                                                                            decoration: const InputDecoration(
                                                                              prefixIcon: Icon(Icons.medical_services_rounded),
                                                                              focusedBorder: InputBorder.none,
                                                                              border: InputBorder.none,
                                                                              hintText: 'Buscar Configuracion...',
                                                                            ),
                                                                            focusNode: focusNode,
                                                                            onChanged: (value) {
                                                                              vacunasConfiguracionService.buscarConfiguracion(value.toUpperCase());
                                                                            }),
                                                                      ),
                                                                      StreamBuilder(
                                                                        stream:
                                                                            vacunasConfiguracionService.listaBusquedaConfiguracionStream,
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<dynamic>
                                                                                snapshot) {
                                                                          return controladorBusquedaConfig.text.isEmpty
                                                                              ? SizedBox(
                                                                                  height: MediaQuery.of(context).size.height * .45,
                                                                                  child: ListView.builder(
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    itemCount: vacunasConfiguracionService.listavacunasConfiguracion!.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return InkWell(
                                                                                        onTap: () async {
                                                                                          loadingLoginService.cargaLotes(true);
                                                                                          listaLotes!.clear();
                                                                                          setState(() {
                                                                                            _selectLote = null;
                                                                                            _selectConfigVacuna = vacunasConfiguracionService.listavacunasConfiguracion![index];
                                                                                            // _selectVacunas = vacunasxPerfilService.listavacunasxPerfil![index];
                                                                                          });
                                                                                          final tempLista = await lotesVacunaProvider.validarLotes(_selectVacunas!.id_sysvacu04);
                                                                                          tempLista[0].codigo_mensaje == "0"
                                                                                              ? showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return DialogoAlerta(
                                                                                                        envioFuncion2: false,
                                                                                                        envioFuncion1: false,
                                                                                                        tituloAlerta: 'ATENCIÓN!',
                                                                                                        descripcionAlerta: tempLista[0].mensaje,
                                                                                                        textoBotonAlerta: 'Listo',
                                                                                                        icon: const Icon(
                                                                                                          Icons.error_outline,
                                                                                                          size: 40,
                                                                                                        ),
                                                                                                        color: Colors.red);
                                                                                                  })
                                                                                              : {
                                                                                                  Navigator.of(context).pop(),
                                                                                                  loadingLoginService.getCargaLotesState! ? mostrarLoadingEstrellasXTiempo(context, 800) : () {},
                                                                                                  // loadingLoginService.cargaConfiguracion(false),
                                                                                                  setState(() {
                                                                                                    listaLotes = tempLista;
                                                                                                    vacunasLotesService.cargarListaVacunasLotes(tempLista);
                                                                                                  }),
                                                                                                  loadingLoginService.cargaLotes(false),
                                                                                                };
                                                                                        },
                                                                                        child: ListTile(
                                                                                          title: Text(vacunasConfiguracionService.listavacunasConfiguracion![index].sysvacu05_nombre! + '-' + vacunasConfiguracionService.listavacunasConfiguracion![index].sysvacu01_descripcion!),
                                                                                          leading: const Icon(Icons.medical_services_outlined),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              : SizedBox(
                                                                                  height: MediaQuery.of(context).size.height * .45,
                                                                                  child: ListView.builder(
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    itemCount: vacunasConfiguracionService.listavacunasConfiguracionBusqueda!.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return InkWell(
                                                                                        onTap: () async {
                                                                                          listaLotes!.clear();
                                                                                          setState(() {
                                                                                            _selectLote = null;
                                                                                            _selectConfigVacuna = vacunasConfiguracionService.listavacunasConfiguracionBusqueda![index];
                                                                                            // _selectVacunas = vacunasxPerfilService.listavacunasxPerfilBusqueda![index];
                                                                                          });
                                                                                          final tempLista = await lotesVacunaProvider.validarLotes(_selectVacunas!.id_sysvacu04);
                                                                                          tempLista[0].codigo_mensaje == "0"
                                                                                              ? showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return DialogoAlerta(
                                                                                                        envioFuncion2: false,
                                                                                                        envioFuncion1: false,
                                                                                                        tituloAlerta: 'ATENCIÓN!',
                                                                                                        descripcionAlerta: tempLista[0].mensaje,
                                                                                                        textoBotonAlerta: 'Listo',
                                                                                                        icon: const Icon(
                                                                                                          Icons.error_outline,
                                                                                                          size: 40,
                                                                                                        ),
                                                                                                        color: Colors.red);
                                                                                                  })
                                                                                              : {
                                                                                                  Navigator.of(context).pop(),
                                                                                                  loadingLoginService.getCargaLotesState! ? mostrarLoadingEstrellasXTiempo(context, 800) : () {},
                                                                                                  setState(() {
                                                                                                    listaLotes = tempLista;
                                                                                                    vacunasLotesService.cargarListaVacunasLotes(tempLista);
                                                                                                  }),
                                                                                                  loadingLoginService.cargaLotes(false),
                                                                                                  Navigator.of(context).pop()
                                                                                                };
                                                                                        },
                                                                                        child: ListTile(
                                                                                          title: Text(vacunasConfiguracionService.listavacunasConfiguracion![index].sysvacu05_nombre! + '-' + vacunasConfiguracionService.listavacunasConfiguracion![index].sysvacu01_descripcion!),
                                                                                          trailing: const Icon(Icons.medical_services_outlined),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                );
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            );
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                  StreamBuilder(
                    stream: vacunasLotesService.listaVacunasLotesStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return vacunasLotesService.listavacunasLotes!.isEmpty
                          ? Container()
                          : Padding(
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
                                  children: [
                                    Row(
                                      children: [
                                        FadeInUpBig(
                                          from: 25,
                                          child: Text(
                                            'Seleccione un Lote',
                                            style: GoogleFonts.barlow(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20)),
                                          ),
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
                                                _selectLote == null
                                                    ? 'Seleccione un Lote'
                                                    : _selectLote!
                                                        .sysdesa18_lote!,
                                                style: TextStyle(
                                                  fontSize:
                                                      getValueForScreenType(
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
                                          vacunasLotesService
                                                  .listavacunasLotes!.isEmpty
                                              ? const Center(
                                                  child:
                                                      Text('Hubo un problema'),
                                                )
                                              : showModalBottomSheet(
                                                  useRootNavigator: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StreamBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                        return Column(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .005,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 5,
                                                                      bottom: 5,
                                                                      right:
                                                                          20),
                                                              margin: EdgeInsets.only(
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.04,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.04),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .blueGrey[
                                                                      50],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  boxShadow: <
                                                                      BoxShadow>[
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.05),
                                                                        offset: const Offset(
                                                                            0,
                                                                            5),
                                                                        blurRadius:
                                                                            5)
                                                                  ]),
                                                              child: TextField(
                                                                  autocorrect:
                                                                      false,
                                                                  controller:
                                                                      controladorBusquedaLotes,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .medical_services_rounded),
                                                                    focusedBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        'Buscar Lotes...',
                                                                  ),
                                                                  focusNode:
                                                                      focusNode,
                                                                  onChanged:
                                                                      (value) {
                                                                    vacunasLotesService
                                                                        .buscarLotes(
                                                                            value.toUpperCase());
                                                                  }),
                                                            ),
                                                            StreamBuilder(
                                                              stream: vacunasLotesService
                                                                  .listaVacunasLotesStream,
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          dynamic>
                                                                      snapshot) {
                                                                return controladorBusquedaLotes
                                                                        .text
                                                                        .isEmpty
                                                                    ? SizedBox(
                                                                        height:
                                                                            MediaQuery.of(context).size.height *
                                                                                .4,
                                                                        child: ListView
                                                                            .builder(
                                                                          physics:
                                                                              const BouncingScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: vacunasLotesService
                                                                              .listavacunasLotes!
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return InkWell(
                                                                              onTap: () async {
                                                                                setState(() {
                                                                                  _selectLote = vacunasLotesService.listavacunasLotes![index];
                                                                                });
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: ListTile(
                                                                                title: Text(vacunasLotesService.listavacunasLotes![index].sysdesa18_lote!),
                                                                                leading: const Icon(Icons.medical_services_outlined),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      )
                                                                    : SizedBox(
                                                                        height:
                                                                            MediaQuery.of(context).size.height *
                                                                                .4,
                                                                        child: ListView
                                                                            .builder(
                                                                          physics:
                                                                              const BouncingScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: vacunasLotesService
                                                                              .listavacunasLotesBusqueda!
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return InkWell(
                                                                              onTap: () async {
                                                                                setState(() {
                                                                                  _selectLote = vacunasLotesService.listavacunasLotesBusqueda![index];
                                                                                });
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: ListTile(
                                                                                title: Text(vacunasLotesService.listavacunasLotesBusqueda![index].sysdesa18_lote!),
                                                                                trailing: const Icon(Icons.medical_services_outlined),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  });
                                        }),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),

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
                                                                sysdesa10_cadena_dni: beneficiarioService
                                                                    .beneficiario!
                                                                    .sysdesa10_cadena_dni, //Solo con Escaner
                                                                sysdesa10_dni: beneficiarioService
                                                                    .beneficiario!
                                                                    .sysdesa10_dni, //Obligatorio
                                                                sysdesa10_nombre: beneficiarioService
                                                                    .beneficiario!
                                                                    .sysdesa10_nombre, //Obligatorio
                                                                sysdesa10_nro_tramite: beneficiarioService
                                                                    .beneficiario!
                                                                    .sysdesa10_nro_tramite, //Solo con Escaner
                                                                sysdesa10_sexo: beneficiarioService
                                                                    .beneficiario!
                                                                    .sysdesa10_sexo, //Obligatorio
                                                                sysdesa10_edad: beneficiarioService
                                                                    .beneficiario!
                                                                    .sysdesa10_edad,
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
                                                                builder:
                                                                    (context) =>
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
                                                              color:
                                                                  Colors.red);
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
                                                builder:
                                                    (BuildContext context) {
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
                                                builder:
                                                    (BuildContext context) {
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
                                    vacunasxPerfilService
                                        .eliminarListaVacunasxPerfil();
                                    perfilesVacunacionService
                                        .eliminarListaPerfiles();
                                    vacunasConfiguracionService
                                        .eliminarListaVacunasConfiguracion();
                                    vacunasLotesService
                                        .eliminarListaVacunasLotes();
                                    notificacionesDosisService
                                        .eliminarListaDosis();

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BusquedaBeneficiario()),
                                        (Route<dynamic> route) => false);
                                  },
                                ));
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  )
                ],
              ),
            ),
          ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeInUpBig(
                        from: 25,
                        child: Text(
                          'Datos del Tutor',
                          style: GoogleFonts.barlow(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20)),
                        ),
                      ),
                      FadeInDownBig(
                        from: 25,
                        child: IconButton(
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
                                          'Registre al tutor mediante el escaneo del codigo de barras, o ingresando manualmente el numero de D.N.I.',
                                      textoBotonAlerta: 'Listo',
                                      color: SisVacuColor.vercelesteCuaternario,
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
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  const EscanerDni(
                    'Tutor',
                    'Escanear',
                    'Escanee el D.N.I. del Tutor',
                    largoValor: 150,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  CustomInput(
                      icon: Icons.perm_identity,
                      placeholder: 'D.N.I.',
                      keyboardType: TextInputType.phone,
                      textController: controladorDni,
                      focusNode: focusNode,
                      funcion: () => focusNode.unfocus()),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  Text('Seleccione el Sexo',
                      style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Femenino',
                        style: GoogleFonts.nunito(
                            color: !genero ? Colors.black87 : Colors.grey[300],
                            fontWeight:
                                !genero ? FontWeight.w700 : FontWeight.w100),
                      ),
                      Switch(
                          activeColor: Colors.blue,
                          inactiveTrackColor: Colors.pink,
                          inactiveThumbColor: Colors.pink,
                          value: genero,
                          onChanged: (value) {
                            setState(() {
                              genero = value;
                              genero ? sexoTutor = 'M' : sexoTutor = 'F';
                            });
                          }),
                      Text(
                        'Masculino',
                        style: GoogleFonts.nunito(
                            color: genero ? Colors.black87 : Colors.grey[300],
                            fontWeight:
                                genero ? FontWeight.w700 : FontWeight.w100),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  BotonCustom(
                    width: 150,
                    iconoBool: true,
                    iconoBoton: const Icon(
                      Icons.people,
                      color: Colors.white,
                    ),
                    text: 'Verificar',
                    onPressed: () {
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
                    },
                  )
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

  cargarPerfilesService(String id) async {
    await perfilesProviders.obtenerDatosPerfilesVacunacion(id);
  }
}
