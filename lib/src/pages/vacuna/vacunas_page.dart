import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/domain/entities/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/pages/vacuna/vacunas_ui_helpers.dart';
import 'package:sistema_vacunacion/src/data/datasources/providers.dart';
import 'package:sistema_vacunacion/src/data/repositories/repositories.dart';
import 'package:sistema_vacunacion/src/presentation/state/services.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class VacunasPage extends StatefulWidget {
  const VacunasPage({super.key});
  static const String nombreRuta = 'VacunasPage';
  @override
  _VacunasPageState createState() => _VacunasPageState();
}

class _VacunasPageState extends State<VacunasPage> {
  bool mostrarBeneficiario = false;
  bool mostrarTutor = false;

  int pasos = 1;
  PerfilesVacunacion? _selectPerfil;
  VacunasxPerfil? _selectVacunas;
  VacunasCondicion? _selectCondicion;
  VacunasEsquema? _selectEsquema;
  VacunasDosis? _selectDosis;

  DateTime _selectFecha = DateTime.now();

  List<InfoVacunas>? listaVacunas;
  List<VacunasCondicion>? listaCondiciones;
  List<VacunasEsquema>? listaEsquemas;
  List<VacunasDosis>? listaDosis;
  List<Lotes>? listaLotes;
  Lotes? _selectLote;
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
  final TextEditingController controladorBusquedaLotes =
      TextEditingController();
  late FocusNode focusNode;

  bool _recargandoPerfiles = false;

  final ScrollController _generalScroll = ScrollController();

  // Scroll controllers de cada paso — a nivel de clase para evitar recreación
  // en cada rebuild (setState) y garantizar su dispose correcto.
  final ScrollController _scrollVacunas = ScrollController();
  final ScrollController _scrollCondiciones = ScrollController();
  final ScrollController _scrollEsquemas = ScrollController();

  @override
  void initState() {
    super.initState();
    mostrarBeneficiario = false;
    mostrarTutor = false;
    pasos = 1;
    listaCondiciones = [];
    listaEsquemas = [];
    listaDosis = [];
    listaVacunas = [];
    listaLotes = [];
    focusNode = FocusNode();
    cargarPerfilesService(registradorService.registrador!.id_flxcore03!);
  }

