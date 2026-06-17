import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/widgets/escanerdni_widget.dart';
import 'package:sistema_vacunacion/src/widgets/alertadialogo_widget.dart';

/// Formulario unificado de captura de documento de una persona.
///
/// Encapsula el patrón repetido en las pantallas de **Vacunador**,
/// **Búsqueda de beneficiario** y **registro de Tutor** (en Vacunas):
/// escanear el D.N.I. con la cámara o ingresarlo manualmente, elegir el
/// sexo (opcional) y disparar la verificación.
///
/// La apariencia es la canónica del panel de tutor de Vacunas (chips de
/// sexo + [FilledButton]). La lógica posterior a la verificación NO vive
/// aquí: cada pantalla la inyecta vía [onVerificar].
class FormularioDocumento extends StatefulWidget {
  /// Tipo que se le pasa a [EscanerDni]: 'Vacunador' | 'Beneficiario' | 'Tutor'.
  final String tipoEscaneo;

  /// Texto del botón de escaneo (p. ej. 'Escanear documento' o 'Escanear').
  final String textoBotonEscaneo;

  /// Alto del botón de [EscanerDni].
  final double anchoEscaner;

  /// Si es `false`, no se muestra el selector de sexo (caso Vacunador) y
  /// [onVerificar] recibe `sexo == null`.
  final bool mostrarSexo;

  /// Controlador del campo de D.N.I. (lo administra la pantalla anfitriona).
  final TextEditingController controladorDni;

  /// Foco opcional del campo de D.N.I.
  final FocusNode? focusNode;

  /// Etiqueta e ícono del botón de acción.
  final String etiquetaBoton;
  final IconData iconoBoton;

  /// Callback de verificación. Recibe el D.N.I. ingresado y el sexo ('F'/'M')
  /// o `null` cuando [mostrarSexo] es `false`.
  final void Function(String dni, String? sexo) onVerificar;

  const FormularioDocumento({
    super.key,
    required this.tipoEscaneo,
    required this.textoBotonEscaneo,
    required this.controladorDni,
    required this.onVerificar,
    this.anchoEscaner = 52,
    this.mostrarSexo = true,
    this.focusNode,
    this.etiquetaBoton = 'Verificar',
    this.iconoBoton = Icons.verified_user_outlined,
  });

  @override
  State<FormularioDocumento> createState() => _FormularioDocumentoState();
}

class _FormularioDocumentoState extends State<FormularioDocumento> {
  /// Estado del selector de sexo: `false` = Femenino ('F'), `true` = Masculino ('M').
  bool _genero = false;

  String get _sexo => _genero ? 'M' : 'F';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botón escanear
        SizedBox(
          width: double.infinity,
          child: EscanerDni(
            widget.tipoEscaneo,
            widget.textoBotonEscaneo,
            anchoValor: widget.anchoEscaner,
          ),
        ),

        const SizedBox(height: AppEspaciado.lg),

        // Separador "o ingresá los datos"
        Row(
          children: [
            Expanded(
              child: Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppEspaciado.sm),
              child: Text(
                'o ingresá los datos',
                style: tt.labelSmall?.copyWith(
                  fontSize: 11,
                  letterSpacing: 0.3,
                  color: AppSuperficies.textoSecundario(context),
                ),
              ),
            ),
            Expanded(
              child: Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
            ),
          ],
        ),

        const SizedBox(height: AppEspaciado.lg),

        // Campo D.N.I.
        _campoDni(cs, tt),

        if (widget.mostrarSexo) ...[
          const SizedBox(height: AppEspaciado.lg),
          _selectorSexo(cs, tt),
        ],

        const SizedBox(height: AppEspaciado.lg),

        // Botón verificar
        FilledButton.icon(
          style: AppBotones.estiloFilledIconCta(
            padding: const EdgeInsets.symmetric(
              horizontal: AppEspaciado.radioCampo,
              vertical: AppEspaciado.md + AppEspaciado.xs,
            ),
          ),
          onPressed: _onPresionarVerificar,
          icon: Icon(widget.iconoBoton),
          label: Text(widget.etiquetaBoton),
        ),
      ],
    );
  }

  void _onPresionarVerificar() {
    if (widget.controladorDni.text.length >= 7) {
      widget.onVerificar(
        widget.controladorDni.text,
        widget.mostrarSexo ? _sexo : null,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogCtx) => DialogoAlerta(
          envioFuncion2: false,
          envioFuncion1: false,
          tituloAlerta: 'Datos incompletos',
          descripcionAlerta:
              'D.N.I. de al menos 7 dígitos y sexo indicados.',
          textoBotonAlerta: 'Listo',
          color: Theme.of(dialogCtx).colorScheme.error,
          icon: const Icon(Icons.error_outline_rounded, size: 40),
        ),
      );
    }
  }

  Widget _campoDni(ColorScheme cs, TextTheme tt) {
    return Container(
      decoration: AppSuperficies.campoBusqueda(context),
      child: TextField(
        autocorrect: false,
        controller: widget.controladorDni,
        keyboardType: TextInputType.number,
        maxLength: 8,
        focusNode: widget.focusNode,
        onEditingComplete: () => widget.focusNode?.unfocus(),
        style: tt.titleMedium?.copyWith(fontSize: 16, color: cs.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: cs.surfaceContainer,
          counterText: '',
          prefixIcon: Icon(
            Icons.perm_identity_rounded,
            color: cs.onSurfaceVariant,
          ),
          hintText: 'D.N.I.',
          hintStyle: tt.bodyLarge?.copyWith(
            fontSize: 15,
            color: AppSuperficies.textoSecundario(context),
          ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _selectorSexo(ColorScheme cs, TextTheme tt) {
    const colorFemenino = Color(0xFFE91E8C);
    const colorMasculino = Color(0xFF009CAF);

    Widget chip({
      required bool seleccionado,
      required String etiqueta,
      required IconData icono,
      required Color colorAccento,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: Material(
          color: seleccionado
              ? colorAccento.withValues(alpha: 0.10)
              : cs.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
            side: BorderSide(
              color: seleccionado ? colorAccento : cs.outlineVariant,
              width: seleccionado ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppEspaciado.radioBoton),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppEspaciado.md,
                horizontal: AppEspaciado.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icono,
                    size: 32,
                    color: seleccionado ? colorAccento : cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppEspaciado.xs),
                  Text(
                    etiqueta,
                    style: tt.titleSmall?.copyWith(
                      fontSize: 14,
                      fontWeight:
                          seleccionado ? FontWeight.w800 : FontWeight.w600,
                      color: seleccionado ? colorAccento : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sexo',
          style: tt.labelLarge?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: AppSuperficies.textoSecundario(context),
          ),
        ),
        const SizedBox(height: AppEspaciado.sm),
        Row(
          children: [
            chip(
              seleccionado: !_genero,
              etiqueta: 'Femenino',
              icono: Icons.female_rounded,
              colorAccento: colorFemenino,
              onTap: () => setState(() => _genero = false),
            ),
            const SizedBox(width: AppEspaciado.sm),
            chip(
              seleccionado: _genero,
              etiqueta: 'Masculino',
              icono: Icons.male_rounded,
              colorAccento: colorMasculino,
              onTap: () => setState(() => _genero = true),
            ),
          ],
        ),
      ],
    );
  }
}
