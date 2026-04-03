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

class BusquedaBeneficiario extends StatefulWidget {
  const BusquedaBeneficiario({Key? key}) : super(key: key);
  static const String nombreRuta = 'BusquedaBeneficiario';

  @override
  State<BusquedaBeneficiario> createState() => _BusquedaBeneficiarioState();
}

class _BusquedaBeneficiarioState extends State<BusquedaBeneficiario> {
  late bool genero;
  late bool modo;
  bool loading = false;
  String? dniBeneficiario;
  String? sexoBeneficiario;
  late TextEditingController dniController;
  late FocusNode focusNode;

  @override
  void initState() {
    genero = false;
    modo = false;
    dniBeneficiario = '';
    sexoBeneficiario = 'F';
    super.initState();
    dniController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const duracionAnimacion = 1000;
    const duracionDelay = 0;

    if (vacunadorService.existeVacunador != false) {
      _incrementoVacunados();
    }

    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) onWillPop();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        drawer: const BodyDrawer(),
        appBar: const AppBarSesion(
          titulo: 'Buscar beneficiario',
        ),
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
                duration: const Duration(milliseconds: duracionAnimacion),
                delay: const Duration(milliseconds: duracionDelay),
                child: _tarjetaSelectorModo(context),
              ),
              const SizedBox(height: AppEspaciado.lg),
              if (!modo)
                FadeInLeft(
                  duration: const Duration(milliseconds: duracionAnimacion),
                  delay: const Duration(milliseconds: duracionDelay),
                  child: _tarjetaModoEscaner(context),
                )
              else
                FadeInRight(
                  duration: const Duration(milliseconds: duracionAnimacion),
                  delay: const Duration(milliseconds: duracionDelay),
                  child: _tarjetaModoManual(context),
                ),
              const SizedBox(height: AppEspaciado.xl),
              const CantidadVacunados(),
            ],
          ),
        ),
      ),
    );
  }

  /// Conmutador Escaner / Manual (misma línea que opciones en vacunador).
  Widget _tarjetaSelectorModo(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final apagado = cs.onSurface.withValues(alpha: 0.38);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppEspaciado.md,
        vertical: AppEspaciado.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.42),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Modo escáner',
              textAlign: TextAlign.end,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: !modo ? FontWeight.w800 : FontWeight.w500,
                color: !modo ? cs.onSurface : apagado,
              ),
            ),
          ),
          Switch(
            value: modo,
            onChanged: (value) {
              setState(() {
                modo = value;
                dniBeneficiario = '';
                dniController.text = '';
              });
            },
          ),
          Expanded(
            child: Text(
              'Modo manual',
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: modo ? FontWeight.w800 : FontWeight.w500,
                color: modo ? cs.onSurface : apagado,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaModoEscaner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppEspaciado.lg),
      decoration: AppSuperficies.tarjeta(context).copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lectura del D.N.I.',
                      style: GoogleFonts.barlow(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Código de barras del reverso',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
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
                          'Si el beneficiario tiene el D.N.I., use Escanear y enfoque la cámara al código de barras. Si no lo tiene, cambie a modo manual, ingrese el número y el sexo.',
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
          const SizedBox(height: AppEspaciado.lg),
          Text(
            'Escanee el código de barras del reverso del documento del beneficiario.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              height: 1.45,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.xl),
          const SizedBox(
            width: double.infinity,
            child: EscanerDni(
              'Beneficiario',
              'Escanear documento',
              'textoAyuda',
              anchoValor: 44,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaModoManual(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppEspaciado.lg),
      decoration: AppSuperficies.tarjeta(context).copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ingreso manual',
            style: GoogleFonts.barlow(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Documento y sexo registrados en el padrón',
            style: GoogleFonts.nunito(
              fontSize: 13,
              height: 1.35,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          Text(
            'Ingrese el D.N.I. (sin puntos) y confirme el sexo.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              height: 1.45,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          Container(
            decoration: AppSuperficies.campoBusqueda(context),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              autofocus: true,
              controller: dniController,
              keyboardType: TextInputType.number,
              maxLength: 8,
              focusNode: focusNode,
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              decoration: InputDecoration(
                counterText: '',
                icon: Icon(Icons.badge_outlined, color: cs.primary),
                labelText: 'D.N.I.',
                labelStyle: GoogleFonts.nunito(color: cs.onSurfaceVariant),
                floatingLabelStyle: GoogleFonts.nunito(color: cs.primary),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              onEditingComplete: focusNode.unfocus,
              onChanged: (valor) {
                setState(() {
                  dniBeneficiario = valor;
                });
              },
            ),
          ),
          const SizedBox(height: AppEspaciado.xl),
          Text(
            'Sexo',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.md),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppEspaciado.sm,
              horizontal: AppEspaciado.md,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Femenino',
                  style: GoogleFonts.nunito(
                    color: !genero
                        ? cs.onSurface
                        : cs.onSurface.withValues(alpha: 0.38),
                    fontWeight:
                        !genero ? FontWeight.w800 : FontWeight.w400,
                  ),
                ),
                Switch(
                  value: genero,
                  onChanged: (value) {
                    setState(() {
                      genero = value;
                      sexoBeneficiario = value ? 'M' : 'F';
                    });
                  },
                ),
                Text(
                  'Masculino',
                  style: GoogleFonts.nunito(
                    color: genero
                        ? cs.onSurface
                        : cs.onSurface.withValues(alpha: 0.38),
                    fontWeight:
                        genero ? FontWeight.w800 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppEspaciado.xl),
          BotonCustom(
            text: 'Verificar datos',
            borderRadius: 16,
            onPressed: () {
              final dniOk = dniBeneficiario != '' &&
                  dniBeneficiario!.length >= 7 &&
                  dniBeneficiario != null;

              if (dniOk) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogoAlerta(
                      tituloAlerta: 'Verificar datos',
                      descripcionAlerta:
                          'D.N.I.: $dniBeneficiario — Sexo: $sexoBeneficiario',
                      textoBotonAlerta: 'Verificar',
                      textoBotonAlerta2: 'Cancelar',
                      funcion1: () {
                        obtenerDatosBeneficiario(
                          context,
                          dniBeneficiario,
                          sexoBeneficiario,
                        );
                        Navigator.of(context).pop();
                        setState(() {
                          loading = true;
                        });
                        retornarLoading(context, 'Espere por favor');
                      },
                      funcion2: () => Navigator.pop(context),
                      envioFuncion1: true,
                      envioFuncion2: true,
                      icon: const Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                      ),
                      color: SisVacuColor.vercelesteCuaternario,
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Datos incompletos',
                    descripcionAlerta:
                        'Ingrese el D.N.I. (mínimo 7 dígitos) y el sexo.',
                    textoBotonAlerta: 'Listo',
                    color: Colors.red,
                    icon: Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> obtenerDatosBeneficiario(
    BuildContext context1,
    String? dni,
    String? sexoPersona,
  ) async {
    final datosBeneficiario = await beneficiarioProviders
        .obtenerDatosBeneficiario('', dni, sexoPersona);
    final notificaciones =
        await notificacionesProvider.validarNotificaciones(dni, sexoPersona);
    if (notificaciones[0].codigo_mensaje == '1') {
      notificacionesDosisService.cargarListaDosis(notificaciones);
    } else {
      notificacionesDosisService.cargarRegistro(NotificacionesDosis());
    }

    if (datosBeneficiario[0].codigo_mensaje == '0') {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: true,
          funcion1: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BusquedaBeneficiario(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          tituloAlerta: 'No se pudo continuar',
          descripcionAlerta: datosBeneficiario[0].mensaje,
          textoBotonAlerta: 'Listo',
          color: Colors.red,
          icon: const Icon(
            Icons.error,
            size: 40,
            color: Colors.white,
          ),
        ),
      );
    } else {
      confirmarBeneficiario(datosBeneficiario[0]);
    }
  }

  void confirmarBeneficiario(Beneficiario? beneficiario) {
    setState(() {
      beneficiarioService.cargarBeneficiario(beneficiario);
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const VacunasPage()),
      (Route<dynamic> route) => false,
    );
  }

  void retornarLoading(BuildContext context, String mensaje) {
    if (loading) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              mensaje,
              style: GoogleFonts.nunito(),
            ),
            content: const LinearProgressIndicator(),
          );
        },
      );
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
      ),
    );
    return mensajeExit ?? false;
  }

  Future<void> _incrementoVacunados() async {
    final cantidadVacunas = await cantidadVacunadosProvider.cantidadVacunas();
    cantidadVacunasService.cargarCantidadVacunados(cantidadVacunas[0]);
  }
}

/// Resumen de dosis aplicadas (misma línea visual que el resto de tarjetas).
class CantidadVacunados extends StatefulWidget {
  const CantidadVacunados({Key? key}) : super(key: key);

  @override
  State<CantidadVacunados> createState() => _CantidadVacunadosState();
}

class _CantidadVacunadosState extends State<CantidadVacunados> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FadeInUp(
      from: 16,
      duration: const Duration(milliseconds: 800),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppEspaciado.lg),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.38),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Vacunaciones',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                Text(
                  'registradas',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppEspaciado.lg),
            Bounce(
              manualTrigger: false,
              from: 8,
              infinite: true,
              duration: const Duration(milliseconds: 2000),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.14,
                height: MediaQuery.of(context).size.width * 0.14,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.primary.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                child: StreamBuilder(
                  stream: cantidadVacunasService.cantidadvacunadosStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.primary,
                        ),
                      );
                    }
                    return Text(
                      cantidadVacunasService
                          .cantidadvacunados!.cantidad_aplicaciones!,
                      style: GoogleFonts.nunito(
                        color: cs.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: getValueForScreenType(
                          context: context,
                          mobile: 17,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
