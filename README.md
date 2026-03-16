# Companion for Cacao

## Descripció
Companion for Cacao és una aplicació mòbil desenvolupada amb Flutter dissenyada per ajudar els jugadors del joc de taula Cacao i les seves expansions (Chocolatl i Diamante). L'objectiu és proporcionar eines digitals que millorin l'experiència de joc, facilitant la preparació de partides, la consulta de regles i el càlcul de puntuacions.

## Estat del Projecte
🚧 **En Desenvolupament** 🚧

### Característiques
- ✅ **Splash Screen:** Càrrega inicial de l'aplicació.
- ✅ **Menú Principal:** Accés ràpid a totes les funcionalitats.
- ✅ **Base de Dades de Rajoles:** Llistat complet amb detalls de cada rajola.
- ✅ **Configuració de Partida:** Stepper per triar jugadors, expansions i mòduls.
- ✅ **Manuals Integrats:** Visor de PDF per al manual del joc base.
- 🔄 **Assistència durant la Partida:** Consulta ràpida de regles (en procés).
- ⏳ **Calculadora de Puntuació Final:** Recompte automàtic (pendent).
- ⏳ **Historial de Partides:** Registre de sessions anteriors (pendent).

## Screenshots
*(Properament)*

## Tech Stack
- **Framework:** Flutter 3.41+ (SDK ^3.9.0)
- **Llenguatge:** Dart 3.11+
- **Gestió d'estat:** Riverpod 3.3+
- **Navegació:** GoRouter 17+
- **Base de dades local:** Drift 2.32+ (SQLite)
- **Linting:** flutter_lints 6.0+
- **Arquitectura:** Feature-first Clean Architecture (MVVM)

## Prerequisits
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)

## Instal·lació

### 1. Clonar el repositori
```bash
git clone https://github.com/isdabenx/companion_for_cacao.git
cd companion_for_cacao
```

### 2. Instal·lar dependències
```bash
flutter pub get
```

### 3. Generar codi de base de dades
```bash
dart run build_runner build
```

### 4. Executar l'aplicació
```bash
flutter run
```

## Configuració dels Git Hooks
Utilitzem Git Hooks per mantenir la qualitat del codi i automatitzar tasques abans de cada commit.

```bash
pub global activate git_hooks
git_hooks create git_hooks.dart
```

## Estructura del Projecte
L'aplicació segueix una estructura organitzada per funcionalitats (features):

```ascii
lib/
├── config/             # Configuració global (rutes, constants)
│   ├── constants/      # Actius i configuracions de rajoles
│   └── routes/         # Definició de rutes de navegació
├── core/               # Components transversals
│   ├── data/           # Models de dades i base de dades (Drift)
│   ├── providers/      # Providers de base de dades
│   └── theme/          # Estils, colors i tipografies
├── features/           # Funcionalitats de l'aplicació
│   ├── game_setup/     # Configuració de la partida
│   ├── home/           # Pantalla principal
│   ├── rule/           # Visor de regles
│   ├── splash/         # Pantalla de benvinguda
│   └── tile/           # Base de dades de rajoles
├── shared/             # Ginys i providers compartits
│   ├── providers/      # Notificadors compartits
│   └── widgets/        # Components de la interfície comuns
└── main.dart           # Punt d'entrada de l'aplicació
```

## Convencions de Noms
- **Classes i Enums:** `PascalCase` (ex: `TileModel`)
- **Mètodes i Variables:** `camelCase` (ex: `calculateScore`)
- **Arxius:** `snake_case` (ex: `app_routes.dart`)
- **Sufixos:** `*_model.dart`, `*_provider.dart`, `*_screen.dart`, `*_widget.dart`

## Documentació Detallada
Per a una descripció exhaustiva de les regles del joc, els mòduls de les expansions i la lògica de puntuació, consulta el fitxer [DESIGN.md](DESIGN.md).

## Llicència
Aquest projecte està llicenciat sota la Llicència Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International. Consulta l'arxiu `LICENSE` per a més detalls.
