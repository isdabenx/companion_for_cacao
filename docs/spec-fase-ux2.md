# Especificació — Fase UX-2: Preparació guiada

> Estat: **en curs** (2026-07-20) · Prerequisits: Fase UX-1 ✅ (model estructurat amb `actor`/`tableZone`/`groupId`) i i18n A/B/C ✅
> Relació amb el roadmap: DESIGN.md §13, entre UX-1 i la Fase 2

## 1. Objectiu i abast

Portar la preparació del "checklist ben presentat" (UX-1) a una experiència **guiada**: pas a pas per pàgines, amb un mapa esquemàtic de la taula que ensenya ON va cada cosa, i polir els dos punts d'entrada que queden aspres (Game Setup amb `Stepper` vertical, registre de la tirada de cabanes com a llista de 12 files).

**Dins de l'abast (UX-2):**
- PR-1 — Graella de cabanes amb gir de tile (editor de la tirada)
- PR-2 — Game Setup en una sola pàgina (absorbeix el "gestor d'expansions millorat" de la Fase 2)
- PR-3 — Mode guiat per pàgines sobre les unitats consolidades d'UX-1
- PR-4 — Mapa de taula esquemàtic (CustomPaint) integrat al mode guiat

**Fora de l'abast:**
- Art nou (tot amb assets existents + CustomPaint), narració per veu, diorama (UX-3 "El Nord")
- Persistir l'estat de la partida (segueix en memòria)

**Ordre triat**: dels blocs petits i autocontinguts als grans; PR-4 depèn de PR-3 (el mapa viu a les pàgines del mode guiat).

## 2. PR-1 — Graella de cabanes amb gir

**Problema**: `_HutLayoutEditorSheet` és una llista de 12 files amb 2 chips (cara A / cara B). Funciona però no s'assembla gens al gest físic (llançar 12 tiles i mirar quina cara ha quedat amunt), i amb 12×2 chips el full és llarg.

**Disseny**:
- El full passa a una **graella 3×4** (una cel·la per tile físic, mateix ordre que `HutTileSupply.tiles`), `responsive_grid_builder` o `GridView` fix.
- Cada cel·la mostra la **cara escollida** (imatge + nom + cost) o l'estat **pendent** (les dues mini-cares apilades amb un "?" — cap cara triada encara).
- **Tap = girar**: pendent → cara A → cara B → cara A… amb una animació de **flip 3D** (`AnimatedBuilder` + `Transform(rotateY)`, ~300 ms, `HapticFeedback.selectionClick`). El flip és la metàfora física del tile que es gira.
- Capçalera: comptador `n/12` existent + hint reescrit ("Toca cada cabana fins que coincideixi amb la teva tirada").
- Peu: botons existents (Aplica / Oblida la tirada) sense canvis de comportament; Aplica segueix requerint 12/12.
- `HutThrowRegisterRow` (targeta de preparació) no canvia.

**On**: tot dins `hut_layout_selector_widget.dart` (+ possible widget `_HutTileFlipCell`). Sense canvis de domini.

**l10n**: clau nova `hutRegisterHint` es reescriu; claus noves `hutTilePending` (etiqueta "?") si cal.

**Tests**: widget test del cicle pendent→A→B→A, del comptador i que Aplica només s'activa a 12/12.

## 3. PR-2 — Game Setup en una sola pàgina

**Problema**: el `Stepper` vertical de Material amaga contingut (els passos col·lapsats), afegeix connectors visuals que no aporten res (no hi ha ordre obligatori real) i el títol del pas 1 acumula badges. La selecció d'expansions és un carrusel horitzontal poc explorable i els mòduls apareixen com a llista plana sense dir de quina expansió venen.

