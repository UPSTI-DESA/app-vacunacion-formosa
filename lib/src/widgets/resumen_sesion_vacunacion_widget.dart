import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/services/services.dart';

/// Muestra establecimiento, modalidad (terreno / fijo) y nombre del vacunador.
/// Útil en búsqueda de beneficiario y en confirmación antes de registrar.
///
/// Con [colapsable]: el usuario puede plegar la tarjeta para ganar espacio; el D.N.I.
/// del vacunador no se muestra (el nombre alcanza para identificar la sesión).
class ResumenSesionVacunacion extends StatefulWidget {
  const ResumenSesionVacunacion({
    Key? key,
    this.mostrarNotaBackend = false,
    this.compendio = false,
    this.colapsable = true,
    this.expandidoInicial = false,
  }) : super(key: key);

  /// Texto aclaratorio: el campo ya viaja en el JSON; el servidor debe persistirlo.
  final bool mostrarNotaBackend;

  /// Menos padding y tipografía más chica (p. ej. pantalla de búsqueda).
  final bool compendio;

  /// Si es true, cabecera tocable para expandir / ocultar el detalle.
  final bool colapsable;

  /// Estado inicial cuando [colapsable] es true.
  final bool expandidoInicial;

  @override
  State<ResumenSesionVacunacion> createState() =>
      _ResumenSesionVacunacionState();
}

class _ResumenSesionVacunacionState extends State<ResumenSesionVacunacion> {
  late bool _expandido;

  @override
  void initState() {
    super.initState();
    _expandido = widget.colapsable ? widget.expandidoInicial : true;
  }

  @override
  void didUpdateWidget(ResumenSesionVacunacion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.colapsable) {
      _expandido = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bar = context.sisTipografia;

    final String establecimiento =
        registradorService.registrador?.sysofic01_descripcion ?? '—';
    final String vacunadorNombre =
        vacunadorService.vacunador?.sysdesa06_nombre ?? '—';
    final String modalidad = sesionEquipoVacunacionService.enTerreno
        ? 'En terreno (campaña o salida)'
        : 'En establecimiento fijo';

    final double pad = widget.compendio ? AppEspaciado.md : AppEspaciado.lg;
    final double anchoEtiqueta = widget.compendio ? 96 : 112;

    return Container(
      width: double.infinity,
      decoration: AppSuperficies.tarjeta(context).copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.colapsable)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _expandido = !_expandido),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, pad, pad * 0.35, pad),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sesión de vacunación',
                              style: bar.barlowTituloTarjeta.copyWith(
                                fontSize: widget.compendio ? 19 : 22,
                                color: cs.onSurface,
                              ),
                            ),
                            if (!_expandido) ...[
                              const SizedBox(height: 4),
                              Text(
                                establecimiento,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tt.bodySmall?.copyWith(
                                  fontSize: widget.compendio ? 12 : 13,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        _expandido
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: cs.primary,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!widget.colapsable || _expandido)
            Padding(
              padding: EdgeInsets.fromLTRB(
                pad,
                widget.colapsable ? AppEspaciado.sm : pad,
                pad,
                pad,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.colapsable) ...[
                    Text(
                      'Sesión de vacunación',
                      style: bar.barlowTituloTarjeta.copyWith(
                        fontSize: widget.compendio ? 19 : 22,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppEspaciado.sm),
                    Text(
                      'Lo que se usará al registrar la aplicación',
                      style: tt.bodySmall?.copyWith(
                        fontSize: widget.compendio ? 12 : 13,
                        height: 1.35,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(
                        height: widget.compendio
                            ? AppEspaciado.md
                            : AppEspaciado.lg),
                  ] else ...[
                    Text(
                      'Lo que se usará al registrar la aplicación',
                      style: tt.bodySmall?.copyWith(
                        fontSize: widget.compendio ? 12 : 13,
                        height: 1.35,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(
                        height: widget.compendio
                            ? AppEspaciado.md
                            : AppEspaciado.lg),
                  ],
                  _fila(
                    context,
                    anchoEtiqueta: anchoEtiqueta,
                    compendio: widget.compendio,
                    etiqueta: 'Establecimiento',
                    valor: establecimiento,
                  ),
                  _fila(
                    context,
                    anchoEtiqueta: anchoEtiqueta,
                    compendio: widget.compendio,
                    etiqueta: 'Modalidad',
                    valor: modalidad,
                  ),
                  _fila(
                    context,
                    anchoEtiqueta: anchoEtiqueta,
                    compendio: widget.compendio,
                    etiqueta: 'Vacunador',
                    valor: vacunadorNombre,
                  ),
                  if (widget.mostrarNotaBackend) ...[
                    const SizedBox(height: AppEspaciado.md),
                    Text(
                      'La modalidad se envía en el registro. Cuando el servidor la habilite, quedará guardada igual que el resto de los datos.',
                      style: tt.labelSmall?.copyWith(
                        fontSize: 11,
                        height: 1.4,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _fila(
    BuildContext context, {
    required double anchoEtiqueta,
    required bool compendio,
    required String etiqueta,
    required String valor,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppEspaciado.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: anchoEtiqueta,
            child: Text(
              etiqueta,
              style: tt.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                fontSize: compendio ? 12 : 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: compendio ? 14 : 15,
                height: 1.3,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
