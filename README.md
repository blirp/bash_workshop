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

Hvis Bash er helt ukjent, kan litt info om struktur og kommandoer finnes i [Kræsjkurs.md](Kr%C3%A6sjkurs.md).

Utover det er [DuckDuckGo](http://duckduckgo.com) din venn.

Noe av det vanligste å bruke Bash skripting til, er å automatisere vanlige operasjoner. En av de vanligste vi utviklere gjør er å bruke git. Ettersom git er så fleksibelt, lager alle sin egen arbeidsflyt. Det betyr egne regler for hovran git skal brukes i akkurat det prosjektet. Mao. et perfekt eksempel for å lage noen enkle skript.

Skriptet 'setUp.sh' starter opp en instans av GitLab ved hjelp av Docker. Deretter startes et skript som gjør diverse git-kommandoer som å lage brancher, legge til filer, redigere filer og merge brancher. Alt dette gjøres som brukeren 'annen'. Din jobb, som brukeren 'du', er å lage skript for å jobbe med dine egne brancher samtidig.

Branchene dine bør begynne med du

### Oppgave 1 ###

gitk gir et enkelt grafisk bilde av et git repo. De to vanligste er å se på aktiv branch sammen med 'main', eller å se på alle brancher for totalt kaos.

#1 Lag et skript som viser aktiv branch sammen med main.

#2 Utvid skriptet slik at hvis det får parametre, så sendes de til gitk, mens hvis det ikke er parametre, vises aktiv branch og main

#3 Utvid skriptet til å håndtere at default branch heter noe annet enn 'main'.