**Disseny** (una sola pàgina scrollable, seccions sempre visibles):
1. **Jugadors** — capçalera de secció (títol + badge `n/4` + avís "en falten N") i `PlayersGridWidget` tal qual.
2. **Expansions** — capçalera + les targetes d'expansió en fila (les 2 caben; `Wrap` per a pantalles estretes). Es manté `SelectExpansionWidget`.
3. **Mòduls** — en lloc de la llista plana: **subseccions per expansió** (nom oficial de l'expansió com a subcapçalera petita + els seus mòduls a sota). Si no hi ha expansions amb mòduls, el mateix empty state actual. El toggle Big Game es manté al final de la secció.
4. **Botó Start/Resume + Clear** fixos a baix (sense canvis).

`GameSetupStepProvider` desapareix (només servia al Stepper). El bloqueig quan `isStarted` (IgnorePointer + opacitat) es manté idèntic.

**l10n**: cap clau nova imprescindible (les capçaleres ja existeixen); si cal subcapçalera "Mòduls de {expansion}" → clau nova amb placeholder.

**Tests**: actualitzar `game_setup_widget_test` (ja no hi ha `Stepper`), test que els mòduls es mostren agrupats per expansió.

## 4. PR-3 — Mode guiat per pàgines

**Problema**: la llista d'UX-1 és bona per revisar, però mentre prepares la taula amb les mans ocupades el que vols és "una cosa cada vegada".

**Disseny**:
- **Refactor previ**: extreure `_RenderUnit`/`_buildUnits` de `detailed_preparation_widget.dart` a `presentation/utils/preparation_render_units.dart` (públics: `PreparationRenderUnit`, `GroupUnit`, `StepUnit`, `buildRenderUnits`). La llista i el mode guiat comparteixen exactament les mateixes unitats → mateix ordre, mateixa lògica de completion.
- **Toggle de mode** a l'AppBar de `GameSetupPreparationScreen`: icona llista/pàgines (`Icons.view_agenda_outlined` ↔ `Icons.checklist`), persistit a `SettingsRepository` (`preparation_mode`, default **llista** per no sorprendre). La barra de progrés global es manté en tots dos modes.
- **Pager**: `PageView` amb **una pàgina per unitat de renderitzat**, agrupades per fase (la fase actual s'ensenya com a eyebrow a dalt de la pàgina: "Fase 2 de 4 — Preparació dels jugadors"). Amb 2-4 jugadors i mòduls típics surten 8-13 pàgines, com preveu el roadmap.
- **Contingut de pàgina**: reutilitza els widgets d'UX-1 tal qual (`PreparationGroupCard` / `ReturnToBoxCard` / `WorkerSelectorWidget` / `PreparationCard`), amb les files **inicialment expandides** (al mode guiat el detall és el protagonista) i scroll intern si no hi cap.
- **Navegació**: botons Enrere/Següent + swipe; indicador de progrés de pàgines (dots o `x/y`). En completar la unitat de la pàgina (check mestre o registre), **auto-avança** amb un petit delay (400 ms) i `mediumImpact` — es pot tornar enrere sempre.
- **Celebració**: la mateixa `PreparationCelebrationOverlay` quan tot està complet (ja escolta l'estat global, no cal tocar-la).
- Obrir el mode guiat **salta a la primera unitat incompleta**.

**l10n**: claus noves — toggle tooltips, "Pàgina x de y" / eyebrow de fase ("{phaseName} · {current}/{total}"), botons Enrere/Següent.

**Tests**: unit test de `buildRenderUnits` (extret; els casos ja existeixen implícitament), widget tests del pager (salt a primera incompleta, auto-avanç en completar, toggle persisteix el mode).

## 5. PR-4 — Mapa de taula esquemàtic

**Problema**: `tableZone` (ON va cada cosa) existeix al model des d'UX-1 però la UI no l'ensenya enlloc.

**Disseny**:
- Widget `TableMapWidget` (`presentation/widgets/table_map_widget.dart`): **CustomPaint** esquemàtic d'una taula vista des de dalt, sense assets nous:
  - centre: zona inicial (2 tiles creuats) + display de jungla (2 forats) + pila de jungla
  - vora inferior/lateral: provisions (cacau, or, aigua…)
  - cantonades: fins a 4 racons de jugador (només els actius, tenyits amb el color real del jugador)
  - la **caixa** es dibuixa fora de la taula (racó) per a `TableZone.box`
- El mapa **ressalta la zona** de la unitat actual (fill accentuat + pulsació subtil amb `AnimationController` respectant `MediaQuery.disableAnimations`); la resta queda en línia fina.
- S'integra **al capdamunt de cada pàgina del mode guiat** (alçada fixa ~140dp). A la llista NO s'afegeix (soroll); si una unitat agrupa zones diferents, es ressalten totes les dels seus passos.
- Etiquetes: cap text dins del canvas (evitem layout de text al painter); una **llegenda d'una línia** sota el mapa amb el nom de la zona ressaltada (claus l10n noves `zonePlayerArea`, `zoneJunglePile`, `zoneJungleDisplay`, `zoneSupplies`, `zoneStartingArea`, `zoneBox`).

**Tests**: golden no (dependent de plataforma); unit test del mapping unitat→zones ressaltades i smoke test que el painter pinta sense error per a totes les zones.

## 6. Riscos i decisions

- **Auto-avanç del pager**: risc de "se m'escapa la pàgina" si l'usuari desmarca just després; mitigació: només auto-avança quan la unitat passa d'incompleta a completa i l'usuari és a la seva pàgina, mai en regeneracions de pipeline.
- **`PageView` + files expandibles**: el swipe horitzontal no col·lisiona amb el scroll vertical intern, però sí amb el zoom per llarg-toc — cap conflicte real (gestos diferents).
- **Stepper fora**: `gameSetupStepProvider` s'elimina; `StartButtonWidget._onClearSetupPressed` deixa de resetejar-lo.
- **Mode per defecte**: llista. El mode guiat és descobrible pel toggle; si l'analítica informal (ús propi) diu el contrari, es canvia el default en un commit d'una línia.
- **Regeneració del pipeline** (`_rerunPipeline`): les unitats es reconstrueixen; el pager manté la posició per **índex de pàgina clampat**, no per referència — si canvia el nombre d'unitats (p. ex. actives un mòdul a mitges), es clampa i no peta.

## 7. Definició de fet (per PR)

`flutter analyze` net + suite completa en verd + verificació a l'emulador amb captura + commit gitmoji. El roadmap (DESIGN.md §13 i README) s'actualitza en tancar cada PR.
