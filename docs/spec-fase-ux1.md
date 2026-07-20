# Especificació — Fase UX-1: Redisseny de la preparació

> Estat: **aprovada per començar** · Referència visual: maqueta "Propostes UX — Preparació del joc" (artifact v3)
> Relació amb el roadmap: primer ítem després de la Fase 1 (vegeu DESIGN.md §13)

## 1. Objectiu i abast

Transformar la pantalla de preparació de "llista de frases de reglament" a "llista consolidada, visual i amb sensació de progrés", construint alhora el model de dades que necessitaran la Fase UX-2 (mode guiat, mapa de taula) i la i18n.

**Dins de l'abast (UX-1):**
- Model de preparació estructurat (qui / què / com / per què / on) — PR-1
- Paquet A: targetes consolidades per jugador, files expandibles, imatge protagonista, targeta de New Workers unificada — PR-2
- Paquet B: progrés global, feedback hàptic i animat, celebració final — PR-3

**Fora de l'abast (queda per a UX-2 o després):**
- Mode guiat per pàgines, mapa de taula, redisseny del Game Setup, graella de cabanes amb gir
- i18n (però tot el copy nou queda centralitzat per fer-la barata)
- Art nou: es treballa només amb els assets existents (`assets/images/preparation/`, tiles)

**Fet verificat que simplifica:** l'estat de preparació NO es persisteix (només els presets personalitzats serialitzen JSON). No hi ha migracions de BD ni de serialització.

## 2. Model de domini (PR-1)

### 2.1 `PreparationEntity` v2

Fitxer: `lib/features/game_setup/domain/entities/preparation_entity.dart`

| Camp | Tipus | Nou? | Contingut |
|---|---|---|---|
| `id` | String | = | Identificador estable (mecanisme de completion per id intacte) |
| `phase` | PreparationPhase | = | Sense canvis |
| `actor` | **PreparationActor** | ✚ | Qui fa el pas: `player(color)` \| `allPlayers` \| `table` |
| `label` | String | ✚ | QUÈ — imperatiu d'una línia ("Take the red village board") |
| `detail` | String | ✚ (rename) | COM — el text complet actual de `description` |
| `rationale` | String? | ✚ | PER QUÈ — opcional ("With 2 players some jungle tiles are removed to keep the map tight") |
| `tableZone` | **TableZone** | ✚ | ON va el resultat: `playerArea` \| `junglePile` \| `jungleDisplay` \| `supplies` \| `startingArea` \| `box` |
| `groupId` | String? | ✚ | Agrupa passos en una targeta (`group_player_red`, `group_return_to_box`) |
| `quantity` | int? | ✚ | Per a passos de tiles ("Sort out **2x**...") — alimenta el badge ×N |
| `imageKey` | String? | = | Sense canvis |
| `color` | String? | = | Es manté per compatibilitat de tint; deriva d'`actor` quan és `player` |
| `isCompleted` | bool | = | Sense canvis |
| `variables` | Map? | = | Sense canvis |

`description` desapareix (rename a `detail`); no cal deprecació transitòria perquè tots els consumidors són interns i es toquen al mateix PR.

Enums nous: `lib/features/game_setup/domain/entities/preparation_actor.dart` i `table_zone.dart`.

### 2.2 Agrupació

- La llista es manté **plana** (no hi ha entitat "grup"): `groupId` marca la pertinença i la UI agrupa. Això preserva intacte el mecanisme de regeneració + completion per id de `DetailedPreparationWidget`/`GameSetupNotifier.togglePreparationCompletion` ([game_setup_notifier.dart:303](../lib/features/game_setup/presentation/providers/game_setup_notifier.dart)).
- La completesa d'un grup és **derivada** (tots els membres complets); marcar el check mestre = marcar tots els membres (mètode nou `toggleGroupCompletion(String groupId)` al notifier).
- **Fusió de passos**: "takes the water carrier" + "puts it on the −10 field" es fusionen en un únic pas per jugador (id nou `setup_water_carrier_<color>`, absorbeix `setup_water_field_<color>`). Resultat per jugador: 3 passos (tauler, aiguador→casella, tiles pròpies) + retirades de workers a 3p/4p dins del mateix grup.

### 2.3 Catàleg de copy

Fitxer nou: `lib/features/game_setup/domain/content/preparation_copy.dart`

