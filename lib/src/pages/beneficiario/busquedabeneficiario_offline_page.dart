import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';
import '../pages.dart';

class BusquedaBeneficiarioOffline extends StatefulWidget {
  const BusquedaBeneficiarioOffline({Key? key}) : super(key: key);
  static const String nombreRuta = 'BusquedaBeneficiarioOffline';

  @override
  _BusquedaBeneficiarioOfflineState createState() =>
      _BusquedaBeneficiarioOfflineState();
}

class _BusquedaBeneficiarioOfflineState
    extends State<BusquedaBeneficiarioOffline> {
  late bool genero;
  late bool generoTutor;
  late bool modo;
  bool loading = false;
  String? dniBeneficiario;
  String? dniTutor;
  String? sexoBeneficiario;
  late String sexoTutor;
  late bool esMenor;
  String? sexoMenor;
  late TextEditingController dniController;
  late FocusNode focusNode;
  late FocusNode focusNodeTutor;
  final TextEditingController controladorDni = TextEditingController();

  @override
  void initState() {
    genero = false;
    generoTutor = false;
    esMenor = false;
    modo = false;
    dniBeneficiario = '';
    dniTutor = '';
    sexoBeneficiario = 'F';
    sexoTutor = 'F';
    super.initState();
    dniController = TextEditingController();
    focusNode = FocusNode();
    focusNodeTutor = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    dniController.dispose();

    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    int duracionAnimacion = 1000;

    int duracionDelay = 0;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const BodyDrawer(),
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
        // drawer: BodyDrawer(),
        body: Stack(
          children: [
            const EncabezadoWave(),
            SingleChildScrollView(
              child: Column(
                children: [
                  FadeInRight(
                    duration: Duration(milliseconds: duracionAnimacion),
                    delay: Duration(milliseconds: duracionDelay),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.02,
                          top: MediaQuery.of(context).size.width * 0.02,
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
                                    'Beneficiario',
                                    textAlign: TextAlign.center,
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
                                    MediaQuery.of(context).size.width * 0.05),
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
                                    MediaQuery.of(context).size.width * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                autofocus: true,
                                controller: dniController,
                                keyboardType: TextInputType.number,
                                maxLength: 8,
                                focusNode: focusNode,
                                style: const TextStyle(color: Colors.blue),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.fingerprint),
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  labelText: 'Ingrese el DNI',
                                ),
                                onEditingComplete: () {
                                  focusNode.unfocus();
                                },
                                onChanged: (valor) {
                                  setState(() {
                                    dniBeneficiario = valor;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.05),
                            Text('Seleccione el Sexo',
                                style: GoogleFonts.barlow(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  FadeInLeft(
                    duration: Duration(milliseconds: duracionAnimacion),
                    delay: Duration(milliseconds: duracionDelay),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.02,
                          top: MediaQuery.of(context).size.width * 0.02,
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
                            Text('¿Es menor de edad?',
                                style: GoogleFonts.barlow(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No',
                                  style: GoogleFonts.nunito(
                                      color: !esMenor
                                          ? Colors.black87
                                          : Colors.grey[300],
                                      fontWeight: !esMenor
                                          ? FontWeight.w700
                                          : FontWeight.w100),
                                ),
                                Switch(
                                    activeColor: Colors.blue,
                                    inactiveTrackColor: Colors.pink,
                                    inactiveThumbColor: Colors.pink,
                                    value: esMenor,
                                    onChanged: (value) {
                                      setState(() {
                                        esMenor = value;
                                        controladorDni.text = '';
                                      });
                                    }),
                                Text(
                                  'Si',
                                  style: GoogleFonts.nunito(
                                      color: esMenor
                                          ? Colors.black87
                                          : Colors.grey[300],
                                      fontWeight: esMenor
                                          ? FontWeight.w700
                                          : FontWeight.w100),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  esMenor
                      ? FadeInRight(
                          duration: Duration(milliseconds: duracionAnimacion),
                          delay: Duration(milliseconds: duracionDelay),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.02,
                                top: MediaQuery.of(context).size.width * 0.02,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      FadeInUpBig(
                                        from: 25,
                                        child: Text(
                                          'Tutor',
                                          textAlign: TextAlign.center,
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
                                      'Ingrese el número de D.N.I. del tutor y seleccione el sexo',
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
                                      autofocus: true,
                                      controller: controladorDni,
                                      keyboardType: TextInputType.number,
                                      maxLength: 8,
                                      focusNode: focusNodeTutor,
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
                                      onEditingComplete: () {
                                        focusNodeTutor.unfocus();
                                      },
                                      onChanged: (valor) {
                                        setState(() {
                                          dniTutor = valor;
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Femenino',
                                        style: GoogleFonts.nunito(
                                            color: !generoTutor
                                                ? Colors.black87
                                                : Colors.grey[300],
                                            fontWeight: !generoTutor
                                                ? FontWeight.w700
                                                : FontWeight.w100),
                                      ),
                                      Switch(
                                          activeColor: Colors.blue,
                                          inactiveTrackColor: Colors.pink,
                                          inactiveThumbColor: Colors.pink,
                                          value: generoTutor,
                                          onChanged: (value) {
                                            setState(() {
                                              generoTutor = value;
                                              generoTutor
                                                  ? sexoTutor = 'M'
                                                  : sexoTutor = 'F';
                                            });
                                          }),
                                      Text(
                                        'Masculino',
                                        style: GoogleFonts.nunito(
                                            color: generoTutor
                                                ? Colors.black87
                                                : Colors.grey[300],
                                            fontWeight: generoTutor
                                                ? FontWeight.w700
                                                : FontWeight.w100),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  ElasticIn(
                      delay: const Duration(milliseconds: 1500),
                      child: BotonCustom(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        borderRadius: 30,
                        iconoBool: false,
                        iconoBoton: Icon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                        text: 'Siguiente',
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BusquedaBeneficiarioOffline()),
                              (Route<dynamic> route) => false);
                        },
                      )),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
