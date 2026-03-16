# Document de Disseny: Companion for Cacao

Aquest document serveix com a referència definitiva i font única de veritat per al desenvolupament de l'aplicació Companion for Cacao.

## 1. Visió General
L'objectiu d'aquesta aplicació és actuar com a acompanyant i assistent per al joc de taula Cacao i les seves dues expansions oficials (Chocolatl i Diamante). Facilita la preparació de la partida, la consulta de regles i el càlcul de la puntuació final.

- **Objectiu:** Dispositius mòbils (Android primer, iOS planificat).
- **Stack Tecnològic:** Flutter 3+, Dart, Riverpod 3 per a la gestió d'estat, Drift (SQLite) com a base de dades local, i una arquitectura neta orientada a funcions (feature-first Clean Architecture).
- **Jugadors:** 2-4 jugadors.
- **Colors de jugador:** Blanc, vermell, lila i groc.

## 2. Joc Base — Cacao
El joc base estableix les mecàniques fonamentals.

- **Jugadors:** 2-4.
- **Durada:** 45 minuts.
- **Edat:** 8+.
- **Objectiu:** El jugador amb més or al final de la partida guanya.

### Recursos per jugador
- **Or:** Monedes de valors 1, 5 i 10.
- **Fruits de cacao:** Màxim 5 emmagatzemats al tauler de poblat.
- **Portador d'aigua:** Track circular amb valors de -10 a +16 (13 posicions).
- **Fitxes de sol:** Màxim 3 emmagatzemades al tauler de poblat.
- **Rajoles de treballador:** 11 rajoles per jugador amb la següent distribució:
  - 1-1-1-1 (4 rajoles)
  - 2-1-0-1 (5 rajoles)
  - 3-0-0-1 (1 rajola)
  - 3-1-0-0 (1 rajola)

### Rajoles de jungla del joc base
- **Plantació simple (x6):** 1 cacao per treballador activat.
- **Plantació doble (x2):** 2 cacao per treballador activat.
- **Mercat preu 2 (x2):** Ven 1 cacao per 2 or.
- **Mercat preu 3 (x4):** Ven 1 cacao per 3 or.
- **Mercat preu 4 (x1):** Ven 1 cacao per 4 or.
- **Mina d'or valor 1 (x2):** 1 or per treballador activat.
- **Mina d'or valor 2 (x2):** 2 or per treballador activat.
- **Aigua (x3):** Avança el portador d'aigua 1 posició per treballador activat.
- **Lloc d'adoració del sol (x2):** 1 fitxa de sol per treballador activat.
- **Temple (x5):** Puntuació al final de la partida.

### Sobreposició de rajoles
Quan la pila de jungla s'esgota, un jugador pot gastar 1 fitxa de sol per col·locar una rajola de treballador sobre una de pròpia ja existent al tauler. Cada rajola només es pot sobreposar una vegada.

### Puntuació final detallada
- **Or acumulat:** Tot l'or obtingut durant la partida.
- **Temples:** Per cada temple, el jugador amb més treballadors adjacents rep 6 or, i el segon en rep 3.
  - Empat al 1r lloc: Es divideixen els 6 or (arrodonint a la baixa) entre els empatats. No s'atorga premi de 2n lloc.
  - Empat al 2n lloc: Es divideixen els 3 or entre els empatats.
  - Requisit: Cal tenir com a mínim 1 treballador adjacent per puntuar. En cas de rajoles sobreposades, només compta la rajola superior.
- **Track d'aigua:** Se suma o resta el valor de la posició final del portador.
- **Fitxes de sol:** 1 or per cada fitxa no utilitzada.
- **Cacao sobrant:** 0 punts.

### Variacions segons el nombre de jugadors
- **3 jugadors:** Cada jugador descarta una rajola 1-1-1-1 abans de començar.
- **4 jugadors:** Cada jugador descarta una rajola 1-1-1-1 i una rajola 2-1-0-1.

## 3. Expansió 1 — Chocolatl
Inclou 4 mòduls independents que es poden combinar lliurement.

### Mòdul A - El Mapa
- Cada jugador rep 2 fitxes de mapa.
- Permeten triar rajoles d'un tauler de mapa específic en lloc de la pila de jungla.
- Les fitxes de mapa no utilitzades valen 0 or al final.

### Mòdul B - La Irrigació
- Substitueix 3 rajoles de plantació per rajoles d'irrigació.
- Acció: Moure el portador d'aigua 1 casella enrere per obtenir 4 fruits de cacao per cada espai retrocedit.
- No es pot utilitzar si el portador ja està a la posició -10.

