import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
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
  late DateTime fechaSeleccionada;
  late bool habilitarCircular;
  late bool mostrarBeneficiario;
  late bool mostrarTutor;
  late bool mostrarVacuna;

  @override
  void initState() {
    habilitarCircular = false;
    super.initState();
    fechaSeleccionada = DateTime.now();
    mostrarBeneficiario = false;
    mostrarTutor = false;
    mostrarVacuna = true;
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final bar = context.sisTipografia;
    final tt = Theme.of(context).textTheme;
    final estTituloSeccion =
        bar.barlowTituloTarjeta.copyWith(fontSize: 20, fontWeight: FontWeight.w600);
    final estDatoFila =
        tt.bodyLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 16);
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppEspaciado.xxl),
            child: FloatingActionButton(
              heroTag: "calendario",
              tooltip: 'Elegir fecha de aplicación',
              mini: true,
              onPressed: () async {
                final DateTime? fechaProvisoria = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime.now());

                fechaProvisoria != null
                    ? setState(() {
                        fechaSeleccionada = fechaProvisoria;
                      })
                    : null;
              },
              child: const FaIcon(FontAwesomeIcons.calendarDays, size: 20),
            ),
          ),
          FloatingActionButton(
            heroTag: "informacion",
            key: UniqueKey(),
            tooltip: 'Información antes de registrar',
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
                        color: SisVacuColor.vercelesteCuaternario,
                        icon: Icon(
                          Icons.info,
                          size: 40.0,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ));
            },
            child: const FaIcon(FontAwesomeIcons.exclamation, size: 20),
          ),
        ],
      ),
      appBar: const AppBarSesion(
        titulo: 'Confirmar datos',
      ),
      body: Stack(
        children: [
          const EncabezadoWave(),
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: AppEspaciado.md),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
                      child: ResumenSesionVacunacion(
                        mostrarNotaBackend: true,
                        colapsable: false,
                      ),
                    ),
                    const SizedBox(height: AppEspaciado.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
                      child: Container(
                        padding: const EdgeInsets.all(AppEspaciado.lg),
                        decoration: AppSuperficies.tarjeta(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FadeInUpBig(
                              from: 25,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Datos Beneficiario',
                                    style: estTituloSeccion,
                                  ),
                                  IconButton(
                                      tooltip: mostrarBeneficiario
                                          ? 'Ocultar datos del beneficiario'
                                          : 'Mostrar datos del beneficiario',
                                      onPressed: () {
                                        setState(() {
                                          mostrarBeneficiario
                                              ? mostrarBeneficiario = false
                                              : mostrarBeneficiario = true;
                                        });
                                      },
                                      icon: mostrarBeneficiario
                                          ? const Icon(Icons
                                              .keyboard_arrow_down_outlined)
                                          : const Icon(Icons
                                              .keyboard_arrow_right_outlined))
                                ],
                              ),
                            ),
                            mostrarBeneficiario
                                ? Column(
                                    children: [
                                      const SizedBox(height: AppEspaciado.lg),
                                      Row(
                                        children: [
                                          Text('Nombre: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!
                                                      .sysdesa10_nombre!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('Apellido: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!
                                                      .sysdesa10_apellido!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('D.N.I.: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!.sysdesa10_dni!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    tutorService.existeTutor
                        ? tutorService.tutor!.sysdesa10_dni_tutor == ''
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
                                child: Container(),
                              )
                            : Column(
                                children: [
                                  const SizedBox(height: AppEspaciado.lg),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
                                    child: Container(
                                      padding: const EdgeInsets.all(AppEspaciado.lg),
                                      decoration:
                                          AppSuperficies.tarjeta(context),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          FadeInUpBig(
                                            from: 25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Datos del Tutor',
                                                  style: estTituloSeccion,
                                                ),
                                                IconButton(
                                                    tooltip: mostrarTutor
                                                        ? 'Ocultar datos del tutor'
                                                        : 'Mostrar datos del tutor',
                                                    onPressed: () {
                                                      setState(() {
                                                        mostrarTutor
                                                            ? mostrarTutor =
                                                                false
                                                            : mostrarTutor =
                                                                true;
                                                      });
                                                    },
                                                    icon: mostrarTutor
                                                        ? const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                        : const Icon(Icons
                                                            .keyboard_arrow_right_outlined))
                                              ],
                                            ),
                                          ),
                                          mostrarTutor
                                              ? Column(
                                                  children: [
                                                    const SizedBox(
                                                        height:
                                                            AppEspaciado.lg),
                                                    Row(
                                                      children: [
                                                        Text('Nombre: ',
                                                            style: estDatoFila,
                                                            textAlign: TextAlign
                                                                .center),
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                                insertRegistroService
                                                                    .registro!
                                                                    .sysdesa10_nombre_tutor!,
                                                                style:
                                                                    estDatoFila,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                            AppEspaciado.sm),
                                                    Row(
                                                      children: [
                                                        Text('Apellido: ',
                                                            style: estDatoFila,
                                                            textAlign: TextAlign
                                                                .center),
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                                insertRegistroService
                                                                    .registro!
                                                                    .sysdesa10_apellido_tutor!,
                                                                style:
                                                                    estDatoFila,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                            AppEspaciado.sm),
                                                    Row(
                                                      children: [
                                                        Text('D.N.I.: ',
                                                            style: estDatoFila,
                                                            textAlign: TextAlign
                                                                .center),
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                                insertRegistroService
                                                                    .registro!
                                                                    .sysdesa10_dni_tutor!,
                                                                style:
                                                                    estDatoFila,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
                            child: Container(),
                          ),
                    const SizedBox(height: AppEspaciado.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
                      child: Container(
                        padding: const EdgeInsets.all(AppEspaciado.lg),
                        decoration: AppSuperficies.tarjeta(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FadeInUpBig(
                              from: 25,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Datos Vacunas',
                                    style: estTituloSeccion,
                                  ),
                                  IconButton(
                                      tooltip: mostrarVacuna
                                          ? 'Ocultar datos de vacunas'
                                          : 'Mostrar datos de vacunas',
                                      onPressed: () {
                                        setState(() {
                                          mostrarVacuna
                                              ? mostrarVacuna = false
                                              : mostrarVacuna = true;
                                        });
                                      },
                                      icon: mostrarVacuna
                                          ? const Icon(Icons
                                              .keyboard_arrow_down_outlined)
                                          : const Icon(Icons
                                              .keyboard_arrow_right_outlined))
                                ],
                              ),
                            ),
                            mostrarVacuna
                                ? Column(
                                    children: [
                                      const SizedBox(height: AppEspaciado.lg),
                                      Row(
                                        children: [
                                          Text('Vacuna: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.start),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!.nombreVacuna!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.start),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('Condición: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.start),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!
                                                      .nombreCondicion!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('Esquema: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.start),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!.nombreEsquema!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('Dosis: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.start),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!.nombreDosis!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('Lote: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.center),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  insertRegistroService
                                                      .registro!.nombreLote!,
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      Row(
                                        children: [
                                          Text('Fecha de Aplicación: ',
                                              style: estDatoFila,
                                              textAlign: TextAlign.start),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                  DateFormat('dd - MM - yyyy')
                                                      .format(
                                                          fechaSeleccionada),
                                                  style: estDatoFila,
                                                  textAlign: TextAlign.start),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppEspaciado.lg),
                    BotonCustom(
                        text: 'Registrar Vacunación',
                        onPressed: () {
                          // vacunasxPerfilService.eliminarListaVacunasxPerfil();
                          // perfilesVacunacionService.eliminarListaPerfiles();
                          // notificacionesDosisService.eliminarListaDosis();
                          // vacunasConfiguracionService
                          //     .eliminarListaVacunasConfiguracion();
                          // vacunasLotesService.eliminarListaVacunasLotes();
                          enviarDatos(context);
                        }),
                    Builder(
                      builder: (context) {
                        final cs = Theme.of(context).colorScheme;
                        return OutlinedButton.icon(
                          style: AppBotones.estiloOutlinedPeligro(cs),
                          icon: const Icon(
                            Icons.cancel_outlined,
                            size: 22,
                          ),
                          label: Text(
                            'Cancelar registro',
                            style: AppBotones.etiquetaBoton(
                              tt,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => DialogoAlerta(
                                tituloAlerta: 'Atención',
                                descripcionAlerta:
                                    '¿Confirma cancelar el registro? Se perderán los datos no guardados.',
                                textoBotonAlerta: 'Sí, cancelar',
                                textoBotonAlerta2: 'Volver',
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 28,
                                ),
                                color: cs.error,
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
                                  insertRegistroService
                                      .cargarRegistro(InsertRegistros());
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BusquedaBeneficiario(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppEspaciado.md),
                      child: Text(
                        'Si desea cambiar la fecha de aplicación, seleccione el calendario',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppSuperficies.textoSecundario(context)),
                      ),
                    )
                  ],
                ),
                habilitarCircular
                    ? Container(
                        height: mqSize.height,
                        width: mqSize.width,
                        color: Theme.of(context)
                            .colorScheme
                            .scrim
                            .withValues(alpha: 0.82),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              Text(
                                'Espere, por favor…',
                                style: tt.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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

  Future<void> enviarDatos(BuildContext context2) async {
    setState(() {
      habilitarCircular = true;
      tutorService.tutor != null ? tutorService.eliminarTutor() : null;
    });
    try {
      if (insertRegistroService.registro!.fecha_aplicacion !=
          fechaSeleccionada.toString()) {
        insertRegistroService.agregarFecha(fechaSeleccionada);
      }
      final mensaje = await insertRegistroProvider.insertRegistroProd();
      if (!mounted) return;
      setState(() => habilitarCircular = false);
      if (mensaje[0].codigo_mensaje == "0") {
        showDialog(
          context: context,
          builder: (BuildContext dialogCtx) => DialogoAlerta(
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
            color: Theme.of(dialogCtx).colorScheme.error,
            icon: const Icon(
              Icons.error,
              size: 40.0,
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext dialogCtx) => DialogoAlerta(
            envioFuncion2: false,
            envioFuncion1: true,
            funcion1: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BusquedaBeneficiario()),
                (Route<dynamic> route) => false),
            tituloAlerta: 'Información',
            descripcionAlerta: mensaje[0].mensaje,
            textoBotonAlerta: 'Listo',
            color: Theme.of(dialogCtx).colorScheme.primary,
            icon: const Icon(
              Icons.check_circle,
              size: 40.0,
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => habilitarCircular = false);
      showDialog(
        context: context,
        builder: (dialogCtx) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'Error de conexión',
          descripcionAlerta:
              'No se pudo registrar la vacunación. Revise la conexión a internet e intente de nuevo.',
          textoBotonAlerta: 'Entendido',
          color: Theme.of(dialogCtx).colorScheme.error,
          icon: const Icon(Icons.wifi_off_rounded, size: 40),
        ),
      );
    }
  }
}
