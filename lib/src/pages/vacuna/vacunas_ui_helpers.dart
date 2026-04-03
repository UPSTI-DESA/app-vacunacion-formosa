import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

/// Cabecera contextual: jerarquía clara, copy orientado a tarea (patrón 2024–2026).
class VacunasEncabezadoPagina extends StatelessWidget {
  const VacunasEncabezadoPagina({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REGISTRO ACTIVO',
          style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Vacunación en campo',
          style: GoogleFonts.barlow(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.05,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Avance paso a paso. Puede volver atrás tocando cualquier paso completado en el indicador.',
          style: GoogleFonts.nunito(
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w500,
            color: AppSuperficies.textoSecundario(context),
          ),
        ),
      ],
    );
  }
}

class _PasoMeta {
  const _PasoMeta(this.etiqueta, this.icono);
  final String etiqueta;
  final IconData icono;
}

const List<_PasoMeta> _metasPasosVacunas = [
  _PasoMeta('Perfil', Icons.assignment_ind_outlined),
  _PasoMeta('Vacuna', Icons.vaccines_outlined),
  _PasoMeta('Condición', Icons.health_and_safety_outlined),
  _PasoMeta('Esquema', Icons.account_tree_outlined),
  _PasoMeta('Dosis', Icons.numbers_outlined),
  _PasoMeta('Lote', Icons.inventory_2_outlined),
  _PasoMeta('Revisar', Icons.fact_check_outlined),
];

/// Stepper horizontal con etiquetas, tacto amplio y estados M3.
class VacunasFlujoStepper extends StatelessWidget {
  const VacunasFlujoStepper({
    Key? key,
    required this.pasoActual,
    required this.onIrAPaso,
  }) : super(key: key);

  /// 1–7 alineado con [VacunasPage] `pasos`.
  final int pasoActual;
  final ValueChanged<int> onIrAPaso;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_metasPasosVacunas.length, (i) {
          final n = i + 1;
          final meta = _metasPasosVacunas[i];
          final hecho = pasoActual > n;
          final actual = pasoActual == n;
          final Color borde;
          final Color fondoCirculo;
          final Color textoEtiqueta;
          if (actual) {
            borde = cs.primary;
            fondoCirculo = cs.primaryContainer;
            textoEtiqueta = cs.onSurface;
          } else if (hecho) {
            borde = cs.primary.withValues(alpha: 0.35);
            fondoCirculo = cs.primary.withValues(alpha: 0.12);
            textoEtiqueta = cs.onSurface;
          } else {
            borde = cs.outlineVariant.withValues(alpha: 0.55);
            fondoCirculo = cs.surfaceContainerHighest;
            textoEtiqueta = AppSuperficies.textoSecundario(context);
          }

          return Padding(
            padding: EdgeInsets.only(right: i < _metasPasosVacunas.length - 1 ? 6 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // Solo retroceso o paso actual (evita saltar adelante sin datos).
                onTap: n <= pasoActual ? () => onIrAPaso(n) : null,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: SizedBox(
                    width: 76,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: fondoCirculo,
                            border: Border.all(color: borde, width: actual ? 2 : 1),
                            boxShadow: actual
                                ? [
                                    BoxShadow(
                                      color: cs.primary.withValues(alpha: 0.18),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: hecho && !actual
                                ? Icon(Icons.check_rounded, color: cs.primary, size: 22)
                                : Icon(meta.icono,
                                    size: 22,
                                    color: actual
                                        ? cs.onPrimaryContainer
                                        : hecho
                                            ? cs.primary
                                            : cs.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meta.etiqueta,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: actual ? FontWeight.w800 : FontWeight.w600,
                            height: 1.15,
                            color: textoEtiqueta,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Contenedor del flujo: stepper + separador + contenido del paso.
class VacunasPanelFlujo extends StatelessWidget {
  const VacunasPanelFlujo({
    Key? key,
    required this.pasoActual,
    required this.onIrAPaso,
    required this.child,
  }) : super(key: key);

  final int pasoActual;
  final ValueChanged<int> onIrAPaso;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final nombrePaso = (pasoActual >= 1 &&
            pasoActual <= _metasPasosVacunas.length)
        ? _metasPasosVacunas[pasoActual - 1].etiqueta
        : '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: cs.surfaceContainerLow.withValues(alpha: 0.65),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspaciado.md,
              AppEspaciado.lg,
              AppEspaciado.md,
              AppEspaciado.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESQUEMA DE APLICACIÓN',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: cs.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Indicador de pasos',
                  style: GoogleFonts.barlow(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
            child: VacunasFlujoStepper(
              pasoActual: pasoActual,
              onIrAPaso: onIrAPaso,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspaciado.lg,
              AppEspaciado.md,
              AppEspaciado.lg,
              AppEspaciado.sm,
            ),
            child: Text(
              'Paso $pasoActual de 7 · $nombrePaso',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppSuperficies.textoSecundario(context),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: cs.outlineVariant.withValues(alpha: 0.35),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspaciado.md,
              AppEspaciado.lg,
              AppEspaciado.md,
              AppEspaciado.lg,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Título + subtítulo por paso del flujo (coherente con cabecera de pantalla).
class VacunasTituloSeccionPaso extends StatelessWidget {
  const VacunasTituloSeccionPaso({
    Key? key,
    this.etiqueta,
    required this.titulo,
    this.subtitulo,
  }) : super(key: key);

  final String? etiqueta;
  final String titulo;
  final String? subtitulo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (etiqueta != null) ...[
            Text(
              etiqueta!,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: cs.tertiary,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            titulo,
            style: GoogleFonts.barlow(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: cs.onSurface,
            ),
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitulo!,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: AppSuperficies.textoSecundario(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
