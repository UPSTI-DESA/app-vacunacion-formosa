import 'dart:convert';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
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
  bool? mostrarBeneficiario;
  bool? mostrarTutor;

  int pasos = 1;
  PerfilesVacunacion? _selectPerfil;
  VacunasxPerfil? _selectVacunas;
  VacunasCondicion? _selectCondicion;
  VacunasEsquema? _selectEsquema;
  VacunasDosis? _selectDosis;

  List<InfoVacunas>? listaVacunas;
  List<VacunasCondicion>? listaCondiciones;
  List<VacunasEsquema>? listaEsquemas;
  List<VacunasDosis>? listaDosis;
  List<Lotes>? listaLotes;
  Lotes? _selectLote;
  String uribeneficiario = beneficiarioService.beneficiario!.foto_beneficiario!;
  final TextEditingController controladorDni = TextEditingController();
  final TextEditingController controladorBusqueda = TextEditingController();
  final TextEditingController controladorBusquedaVacunas =
      TextEditingController();
  final TextEditingController controladorBusquedaCondicion =
      TextEditingController();
  final TextEditingController controladorBusquedaEsquema =
      TextEditingController();
  final TextEditingController controladorBusquedaDosis =
      TextEditingController();
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
  @override
  void initState() {
    fotoBeneficiario = base64.decode(uribeneficiario.split(',').last);
    mostrarBeneficiario = false;
    mostrarTutor = false;
    pasos = 1;
    listaCondiciones = [];
    listaEsquemas = [];
    listaDosis = [];
    listaVacunas = [];
    listaLotes = [];
    dniTutor = '';
    sexoTutor = 'F';
    genero = false;
    super.initState();
    focusNode = FocusNode();
    cargarPerfilesService(registradorService.registrador!.id_flxcore03!);
  }

  @override
  void dispose() {
    focusNode.dispose();
    controladorDni.dispose();
    controladorBusqueda.dispose();
    controladorBusquedaLotes.dispose();
    controladorBusquedaVacunas.dispose();
    controladorBusquedaCondicion.dispose();
    controladorBusquedaEsquema.dispose();
    controladorBusquedaDosis.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScrollController generalScroll = ScrollController();

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Center(
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return vacunasAplicadas();
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
            RawScrollbar(
              thumbColor: SisVacuColor.verceleste,
              isAlwaysShown: true,
              radius: const Radius.circular(20),
              thickness: 5,
              controller: generalScroll,
              child: SingleChildScrollView(
                controller: generalScroll,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                    containerBeneficiario(),

                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    //CUANDO EL TUTORSERVICE TENGA DATOS
                    containerTutor(),

                    containerPasos(),

                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                    containerProgressBar(),

                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                    pasos == 7 ? botonRegistrarVacunacion() : Container(),

                    BotonCustom(
                        text: 'Cancelar Registro',
                        color: SisVacuColor.red,
                        onPressed: () {
                          showDialog(
                              context: _scaffoldKey.currentContext!,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget containerPasos() {
    switch (pasos) {

      // 1 -> Perfiles // 2 -> Vacuna // 3 -> Esquema // 4 -> Condicion // 5 -> Dosis // 6 -> Lote

      case 1:
        return FadeInLeft(child: containerPerfiles());
      case 2:
        return FadeInRight(child: containerVacunas());
      case 3:
        return FadeInLeft(child: containerCondiciones());
      case 4:
        return FadeInRight(child: containerEsquemas());
      case 5:
        return FadeInRight(child: containerDosis());
      case 6:
        return FadeInRight(child: containerLotes());
      case 7:
        return FadeInRight(child: containerVerificar());

      default:
        return containerPerfiles();
    }
  }

  Widget vacunasAplicadas() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        Text(
          'Vacunas Aplicadas',
          style: GoogleFonts.nunito(
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        StreamBuilder(
          stream: notificacionesDosisService.listaDosisAplicadasStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return notificacionesDosisService.listaDosisAplicadas.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        notificacionesDosisService.listaDosisAplicadas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(notificacionesDosisService
                                .listaDosisAplicadas[index].sysvacu05_nombre! +
                            ' - ' +
                            notificacionesDosisService
                                .listaDosisAplicadas[index].sysvacu04_nombre!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lote: - ' +
                                notificacionesDosisService
                                    .listaDosisAplicadas[index]
                                    .sysdesa18_lote!),
                            Text('Fecha de Aplicación: - ' +
                                notificacionesDosisService
                                    .listaDosisAplicadas[index]
                                    .sysdesa10_fecha_aplicacion!),
                          ],
                        ),
                      );
                    },
                  )
                : const Text('No posee dosis aplicadas');
          },
        ),
      ],
    );
  }

  Widget containerBeneficiario() {
    return Padding(
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
                    'Datos Beneficiario',
                    style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        mostrarBeneficiario!
                            ? mostrarBeneficiario = false
                            : mostrarBeneficiario = true;
                      });
                    },
                    icon: mostrarBeneficiario!
                        ? const Icon(Icons.keyboard_arrow_down_outlined)
                        : const Icon(Icons.keyboard_arrow_right_outlined))
              ],
            ),
            mostrarBeneficiario!
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  height:
                                      MediaQuery.of(context).size.width * 0.02),
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
                                  height:
                                      MediaQuery.of(context).size.width * 0.02),
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
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget containerTutor() {
    return StreamBuilder(
      stream: tutorService.tutorStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Column(
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
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, 5),
                                blurRadius: 5)
                          ],
                          color: SisVacuColor.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      mostrarTutor!
                                          ? mostrarTutor = false
                                          : mostrarTutor = true;
                                    });
                                  },
                                  icon: mostrarTutor!
                                      ? const Icon(
                                          Icons.keyboard_arrow_down_outlined)
                                      : const Icon(
                                          Icons.keyboard_arrow_right_outlined))
                            ],
                          ),
                          mostrarTutor!
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
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
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16.0),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                                Text(
                                                    tutorService.tutor!
                                                        .sysdesa10_nombre_tutor!,
                                                    style: GoogleFonts.nunito(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16.0),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ],
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            Row(
                                              children: [
                                                Text(
                                                  'Apellido: ',
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                                Text(
                                                    tutorService.tutor!
                                                        .sysdesa10_apellido_tutor!,
                                                    style: GoogleFonts.nunito(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16.0),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
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
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16.0),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                                Text(
                                                    tutorService.tutor!
                                                        .sysdesa10_dni_tutor!,
                                                    style: GoogleFonts.nunito(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16.0),
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
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                ],
              )
            : verificarEdad(context);
      },
    );
  }

  Widget containerPerfiles() {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.02,
          left: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: FadeInUpBig(
              from: 25,
              child: Text(
                'Seleccione un Perfil',
                style: GoogleFonts.barlow(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20)),
              ),
            ),
          ),
          Container(
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
              child: StreamBuilder(
                stream: perfilesVacunacionService.listaPerfilesVacunacionStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return perfilesVacunacionService.listaPerfilesVacunacion !=
                              null &&
                          perfilesVacunacionService
                              .listaPerfilesVacunacion!.isNotEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height * .1,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemExtent: 90,
                            itemCount: perfilesVacunacionService
                                .listaPerfilesVacunacion!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    loadingLoginService.cargaPerfil(true);
                                    listaLotes!.clear();
                                    setState(() {
                                      _selectVacunas = null;
                                      _selectPerfil = perfilesVacunacionService
                                          .listaPerfilesVacunacion![index];
                                    });
                                    final tempLista = await vacunasxPerfiles
                                        .obtenerVacunasxPerfilesProviders(
                                            _selectPerfil!.id_sysvacu12,
                                            beneficiarioService
                                                .beneficiario!.sysdesa10_dni,
                                            beneficiarioService
                                                .beneficiario!.sysdesa10_sexo);
                                    tempLista != null
                                        ? tempLista[0].codigo_mensaje == "0"
                                            ? showDialog(
                                                context: _scaffoldKey
                                                    .currentContext!,
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
                                            : {
                                                loadingLoginService
                                                        .getCargaPerfilState!
                                                    ? mostrarLoadingEstrellasXTiempo(
                                                        context, 850)
                                                    : () {},
                                                loadingLoginService
                                                    .cargaPerfil(false)
                                              }
                                        : {
                                            loadingLoginService
                                                    .getCargaPerfilState!
                                                ? {
                                                    mostrarLoadingEstrellasXTiempo(
                                                        context, 850),
                                                  }
                                                : () {},
                                            loadingLoginService
                                                .cargaPerfil(false),
                                            setState(() {
                                              pasos++;
                                            })
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
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    offset: const Offset(0, 5),
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
                                            BorderRadius.circular(15)),
                                    //height: MediaQuery.of(context).size.height * .2,
                                    child: Center(
                                      child: Text(
                                        perfilesVacunacionService
                                            .listaPerfilesVacunacion![index]
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
              )),
        ],
      ),
    );
  }

  Widget containerVacunas() {
    ScrollController vacunaScrollController = ScrollController();
    return StreamBuilder(
      stream: loadingLoginService.cargaPerfilStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getCargaPerfilState!
            ? Container()
            : StreamBuilder(
                stream: vacunasxPerfilService.listaVacunasxPerfilesStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasxPerfilService.listavacunasxPerfil!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02,
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FadeInUpBig(
                                  from: 20,
                                  child: Text(
                                    'Seleccione una vacuna',
                                    style: GoogleFonts.barlow(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            offset: const Offset(0, 5),
                                            blurRadius: 5)
                                      ],
                                      color: Colors.white),
                                  child: StreamBuilder(
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .005,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey[50],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      offset:
                                                          const Offset(0, 5),
                                                      blurRadius: 5)
                                                ]),
                                            child: TextField(
                                                autocorrect: false,
                                                controller: controladorBusqueda,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                  hintText: 'Buscar Vacuna...',
                                                ),
                                                focusNode: focusNode,
                                                onChanged: (value) {
                                                  vacunasxPerfilService
                                                      .buscarVacuna(
                                                          value.toUpperCase());

                                                  if (value.length >= 3) {
                                                    focusNode.unfocus();
                                                  }
                                                }),
                                          ),
                                          StreamBuilder(
                                            stream: vacunasxPerfilService
                                                .listaBusquedaStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              return controladorBusqueda
                                                      .text.isEmpty
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      child: RawScrollbar(
                                                        thumbColor: SisVacuColor
                                                            .verceleste,
                                                        isAlwaysShown: true,
                                                        radius: const Radius
                                                            .circular(20),
                                                        controller:
                                                            vacunaScrollController,
                                                        child: ListView.builder(
                                                          controller:
                                                              vacunaScrollController,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vacunasxPerfilService
                                                                  .listavacunasxPerfil!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                listaLotes!
                                                                    .clear();
                                                                setState(() {
                                                                  _selectCondicion =
                                                                      null;
                                                                  _selectVacunas =
                                                                      vacunasxPerfilService
                                                                              .listavacunasxPerfil![
                                                                          index];
                                                                  controladorBusqueda
                                                                      .clear();
                                                                });
                                                                // final comprobarLotes =
                                                                //     await lotesVacunaProvider
                                                                //         .validarLotes(
                                                                //             _selectVacunas!.id_sysvacu04);

                                                                final tempLista = await vacunasCondicion.obtenerCondicionesProviders(
                                                                    _selectVacunas!
                                                                        .id_sysvacu04,
                                                                    beneficiarioService
                                                                        .beneficiario!
                                                                        .sysdesa10_edad!);

                                                                // .validarConfiguraciones(
                                                                //     _selectVacunas!.id_sysvacu04);
                                                                tempLista[0].codigo_mensaje ==
                                                                        "0"
                                                                    ? showDialog(
                                                                        context:
                                                                            _scaffoldKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
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
                                                                        // Navigator.of(
                                                                        //         context)
                                                                        //     .pop(),
                                                                        loadingLoginService.getLoadingCondicionState!
                                                                            ? mostrarLoadingEstrellasXTiempo(context,
                                                                                800)
                                                                            : () {},
                                                                        setState(
                                                                            () {
                                                                          listaCondiciones =
                                                                              tempLista;
                                                                          vacunasCondicionService
                                                                              .cargarListaVacunasCondicion(tempLista);
                                                                        }),
                                                                        loadingLoginService
                                                                            .cargarCondicion(false),
                                                                        setState(
                                                                            () {
                                                                          pasos++;
                                                                        })
                                                                      };
                                                              },
                                                              child: ListTile(
                                                                title: Text(vacunasxPerfilService
                                                                    .listavacunasxPerfil![
                                                                        index]
                                                                    .sysvacu04_nombre!),
                                                                // leading: const Icon(
                                                                //     Icons
                                                                //         .medical_services_outlined),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      child: RawScrollbar(
                                                        thumbColor: SisVacuColor
                                                            .verceleste,
                                                        isAlwaysShown: true,
                                                        radius: const Radius
                                                            .circular(20),
                                                        child: ListView.builder(
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vacunasxPerfilService
                                                                  .listavacunasxPerfilBusqueda!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                listaLotes!
                                                                    .clear();
                                                                setState(() {
                                                                  _selectCondicion =
                                                                      null;
                                                                  _selectVacunas =
                                                                      vacunasxPerfilService
                                                                              .listavacunasxPerfilBusqueda![
                                                                          index];
                                                                  controladorBusqueda
                                                                      .clear();
                                                                });
                                                                final tempLista = await vacunasCondicion.obtenerCondicionesProviders(
                                                                    _selectVacunas!
                                                                        .id_sysvacu04,
                                                                    beneficiarioService
                                                                        .beneficiario!
                                                                        .sysdesa10_edad!);

                                                                tempLista[0].codigo_mensaje ==
                                                                        "0"
                                                                    ? showDialog(
                                                                        context:
                                                                            _scaffoldKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
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
                                                                        loadingLoginService.getLoadingCondicionState!
                                                                            ? mostrarLoadingEstrellasXTiempo(context,
                                                                                800)
                                                                            : () {},
                                                                        setState(
                                                                            () {
                                                                          listaCondiciones =
                                                                              tempLista;
                                                                          vacunasCondicionService
                                                                              .cargarListaVacunasCondicion(tempLista);
                                                                        }),
                                                                        loadingLoginService
                                                                            .cargarCondicion(false),
                                                                        setState(
                                                                            () {
                                                                          pasos++;
                                                                        })
                                                                      };
                                                              },
                                                              child: ListTile(
                                                                title: Text(vacunasxPerfilService
                                                                    .listavacunasxPerfilBusqueda![
                                                                        index]
                                                                    .sysvacu04_nombre!),
                                                                // trailing:
                                                                //     const Icon(Icons
                                                                //         .medical_services_outlined),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  )),
                            ],
                          ),
                        )
                      : Container();
                },
              );
      },
    );
  }

  Widget containerCondiciones() {
    ScrollController vacunaScrollController = ScrollController();
    return StreamBuilder(
      stream: loadingLoginService.loadingCondicionStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getLoadingCondicionState!
            ? Container()
            : StreamBuilder(
                stream: vacunasCondicionService.listaVacunasCondicionesStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasCondicionService
                          .listaVacunasCondicion!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02,
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FadeInUpBig(
                                  from: 20,
                                  child: Text(
                                    'Seleccione una Condicion',
                                    style: GoogleFonts.barlow(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            offset: const Offset(0, 5),
                                            blurRadius: 5)
                                      ],
                                      color: Colors.white),
                                  child: StreamBuilder(
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .005,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey[50],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      offset:
                                                          const Offset(0, 5),
                                                      blurRadius: 5)
                                                ]),
                                            child: TextField(
                                                autocorrect: false,
                                                controller:
                                                    controladorBusquedaCondicion,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Buscar Condición...',
                                                ),
                                                focusNode: focusNode,
                                                onChanged: (value) {
                                                  vacunasCondicionService
                                                      .buscarCondicion(
                                                          value.toUpperCase());

                                                  if (value.length >= 3) {
                                                    focusNode.unfocus();
                                                  }
                                                }),
                                          ),
                                          StreamBuilder(
                                            stream: vacunasCondicionService
                                                .listaBusquedaStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              return controladorBusquedaCondicion
                                                      .text.isEmpty
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      child: RawScrollbar(
                                                        thumbColor: SisVacuColor
                                                            .verceleste,
                                                        isAlwaysShown: true,
                                                        radius: const Radius
                                                            .circular(20),
                                                        controller:
                                                            vacunaScrollController,
                                                        child: ListView.builder(
                                                          controller:
                                                              vacunaScrollController,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vacunasCondicionService
                                                                  .listaVacunasCondicion!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                listaLotes!
                                                                    .clear();
                                                                listaEsquemas!
                                                                    .clear();
                                                                setState(() {
                                                                  _selectEsquema =
                                                                      null;
                                                                  _selectCondicion =
                                                                      vacunasCondicionService
                                                                              .listaVacunasCondicion![
                                                                          index];
                                                                  controladorBusquedaCondicion
                                                                      .clear();
                                                                });
                                                                final tempLista = await vacunasEsquemaProvider.obtenerEsquemasProviders(
                                                                    _selectVacunas!
                                                                        .id_sysvacu04!,
                                                                    _selectCondicion!
                                                                        .id_sysvacu01);

                                                                tempLista[0].codigo_mensaje ==
                                                                        "0"
                                                                    ? showDialog(
                                                                        context:
                                                                            _scaffoldKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
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
                                                                        // Navigator.of(
                                                                        //         context)
                                                                        //     .pop(),
                                                                        loadingLoginService.getLoadingCondicionState!
                                                                            ? mostrarLoadingEstrellasXTiempo(context,
                                                                                800)
                                                                            : () {},
                                                                        setState(
                                                                            () {
                                                                          listaEsquemas =
                                                                              tempLista;
                                                                          vacunasEsquemaService
                                                                              .cargarListavacunasEsquema(tempLista);
                                                                        }),
                                                                        loadingLoginService
                                                                            .cargarEsquema(false),
                                                                        setState(
                                                                            () {
                                                                          pasos++;
                                                                        })
                                                                      };
                                                              },
                                                              child: ListTile(
                                                                title: Text(vacunasCondicionService
                                                                    .listaVacunasCondicion![
                                                                        index]
                                                                    .sysvacu01_descripcion!),
                                                                // leading: const Icon(
                                                                //     Icons
                                                                //         .medical_services_outlined),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      child: RawScrollbar(
                                                        thumbColor: SisVacuColor
                                                            .verceleste,
                                                        isAlwaysShown: true,
                                                        radius: const Radius
                                                            .circular(20),
                                                        child: ListView.builder(
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vacunasCondicionService
                                                                  .listaVacunasCondicionBusqueda!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                listaEsquemas!
                                                                    .clear();
                                                                setState(() {
                                                                  _selectEsquema =
                                                                      null;
                                                                  _selectEsquema =
                                                                      vacunasEsquemaService
                                                                              .listavacunasEsquema![
                                                                          index];
                                                                  controladorBusquedaCondicion
                                                                      .clear();
                                                                });
                                                                final tempLista = await vacunasEsquemaProvider.obtenerEsquemasProviders(
                                                                    _selectVacunas!
                                                                        .id_sysvacu04,
                                                                    _selectCondicion!
                                                                        .id_sysvacu01);
                                                                tempLista[0].codigo_mensaje ==
                                                                        "0"
                                                                    ? showDialog(
                                                                        context:
                                                                            _scaffoldKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
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
                                                                        loadingLoginService.getLoadingEsquemaState!
                                                                            ? mostrarLoadingEstrellasXTiempo(context,
                                                                                800)
                                                                            : () {},
                                                                        setState(
                                                                            () {
                                                                          listaEsquemas =
                                                                              tempLista;
                                                                          vacunasEsquemaService
                                                                              .cargarListavacunasEsquema(tempLista);
                                                                        }),
                                                                        loadingLoginService
                                                                            .cargarEsquema(false),
                                                                        setState(
                                                                            () {
                                                                          pasos++;
                                                                        })
                                                                      };
                                                              },
                                                              child: ListTile(
                                                                title: Text(vacunasCondicionService
                                                                    .listaVacunasCondicionBusqueda![
                                                                        index]
                                                                    .sysvacu01_descripcion!),
                                                                // trailing:
                                                                //     const Icon(Icons
                                                                //         .medical_services_outlined),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  )),
                            ],
                          ),
                        )
                      : Container();
                },
              );
      },
    );
  }

  Widget containerEsquemas() {
    ScrollController esquemaScrollController = ScrollController();
    return StreamBuilder(
      stream: loadingLoginService.loadingEsquemaStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getLoadingEsquemaState!
            ? Container()
            : StreamBuilder(
                stream: vacunasEsquemaService.listavacunasEsquemaesStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasEsquemaService.listavacunasEsquema!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02,
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FadeInUpBig(
                                  from: 20,
                                  child: Text(
                                    'Seleccione un Esquema',
                                    style: GoogleFonts.barlow(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            offset: const Offset(0, 5),
                                            blurRadius: 5)
                                      ],
                                      color: Colors.white),
                                  child: StreamBuilder(
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .005,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey[50],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      offset:
                                                          const Offset(0, 5),
                                                      blurRadius: 5)
                                                ]),
                                            child: TextField(
                                                autocorrect: false,
                                                controller:
                                                    controladorBusquedaEsquema,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                  hintText: 'Buscar Esquema...',
                                                ),
                                                focusNode: focusNode,
                                                onChanged: (value) {
                                                  vacunasEsquemaService
                                                      .buscaresquema(
                                                          value.toUpperCase());

                                                  if (value.length >= 3) {
                                                    focusNode.unfocus();
                                                  }
                                                }),
                                          ),
                                          StreamBuilder(
                                            stream: vacunasEsquemaService
                                                .listaBusquedaStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              return controladorBusquedaEsquema
                                                      .text.isEmpty
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      child: RawScrollbar(
                                                        thumbColor: SisVacuColor
                                                            .verceleste,
                                                        isAlwaysShown: true,
                                                        radius: const Radius
                                                            .circular(20),
                                                        controller:
                                                            esquemaScrollController,
                                                        child: ListView.builder(
                                                          controller:
                                                              esquemaScrollController,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vacunasEsquemaService
                                                                  .listavacunasEsquema!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                listaLotes!
                                                                    .clear();
                                                                setState(() {
                                                                  _selectDosis =
                                                                      null;
                                                                  _selectEsquema =
                                                                      vacunasEsquemaService
                                                                              .listavacunasEsquema![
                                                                          index];
                                                                  controladorBusquedaEsquema
                                                                      .clear();
                                                                });
                                                                final tempLista = await vacunasDosisProvider.obtenerDosisProviders(
                                                                    _selectVacunas!
                                                                        .id_sysvacu04!,
                                                                    _selectCondicion!
                                                                        .id_sysvacu01!,
                                                                    _selectEsquema!
                                                                        .id_sysvacu02!);
                                                                tempLista[0].codigo_mensaje ==
                                                                        "0"
                                                                    ? showDialog(
                                                                        context:
                                                                            _scaffoldKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
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
                                                                        // Navigator.of(
                                                                        //         context)
                                                                        //     .pop(),
                                                                        loadingLoginService.getLoadingDosisState!
                                                                            ? mostrarLoadingEstrellasXTiempo(context,
                                                                                800)
                                                                            : () {},
                                                                        setState(
                                                                            () {
                                                                          listaDosis =
                                                                              tempLista;
                                                                          vacunasDosisService
                                                                              .cargarListaVacunasDosis(tempLista);
                                                                        }),
                                                                        loadingLoginService
                                                                            .cargarDosis(false),
                                                                        setState(
                                                                            () {
                                                                          pasos++;
                                                                        })
                                                                      };
                                                              },
                                                              child: ListTile(
                                                                title: Text(vacunasEsquemaService
                                                                    .listavacunasEsquema![
                                                                        index]
                                                                    .sysvacu02_descripcion!),
                                                                // leading: const Icon(
                                                                //     Icons
                                                                //         .medical_services_outlined),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .3,
                                                      child: RawScrollbar(
                                                        thumbColor: SisVacuColor
                                                            .verceleste,
                                                        isAlwaysShown: true,
                                                        radius: const Radius
                                                            .circular(20),
                                                        child: ListView.builder(
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vacunasEsquemaService
                                                                  .listavacunasEsquemaBusqueda!
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return InkWell(
                                                              onTap: () async {
                                                                listaLotes!
                                                                    .clear();
                                                                setState(() {
                                                                  _selectDosis =
                                                                      null;
                                                                  _selectEsquema =
                                                                      vacunasEsquemaService
                                                                              .listavacunasEsquema![
                                                                          index];
                                                                  controladorBusquedaEsquema
                                                                      .clear();
                                                                });
                                                                final tempLista = await vacunasDosisProvider.obtenerDosisProviders(
                                                                    _selectVacunas!
                                                                        .id_sysvacu04!,
                                                                    _selectCondicion!
                                                                        .id_sysvacu01!,
                                                                    _selectEsquema!
                                                                        .id_sysvacu02!);
                                                                tempLista[0].codigo_mensaje ==
                                                                        "0"
                                                                    ? showDialog(
                                                                        context:
                                                                            _scaffoldKey
                                                                                .currentContext!,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
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
                                                                        loadingLoginService.getLoadingDosisState!
                                                                            ? mostrarLoadingEstrellasXTiempo(context,
                                                                                800)
                                                                            : () {},
                                                                        setState(
                                                                            () {
                                                                          listaDosis =
                                                                              tempLista;
                                                                          vacunasDosisService
                                                                              .cargarListaVacunasDosis(tempLista);
                                                                        }),
                                                                        loadingLoginService
                                                                            .cargarDosis(false),
                                                                        setState(
                                                                            () {
                                                                          pasos++;
                                                                        })
                                                                      };
                                                              },
                                                              child: ListTile(
                                                                title: Text(vacunasEsquemaService
                                                                    .listavacunasEsquemaBusqueda![
                                                                        index]
                                                                    .sysvacu02_descripcion!),
                                                                // trailing:
                                                                //     const Icon(Icons
                                                                //         .medical_services_outlined),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  )),
                            ],
                          ),
                        )
                      : Container();
                },
              );
      },
    );
  }

  Widget containerDosis() {
    ScrollController dosisScrollController = ScrollController();
    return StreamBuilder(
      stream: loadingLoginService.loadingDosisStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getLoadingDosisState!
            ? Container()
            : StreamBuilder(
                stream: vacunasDosisService.listaVacunasDosisStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasDosisService.listaVacunasDosis!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02,
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FadeInUpBig(
                                  from: 20,
                                  child: Text(
                                    'Seleccione una dosis',
                                    style: GoogleFonts.barlow(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            offset: const Offset(0, 5),
                                            blurRadius: 5)
                                      ],
                                      color: Colors.white),
                                  child: StreamBuilder(
                                    stream:
                                        vacunasDosisService.listaBusquedaStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .1,
                                        child: RawScrollbar(
                                          thumbColor: SisVacuColor.verceleste,
                                          isAlwaysShown: true,
                                          radius: const Radius.circular(20),
                                          controller: dosisScrollController,
                                          child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .05,
                                            ),
                                            scrollDirection: Axis.horizontal,
                                            controller: dosisScrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: vacunasDosisService
                                                .listaVacunasDosis!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () async {
                                                  loadingLoginService
                                                          .getLoadingDosisState!
                                                      ? mostrarLoadingEstrellasXTiempo(
                                                          context, 800)
                                                      : () {};
                                                  loadingLoginService
                                                      .cargaLotes(false);

                                                  listaLotes!.clear();
                                                  setState(() {
                                                    _selectLote = null;
                                                    _selectDosis =
                                                        vacunasDosisService
                                                                .listaVacunasDosis![
                                                            index];
                                                  });

                                                  final tempLista =
                                                      await lotesVacunaProvider
                                                          .validarLotes(
                                                              _selectVacunas!
                                                                  .id_sysvacu04);
                                                  tempLista[0].codigo_mensaje ==
                                                          "0"
                                                      ? showDialog(
                                                          context: _scaffoldKey
                                                              .currentContext!,
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
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .error_outline,
                                                                  size: 40,
                                                                ),
                                                                color:
                                                                    Colors.red);
                                                          })
                                                      : {
                                                          loadingLoginService
                                                                  .getCargaLotesState!
                                                              ? mostrarLoadingEstrellasXTiempo(
                                                                  context, 800)
                                                              : () {},
                                                          setState(() {
                                                            listaLotes =
                                                                tempLista;
                                                            vacunasLotesService
                                                                .cargarListaVacunasLotes(
                                                                    tempLista);
                                                          }),
                                                          loadingLoginService
                                                              .cargaLotes(
                                                                  false),
                                                          setState(() {
                                                            pasos++;
                                                          })
                                                        };
                                                },
                                                child: Center(
                                                  child: Chip(
                                                    backgroundColor:
                                                        SisVacuColor.verceleste,
                                                    label: Text(
                                                        vacunasDosisService
                                                            .listaVacunasDosis![
                                                                index]
                                                            .sysvacu05_nombre!),

                                                    // leading: const Icon(
                                                    //     Icons
                                                    //         .medical_services_outlined),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                            ],
                          ),
                        )
                      : Container();
                },
              );
      },
    );
  }

  Widget containerLotes() {
    ScrollController lotesScrollController = ScrollController();

    return StreamBuilder(
      stream: vacunasLotesService.listaVacunasLotesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return vacunasLotesService.listavacunasLotes!.isEmpty
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                        child: RawScrollbar(
                          thumbColor: SisVacuColor.verceleste,
                          isAlwaysShown: true,
                          radius: const Radius.circular(20),
                          controller: lotesScrollController,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              width: MediaQuery.of(context).size.width * .05,
                            ),
                            scrollDirection: Axis.horizontal,
                            controller: lotesScrollController,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                vacunasLotesService.listavacunasLotes!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  loadingLoginService.getLoadingVerificarState!
                                      ? mostrarLoadingEstrellasXTiempo(
                                          context, 800)
                                      : () {};
                                  loadingLoginService.cargarVerificar(false);
                                  setState(() {
                                    _selectLote = vacunasLotesService
                                        .listavacunasLotes![index];
                                    pasos++;
                                  });
                                },
                                child: Chip(
                                  backgroundColor: SisVacuColor.verceleste,
                                  label: Text(vacunasLotesService
                                      .listavacunasLotes![index]
                                      .sysdesa18_lote!),

                                  // leading: const Icon(
                                  //     Icons
                                  //         .medical_services_outlined),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget containerVerificar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        width: MediaQuery.of(context).size.width,
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
            const Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Text('Continue para verificar los datos',
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget containerProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            'Si lo desea, toque el paso que quiere modificar',
            style: TextStyle(color: Colors.black.withOpacity(.7)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          StepProgressIndicator(
            totalSteps: 6,
            currentStep: pasos - 1,
            size: 36,
            selectedColor: SisVacuColor.verceleste!,
            unselectedColor: Colors.black.withOpacity(.7),
            customStep: (index, color, _) =>
                color != Colors.black.withOpacity(.7)
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            pasos = index + 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: color,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((index + 1).toString()),
                              const Icon(
                                Icons.check_sharp,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: color,
                        ),
                        child: const Icon(
                          Icons.remove,
                        ),
                      ),
          ),
        ],
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
                                context: _scaffoldKey.currentContext!,
                                builder: (BuildContext context) =>
                                    DialogoAlerta(
                                      envioFuncion2: false,
                                      envioFuncion1: false,
                                      tituloAlerta: 'Información',
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
                              context: _scaffoldKey.currentContext!,
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

  Widget botonRegistrarVacunacion() {
    return BotonCustom(
        text: 'Registrar Vacunación',
        onPressed: () {
          beneficiarioService.beneficiario!.sysdesa10_dni != ''
              ? int.parse(beneficiarioService.beneficiario!.sysdesa10_edad!) <
                      18
                  ? tutorService.existeTutor
                      ? tutorService.tutor!.sysdesa10_dni_tutor != ''
                          ? _selectVacunas != null
                              ? _selectCondicion != null
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
                                                  id_sysvacu01: _selectCondicion!
                                                      .id_sysvacu01!,
                                                  id_sysvacu02: _selectEsquema!
                                                      .id_sysvacu02!,
                                                  id_sysvacu05: _selectDosis!
                                                      .id_sysvacu05!,
                                                  nombreVacuna: _selectVacunas!
                                                      .sysvacu04_nombre,
                                                  nombreCondicion: _selectCondicion!
                                                      .sysvacu01_descripcion,
                                                  nombreEsquema: _selectEsquema!
                                                      .sysvacu02_descripcion,
                                                  nombreDosis: _selectDosis!
                                                      .sysvacu05_nombre,
                                                  nombreLote: _selectLote!
                                                      .sysdesa18_lote,
                                                  id_sysvacu04: _selectVacunas!
                                                      .id_sysvacu04, //Obligatorio
                                                  sysdesa10_apellido: beneficiarioService
                                                      .beneficiario!
                                                      .sysdesa10_apellido, //Obligatorio
                                                  sysdesa10_cadena_dni:
                                                      beneficiarioService
                                                          .beneficiario!
                                                          .sysdesa10_cadena_dni, //Solo con Escaner
                                                  sysdesa10_dni: beneficiarioService.beneficiario!.sysdesa10_dni, //Obligatorio
                                                  sysdesa10_nombre: beneficiarioService.beneficiario!.sysdesa10_nombre, //Obligatorio
                                                  sysdesa10_nro_tramite: beneficiarioService.beneficiario!.sysdesa10_nro_tramite, //Solo con Escaner
                                                  sysdesa10_sexo: beneficiarioService.beneficiario!.sysdesa10_sexo, //Obligatorio
                                                  sysdesa10_edad: beneficiarioService.beneficiario!.sysdesa10_edad, //DatosExtras que no se envian, SOlo para vista

                                                  //     nombreConfiguracion: _selectConfigVacuna!.sysvacu05_nombre! + '-' + _selectConfigVacuna!.sysvacu01_descripcion! + '-' + _selectConfigVacuna!.sysvacu02_descripcion!,
                                                  fecha_aplicacion: DateTime.now().toString(),
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
                                              (Route<dynamic> route) => false)
                                        }
                                      : showDialog(
                                          context: _scaffoldKey.currentContext!,
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
                                      context: _scaffoldKey.currentContext!,
                                      builder: (BuildContext context) {
                                        return const DialogoAlerta(
                                            envioFuncion2: false,
                                            envioFuncion1: false,
                                            tituloAlerta: 'ATENCIÓN!',
                                            descripcionAlerta:
                                                'Debe Seleccionar una Configuración',
                                            textoBotonAlerta: 'Listo',
                                            icon: Icon(
                                              Icons.error_outline,
                                              size: 40,
                                            ),
                                            color: Colors.red);
                                      })
                              : showDialog(
                                  context: _scaffoldKey.currentContext!,
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
                              context: _scaffoldKey.currentContext!,
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
                          context: _scaffoldKey.currentContext!,
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
                      ? _selectCondicion != null
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
                                              .registrador!.rela_sysofic01,
                                          id_sysvacu01:
                                              _selectCondicion!.id_sysvacu01!,
                                          id_sysvacu02:
                                              _selectEsquema!.id_sysvacu02!,
                                          id_sysvacu05:
                                              _selectDosis!.id_sysvacu05!,
                                          nombreVacuna:
                                              _selectVacunas!.sysvacu04_nombre,
                                          nombreCondicion: _selectCondicion!
                                              .sysvacu01_descripcion,
                                          nombreEsquema: _selectEsquema!
                                              .sysvacu02_descripcion,
                                          nombreDosis:
                                              _selectDosis!.sysvacu05_nombre,
                                          nombreLote: _selectLote!
                                              .sysdesa18_lote, //Obligatorio
                                          id_sysvacu04: _selectVacunas!
                                              .id_sysvacu04, //Obligatorio
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
                                          sysdesa10_sexo: beneficiarioService.beneficiario!.sysdesa10_sexo, //Obligatorio
                                          sysdesa10_edad: beneficiarioService.beneficiario!.sysdesa10_edad,
                                          fecha_aplicacion: DateTime.now().toString(),

                                          //DatosExtras que no se envian, SOlo para vista
                                          //   nombreConfiguracion: _selectConfigVacuna!.sysvacu05_nombre! + '-' + _selectConfigVacuna!.sysvacu01_descripcion! + '-' + _selectConfigVacuna!.sysvacu02_descripcion!,
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
                                      (Route<dynamic> route) => false)
                                }
                              : showDialog(
                                  context: _scaffoldKey.currentContext!,
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
                              context: _scaffoldKey.currentContext!,
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
                          context: _scaffoldKey.currentContext!,
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
                  context: _scaffoldKey.currentContext!,
                  builder: (BuildContext context) {
                    return const DialogoAlerta(
                        envioFuncion2: false,
                        envioFuncion1: false,
                        tituloAlerta: 'ATENCIÓN!',
                        descripcionAlerta: 'Hubo un error con el Beneficiario',
                        textoBotonAlerta: 'Listo',
                        icon: Icon(
                          Icons.error_outline,
                          size: 40,
                        ),
                        color: Colors.red);
                  });
        });
  }

  obtenerDatosBeneficiario(
      BuildContext context1, String dni, String sexoPersona) async {
    //Provider con Datos del Beneficiario
    //Cargo Datos de Beneficiario en Singleton, y envio parametros EDAD + DNI para recibir la lista de VACUNAS
    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario('', dni, sexoPersona);
    datosBeneficiario[0].codigo_mensaje == '0'
        ? showDialog(
            context: _scaffoldKey.currentContext!,
            builder: (BuildContext context) => DialogoAlerta(
                  envioFuncion2: false,
                  envioFuncion1: false,
                  tituloAlerta: 'Hubo un Error',
                  descripcionAlerta: datosBeneficiario[0].mensaje,
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
        context: _scaffoldKey.currentContext!,
        builder: (context) => DialogoAlerta(
              envioFuncion2: true,
              envioFuncion1: true,
              tituloAlerta: 'ATENCIÓN',
              descripcionAlerta:
                  'Seguro que desea salir? deberá logearse nuevamente',
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
