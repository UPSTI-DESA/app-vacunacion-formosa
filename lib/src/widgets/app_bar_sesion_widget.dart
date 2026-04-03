import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sistema_vacunacion/src/config/config.dart';

/// AppBar unificada del flujo de vacunación (mismo criterio que Equipo de trabajo
/// y Buscar beneficiario): color de marca, título centrado, Nunito 18 semibold.
class AppBarSesion extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSesion({
    Key? key,
    required this.titulo,
    this.leading,
    this.actions,
    this.fadeDesde = 40,
  }) : super(key: key);

  final String titulo;
  final Widget? leading;
  final List<Widget>? actions;
  final double fadeDesde;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: SisVacuColor.vercelesteCuaternario,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: leading,
      automaticallyImplyLeading: leading == null,
      title: FadeInLeftBig(
        from: fadeDesde,
        child: Text(
          titulo,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
