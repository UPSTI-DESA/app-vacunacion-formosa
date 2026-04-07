import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

/// Cabecera contextual: jerarquía clara, copy orientado a tarea (patrón 2024–2026).
class VacunasEncabezadoPagina extends StatelessWidget {
  const VacunasEncabezadoPagina({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          'REGISTRO ACTIVO',
          style: tt.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: cs.primary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Vacunación en campo',
          style: tt.bodyMedium?.copyWith(
            fontSize: 13,
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
    final tt = Theme.of(context).textTheme;

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
            padding: EdgeInsets.only(right: i < _metasPasosVacunas.length - 1 ? 4 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: n <= pasoActual ? () => onIrAPaso(n) : null,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: SizedBox(
                    width: 48,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: fondoCirculo,
                            border: Border.all(color: borde, width: actual ? 2 : 1),
                            boxShadow: actual
                                ? [
                                    BoxShadow(
                                      color: cs.primary.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: hecho && !actual
                                ? Icon(Icons.check_rounded, color: cs.primary, size: 16)
                                : Icon(meta.icono,
                                    size: 16,
                                    color: actual
                                        ? cs.onPrimaryContainer
                                        : hecho
                                            ? cs.primary
                                            : cs.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meta.etiqueta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: tt.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: actual ? FontWeight.w800 : FontWeight.w500,
                            height: 1.1,
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
    final tt = Theme.of(context).textTheme;
    final nombrePaso = (pasoActual >= 1 &&
            pasoActual <= _metasPasosVacunas.length)
        ? _metasPasosVacunas[pasoActual - 1].etiqueta
        : '';

    return Material(
      elevation: 3,
      shadowColor: cs.shadow.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(20),
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera del paso con fondo en color primario — identidad visual fuerte
          Container(
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppEspaciado.md,
              AppEspaciado.sm,
              AppEspaciado.md,
              AppEspaciado.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'PASO $pasoActual DE 7',
                      style: tt.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: cs.onPrimaryContainer.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: cs.onPrimaryContainer.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      nombrePaso.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspaciado.xs),
                VacunasFlujoStepper(
                  pasoActual: pasoActual,
                  onIrAPaso: onIrAPaso,
                ),
              ],
            ),
          ),
          // Cuerpo del paso — superficie limpia y con espacio para respirar
          Padding(
            padding: const EdgeInsets.all(AppEspaciado.lg),
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
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (etiqueta != null) ...[
            Text(
              etiqueta!,
              style: tt.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: cs.tertiary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            titulo,
            style: bar.barlowTituloTarjeta.copyWith(
              fontSize: 16,
              height: 1.1,
              color: cs.onSurface,
            ),
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitulo!,
              style: tt.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.3,
                color: AppSuperficies.textoSecundario(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
