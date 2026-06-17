import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/debug/dev_overlay.dart';
import 'package:sistema_vacunacion/src/services/enviroment_service.dart';
import 'package:sistema_vacunacion/src/services/tema_app_service.dart';

import 'src/pages/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await temaAppService.inicializar();
  _buildReleaseErrorWidgetBuilder();
  AppConfig appconfig = AppConfig(enviroment: 'DEV');
  enviromentService.cargarEnviroment(appconfig);

  runApp(const MyApp());
}

_buildReleaseErrorWidgetBuilder() {
  if (kReleaseMode) {
    ErrorWidget.builder = (errorDetails) {
      return Container(
        color: Colors.red,
        child: const Center(
          child: Icon(
            Icons.error,
            color: Colors.white,
          ),
        ),
      );
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: temaAppService,
      builder: (context, _) {
        return _buildMaterialApp();
      },
    );
  }

  MaterialApp _buildMaterialApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner:
          enviromentService.envState!.enviroment == 'DEV' ? true : false,
      builder: (context, child) {
        if (enviromentService.envState?.enviroment == 'DEV') {
          return DevOverlay(child: child!);
        }
        return child!;
      },
      initialRoute: LoginBody.nombreRuta,
      theme: SisVacuTheme.light.theme,
      darkTheme: SisVacuTheme.light.temaOscuro,
      themeMode: temaAppService.modoTema,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("es", "ES"), // Español
      ],
      routes: {
        LoginBody.nombreRuta: (BuildContext context) => const LoginBody(),
        VacunadorPage.nombreRuta: (BuildContext context) => const VacunadorPage(
              infoCargador: [],
            ),
        BusquedaBeneficiario.nombreRuta: (context) =>
            const BusquedaBeneficiario(),
        VacunasPage.nombreRuta: (BuildContext context) => const VacunasPage(),
      },
    );
  }
}
