import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/services/enviroment_service.dart';

import 'src/pages/pages.dart';

void main() {
  AppConfig appconfig = AppConfig(enviroment: 'DEV');
  enviromentService.cargarEnviroment(appconfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildMaterialApp();
  }

  MaterialApp _buildMaterialApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner:
          enviromentService.envState!.enviroment == 'DEV' ? true : false,
      initialRoute: LoginBody.nombreRuta,
      theme: SisVacuColor.theme.theme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en", "US"), // Ingles
        Locale("es", "ES"), // Español
      ],
      routes: {
        //TODO:LLEVAR A ARCHIVO DE RUTAS
        LoginBody.nombreRuta: (BuildContext context) => const LoginBody(),
        VacunadorPage.nombreRuta: (BuildContext context) => const VacunadorPage(
              infoCargador: [],
            ),
        BusquedaBeneficiario.nombreRuta: (context) =>
            const BusquedaBeneficiario(),

        VacunasPage.nombreRuta: (BuildContext context) => const VacunasPage(
              vacunas: [],
            ),
      },
    );
  }
}
