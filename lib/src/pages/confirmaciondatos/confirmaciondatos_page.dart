import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/domain/entities/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/data/repositories/repositories.dart';
import 'package:sistema_vacunacion/src/presentation/state/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class ConfirmarDatos extends StatefulWidget {
  const ConfirmarDatos({super.key});
  static const String nombreRuta = 'ConfirmarDatos';
  @override
  _ConfirmarDatosState createState() => _ConfirmarDatosState();
}

class _ConfirmarDatosState extends State<ConfirmarDatos> {
  bool habilitarCircular = false;
  bool _mostrarBeneficiario = false;
  bool _mostrarTutor = false;

  bool _hayTutor() {
    final t = tutorService.tutor;
    if (t == null) return false;
    return (t.sysdesa10_dni_tutor?.trim().isNotEmpty) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !habilitarCircular,
      child: Scaffold(
        appBar: const AppBarSesion(titulo: 'Confirmar datos'),
        backgroundColor: cs.surface,
        body: Stack(
          children: [
            RawScrollbar(
              thumbColor: cs.primary.withValues(alpha: 0.42),
              thumbVisibility: true,
              radius: const Radius.circular(AppEspaciado.radioBoton),
              thickness: 6,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppEspaciado.lg,
                  AppEspaciado.sm,
                  AppEspaciado.lg,
                  AppEspaciado.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _encabezadoPagina(),
                    const SizedBox(height: AppEspaciado.md),
                    _seccionResumenVacuna(),
                    const SizedBox(height: AppEspaciado.md),
                    _tarjetaBeneficiario(),
                    if (_hayTutor()) ...[
                      const SizedBox(height: AppEspaciado.sm),
                      _tarjetaTutor(),
                    ],
                    const SizedBox(height: AppEspaciado.xl),
                    _botonRegistrar(),
                    const SizedBox(height: AppEspaciado.sm),
                    _botonCancelar(),
                    SizedBox(
                      height: MediaQuery.paddingOf(context).bottom +
                          AppEspaciado.xl,
                    ),
                  ],
                ),
              ),
            ),
            if (habilitarCircular) _loadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _encabezadoPagina() {
    final cs = Theme.of(context).colorScheme;
    final bar = context.sisTipografia;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppEspaciado.sm),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: cs.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: AppEspaciado.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Revisión final',
                style: bar.tituloTarjeta.copyWith(
                  fontSize: 22,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'Verifique los datos antes de registrar la vacunación.',
                style: tt.bodySmall?.copyWith(
                  fontSize: 12,
                  color: AppSuperficies.textoSecundario(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _seccionResumenVacuna() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final r = insertRegistroService.registro!;

    Widget fila(String etiqueta, String? valor, IconData icono) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.md,
          vertical: AppEspaciado.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icono, size: 18, color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: AppEspaciado.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etiqueta,
                    style: tt.labelSmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppSuperficies.textoSecundario(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    valor?.isNotEmpty == true ? valor! : '—',
                    style: tt.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget divisor() => Divider(
          height: 1,
          thickness: 1,
          indent: AppEspaciado.md,
          endIndent: AppEspaciado.md,
          color: cs.outlineVariant.withValues(alpha: 0.35),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
            border:
                Border.all(color: cs.outlineVariant.withValues(alpha: 0.45)),
          ),
          child: Column(
            children: [
              fila('Vacuna', r.nombreVacuna, Icons.vaccines_outlined),
              divisor(),
              fila('Condición', r.nombreCondicion,
                  Icons.health_and_safety_outlined),
              divisor(),
              fila('Esquema', r.nombreEsquema, Icons.account_tree_outlined),
              divisor(),
              fila('Dosis', r.nombreDosis, Icons.numbers_outlined),
              divisor(),
              fila('Lote', r.nombreLote, Icons.inventory_2_outlined),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _decoracionTarjeta() {
    return AppSuperficies.tarjetaBlanca(context, radio: AppEspaciado.xl);
  }

  Widget _encabezadoColapsable({
    required IconData icono,
    required String rol,
    required String nombre,
    String? contexto,
    required bool expandido,
    required VoidCallback onAlternar,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
        onTap: onAlternar,
        child: Padding(
          padding: const EdgeInsets.all(AppEspaciado.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                constraints: const BoxConstraints(minHeight: 52),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppEspaciado.xs),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.55)],
                  ),
                ),
              ),
const SizedBox(width: AppEspaciado.lg),
              Icon(icono, color: cs.primary, size: 22),
const SizedBox(width: AppEspaciado.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rol.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.35,
                        height: 1.2,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nombre,
                      style: bar.tituloTarjeta.copyWith(
                        fontSize: 23,
                        height: 1.12,
                        color: cs.onSurface,
                      ),
                    ),
                    if (contexto != null && contexto.trim().isNotEmpty) ...[
                      const SizedBox(height: AppEspaciado.xs),
                      Text(
                        contexto.trim(),
                        style: tt.titleSmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                expandido
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: cs.onSurfaceVariant,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filaDato(String etiqueta, String valor) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppEspaciado.lg,
        vertical: AppEspaciado.md + AppEspaciado.xs,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppEspaciado.lg),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 12,
            child: Text(
              etiqueta,
              style: tt.labelLarge?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                height: 1.3,
                color: AppSuperficies.textoSecundario(context),
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: tt.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaBeneficiario() {
    final cs = Theme.of(context).colorScheme;
    final r = insertRegistroService.registro!;
    final nombre = r.sysdesa10_nombre?.trim() ?? '';
    final apellido = r.sysdesa10_apellido?.trim() ?? '';
    final resumen = [nombre, apellido].where((s) => s.isNotEmpty).join(' ');
    final nombreTarjeta =
        resumen.isNotEmpty ? resumen : 'Sin nombre en el registro';
    final dni = r.sysdesa10_dni?.trim() ?? '';
    final lineaCtx = dni.isNotEmpty ? 'Documento $dni' : 'Beneficiario';

    final filas = <Widget>[
      if (nombre.isNotEmpty) _filaDato('Nombre', nombre),
      if (apellido.isNotEmpty) _filaDato('Apellido', apellido),
      if (dni.isNotEmpty) _filaDato('D.N.I.', dni),
    ];

    return FadeInUpBig(
      from: 14,
      duration: const Duration(milliseconds: 380),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: _decoracionTarjeta(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppEspaciado.lg, AppEspaciado.lg, AppEspaciado.md, AppEspaciado.sm),
              child: _encabezadoColapsable(
                icono: Icons.badge_outlined,
                rol: 'Beneficiario',
                nombre: nombreTarjeta,
                contexto: lineaCtx,
                expandido: _mostrarBeneficiario,
                onAlternar: () =>
                    setState(() => _mostrarBeneficiario = !_mostrarBeneficiario),
              ),
            ),
            if (_mostrarBeneficiario)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppEspaciado.lg, 0, AppEspaciado.lg, AppEspaciado.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: cs.outlineVariant.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: AppEspaciado.lg),
                    ..._intercalarEspacio(filas),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaTutor() {
    final cs = Theme.of(context).colorScheme;
    final t = tutorService.tutor!;
    final nombre = t.sysdesa10_nombre_tutor?.trim() ?? '';
    final apellido = t.sysdesa10_apellido_tutor?.trim() ?? '';
    final resumen = [nombre, apellido].where((s) => s.isNotEmpty).join(' ');
    final nombreTarjeta =
        resumen.isNotEmpty ? resumen : 'Sin nombre en el registro';
    final dni = t.sysdesa10_dni_tutor?.trim() ?? '';
    final lineaCtx = dni.isNotEmpty ? 'Documento $dni' : 'Tutor o responsable';

    final filas = <Widget>[
      if (nombre.isNotEmpty) _filaDato('Nombre', nombre),
      if (apellido.isNotEmpty) _filaDato('Apellido', apellido),
      if (dni.isNotEmpty) _filaDato('D.N.I.', dni),
    ];

    return FadeInUpBig(
      from: 14,
      duration: const Duration(milliseconds: 380),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: _decoracionTarjeta(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppEspaciado.lg, AppEspaciado.lg, AppEspaciado.md, AppEspaciado.sm),
              child: _encabezadoColapsable(
                icono: Icons.family_restroom_outlined,
                rol: 'Tutor o responsable',
                nombre: nombreTarjeta,
                contexto: lineaCtx,
                expandido: _mostrarTutor,
                onAlternar: () =>
                    setState(() => _mostrarTutor = !_mostrarTutor),
              ),
            ),
            if (_mostrarTutor)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppEspaciado.lg, 0, AppEspaciado.lg, AppEspaciado.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: cs.outlineVariant.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: AppEspaciado.lg),
                    ..._intercalarEspacio(filas),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _intercalarEspacio(List<Widget> widgets) {
    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      if (i > 0) result.add(const SizedBox(height: 10));
      result.add(widgets[i]);
    }
    return result;
  }

  Widget _botonRegistrar() {
    return FilledButton.icon(
      style: AppBotones.estiloFilledIconCta(
        padding: const EdgeInsets.symmetric(
          horizontal: AppEspaciado.xl,
          vertical: AppEspaciado.lg,
        ),
      ),
      onPressed: habilitarCircular ? null : () => enviarDatos(context),
      icon: const Icon(Icons.check_circle_outline_rounded),
      label: const Text('Registrar vacunación'),
    );
  }

  Widget _botonCancelar() {
    final cs = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      style: AppBotones.estiloOutlinedPeligro(cs),
      icon: const Icon(Icons.cancel_outlined),
      label: const Text('Cancelar registro'),
      onPressed: habilitarCircular
          ? null
          : () {
              showDialog(
                context: context,
                builder: (BuildContext context) => DialogoAlerta(
                  tituloAlerta: 'Atención',
                  descripcionAlerta:
                      '¿Confirma cancelar el registro? Se perderán los datos no guardados.',
                  textoBotonAlerta: 'Sí, cancelar',
                  textoBotonAlerta2: 'Volver',
                  icon: const Icon(Icons.warning_amber_rounded, size: 28),
                  color: cs.error,
                  envioFuncion2: true,
                  funcion2: () => Navigator.of(context).pop(),
                  envioFuncion1: true,
                  funcion1: () {
                    vacunasxPerfilService.eliminarListaVacunasxPerfil();
                    perfilesVacunacionService.reiniciar();
                    vacunasConfiguracionService
                        .eliminarListaVacunasConfiguracion();
                    vacunasLotesService.eliminarListaVacunasLotes();
                    notificacionesDosisService.eliminarListaDosis();
                    insertRegistroService.cargarRegistro(InsertRegistros());
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusquedaBeneficiario(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              );
            },
    );
  }

  Widget _loadingOverlay() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      color: cs.scrim.withValues(alpha: 0.82),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppEspaciado.md),
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
    );
  }

  Future<void> enviarDatos(BuildContext context2) async {
    setState(() => habilitarCircular = true);
    try {
      final mensaje = await sistemaRepository.insertRegistroProd();
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
              MaterialPageRoute(builder: (context) => const ConfirmarDatos()),
              (Route<dynamic> route) => false,
            ),
            tituloAlerta: 'Atención',
            descripcionAlerta: mensaje[0].mensaje,
            textoBotonAlerta: 'Reintentar',
            color: Theme.of(dialogCtx).colorScheme.error,
            icon: const Icon(Icons.error, size: 40.0),
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
                builder: (context) => const BusquedaBeneficiario(),
              ),
              (Route<dynamic> route) => false,
            ),
            tituloAlerta: 'Información',
            descripcionAlerta: mensaje[0].mensaje,
            textoBotonAlerta: 'Listo',
            color: Theme.of(dialogCtx).colorScheme.primary,
            icon: const Icon(Icons.check_circle, size: 40.0),
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
