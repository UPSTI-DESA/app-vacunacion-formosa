# Contrato — Sesión de vacunación (ciclos de estado y flujo de carga)

Documento de estado vivo. Describe cómo funciona el flujo de carga de un registro
de vacunación y los ciclos de vida del estado en memoria. Todo lo afirmado está
verificado en código con cita `archivo:línea`. Lo no verificado se marca explícito.

Análisis de origen: 2026-07-03, rama `actualizacion2026`.

---

## Los tres ciclos de vida del estado

El estado en memoria vive en singletons `Estado<T>` (`lib/src/presentation/state/`).
Se agrupa en tres ciclos, de mayor a menor duración:

| Ciclo | Nace | Muere | Contiene |
|-------|------|-------|----------|
| **Largo (cuenta/equipo)** | Login / pantalla «Equipo de trabajo» | Logout manual (`drawer_page.dart:110`) | tema, enviroment, vacunador, registrador, efectores, `sesionEquipoVacunacionService` (enTerreno), cantidadVacunados (`estado_sesion.dart:30-32`) |
| **Persona (`estadosPorPersona`)** | Al cargar un beneficiario | Al buscar otro beneficiario — `reiniciarCicloBeneficiario()` | beneficiario, edad y fecha nac. del PDF417, tutor, situación (condición gestacional + personal de salud), historial de dosis (notificaciones), perfil de vacunación elegido, **vacunas registradas en la visita** (`estado_sesion.dart:19-34`) |
| **Vacuna (`estadosPorVacuna`)** | Al iniciar la carga de una vacuna | Entre dosis de la misma persona — `reiniciarCicloVacuna()` — y al cambiar de persona | lista de perfiles disponibles, vacunas, lotes, dosis, condiciones, esquemas, vacunas×perfil, insertRegistro, flags de loading (`estado_sesion.dart:35-58`) |

**Punto único de reinicio del ciclo persona**: `busquedabeneficiario_page.dart:41`
(`initState` de `BusquedaBeneficiario`). Ningún otro lugar llama
`reiniciarCicloBeneficiario()`.

**Punto único de reinicio del ciclo vacuna** (sin cambiar de persona):
`confirmaciondatos_page.dart:601`, botón «Sí, otra vacuna».

La «sesión de vacunación» (cargar la persona una vez, registrar varias vacunas)
está implementada como: ciclo persona + pregunta post-registro
«¿Aplicar otra vacuna a la misma persona?» (`confirmaciondatos_page.dart:610`).

---

## Flujo de carga completo

### 1. Entrada del beneficiario — dos vías

**Vía escaneo** (`_modoEscaneo`, `busquedabeneficiario_page.dart:205`):

1. `EscanerDni` lee el PDF417 y parsea localmente apellido, nombre, DNI, sexo,
   trámite y — según formato de tarjeta — edad y fecha de nacimiento
   (`escanerdni_widget.dart:544-559`).
2. Llama al back `obtenerDatosBeneficiario(codigodebarras, dni, sexo)`
   (`escanerdni_widget.dart:497-498`).
3. Fusiona nombre/apellido de la API con los del escaneo si la API viene corrupta
   (`escanerdni_widget.dart:487-493`).
4. `cargarBeneficiario(...)` guarda el beneficiario **más** edad y fecha nac. del
   PDF417 como fuentes propias (`escanerdni_widget.dart:507-511`,
   `usuariobeneficiario_service.dart:21-31`).
5. `validarNotificaciones` carga el historial de dosis aplicadas
   (`escanerdni_widget.dart:514-520`).
6. Control vuelve a `BusquedaBeneficiario` vía `onBeneficiarioCargado`
   (`escanerdni_widget.dart:523-527`): muestra resumen solo-lectura, bloque
   Situación y botón Continuar (`busquedabeneficiario_page.dart:223-247`).
7. «Continuar» guarda la situación en el service y navega a `VacunasPage`
   (`busquedabeneficiario_page.dart:315-325`).

**Vía manual** (`_modoManual`, `busquedabeneficiario_page.dart:328`):

1. Operador escribe DNI (≥7 dígitos) y elige sexo; sin default, elección
   obligatoria — «Verificar datos» no avanza sin sexo elegido
   (`formulario_documento_widget.dart:77`, `176-179`).
2. Bloque Situación visible; condición gestacional solo si sexo = F; al cambiar
   a sexo ≠ F la condición se anula (`formulario_documento_widget.dart:83-89`).
3. «Verificar datos» guarda la situación en el service **antes** de consultar el
   padrón (`formulario_documento_widget.dart:176-187`).
4. Diálogo de confirmación DNI+sexo (`busquedabeneficiario_page.dart:343-368`).
5. Back responde persona con `sysdesa10_edad` y `sysdesa10_fecha_nacimiento`;
   si `codigo_mensaje == '0'` frena con error (`busquedabeneficiario_page.dart:392`).
