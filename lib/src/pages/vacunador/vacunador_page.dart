import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

import '../pages.dart';

class VacunadorPage extends StatefulWidget {
  static const String nombreRuta = 'VacunadorEstablecimiento';
  final List<Usuarios?> infoCargador;

  const VacunadorPage({Key? key, required this.infoCargador}) : super(key: key);

  @override
  State<VacunadorPage> createState() => _VacunadorPageState();
}

class _VacunadorPageState extends State<VacunadorPage> {
  late TextEditingController controladorDni;
  late FocusNode focusNode;
  bool estadoVacunador = false;
  bool? animacionNombreVacunado;
  bool? mismoVacunador;
  bool? esTerreno;
  bool? switchContainer;
  String? stringVacunador;
  String? stringTerreno;

  @override
  void initState() {
    mismoVacunador = true;
    esTerreno = true;
    animacionNombreVacunado = false;
    switchContainer = false;
    stringVacunador = 'No';
    stringTerreno = 'No';
    cargarEfectoresService(registradorService.registrador!.flxcore03_dni!);
    super.initState();
    controladorDni = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controladorDni.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) onWillPop();
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          appBar: const AppBarSesion(
            titulo: 'Equipo de trabajo',
            fadeDesde: 50,
          ),
          drawer: const BodyDrawer(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppEspaciado.lg,
              AppEspaciado.md,
              AppEspaciado.lg,
              AppEspaciado.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: _tarjetaResumenEquipo(context),
                ),
                const SizedBox(height: AppEspaciado.lg),
                StreamBuilder<Vacunador?>(
                  stream: vacunadorService.vacunadorStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) return const SizedBox.shrink();
                    return FadeIn(
                      duration: const Duration(milliseconds: 650),
                      child: _tarjetaOpcionesVacunacion(context),
                    );
                  },
                ),
                const SizedBox(height: AppEspaciado.lg),
                mismoVacunador == false
                    ? const SizedBox.shrink()
                    : vacunadorService.existeVacunador
                        ? const SizedBox.shrink()
                        : FadeIn(
                            duration: const Duration(milliseconds: 700),
                            child: _infoVacunador(context),
                          ),
                const SizedBox(height: AppEspaciado.xl),
                ElasticIn(
                  duration: const Duration(milliseconds: 720),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: BotonCustom(
                      text: 'Siguiente',
                      borderRadius: 16,
                      onPressed: () {
                        mismoVacunador!
                            ? verificarVacunador()
                            : {
                                vacunadorService.cargarVacunador(Vacunador(
                                    id_sysdesa12: registradorService
                                        .registrador!.flxcore03_dni,
                                    sysdesa06_nombre: registradorService
                                        .registrador!.flxcore03_nombre,
                                    sysdesa06_nro_documento: registradorService
                                        .registrador!.flxcore03_dni)),
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BusquedaBeneficiario()),
                                    (Route<dynamic> route) => false),
                              };
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _etiquetaSeccion(BuildContext context, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm, top: 2),
      child: Text(
        texto.toUpperCase(),
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.05,
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: 0.95),
        ),
      ),
    );
  }

  Widget _tarjetaResumenEquipo(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppEspaciado.lg),
      decoration: AppSuperficies.tarjeta(context).copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen',
                      style: GoogleFonts.barlow(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Efector, registrador y vacunador asignado',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        height: 1.35,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: cs.primary.withValues(alpha: 0.12),
                  foregroundColor: cs.primary,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DialogoAlerta(
                      envioFuncion2: false,
                      envioFuncion1: false,
                      tituloAlerta: 'Información',
                      descripcionAlerta:
                          'Seleccione el interruptor si es la misma persona que registra y realiza la vacunación.\nSi corresponde, cambie el efector con el ícono del hospital.',
                      textoBotonAlerta: 'Entendido',
                      color: SisVacuColor.vercelesteCuaternario,
                      icon: const Icon(Icons.info, size: 40, color: Colors.white),
                    ),
                  );
                },
                icon: const Icon(FontAwesomeIcons.circleInfo, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.md),
          _etiquetaSeccion(context, 'Establecimiento'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: registradorService.registradorStream,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return Text(
                      registradorService.registrador!.sysofic01_descripcion!,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: cs.onSurface,
                      ),
                    );
                  },
                ),
              ),
              Material(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _abrirSelectorEfectores(context),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: FaIcon(
                      FontAwesomeIcons.hospital,
                      size: getValueForScreenType(context: context, mobile: 18),
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.lg),
          Divider(
            height: 1,
            color: cs.outlineVariant.withValues(alpha: 0.45),
          ),
          const SizedBox(height: AppEspaciado.lg),
          _etiquetaSeccion(context, 'Personas'),
          _filaPersona(
            context,
            etiqueta: 'Registrador',
            valor: registradorService.registrador!.flxcore03_nombre!
                .toUpperCase(),
          ),
          const SizedBox(height: AppEspaciado.md),
          StreamBuilder<Vacunador?>(
            stream: vacunadorService.vacunadorStream,
            builder: (context, snapshot) {
              final valorVacunador = snapshot.hasData
                  ? vacunadorService.vacunador!.sysdesa06_nombre!
                  : (mismoVacunador!
                      ? 'Falta asignar'
                      : registradorService.registrador!.flxcore03_nombre!);
              final destacarPendiente =
                  !snapshot.hasData && mismoVacunador == true;
              return _filaPersona(
                context,
                etiqueta: 'Vacunador',
                valor: valorVacunador,
                destacarAlerta: destacarPendiente,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _filaPersona(
    BuildContext context, {
    required String etiqueta,
    required String valor,
    bool destacarAlerta = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 102,
          child: Text(
            etiqueta,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              valor,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight:
                    destacarAlerta ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: destacarAlerta ? 1.2 : 0,
                color: destacarAlerta ? cs.error : cs.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tarjetaOpcionesVacunacion(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppEspaciado.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.42),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Opciones de sesión',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          _filaSwitch(
            context,
            titulo: '¿Es el mismo vacunador?',
            valor: mismoVacunador!,
            onChanged: (v) {
              setState(() {
                mismoVacunador = v;
                stringVacunador = v ? 'Si' : 'No';
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppEspaciado.sm),
            child: Divider(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          _filaSwitch(
            context,
            titulo: '¿Es en terreno?',
            valor: esTerreno!,
            onChanged: (v) {
              setState(() {
                esTerreno = v;
                stringTerreno = v ? 'Si' : 'No';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _filaSwitch(
    BuildContext context, {
    required String titulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    final apagado = cs.onSurface.withValues(alpha: 0.38);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            titulo,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: cs.onSurface,
            ),
          ),
        ),
        Text(
          'Sí',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: valor ? FontWeight.w800 : FontWeight.w400,
            color: valor ? cs.onSurface : apagado,
          ),
        ),
        Switch(
          value: valor,
          onChanged: onChanged,
        ),
        Text(
          'No',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: !valor ? FontWeight.w800 : FontWeight.w400,
            color: !valor ? cs.onSurface : apagado,
          ),
        ),
      ],
    );
  }

  void _abrirSelectorEfectores(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outlineVariant.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppEspaciado.lg,
                      AppEspaciado.lg,
                      AppEspaciado.lg,
                      AppEspaciado.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_hospital_rounded, color: cs.primary),
                        const SizedBox(width: AppEspaciado.sm),
                        Text(
                          'Efectores',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: efectoresService.listaEfectoresStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return ListView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: AppEspaciado.xl),
                          itemCount:
                              efectoresService.listaEfectores?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                efectoresService.listaEfectores![index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    cs.primary.withValues(alpha: 0.12),
                                child: FaIcon(
                                  FontAwesomeIcons.hospital,
                                  size: 18,
                                  color: cs.primary,
                                ),
                              ),
                              title: Text(
                                item.sysofic01Descripcion!,
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () {
                                registradorService
                                    .editarEfectorUsuario(item);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoVacunador(BuildContext context) {
    return StreamBuilder<Vacunador?>(
      stream: vacunadorService.vacunadorStream,
      builder: (BuildContext context, AsyncSnapshot<Vacunador?> snapshot) {
        if (vacunadorService.existeVacunador) {
          return const SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppEspaciado.lg),
          decoration: AppSuperficies.tarjeta(context).copyWith(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registro del vacunador',
                          style: GoogleFonts.barlow(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Escanee el código o ingrese el D.N.I.',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.12),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => DialogoAlerta(
                          envioFuncion2: false,
                          envioFuncion1: false,
                          tituloAlerta: 'Información',
                          descripcionAlerta:
                              'Registre al vacunador escaneando el código de barras del D.N.I. o ingresando el número manualmente.',
                          textoBotonAlerta: 'Listo',
                          color: SisVacuColor.vercelesteCuaternario,
                          icon: const Icon(Icons.info,
                              size: 40, color: Colors.white),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.circleInfo,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppEspaciado.lg),
              EscanerDni(
                'Vacunador',
                'Escanear',
                'Escanee el D.N.I. del Vacunador',
                largoValor: 150,
              ),
              const SizedBox(height: AppEspaciado.lg),
              CustomInput(
                autoFocus: true,
                focusNode: focusNode,
                icon: Icons.perm_identity,
                placeholder: 'D.N.I.',
                keyboardType: TextInputType.phone,
                textController: controladorDni,
                funcionTerminar: true,
                funcion: () {
                  verificarEscencialText(controladorDni.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> verificarVacunador() async {
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
                    'Escanee o ingrese manualmente el D.N.I. del vacunador',
                textoBotonAlerta: 'Listo',
                color: Colors.red,
                icon: const Icon(
                  Icons.new_releases_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ));
    }
  }

  Future<void> verificarEscencialText(String dni) async {
    final respUsuario = await vacunadorProviders.validarVacunador(dni);

    if (respUsuario[0].codigo_mensaje == '0') {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogoAlerta(
                envioFuncion2: false,
                envioFuncion1: false,
                tituloAlerta: 'Error',
                descripcionAlerta: respUsuario[0].mensaje,
                textoBotonAlerta: 'Listo',
                color: Colors.red,
                icon: const Icon(
                  Icons.new_releases_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ));
      controladorDni.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 2.0,
          backgroundColor: SisVacuColor.red!.withValues(alpha: 0.7),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          content: Text(
            ':(',
            style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          )));
    } else {
      setState(() {
        vacunadorService.cargarVacunador(respUsuario[0]);
        estadoVacunador = true;
      });
      controladorDni.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 2.0,
          backgroundColor: SisVacuColor.vercelestePrimario,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          content: Text(
            'Se agregó al vacunador',
            style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          )));
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
                  '¿Seguro que desea salir? Deberá iniciar sesión nuevamente',
              textoBotonAlerta: 'SÍ',
              textoBotonAlerta2: 'NO',
              funcion1: () => Navigator.of(context).pop(true),
              funcion2: () => Navigator.of(context).pop(false),
              color: Colors.red,
              icon: const Icon(
                Icons.new_releases_outlined,
                size: 40,
                color: Colors.white,
              ),
            ));
    return mensajeExit ?? false;
  }

  void cargarEfectoresService(String dni) {
    efectoresProviders.obtenerDatosEfectores(dni);
  }
}
