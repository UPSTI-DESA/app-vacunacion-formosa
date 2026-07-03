# Plan de mejora — Sesión de vacunación

Fecha del análisis: 2026-07-03. Rama base: `actualizacion2026`.
Contrato de funcionamiento (qué existe y cómo): `docs/contrato_sesion_vacunacion.md`.

Objetivo: que cargar una persona una vez y registrarle varias vacunas funcione
coherente y con el mínimo de pasos repetidos. La arquitectura de sesión ya existe
(ciclo persona / ciclo vacuna, `estado_sesion.dart`); este plan la corrige y la
completa. No se rehace nada.

## Reglas de trabajo

- No inventar ni asumir. Caso que no encaje en una fase: frenar y preguntar.
- Una fase = un commit `[SESION] <fase>`. `flutter analyze` en verde antes de commitear.
- No cambiar comportamiento fuera del alcance declarado de cada fase.
- Las decisiones marcadas **DECISIÓN** las toma el dueño del producto antes de
  ejecutar la fase; sin respuesta, la fase no se ejecuta.

---

## Fase 1 — Historial de dosis pertenece a la persona (bug)

**Problema**: `notiDosisEstado` y `listaDosisAplicadasEstado` están en
`estadosPorVacuna` (`estado_sesion.dart:55-56`). «Sí, otra vacuna» →
`reiniciarCicloVacuna()` (`confirmaciondatos_page.dart:601`) los vacía. El
historial es dato de la persona y solo se carga al buscar/escanear
(`busquedabeneficiario_page.dart:378-390`, `escanerdni_widget.dart:514-520`) →
en la segunda vacuna el «Historial de dosis» (`vacunas_page.dart:120-145`)
aparece vacío.

**Cambio**: mover esas 2 entradas de `estadosPorVacuna` a `estadosPorPersona`.

**Verificación**: registrar vacuna → «Sí, otra vacuna» → abrir historial → las
dosis previas siguen visibles.

## Fase 2 — Refrescar historial tras cada registro exitoso

**Problema**: la vacuna recién registrada no aparece en el historial hasta una
nueva búsqueda.

**Cambio**: en el camino «Sí, otra vacuna» (`confirmaciondatos_page.dart:600-607`),
re-llamar `validarNotificaciones(dni, sexo)` con los datos del beneficiario en
memoria y recargar `notificacionesDosisService` antes de navegar a `VacunasPage`.
Misma lógica de carga que `busquedabeneficiario_page.dart:386-390`.

**Verificación**: registrar → «Sí, otra vacuna» → historial incluye la dosis
recién aplicada.

## Fase 3 — Cierres de integridad de datos (tres chequeos chicos)

1. **Escáner valida `codigo_mensaje == '0'`** del beneficiario en
   `obtenerDatosBeneficiario` (`escanerdni_widget.dart:499`), igual que el tutor
   (`escanerdni_widget.dart:466`) y la vía manual
   (`busquedabeneficiario_page.dart:392`): error → diálogo y no avanza.
2. **Sexo↔condición al construir registro**: en `_construirRegistro`
   (`vacunas_page.dart:2605-2606`), si `sysdesa10_sexo != 'F'` → enviar condición
   gestacional null.
3. **Fecha aplicación ≥ fecha nacimiento**: en el picker de fecha
   (`vacunas_page.dart:2012-2018`), `firstDate` = max(2021, fecha nacimiento
   parseada si existe).

**Verificación**: escaneo de DNI inexistente no avanza; registro de persona M
sale sin condición; bebé nacido 2026 no admite fecha 2021.

## Fase 4 — Perfil heredado dentro de la visita ✅ resuelta

**Problema**: cada vacuna de la misma persona re-consulta perfiles y obliga a
re-seleccionar (`vacunas_page.dart:70,77`; `pasos = 1`).

**Decisión**: el perfil vive en el ciclo persona — se hereda entre vacunas de
la misma visita y se limpia al buscar otro beneficiario. Para cambiarlo, el
operador vuelve al paso 1 con el stepper (ya permite retroceder,
`vacunas_ui_helpers.dart:123`) y elige otro perfil ahí — sin pantalla ni
control nuevo.

**Cambio aplicado**:
- `perfilesVacunacionEstado` (perfil seleccionado) pasó de
  `estadosPorVacuna` a `estadosPorPersona` (`estado_sesion.dart`).
- Al elegir perfil en paso 1, se persiste con
  `perfilesVacunacionService.cargarPerfilesVacu(perfil)` además de
  `_selectPerfil` local (`vacunas_page.dart`, `onSelected` del `FilterChip`).
- `_heredarPerfilDeLaVisita()` en `initState`: si ya hay perfil de una vacuna
  anterior de la misma visita, lo asigna a `_selectPerfil`, arranca en
  `pasos = 2` y repite la consulta de vacunas×perfil (esa lista sí es de
  ciclo vacuna, se vació con `reiniciarCicloVacuna()`).

