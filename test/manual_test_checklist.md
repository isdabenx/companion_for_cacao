# Game Setup — Manual Test Checklist

Use this checklist to verify all game setup combinations in the app.
For each test, configure the app with the specified players and modules, then verify each checkpoint.

---

## 🔵 GRUP 1: Joc Base (sense mòduls)

### Test 1 — Base, 2 jugadors

- **Config**: 2 jugadors, cap mòdul
- **Player Setup**:
  - [x] Cada jugador: village board, water carrier, water carrier a "-10", worker tiles
  - [x] NO apareix cap pas de "remove worker tile"
  - [x] Pas de shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "market, selling price 2"
  - [x] 6 passos individuals de "sort out jungle tiles":
    - [x] 2x Single Plantation
    - [x] 1x Market, selling price 3
    - [x] 1x Gold Mine, value 1
    - [x] 1x Water
    - [x] 1x Sun-Worshiping Site
    - [x] 1x Temple
  - [x] Cada pas mostra la imatge de la rajola corresponent
  - [x] Els passos de sort out apareixen ABANS de "mix remaining jungle tiles"
  - [x] Jungle draw pile + jungle display (2 tiles)
- **Supplies**:
  - [x] Cacao fruits + sun tokens + gold coins (bank)

---

### Test 2 — Base, 3 jugadors

- **Config**: 3 jugadors, cap mòdul
- **Player Setup**:
  - [x] Cada jugador: village board, water carrier, water carrier a "-10", worker tiles
  - [x] Cada jugador treu 1x 1-1-1-1 worker tile (3 passos, un per jugador)
  - [x] NO apareix pas de "remove 2-1-0-1"
  - [x] Pas de shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "market, selling price 2"
  - [x] NO apareixen passos de "sort out jungle tiles"
  - [x] Jungle draw pile + jungle display (2 tiles)
- **Supplies**:
  - [x] Cacao fruits + sun tokens + gold coins (bank)

---

### Test 3 — Base, 4 jugadors

- **Config**: 4 jugadors, cap mòdul
- **Player Setup**:
  - [x] Cada jugador: village board, water carrier, water carrier a "-10", worker tiles
  - [x] Cada jugador treu 1x 1-1-1-1 worker tile (4 passos)
  - [x] Cada jugador treu 1x 2-1-0-1 worker tile (4 passos més)
  - [x] Pas de shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "market, selling price 2"
  - [x] NO apareixen passos de "sort out jungle tiles"
  - [x] Jungle draw pile + jungle display (2 tiles)
- **Supplies**:
  - [x] Cacao fruits + sun tokens + gold coins (bank)

---

## 🟡 GRUP 2: Mòduls individuals

### Test 4 — Map Module, 2 jugadors

- **Config**: 2 jugadors, Map Module
- **Player Setup**:
  - [x] Cada jugador rep 2 map tiles (pas per jugador)
  - [x] Apareix pas "put surplus map tiles back into the box"
- **Board Setup**:
  - [x] Map board al costat del jungle draw pile
  - [x] 4 jungle tiles: 2 als espais marcats del map board + 2 com a jungle display

---

### Test 5 — Map Module, 4 jugadors

- **Config**: 4 jugadors, Map Module
- **Player Setup**:
  - [x] Cada jugador rep 2 map tiles
  - [x] NO apareix pas de "surplus map tiles" (8 tiles / 4 jugadors = 0 sobrants)
- **Board Setup**:
  - [x] Map board + 4 jungle tiles (2 marcades + 2 display)

---

### Test 6 — Watering Module, 2 jugadors

- **Config**: 2 jugadors, Watering Module
- **Board Setup**:
  - [x] Starting tiles canvien a: "single plantation" + "**water**" (NO market selling 2)
  - [x] Imatge de starting tiles correspon a la variant water
  - [x] Pas: "Sort out 2x Double Plantation and put them back in the box" (amb imatge)
  - [x] Pas: "Add 2x Watering tiles to the jungle tiles" (amb imatge)
  - [x] Ambdós passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] 2 double plantations eliminades
  - [x] 2 watering tiles afegides

