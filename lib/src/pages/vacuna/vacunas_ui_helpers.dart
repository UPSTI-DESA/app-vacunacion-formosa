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
        const SizedBox(width: AppEspaciado.sm),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppEspaciado.sm),
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

class _ColorPasoMeta {
  const _ColorPasoMeta(this.color);
  final Color color;
}

const List<_ColorPasoMeta> _coloresPasosVacunas = [
  _ColorPasoMeta(Color(0xFF004B8E)),
  _ColorPasoMeta(Color(0xFF00796B)),
  _ColorPasoMeta(Color(0xFF00897A)),
  _ColorPasoMeta(Color(0xFF0097A7)),
  _ColorPasoMeta(Color(0xFF00695C)),
  _ColorPasoMeta(Color(0xFF009688)),
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

/// Contenedor del flujo: header con selecciones + stepper + contenido del paso.
class VacunasPanelFlujo extends StatefulWidget {
  const VacunasPanelFlujo({
    Key? key,
    required this.pasoActual,
    required this.onIrAPaso,
    required this.child,
    this.perfil,
    this.vacuna,
    this.condicion,
    this.esquema,
    this.dosis,
    this.lote,
  }) : super(key: key);

  final int pasoActual;
  final ValueChanged<int> onIrAPaso;
  final Widget child;
  final String? perfil;
  final String? vacuna;
  final String? condicion;
  final String? esquema;
  final String? dosis;
  final String? lote;

  @override
  State<VacunasPanelFlujo> createState() => _VacunasPanelFlujoState();
}

class _VacunasPanelFlujoState extends State<VacunasPanelFlujo> {
  final List<_ItemSeleccion> _items = [];

  @override
  void didUpdateWidget(VacunasPanelFlujo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _actualizarItems();
  }

  @override
  void initState() {
    super.initState();
    _actualizarItems();
  }

  void _actualizarItems() {
    _items.clear();
    _items.addAll([
      _ItemSeleccion(numeroPaso: 1, nombre: 'Perfil', valor: widget.perfil, icono: Icons.assignment_ind_outlined, indiceColor: 0),
      _ItemSeleccion(numeroPaso: 2, nombre: 'Vacuna', valor: widget.vacuna, icono: Icons.vaccines_outlined, indiceColor: 1),
      _ItemSeleccion(numeroPaso: 3, nombre: 'Condición', valor: widget.condicion, icono: Icons.health_and_safety_outlined, indiceColor: 2),
      _ItemSeleccion(numeroPaso: 4, nombre: 'Esquema', valor: widget.esquema, icono: Icons.account_tree_outlined, indiceColor: 3),
      _ItemSeleccion(numeroPaso: 5, nombre: 'Dosis', valor: widget.dosis, icono: Icons.numbers_outlined, indiceColor: 4),
      _ItemSeleccion(numeroPaso: 6, nombre: 'Lote', valor: widget.lote, icono: Icons.inventory_2_outlined, indiceColor: 5),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final nombrePaso = (widget.pasoActual >= 1 &&
            widget.pasoActual <= _metasPasosVacunas.length)
        ? _metasPasosVacunas[widget.pasoActual - 1].etiqueta
        : '';

    final pasosCompletados = _items.where((i) => i.tieneValor).length;

    return Container(
      decoration: AppSuperficies.tarjetaBlanca(context, radio: AppEspaciado.xl),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppEspaciado.xl),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppEspaciado.lg,
              AppEspaciado.lg,
              AppEspaciado.lg,
              AppEspaciado.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppEspaciado.radioCampo),
                      ),
                      child: Text(
                        'PASO ${widget.pasoActual} DE 7',
                        style: tt.labelSmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      nombrePaso.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: cs.onPrimaryContainer.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    if (pasosCompletados > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$pasosCompletados completados',
                          style: tt.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppEspaciado.md),
                _BarraSelecciones(
                  items: _items,
                  pasoActual: widget.pasoActual,
                  onIrAPaso: widget.onIrAPaso,
                ),
              ],
            ),
          ),
          Container(
            color: cs.surfaceContainerLowest,
            child: Padding(
              padding: const EdgeInsets.all(AppEspaciado.lg),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemSeleccion {
  const _ItemSeleccion({
    required this.numeroPaso,
    required this.nombre,
    this.valor,
    required this.icono,
    required this.indiceColor,
  });

  final int numeroPaso;
  final String nombre;
  final String? valor;
  final IconData icono;
  final int indiceColor;
  bool get tieneValor => valor != null && valor!.isNotEmpty;
}

class _BarraSelecciones extends StatelessWidget {
  const _BarraSelecciones({
    required this.items,
    required this.pasoActual,
    required this.onIrAPaso,
  });

  final List<_ItemSeleccion> items;
  final int pasoActual;
  final ValueChanged<int> onIrAPaso;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
            child: Row(
              children: [
                for (int j = i; j < i + 2 && j < items.length; j++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: j < i + 1 && j < items.length - 1 ? AppEspaciado.sm : 0),
                      child: _ChipItemSeleccion(
                        item: items[j],
                        esPasoActual: pasoActual == items[j].numeroPaso,
                        puedeTocarse: items[j].numeroPaso <= pasoActual || items[j].tieneValor,
                        onTap: () => onIrAPaso(items[j].numeroPaso),
                      ),
                    ),
                  ),
                if (i + 2 > items.length && items.length - i == 1)
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }
}

class _ChipItemSeleccion extends StatelessWidget {
  const _ChipItemSeleccion({
    required this.item,
    required this.esPasoActual,
    required this.puedeTocarse,
    required this.onTap,
  });

  final _ItemSeleccion item;
  final bool esPasoActual;
  final bool puedeTocarse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final oscuro = cs.brightness == Brightness.dark;

    final colorPaso = _coloresPasosVacunas[item.indiceColor].color;

    final Color borde;
    final Color colorIcono;
    final Color colorNombre;
    final Color colorValor;

    if (item.tieneValor) {
      borde = colorPaso;
      colorIcono = oscuro ? colorPaso.withValues(alpha: 0.9) : colorPaso;
      colorNombre = oscuro ? cs.onSurface.withValues(alpha: 0.6) : cs.onSurfaceVariant;
      colorValor = oscuro ? cs.onSurface : colorPaso.withValues(alpha: 0.85);
    } else if (esPasoActual) {
      borde = cs.primary;
      colorIcono = cs.primary;
      colorNombre = cs.onSurfaceVariant;
      colorValor = cs.primary;
    } else {
      borde = cs.outlineVariant;
      colorIcono = cs.onSurfaceVariant.withValues(alpha: 0.5);
      colorNombre = cs.onSurfaceVariant.withValues(alpha: 0.5);
      colorValor = cs.onSurfaceVariant.withValues(alpha: 0.4);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: puedeTocarse ? onTap : null,
        borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
            border: Border.all(color: borde, width: esPasoActual ? 2 : 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.tieneValor
                      ? colorPaso.withValues(alpha: oscuro ? 0.2 : 0.1)
                      : (esPasoActual ? cs.primary.withValues(alpha: 0.1) : Colors.transparent),
                  border: Border.all(color: borde, width: 1.5),
                ),
                child: Center(
                  child: item.tieneValor
                      ? Icon(Icons.check, size: 14, color: colorPaso)
                      : Text(
                          '${item.numeroPaso}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colorPaso,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppEspaciado.sm),
              Icon(item.icono, size: 16, color: colorIcono),
              const SizedBox(width: AppEspaciado.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.nombre,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colorNombre,
                        height: 1.2,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: AppEspaciado.xs),
                    Text(
                      item.tieneValor ? item.valor! : (esPasoActual ? 'Seleccione...' : '—'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: item.tieneValor ? FontWeight.w700 : FontWeight.w400,
                        fontStyle: item.tieneValor ? FontStyle.normal : FontStyle.italic,
                        color: colorValor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            style: bar.tituloTarjeta.copyWith(
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

class VacunasBarraResumen extends StatelessWidget {
  const VacunasBarraResumen({
    Key? key,
    required this.pasoActual,
    required this.perfil,
    required this.vacuna,
    required this.condicion,
    required this.esquema,
    required this.dosis,
    required this.lote,
  }) : super(key: key);

  final int pasoActual;
  final String? perfil;
  final String? vacuna;
  final String? condicion;
  final String? esquema;
  final String? dosis;
  final String? lote;

  @override
  Widget build(BuildContext context) {
    final selections = [
      _ChipDatoPaso(nombre: 'Perfil', valor: perfil, indice: 0),
      _ChipDatoPaso(nombre: 'Vacuna', valor: vacuna, indice: 1),
      _ChipDatoPaso(nombre: 'Condición', valor: condicion, indice: 2),
      _ChipDatoPaso(nombre: 'Esquema', valor: esquema, indice: 3),
      _ChipDatoPaso(nombre: 'Dosis', valor: dosis, indice: 4),
      _ChipDatoPaso(nombre: 'Lote', valor: lote, indice: 5),
    ];

    return Wrap(
      spacing: AppEspaciado.sm,
      runSpacing: AppEspaciado.sm,
      children: selections.map((chip) {
        return _ChipSeleccion(
          nombre: chip.nombre,
          valor: chip.valor ?? '—',
          tieneValor: chip.valor != null && chip.valor!.isNotEmpty,
          colorBase: _coloresPasosVacunas[chip.indice].color,
        );
      }).toList(),
    );
  }
}

class _ChipDatoPaso {
  const _ChipDatoPaso({
    required this.nombre,
    required this.valor,
    required this.indice,
  });
  final String nombre;
  final String? valor;
  final int indice;
}

class _ChipSeleccion extends StatelessWidget {
  const _ChipSeleccion({
    required this.nombre,
    required this.valor,
    required this.tieneValor,
    required this.colorBase,
  });

  final String nombre;
  final String valor;
  final bool tieneValor;
  final Color colorBase;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final oscuro = cs.brightness == Brightness.dark;

    final Color fondo;
    final Color borde;
    final Color texto;

    if (tieneValor) {
      if (oscuro) {
        fondo = colorBase.withValues(alpha: 0.35);
        borde = colorBase.withValues(alpha: 0.8);
        texto = colorBase.withValues(alpha: 1.0);
      } else {
        fondo = colorBase.withValues(alpha: 0.15);
        borde = colorBase.withValues(alpha: 0.6);
        texto = colorBase;
      }
    } else {
      fondo = cs.surfaceContainerHighest.withValues(alpha: 0.5);
      borde = cs.outlineVariant.withValues(alpha: 0.5);
      texto = cs.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.md, vertical: AppEspaciado.xs),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(AppEspaciado.sm),
        border: Border.all(color: borde, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$nombre: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: texto,
            ),
          ),
          Flexible(
            child: Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: tieneValor ? FontWeight.w700 : FontWeight.w400,
                color: texto,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
