# Escombrat de QA — 2026-07-28

Repàs complet de l'app al dispositiu: cada pantalla, cada control, i sobretot **què
sobreviu a què** quan navegues. Fet sobre `chore/tech-debt-review`, emulador Pixel 9a
(1080×2424, 420 dpi), builds release instal·lats amb `adb`.

Aquest document **no** repeteix `test/manual_test_checklist.md` — vegeu la nota al final.

## Mètode

Cada troballa surt d'una captura, no d'una lectura de codi. On el comportament es podia
fixar amb un test l'he escrit, i l'he comprovat per mutació (revertir el fix ha de fer
fallar el test). Les correccions van commit a commit, cadascuna reverificada al dispositiu
abans de passar a la següent.

Dos falsos positius meus pel camí, tots dos per llegir malament una captura: un toc que no
havia arribat a desmarcar un mòdul, i un dígit tapat per la barra flotant de l'IME de
l'emulador («1 / 4 mòduls» llegit com a «0 / 4»). Cap dels dos era un problema de l'app.

## Matriu de pantalles

| Pantalla | Vertical CA | Horitzontal | ES / EN |
|---|---|---|---|
| Splash | OK (<3 s en instal·lació neta) | — | — |
| Inici | OK | **P4-2** | OK |
| Sobre l'app | OK | no provat | OK |
| Rajoles (catàleg) | OK | no provat | — |
| Filtres i ajustos (7 opcions) | OK | no provat | — |
| Detall de rajola | **P1-5** (arreglat) | no provat | — |
| Regles + visor PDF | OK | no provat | — |
| Nova partida | OK | **P4-1** | OK |
| Tauler de partida | OK | OK (aprofita l'amplada) | — |
| Preparació (llista) | OK | OK | OK |
| Preparació (guiada) | **P1-1**, **P1-2** (arreglats) | OK | OK |
| Selector de recol·lectors | **P1-3**, **P1-4** (arreglats) | no provat | — |
| Tirada de cabanes | OK | no provat | — |
| Rajoles en joc | OK | no provat | — |
| Calculadora (6-8 passos) | OK | **P4-3** | OK |
| Resultats | OK | no provat | — |

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

| Id | Gravetat | Què | On |
|---|---|---|---|
| **P4-1** | Mitjana | En horitzontal, a «Nova partida» el botó inferior fix se solapa amb la llista: «Expansions i mòduls» queda tallat per la meitat i no es pot veure sencer. És la pantalla amb més formulari i la que pitjor porta l'apaïsat. | `game_setup_screen.dart` |
| **P4-3** | Baixa-mitjana | En horitzontal, la imatge de referència de cada pas de puntuació ocupa tota la finestra i empeny els comptadors fora de pantalla. Es pot fer scroll i els controls hi són, però cada pas obliga a desplaçar abans de poder escriure res. Falta un topall d'alçada a la imatge. | `score_calculator_screen.dart` (`_StepReferenceImage`) |
| **P4-2** | Baixa | En horitzontal el logo de la Home ocupa tota la finestra; cal fer scroll per arribar a qualsevol acció i només es veu la primera targeta. | `home_screen.dart` |

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
- En horitzontal el mòbil ja fa **923 dp** i creua el punt de tall *expanded*: el calaix
  passa al 35% i la barra de 56 a 44 px, tal com preveu `custom_scaffold_widget`.

## Cobertura: què NO s'ha provat

- **Amplada de tauleta en vertical** (600–840 dp, la branca *medium*). L'apaïsat cobreix la
  branca *expanded* però no aquesta.
- L'horitzontal només s'ha escombrat a les pantalles denses; les marcades «no provat» a la
  matriu queden pendents.
- L'anglès s'ha comprovat per sobre: és l'idioma origen i el més curt, i les cadenes noves
  d'avui les afirmen literalment els tests de widget.

## Nota sobre `test/manual_test_checklist.md`

Aquell document (653 línies, 31 tests) cobreix una cosa diferent i complementària: **quins
passos de preparació genera cada combinació** de jugadors i mòduls. Aquest escombrat no ho
repeteix perquè aquella matriu ja té tests unitaris al darrere (handlers, pipeline, use
case).

Ara bé, **ha quedat desfasat**: té les 31 entrades marcades però descriu l'app d'abans dels
redissenys UX-2 i UX-3. Per exemple diu «3 passos, un per jugador» quan `a4f3c46` va
generalitzar aquells passos a un de sol («cada jugador…»). Convindria repassar-lo o marcar-lo
com a històric.