### Mòdul C - El Xocolata
- Nou recurs: Rajoles de xocolata (20 en total).
- **Cuina de xocolata:** Converteix 1 cacao en 1 xocolata per cada treballador activat.
- **Mercat de xocolata:** Permet vendre 1 cacao per 3 or O 1 xocolata per 7 or per cada treballador activat.
- La xocolata sobrant val 0 or al final.

### Mòdul D - Les Cabanes
Es compren durant la partida pagant el seu cost en or. Màxim una cabana de cada tipus per jugador.

| Cabana | Cost | Tipus | Efecte |
|---|---|---|---|
| Pregoner del Mercat | 4 | Durant partida | Els mercats de preu 2 venen a preu 3 |
| Ermita | 6 | Final de partida | 1 or per cada vora de treballador no activada |
| Treballador de Carreteres | 6 | Final de partida | 1 or per cada rajola a la fila o columna pròpia més llarga |
| Comerciant | 6 | Final de partida | 1 or per cada cacao emmagatzemat |
| Granger | 8 | Durant partida | +1 fruit quan se n'obtenen exactament 4 |
| Xaman | 8 | Durant partida | Sobreposició de rajoles sense gastar fitxa de sol |
| Monjo | 10 | Final de partida | 1 or per cada temple on es té mínim 1 treballador adjacent |
| Mestre Constructor | 10 | Final de partida | 1 or per cada altra cabana en propietat |
| Capatàs | 12 | Durant partida | Les vores de 3 treballadors compten com a 4 |
| Mestre de la Font | 12 | Final de partida | 4 or si el portador d'aigua està a la posició 16 |
| Filla del Cap | 14 | Bonus fix | +4 or |
| Fill del Cap | 16 | Bonus fix | +4 or |
| Dona del Cap | 20 | Bonus fix | +5 or |
| Cap | 24 | Bonus fix | +6 or |

## 4. Expansió 2 — Diamante
Inclou 4 mòduls independents combinables amb tota la resta.

### Mòdul A - Les Mines de Gemmes
- Substitueix els 5 temples per 5 mines de gemmes (4 mines en partides de 2 jugadors).
- Nous recursos: Gemmes de 4 colors (vermell, verd, blau, blanc; 8 de cada color, 32 en total) i màscares (valors: 8, 9, 10, 10, 12; la de 12 es descarta en partides de 2).
- Acció: Prendre 1 gemma del color triat per cada treballador activat.
- Intercanvi obligatori: Quan es té com a mínim una gemma de cada color, s'han de canviar per la màscara de valor més baix disponible. Les gemmes utilitzades surten del joc.
- Final de partida: Cada màscara suma el seu valor. Cada gemma sobrant val 1 or.

### Mòdul B - L'Arbre de la Vida
- Substitueix 3 mines d'or (2 mines en partides de 2 jugadors).
- Atorga 1 or per cada treballador adjacent.
- Si una vora té 0 treballadors, atorga 3 or (recompensa per no tenir treballadors).

### Mòdul C - El Favor de l'Emperador
- S'afegeix la figura de l'Emperador al mercat inicial.
- Quan es col·loca una rajola a la mateixa fila o columna que l'Emperador, aquest es mou a la teva rajola i reps 1 or.
- Si l'Emperador està a la teva rajola a l'inici del teu torn, reps 1 or.

### Mòdul D - Nous Treballadors
- 16 rajoles noves (4 per color) amb distribucions inèdites, incloent la 0-0-0-4.
- No afecten la puntuació directament, però canvien les opcions estratègiques.

**Variant "Gran Partida":** Es juguen tots els mòduls d'ambdues expansions simultàniament.

## 5. Taules de Puntuació Completes

### Track d'Aigua
| Posició | Valor |
|---|---|
| 1 (Inici) | -10 |
| 2 | -7 |
| 3 | -5 |
| 4 | -3 |
| 5 | -1 |
| 6 | 0 |
| 7 | 1 |
| 8 | 3 |
| 9 | 5 |
| 10 | 7 |
| 11 | 10 |
| 12 | 13 |
| 13 | 16 |

### Temples
- 1r lloc: 6 or.
- 2n lloc: 3 or.
- Empat 1r: (6 / nombre de jugadors) arrodonit a la baixa. No hi ha 2n.
- Empat 2n: (3 / nombre de jugadors) arrodonit a la baixa.