  @override
  void dispose() {
    _generalScroll.dispose();
    _scrollVacunas.dispose();
    _scrollCondiciones.dispose();
    _scrollEsquemas.dispose();
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) onWillPop();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: cs.surface,
        appBar: AppBarSesion(
          titulo: 'Vacunas',
          leading: Center(
            child: IconButton(
              style: IconButton.styleFrom(
                foregroundColor: cs.onPrimary,
                backgroundColor: cs.onPrimary.withValues(alpha: 0.2),
              ),
              tooltip: 'Historial de dosis aplicadas',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppEspaciado.radioCampo),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.52,
                      minChildSize: 0.32,
                      maxChildSize: 0.95,
                      expand: false,
                      builder: (context, scrollController) {
                        return vacunasAplicadas(
                          scrollController: scrollController,
                        );
                      },
                    );
                  },
                );
              },
              icon: const FaIcon(FontAwesomeIcons.hospitalUser, size: 20),
            ),
          ),
        ),
        body: RawScrollbar(
          thumbColor: cs.primary.withValues(alpha: 0.42),
          thumbVisibility: true,
          radius: const Radius.circular(AppEspaciado.radioBoton),
          thickness: 6,
          controller: _generalScroll,
          child: SingleChildScrollView(
            controller: _generalScroll,
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
                const VacunasEncabezadoPagina(),
                const SizedBox(height: AppEspaciado.sm),
                VacunasPanelFlujo(
                  pasoActual: pasos,
                  onIrAPaso: (p) => setState(() => pasos = p),
                  perfil: _selectPerfil?.sysvacu12_descripcion,
                  vacuna: _selectVacunas?.sysvacu04_nombre,
                  condicion: _selectCondicion?.sysvacu01_descripcion,
                  esquema: _selectEsquema?.sysvacu02_descripcion,
                  dosis: _selectDosis?.sysvacu05_nombre,
                  fecha: pasos > 6
                      ? '${_selectFecha.day.toString().padLeft(2, '0')}/${_selectFecha.month.toString().padLeft(2, '0')}/${_selectFecha.year}'
                      : null,
                  lote: _selectLote?.sysdesa18_lote,
                  child: containerPasos(),
                ),
                const SizedBox(height: AppEspaciado.md),
                containerBeneficiario(),
                const SizedBox(height: AppEspaciado.sm),
                containerTutor(),
                const SizedBox(height: AppEspaciado.sm),

                const SizedBox(height: AppEspaciado.xl),
                if (pasos == 8) botonRegistrarVacunacion(),
                Padding(
                  padding: const EdgeInsets.only(top: AppEspaciado.md),
                  child: OutlinedButton.icon(
                    style: AppBotones.estiloOutlinedPeligro(cs),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar registro'),
                    onPressed: () {
                      showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (BuildContext context) => DialogoAlerta(
                          tituloAlerta: 'Cancelar registro',
                          descripcionAlerta:
                              '¿Confirma cancelar? Se perderán los datos no guardados de esta vacuna.',
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
                            vacunasxPerfilService.eliminarListaVacunasxPerfil();
                            perfilesVacunacionService.reiniciar();
                            vacunasConfiguracionService
                                .eliminarListaVacunasConfiguracion();
                            vacunasLotesService.eliminarListaVacunasLotes();
                            notificacionesDosisService.eliminarListaDosis();

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
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.paddingOf(context).bottom + AppEspaciado.xl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget containerPasos() {
    // 1 -> Perfiles // 2 -> Vacuna // 3 -> Condicion // 4 -> Esquema // 5 -> Dosis // 6 -> Fecha // 7 -> Lote // 8 -> Verificar
    final Widget child;
    switch (pasos) {
      case 1:
        child = containerPerfiles();
        break;
      case 2:
        child = containerVacunas();
        break;
      case 3:
        child = containerCondiciones();
        break;
      case 4:
        child = containerEsquemas();
        break;
      case 5:
        child = containerDosis();
        break;
      case 6:
        child = containerFecha();
        break;
      case 7:
        child = containerLotes();
        break;
      case 8:
        child = containerVerificar();
        break;
      default:
        child = containerPerfiles();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(key: ValueKey<int>(pasos), child: child),
    );
  }

  Widget vacunasAplicadas({ScrollController? scrollController}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppEspaciado.sm),
          Center(
            child: Container(
              width: 44,
              height: AppEspaciado.xs,
              decoration: BoxDecoration(
                color: cs.outlineVariant.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(AppEspaciado.xs),
              ),
            ),
          ),
          const SizedBox(height: AppEspaciado.radioCampo),
          Text(
            'Historial de dosis',
            style: bar.tituloTarjeta.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppEspaciado.xs),
          Text(
            'Beneficiario en pantalla · solo lectura',
            style: tt.titleSmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppSuperficies.textoSecundario(context),
            ),
          ),
          const SizedBox(height: AppEspaciado.lg),
          Expanded(
            child: StreamBuilder(
              stream: notificacionesDosisService.listaDosisAplicadasStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return notificacionesDosisService.listaDosisAplicadas.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: AppEspaciado.xl),
                        itemCount: notificacionesDosisService
                            .listaDosisAplicadas
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          final d = notificacionesDosisService
                              .listaDosisAplicadas[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppEspaciado.sm,
                            ),
                            child: Material(
                              color: cs.surfaceContainerHighest.withValues(
                                alpha: 0.55,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppEspaciado.radioCampo,
                                ),
                                side: BorderSide(
                                  color: cs.outlineVariant.withValues(
                                    alpha: 0.38,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppEspaciado.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${d.sysvacu05_nombre!} · ${d.sysvacu04_nombre!}',
                                      style: tt.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        height: 1.25,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: AppEspaciado.sm),
                                    Text(
                                      'Lote ${d.sysdesa18_lote!}',
                                      style: tt.bodyMedium?.copyWith(
                                        fontSize: 13,
                                        color: AppSuperficies.textoSecundario(
                                          context,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Aplicación ${d.sysdesa10_fecha_aplicacion!}',
                                      style: tt.bodyMedium?.copyWith(
                                        fontSize: 13,
                                        color: AppSuperficies.textoSecundario(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppEspaciado.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.vaccines_outlined,
                                size: 52,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                              const SizedBox(height: AppEspaciado.md),
                              Text(
                                'Sin dosis registradas',
                                textAlign: TextAlign.center,
                                style: bar.subtituloTarjeta.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppEspaciado.sm),
                              Text(
                                'Cuando existan aplicaciones previas, aparecerán aquí.',
                                textAlign: TextAlign.center,
                                style: tt.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  height: 1.35,
                                  color: AppSuperficies.textoSecundario(
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoracionTarjetaIdentidadVacunas() {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppEspaciado.xl),
      border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
      boxShadow: [
        BoxShadow(
          color: cs.shadow.withValues(alpha: 0.08),
          blurRadius: 22,
          offset: const Offset(0, 10),
          spreadRadius: -6,
        ),
      ],
    );
  }

  Widget _encabezadoIdentidadColapsable({
    required IconData icono,
    required String rol,
    required String nombreDestacado,
    String? lineaContexto,
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
              const SizedBox(width: 14),
              Icon(icono, color: cs.primary, size: AppTamanoIcono.mediano),
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
                    const SizedBox(height: AppEspaciado.sm),
                    Text(
                      nombreDestacado,
                      style: bar.tituloTarjeta.copyWith(
                        fontSize: 23,
                        height: 1.12,
                        color: cs.onSurface,
                      ),
                    ),
                    if (lineaContexto != null &&
                        lineaContexto.trim().isNotEmpty) ...[
                      const SizedBox(height: AppEspaciado.xs),
                      Text(
                        lineaContexto.trim(),
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

  /// No muestra filas con cadena vacía; [ceroEsVacio] para C.U.I.L. / trámite cuando el API manda "0".
  bool _beneficiarioValorVisible(String? valor, {bool ceroEsVacio = false}) {
    final t = valor?.trim() ?? '';
    if (t.isEmpty) return false;
    if (ceroEsVacio && t == '0') return false;
    return true;
  }

  List<Widget> _filasDetalleBeneficiario(BuildContext context, Beneficiario b) {
    final filas = <Widget>[];
    void agregar(String etiqueta, String? valor, {bool ceroEsVacio = false}) {
      if (!_beneficiarioValorVisible(valor, ceroEsVacio: ceroEsVacio)) return;
      filas.add(_filaDatoBeneficiario(etiqueta, valor!.trim()));
    }

    agregar('Nombre', b.sysdesa10_nombre);
    agregar('Apellido', b.sysdesa10_apellido);
    agregar('D.N.I.', b.sysdesa10_dni);
    final sexoRaw = b.sysdesa10_sexo?.trim();
    if (sexoRaw != null && sexoRaw.isNotEmpty) {
      agregar('Sexo registrado', _sexoRegistradoLegible(sexoRaw));
    }
    final fnDni = beneficiarioService.fechaNacimientoDesdePdf417Escaneado;
    if (fnDni != null && fnDni.trim().isNotEmpty) {
      filas.add(_filaDatoBeneficiario('Fecha de nacimiento', fnDni.trim()));
    } else {
      agregar('Fecha de nacimiento', b.sysdesa10_fecha_nacimiento);
    }
    final edadDni = beneficiarioService.edadAniosDesdePdf417Escaneado;
    if (edadDni != null && edadDni.trim().isNotEmpty) {
      filas.add(_filaDatoBeneficiario('Edad', '${edadDni.trim()} años'));
    } else if (_beneficiarioValorVisible(b.sysdesa10_edad)) {
      filas.add(
        _filaDatoBeneficiario('Edad', '${b.sysdesa10_edad!.trim()} años'),
      );
    }
    agregar('C.U.I.L.', b.sysdesa10_cuil, ceroEsVacio: true);
    agregar('N.º de trámite', b.sysdesa10_nro_tramite, ceroEsVacio: true);

    if (filas.isEmpty) {
      filas.add(
        Text(
          'Sin datos de identificación',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.35,
            color: AppSuperficies.textoSecundario(context),
          ),
        ),
      );
    }
    return filas;
  }

  List<Widget> _filasDetalleTutor(BuildContext context, Tutor t) {
    final filas = <Widget>[];
    void agregar(String etiqueta, String? valor) {
      if (!_beneficiarioValorVisible(valor)) return;
      filas.add(_filaDatoBeneficiario(etiqueta, valor!.trim()));
    }

    agregar('Nombre', t.sysdesa10_nombre_tutor);
    agregar('Apellido', t.sysdesa10_apellido_tutor);
    agregar('D.N.I.', t.sysdesa10_dni_tutor);
    final sexoRaw = t.sysdesa10_sexo_tutor?.trim();
    if (sexoRaw != null && sexoRaw.isNotEmpty) {
      agregar('Sexo registrado', _sexoRegistradoLegible(sexoRaw));
    }

    if (filas.isEmpty) {
      filas.add(
        Text(
          'Sin datos del tutor',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.35,
            color: AppSuperficies.textoSecundario(context),
          ),
        ),
      );
    }
    return filas;
  }

  String _sexoRegistradoLegible(String? codigo) {
    if (codigo == null || codigo.trim().isEmpty) return '—';
    switch (codigo.trim().toUpperCase()) {
      case 'M':
        return 'Masculino';
      case 'F':
        return 'Femenino';
      default:
        return codigo;
    }
  }

  Widget containerBeneficiario() {
    final b = beneficiarioService.beneficiario;
    if (b == null) {
      return const SizedBox.shrink();
    }
    final nombre = b.sysdesa10_nombre?.trim() ?? '';
    final apellido = b.sysdesa10_apellido?.trim() ?? '';
    final resumen = [nombre, apellido].where((s) => s.isNotEmpty).join(' ');
    final nombreTarjeta = resumen.isNotEmpty
        ? resumen
        : 'Sin nombre en el registro';
    final dni = b.sysdesa10_dni?.trim() ?? '';
    final lineaCtx = dni.isNotEmpty
        ? 'Documento $dni'
        : 'Persona que recibirá la dosis';

    final cs = Theme.of(context).colorScheme;
    final filasDetalle = _filasDetalleBeneficiario(context, b);
    final bloquesDetalle = <Widget>[];
    for (var i = 0; i < filasDetalle.length; i++) {
      if (i > 0) bloquesDetalle.add(const SizedBox(height: AppEspaciado.md));
      bloquesDetalle.add(filasDetalle[i]);
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _decoracionTarjetaIdentidadVacunas(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInUpBig(
            from: 14,
            duration: const Duration(milliseconds: 380),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 14, 12),
              child: _encabezadoIdentidadColapsable(
                icono: Icons.badge_outlined,
                rol: 'Beneficiario',
                nombreDestacado: nombreTarjeta,
                lineaContexto: lineaCtx,
                expandido: mostrarBeneficiario,
                onAlternar: () {
                  setState(() {
                    mostrarBeneficiario = !mostrarBeneficiario;
                  });
                },
              ),
            ),
          ),
          if (mostrarBeneficiario)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: AppEspaciado.lg),
                  ...bloquesDetalle,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _filaDatoBeneficiario(String etiqueta, String valor) {
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

  static const double _alturaListaPaso = 280;

  Widget _scrollbarConTema({
    required ScrollController controller,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;
    return RawScrollbar(
      thumbVisibility: true,
      thickness: 5,
      radius: const Radius.circular(AppEspaciado.radioBoton),
      thumbColor: cs.primary.withValues(alpha: 0.42),
      controller: controller,
      child: child,
    );
  }

  Widget _tarjetaOpcionFila({
    required bool seleccionado,
    required String titulo,
    String? subtitulo,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: Material(
        color: seleccionado
            ? cs.primaryContainer.withValues(alpha: 0.5)
            : cs.surfaceContainerHighest.withValues(alpha: 0.42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppEspaciado.lg),
          side: BorderSide(
            color: seleccionado
                ? cs.primary
                : cs.outlineVariant.withValues(alpha: 0.4),
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppEspaciado.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppEspaciado.md,
              vertical: AppEspaciado.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: seleccionado
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 15,
                          height: 1.25,
                          color: cs.onSurface,
                        ),
                      ),
                      if (subtitulo != null) ...[
                        const SizedBox(height: AppEspaciado.xs),
                        Text(
                          subtitulo,
                          style: tt.bodySmall?.copyWith(
                            fontSize: 12,
                            color: AppSuperficies.textoSecundario(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: seleccionado
                      ? cs.primary
                      : cs.onSurfaceVariant.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tutor dado de alta con D.N.I.
  bool _tutorTieneDocumentoCargado(Tutor? t) {
    if (t == null) return false;
    final dni = t.sysdesa10_dni_tutor?.trim() ?? '';
    return dni.isNotEmpty;
  }

  /// Tarjeta colapsable del tutor ya validado (solo datos).
  Widget _columnaTarjetaTutor(Tutor tut) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Builder(
          builder: (context) {
            final n = tut.sysdesa10_nombre_tutor?.trim() ?? '';
            final a = tut.sysdesa10_apellido_tutor?.trim() ?? '';
            final sub = [n, a].where((s) => s.isNotEmpty).join(' ');
            final nombreTutor = sub.isNotEmpty
                ? sub
                : 'Sin nombre en el registro';
            final dniT = tut.sysdesa10_dni_tutor?.trim() ?? '';
            final lineaTutor = dniT.isNotEmpty
                ? 'Documento $dniT'
                : 'Tutor o responsable';
            final cs = Theme.of(context).colorScheme;
            final filasT = _filasDetalleTutor(context, tut);
            final bloquesT = <Widget>[];
            for (var i = 0; i < filasT.length; i++) {
              if (i > 0) {
                bloquesT.add(const SizedBox(height: AppEspaciado.md));
              }
              bloquesT.add(filasT[i]);
            }
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: _decoracionTarjetaIdentidadVacunas(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInUpBig(
                    from: 14,
                    duration: const Duration(milliseconds: 380),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 14, 12),
                      child: _encabezadoIdentidadColapsable(
                        icono: Icons.family_restroom_outlined,
                        rol: 'Tutor o responsable',
                        nombreDestacado: nombreTutor,
                        lineaContexto: lineaTutor,
                        expandido: mostrarTutor,
                        onAlternar: () {
                          setState(() {
                            mostrarTutor = !mostrarTutor;
                          });
                        },
                      ),
                    ),
                  ),
                  if (mostrarTutor)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: cs.outlineVariant.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: AppEspaciado.lg),
                          ...bloquesT,
                          const SizedBox(height: AppEspaciado.lg),
                          OutlinedButton.icon(
                            style: AppBotones.estiloOutlinedAccion(cs),
                            onPressed: () {
                              setState(() {
                                tutorService.reiniciar();
                                mostrarTutor = false;
                              });
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Cambiar tutor'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppEspaciado.lg),
      ],
    );
  }

  /// Menor o edad desconocida: **siempre** se muestra el formulario aunque ya haya
  /// un tutor en memoria (evita que un D.N.I. residual oculte el registro).
  Widget containerTutor() {
    if (beneficiarioService.beneficiario == null) {
      return const SizedBox.shrink();
    }
    return ValueListenableBuilder<Tutor?>(
      valueListenable: tutorService.tutorEstado,
      builder: (BuildContext context, Tutor? tut, _) {
        final requiereRegistroTutor = _beneficiarioRequierePanelTutor();

        if (!requiereRegistroTutor) {
          if (tut != null && _tutorTieneDocumentoCargado(tut)) {
            return _columnaTarjetaTutor(tut);
          }
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (tut != null && _tutorTieneDocumentoCargado(tut)) ...[
              _columnaTarjetaTutor(tut),
              const SizedBox(height: AppEspaciado.md),
            ],
            if (tut == null || !_tutorTieneDocumentoCargado(tut))
              _panelRegistroTutorMenor(context),
          ],
        );
      },
    );
  }

  /// Sin perfiles: mensaje claro y reintentar.
  Widget _vacunasPaso1SinPerfiles() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final detalle = perfilesVacunacionService.mensajeListaPerfilesVacia;
    final texto =
        detalle ??
        'No hay perfiles de vacunación asignados a su usuario en este momento. '
            'Si cree que es un error, contacte a su supervisor o intente cargar de nuevo.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VacunasTituloSeccionPaso(
          etiqueta: 'PASO 1',
          titulo: 'Perfil de vacunación',
          subtitulo: 'Elija el contexto del registro (campaña o estrategia).',
        ),
        Container(
          padding: const EdgeInsets.all(AppEspaciado.lg),
          decoration: AppSuperficies.tarjeta(
            context,
            radio: AppEspaciado.radioCampo,
          ),
          child: Column(
            children: [
              Icon(Icons.assignment_late_outlined, size: 48, color: cs.primary),
              const SizedBox(height: AppEspaciado.md),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(
                  fontSize: 15,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppEspaciado.lg),
              FilledButton.icon(
                style: AppBotones.estiloFilledIconCta(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppEspaciado.xl,
                    vertical: AppEspaciado.lg,
                  ),
                ),
                onPressed: _recargandoPerfiles
                    ? null
                    : _reintentarCargaPerfiles,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar carga'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _reintentarCargaPerfiles() async {
    final id = registradorService.registrador?.id_flxcore03;
    if (id == null || id.isEmpty) return;
    setState(() => _recargandoPerfiles = true);
    try {
      await cargarPerfilesService(id);
    } finally {
      if (mounted) setState(() => _recargandoPerfiles = false);
    }
  }

  Widget containerPerfiles() {
    return ValueListenableBuilder<List<PerfilesVacunacion>>(
      valueListenable: perfilesVacunacionService.listaPerfilesVacunacionEstado,
      builder: (BuildContext context, lista, _) {
        if (_recargandoPerfiles) {
          return const LoadingEstrellas();
        }
        if (lista.isEmpty) {
          return _vacunasPaso1SinPerfiles();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VacunasTituloSeccionPaso(
              etiqueta: 'PASO 1',
              titulo: 'Perfil de vacunación',
              subtitulo:
                  'Elija el contexto del registro (campaña o estrategia).',
            ),
            Wrap(
              spacing: AppEspaciado.sm,
              runSpacing: AppEspaciado.sm,
              children: lista.map((perfil) {
                return FilterChip(
                  label: Text(perfil.sysvacu12_descripcion!),
                  selected: _selectPerfil == perfil,
                  showCheckmark: true,
                  onSelected: (_) async {
                    loadingLoginService.cargaPerfil(true);
                    listaLotes!.clear();
                    setState(() {
                      _selectVacunas = null;
                      _selectPerfil = perfil;
                    });
                    final tempLista = await vacunasxPerfiles
                        .obtenerVacunasxPerfilesProviders(
                          _selectPerfil!.id_sysvacu12,
                          beneficiarioService.beneficiario!.sysdesa10_dni,
                          beneficiarioService.beneficiario!.sysdesa10_sexo,
                        );
                    if (!mounted) return;
                    if (tempLista != null &&
                        tempLista[0].codigo_mensaje == "0") {
                      showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (dialogCtx) => DialogoAlerta(
                          envioFuncion2: false,
                          envioFuncion1: false,
                          tituloAlerta:
                              'No se pudieron cargar las vacunas del perfil',
                          descripcionAlerta: tempLista[0].mensaje,
                          textoBotonAlerta: 'Listo',
                          icon: const Icon(Icons.error_outline, size: 40),
                          color: Theme.of(dialogCtx).colorScheme.error,
                        ),
                      );
                    } else {
                      loadingLoginService.cargaPerfil(false);
                      if (tempLista == null) {
                        setState(() => pasos++);
                      }
                    }
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  /// Paso 2 — seleccionar vacuna y avanzar al paso de condición.
  Future<void> _seleccionarVacuna(VacunasxPerfil v) async {
    listaLotes!.clear();
    setState(() {
      _selectCondicion = null;
      _selectVacunas = v;
      controladorBusqueda.clear();
    });
    final ben = beneficiarioService.beneficiario!;
    final edadEscaneo = beneficiarioService.edadAniosDesdePdf417Escaneado
        ?.trim();
    final edadParam = (edadEscaneo != null && edadEscaneo.isNotEmpty)
        ? edadEscaneo
        : (ben.sysdesa10_edad?.trim().isNotEmpty == true
              ? ben.sysdesa10_edad!.trim()
              : '');
    final tempLista = await vacunasRepository.obtenerCondicionesProviders(
      _selectVacunas!.id_sysvacu04,
      edadParam.isNotEmpty ? edadParam : ben.sysdesa10_edad,
    );
    if (!mounted) return;
    if (tempLista[0].codigo_mensaje == "0") {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (dialogCtx) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'No se pudieron cargar las condiciones',
          descripcionAlerta: tempLista[0].mensaje,
          textoBotonAlerta: 'Listo',
          icon: const Icon(Icons.error_outline, size: 40),
          color: Theme.of(dialogCtx).colorScheme.error,
        ),
      );
    } else {
      if (loadingLoginService.getLoadingCondicionState!) {
        mostrarLoadingEstrellasXTiempo(context, 800);
      }
      loadingLoginService.cargarCondicion(false);
      setState(() {
        listaCondiciones = tempLista;
        vacunasCondicionService.cargarListaVacunasCondicion(tempLista);
        pasos++;
      });
    }
  }

  /// Paso 3 — seleccionar condición y avanzar al paso de esquema.
  Future<void> _seleccionarCondicion(VacunasCondicion cond) async {
    listaLotes!.clear();
    listaEsquemas!.clear();
    setState(() {
      _selectEsquema = null;
      _selectCondicion = cond;
      controladorBusquedaCondicion.clear();
    });
    final tempLista = await vacunasRepository.obtenerEsquemasProviders(
      _selectVacunas!.id_sysvacu04!,
      _selectCondicion!.id_sysvacu01,
    );
    if (!mounted) return;
    if (tempLista[0].codigo_mensaje == "0") {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (dialogCtx) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'No se pudieron cargar los esquemas',
          descripcionAlerta: tempLista[0].mensaje,
          textoBotonAlerta: 'Listo',
          icon: const Icon(Icons.error_outline, size: 40),
          color: Theme.of(dialogCtx).colorScheme.error,
        ),
      );
    } else {
      if (loadingLoginService.getLoadingEsquemaState!) {
        mostrarLoadingEstrellasXTiempo(context, 800);
      }
      loadingLoginService.cargarEsquema(false);
      setState(() {
        listaEsquemas = tempLista;
        vacunasEsquemaService.cargarListavacunasEsquema(tempLista);
        pasos++;
      });
    }
  }

  /// Paso 4 — seleccionar esquema y avanzar al paso de dosis.
  Future<void> _seleccionarEsquema(VacunasEsquema esq) async {
    listaLotes!.clear();
    setState(() {
      _selectDosis = null;
      _selectEsquema = esq;
      controladorBusquedaEsquema.clear();
    });
    final tempLista = await vacunasRepository.obtenerDosisProviders(
      _selectVacunas!.id_sysvacu04!,
      _selectCondicion!.id_sysvacu01!,
      _selectEsquema!.id_sysvacu02!,
    );
    if (!mounted) return;
    if (tempLista[0].codigo_mensaje == "0") {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (dialogCtx) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'No se pudieron cargar las dosis',
          descripcionAlerta: tempLista[0].mensaje,
          textoBotonAlerta: 'Listo',
          icon: const Icon(Icons.error_outline, size: 40),
          color: Theme.of(dialogCtx).colorScheme.error,
        ),
      );
    } else {
      if (loadingLoginService.getLoadingDosisState!) {
        mostrarLoadingEstrellasXTiempo(context, 800);
      }
      loadingLoginService.cargarDosis(false);
      setState(() {
        listaDosis = tempLista;
        vacunasDosisService.cargarListaVacunasDosis(tempLista);
        pasos++;
      });
    }
  }

  Widget containerVacunas() {
    return StreamBuilder(
      stream: loadingLoginService.cargaPerfilStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getCargaPerfilState!
            ? const SizedBox.shrink()
            : StreamBuilder(
                stream: vacunasxPerfilService.listaVacunasxPerfilesStream,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasxPerfilService.listavacunasxPerfil!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VacunasTituloSeccionPaso(
                              etiqueta: 'PASO 2',
                              titulo: 'Vacuna',
                              subtitulo:
                                  'Busque por nombre o elija una opción de la lista.',
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: AppSuperficies.campoBusqueda(
                                    context,
                                  ),
                                  child: TextField(
                                    autocorrect: false,
                                    controller: controladorBusqueda,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintText: 'Buscar vacuna…',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 15,
                                            color:
                                                AppSuperficies.textoSecundario(
                                                  context,
                                                ),
                                          ),
                                    ),
                                    focusNode: focusNode,
                                    onChanged: (value) {
                                      vacunasxPerfilService.buscarVacuna(
                                        value.toUpperCase(),
                                      );
                                      if (value.length >= 3) {
                                        focusNode.unfocus();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: AppEspaciado.md),
                                StreamBuilder(
                                  stream:
                                      vacunasxPerfilService.listaBusquedaStream,
                                  builder:
                                      (
                                        BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot,
                                      ) {
                                        return controladorBusqueda.text.isEmpty
                                            ? SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollVacunas,
                                                  child: ListView.builder(
                                                    controller: _scrollVacunas,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasxPerfilService
                                                            .listavacunasxPerfil!
                                                            .length,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                          int index,
                                                        ) {
                                                          final v =
                                                              vacunasxPerfilService
                                                                  .listavacunasxPerfil![index];
                                                          return _tarjetaOpcionFila(
                                                            seleccionado:
                                                                _selectVacunas ==
                                                                v,
                                                            titulo: v
                                                                .sysvacu04_nombre!,
                                                            onTap: () =>
                                                                _seleccionarVacuna(
                                                                  v,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollVacunas,
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: vacunasxPerfilService
                                                        .listavacunasxPerfilBusqueda!
                                                        .length,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                          int index,
                                                        ) {
                                                          final v =
                                                              vacunasxPerfilService
                                                                  .listavacunasxPerfilBusqueda![index];
                                                          return _tarjetaOpcionFila(
                                                            seleccionado:
                                                                _selectVacunas ==
                                                                v,
                                                            titulo: v
                                                                .sysvacu04_nombre!,
                                                            onTap: () =>
                                                                _seleccionarVacuna(
                                                                  v,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              );
                                      },
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              );
      },
    );
  }

  Widget containerCondiciones() {
    return StreamBuilder(
      stream: loadingLoginService.loadingCondicionStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getLoadingCondicionState!
            ? const SizedBox.shrink()
            : StreamBuilder(
                stream: vacunasCondicionService.listaVacunasCondicionesStream,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasCondicionService
                          .listaVacunasCondicion!
                          .isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VacunasTituloSeccionPaso(
                              etiqueta: 'PASO 3',
                              titulo: 'Condición',
                              subtitulo:
                                  'Indicación o situación clínica asociada a la aplicación.',
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: AppSuperficies.campoBusqueda(
                                    context,
                                  ),
                                  child: TextField(
                                    autocorrect: false,
                                    controller: controladorBusquedaCondicion,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintText: 'Buscar condición…',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 15,
                                            color:
                                                AppSuperficies.textoSecundario(
                                                  context,
                                                ),
                                          ),
                                    ),
                                    focusNode: focusNode,
                                    onChanged: (value) {
                                      vacunasCondicionService.buscarCondicion(
                                        value.toUpperCase(),
                                      );
                                      if (value.length >= 3) {
                                        focusNode.unfocus();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: AppEspaciado.md),
                                StreamBuilder(
                                  stream: vacunasCondicionService
                                      .listaBusquedaStream,
                                  builder:
                                      (
                                        BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot,
                                      ) {
                                        return controladorBusquedaCondicion
                                                .text
                                                .isEmpty
                                            ? SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller:
                                                      _scrollCondiciones,
                                                  child: ListView.builder(
                                                    controller:
                                                        _scrollCondiciones,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasCondicionService
                                                            .listaVacunasCondicion!
                                                            .length,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                          int index,
                                                        ) {
                                                          final cond =
                                                              vacunasCondicionService
                                                                  .listaVacunasCondicion![index];
                                                          return _tarjetaOpcionFila(
                                                            seleccionado:
                                                                _selectCondicion ==
                                                                cond,
                                                            titulo: cond
                                                                .sysvacu01_descripcion!,
                                                            onTap: () =>
                                                                _seleccionarCondicion(
                                                                  cond,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller:
                                                      _scrollCondiciones,
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasCondicionService
                                                            .listaVacunasCondicionBusqueda!
                                                            .length,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                          int index,
                                                        ) {
                                                          final cond =
                                                              vacunasCondicionService
                                                                  .listaVacunasCondicionBusqueda![index];
                                                          return _tarjetaOpcionFila(
                                                            seleccionado:
                                                                _selectCondicion ==
                                                                cond,
                                                            titulo: cond
                                                                .sysvacu01_descripcion!,
                                                            onTap: () =>
                                                                _seleccionarCondicion(
                                                                  cond,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              );
                                      },
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              );
      },
    );
  }

  Widget containerEsquemas() {
    return StreamBuilder(
      stream: loadingLoginService.loadingEsquemaStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getLoadingEsquemaState!
            ? const SizedBox.shrink()
            : StreamBuilder(
                stream: vacunasEsquemaService.listavacunasEsquemaesStream,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasEsquemaService.listavacunasEsquema!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VacunasTituloSeccionPaso(
                              etiqueta: 'PASO 4',
                              titulo: 'Esquema',
                              subtitulo:
                                  'Calendario o pauta de aplicación para esta vacuna.',
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: AppSuperficies.campoBusqueda(
                                    context,
                                  ),
                                  child: TextField(
                                    autocorrect: false,
                                    controller: controladorBusquedaEsquema,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintText: 'Buscar esquema…',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 15,
                                            color:
                                                AppSuperficies.textoSecundario(
                                                  context,
                                                ),
                                          ),
                                    ),
                                    focusNode: focusNode,
                                    onChanged: (value) {
                                      vacunasEsquemaService.buscaresquema(
                                        value.toUpperCase(),
                                      );
                                      if (value.length >= 3) {
                                        focusNode.unfocus();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: AppEspaciado.md),
                                StreamBuilder(
                                  stream:
                                      vacunasEsquemaService.listaBusquedaStream,
                                  builder:
                                      (
                                        BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot,
                                      ) {
                                        return controladorBusquedaEsquema
                                                .text
                                                .isEmpty
                                            ? SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollEsquemas,
                                                  child: ListView.builder(
                                                    controller: _scrollEsquemas,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasEsquemaService
                                                            .listavacunasEsquema!
                                                            .length,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                          int index,
                                                        ) {
                                                          final esq =
                                                              vacunasEsquemaService
                                                                  .listavacunasEsquema![index];
                                                          return _tarjetaOpcionFila(
                                                            seleccionado:
                                                                _selectEsquema ==
                                                                esq,
                                                            titulo: esq
                                                                .sysvacu02_descripcion!,
                                                            onTap: () =>
                                                                _seleccionarEsquema(
                                                                  esq,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollEsquemas,
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: vacunasEsquemaService
                                                        .listavacunasEsquemaBusqueda!
                                                        .length,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                          int index,
                                                        ) {
                                                          final esq =
                                                              vacunasEsquemaService
                                                                  .listavacunasEsquemaBusqueda![index];
                                                          return _tarjetaOpcionFila(
                                                            seleccionado:
                                                                _selectEsquema ==
                                                                esq,
                                                            titulo: esq
                                                                .sysvacu02_descripcion!,
                                                            onTap: () =>
                                                                _seleccionarEsquema(
                                                                  esq,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              );
                                      },
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              );
      },
    );
  }

  Widget containerDosis() {
    return StreamBuilder(
      stream: loadingLoginService.loadingDosisStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return loadingLoginService.getLoadingDosisState!
            ? const SizedBox.shrink()
            : StreamBuilder(
                stream: vacunasDosisService.listaVacunasDosisStream,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasDosisService.listaVacunasDosis!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VacunasTituloSeccionPaso(
                              etiqueta: 'PASO 5',
                              titulo: 'Dosis',
                              subtitulo:
                                  'Número o tipo de dosis según el esquema elegido.',
                            ),
                            Wrap(
                              spacing: AppEspaciado.sm,
                              runSpacing: AppEspaciado.sm,
                              children: vacunasDosisService.listaVacunasDosis!
                                  .map(
                                    (d) => FilterChip(
                                      label: Text(d.sysvacu05_nombre!),
                                      selected: _selectDosis == d,
                                      showCheckmark: true,
                                      onSelected: (_) {
                                        listaLotes!.clear();
                                        setState(() {
                                          _selectLote = null;
                                          _selectDosis = d;
                                          pasos++;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              );
      },
    );
  }

  Widget containerFecha() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;
    final fechaFmt =
        '${_selectFecha.day.toString().padLeft(2, '0')}/${_selectFecha.month.toString().padLeft(2, '0')}/${_selectFecha.year}';

    Future<void> cargarLotesYAvanzar() async {
      loadingLoginService.cargaLotes(false);
      try {
        final tempLista = await vacunasRepository.validarLotes(
          _selectVacunas!.id_sysvacu04,
        );
        if (!mounted) return;
        if (tempLista.isEmpty) {
          showDialog(
            context: _scaffoldKey.currentContext!,
            builder: (dialogCtx) => DialogoAlerta(
              envioFuncion2: true,
              envioFuncion1: true,
              tituloAlerta: 'Sin lotes disponibles',
              descripcionAlerta:
                  'No hay lotes registrados para esta vacuna. Seleccione otra dosis o cambie la vacuna.',
              textoBotonAlerta: 'Cambiar vacuna',
              textoBotonAlerta2: 'Cambiar dosis',
              funcion1: () {
                Navigator.of(dialogCtx).pop();
                setState(() {
                  pasos = 2;
                  _selectCondicion = null;
                  _selectEsquema = null;
                  _selectDosis = null;
                  _selectLote = null;
                  listaLotes!.clear();
                });
              },
              funcion2: () => Navigator.of(dialogCtx).pop(),
              icon: const Icon(Icons.inventory_2_outlined, size: 40),
              color: Theme.of(dialogCtx).colorScheme.tertiary,
            ),
          );
          return;
        }
        if (tempLista[0].codigo_mensaje == "0") {
          showDialog(
            context: _scaffoldKey.currentContext!,
            builder: (dialogCtx) => DialogoAlerta(
              envioFuncion2: true,
              envioFuncion1: true,
              tituloAlerta: 'No se pudieron cargar los lotes',
              descripcionAlerta:
                  tempLista[0].mensaje ?? 'Intente con otra dosis o cambie la vacuna.',
              textoBotonAlerta: 'Cambiar vacuna',
              textoBotonAlerta2: 'Reintentar',
              funcion1: () {
                Navigator.of(dialogCtx).pop();
                setState(() {
                  pasos = 2;
                  _selectCondicion = null;
                  _selectEsquema = null;
                  _selectDosis = null;
                  _selectLote = null;
                  listaLotes!.clear();
                });
              },
              funcion2: () => Navigator.of(dialogCtx).pop(),
              icon: const Icon(Icons.error_outline, size: 40),
              color: Theme.of(
                _scaffoldKey.currentContext!,
              ).colorScheme.error,
            ),
          );
          return;
        }
        if (loadingLoginService.getCargaLotesState!) {
          mostrarLoadingEstrellasXTiempo(context, 800);
        }
        setState(() {
          listaLotes = tempLista;
          vacunasLotesService.cargarListaVacunasLotes(tempLista);
        });
        loadingLoginService.cargaLotes(false);
        setState(() => pasos++);
      } catch (_) {
        if (!mounted) return;
        showDialog(
          context: _scaffoldKey.currentContext!,
          builder: (dialogCtx) => DialogoAlerta(
            envioFuncion2: true,
            envioFuncion1: true,
            tituloAlerta: 'Error de conexión',
            descripcionAlerta:
                'No se pudieron obtener los lotes. Revise la conexión o cambie la vacuna.',
            textoBotonAlerta: 'Cambiar vacuna',
            textoBotonAlerta2: 'Cerrar',
            funcion1: () {
              Navigator.of(dialogCtx).pop();
              setState(() {
                pasos = 2;
                _selectCondicion = null;
                _selectEsquema = null;
                _selectDosis = null;
                _selectLote = null;
                listaLotes!.clear();
              });
            },
            funcion2: () => Navigator.of(dialogCtx).pop(),
            color: Theme.of(dialogCtx).colorScheme.error,
            icon: const Icon(Icons.wifi_off_rounded, size: 40),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VacunasTituloSeccionPaso(
          etiqueta: 'PASO 6',
          titulo: 'Fecha de Aplicación',
          subtitulo: 'Seleccione la fecha en que se aplicó la vacuna.',
        ),
        const SizedBox(height: AppEspaciado.md),
        Container(
          padding: const EdgeInsets.all(AppEspaciado.lg),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppEspaciado.xl),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppEspaciado.xs),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [cs.tertiary, cs.tertiary.withValues(alpha: 0.55)],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Icon(Icons.calendar_today_outlined, color: cs.tertiary, size: AppTamanoIcono.mediano),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FECHA SELECCIONADA',
                      style: tt.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.35,
                        color: cs.tertiary,
                      ),
                    ),
                    const SizedBox(height: AppEspaciado.xs),
                    Text(
                      fechaFmt,
                      style: bar.tituloTarjeta.copyWith(
                        fontSize: 20,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                style: AppBotones.estiloTextoPequeno(cs),
                onPressed: () async {
                  final DateTime? nueva = await showDatePicker(
                    context: context,
                    initialDate: _selectFecha,
                    firstDate: DateTime(2021),
                    lastDate: DateTime.now(),
                  );
                  if (nueva != null) setState(() => _selectFecha = nueva);
                },
                icon: const Icon(Icons.edit_calendar_outlined),
                label: const Text('Cambiar'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppEspaciado.lg),
        FilledButton(
          style: AppBotones.estiloFilledPrimario(cs),
          onPressed: cargarLotesYAvanzar,
          child: const Text('Continuar'),
        ),
      ],
    );
  }

  Widget containerLotes() {
    return StreamBuilder(
      stream: vacunasLotesService.listaVacunasLotesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return vacunasLotesService.listavacunasLotes!.isEmpty
            ? _sinLotesDisponibles()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VacunasTituloSeccionPaso(
                    etiqueta: 'PASO 7',
                    titulo: 'Lote',
                    subtitulo:
                        'Seleccione el lote disponible para registrar la aplicación.',
                  ),
                  Wrap(
                    spacing: AppEspaciado.sm,
                    runSpacing: AppEspaciado.sm,
                    children: vacunasLotesService.listavacunasLotes!
                        .map(
                          (lote) => FilterChip(
                            label: Text(lote.sysdesa18_lote!),
                            selected: _selectLote == lote,
                            showCheckmark: true,
                            onSelected: (_) {
                              loadingLoginService.cargarVerificar(false);
                              setState(() {
                                _selectLote = lote;
                                pasos++;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
      },
    );
  }

  Widget _sinLotesDisponibles() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VacunasTituloSeccionPaso(
          etiqueta: 'PASO 7',
          titulo: 'Sin lotes disponibles',
          subtitulo: 'No hay lotes registrados para la vacuna seleccionada.',
        ),
        Container(
          padding: const EdgeInsets.all(AppEspaciado.xl),
          decoration: BoxDecoration(
            color: cs.errorContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
            border: Border.all(color: cs.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: cs.error),
              const SizedBox(height: AppEspaciado.md),
              Text(
                'Sin lotes registrados',
                textAlign: TextAlign.center,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: AppEspaciado.sm),
              Text(
                'No hay lotes disponibles para esta vacuna. Puede cambiar la dosis o volver a seleccionar otra vacuna.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.4,
                  color: AppSuperficies.textoSecundario(context),
                ),
              ),
              const SizedBox(height: AppEspaciado.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    style: AppBotones.estiloOutlinedSecundario(),
                    onPressed: () => setState(() => pasos = 5),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Cambiar dosis'),
                  ),
                  const SizedBox(width: AppEspaciado.md),
                  OutlinedButton.icon(
                    style: AppBotones.estiloOutlinedSecundario(),
                    onPressed: () => setState(() => pasos = 2),
                    icon: const Icon(Icons.vaccines_outlined),
                    label: const Text('Cambiar vacuna'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget containerVerificar() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    Widget filaResumen(
      String etiqueta,
      String? valor,
      int paso,
      IconData icono,
    ) {
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
            TextButton(
              style: AppBotones.estiloTextoPequeno(cs),
              onPressed: () => setState(() => pasos = paso),
              child: const Text('Cambiar'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VacunasTituloSeccionPaso(
          etiqueta: 'PASO 8',
          titulo: 'Revisar selección',
          subtitulo:
              'Confirme los datos antes de continuar. Toque "Cambiar" en cualquier fila para corregir.',
        ),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              filaResumen(
                'Perfil',
                _selectPerfil?.sysvacu12_descripcion,
                1,
                Icons.assignment_ind_outlined,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: AppEspaciado.md,
                endIndent: AppEspaciado.md,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              filaResumen(
                'Vacuna',
                _selectVacunas?.sysvacu04_nombre,
                2,
                Icons.vaccines_outlined,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: AppEspaciado.md,
                endIndent: AppEspaciado.md,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              filaResumen(
                'Condición',
                _selectCondicion?.sysvacu01_descripcion,
                3,
                Icons.health_and_safety_outlined,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: AppEspaciado.md,
                endIndent: AppEspaciado.md,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              filaResumen(
                'Esquema',
                _selectEsquema?.sysvacu02_descripcion,
                4,
                Icons.account_tree_outlined,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: AppEspaciado.md,
                endIndent: AppEspaciado.md,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              filaResumen(
                'Dosis',
                _selectDosis?.sysvacu05_nombre,
                5,
                Icons.numbers_outlined,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: AppEspaciado.md,
                endIndent: AppEspaciado.md,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              filaResumen(
                'Fecha de Aplicación',
                '${_selectFecha.day.toString().padLeft(2, '0')}/${_selectFecha.month.toString().padLeft(2, '0')}/${_selectFecha.year}',
                6,
                Icons.calendar_today_outlined,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: AppEspaciado.md,
                endIndent: AppEspaciado.md,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              filaResumen(
                'Lote',
                _selectLote?.sysdesa18_lote,
                7,
                Icons.inventory_2_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Edad numérica desde el WS (`8`, `"12"`, `"8 años"`, etc.).
  /// Valores &gt; 120 se ignoran (a veces mandan año de nacimiento en el campo edad).
  int? _edadNumericaBeneficiario(String? raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;
    int? v = int.tryParse(s);
    if (v == null) {
      final m = RegExp(r'(\d+)').firstMatch(s);
      if (m != null) v = int.tryParse(m.group(1)!);
    }
    if (v == null || v > 120) return null;
    return v;
  }

  /// Años cumplidos desde fecha de nacimiento si el campo edad no viene o no parsea.
  int? _edadAniosDesdeFechaNacimiento(String? raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;
    DateTime? dt;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(s)) {
      dt = DateTime.tryParse(s.substring(0, s.length >= 10 ? 10 : s.length));
    }
    if (dt == null) {
      final m = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(s);
      if (m != null) {
        final d = int.tryParse(m.group(1)!);
        final mo = int.tryParse(m.group(2)!);
        final y = int.tryParse(m.group(3)!);
        if (d != null && mo != null && y != null) {
          dt = DateTime(y, mo, d);
        }
      }
    }
    if (dt == null) return null;
    final ahora = DateTime.now();
    var anios = ahora.year - dt.year;
    if (ahora.month < dt.month ||
        (ahora.month == dt.month && ahora.day < dt.day)) {
      anios--;
    }
    return anios;
  }

  /// Panel tutor: primero edad del **DNI escaneado**; si no hay (búsqueda manual), datos del API.
  bool _beneficiarioRequierePanelTutor() {
    final b = beneficiarioService.beneficiario;
    if (b == null) return false;
    final eScan = beneficiarioService.edadAniosDesdePdf417Escaneado?.trim();
    if (eScan != null && eScan.isNotEmpty) {
      final n = int.tryParse(eScan);
      if (n != null) return n < 18;
    }
    final c = _edadNumericaBeneficiario(b.sysdesa10_edad);
    final f = _edadAniosDesdeFechaNacimiento(b.sysdesa10_fecha_nacimiento);
    if (c != null && c < 18) return true;
    if (f != null && f < 18) return true;
    if (c == null && f == null) return true;
    return false;
  }

  bool _beneficiarioSinDatoEdadParseable() {
    final esc = beneficiarioService.edadAniosDesdePdf417Escaneado?.trim();
    if (esc != null && esc.isNotEmpty) return false;
    final b = beneficiarioService.beneficiario;
    if (b == null) return true;
    final c = _edadNumericaBeneficiario(b.sysdesa10_edad);
    final f = _edadAniosDesdeFechaNacimiento(b.sysdesa10_fecha_nacimiento);
    return c == null && f == null;
  }

  /// Formulario escanear / D.N.I. / sexo del tutor (solo invocar si es menor o sin edad).
  Widget _panelRegistroTutorMenor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;
    final sinDatoEdad = _beneficiarioSinDatoEdadParseable();

    return FadeInUpBig(
      from: 14,
      duration: const Duration(milliseconds: 400),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: _decoracionTarjetaIdentidadVacunas(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Encabezado ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
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
                        colors: [
                          cs.tertiary,
                          cs.tertiary.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(
                    Icons.family_restroom_outlined,
                    color: cs.tertiary,
                    size: 22,
                  ),
                  const SizedBox(width: AppEspaciado.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MENOR DE EDAD',
                          style: tt.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.35,
                            height: 1.2,
                            color: cs.tertiary,
                          ),
                        ),
                        const SizedBox(height: AppEspaciado.sm),
                        Text(
                          'Tutor o responsable',
                          style: bar.tituloTarjeta.copyWith(
                            fontSize: 21,
                            height: 1.12,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppEspaciado.xs),
                        Text(
                          'Reverso del D.N.I. con la cámara o datos abajo.',
                          style: tt.titleSmall?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppEspaciado.sm),
                  IconButton(
                    tooltip: 'Ayuda: registrar tutor o responsable',
                    style: AppBotones.estiloIconoAyuda(cs),
                    onPressed: () {
                      showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (BuildContext context) => DialogoAlerta(
                          envioFuncion2: false,
                          envioFuncion1: false,
                          tituloAlerta: 'Información',
                          descripcionAlerta:
                              'Escanee el código del D.N.I. (frente o reverso según la tarjeta) o ingrese número y sexo como en el documento.',
                          textoBotonAlerta: 'Listo',
                          color: cs.primary,
                          icon: const Icon(
                            Icons.info_outline_rounded,
                            size: 40,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: cs.outlineVariant.withValues(alpha: 0.35),
            ),

            // ── Cuerpo ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppEspaciado.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner opcional: edad desconocida
                  if (sinDatoEdad) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(
                          AppEspaciado.radioBoton,
                        ),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppEspaciado.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: cs.primary,
                            ),
                            const SizedBox(width: AppEspaciado.sm),
                            Expanded(
                              child: Text(
                                'No se recibió la edad desde el servidor. '
                                'Si el beneficiario es menor, cargue al tutor o '
                                'responsable; si es mayor, puede ignorar este bloque.',
                                style: tt.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  height: 1.35,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppEspaciado.lg),
                  ],

                  // Captura del documento del tutor (escaneo + ingreso manual)
                  FormularioDocumento(
                    tipoEscaneo: 'Tutor',
                    textoBotonEscaneo: 'Escanear',
                    anchoEscaner: 52,
                    controladorDni: controladorDni,
                    focusNode: focusNode,
                    onVerificar: (dni, sexo) =>
                        obtenerDatosBeneficiario(context, dni, sexo!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Valida que todos los datos necesarios estén presentes antes de registrar.
  /// Devuelve el mensaje de error o null si todo está OK.
  String? _validarDatosRegistro() {
    if (beneficiarioService.beneficiario!.sysdesa10_dni == '') {
      return 'Hubo un error con el Beneficiario';
    }
    if (_beneficiarioRequierePanelTutor() && !tutorService.existeTutor) {
      return 'El beneficiario es menor de edad. Debe cargar los datos del Tutor';
    }
    if (_selectVacunas == null) return 'Debe seleccionar una Vacuna';
    if (_selectCondicion == null) return 'Debe seleccionar una Condición';
    if (_selectEsquema == null) return 'Debe seleccionar un Esquema';
    if (_selectDosis == null) return 'Debe seleccionar una Dosis';
    if (_selectLote == null) return 'Debe seleccionar un Lote';
    return null;
  }

  /// Construye el objeto InsertRegistros con o sin datos de tutor según edad.
  InsertRegistros _construirRegistro() {
    final conTutor =
        _beneficiarioRequierePanelTutor() && tutorService.existeTutor;
    return InsertRegistros(
      id_flxcore03: registradorService.registrador!.id_flxcore03,
      id_sysdesa12: vacunadorService.vacunador!.id_sysdesa12,
      id_sysdesa18: _selectLote!.id_sysdesa18,
      id_sysofic01: registradorService.registrador!.rela_sysofic01,
      id_sysvacu01: _selectCondicion!.id_sysvacu01!,
      id_sysvacu02: _selectEsquema!.id_sysvacu02!,
      id_sysvacu05: _selectDosis!.id_sysvacu05!,
      nombreVacuna: _selectVacunas!.sysvacu04_nombre,
      nombreCondicion: _selectCondicion!.sysvacu01_descripcion,
      nombreEsquema: _selectEsquema!.sysvacu02_descripcion,
      nombreDosis: _selectDosis!.sysvacu05_nombre,
      nombreLote: _selectLote!.sysdesa18_lote,
      id_sysvacu04: _selectVacunas!.id_sysvacu04,
      sysdesa10_apellido: beneficiarioService.beneficiario!.sysdesa10_apellido,
      sysdesa10_cadena_dni:
          beneficiarioService.beneficiario!.sysdesa10_cadena_dni,
      sysdesa10_dni: beneficiarioService.beneficiario!.sysdesa10_dni,
      sysdesa10_nombre: beneficiarioService.beneficiario!.sysdesa10_nombre,
      sysdesa10_nro_tramite:
          beneficiarioService.beneficiario!.sysdesa10_nro_tramite,
      sysdesa10_sexo: beneficiarioService.beneficiario!.sysdesa10_sexo,
      sysdesa10_edad: beneficiarioService.beneficiario!.sysdesa10_edad,
      fecha_aplicacion: _selectFecha.toString(),
      sysdesa10_fecha_nacimiento:
          beneficiarioService.beneficiario!.sysdesa10_fecha_nacimiento,
      vacunador_registrador:
          registradorService.registrador!.flxcore03_dni ==
              vacunadorService.vacunador!.id_sysdesa12
          ? '1'
          : '0',
      // Incluido en el POST; el backend debe leerlo cuando esté disponible.
      vacunacion_en_terreno: sesionEquipoVacunacionService.enTerreno
          ? '1'
          : '0',
      sysdesa10_apellido_tutor: conTutor
          ? tutorService.tutor!.sysdesa10_apellido_tutor
          : '',
      sysdesa10_dni_tutor: conTutor
          ? tutorService.tutor!.sysdesa10_dni_tutor
          : '',
      sysdesa10_nombre_tutor: conTutor
          ? tutorService.tutor!.sysdesa10_nombre_tutor
          : '',
      sysdesa10_sexo_tutor: conTutor
          ? tutorService.tutor!.sysdesa10_sexo_tutor
          : '',
    );
  }

  Widget botonRegistrarVacunacion() {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: FilledButton(
        style: AppBotones.estiloFilledPrimario(cs),
        onPressed: () {
          final error = _validarDatosRegistro();
          if (error != null) {
            showDialog(
              context: _scaffoldKey.currentContext!,
              builder: (dialogCtx) => DialogoAlerta(
                envioFuncion2: false,
                envioFuncion1: false,
                tituloAlerta: 'Faltan datos para continuar',
                descripcionAlerta: error,
                textoBotonAlerta: 'Listo',
                icon: const Icon(Icons.error_outline, size: 40),
                color: Theme.of(dialogCtx).colorScheme.error,
              ),
            );
            return;
          }
          insertRegistroService.cargarRegistro(_construirRegistro());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ConfirmarDatos()),
            (route) => false,
          );
        },
        child: const Text('Continuar a confirmación'),
      ),
    );
  }

  /// Carga tutor desde padrón (mismo servicio que beneficiario).
  Future<void> obtenerDatosBeneficiario(
    BuildContext context1,
    String dni,
    String sexoPersona,
  ) async {
    try {
      final datosBeneficiario = await beneficiarioProviders
          .obtenerDatosBeneficiario('', dni, sexoPersona);
      if (!mounted) return;
      if (datosBeneficiario[0].codigo_mensaje == '0') {
        await showDialog<void>(
          context: _scaffoldKey.currentContext!,
          builder: (BuildContext dialogCtx) => DialogoAlerta(
            envioFuncion2: false,
            envioFuncion1: false,
            tituloAlerta: 'No se pudo validar al tutor',
            descripcionAlerta: datosBeneficiario[0].mensaje,
            textoBotonAlerta: 'Listo',
            color: Theme.of(dialogCtx).colorScheme.error,
            icon: const Icon(Icons.error_outline, size: 40),
          ),
        );
        return;
      }
      confirmarTutor(datosBeneficiario[0]);
    } catch (_) {
      if (!mounted) return;
      await showDialog<void>(
        context: _scaffoldKey.currentContext!,
        builder: (BuildContext dialogCtx) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'Sin conexión',
          descripcionAlerta:
              'No se pudieron obtener los datos del tutor. Revise la red e intente de nuevo.',
          textoBotonAlerta: 'Listo',
          color: Theme.of(dialogCtx).colorScheme.error,
          icon: const Icon(Icons.wifi_off_rounded, size: 40),
        ),
      );
    }
  }

  void confirmarTutor(Beneficiario tutor) {
    setState(() {
      tutorService.cargarTutor(Tutor.desdeBeneficiario(tutor));
    });
  }

  Future<bool> onWillPop() async {
    final mensajeExit = await showDialog(
      context: _scaffoldKey.currentContext!,
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
        icon: const Icon(Icons.new_releases_outlined, size: 40.0),
      ),
    );
    return mensajeExit ?? false;
  }

  cargarPerfilesService(String id) async {
    await vacunasRepository.obtenerDatosPerfilesVacunacion(id);
  }
}
