import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                child: const ResumenSesionVacunacion(compendio: true),
              ),
              const SizedBox(height: AppEspaciado.lg),
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

  Widget _tarjetaSelectorModo(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final suave = cs.onSurface.withValues(alpha: 0.5);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Forma de carga del D.N.I.',
            style: tt.labelLarge?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.xs),
          Text(
            modo
                ? 'Modo actual: ingreso manual del número'
                : 'Modo actual: escaneo con cámara',
            style: tt.bodyMedium?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: cs.primary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppEspaciado.sm),
          // Escanear — Switch — Manual: thumb izquierda = escanear, derecha = manual.
          Row(
            children: [
              Expanded(
                child: Text(
                  'Escanear',
                  textAlign: TextAlign.end,
                  style: tt.titleSmall?.copyWith(
                    fontSize: 15,
                    fontWeight: modo ? FontWeight.w500 : FontWeight.w800,
                    color: modo ? suave : cs.onSurface,
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
                  'Manual',
                  textAlign: TextAlign.start,
                  style: tt.titleSmall?.copyWith(
                    fontSize: 15,
                    fontWeight: modo ? FontWeight.w800 : FontWeight.w500,
                    color: modo ? cs.onSurface : suave,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tarjetaModoEscaner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;

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
                      style: bar.barlowTituloTarjeta.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Código del documento (frente o reverso)',
                      style: tt.labelLarge?.copyWith(
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
                tooltip: 'Ayuda: escanear o cargar D.N.I. del beneficiario',
                style: AppBotones.estiloIconoAyuda(cs),
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
                icon: const FaIcon(FontAwesomeIcons.circleInfo, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppEspaciado.lg),
          Text(
            'Escanee el código del DNI del beneficiario: frente (tarjeta nueva) o PDF417 del reverso (tarjeta anterior).',
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
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
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;
    final suave = cs.onSurface.withValues(alpha: 0.5);

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
            style: bar.barlowTituloTarjeta.copyWith(
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Documento y sexo registrados en el padrón',
            style: tt.bodyMedium?.copyWith(
              fontSize: 13,
              height: 1.35,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          Text(
            'Ingrese el D.N.I. (sin puntos) y confirme el sexo.',
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
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
              style: tt.titleMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              decoration: InputDecoration(
                counterText: '',
                icon: Icon(Icons.badge_outlined, color: cs.primary),
                labelText: 'D.N.I.',
                labelStyle: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                floatingLabelStyle:
                    tt.bodyMedium?.copyWith(color: cs.primary),
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
            style: tt.labelLarge?.copyWith(
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
              borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  genero
                      ? 'Sexo elegido: Masculino (M)'
                      : 'Sexo elegido: Femenino (F)',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: cs.primary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppEspaciado.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Femenino',
                      style: tt.bodyLarge?.copyWith(
                        color: !genero ? cs.onSurface : suave,
                        fontWeight:
                            !genero ? FontWeight.w800 : FontWeight.w500,
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
                      style: tt.bodyLarge?.copyWith(
                        color: genero ? cs.onSurface : suave,
                        fontWeight:
                            genero ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppEspaciado.xl),
          BotonCustom(
            text: 'Verificar datos',
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
                      icon: const FaIcon(
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
                  builder: (BuildContext dialogCtx) => DialogoAlerta(
                    envioFuncion2: false,
                    envioFuncion1: false,
                    tituloAlerta: 'Datos incompletos',
                    descripcionAlerta:
                        'Ingrese el D.N.I. (mínimo 7 dígitos) y el sexo.',
                    textoBotonAlerta: 'Listo',
                    color: Theme.of(dialogCtx).colorScheme.error,
                    icon: const Icon(
                      Icons.error_outline,
                      size: 40,
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
    try {
      final datosBeneficiario = await beneficiarioProviders
          .obtenerDatosBeneficiario('', dni, sexoPersona);
      final notificaciones =
          await notificacionesProvider.validarNotificaciones(dni, sexoPersona);
      if (!mounted) return;

      _cerrarDialogoCargaSiAbierta();

      if (notificaciones[0].codigo_mensaje == '1') {
        notificacionesDosisService.cargarListaDosis(notificaciones);
      } else {
        notificacionesDosisService.cargarRegistro(NotificacionesDosis());
      }

      if (datosBeneficiario[0].codigo_mensaje == '0') {
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
            color: Theme.of(context).colorScheme.error,
            icon: const Icon(
              Icons.error,
              size: 40,
            ),
          ),
        );
        return;
      }
      confirmarBeneficiario(datosBeneficiario[0]);
    } catch (_) {
      if (!mounted) return;
      _cerrarDialogoCargaSiAbierta();
      showDialog(
        context: context,
        builder: (BuildContext context) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'Sin conexión',
          descripcionAlerta:
              'No se pudieron obtener los datos del beneficiario. Revise la red e intente de nuevo.',
          textoBotonAlerta: 'Listo',
          color: Theme.of(context).colorScheme.error,
          icon: const Icon(
            Icons.wifi_off_rounded,
            size: 40,
          ),
        ),
      );
    }
  }

  /// Cierra el [AlertDialog] de «Espere por favor» si sigue abierto.
  void _cerrarDialogoCargaSiAbierta() {
    final NavigatorState nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) {
      nav.pop();
    }
    setState(() {
      loading = false;
    });
  }

  void confirmarBeneficiario(Beneficiario? beneficiario) {
    beneficiarioService.cargarBeneficiario(beneficiario);
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
              style: Theme.of(context).textTheme.titleMedium,
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
        tituloAlerta: '¿Cerrar sesión?',
        descripcionAlerta:
            'Si sale, deberá iniciar sesión otra vez escaneando su documento.',
        textoBotonAlerta: 'Sí, salir',
        textoBotonAlerta2: 'No',
        funcion1: () => Navigator.of(context).pop(true),
        funcion2: () => Navigator.of(context).pop(false),
        color: Theme.of(context).colorScheme.error,
        icon: const Icon(
          Icons.new_releases_outlined,
          size: 40,
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
    final tt = Theme.of(context).textTheme;

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
                  style: tt.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                Text(
                  'registradas',
                  style: tt.labelSmall?.copyWith(
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
                      style: tt.titleMedium?.copyWith(
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