### Resum de Puntuació per Font
| Font | Valor | Moment |
|---|---|---|
| Mines d'or | 1-2 per treballador | Durant |
| Mercats | 2-4 per fruit | Durant |
| Mercat de xocolata | 3 (fruit) o 7 (xocolata) | Durant |
| Arbre de la Vida | 1 o 3 per treballador | Durant |
| Favor de l'Emperador | 1 per activació | Durant |
| Temples | 0/3/6 per temple | Final |
| Track d'aigua | -10 a +16 | Final |
| Fitxes de sol | 1 cadascuna | Final |
| Gemmes sobrants | 1 cadascuna | Final |
| Màscares | 8/9/10/12 | Final |
| Cabanes (bonus) | Variable | Final |
| Cacao sobrant | 0 (excepte Comerciant) | Final |
| Xocolata sobrant | 0 | Final |

## 6. Anàlisi de Cobertura: Joc vs Aplicació

Aquesta secció documenta el que li FALTA a l'aplicació en comparació amb les regles reals del joc.

### Fitxes d'Expansions absents al JSON
- tiles.json només conté fitxes del joc base (26 fitxes). Falten:
  - Chocolatl: 3 fitxes irrigació, 3 cuines xocolata, 3 mercats xocolata (9 fitxes)
  - Diamante: 5 mines de gemmes, 3 arbres de la vida (8 fitxes)
  - Diamante Nous Treballadors: 16 fitxes noves (4 per color), incloent 0-0-0-4
  - Total faltant: ~33 fitxes

### TileType enum incomplet
Tipus actuals: player, market, plantation, goldMine, water, temple, sunWorshipingSite
Tipus que falten per les expansions:
- irrigation (Irrigació - Chocolatl)
- chocolateKitchen (Cuina de xocolata - Chocolatl)
- chocolateMarket (Mercat de xocolata - Chocolatl)
- gemMine (Mina de gemmes - Diamante)
- treeOfLife (Arbre de la vida - Diamante)

### Lògica de substitució de fitxes per mòdul
El setup actual NO gestiona la substitució de fitxes quan s'activa un mòdul:
- Irrigació: substitueix 1 plantació simple + 2 dobles (4J), o 2 dobles (2J)
- Xocolata: substitueix 3 mines d'or + 3 mercats preu 3 (4J), o 1 mina valor 2 + 1 mina valor 1 + 2 mercats preu 3 (2J)
- Mines Gemmes: substitueix 5 temples (4J) o 4 temples (2J)
- Arbre Vida: substitueix 3 mines d'or (4J) o 2 mines d'or (2J)
- Combinació Xocolata + Arbre Vida: regles especials — NO treure mines d'or del mòdul xocolata

### Eliminació de fitxes selva per 2 jugadors
El codi elimina fitxes treballador per 3J/4J, però NO gestiona l'eliminació de fitxes selva per 2J:
- -2 plantacions simples
- -1 mercat preu 3
- -1 mina d'or valor 1
- -1 aigua
- -1 lloc d'adoració sol
- -1 temple

### Fitxa inicial diferent amb Irrigació
Amb irrigació activa, la fitxa inicial canvia: es posa 1 fitxa d'aigua en lloc del mercat preu 2.

### Mòdul Mapa — mecànica no contemplada
- 2 tokens per jugador, tauler de mapa amb 4 fitxes (en lloc de 2)
- La preparació hauria d'incloure: "Cada jugador rep 2 tokens de mapa"

### Mòdul Cabanes — model de dades absent
Les 14 cabanes no tenen model de dades (ni JSON ni Drift). Caldria un HutModel o similar amb: nom, cost, efecte, tipus (durant partida / final / bonus fix).

### Mòdul Xocolata — recurs no modelat
- Recurs xocolata comparteix espais d'emmagatzematge amb cacau
- Cuina: 1 cacau → 1 xocolata per treballador
- Mercat: cacau = 3 or, xocolata = 7 or

### Mòdul Mines de Gemmes — mecànica no modelada
- 32 gemmes (4 colors x 8), 7 màscares (valors 8, 9, 10, 10, 12)
- Ajust 2J: treure màscara valor 12 + 8 gemmes
- Intercanvi: 4 gemmes (1 cada color) → màscara més baixa disponible

### Mòdul Emperador — preparació absent
- Figura emperador sobre mercat preu 2 (o irrigació si activa)
- +1 or al moure, +1 or a l'inici del torn si està a la teva rajola

### Mòdul Nous Treballadors — fitxes noves absents
- 16 noves (4 per color) amb distribucions inèdites (incloent 0-0-0-4)
- Dues opcions: reemplaçar o afegir a les existents
- Regles d'equilibri: treballadors han de superar selva per 1-16 segons nombre jugadors