**Verificación**: registrar vacuna → «Sí, otra vacuna» → `VacunasPage` abre
directo en paso 2 con el mismo perfil; volver a paso 1 permite elegir otro.

## Fase 5 — «Vacunas de esta visita» ✅ resuelta

**Problema**: `insertRegistroService` guardaba solo el último registro; no
había rastro visible de lo aplicado en la visita en curso.

**Cambio aplicado**:
- `insertregistro_service.dart`: `visitaRegistrosEstado` (`Estado<List<InsertRegistros>>`)
  + `agregarRegistroVisita(registro)` (agrega con lista nueva, no mutación
  in-place, para que el `ValueNotifier` notifique).
- `estado_sesion.dart`: `visitaRegistrosEstado` va en `estadosPorPersona` — se
  acumula durante toda la visita y se limpia al buscar otro beneficiario.
- `confirmaciondatos_page.dart` (`enviarDatos`, rama de éxito): agrega el
  registro a la visita antes de mostrar el diálogo «¿otra vacuna?», así queda
  contado sin importar qué botón elija el operador después.
- UI: `_seccionVacunasVisita()` en `vacunas_page.dart` (debajo de
  `containerBeneficiario()`) y en `confirmaciondatos_page.dart` (arriba del
  resumen de la vacuna a confirmar) — tarjeta «Ya aplicadas en esta visita
  (N)» con vacuna · dosis por línea, oculta si la lista está vacía.

**Verificación**: registrar 2 vacunas seguidas a la misma persona → la 2ª
vez, tanto `VacunasPage` como `ConfirmarDatos` muestran la 1ª ya aplicada.

Base para Fase 6 (advertencia de duplicados).

## Fase 6 — Advertencia de duplicado en la visita

**Cambio**: antes de registrar, comparar vacuna+dosis contra el historial del
back (Fases 1-2) y contra la lista de la visita (Fase 5). Coincidencia → diálogo
de advertencia.

**DECISIÓN pendiente**: ¿advertencia (permite continuar) o bloqueo? Criterio
médico; default propuesto: advertencia.

## Fase 7 — Fricciones UX del ciclo

1. **«Cancelar registro» conserva a la persona**: hoy el único destino es
   `BusquedaBeneficiario` con pérdida total (`vacunas_page.dart:220-227`).
   Agregar opción «descartar esta vacuna» = `reiniciarCicloVacuna()` +
   `VacunasPage` (primitiva ya existente).
2. **Situación editable en `VacunasPage`**: reusar `SituacionBeneficiario`
   (stateless, `situacion_beneficiario_widget.dart:16`) para corregir
   embarazada/puérpera/personal de salud sin re-buscar.
3. **Sexo manual sin default**: `formulario_documento_widget.dart:77` arranca en
   `'F'`; pasar a sin selección + validación de elección explícita.
   **DECISIÓN pendiente**: confirmar que se quiere exigir elección.
4. **Colapsar doble confirmación** (paso 8 «Verificar» + página `ConfirmarDatos`)
   para la segunda vacuna en adelante: persona ya confirmada, revisar solo
   vacuna/dosis/lote. **DECISIÓN pendiente**: alcance exacto.
5. **Etiqueta sexo desconocido**: fallback «Femenino»
   (`busquedabeneficiario_page.dart:208-212`) → mostrar «Sin dato» cuando el
   sexo no es M/F/X.

## Fase 8 — Limpieza menor (independiente, cualquier momento)

1. Quitar doble escritura de `enTerreno`: dejar solo el on-change
   (`vacunador_page.dart:523`), borrar la del `dispose` (`vacunador_page.dart:68`).
2. `ResumenSesionVacunacion`: podar parámetros nunca variados
   (`mostrarNotaBackend`, `colapsable`, `expandidoInicial` — único uso real
   `busquedabeneficiario_page.dart:86`) y la nota backend muerta
   (`resumen_sesion_vacunacion_widget.dart:176-186`). Hacerlo reactivo a
   `enTerrenoEstado` con `ValueListenableBuilder`.
3. **DECISIÓN pendiente**: default de `enTerreno`
   (`sesion_equipo_vacunacion_service.dart:7`, hoy `true`).

---

## Fuera de alcance de este plan

- Confirmación de nombres de campos con el back
  (`condicion_gestacional_beneficiario`, `es_personal_salud`,
  `vacunacion_en_terreno`, semántica de `vacunador_registrador`): depende del PHP.
- Umbrales edad↔situación: se definen junto con la confirmación del back.
- Reset de sesión de equipo ante expiración de token: verificar primero si esa
  vía de salida existe.

## Decisiones pendientes (resumen)

| # | Decisión | Fase |
|---|----------|------|
| ~~1~~ | ~~Perfil: ciclo persona o ciclo cuenta~~ → ciclo persona, resuelto | 4 |
| 2 | Duplicados: advertencia o bloqueo | 6 |
| 3 | Sexo manual: exigir elección explícita | 7.3 |
| 4 | Confirmación única para 2ª vacuna en adelante: alcance | 7.4 |
| 5 | Default de `enTerreno` | 8.3 |