6. Carga notificaciones (`busquedabeneficiario_page.dart:378-390`) y navega a
   `VacunasPage` (`busquedabeneficiario_page.dart:447-454`).

### 2. Determinación de edad y tutor

Prioridad de fuente de edad (`vacunas_page.dart:2330-2344`):

1. Edad en años del PDF417 escaneado.
2. `sysdesa10_edad` de la API (parseo tolerante: `edad_beneficiario.dart:11-22`,
   ignora valores > 120).
3. Edad calculada desde `sysdesa10_fecha_nacimiento`
   (`edad_beneficiario.dart:26-56`).

Regla tutor: menor de 18 **o edad no parseable** → panel tutor obligatorio
(`vacunas_page.dart:2342`: sin dato de edad se exige tutor — conservador).
El tutor se valida contra el back (`escanerdni_widget.dart:459-484`). Un
beneficiario nuevo limpia el tutor anterior (`usuariobeneficiario_service.dart:27`).

### 3. Clasificador calendario 2026 (modo prueba)

`clasificarBeneficiarioActual()` (`calendario_2026.dart:160-184`) es función pura
derivada: fecha nac. (PDF417 > API) o edad en años (PDF417 > API), más situación.
Devuelve filas del calendario + flag `edadIndeterminada`. La matriz es
transcripción literal de `docs/calendario_nacional_vacunacion_2026.md`
(`calendario_2026.dart:196-286`). Se muestra en `VacunasPage` solo si hay
beneficiario (`vacunas_page.dart:186-189`).

Situación editable sin re-buscar: `_seccionSituacionEditable()` en
`VacunasPage`, debajo de `containerBeneficiario()`, reusa
`SituacionBeneficiario` contra `situacionBeneficiarioService` directamente
(no hay copia local intermedia). Cambiarla recalcula el calendario en el
siguiente build.

### 4. Registro — wizard de 8 pasos

`containerPasos()` (`vacunas_page.dart:246-292`):
1 Perfil · 2 Vacuna · 3 Condición · 4 Esquema · 5 Dosis · 6 Fecha · 7 Lote · 8 Verificar.

- Cascada dependiente: cambiar una selección anula todas las de aguas abajo
  (`vacunas_page.dart:1199`, `1247-1248`, `1286-1287`, `1820-1821`).
- El stepper solo permite navegar hacia atrás: guard `n <= pasoActual`
  (`vacunas_ui_helpers.dart:123`).
- «Cancelar registro» (`_mostrarDialogoCancelarRegistro`, `vacunas_page.dart`):
  tres destinos — «Volver» (cierra el diálogo), «Salir y buscar otra persona»
  (`BusquedaBeneficiario`, pierde la persona) y «Descartar esta vacuna»
  (`reiniciarCicloVacuna()` + `VacunasPage`, conserva beneficiario/tutor).
- **Perfil heredado dentro de la visita**: si ya hay perfil elegido en una
  vacuna anterior de la misma persona (`perfilesVacunacionService`, ciclo
  persona), `_heredarPerfilDeLaVisita()` lo reutiliza y arranca directo en
  paso 2 (`vacunas_page.dart`, `initState`). Para cambiarlo: volver a paso 1
  con el stepper y elegir otro perfil ahí.
- Fecha de aplicación: default hoy, `firstDate` del picker = fecha de
  nacimiento del beneficiario si es posterior a 2021, si no 2021
  (`vacunas_page.dart:2011-2024`, `_fechaNacimientoBeneficiario()`).
- Paso 8 valida completitud (`_validarDatosRegistro`, `vacunas_page.dart:2543-2551`)
  y arma `InsertRegistros` (`_construirRegistro`, `vacunas_page.dart:2555-2610`).
  La condición gestacional se descarta si `sysdesa10_sexo != 'F'`.
- **Advertencia de duplicado** (no bloquea): `_vacunaDosisYaAplicada()`
  compara vacuna+dosis por nombre contra el historial del back
  (`notificacionesDosisService.listaDosisAplicadas`) y contra lo ya
  registrado en la visita (`insertRegistroService.visitaRegistros`). Si
  coincide, diálogo «Vacuna ya registrada» con «Continuar igual» / «Volver»
  antes de ir a `ConfirmarDatos`.

### 5. Confirmación y envío

`ConfirmarDatos` (revisión final) → POST `insertRegistroProd`
(`confirmaciondatos_page.dart:565`). El resumen de vacuna/dosis/lote se
muestra siempre expandido (cambia en cada vacuna). Las tarjetas de
beneficiario y tutor arrancan expandidas solo en la 1ª vacuna de la visita
(`insertRegistroService.visitaRegistros` vacía); desde la 2ª arrancan
colapsadas — ya se revisaron antes — y un toque las expande
(`confirmaciondatos_page.dart`, `initState`).