### Variant "Gran Partida" no contemplada
- Combinar TOT: base + Chocolatl + Diamante
- 4J: 60 treballadors + 45 selva
- 3J: eliminacions específiques de fitxes selva

### Mini-expansions no contemplades
- Noves Cabanes (Calendari Advent 2016): 3 cabanes addicionals
- Nous Espais d'Emmagatzematge: 2 cabanes de 6 or amb +3 espais

| Prioritat | Element | Impacte |
|---|---|---|
| Alta | Fitxes expansions al JSON | Catàleg incomplet sense elles |
| Alta | TileType enum ampliat | Necessari per classificar fitxes d'expansions |
| Alta | Substitució de fitxes per mòdul al setup | Setup no reflecteix regles reals |
| Alta | Eliminació fitxes selva per 2J | Setup incorrecte per partides de 2 |
| Mitjana | Model de cabanes | Necessari per calculadora de puntuació |
| Mitjana | Gemmes i màscares | Necessari per calculadora de puntuació |
| Mitjana | Fitxa inicial dinàmica (irrigació) | Preparació incorrecta amb irrigació |
| Mitjana | Nous treballadors al JSON | Catàleg incomplet |
| Baixa | Mòdul Mapa (tokens) | Preparació incompleta |
| Baixa | Emperador (preparació) | Preparació incompleta |
| Baixa | Mini-expansions | Contingut extra opcional |
| Baixa | Variant Gran Partida | Mode avançat |

## 7. Features de l'Aplicació

### Completades
- **Splash:** Pantalla de càrrega inicial.
- **Home:** Menú principal de navegació.
- **Base de dades de rajoles:** Llistat amb graella, detall amb imatge i descripció en Markdown, i configuració de visualització.
- **Configuració de partida:** Stepper de 3 passos (jugadors, expansions, mòduls) i generació de la preparació pas a pas.
- **Regles:** Visor de PDF integrat per al manual del joc base.

