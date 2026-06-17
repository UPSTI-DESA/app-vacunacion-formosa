# AGENTS.md

## Proyecto: Sistema de Vacunación Formosa (Flutter)

### Secretos requeridos
- `lib/src/config/appconst_config.dart` — contiene `host`, `scheme`, y URLs de API. Este archivo está en `.gitignore`. Sin él, la app no compila ni hace llamadas a la API.

### Comandos útiles
```bash
flutter analyze        # Linting (config en analysis_options.yaml)
flutter pub get        # Instalar dependencias
flutter run            # Ejecutar en debug
flutter build apk      # Build Android release
```

### API
- **Host:** `https://dh.formosa.gob.ar/modulos/webservice/php/`
- **Versiones de endpoints:** `version_3_0/` y `version_4_0/`
- **Convención respuesta:** `codigo_mensaje = ""` (éxito), `"0"` (error)
- Flow de pantallas documentado en `docs/flujos_pantallas_api.md`
- Contexto de endpoints PHP en `lib/src/docs/CONTEXT_ENDPOINTS.md`

### Arquitectura
- **Estado:** singletons con `_NombreService` + `final nombreService = _NombreService()` (ver `lib/src/services/services.dart`)
- **Rutas:** usan propiedad estática `nombreRuta` en cada Page (ver `lib/src/routes/get_routes.dart`)
- **Configuración de API:** `lib/src/config/appconst_config.dart` exportado vía `lib/src/config/config.dart`
- **Pantallas:** `lib/src/pages/pages.dart` exporta 6 páginas: LoginBody, VacunadorPage, BusquedaBeneficiario, VacunasPage, ConfirmarDatos, DrawerPage

### Linting
- `analysis_options.yaml` ignora intencionalmente: `strict_top_level_inference`, `use_super_parameters`, `library_private_types_in_public_api`, `use_build_context_synchronously`, `sort_child_properties_last`, `unnecessary_underscores`, `dangling_library_doc_comments`
- Proyecto legacy; no se cumplen todas las reglas de `flutter_lints` estrictas

### Dependencias delicadas
- `flutter_zxing: ^2.2.1` declara `camera < 0.12` — no subir `camera_android` por encima de lo que resuelva el árbol sin nueva versión de `flutter_zxing`
- `dependency_overrides: file: ^7.0.0`

### Flujo de navegación
```
LoginBody → VacunadorPage → BusquedaBeneficiario → VacunasPage (8 pasos) → ConfirmarDatos → BusquedaBeneficiario
```
