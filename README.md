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

## I begynnelsen ##

Den aller enkleste kommandoen i Bash er antagelig `echo`. Denne skriver enkelt og greit ut parameterlisten sin:

```bash
$ echo "Hei på deg!"
Hei på deg!
```
Hvis vi definerer en variabel, kan `echo` vise innholdet av den:
```bash
$ NAVN="Martin"
$ echo "Hei på deg, $NAVN!"
Hei på deg, Martin!
```
Vi kan også bruke enkeltfnutter, men da vil `echo` ikke ekspandere variablene:
```bash
$ echo 'Hei på deg, $NAVN!'
Hei på deg, $NAVN!
```
Hvis det som kommer rett etter variabelnavnet i strengen kan tolkes som en gyldig del av variabelnavnet, kan vi pakke det inn i krøllparenteser:
```bash
$ NAVN="Martin"
$ echo "Hei på deg, ${NAVN}_${NAVN}!"
Hei på deg, Martin_Martin!
```

Merk at `echo` ikke er et reservert ord i Bash, heller ikke en kommando, det er faktisk et frittstående program:
```bash
$ which echo
/usr/bin/echo
```

Vi kan putte disse linjene i en fil, skript, slik at vi kan kjøre dem igjen:
```
NAVN="Martin"
echo "Hei på deg, $NAVN!"
```
```bash
$ bash skript
Hei på deg, Martin
```
Bash har også muligheten til å definere skript som selv-kjørende. Dette krever to steg, det første er at den første linjen i filen er en spesiell kommentar:
```bash
#!/bin/bash
```
Dette betyr at denne filen kan tolkes med programmet /bin/bash. Det neste steget er å markere filen som kjørbar:
```bash
$ chmod +x skript
$ ./skript
Hei på deg, Martin!
```

## Parametre ##

Parametre til et skript heter 1, 2, 3 opp til 9. Disse kan altså refereres til i skriptet som $1, $2 osv. skript2:
```bash
#!/bin/bash
echo 1: $1
echo 2: $2
echo 3: $3
echo 4: $4
```
```bash
$ ./skript2 Hei på deg
$ ./skript2 "Hei på deg"
$ ./skript2 'Hei på deg'
```

## Redirigering ##

Unix/Linux har tre standard tekststrømmer:
* stdin
* stdout
* stderr

Til vanlig er `stdin` koblet til tastaturet, mens `stdout` og `stderr` er koblet til terminalvinduet. Bash tilbyr enkle måter å redirigere disse slik at de peker andre steder:

* < redirigerer fil til stdin
* \> redirigerer stdout til fil
* 2> redirigerer stderr til fil
* | kobler et programs stdout til neste programs stdin
* \>&1 redirigerer til stdout
* \>&2 redirigerer til stderr

Eks. skript3:
```bash
#!/bin/bash
echo 1: $1
echo 2: $2 >&2
```
```bash
$ ./skript3 Hei på deg
$ ./skript3 Hei på deg >/dev/null
$ ./skript3 Hei på deg 2>/dev/null
```

## if ##

En if-setning ser slik ut i Bash (fil 'skript4'):
```bash
#!/bin/bash
NAVN=$1
if [[ $NAVN == "Martin" ]]
then 
  echo "Woo"
else 
  echo "Åh..."
fi
```
Merk at Bash er ganske kresen på hvor vi plasserer blanke og linjeskift. Det kan ikke være blanke rundt likhetstegnet i tilordningen av variablen `NAVN`. Men det må være blanke rundt `[[` og `==`, samt før `]]`. I tillegg må`then`, `else` og `fi` stå på egne linjer.

For å kjøre tilsvarende if-setning i Bash REPL, må vi bruke semikolon for å markere hvor hvert element slutter:
```bash
$ if [[ $NAVN == "Martin" ]]; then echo "Woo"; else echo "Åh..."; fi
```
Det er nokså vanlig å putte `; then` på samme linje som `if` for å spare litt plass og få en mer naturlig flyt.

Det `if` egentlig gjør, er å sjekke returverdien av programmet som kjøres, her `[[`. I Bash er `[[` en innebygd kommando, men opprinnelig ble `[` brukt, og dette er et frittstående program, noe som forklarer behovet for en blank etterpå. `]` markerer siste parameter til `[`, noe som da forklarer behovet for en blank foran denne.

`if` tolker returverdien `0` som sant, mens 1 til 255 er usant.

## for-løkke ##

En for-løkke ser slik ut i Bash (fil skript5):
```bash
#!/bin/bash
for a in $(seq 10)
do 
  echo $a
done
```
Også her er det vanlig å skrive `; do` på samme linje som `for`.

`seq` er et eget program som returnerer en sekvens av tall.
```bash
$ seq 10
$ man seq
```
Her kjører vi `seq 10` i et separat Bash-miljø, og så vil `for`-løkken iterere over hvert element som det miljøet skriver til `stdout`. Elementene er skilt med blanke, TAB, linjeskift osv. Dette medfører et litt uventet resultat for filnavn som inneholder blanke:
```bash
$ ls -1
'Filnavn med blanke'
LICENSE
oppdater.sh
README.md
script
$ for a in $(ls -1); do echo $a; done
Filnavn
med
blanke
LICENSE
oppdater.sh
README.md
```
