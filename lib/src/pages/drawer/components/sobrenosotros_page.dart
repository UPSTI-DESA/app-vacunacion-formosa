import 'package:flutter/material.dart';

import 'package:sistema_vacunacion/src/utils/informacion_version_app_util.dart';
import 'package:sistema_vacunacion/src/widgets/widgets.dart';

class SobreNosotrosPage extends StatelessWidget {
  const SobreNosotrosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final texto = cs.onSurface;
    final estiloTexto = tt.titleMedium?.copyWith(
      letterSpacing: 2.0,
      fontWeight: FontWeight.w300,
      fontSize: 20,
      color: texto,
    );
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBarSesion(
        titulo: 'Sobre nosotros',
        leading: IconButton(
          style: IconButton.styleFrom(
            foregroundColor: cs.onPrimary,
            backgroundColor: cs.onPrimary.withValues(alpha: 0.18),
          ),
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: cs.surface),
        child: Center(
          child: Container(
            width: size.width * 0.85,
            height: size.height * 0.50,
            margin: const EdgeInsets.symmetric(vertical: 30.0),
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.25),
                  blurRadius: 3.0,
                  offset: const Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40.0),
                FutureBuilder<String>(
                  future: InformacionVersionApp.etiquetaSemver(),
                  builder: (BuildContext context, AsyncSnapshot<String> snap) {
                    final String v = snap.data ?? '…';
                    return Text(
                      'Versión: $v',
                      style: tt.headlineSmall?.copyWith(
                        fontSize: 25,
                        color: texto,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                Text(
                  'Desarrollado Por: ',
                  style: estiloTexto,
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: const AssetImage('assets/img/fondo/logopolo.png'),
                      fit: BoxFit.cover,
                      height: size.height * 0.12,
                    ),
                    Image(
                      image: const AssetImage('assets/img/fondo/logoupsti.png'),
                      fit: BoxFit.cover,
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
