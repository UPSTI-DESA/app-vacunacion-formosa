import 'estado.dart';
import 'usuariobeneficiario_service.dart';
import 'tutor_service.dart';
import 'perfilesvacunacion_service.dart';
import 'vacunasconfiguracion_service.dart';
import 'vacunaslotes_service.dart';
import 'vacunas_dosis_service.dart';
import 'vacunas_condicion_service.dart';
import 'vacunas_esquema_service.dart';
import 'vacunasxperfiles_service.dart';
import 'notificacionesdosis_service.dart';
import 'insertregistro_service.dart';
import 'loadingLogin_service.dart';

/// Estados que pertenecen al ciclo "por beneficiario": nacen y mueren con cada
/// persona atendida (ver Fase 2 del plan). Ciclo largo (tema, enviroment,
/// vacunador, registrador, efectores, sesionEquipoVacunacion, cantidadVacunados)
/// NO se registra acá.
final List<Estado> estadosPorBeneficiario = [
  beneficiarioService.beneficiarioEstado,
  beneficiarioService.edadEstado,
  beneficiarioService.fechaNacEstado,
  tutorService.tutorEstado,
  perfilesVacunacionService.perfilesVacunacionEstado,
  perfilesVacunacionService.listaPerfilesVacunacionEstado,
  perfilesVacunacionService.mensajeListaPerfilesVaciaEstado,
  vacunasConfiguracionService.vacunasConfiguracionEstado,
  vacunasConfiguracionService.listavacunasConfiguracionEstado,
  vacunasConfiguracionService.listavacunasConfiguracionBusquedaEstado,
  vacunasLotesService.vacunasLotesEstado,
  vacunasLotesService.listavacunaslotesEstado,
  vacunasLotesService.listavacunaslotesBusquedaEstado,
  vacunasDosisService.vacunasDosisEstado,
  vacunasDosisService.listaVacunasDosisEstado,
  vacunasDosisService.listaVacunasDosisBusquedaEstado,
  vacunasCondicionService.vacunasCondicionEstado,
  vacunasCondicionService.listaVacunasCondicionEstado,
  vacunasCondicionService.listaVacunasCondicionBusquedaEstado,
  vacunasEsquemaService.vacunasEsquemaEstado,
  vacunasEsquemaService.listaVacunasEsquemaEstado,
  vacunasEsquemaService.listaVacunasEsquemaBusquedaEstado,
  vacunasxPerfilService.vacunasxperfilEstado,
  vacunasxPerfilService.listavacunasxperfilEstado,
  vacunasxPerfilService.listavacunasxperfilBusquedaEstado,
  notificacionesDosisService.notiDosisEstado,
  notificacionesDosisService.listaDosisAplicadasEstado,
  insertRegistroService.registroEstado,
  loadingLoginService.loadingVerificarEstado,
  loadingLoginService.loadingDosisEstado,
  loadingLoginService.loadingEsquemaEstado,
  loadingLoginService.loadingCondicionEstado,
  loadingLoginService.cargaPerfilEstado,
  loadingLoginService.cargaLotesEstado,
];

/// Reinicia todo el ciclo corto de una. Se llama al iniciar un beneficiario nuevo.
void reiniciarCicloBeneficiario() {
  for (final e in estadosPorBeneficiario) {
    e.reiniciar();
  }
}