---

### Test 7 — Watering Module, 3 jugadors

- **Config**: 3 jugadors, Watering Module
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Pas: "Sort out 1x Single Plantation and put it back in the box" (amb imatge)
  - [x] Pas: "Sort out 2x Double Plantation and put them back in the box" (amb imatge)
  - [x] Pas: "Add 3x Watering tiles to the jungle tiles" (amb imatge)
  - [x] Tots 3 passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] 1 single plantation + 2 double plantations eliminades
  - [x] 3 watering tiles afegides

---

### Test 8 — Chocolate Module, 2 jugadors

- **Config**: 2 jugadors, Chocolate Module
- **Board Setup**:
  - [x] El pas base "Sort out 1x Gold Mine, value 1" canvia a "Sort out **2x** Gold Mine, value 1" (base 1 + chocolate 1)
  - [x] El pas base "Sort out 1x Market, selling price 3" canvia a "Sort out **3x** Market, selling price 3" (base 1 + chocolate 2)
  - [x] Pas NOU: "Sort out 1x Gold Mine, value 2 and put it back in the box" (amb imatge)
  - [x] Pas NOU: "Add 2x Chocolate Kitchen tiles to the jungle tiles" (amb imatge)
  - [x] Pas NOU: "Add 2x Chocolate Market tiles to the jungle tiles" (amb imatge)
  - [x] Tots els passos nous apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] 2 gold mine value 1 eliminades (1 base + 1 chocolate)
  - [x] 1 gold mine value 2 eliminada
  - [x] 3 market selling 3 eliminades (1 base + 2 chocolate)
  - [x] 2 chocolate kitchen afegides
  - [x] 2 chocolate market afegides
- **Supplies**:
  - [x] Pas: "20 chocolate bars as supply pile"

---

### Test 9 — Chocolate Module, 3 jugadors

- **Config**: 3 jugadors, Chocolate Module
- **Board Setup**:
  - [x] Pas: "Sort out 2x Gold Mine, value 1 and put them back in the box" (amb imatge)
  - [x] Pas: "Sort out 1x Gold Mine, value 2 and put it back in the box" (amb imatge)
  - [x] Pas: "Sort out 3x Market, selling price 3 and put them back in the box" (amb imatge)
  - [x] Pas: "Add 3x Chocolate Kitchen tiles to the jungle tiles" (amb imatge)
  - [x] Pas: "Add 3x Chocolate Market tiles to the jungle tiles" (amb imatge)
  - [x] Tots 5 passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] 2 gold mine value 1 eliminades
  - [x] 1 gold mine value 2 eliminada
  - [x] 3 market selling 3 eliminades (de 4 totals, en queda 1)
  - [x] 3 chocolate kitchen afegides
  - [x] 3 chocolate market afegides
- **Supplies**:
  - [x] Pas: "20 chocolate bars as supply pile"

---

### Test 10 — Hut Module, 2 jugadors

- **Config**: 2 jugadors, Hut Module
- **Board Setup**:
  - [x] Pas al final de boardSetup: "12 hut tiles, drop, sort by cost" (⚠️ el pas diu 12 però `tiles.json` en conté 14)
- **Tiles en joc**:
  - [x] 14 hut tiles afegides al pool

---

### Test 11 — Gem Mines Module, 2 jugadors

- **Config**: 2 jugadors, Gem Mines Module
- **Board Setup**:
  - [x] El pas base "Sort out 1x Temple" queda **ELIMINAT** i substituït per:
  - [x] Pas: "Sort out all Temple tiles and put them back in the box" (amb imatge)
  - [x] Pas: "Add 4x Gem Mine tiles to the jungle tiles" (amb imatge)
  - [x] Ambdós passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] Totes les temples eliminades
  - [x] Gem mines afegides amb quantity 4 (5-1 per 2 jugadors)
