# Escombrat de QA

Registre viu. Dues passades fins ara:

- **2026-07-28** — l'escombrat original, vertical a fons i apaïsat només a les pantalles
  denses.
- **2026-08-16** — l'apaïsat sencer, tauleta, i **girant amb cada pantalla oberta**, durant
  el treball de la closca adaptativa (`feat/adaptive-shell`). El que va trobar és a
  [la passada de la closca](#passada-de-la-closca-adaptativa--2026-08-16).

La matriu i les troballes de sota estan **al dia**; les seccions datades són història.

## Matriu de pantalles

Estat a 2026-08-16. «Girat» vol dir verificat **obrint la pantalla i girant després**,
que és on van sortir els defectes que obrir-la ja girada amagava.

| Pantalla | Vertical CA | Horitzontal | ES / EN |
|---|---|---|---|
| Splash | OK (<3 s en instal·lació neta) | — | — |
| Inici | OK | OK, girat (**P4-2** tancat) | OK |
| Sobre l'app | OK | no provat en apaïsat | OK |
| Rajoles (catàleg) | OK | OK — graella + panell de detall | — |
| Filtres i ajustos (7 opcions) | OK | OK | — |
| Detall de rajola | **P1-5** (arreglat) | OK, com a pantalla i com a panell | — |
| Regles + visor PDF | OK | OK — índex + lector al costat | — |
| Nova partida | OK | OK — dos panells (**P4-1** tancat) | OK |
| Tauler de partida | OK | OK (aprofita l'amplada) | — |
| Preparació (llista) | OK | OK | OK |
| Preparació (guiada) | **P1-1**, **P1-2** (arreglats) | OK (juliol; no reverificat al 08-16) | OK |
| Selector de recol·lectors | **P1-3**, **P1-4** (arreglats) | no provat en apaïsat | — |
| Tirada de cabanes | OK | no provat en apaïsat | — |
| Rajoles en joc | OK | OK | — |
| Calculadora (6-8 passos) | OK | OK, girat (**P4-3** tancat) | OK |
| Resultats | OK | OK — dos panells | — |

## Matriu d'estat: què es perd i què no

Tres maneres de marxar d'una pantalla, més el botó HOME:

| Estat | Enrere/endavant | Calaix (`go`) | Procés mort | Botó HOME |
|---|---|---|---|---|
| Jugadors, expansions, mòduls | conserva | conserva | perd | conserva |
| Passos de preparació marcats | conserva | conserva | perd | conserva |
| Selecció de recol·lectors | conserva | conserva | perd | conserva |
| Tirada de cabanes | conserva | conserva | perd | conserva |
| Puntuacions introduïdes | conserva | conserva | perd | conserva |
| Plegat de fases | conserva¹ | conserva¹ | perd | conserva¹ |
| Filtre del catàleg / en joc | conserva | conserva | perd | conserva |
| Ajustos de rajola (7) | conserva | conserva | **conserva** | conserva |
| Mode llista/guiat | conserva | conserva | **conserva** | conserva |
| Presets propis de recol·lectors | conserva | conserva | **conserva** | conserva |

¹ Es perdia fins i tot en sortir i tornar; arreglat (**P2-2**).

La conclusió operativa: **tot el que és la partida viu només en memòria**. Els tres únics
supervivents d'un tancament són coses de disc (preferències i presets).

## Troballes

### Arreglades i verificades

| Id | Què | Commit |
|---|---|---|
| **P1-1** | El mode guiat arribava a l'última pàgina amb passos pendents i res no ho deia: el comptador diu 8/8 perquè compta pàgines, i «Següent» es desactiva igual que quan sí que has acabat. Ara ofereix «Queden N passos — vés al primer». | `344f730` |
| **P1-2** | Pàgines guiades curtes deixaven ~1.400 px de buit sota la targeta. Capçalera fixada, targeta centrada, scroll intacte si el contingut és llarg. | `344f730` |
| **P1-3** | Desar una tirada de sorpresa amb nom i aplicar-la seguia dient «Sorpresa»: la comparació amb presets propis quedava darrere de `isSurprise` i era inabastable. | `078c996` |
| **P1-4** | El badge de balanç jutjava el valor per defecte. Amb 3 jugadors, «afegeix-les totes» queda fora del marge recomanat, o sigui que la preparació obria en groc per una decisió que ningú havia pres. | `078c996` |
| **P1-5** | El nom de la rajola feia servir la font decorativa amb contorn daurat, reservada per docstring a moments de marca. Els noms llargs («Mercat, preu de venda 3») s'hi esfilagarsen. Token nou `screenTitlePlain`. | `958c386` |
| **P2-1** | El back destruïa la partida sencera. Vegeu el detall a sota. | `d6ce444` |
| **P2-2** | El plegat de fases no sobrevivia ni a sortir al tauler i tornar, mentre que els passos marcats a la mateixa pantalla sí. | `d672ef2` |
| — | Regressió de la meva pròpia correcció de P2-2: la partida nova obria amb les fases plegades, heretades de l'anterior. | `92cb4fe` |

**P2-1 amb detall**, perquè és la més greu i queda a mitges. Comparant les dues maneres de
sortir: prémer HOME i tornar deixa la partida intacta i fins i tot recupera la pantalla on
eres; prémer enrere des de qualsevol secció del calaix te'n treia i, en tornar, la partida
havia desaparegut sencera. El procés continuava viu (pid comprovat) — Android manté l'app a
recents — però enrere a la ruta arrel acaba l'`Activity` i s'emporta tot l'estat Dart.

Ara enrere des d'una secció puja a Inici, i enrere a Inici amb partida en curs pregunta
abans de sortir. Això cobreix l'accident habitual, **no** cobreix que Android mati l'app per
memòria amb la pantalla apagada al mig d'una partida de 45 minuts.

### Obertes

Cap. Les tres troballes d'apaïsat de juliol (**P4-1**, **P4-2**, **P4-3**) es van tancar el
2026-08-16; vegeu la passada de sota.

### Decisió pendent

**Persistir la partida a disc.** És l'únic que fa la pèrdua impossible en lloc de poc
probable. Avui no s'escriu res enlloc. El que ho bloqueja no és el codi sinó decidir el
comportament d'obertura: si en arrencar es troba una partida desada, es reprèn sola, es
pregunta, o es mostra «Reprèn / Descarta». No és feina llençada — l'historial de partides
de la Fase 2 necessita exactament aquesta peça.

## El que va bé i val la pena dir

- **La tirada de cabanes** és el millor widget de l'app: 12 tocs i l'eliminació automàtica
  resol les combinacions impossibles sola (en triar-ne 6, «El remeier» desapareix sencer).
- **La cadena creuada funciona d'extrem a extrem**: la tirada registrada filtra la llista de
  cabanes de la calculadora a les 9 funcions que van sortir, i «Rajoles en joc» mostra
  exactament les rajoles de la selecció aplicada, per color.
- **Canviar la selecció de recol·lectors** desmarca sol els passos que en depenien i avisa
  («Has canviat els recol·lectors: torna a muntar la pila»).
- La configuració canvia a «Reprèn la partida» quan n'hi ha una en curs; els resultats
  gestionen negatius i empats correctament.
- En horitzontal el mòbil ja fa **923 dp** i creua el punt de tall *expanded*. Al juliol
  això només movia el calaix al 35% i la barra de 56 a 44 px; des del 2026-08-16 el calaix
  ja no existeix i l'amplada decideix tota la navegació.

## Cobertura: què NO s'ha provat

Al dia a 2026-08-16.

- **Tres pantalles no s'han obert mai en apaïsat**: «Sobre l'app» desplegat, el selector de
  recol·lectors i la tirada de cabanes. Cap surt a la ruta principal d'una partida, que és
  per què han anat quedant per al final dues passades seguides.
- **Preparació guiada en apaïsat** consta OK des del juliol i no s'ha reverificat girant, que
  és precisament el gest que va destapar defectes en altres pantalles.
- **Tauleta**: s'han comprovat les quatre classes de finestra (1600×2560 @320 dpi, en les
  dues orientacions), però **només a Inici i la navegació**. Cap pantalla de contingut s'ha
  recorregut a mida de tauleta.
- L'anglès s'ha comprovat per sobre: és l'idioma origen i el més curt.

## Escombrat original — 2026-07-28

Repàs complet de l'app al dispositiu: cada pantalla, cada control, i sobretot **què
sobreviu a què** quan navegues. Fet sobre `chore/tech-debt-review`, emulador Pixel 9a
(1080×2424, 420 dpi), builds release instal·lats amb `adb`.

Aquest document **no** repeteix `test/manual_test_checklist.md` — vegeu la nota al final.

### Mètode

Cada troballa surt d'una captura, no d'una lectura de codi. On el comportament es podia
fixar amb un test l'he escrit, i l'he comprovat per mutació (revertir el fix ha de fer
fallar el test). Les correccions van commit a commit, cadascuna reverificada al dispositiu
abans de passar a la següent.

Dos falsos positius meus pel camí, tots dos per llegir malament una captura: un toc que no
havia arribat a desmarcar un mòdul, i un dígit tapat per la barra flotant de l'IME de
l'emulador («1 / 4 mòduls» llegit com a «0 / 4»). Cap dels dos era un problema de l'app.

## Passada de la closca adaptativa — 2026-08-16

Feta durant `feat/adaptive-shell`, sobre l'emulador Pixel 9a i, per a les classes de finestra
grans, el mateix emulador redimensionat a 1600×2560 @320 dpi. Cada troballa surt d'una
captura o del logcat, no d'una lectura de codi.

**El mètode que va marcar la diferència**: obrir una pantalla i **girar-la**, en comptes
d'obrir-la ja girada. Dos defectes només apareixien així, i la primera passada d'aquell dia
els va donar per bons perquè no ho feia.

### Tancades

| Id | Què | On |
|---|---|---|
| **P4-1** | El formulari de partida compartia una finestra de scroll d'uns 190 dp en apaïsat: es veien dues de les quatre targetes de color, tallades. Jugadors i expansions són decisions independents, així que ara van en dos panells amb scroll propi. | `game_setup_widget.dart` |
| **P4-2** | El hero de la Home ocupava el 53% de la finestra apaïsada i deixava lloc per a una targeta. Ara cedeix alçada, i la Home ha deixat de ser un llançador perquè la navegació és permanent. | `home_screen.dart` |
| **P4-3** | La imatge de referència de la calculadora empenyia els comptadors sota el plec. Ara el pas es parteix en dos panells: referència a l'esquerra, camps a la dreta. | `score_calculator_screen.dart` |

### Trobades i tancades el mateix dia

Cinc de sis introduïdes per la pròpia reforma; es documenten igual perquè el patró es
repetirà.

| Què | Com va sortir |
|---|---|
| «Reprèn la partida» a la Home anava a la pantalla d'error: navegava amb `go` i el tauler rep la partida com a `extra` tipat. | Recorrent el flux al mòbil. Cap test hi passava; ara n'hi ha un al router. |
| Puntuacions era un atzucac en vertical: fora de la barra per nivell, sense fletxa d'enrere i sense menú. | Obrint-la des de la Home. La barra ara porta totes les destinacions mentre hi càpiguen, i un test falla el dia que en sobri una. |
| El rail s'inflava de 79 a 135 dp en apaïsat amb la càmera a l'esquerra, amb les icones escorades. | Observació de l'usuari; confirmada mesurant les dues rotacions. |
| El hero i la imatge de la calculadora es quedaven a la mida de vertical en girar amb la pantalla oberta. | Girant. Totes dues llegien la mida de `MediaQuery`, que va obsoleta; ara surten de les restriccions. |
| La capçalera d'un pas de puntuació desbordava amb el títol llarg: `Row` fix, sense flexibilitat. | Un test nou a 411 dp. Hauria petat amb una traducció llarga o amb text accessible gran. |
| En una finestra ampla sense imatge (el pas de jugadors), el peu no es dibuixava i el pas quedava sense manera d'avançar. | Un test que ja existia, en reordenar el layout. |

### El que no es va tocar, i per què

- **Preparació**, en tots dos modes: ja constava OK en apaïsat i reestructurar una pantalla
  que funciona és soroll.
- **L'anell de progrés** de la capçalera de fase: té `value`, és progrés i no espera. Les
  rodetes que sí que es van substituir per esquelets eren les de càrrega.

### Regla que en surt

Cap decisió de layout hauria de venir de `MediaQuery` si hi ha una restricció a mà. Una
consulta a la finestra pot llegir obsoleta després d'una rotació; una restricció no, perquè
res no es disposa fins que existeix. L'única excepció viva és l'alçada de l'app bar, que
s'ha de declarar abans que hi hagi cap disposició — i està documentada com a tal a
`AppBreakpoints.isShortWindow`.

## Nota sobre `test/manual_test_checklist.md`

Aquell document (653 línies, 31 tests) cobreix una cosa diferent i complementària: **quins
passos de preparació genera cada combinació** de jugadors i mòduls. Aquest escombrat no ho
repeteix perquè aquella matriu ja té tests unitaris al darrere (handlers, pipeline, use
case).

Ara bé, **ha quedat desfasat**: té les 31 entrades marcades però descriu l'app d'abans dels
redissenys UX-2 i UX-3. Per exemple diu «3 passos, un per jugador» quan `a4f3c46` va
generalitzar aquells passos a un de sol («cada jugador…»). Convindria repassar-lo o marcar-lo
com a històric.
