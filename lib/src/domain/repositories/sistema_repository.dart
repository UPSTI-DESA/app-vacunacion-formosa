import 'package:sistema_vacunacion/src/domain/entities/entities.dart';

abstract class SistemaRepository {
  Future<List<MensajeServidor>> insertRegistroProd();
  Future validarNotificaciones(String? dni, String? sexo);
  Future validarVersionNuevaVersion(String nombreapp, String versionApp);
}