- **Supplies**:
  - [x] Pas: "Remove 8 gems (2 of each color) and put them back into the box" (amb imatge gems)
  - [x] Pas: "Fill the remaining gems into the mine car..." (amb imatge gems)
  - [x] Pas: "Sort the masks (without the value 12 mask)..." (amb imatge)
  - [x] Pas: "Rule reminder: shake out 6 gems..."

---

### Test 12 — Gem Mines Module, 3 jugadors

- **Config**: 3 jugadors, Gem Mines Module
- **Board Setup**:
  - [x] Pas: "Sort out all Temple tiles and put them back in the box" (amb imatge)
  - [x] Pas: "Add 5x Gem Mine tiles to the jungle tiles" (amb imatge)
  - [x] Ambdós passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] Totes les temples eliminades
  - [x] Gem mines afegides amb quantity 5
- **Supplies**:
  - [x] Pas: "Fill all 32 gems into the mine car..." (amb imatge gems)
  - [x] Pas: "Sort the 7 masks..." (sense imatge de moment)
  - [x] Pas: "Rule reminder: shake out 6 gems..."

---

### Test 13 — Tree of Life Module, 2 jugadors

- **Config**: 2 jugadors, Tree of Life Module
- **Board Setup**:
  - [x] El pas base "Sort out 1x Gold Mine, value 1" canvia a "Sort out **2x** Gold Mine, value 1" (base 1 + tree of life 1)
  - [x] Pas NOU: "Sort out 1x Gold Mine, value 2 and put it back in the box" (amb imatge)
  - [x] Pas NOU: "Add 2x Tree of Life tiles to the jungle tiles" (amb imatge)
  - [x] Tots els passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] 2 gold mine value 1 eliminades (1 base + 1 tree of life)
  - [x] 1 gold mine value 2 eliminada
  - [x] 2 tree of life tiles afegides
- **Player Setup**:
  - [x] Cada jugador agafa la 0-0-0-4 worker tile (pas per jugador, **amb imatge**)
  - [x] NO apareix cap pas de "remove worker tile"

---

### Test 14 — Tree of Life Module, 3 jugadors

- **Config**: 3 jugadors, Tree of Life Module
- **Board Setup**:
  - [x] Pas: "Sort out 2x Gold Mine, value 1 and put them back in the box" (amb imatge)
  - [x] Pas: "Sort out 1x Gold Mine, value 2 and put it back in the box" (amb imatge)
  - [x] Pas: "Add 3x Tree of Life tiles to the jungle tiles" (amb imatge)
  - [x] Tots 3 passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] 2 gold mine value 1 eliminades (totes)
  - [x] 1 gold mine value 2 eliminada (de 2 totals, en queda 1)
  - [x] 3 tree of life tiles afegides
- **Player Setup**:
  - [x] NO apareix pas "remove 1-1-1-1" (Tree of Life restaura la que Base treia)

---

### Test 15 — Tree of Life Module, 4 jugadors

- **Config**: 4 jugadors, Tree of Life Module
- **Board Setup**:
  - [x] Pas: "Sort out 2x Gold Mine, value 1 and put them back in the box" (amb imatge)
  - [x] Pas: "Sort out 1x Gold Mine, value 2 and put it back in the box" (amb imatge)
  - [x] Pas: "Add 3x Tree of Life tiles to the jungle tiles" (amb imatge)
  - [x] Tots 3 passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] Tots 3 gold mines eliminats
  - [x] 3 tree of life tiles afegides
- **Player Setup**:
  - [x] SÍ apareix pas "remove 1-1-1-1" per cada jugador
  - [x] NO apareix pas "remove 2-1-0-1" (Tree of Life restaura)

---

### Test 16 — Emperor Favour Module, 2 jugadors

- **Config**: 2 jugadors, Emperor Favour Module
- **Board Setup**:
  - [x] Pas: "place Emperor figure on the **market, selling price 2**"
  - [x] El pas apareix just després de les starting tiles

---

### Test 17 — New Workers Module, 2 jugadors

