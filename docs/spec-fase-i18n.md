# Especificació — Fase i18n (català, castellà, anglès)

> Estat: en curs · Predecessor: Fase UX-1 (feta) · Es fa ABANS d'UX-2 perquè el contingut nou d'UX-2 neixi localitzat (decisió del roadmap: "traduir una sola vegada").

## 1. Estratègia

- **Un ARB per idioma** (`lib/l10n/app_en.arb` plantilla, `app_ca.arb`, `app_es.arb`) amb `flutter gen-l10n` — l'estàndard de Flutter: plurals ICU, placeholders, comprovació de compilació.
- **Locale del sistema** (ca/es/en, fallback en). Sense selector manual dins l'app: això pertany a "configuració general" (Fase 4).
- El catàleg de tiles (noms/descripcions per id estable) i les descripcions de mòduls entren a l'ARB en un PR posterior (decisió ja registrada al deute tècnic).

## 2. El problema del domini i la solució

Els handlers construeixen `label/detail/rationale` en temps de pipeline, sense BuildContext. Solució:

- **`PreparationL10n`** (abstracció a `domain/content/preparation_l10n.dart`) amb els mateixos mètodes que tenia `PreparationCopy`, més `colorName(String)` perquè els colors dins de les frases també es tradueixin ("tauler de color **vermell**", no "de color red").
- **Adapter sobre `AppLocalizations`** (el codi generat és una classe Dart pura; es pot instanciar amb `lookupAppLocalizations(locale)` sense context). Viu al mateix fitxer de domini: dependre de codi generat per gen-l10n no trenca la puresa (no és UI).
- **Injecció amb default**: els handlers reben `PreparationL10n? l10n` i cauen a l'anglès (`lookupAppLocalizations('en')`) si no se'ls passa res → els ~10 fitxers de test de handlers no es toquen i les strings vives tenen una única font (l'ARB). `PrepareGameUseCase` rep l'adapter del locale actiu via provider.
- `PreparationCopy` desapareix; la UI amb context (targetes, celebració) usa `AppLocalizations.of(context)` directament.

## 3. Canvi de locale amb partida en marxa

Els passos generats conserven l'idioma de generació fins a la següent regeneració del pipeline (startGame / applyWorkerSelection / applyHutLayout). Limitació acceptada: el canvi de locale del sistema amb una preparació a mig fer és un cas marginal i l'estat és en memòria.

## 4. PRs

| PR | Contingut |
|---|---|
| **i18n-A** | Infra gen-l10n + ARB en/ca/es amb tot el contingut de preparació + `PreparationL10n` + refactor de handlers/use case + UI de preparació via `AppLocalizations.of` + delegates al MaterialApp |
| **i18n-B** | Resta d'UI (menú, home, Game Setup, dashboard, tiles, score, sheets de workers/cabanes) |
| **i18n-C** | Catàleg per id estable (`tileName_<id>`, `tileDesc_<id>`) + descripcions de mòduls + revisió completa ca/es |

## 5. Terminologia (fonts canòniques per idioma)

- **Anglès**: els PDF d'Abacusspiele inclosos a `assets/rules/` (font original de l'app).
- **Castellà**: la **traducció oficial de Devir** (Marc Figueras i Marià Pitarque, Devir Iberia). Termes clau que difereixen d'una traducció literal de l'anglès: *recolectores* (workers), *aguador* (water carrier), *remansos* del riu (water fields), *aldea* (village board), *losetas de selva* (jungle tiles), *pila de la selva* i *selva explorada* (draw pile / display), *cenote* (water tile), *mercado de precio de venta «2»*, *irrigación* (watering), *chocolatera* (chocolate kitchen), *tabletas de chocolate*, *bohíos* (huts). Expansions: **Xocolatl** (no "Chocolatl") amb mòduls *Mapas / Irrigación / Chocolate / Bohíos*; **Diamante** amb *Las minas de gemas / El árbol de la vida / El favor del **ahau** / Los nuevos recolectores*. Fonts: PDF oficial de Xocolatl (quejuegosdemesa.com), fitxes de producte Devir i ressenya Misut Meeple. Pendents de confirmar amb el PDF oficial de Diamante: *vagoneta* i el redactat exacte dels seus passos.
- **Català**: no hi ha edició oficial. La font canònica és el **glossari propi del projecte (DESIGN.md)**: rajoles, portador d'aigua, tauler de poblat, fitxes de sol, jungla, El Reg, Cuina de xocolata, Les Cabanes, El Favor de l'Emperador, Nous Treballadors. On el DESIGN.md no defineixi un terme, s'adapta del castellà oficial de Devir.
- **PR-B/C**: els noms d'expansions i mòduls que mostra el Game Setup han d'usar aquests noms oficials per idioma (via ARB, no `modules.json`).

## 6. Tests

- Handlers: intactes (default anglès de l'ARB — si l'ARB anglès canvia, els tests ho detecten: única font de veritat).
- Widget tests de preparació: afegir `localizationsDelegates` al MaterialApp de test on calgui.
- Cas nou: l'adapter en ca/es retorna strings no buides per a totes les claus de preparació (smoke test de paritat d'idiomes).