- **Tots** els literals (label/detail/rationale) viuen aquí, com a funcions amb paràmetres (`playerBoardLabel(String playerName)`, etc.). Els handlers no contenen cap string de cara a l'usuari.
- Idioma: **anglès** (coherent amb la resta de l'app) fins a la fase i18n; aleshores aquest fitxer és l'únic que es converteix a ARB/gen-l10n.
- El **nom del jugador** usa `PlayerEntity.displayName` (nom escrit, o color capitalitzat si no n'hi ha — getter ja existent), a la capçalera del grup; el label del pas queda impersonal ("Take the village board"). Els handlers ja reben `players`.

## 3. Canvis al domini per fitxer (PR-1)

| Fitxer | Canvi |
|---|---|
| `base_game_handler.dart` | Emet grups de jugador (actor `player`, zone `playerArea`, groupId `group_player_<color>`); fusió aiguador+casella; retirades 2p/BigGame-3p amb groupId `group_return_to_box` + `quantity`; shuffle workers → actor `allPlayers`; tiles inicials → `startingArea`; pila/display → `junglePile`/`jungleDisplay`; provisions → `supplies` |
| `handlers/*.dart` (map, watering, chocolate, huts, gem_mines, tree_of_life, emperor_favor) | Cada pas rep actor/zone/label/detail (+rationale on aporti); la lògica de tiles NO es toca |
| `new_workers_module_handler.dart` | `selectionStepId` conserva id i posició; label "Choose the worker tiles" |
| `module_preparation_handler.dart`, `preparation_pipeline.dart`, `prepare_game_use_case.dart` | Sense canvis de signatura |

## 4. Presentació — Paquet A (PR-2)

Widgets **nous** (`presentation/widgets/`):

- `preparation_group_card.dart` — targeta per `groupId`: capçalera amb avatar/inicial + nom + tint del color del jugador (fons suau + vora; contrast AA; el color mai és l'únic senyal — hi ha nom i inicial), check mestre a la dreta; fills renderitzats com a files.
- `preparation_step_row.dart` — fila expandible: icona/imatge petita + `label` + chevron + check individual. Expandida: imatge gran (reutilitza el `Hero` + dialog de zoom existents) + `detail` + `rationale` en to secundari. **Regla de zones tàctils**: tocar imatge = zoom; tocar check = completar; tocar la resta de la fila = expandir/plegar.
- `return_to_box_card.dart` — targeta del grup `group_return_to_box`: graella d'imatges de tile amb badge ×`quantity`; cada tile és marcable individualment (és un pas); check mestre a la capçalera.

Widgets **modificats**:

- `detailed_preparation_widget.dart` — agrupa per `groupId` dins de cada fase; passos sense grup segueixen com a `PreparationCard` (ara visual-first: thumb 68 px quadrat arrodonit + icona de lupa visible; el long-press es manté com a drecera). Es conserven: acordió per fase, auto-advance, scroll-to-top, `phaseExpansionProvider`.
- `worker_selector_widget.dart` — només la targeta d'entrada: mateixa anatomia que `PreparationCard` (thumb + label "Choose the worker tiles" + check derivat) amb el resum de la tria i el botó d'edició en **footer verd**, replicant el patró existent de `HutThrowRegisterRow`. El sheet d'edició NO es toca.
- Tipografia: la font Burrito queda només per a títols; comptadors i números passen a la font de text amb `FontFeature.tabularFigures()`.

**Primera partida vs. expertes:** les files neixen **expandides** si el grup té algun pas no completat i és la primera vegada que es mostra la preparació en aquest dispositiu; després, plegades. Nota d'implementació: `SettingsRepository` avui només cobreix tile settings — s'hi afegeixen dos mètodes (`hasSeenPreparation()` / `markPreparationSeen()`) implementats sobre el `SharedPreferences` que la impl ja utilitza. (La verbositat adaptativa completa per comptador de partides queda per quan hi hagi historial — Fase 2.)

## 5. Presentació — Paquet B (PR-3)

- **Progrés global**: barra fina sota l'AppBar de la pantalla de preparació (passos completats / totals, ja derivables del `completionMap` existent que inclou els passos interactius).
- **Check amb resposta**: animació de "pop" (~250 ms, `ScaleTransition` — sense dependències noves) + `HapticFeedback.lightImpact()`; en completar una fase sencera, `mediumImpact()`.
- **Celebració final**: overlay quan tot està complet — confeti (paquet `confetti`), missatge, i **anunci del jugador inicial segons l'ordre ja definit al Game Setup** (posició 1 de `colorOrder`, el mecanisme canònic de primer jugador de l'app — la celebració no el sobreescriu). Per als grups que no han decidit ordre, una acció secundària explícita "Draw randomly instead" crida `drawRandomFirstPlayer()` (mètode nou del notifier que rota un color seleccionat a l'atzar a la posició 1). Botó principal → torna al dashboard de partida.
- Decisió d'acordió vs. chips de fase: **es manté l'acordió** (funciona i té lògica fina ja provada); els chips de navegació queden per a UX-2 si el mode guiat no els fa innecessaris.

Dependència nova única: `confetti` (el "pop" i les expansions es fan amb animacions implícites del SDK).

## 6. Pla de PRs

| PR | Contingut | Visible per a l'usuari? |
|---|---|---|
| **PR-1** | Entitat v2 + enums + catàleg de copy + handlers + tests de domini | No (la UI llegeix `detail` on llegia `description`) |
| **PR-2** | Paquet A: widgets nous + agrupació + New Workers unificada + tests de widget | Sí — el redisseny de la llista |
| **PR-3** | Paquet B: progrés + hàptics + celebració + sorteig | Sí |

Cada PR deixa l'app funcional i amb `dart_pre_commit` verd.

## 7. Tests

- **Unit (domini)**: actualitzar `base_game_handler_test.dart`, els 8 tests de handlers i `preparation_pipeline_*` per validar actor/zone/groupId/label/quantity als escenaris 2p/3p/4p, amb mòduls actius i Big Game. Cas nou explícit: la fusió aiguador+casella (id `setup_water_carrier_<color>` existeix, `setup_water_field_<color>` no).
- **Widget**: group card (expandir fila, check individual vs. mestre, tint per jugador), return-to-box (graella + quantitats), worker card unificada (completion derivada sobreviu a la regeneració — cas ja cobert avui, no regressar), celebració (apareix només amb tot complet).
- **Manual**: afegir secció UX-1 a `test/manual_test_checklist.md` (expandir/plegar, hàptics en dispositiu real, sorteig).

## 8. Riscos i decisions preses

- **Ids que canvien** (fusió aiguador): una preparació a mig marcar es perdria en actualitzar — acceptable perquè l'estat és en memòria.
- **Copy en anglès** fins a la i18n (que el roadmap situa just després d'UX-1).
- **Acordió es manté** a UX-1; revisitar a UX-2.
- **El check mestre de grup marca tots els fills**: decisió deliberada (grups experts); el detall fila a fila continua disponible.
- `color` es manté a l'entitat tot i ser derivable d'`actor`, per no tocar `AppColors.findColorByName` a tots els consumidors en aquest pas.