- **Config**: 2 jugadors, New Workers Module
- **Player Setup**:
  - [x] Pas al principi: instruccions de selecció de worker tiles (replace o add)
  - [x] Menciona les regles de balance (1-8 more worker tiles per 2p)
- **Tiles en joc**:
  - [x] Les jungle tiles NO es modifiquen
  - [x] S'afegeixen les 4 noves worker tiles per cada jugador (0-0-0-4, 0-0-2-2, 0-2-0-2, 0-1-0-3)
  - [x] Les noves tiles apareixen a "Tiles in Play"

---

## 🔴 GRUP 3: Combinacions amb interaccions creuades

### Test 18 — Watering + Emperor, 2 jugadors

- **Config**: 2 jugadors, Watering Module + Emperor Favour Module
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Emperor diu: "place Emperor figure on the **water tile**" (NO market selling 2)

---

### Test 19 — Watering + Emperor, 3 jugadors

- **Config**: 3 jugadors, Watering Module + Emperor Favour Module
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Emperor diu: "place Emperor figure on the **water tile**"

---

### Test 20 — Chocolate + Tree of Life, 2 jugadors

- **Config**: 2 jugadors, Chocolate Module + Tree of Life Module
- **Board Setup**:
  - [x] Chocolate modifica pas base gold mine v1 (1→2) i market selling 3 (1→3)
  - [x] Chocolate afegeix: "Sort out 1x Gold Mine, value 2"
  - [x] Chocolate afegeix: "Add 2x Chocolate Kitchen" + "Add 2x Chocolate Market"
  - [x] Tree of Life **NO** afegeix passos de gold mine removal (Chocolate actiu)
  - [x] Tree of Life afegeix: "Add 2x Tree of Life tiles to the jungle tiles"
  - [x] Tots els passos apareixen ABANS de "mix remaining jungle tiles"
- **Tiles en joc**:
  - [x] Chocolate treu gold mines + markets (com sempre)
  - [x] Tree of Life **NO** treu gold mines addicionals (ja trets per Chocolate)
  - [x] 2 tree of life tiles afegides
  - [x] 2 chocolate kitchen + 2 chocolate market afegides
- **Player Setup**:
  - [x] Cada jugador agafa la 0-0-0-4 worker tile
- **Supplies**:
  - [x] Chocolate bars a supplies

---

### Test 21 — Chocolate + Tree of Life, 3 jugadors

- **Config**: 3 jugadors, Chocolate Module + Tree of Life Module
- **Board Setup**:
  - [x] Chocolate afegeix: "Sort out 2x Gold Mine, value 1" + "Sort out 1x Gold Mine, value 2" + "Sort out 3x Market, selling price 3"
  - [x] Chocolate afegeix: "Add 3x Chocolate Kitchen" + "Add 3x Chocolate Market"
  - [x] Tree of Life **NO** afegeix passos de gold mine removal (Chocolate actiu)
  - [x] Tree of Life afegeix: "Add 3x Tree of Life tiles to the jungle tiles"
- **Tiles en joc**:
  - [x] Chocolate treu gold mines + markets
  - [x] Tree of Life NO treu gold mines
  - [x] 3 tree of life + 3 choc kitchen + 3 choc market
- **Player Setup**:
  - [x] Worker 1-1-1-1 NO es treu (Tree of Life restaura)

---

### Test 22 — Chocolate + Tree of Life, 4 jugadors

- **Config**: 4 jugadors, Chocolate Module + Tree of Life Module
- **Tiles en joc**:
  - [x] Same: Chocolate treu gold mines, Tree of Life no
  - [x] 3 tree of life + 3 choc kitchen + 3 choc market
- **Player Setup**:
  - [x] Worker 1-1-1-1 SÍ es treu (per cada jugador)
  - [x] Worker 2-1-0-1 NO es treu (Tree of Life restaura)

---

### Test 23 — Gem Mines + Chocolate, 2 jugadors

