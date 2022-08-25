# Bash Workshop #


## Introduksjon ##

Bash (Bourne Again Shell) er et kommandolinjegrensesnitt til operativsystemer basert på Unix og Linux. 
Dette inkluder OS X, macOS og iOS som alle er basert på BSD Unix. 
Det finnes også Bash-implementasjoner for Windows, for eksempel GitBash eller via WSL/WSL2.

Unix har sin egen filosofi for hvordan programmer skal lages. 

De:
* gjør en ting og gjør den godt
* er skrevet for å samhandle med andre programmer
* benytter strøm av tekst som universelt grensesnitt

Dette betyr at vi kan ta en strøm av tekst (for eksempel innholdet i en fil) og sende til et program som gjør en eller annen transformasjon og produserer en ny strøm av tekst. Denne kan vi igjen sende videre til et annet program osv. Til slutt kan vi sende dette til skjermen eller til en fil. Hvert program fungerer da som et filter på tekststrømmen.

Bash er egentlig et veldig enkelt program. Det gir mulighet til å starte programmer, sende dem innputt og ta vare på resultatet i variabler. Det kan også redirigere resultatet videre til neste program. I tillegg har bash en enkel kontrollflyt med if/case/select og løkker med for/while/until. Til slutt er det en minimal støtte for å gruppere en rekke operasjoner i en privat funksjon. Totalt sett har Bash [22 reserverte ord](https://www.gnu.org/software/bash/manual/html_node/Reserved-Words.html), og to av dem er kun reserverte hvis de oppstår på spesielle plasser i forhold til andre reserverte ord.

Men selv med dette enkle oppsettet, fungerer bash som limet mellom alle de små programmene som utgjør en vanlig Unix/Linux distribusjon.


## Oppgaver ##

Det er tre sett med oppgaver i økende vanskelighetsgrad:

* [Krasjkurs.md](Krasjkurs/Krasjkurs.md) - Dette er for deg som aldri har brukt Bash. Alle skriptene er ferdig skrevne, men du kan eksperimentere litt med de forskjellige for å se på hvordan det virker.
* [Enkel nytte](EnkelNytte.md) - Dette er for deg som enten har vært igjennom `Kræsjkurset`, eller som har prøvd deg litt før. Oppgavene går ut på å lage noen nokså enkle skript for en gitt git-flyt.
* [Moro](Moro.md) - Dette er for deg som har jobbet med Bash før, eller som har vært igjennom `Enkel nytte`. Oppgaven er å bruke Bash til å kalle på et REST API, parse resultatet og bruke det videre til nye kall.


Lykke til!