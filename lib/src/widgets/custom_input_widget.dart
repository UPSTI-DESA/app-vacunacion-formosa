import 'package:flutter/material.dart';
import 'package:sistema_vacunacion/src/config/app_spacing_config.dart';

/// Campo de texto con estilo de app. El teclado lo muestra el sistema al tomar foco
/// ([FocusNode]); no hay API público tipo «showKeyboard» en la app.
///
/// [scrollPadding] lo usa el [TextField] al llamar a [Scrollable.ensureVisible]: define
/// margen mínimo respecto al viewport al enfocar dentro de un [ScrollView]. El efecto
/// real depende de la pantalla: [Scaffold.resizeToAvoidBottomInset], si el [MaterialApp]
/// recibe insets del SO (p. ej. Android `adjustPan` vs `adjustResize`), etc. Ajustar
/// por pantalla si un campo queda tapado.
class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final Function()? funcion;
  /// Margen mínimo al hacer scroll al enfocar (p. ej. sobre el teclado).
  final EdgeInsets scrollPadding;

  final bool isPassword;
  final bool funcionTerminar;
  final bool autoFocus;
  final int maxLength;
  final FocusNode focusNode;

  const CustomInput({
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.autoFocus = false,
    this.funcionTerminar = false,
    this.maxLength = 8,
    required this.focusNode,
    this.funcion,
    this.scrollPadding = const EdgeInsets.only(bottom: 120),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo [Theme]: no registrar dependencia de [MediaQuery] (tamaño / insets).
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: const EdgeInsets.symmetric(horizontal: AppEspaciado.lg),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .shadow
                    .withValues(alpha: 0.08),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]),
      child: TextField(
        autofocus: autoFocus,
        focusNode: focusNode,
        maxLength: maxLength,
        autocorrect: false,
        controller: textController,
        keyboardType: keyboardType,
        obscureText: isPassword,
        onEditingComplete: funcionTerminar == true ? funcion : null,
        scrollPadding: scrollPadding,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: placeholder,
        ),
      ),
    );
  }
}