- **Config**: 2 jugadors, Gem Mines Module + Chocolate Module
- **Board Setup**:
  - [x] Chocolate modifica pas base gold mine v1 (1→2) i market selling 3 (1→3)
  - [x] Chocolate: "Sort out 1x Gold Mine, value 2" + "Add 2x Choc Kitchen" + "Add 2x Choc Market"
  - [x] Gem Mines elimina pas base temple i afegeix: "Sort out all Temple tiles" + "Add 4x Gem Mine tiles"
- **Tiles en joc**:
  - [x] Temples eliminats (Gem Mines)
  - [x] Gold mines eliminats + chocolate tiles afegides (Chocolate)
  - [x] 4 gem mines afegides (2 jugadors)
- **Supplies**:
  - [x] Chocolate bars + gems + mine car + masks (sense value 12)

---

### Test 24 — Gem Mines + Tree of Life, 3 jugadors

- **Config**: 3 jugadors, Gem Mines Module + Tree of Life Module
- **Board Setup**:
  - [x] Gem Mines: "Sort out all Temple tiles" + "Add 5x Gem Mine tiles"
  - [x] Tree of Life: "Sort out 2x Gold Mine, value 1" + "Sort out 1x Gold Mine, value 2" + "Add 3x Tree of Life tiles"
- **Tiles en joc**:
  - [x] Temples eliminats (Gem Mines)
  - [x] Gold mines eliminats (Tree of Life — Chocolate NO actiu)
  - [x] 5 gem mines + 3 tree of life afegides
- **Player Setup**:
  - [x] Worker 1-1-1-1 NO es treu (Tree of Life restaura)

---

### Test 25 — Watering + Chocolate, 2 jugadors

- **Config**: 2 jugadors, Watering Module + Chocolate Module
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Watering: "Sort out 2x Double Plantation" + "Add 2x Watering tiles"
  - [x] Chocolate modifica pas base gold mine v1 (1→2) i market selling 3 (1→3)
  - [x] Chocolate: "Sort out 1x Gold Mine, value 2" + "Add 2x Choc Kitchen" + "Add 2x Choc Market"
- **Tiles en joc**:
  - [x] Plantations reduïdes (Watering)
  - [x] Gold mines + markets reduïts (Chocolate)
  - [x] Watering tiles + chocolate tiles afegides
- **Supplies**:
  - [x] Chocolate bars a supplies

---

### Test 26 — Map + Watering + Emperor, 2 jugadors

- **Config**: 2 jugadors, Map Module + Watering Module + Emperor Favour Module
- **Player Setup**:
  - [x] Cada jugador rep 2 map tiles
  - [x] Surplus map tiles back in box
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Emperor: "place Emperor figure on the **water tile**"
  - [x] Map board + 4 jungle tiles

---

## ⚫ GRUP 4: Big Game (tots els mòduls)

### Test 27 — Tots els mòduls, 2 jugadors

- **Config**: 2 jugadors, tots 8 mòduls actius
- **Player Setup**:
  - [x] Pas New Workers al principi (selecció worker tiles)
  - [x] Cada jugador: village board, water carrier, "-10", worker tiles
  - [x] Cada jugador rep 2 map tiles + surplus back in box
  - [x] Cada jugador agafa 0-0-0-4 (Tree of Life)
  - [x] Les 0-0-0-4 worker tiles tenen qty 1 per jugador (NO duplicades)
  - [x] NO "remove worker" steps
  - [x] Shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "**water**"
  - [x] Emperor: "on the **water tile**"
  - [x] 6 passos base sort out jungle tiles:
    - [x] 2x Single Plantation (base 2p)
    - [x] **3x** Market, selling price 3 (base 1 + chocolate 2, pas modificat)
    - [x] **2x** Gold Mine, value 1 (base 1 + chocolate 1, pas modificat)
    - [x] 1x Water (base 2p)
    - [x] 1x Sun-Worshiping Site (base 2p)
    - [x] Temple: **ELIMINAT** (reemplaçat per Gem Mines "Sort out all Temples")
  - [x] Watering: "Sort out 2x Double Plantation" + "Add 2x Watering tiles"
  - [x] Chocolate: "Sort out 1x Gold Mine, value 2" + "Add 2x Choc Kitchen" + "Add 2x Choc Market"
  - [x] Gem Mines: "Sort out all Temple tiles" + "Add 4x Gem Mine tiles"
  - [x] Tree of Life: "Add 2x Tree of Life tiles" (NO gold mine removal — Chocolate actiu)
  - [x] Map board + 4 jungle tiles
  - [x] 14 hut tiles (el pas diu "12", però `tiles.json` en conté 14)
