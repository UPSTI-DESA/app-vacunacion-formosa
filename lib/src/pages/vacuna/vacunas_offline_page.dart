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

class VacunasPageOffline extends StatefulWidget {
  const VacunasPageOffline({
    Key? key,
  }) : super(key: key);
  static const String nombreRuta = 'VacunasPageOffline';
  @override
  _VacunasPageOfflineState createState() => _VacunasPageOfflineState();
}

class _VacunasPageOfflineState extends State<VacunasPageOffline> {
  bool? mostrarBeneficiario;
  bool? mostrarTutor;

  int pasos = 1;

  List<InfoVacunas>? listaVacunas;
  List<VacunasCondicion>? listaCondiciones;
  List<VacunasEsquema>? listaEsquemas;
  List<VacunasDosis>? listaDosis;
  List<Lotes>? listaLotes;
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
    // cargarPerfilesService(registradorService.registrador!.id_flxcore03!);
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
          centerTitle: true,
          backgroundColor: SisVacuColor.vercelesteCuaternario,
          title: FadeInLeftBig(
            from: 50,
            child: Text(
              'Modo Offline',
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
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BusquedaBeneficiarioOffline()),
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
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        pasos++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 5),
                                blurRadius: 5)
                          ],
                          color: SisVacuColor.vercelesteCuaternario!
                              .withOpacity(.75),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          'Vacuna 1',
                          textAlign: TextAlign.center,
                          style:
                              GoogleFonts.nunito(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget containerVacunas() {
    ScrollController vacunaScrollController = ScrollController();
    return Padding(
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
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, 5),
                                  blurRadius: 5)
                            ]),
                        child: TextField(
                            autocorrect: false,
                            controller: controladorBusqueda,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: 'Buscar Vacuna...',
                            ),
                            focusNode: focusNode,
                            onChanged: (value) {}),
                      ),
                      StreamBuilder(
                        stream: vacunasxPerfilService.listaBusquedaStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return controladorBusqueda.text.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: RawScrollbar(
                                    thumbColor: SisVacuColor.verceleste,
                                    isAlwaysShown: true,
                                    radius: const Radius.circular(20),
                                    controller: vacunaScrollController,
                                    child: ListView.builder(
                                      controller: vacunaScrollController,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              pasos++;
                                            });
                                          },
                                          child: const ListTile(
                                            title: Text('Nombre Vacuna'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: RawScrollbar(
                                    thumbColor: SisVacuColor.verceleste,
                                    isAlwaysShown: true,
                                    radius: const Radius.circular(20),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              pasos++;
                                            });
                                          },
                                          child: const ListTile(
                                            title: Text('nombre Vacuna'),
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
    );
  }

  Widget containerCondiciones() {
    ScrollController vacunaScrollController = ScrollController();
    return Padding(
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
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, 5),
                                  blurRadius: 5)
                            ]),
                        child: TextField(
                            autocorrect: false,
                            controller: controladorBusquedaCondicion,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: 'Buscar Condición...',
                            ),
                            focusNode: focusNode,
                            onChanged: (value) {}),
                      ),
                      StreamBuilder(
                        stream: vacunasCondicionService.listaBusquedaStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return controladorBusquedaCondicion.text.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: RawScrollbar(
                                    thumbColor: SisVacuColor.verceleste,
                                    isAlwaysShown: true,
                                    radius: const Radius.circular(20),
                                    controller: vacunaScrollController,
                                    child: ListView.builder(
                                      controller: vacunaScrollController,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              pasos++;
                                            });
                                          },
                                          child: const ListTile(
                                            title: Text('Nombre '),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: RawScrollbar(
                                    thumbColor: SisVacuColor.verceleste,
                                    isAlwaysShown: true,
                                    radius: const Radius.circular(20),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              pasos++;
                                            });
                                          },
                                          child: const ListTile(
                                            title: Text('Nombre'),
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
    );
  }

  Widget containerEsquemas() {
    ScrollController esquemaScrollController = ScrollController();
    return Padding(
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
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, 5),
                                  blurRadius: 5)
                            ]),
                        child: TextField(
                            autocorrect: false,
                            controller: controladorBusquedaEsquema,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: 'Buscar Esquema...',
                            ),
                            focusNode: focusNode,
                            onChanged: (value) {}),
                      ),
                      StreamBuilder(
                        stream: vacunasEsquemaService.listaBusquedaStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return controladorBusquedaEsquema.text.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: RawScrollbar(
                                    thumbColor: SisVacuColor.verceleste,
                                    isAlwaysShown: true,
                                    radius: const Radius.circular(20),
                                    controller: esquemaScrollController,
                                    child: ListView.builder(
                                      controller: esquemaScrollController,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              pasos++;
                                            });
                                          },
                                          child: const ListTile(
                                            title: Text('Nombre'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: RawScrollbar(
                                    thumbColor: SisVacuColor.verceleste,
                                    isAlwaysShown: true,
                                    radius: const Radius.circular(20),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              pasos++;
                                            });
                                          },
                                          child: const ListTile(
                                            title: Text('Nombre'),
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
    );
  }

  Widget containerDosis() {
    ScrollController dosisScrollController = ScrollController();
    return Padding(
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
                        fontWeight: FontWeight.w600, fontSize: 20)),
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
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
                stream: vacunasDosisService.listaBusquedaStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: RawScrollbar(
                      thumbColor: SisVacuColor.verceleste,
                      isAlwaysShown: true,
                      radius: const Radius.circular(20),
                      controller: dosisScrollController,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          width: MediaQuery.of(context).size.width * .05,
                        ),
                        scrollDirection: Axis.horizontal,
                        controller: dosisScrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                pasos++;
                              });
                            },
                            child: Center(
                              child: Chip(
                                backgroundColor: SisVacuColor.verceleste,
                                label: const Text('Nombre'),
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
    );
  }

  Widget containerLotes() {
    ScrollController lotesScrollController = ScrollController();

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
          children: [
            Row(
              children: [
                FadeInUpBig(
                  from: 25,
                  child: Text(
                    'Seleccione un Lote',
                    style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20)),
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
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    width: MediaQuery.of(context).size.width * .05,
                  ),
                  scrollDirection: Axis.horizontal,
                  controller: lotesScrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          pasos++;
                        });
                      },
                      child: Chip(
                        backgroundColor: SisVacuColor.verceleste,
                        label: const Text('Nombre'),
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

  Widget botonRegistrarVacunacion() {
    return BotonCustom(text: 'Guardar Datos', onPressed: () {});
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
