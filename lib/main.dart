import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sistema_vacunacion/src/config/config.dart';
import 'package:sistema_vacunacion/src/helpers/database_helper.dart';
import 'package:sistema_vacunacion/src/services/enviroment_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'src/pages/pages.dart';

final dbHelper = DatabaseHelper();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _buildReleaseErrorWidgetBuilder();
  AppConfig appconfig = AppConfig(enviroment: 'PROD');
  enviromentService.cargarEnviroment(appconfig);
  await dbHelper.init();
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