- **Tiles en joc**:
  - [x] Plantations reduïdes (Watering) + 2 watering
  - [x] Gold mines trets (Chocolate) + 2 choc kitchen + 2 choc market
  - [x] Tree of Life NO treu gold mines (Chocolate actiu)
  - [x] 2 tree of life
  - [x] Temples eliminats (Gem Mines) + 4 gem mines
  - [x] 14 hut tiles
- **Supplies**:
  - [x] Cacao fruits + sun tokens + gold coins
  - [x] 20 chocolate bars
  - [x] Gems 2p: "Remove 8 gems..." + "Fill remaining into mine car..." + "Masks (sense value 12)..." + "Rule reminder"

---

### Test 28 — Tots els mòduls, 3 jugadors

- **Config**: 3 jugadors, tots 8 mòduls actius
- **Player Setup**:
  - [x] Pas New Workers al principi
  - [x] Cada jugador: village board, water carrier, "-10", worker tiles
  - [x] Cada jugador rep 2 map tiles
  - [x] Surplus map tiles back in box (3 jugadors × 2 = 6 usades, 8 total → 2 sobrants)
  - [x] Worker 1-1-1-1 NO es treu (Tree of Life restaura)
  - [x] Shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Emperor: "on the water tile"
  - [x] NO passos base sort out jungle tiles (només per 2p)
  - [x] Watering: "Sort out 1x Single Plantation" + "Sort out 2x Double Plantation" + "Add 3x Watering tiles"
  - [x] Chocolate: "Sort out 2x Gold Mine v1" + "Sort out 1x Gold Mine v2" + "Sort out 3x Market selling 3" + "Add 3x Choc Kitchen" + "Add 3x Choc Market"
  - [x] Gem Mines: "Sort out all Temple tiles" + "Add 5x Gem Mine tiles"
  - [x] Tree of Life: "Add 3x Tree of Life tiles" (NO gold mine removal — Chocolate actiu)
  - [x] Map board + 4 jungle tiles
  - [x] 14 hut tiles
- **Tiles en joc**:
  - [x] 1 single + 2 double plantations tretes (Watering) + 3 watering
  - [x] Gold mines trets (Chocolate) + 3 choc kitchen + 3 choc market
  - [x] 3 tree of life (Tree of Life NO treu gold mines, Chocolate actiu)
  - [x] Temples eliminats (Gem Mines) + 5 gem mines
  - [x] 14 hut tiles
- **Supplies**:
  - [x] Cacao + sun tokens + gold coins
  - [x] 20 chocolate bars
  - [x] Gems 3p: "Fill all 32 gems into mine car..." + "7 masks..." + "Rule reminder"

---

### Test 29 — Tots els mòduls, 4 jugadors

- **Config**: 4 jugadors, tots 8 mòduls actius
- **Player Setup**:
  - [x] Pas New Workers al principi
  - [x] Cada jugador: village board, water carrier, "-10", worker tiles
  - [x] Cada jugador rep 2 map tiles
  - [x] NO surplus map tiles (4 jugadors = 0 sobrants)
  - [x] Worker 1-1-1-1 SÍ es treu (per cada jugador)
  - [x] Worker 2-1-0-1 NO es treu (Tree of Life restaura)
  - [x] Shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "water"
  - [x] Emperor: "on the water tile"
  - [x] NO passos base sort out jungle tiles (només per 2p)
  - [x] Mateixos passos de substitució que 3 jugadors (Watering 3+p, Chocolate 3+p, Gem Mines 3+p, Tree of Life 3+p)
  - [x] Map board + 4 jungle tiles
  - [x] 14 hut tiles
