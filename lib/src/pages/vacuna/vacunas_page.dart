import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/models/models.dart';
import 'package:sistema_vacunacion/src/pages/pages.dart';
import 'package:sistema_vacunacion/src/pages/vacuna/vacunas_ui_helpers.dart';
import 'package:sistema_vacunacion/src/providers/providers.dart';
import 'package:sistema_vacunacion/src/services/services.dart';
import 'package:sistema_vacunacion/src/utils/imagen_base64_util.dart';
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
  late bool genero;
  String? dniTutor;
  String? sexoTutor;

  Uint8List? fotoBeneficiario;
  bool _fotoDecodificando = false;
  bool _recargandoPerfiles = false;

  final ScrollController _generalScroll = ScrollController();

  // Scroll controllers de cada paso — a nivel de clase para evitar recreación
  // en cada rebuild (setState) y garantizar su dispose correcto.
  final ScrollController _scrollVacunas = ScrollController();
  final ScrollController _scrollCondiciones = ScrollController();
  final ScrollController _scrollEsquemas = ScrollController();
  final ScrollController _scrollDosis = ScrollController();
  final ScrollController _scrollLotes = ScrollController();

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
    dniTutor = '';
    sexoTutor = 'F';
    genero = false;
    focusNode = FocusNode();
    cargarPerfilesService(registradorService.registrador!.id_flxcore03!);
    _iniciarDecodificacionFotoBeneficiario();
  }

  Future<void> _iniciarDecodificacionFotoBeneficiario() async {
    final raw = beneficiarioService.beneficiario?.foto_beneficiario;
    if (raw == null || raw.trim().isEmpty) return;
    setState(() => _fotoDecodificando = true);
    final bytes = await decodificarImagenBase64Async(raw);
    if (!mounted) return;
    setState(() {
      _fotoDecodificando = false;
      fotoBeneficiario = bytes;
    });
  }

  @override
  void dispose() {
    _generalScroll.dispose();
    _scrollVacunas.dispose();
    _scrollCondiciones.dispose();
    _scrollEsquemas.dispose();
    _scrollDosis.dispose();
    _scrollLotes.dispose();
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
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
              ),
              tooltip: 'Historial de dosis aplicadas',
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.52,
                        minChildSize: 0.32,
                        maxChildSize: 0.95,
                        expand: false,
                        builder: (context, scrollController) {
                          return vacunasAplicadas(
                              scrollController: scrollController);
                        },
                      );
                    });
              },
              icon: FaIcon(
                FontAwesomeIcons.hospitalUser,
                size: getValueForScreenType(context: context, mobile: 20),
              ),
            ),
          ),
        ),
        body: RawScrollbar(
          thumbColor: cs.primary.withValues(alpha: 0.42),
          thumbVisibility: true,
          radius: const Radius.circular(12),
          thickness: 6,
          controller: _generalScroll,
          child: SingleChildScrollView(
            controller: _generalScroll,
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
                const VacunasEncabezadoPagina(),
                const SizedBox(height: AppEspaciado.xl),
                containerBeneficiario(),
                const SizedBox(height: AppEspaciado.md),
                containerTutor(),
                const SizedBox(height: AppEspaciado.xl),
                VacunasPanelFlujo(
                  pasoActual: pasos,
                  onIrAPaso: (p) => setState(() => pasos = p),
                  child: containerPasos(),
                ),
                const SizedBox(height: AppEspaciado.xl),
                if (pasos == 7) botonRegistrarVacunacion(),
                Padding(
                  padding: const EdgeInsets.only(top: AppEspaciado.md),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                      side: BorderSide(
                        color: cs.error.withValues(alpha: 0.72),
                        width: 1.5,
                      ),
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.cancel_outlined, size: 22, color: cs.error),
                    label: Text(
                      'Cancelar registro',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (BuildContext context) => DialogoAlerta(
                          tituloAlerta: 'Atenci\u00F3n',
                          descripcionAlerta:
                              '\u00BFConfirma cancelar el registro? Se perder\u00E1n los datos no guardados.',
                          textoBotonAlerta: 'S\u00ED, cancelar',
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
                            perfilesVacunacionService.eliminarListaPerfiles();
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
                  height: MediaQuery.of(context).padding.bottom +
                      AppEspaciado.xl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget containerPasos() {
    // 1 -> Perfiles // 2 -> Vacuna // 3 -> Condicion // 4 -> Esquema // 5 -> Dosis // 6 -> Lote
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
        child = containerLotes();
        break;
      case 7:
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
      child: KeyedSubtree(
        key: ValueKey<int>(pasos),
        child: child,
      ),
    );
  }

  Widget vacunasAplicadas({ScrollController? scrollController}) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Historial de dosis',
            style: GoogleFonts.barlow(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Beneficiario en pantalla · solo lectura',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppSuperficies.textoSecundario(context),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: notificacionesDosisService.listaDosisAplicadasStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return notificacionesDosisService.listaDosisAplicadas.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: AppEspaciado.xl),
                        itemCount: notificacionesDosisService
                            .listaDosisAplicadas.length,
                        itemBuilder: (BuildContext context, int index) {
                          final d = notificacionesDosisService
                              .listaDosisAplicadas[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppEspaciado.sm),
                            child: Material(
                              color: cs.surfaceContainerHighest
                                  .withValues(alpha: 0.55),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(
                                  color: cs.outlineVariant
                                      .withValues(alpha: 0.38),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppEspaciado.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${d.sysvacu05_nombre!} · ${d.sysvacu04_nombre!}',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        height: 1.25,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Lote ${d.sysdesa18_lote!}',
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        color: AppSuperficies.textoSecundario(
                                            context),
                                      ),
                                    ),
                                    Text(
                                      'Aplicación ${d.sysdesa10_fecha_aplicacion!}',
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        color: AppSuperficies.textoSecundario(
                                            context),
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
                                color: cs.onSurfaceVariant
                                    .withValues(alpha: 0.65),
                              ),
                              const SizedBox(height: AppEspaciado.md),
                              Text(
                                'Sin dosis registradas',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.barlow(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Cuando existan aplicaciones previas, aparecerán aquí.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  height: 1.35,
                                  color: AppSuperficies.textoSecundario(
                                      context),
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

  Widget _encabezadoTarjetaColapsable({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required bool expandido,
    required VoidCallback onAlternar,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onAlternar,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icono, color: cs.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: GoogleFonts.barlow(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                expandido
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarFotoBeneficiario(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const double radio = 44;
    if (_fotoDecodificando) {
      return SizedBox(
        width: radio * 2,
        height: radio * 2,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: cs.primary,
            ),
          ),
        ),
      );
    }
    if (fotoBeneficiario != null && fotoBeneficiario!.isNotEmpty) {
      final dpr = MediaQuery.of(context).devicePixelRatio;
      final cacheW = (radio * 2 * dpr).round().clamp(96, 320);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radio),
        child: Image.memory(
          fotoBeneficiario!,
          width: radio * 2,
          height: radio * 2,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          cacheWidth: cacheW,
          errorBuilder: (_, __, ___) => CircleAvatar(
            radius: radio,
            backgroundColor: cs.surfaceContainerHighest,
            child: Icon(Icons.broken_image_outlined,
                color: cs.onSurfaceVariant, size: 32),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radio,
      backgroundColor: cs.surfaceContainerHighest,
      child: Icon(Icons.person_outline,
          size: 36, color: cs.onSurfaceVariant),
    );
  }

  /// Foto del tutor/responsable (mismo tamaño y estilo que el beneficiario).
  Widget _avatarFotoTutor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const double radio = 44;
    final bytes = tutorService.tutor?.fotoTutor;
    if (bytes != null && bytes.isNotEmpty) {
      final dpr = MediaQuery.of(context).devicePixelRatio;
      final cacheW = (radio * 2 * dpr).round().clamp(96, 320);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radio),
        child: Image.memory(
          bytes,
          width: radio * 2,
          height: radio * 2,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          cacheWidth: cacheW,
          errorBuilder: (_, __, ___) => CircleAvatar(
            radius: radio,
            backgroundColor: cs.surfaceContainerHighest,
            child: Icon(Icons.broken_image_outlined,
                color: cs.onSurfaceVariant, size: 32),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radio,
      backgroundColor: cs.surfaceContainerHighest,
      child: Icon(Icons.family_restroom_outlined,
          size: 36, color: cs.onSurfaceVariant),
    );
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
    return Container(
      padding: const EdgeInsets.all(AppEspaciado.lg),
      decoration: AppSuperficies.tarjeta(context, radio: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInUpBig(
            from: 16,
            duration: const Duration(milliseconds: 420),
            child: _encabezadoTarjetaColapsable(
              icono: Icons.badge_outlined,
              titulo: 'Beneficiario',
              subtitulo: 'Persona que recibirá la dosis',
              expandido: mostrarBeneficiario!,
              onAlternar: () {
                setState(() {
                  mostrarBeneficiario = !mostrarBeneficiario!;
                });
              },
            ),
          ),
          if (mostrarBeneficiario!)
            Padding(
              padding: const EdgeInsets.only(top: AppEspaciado.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _avatarFotoBeneficiario(context),
                  const SizedBox(width: AppEspaciado.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _filaDatoBeneficiario(
                          'Nombre',
                          beneficiarioService.beneficiario!.sysdesa10_nombre!,
                        ),
                        const SizedBox(height: AppEspaciado.sm),
                        _filaDatoBeneficiario(
                          'Apellido',
                          beneficiarioService.beneficiario!.sysdesa10_apellido!,
                        ),
                        const SizedBox(height: AppEspaciado.sm),
                        _filaDatoBeneficiario(
                          'D.N.I.',
                          beneficiarioService.beneficiario!.sysdesa10_dni!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _filaDatoBeneficiario(String etiqueta, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppSuperficies.textoSecundario(context),
            ),
          ),
        ),
        Text(
          valor,
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
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
      radius: const Radius.circular(12),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: Material(
        color: seleccionado
            ? cs.primaryContainer.withValues(alpha: 0.5)
            : cs.surfaceContainerHighest.withValues(alpha: 0.42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: seleccionado
                ? cs.primary
                : cs.outlineVariant.withValues(alpha: 0.4),
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
                        style: GoogleFonts.nunito(
                          fontWeight: seleccionado
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 15,
                          height: 1.25,
                          color: cs.onSurface,
                        ),
                      ),
                      if (subtitulo != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitulo,
                          style: GoogleFonts.nunito(
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

  Widget _capsulaHorizontal({
    required String texto,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: AppEspaciado.sm),
      child: Material(
        color: seleccionado
            ? cs.primaryContainer.withValues(alpha: 0.65)
            : cs.surfaceContainerHigh.withValues(alpha: 0.5),
        shape: StadiumBorder(
          side: BorderSide(
            color: seleccionado
                ? cs.primary
                : cs.outlineVariant.withValues(alpha: 0.45),
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontWeight: seleccionado ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
                color: seleccionado ? cs.onPrimaryContainer : cs.onSurface,
              ),
            ),
          ),
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
                  Container(
                    padding: const EdgeInsets.all(AppEspaciado.lg),
                    decoration: AppSuperficies.tarjeta(context, radio: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FadeInUpBig(
                          from: 16,
                          duration: const Duration(milliseconds: 420),
                          child: _encabezadoTarjetaColapsable(
                            icono: Icons.family_restroom_outlined,
                            titulo: 'Tutor o responsable',
                            subtitulo: 'Requerido si el beneficiario es menor',
                            expandido: mostrarTutor!,
                            onAlternar: () {
                              setState(() {
                                mostrarTutor = !mostrarTutor!;
                              });
                            },
                          ),
                        ),
                        if (mostrarTutor!)
                          Padding(
                            padding: const EdgeInsets.only(top: AppEspaciado.md),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _avatarFotoTutor(context),
                                const SizedBox(width: AppEspaciado.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _filaDatoBeneficiario(
                                        'Nombre',
                                        tutorService.tutor!
                                                .sysdesa10_nombre_tutor ??
                                            '—',
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      _filaDatoBeneficiario(
                                        'Apellido',
                                        tutorService.tutor!
                                                .sysdesa10_apellido_tutor ??
                                            '—',
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      _filaDatoBeneficiario(
                                        'D.N.I.',
                                        tutorService
                                                .tutor!.sysdesa10_dni_tutor ??
                                            '—',
                                      ),
                                      const SizedBox(height: AppEspaciado.sm),
                                      _filaDatoBeneficiario(
                                        'Sexo registrado',
                                        _sexoRegistradoLegible(
                                          tutorService
                                              .tutor!.sysdesa10_sexo_tutor,
                                        ),
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
                  const SizedBox(height: AppEspaciado.lg),
                ],
              )
            : verificarEdad(context);
      },
    );
  }

  /// Sin perfiles: mensaje claro y reintentar.
  Widget _vacunasPaso1SinPerfiles() {
    final cs = Theme.of(context).colorScheme;
    final detalle = perfilesVacunacionService.mensajeListaPerfilesVacia;
    final texto = detalle ??
        'No hay perfiles de vacunaci\u00F3n asignados a su usuario en este momento. '
            'Si cree que es un error, contacte a su supervisor o intente cargar de nuevo.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VacunasTituloSeccionPaso(
          etiqueta: 'PASO 1',
          titulo: 'Perfil de vacunaci\u00F3n',
          subtitulo:
              'Elija el contexto del registro (campa\u00F1a o estrategia).',
        ),
        Container(
          padding: const EdgeInsets.all(AppEspaciado.lg),
          decoration: AppSuperficies.tarjeta(context, radio: 22),
          child: Column(
            children: [
              Icon(
                Icons.assignment_late_outlined,
                size: 48,
                color: cs.primary,
              ),
              const SizedBox(height: AppEspaciado.md),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppEspaciado.lg),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _recargandoPerfiles ? null : _reintentarCargaPerfiles,
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: Text(
                  'Reintentar carga',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                ),
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
    return StreamBuilder(
      stream: perfilesVacunacionService.listaPerfilesVacunacionStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (_recargandoPerfiles) {
          return const LoadingEstrellas();
        }
        final lista = perfilesVacunacionService.listaPerfilesVacunacion;
        if (lista == null) {
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
              titulo: 'Perfil de vacunaci\u00F3n',
              subtitulo:
                  'Elija el contexto del registro (campa\u00F1a o estrategia).',
            ),
            SizedBox(
              height: 124,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: lista.length,
                  itemBuilder: (BuildContext context, int index) {
                    final perfil = lista[index];
                    final sel = _selectPerfil == perfil;
                    return _capsulaHorizontal(
                      texto: perfil.sysvacu12_descripcion!,
                      seleccionado: sel,
                      onTap: () async {
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
                        tempLista != null
                            ? tempLista[0].codigo_mensaje == "0"
                                ? showDialog(
                                    context: _scaffoldKey.currentContext!,
                                    builder: (BuildContext context) {
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
                                    loadingLoginService.getCargaPerfilState!
                                        ? mostrarLoadingEstrellasXTiempo(
                                            context, 850)
                                        : () {},
                                    loadingLoginService.cargaPerfil(false)
                                  }
                            : {
                                loadingLoginService.getCargaPerfilState!
                                    ? {
                                        mostrarLoadingEstrellasXTiempo(
                                            context, 850),
                                      }
                                    : () {},
                                loadingLoginService.cargaPerfil(false),
                                setState(() {
                                  pasos++;
                                })
                              };
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Lógica de selección por paso ─────────────────────────────────────────
  // Extraída para eliminar duplicación: cada paso tenía el mismo callback
  // tanto en la lista completa como en la lista filtrada por búsqueda.

  /// Paso 2 — seleccionar vacuna y avanzar al paso de condición.
  Future<void> _seleccionarVacuna(VacunasxPerfil v) async {
    listaLotes!.clear();
    setState(() {
      _selectCondicion = null;
      _selectVacunas = v;
      controladorBusqueda.clear();
    });
    final tempLista = await vacunasCondicion.obtenerCondicionesProviders(
      _selectVacunas!.id_sysvacu04,
      beneficiarioService.beneficiario!.sysdesa10_edad!,
    );
    if (!mounted) return;
    if (tempLista[0].codigo_mensaje == "0") {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (_) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'ATENCIÓN!',
          descripcionAlerta: tempLista[0].mensaje,
          textoBotonAlerta: 'Listo',
          icon: const Icon(Icons.error_outline, size: 40),
          color: Colors.red,
        ),
      );
    } else {
      if (loadingLoginService.getLoadingCondicionState!) {
        mostrarLoadingEstrellasXTiempo(context, 800);
      }
      setState(() {
        listaCondiciones = tempLista;
        vacunasCondicionService.cargarListaVacunasCondicion(tempLista);
      });
      loadingLoginService.cargarCondicion(false);
      setState(() => pasos++);
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
    final tempLista = await vacunasEsquemaProvider.obtenerEsquemasProviders(
      _selectVacunas!.id_sysvacu04!,
      _selectCondicion!.id_sysvacu01,
    );
    if (!mounted) return;
    if (tempLista[0].codigo_mensaje == "0") {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (_) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'ATENCIÓN!',
          descripcionAlerta: tempLista[0].mensaje,
          textoBotonAlerta: 'Listo',
          icon: const Icon(Icons.error_outline, size: 40),
          color: Colors.red,
        ),
      );
    } else {
      if (loadingLoginService.getLoadingEsquemaState!) {
        mostrarLoadingEstrellasXTiempo(context, 800);
      }
      setState(() {
        listaEsquemas = tempLista;
        vacunasEsquemaService.cargarListavacunasEsquema(tempLista);
      });
      loadingLoginService.cargarEsquema(false);
      setState(() => pasos++);
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
    final tempLista = await vacunasDosisProvider.obtenerDosisProviders(
      _selectVacunas!.id_sysvacu04!,
      _selectCondicion!.id_sysvacu01!,
      _selectEsquema!.id_sysvacu02!,
    );
    if (!mounted) return;
    if (tempLista[0].codigo_mensaje == "0") {
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (_) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'ATENCIÓN!',
          descripcionAlerta: tempLista[0].mensaje,
          textoBotonAlerta: 'Listo',
          icon: const Icon(Icons.error_outline, size: 40),
          color: Colors.red,
        ),
      );
    } else {
      if (loadingLoginService.getLoadingDosisState!) {
        mostrarLoadingEstrellasXTiempo(context, 800);
      }
      setState(() {
        listaDosis = tempLista;
        vacunasDosisService.cargarListaVacunasDosis(tempLista);
      });
      loadingLoginService.cargarDosis(false);
      setState(() => pasos++);
    }
  }

  Widget containerVacunas() {
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
                                      decoration:
                                          AppSuperficies.campoBusqueda(context),
                                      child: TextField(
                                        autocorrect: false,
                                        controller: controladorBusqueda,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: 'Buscar vacuna…',
                                          hintStyle: GoogleFonts.nunito(
                                            fontSize: 15,
                                            color: AppSuperficies.textoSecundario(
                                                context),
                                          ),
                                        ),
                                        focusNode: focusNode,
                                        onChanged: (value) {
                                          vacunasxPerfilService.buscarVacuna(
                                              value.toUpperCase());
                                          if (value.length >= 3) {
                                            focusNode.unfocus();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: AppEspaciado.md),
                                    StreamBuilder(
                                      stream: vacunasxPerfilService
                                          .listaBusquedaStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return controladorBusqueda.text.isEmpty
                                            ? SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollVacunas,
                                                  child: ListView.builder(
                                                          controller:
                                                              _scrollVacunas,
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
                                                            final v = vacunasxPerfilService
                                                                .listavacunasxPerfil![
                                                                    index];
                                                            return _tarjetaOpcionFila(
                                                              seleccionado:
                                                                  _selectVacunas ==
                                                                      v,
                                                              titulo: v
                                                                  .sysvacu04_nombre!,
                                                              onTap: () => _seleccionarVacuna(v),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                  )
                                                  : SizedBox(
                                                      height: _alturaListaPaso,
                                                      child: _scrollbarConTema(
                                                        controller:
                                                            _scrollVacunas,
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
                                                            final v = vacunasxPerfilService
                                                                .listavacunasxPerfilBusqueda![
                                                                    index];
                                                            return _tarjetaOpcionFila(
                                                              seleccionado:
                                                                  _selectVacunas ==
                                                                      v,
                                                              titulo: v
                                                                  .sysvacu04_nombre!,
                                                              onTap: () => _seleccionarVacuna(v),
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
                      : Container();
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
            ? Container()
            : StreamBuilder(
                stream: vacunasCondicionService.listaVacunasCondicionesStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return vacunasCondicionService
                          .listaVacunasCondicion!.isNotEmpty
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
                                      decoration:
                                          AppSuperficies.campoBusqueda(context),
                                      child: TextField(
                                        autocorrect: false,
                                        controller:
                                            controladorBusquedaCondicion,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: 'Buscar condición…',
                                          hintStyle: GoogleFonts.nunito(
                                            fontSize: 15,
                                            color: AppSuperficies.textoSecundario(
                                                context),
                                          ),
                                        ),
                                        focusNode: focusNode,
                                        onChanged: (value) {
                                          vacunasCondicionService.buscarCondicion(
                                              value.toUpperCase());
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
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return controladorBusquedaCondicion
                                                .text.isEmpty
                                            ? SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollCondiciones,
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
                                                        (BuildContext context,
                                                            int index) {
                                                      final cond = vacunasCondicionService
                                                          .listaVacunasCondicion![
                                                              index];
                                                      return _tarjetaOpcionFila(
                                                        seleccionado:
                                                            _selectCondicion ==
                                                                cond,
                                                        titulo: cond
                                                            .sysvacu01_descripcion!,
                                                        onTap: () => _seleccionarCondicion(cond),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller: _scrollCondiciones,
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasCondicionService
                                                            .listaVacunasCondicionBusqueda!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final cond = vacunasCondicionService
                                                          .listaVacunasCondicionBusqueda![
                                                              index];
                                                      return _tarjetaOpcionFila(
                                                        seleccionado:
                                                            _selectCondicion ==
                                                                cond,
                                                        titulo: cond
                                                            .sysvacu01_descripcion!,
                                                        onTap: () => _seleccionarCondicion(cond),
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
                      : Container();
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
            ? Container()
            : StreamBuilder(
                stream: vacunasEsquemaService.listavacunasEsquemaesStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                      decoration:
                                          AppSuperficies.campoBusqueda(context),
                                      child: TextField(
                                        autocorrect: false,
                                        controller: controladorBusquedaEsquema,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: 'Buscar esquema…',
                                          hintStyle: GoogleFonts.nunito(
                                            fontSize: 15,
                                            color: AppSuperficies.textoSecundario(
                                                context),
                                          ),
                                        ),
                                        focusNode: focusNode,
                                        onChanged: (value) {
                                          vacunasEsquemaService.buscaresquema(
                                              value.toUpperCase());
                                          if (value.length >= 3) {
                                            focusNode.unfocus();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: AppEspaciado.md),
                                    StreamBuilder(
                                      stream: vacunasEsquemaService
                                          .listaBusquedaStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return controladorBusquedaEsquema
                                                .text.isEmpty
                                            ? SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller:
                                                      _scrollEsquemas,
                                                  child: ListView.builder(
                                                    controller:
                                                        _scrollEsquemas,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasEsquemaService
                                                            .listavacunasEsquema!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final esq = vacunasEsquemaService
                                                          .listavacunasEsquema![
                                                              index];
                                                      return _tarjetaOpcionFila(
                                                        seleccionado:
                                                            _selectEsquema ==
                                                                esq,
                                                        titulo: esq
                                                            .sysvacu02_descripcion!,
                                                        onTap: () => _seleccionarEsquema(esq),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: _alturaListaPaso,
                                                child: _scrollbarConTema(
                                                  controller:
                                                      _scrollEsquemas,
                                                  child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vacunasEsquemaService
                                                            .listavacunasEsquemaBusqueda!
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final esq = vacunasEsquemaService
                                                          .listavacunasEsquemaBusqueda![
                                                              index];
                                                      return _tarjetaOpcionFila(
                                                        seleccionado:
                                                            _selectEsquema ==
                                                                esq,
                                                        titulo: esq
                                                            .sysvacu02_descripcion!,
                                                        onTap: () => _seleccionarEsquema(esq),
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
                      : Container();
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
            ? Container()
            : StreamBuilder(
                stream: vacunasDosisService.listaVacunasDosisStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                            SizedBox(
                              height: 120,
                              child: _scrollbarConTema(
                                controller: _scrollDosis,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollDosis,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: AppEspaciado.sm),
                                  itemCount: vacunasDosisService
                                      .listaVacunasDosis!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final d = vacunasDosisService
                                        .listaVacunasDosis![index];
                                    return _capsulaHorizontal(
                                      texto: d.sysvacu05_nombre!,
                                      seleccionado: _selectDosis == d,
                                      onTap: () async {
                                        loadingLoginService.getLoadingDosisState!
                                            ? mostrarLoadingEstrellasXTiempo(
                                                context, 800)
                                            : () {};
                                        loadingLoginService.cargaLotes(false);
                                        listaLotes!.clear();
                                        setState(() {
                                          _selectLote = null;
                                          _selectDosis = d;
                                        });
                                        final tempLista =
                                            await lotesVacunaProvider.validarLotes(
                                                _selectVacunas!.id_sysvacu04);
                                        tempLista[0].codigo_mensaje == "0"
                                            ? showDialog(
                                                context: _scaffoldKey
                                                    .currentContext!,
                                                builder: (BuildContext context) {
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
                                                        .getCargaLotesState!
                                                    ? mostrarLoadingEstrellasXTiempo(
                                                        context, 800)
                                                    : () {},
                                                setState(() {
                                                  listaLotes = tempLista;
                                                  vacunasLotesService
                                                      .cargarListaVacunasLotes(
                                                          tempLista);
                                                }),
                                                loadingLoginService
                                                    .cargaLotes(false),
                                                setState(() {
                                                  pasos++;
                                                })
                                              };
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container();
                },
              );
      },
    );
  }

  Widget containerLotes() {
    return StreamBuilder(
      stream: vacunasLotesService.listaVacunasLotesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return vacunasLotesService.listavacunasLotes!.isEmpty
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VacunasTituloSeccionPaso(
                    etiqueta: 'PASO 6',
                    titulo: 'Lote',
                    subtitulo:
                        'Seleccione el lote disponible para registrar la aplicación.',
                  ),
                  SizedBox(
                    height: 120,
                    child: _scrollbarConTema(
                      controller: _scrollLotes,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollLotes,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppEspaciado.sm),
                        itemCount:
                            vacunasLotesService.listavacunasLotes!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final lote =
                              vacunasLotesService.listavacunasLotes![index];
                          return _capsulaHorizontal(
                            texto: lote.sysdesa18_lote!,
                            seleccionado: _selectLote == lote,
                            onTap: () async {
                              loadingLoginService.getLoadingVerificarState!
                                  ? mostrarLoadingEstrellasXTiempo(
                                      context, 800)
                                  : () {};
                              loadingLoginService.cargarVerificar(false);
                              setState(() {
                                _selectLote = lote;
                                pasos++;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget containerVerificar() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VacunasTituloSeccionPaso(
          etiqueta: 'PASO 7',
          titulo: 'Listo para revisar',
          subtitulo:
              'Los datos están completos. Use el botón inferior para pasar a la pantalla de confirmación.',
        ),
        Container(
          padding: const EdgeInsets.all(AppEspaciado.xl),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.28),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 56,
                color: cs.primary,
              ),
              const SizedBox(height: AppEspaciado.md),
              Text(
                'Esquema completo',
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: AppEspaciado.sm),
              Text(
                'Revise bien la selección antes de confirmar. Desde el paso anterior puede corregir cualquier dato.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: AppSuperficies.textoSecundario(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _campoDniTutorRegistro() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: AppSuperficies.campoBusqueda(context),
      child: TextField(
        autocorrect: false,
        controller: controladorDni,
        keyboardType: TextInputType.number,
        maxLength: 8,
        focusNode: focusNode,
        onEditingComplete: () => focusNode.unfocus(),
        style: GoogleFonts.nunito(fontSize: 16, color: cs.onSurface),
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: Icon(
            Icons.perm_identity_rounded,
            color: cs.onSurfaceVariant,
          ),
          hintText: 'D.N.I.',
          hintStyle: GoogleFonts.nunito(
            fontSize: 15,
            color: AppSuperficies.textoSecundario(context),
          ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _switchSexoTutorRegistro() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sexo',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppSuperficies.textoSecundario(context),
          ),
        ),
        const SizedBox(height: AppEspaciado.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Femenino',
              style: GoogleFonts.nunito(
                color: !genero
                    ? cs.onSurface
                    : cs.onSurface.withValues(alpha: 0.38),
                fontWeight: !genero ? FontWeight.w700 : FontWeight.w100,
              ),
            ),
            Switch(
              value: genero,
              onChanged: (value) {
                setState(() {
                  genero = value;
                  sexoTutor = value ? 'M' : 'F';
                });
              },
            ),
            Text(
              'Masculino',
              style: GoogleFonts.nunito(
                color: genero
                    ? cs.onSurface
                    : cs.onSurface.withValues(alpha: 0.38),
                fontWeight: genero ? FontWeight.w700 : FontWeight.w100,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget verificarEdad(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final edadStr = beneficiarioService.beneficiario!.sysdesa10_edad;
    if (edadStr == null || edadStr.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final edad = int.tryParse(edadStr.trim());
    if (edad == null) {
      return const SizedBox.shrink();
    }
    return edad < 18
        ? FadeInUpBig(
            from: 14,
            duration: const Duration(milliseconds: 400),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppEspaciado.lg),
              decoration: AppSuperficies.tarjeta(context, radio: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: VacunasTituloSeccionPaso(
                          etiqueta: 'MENOR DE EDAD',
                          titulo: 'Registrar tutor o responsable',
                          subtitulo:
                              'Reverso del D.N.I. con la c\u00E1mara o datos abajo.',
                        ),
                      ),
                      IconButton(
                        tooltip: 'Informaci\u00F3n',
                        onPressed: () {
                          showDialog(
                            context: _scaffoldKey.currentContext!,
                            builder: (BuildContext context) => DialogoAlerta(
                              envioFuncion2: false,
                              envioFuncion1: false,
                              tituloAlerta: 'Informaci\u00F3n',
                              descripcionAlerta:
                                  'Escanee el reverso del D.N.I. o ingrese n\u00FAmero y sexo como en el documento.',
                              textoBotonAlerta: 'Listo',
                              color: cs.primary,
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.info_outline_rounded,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppEspaciado.md),
                  SizedBox(
                    width: double.infinity,
                    child: EscanerDni(
                      'Tutor',
                      'Escanear',
                      'Escanee el D.N.I. del Tutor',
                      anchoValor: 52,
                    ),
                  ),
                  const SizedBox(height: AppEspaciado.lg),
                  _campoDniTutorRegistro(),
                  const SizedBox(height: AppEspaciado.lg),
                  _switchSexoTutorRegistro(),
                  const SizedBox(height: AppEspaciado.lg),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
                      if (controladorDni.text.length >= 7) {
                        obtenerDatosBeneficiario(
                          context,
                          controladorDni.text,
                          sexoTutor!,
                        );
                      } else {
                        showDialog(
                          context: _scaffoldKey.currentContext!,
                          builder: (BuildContext context) => DialogoAlerta(
                            envioFuncion2: false,
                            envioFuncion1: false,
                            tituloAlerta: 'Datos incompletos',
                            descripcionAlerta:
                                'D.N.I. de al menos 7 d\u00EDgitos y sexo indicados.',
                            textoBotonAlerta: 'Listo',
                            color: Colors.red,
                            icon: const Icon(
                              Icons.error_outline_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.verified_user_outlined, size: 22),
                    label: Text(
                      'Verificar',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  /// Valida que todos los datos necesarios estén presentes antes de registrar.
  /// Devuelve el mensaje de error o null si todo está OK.
  String? _validarDatosRegistro() {
    if (beneficiarioService.beneficiario!.sysdesa10_dni == '') {
      return 'Hubo un error con el Beneficiario';
    }
    final esMenor =
        int.parse(beneficiarioService.beneficiario!.sysdesa10_edad!) < 18;
    if (esMenor &&
        (!tutorService.existeTutor ||
            tutorService.tutor!.sysdesa10_dni_tutor == '')) {
      return 'El beneficiario es menor de edad. Debe cargar los datos del Tutor';
    }
    if (_selectVacunas == null) return 'Debe Seleccionar una Vacuna';
    if (_selectCondicion == null) return 'Debe Seleccionar una Configuración';
    if (_selectLote == null) return 'Debe Seleccionar un Lote';
    return null;
  }

  /// Construye el objeto InsertRegistros con o sin datos de tutor según edad.
  InsertRegistros _construirRegistro() {
    final esMenor =
        int.parse(beneficiarioService.beneficiario!.sysdesa10_edad!) < 18;
    final conTutor = esMenor && tutorService.existeTutor;
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
      fecha_aplicacion: DateTime.now().toString(),
      sysdesa10_fecha_nacimiento:
          beneficiarioService.beneficiario!.sysdesa10_fecha_nacimiento,
      vacunador_registrador:
          registradorService.registrador!.flxcore03_dni ==
                  vacunadorService.vacunador!.id_sysdesa12
              ? '1'
              : '0',
      sysdesa10_apellido_tutor:
          conTutor ? tutorService.tutor!.sysdesa10_apellido_tutor : '',
      sysdesa10_dni_tutor:
          conTutor ? tutorService.tutor!.sysdesa10_dni_tutor : '',
      sysdesa10_nombre_tutor:
          conTutor ? tutorService.tutor!.sysdesa10_nombre_tutor : '',
      sysdesa10_sexo_tutor:
          conTutor ? tutorService.tutor!.sysdesa10_sexo_tutor : '',
    );
  }

  Widget botonRegistrarVacunacion() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        onPressed: () {
          final error = _validarDatosRegistro();
          if (error != null) {
            showDialog(
              context: _scaffoldKey.currentContext!,
              builder: (_) => DialogoAlerta(
                envioFuncion2: false,
                envioFuncion1: false,
                tituloAlerta: 'ATENCIÓN!',
                descripcionAlerta: error,
                textoBotonAlerta: 'Listo',
                icon: const Icon(Icons.error_outline, size: 40),
                color: Colors.red,
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
        child: Text(
          'Continuar a confirmación',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
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
                  icon: const Icon(
                    Icons.error,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ))
        : confirmarTutor(datosBeneficiario[0]);
  }

  Future<void> confirmarTutor(Beneficiario tutor) async {
    final bytes = await decodificarImagenBase64Async(tutor.foto_beneficiario);
    final Tutor tutorS = Tutor(
        sysdesa10_apellido_tutor: tutor.sysdesa10_apellido,
        sysdesa10_nombre_tutor: tutor.sysdesa10_nombre,
        sysdesa10_dni_tutor: tutor.sysdesa10_dni,
        sysdesa10_sexo_tutor: tutor.sysdesa10_sexo,
        fotoTutor: bytes);
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
              icon: const Icon(
                Icons.new_releases_outlined,
                size: 40.0,
                color: Colors.white,
              ),
            ));
    return mensajeExit ?? false;
  }

  cargarPerfilesService(String id) async {
    await perfilesProviders.obtenerDatosPerfilesVacunacion(id);
  }
}
