# AGENTS.md - Sistema de Vacunación Formosa

## Verify changes
```bash
flutter analyze lib/src/pages/vacuna/vacunas_page.dart lib/src/pages/vacuna/vacunas_ui_helpers.dart
```

## Architecture
- Flutter app (no monorepo)
- Entry: `lib/main.dart`
- Structure: `config/`, `models/`, `pages/`, `providers/`, `services/`, `utils/`, `widgets/`

## Required file
- `lib/src/config/appconst_config.dart` must exist for the app to function

## Theme system
- `lib/src/config/apptema_config.dart` contains `SisVacuTheme` with light/dark modes
- Colors defined in `SisVacuMarca` (verceleste, verde, azulFormosa, etc.)
- Use `cs.primaryContainer`, `cs.surface`, `cs.onSurface` from ColorScheme for theming
- Use `.withValues(alpha:)` for opacity instead of `.withOpacity()`

## UI components pattern
- `AppEspaciado` for spacing constants
- `AppBotones` for button styles
- `AppSuperficies.tarjeta()` for card decoration
- Custom theme extensions via `context.sisTipografia`

## Key pages
- `lib/src/pages/vacuna/vacunas_page.dart` - main vaccination flow
- `lib/src/pages/vacuna/vacunas_ui_helpers.dart` - VacunasPanelFlujo, VacunasFlujoStepper

## Styling conventions
- Border radius: `AppEspaciado.radioCampo` (20), `radioBoton` (14), `radioTarjeta`
- Elevation: 3-4 for cards, shadow with `.withValues(alpha: 0.12-0.18)`
- Use `BorderRadius.circular()` with spacing constants