- **Tiles en joc**:
  - [x] Mateixos que 3 jugadors (same quantities per 3+ players)
- **Supplies**:
  - [x] Same que 3 jugadors

---

## 🟣 GRUP 5: Big Game variant (`isBigGame = true`)

> La variant Big Game s'activa quan els 8 mòduls estan actius, hi ha 3 o 4 jugadors, i l'usuari activa el toggle "Big Game".
> En Big Game: s'utilitzen TOTES les tiles sense substitucions. Només 3 jugadors aplica removals específics.

### Test 30 — Big Game, 3 jugadors

- **Config**: 3 jugadors, tots 8 mòduls actius, toggle Big Game activat
- **Player Setup**:
  - [x] Cada jugador: village board, water carrier, "-10", worker tiles
  - [x] Cada jugador rep 2 map tiles
  - [x] Surplus map tiles back in box (3 jugadors × 2 = 6 usades, 8 total → 2 sobrants)
  - [x] NO apareix pas "New Workers selection" (totes les worker tiles ja estan al pool)
  - [x] NO apareix pas "Tree of Life 0-0-0-4" (totes ja al pool)
  - [x] NO apareix cap pas "remove worker tile" (Big Game = sense removals)
  - [x] Shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "**water**" (Watering encara modifica)
  - [x] Emperor: "on the **water tile**"
  - [x] NO passos base sort out jungle tiles (2p)
  - [x] NO passos de substitució de cap mòdul:
    - [x] NO watering remove/add steps
    - [x] NO chocolate remove/add steps
    - [x] NO gem mines remove/add steps
    - [x] NO tree of life remove/add steps
  - [x] Big Game 3p removal steps SÍ apareixen (5 passos, cadascun amb imatge):
    - [x] "Sort out 2x Single Plantation" (amb imatge)
    - [x] "Sort out 2x Gold Mine, value 1" (amb imatge)
    - [x] "Sort out 1x Market, selling price 2" (amb imatge)
    - [x] "Sort out 1x Market, selling price 3" (amb imatge)
    - [x] "Sort out 1x Watering" (amb imatge)
  - [x] Jungle draw pile + jungle display
  - [x] Map board + jungle display map
  - [x] 14 hut tiles
- **Tiles en joc** (TOTES les tiles, només amb removals 3p):
  - [x] Single plantation: 4 (6-2)
  - [x] Double plantation: 2 (sense removal)
  - [x] Market selling 2: 1 (2-1)
  - [x] Market selling 3: 3 (4-1)
  - [x] Market selling 4: 1
  - [x] Gold mine value 1: 0 (2-2, filtrada)
  - [x] Gold mine value 2: 2
  - [x] Water: 3
  - [x] Sun-Worshiping Site: 2
  - [x] Temple: 5 (sense removal!)
  - [x] Watering: 2 (3-1)
  - [x] Chocolate kitchen: 3
  - [x] Chocolate market: 3
  - [x] Gem mine: 5
  - [x] Tree of life: 3
  - [x] 14 hut tiles
- **Workers** (tots a full quantity, sense removals):
  - [x] Per cada jugador (red, purple, white):
    - [x] 1-1-1-1: qty 4
    - [x] 2-1-0-1: qty 5
    - [x] 3-0-0-1: qty 1
    - [x] 3-1-0-0: qty 1
    - [x] 0-0-0-4: qty 1
    - [x] 0-0-2-2: qty 1
    - [x] 0-2-0-2: qty 1
    - [x] 0-1-0-3: qty 1
    - [x] Total per jugador: 15 worker tiles
  - [x] NO hi ha worker tiles de yellow (només 3 jugadors)