Convención `codigo_mensaje` (verificada en llamadas, no en el PHP):
- Beneficiario: `'0'` = error/no encontrado (`busquedabeneficiario_page.dart:392`).
- Notificaciones: `'1'` = hay dosis (`busquedabeneficiario_page.dart:386`).
- Insert: `'0'` = error, reintentar (`confirmaciondatos_page.dart:568`).

Post-registro OK (`confirmaciondatos_page.dart:586-616`):
- Antes del diálogo, el registro se suma a
  `insertRegistroService.visitaRegistrosEstado` («vacunas de esta visita»,
  ciclo persona) sin importar qué botón se elija después.
- «Sí, otra vacuna» → `reiniciarCicloVacuna()` → `VacunasPage` (misma persona).
- «No, finalizar» → `BusquedaBeneficiario` → reinicio total del ciclo persona.

«Vacunas de esta visita»: tarjeta con las vacunas ya confirmadas en la visita
en curso, visible en `VacunasPage` (`_seccionVacunasVisita()`, debajo de
`containerBeneficiario()`) y en `ConfirmarDatos` (arriba del resumen de la
vacuna a confirmar). Oculta si la lista está vacía (primera vacuna de la
visita).

---

## Campos del registro enviados al back

`InsertRegistros.toJson()` (`insertregistros_models.dart:86-114`). Campos en
modo prueba / pendientes de confirmación del back:

| Campo | Valores | Estado back |
|-------|---------|-------------|
| `vacunacion_en_terreno` | `'1'` terreno / `'0'` fijo | Se envía; persistencia depende del PHP (`insertregistros_models.dart:63-64`) |
| `condicion_gestacional_beneficiario` | `'embarazada'` \| `'puerpera'` \| null | Nombre de campo sin confirmar (`insertregistros_models.dart:71`) |
| `es_personal_salud` | `'1'` / `'0'` | Nombre de campo sin confirmar (`insertregistros_models.dart:73`) |
| `vacunador_registrador` | `'1'` si `registrador.flxcore03_dni == vacunador.id_sysdesa12` | Contrato no verificado: compara DNI contra id (`vacunas_page.dart:2584-2588`) |

---

## Piezas en modo prueba

- Bloque Situación (condición gestacional + personal de salud):
  `situacion_beneficiario_widget.dart`, `situacionbeneficiario_service.dart`.
- Clasificador y matriz calendario 2026: `calendario_2026.dart`,
  test en `test/calendario_2026_test.dart`.
- Umbrales edad↔situación: sin definir; se definen cuando el back confirme campos.
- Modalidad en terreno: switch en «Equipo de trabajo»
  (`vacunador_page.dart:514-527`), default `false` (establecimiento fijo)
  (`sesion_equipo_vacunacion_service.dart:7-8`), reset solo en logout manual.

---

## Incoherencias conocidas

Detalle, impacto y orden de resolución: `docs/plan_mejora_sesion_vacunacion.md`.
Tachadas: ya resueltas (Fases 1-7 del plan).

1. ~~Historial de dosis en `estadosPorVacuna`: se borraba al elegir «otra
   vacuna, misma persona» aunque es dato de la persona.~~ Resuelto Fase 1
   (movido a `estadosPorPersona`) + Fase 2 (se refresca tras cada registro).
2. ~~Escáner no valida `codigo_mensaje == '0'` del beneficiario.~~ Resuelto
   Fase 3.1.
3. ~~Situación fijada con sexo declarado, sin revalidar contra sexo del
   back.~~ Resuelto Fase 3.2 (`_construirRegistro` descarta condición si
   `sysdesa10_sexo != 'F'`).
4. ~~Situación no editable después de la búsqueda.~~ Resuelto Fase 7.2
   (`_seccionSituacionEditable()` en `VacunasPage`, reusa
   `SituacionBeneficiario` contra `situacionBeneficiarioService`).
5. ~~Etiqueta de sexo con fallback «Femenino» ante sexo desconocido, con
   bloque condición oculto.~~ Resuelto Fase 7.5 (M/F/X muestran su etiqueta,
   cualquier otro valor muestra «Sin dato»).
6. ~~Perfil se re-consulta y re-selecciona en cada vacuna de la misma
   persona.~~ Resuelto Fase 4 (perfil en ciclo persona, heredado entre
   vacunas de la visita).
7. `enTerreno`: doble escritura (`vacunador_page.dart:68` y `:523`).
   Pendiente, Fase 8.1.
8. ~~Sin validación de duplicado vacuna+dosis dentro de la visita.~~ Resuelto
   Fase 6 (advertencia, no bloqueo). Fecha aplicación ≥ fecha nacimiento:
   resuelto Fase 3.3. Tutor ≠ beneficiario / tutor mayor de edad: pendiente,
   sin fase asignada.