### Fase 1 — Funcionalitats Core (Prioritat alta)
1. **Calculadora de puntuació final:** Formulari pas a pas amb suport per expansions (temples/gemmes, cabanes, track d'aigua). Gestió automàtica d'empats i desempats.
2. **Filtre i cerca de rajoles:** Filtrar per tipus, color, expansió i mòdul. Cerca per nom.
3. **Selector de primer jugador:** Aleatori temàtic ("qui ha menjat xocolata més recentment?"), rotació basada en historial, o manual.
4. **Rajoles d'expansions completes:** Afegir totes les fitxes de Chocolatl i Diamante al JSON i ampliar TileType.

### Fase 2 — Diferenciació (Prioritat mitjana)
5. **Historial de partides:** Registre de cada sessió amb jugadors, puntuacions, guanyador, durada, expansions utilitzades i notes opcionals.
6. **Perfils de jugador:** Estadístiques personals — partides jugades, percentatge de victòries, millor ratxa, posició mitjana, rendiment per expansió.
7. **Comptador de probabilitats de rajoles:** Mostra rajoles restants a la pila de selva. Probabilitat de treure cada tipus. Essencial per a joc competitiu.
8. **Foto de partida:** Captura foto del taulell finalitzat, emmagatzemada a l'historial. Galeria visual de partides.
9. **Gestor d'expansions millorat:** Lògica completa de substitució de fitxes per mòdul, ajustos per 2J, i fitxes inicials dinàmiques.

### Fase 3 — Engagement (Prioritat baixa)
10. **Sistema d'assoliments:** Desbloquejables temàtics — "Baró del Xocolata" (50+ cacau en una partida), "Mestre del Temple" (guanyar per temples), "Supervivent de la Sequera" (guanyar amb aigua mínima), etc.
11. **Grups de joc:** Crear grups ("Divendres de jocs", "Família"). Estadístiques, taules de classificació i rivalitats per grup.
12. **Anàlisi post-partida:** Insights automàtics — "Has aconseguit el 40% de l'or als temples (per sobre de la mitjana)", "El guanyador va controlar les fonts d'aigua aviat".
13. **Temporitzador de torns:** Compte enrere no intrusiu amb avís suau (visual, so o vibració). Temps configurable. Mostra mitjana per jugador.

### Fase 4 — Qualitat i Accessibilitat
14. **Mode daltònic:** Patrons sobre colors (ratlles, punts), símbols per jugador (triangle, cercle, quadrat, estrella), paleta de colors segura.
15. **Internacionalització (i18n):** Suport multiidioma (català, castellà, anglès com a mínim).
16. **Configuració general:** Preferències de l'app (tema, idioma, sons, notificacions).

## 8. Arquitectura Tècnica
L'aplicació segueix els principis de Clean Architecture amb una organització per funcionalitats (feature-first).

- **Stack:** Flutter 3+ (SDK ^3.9.0), Dart, Riverpod 3.3+, Drift 2.32+ (SQLite).
- **Patrons:** MVVM, Repository Pattern, UDF (Unidirectional Data Flow).

### Estructura de directoris real
```
lib/
  config/
    constants/ (assets.dart, tile_settings.dart)
    routes/ (app_routes.dart)
  core/
    data/
      models/ (boardgame_model, module_model, tile_model)
    providers/ (database_provider)
    theme/ (app_colors, app_fonts, app_text_styles, app_markdown_style_sheet)
  features/
    splash/ (presentation, data, domain)
    home/ (presentation)
    tile/ (presentation, domain)
    game_setup/ (presentation, domain)
    rule/ (presentation)
  shared/
    widgets/ (menu, main_menu, header, custom_scaffold, container_full_style)
    providers/ (boardgame_notifier)
  main.dart
```

- **Navegació:** GoRouter amb rutes declaratives i tipades.
- **Menú lateral:** Implementat amb `AdvancedDrawer`.
- **Dades inicials:** Fitxers JSON a `assets/initial_data/` (boardgames, modules, tiles).

## 9. Pantalles i Navegació
Rutes definides a `app_routes.dart`:

- `/`: `SplashScreen`
- `/home`: `HomeScreen`
- `/tile`: `TileListScreen`
- `/tile_detail`: `TileDetailScreen` (rep `TileModel`)
- `/game_setup`: `GameSetupScreen`
- `/game_setup_detail`: `GameSetupDetailScreen` (rep `GameSetupStateEntity`)
- `/rule`: `RuleScreen`

**Planificades:** `/score_calculator`, `/settings`, `/game_history`.

## 10. Models de Dades

### Existents
- `BoardgameModel`: Representa el joc base o una expansió.
- `ModuleModel`: Defineix els mòduls de cada expansió.
- `TileModel`: Detalls de cada rajola (inclou enums `TileType` i `TileColor`).
- `PlayerEntity`: Dades del jugador (nom, color).
- `GameSetupStateEntity`: Estat de la configuració de la partida.
- `PreparationEntity`: Logica de preparació de rajoles.
- `TileSettingsEntity`: Preferències de visualització de rajoles.

### Proposats
- `ScoreEntryEntity`: Puntuació per jugador i categoria.
- `GameSessionEntity`: Dades completes d'una partida finalitzada.
- `SettingsEntity`: Preferències globals de l'usuari.

## 11. Configuració de Partida
El flux del stepper consta de 3 passos:
1. **Jugadors:** Selecció del nombre i colors.
2. **Expansions:** Selecció de quines expansions s'inclouen.
3. **Mòduls:** Selecció de mòduls específics segons les expansions triades.

**Lògica de preparació:** Gestionada per `game_setup_notifier`. Inclou l'assignació de taulers, portadors d'aigua, rajoles per color i l'eliminació de rajoles segons el nombre de jugadors (2, 3 o 4).

## 12. Calculadora de Puntuació Final
Algoritme de càlcul pas a pas:
1. **Or acumulat:** Introducció manual de l'or obtingut.
2. **Track d'aigua:** Selecció de la posició final i consulta del valor a la taula.
3. **Temples:** (Si el mòdul de gemmes no està actiu) Introducció de treballadors per jugador i càlcul de 1r/2n lloc amb regles d'empat.
4. **Fitxes de sol:** 1 or per cada fitxa no utilitzada.
5. **Cabanes:** (Si el mòdul està actiu) Càlcul dels bonus de final de partida.
6. **Mines de gemmes:** (Si el mòdul està actiu) Suma del valor de les màscares i 1 or per gemma sobrant.
7. **Resultat:** Determinació del guanyador. En cas d'empat, guanya qui estigui més avançat al track d'aigua.

## 13. Planificació i Prioritats (Roadmap)

- **Fase 1:** Calculadora de puntuació, filtre de rajoles, selector primer jugador, rajoles expansions
- **Fase 2:** Historial de partides, perfils de jugador, comptador probabilitats, foto partida, gestor expansions millorat
- **Fase 3:** Assoliments, grups de joc, anàlisi post-partida, temporitzador
- **Fase 4:** Mode daltònic, i18n, configuració general
- **Futur:** Sincronització amb BGG, estadístiques avançades, mini-expansions