- **Supplies**:
  - [x] Cacao fruits + sun tokens + gold coins
  - [x] 20 chocolate bars
  - [x] Gems: "Fill all 32 gems into mine car..." + "7 masks..." + "Rule reminder"
  - [x] NO apareix "Remove 8 gems..." (només per 2 jugadors normal mode)

---

### Test 31 — Big Game, 4 jugadors

- **Config**: 4 jugadors, tots 8 mòduls actius, toggle Big Game activat
- **Player Setup**:
  - [x] Cada jugador: village board, water carrier, "-10", worker tiles
  - [x] Cada jugador rep 2 map tiles
  - [x] NO surplus map tiles (4 jugadors = 0 sobrants)
  - [x] NO apareix pas "New Workers selection"
  - [x] NO apareix pas "Tree of Life 0-0-0-4"
  - [x] NO apareix cap pas "remove worker tile"
  - [x] Shuffle workers + draw 3
- **Board Setup**:
  - [x] Starting tiles: "single plantation" + "**water**"
  - [x] Emperor: "on the **water tile**"
  - [x] NO passos base sort out jungle tiles
  - [x] NO passos de substitució de cap mòdul
  - [x] NO Big Game 3p removal steps (4 jugadors = TOTES les tiles)
  - [x] Jungle draw pile + jungle display
  - [x] Map board + jungle display map
  - [x] 14 hut tiles
- **Tiles en joc** (TOTES les tiles, sense cap removal):
  - [x] Single plantation: 6
  - [x] Double plantation: 2
  - [x] Market selling 2: 2
  - [x] Market selling 3: 4
  - [x] Market selling 4: 1
  - [x] Gold mine value 1: 2
  - [x] Gold mine value 2: 2
  - [x] Water: 3
  - [x] Sun-Worshiping Site: 2
  - [x] Temple: 5
  - [x] Watering: 3
  - [x] Chocolate kitchen: 3
  - [x] Chocolate market: 3
  - [x] Gem mine: 5
  - [x] Tree of life: 3
  - [x] 14 hut tiles
- **Workers** (tots a full quantity, sense removals):
  - [x] Per cada jugador (red, purple, white, yellow):
    - [x] 1-1-1-1: qty 4
    - [x] 2-1-0-1: qty 5
    - [x] 3-0-0-1: qty 1
    - [x] 3-1-0-0: qty 1
    - [x] 0-0-0-4: qty 1
    - [x] 0-0-2-2: qty 1
    - [x] 0-2-0-2: qty 1
    - [x] 0-1-0-3: qty 1
    - [x] Total per jugador: 15 worker tiles
- **Supplies**:
  - [x] Cacao fruits + sun tokens + gold coins
  - [x] 20 chocolate bars
  - [x] Gems: "Fill all 32 gems into mine car..." + "7 masks..." + "Rule reminder"

---

## Notes

- L'ordre dels mòduls al pipeline és: Map → Watering → Chocolate → Hut → Gem Mines → Tree of Life → Emperor Favour → New Workers (per id de mòdul: 1-8).
- Les interaccions crítiques són: Watering↔Emperor (starting tile), Chocolate↔Tree of Life (gold mines), Tree of Life↔Base (worker removals), Gem Mines↔Base (temples), **Tree of Life↔New Workers (0-0-0-4 dedup)**.
- Cada test hauria de verificar tant els **passos de preparació** (instruccions) com les **tiles en joc** (pool resultant).
- **Big Game**: Quan `isBigGame = true`, el pipeline carrega TOTES les tiles al base handler i salta els `adjustTiles` dels mòduls. Watering encara modifica la starting tile. TreeOfLife i NewWorkers retornen early en `modifyPreparationSteps`. Chocolate i GemMines afegeixen supplies però salten substitucions.

### Qüestions pendents

- **Hut tiles 12 vs 14**: El handler diu "12 hut tiles" a la descripció (text del rulebook Chocolatl), però `tiles.json` en conté 14 i els integration tests esperen 14. Pendent de verificar amb el rulebook oficial si els 2 extres (Chief's Wife i Chief) provenen de Diamante.
