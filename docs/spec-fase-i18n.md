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

## 5. Tests

- Handlers: intactes (default anglès de l'ARB — si l'ARB anglès canvia, els tests ho detecten: única font de veritat).
- Widget tests de preparació: afegir `localizationsDelegates` al MaterialApp de test on calgui.
- Cas nou: l'adapter en ca/es retorna strings no buides per a totes les claus de preparació (smoke test de paritat d'idiomes).
