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
$ echo "Hei på deg, $NAVN_$NAVN!"
Hei på deg, Martin!
$ echo "Hei på deg, ${NAVN}_${NAVN}!"
Hei på deg, Martin_Martin!
```

Merk at `echo` ikke er et reservert ord i Bash, heller ikke en kommando, det er faktisk et frittstående program:
```bash
$ which echo
/usr/bin/echo
```

Vi kan putte disse linjene i en fil, skript, slik at vi kan kjøre dem igjen:

*skript*:
```
NAVN="Martin"
echo "Hei på deg, $NAVN!"
```
Dette kan vi da kjøre:
```bash
$ bash skript
Hei på deg, Martin
```
Bash har også muligheten til å definere skript som selv-kjørende. Dette krever to steg, det første er at den første linjen i filen er en spesiell kommentar:
```bash
#!/bin/Bash
```
Dette betyr at denne filen kan tolkes med programmet /bin/bash. Andre muligheter, som /bin/python3, er også mulige. Det neste steget er å markere filen som kjørbar:
```bash
$ chmod +x skript
$ ./skript
Hei på deg, Martin!
```

## Parametre ##

Parametre til et skript heter 1, 2, 3 opp til 9. Disse kan altså refereres til i skriptet som $1, $2 osv.

*skript2*:
```bash
#!/bin/Bash
echo 1: $1
echo 2: $2
echo 3: $3
echo 4: $4
```
```bash
$ ./skript2 Hei på deg
```
Prøv også med forskjellige varianter av fnutter:
```bash
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

*skript3*:
```bash
#!/bin/Bash
echo 1: $1
echo 2: $2 >&2
```
Hvordan oppfører disse seg?
```bash
$ ./skript3 Hei på deg
$ ./skript3 Hei på deg >/dev/null
$ ./skript3 Hei på deg 2>/dev/null
```
Hva endrer seg om du legger på fnutter?

## if ##

En if-setning ser slik ut i Bash.

*skript4*:
```bash
#!/bin/Bash
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

En for-løkke ser slik ut i Bash.

*skript5*:
```bash
#!/bin/Bash
for a in $(seq 10)
do 
  echo "$a * 2 = $((a * 2))"
done
```
Også her er det vanlig å skrive `; do` på samme linje som `for`.

Her kjører vi `seq 10` i et separat Bash-miljø, og så vil `for`-løkken iterere over hvert element som det miljøet skriver til `stdout`.

Dette skriptet er også morsomt å kjøre uten fnuttene.

`seq` er et eget program som returnerer en sekvens av tall.
```bash
$ seq 10
$ man seq
```

Elementene i en for-løkke er skilt med whitespace, altså blanke, TAB, linjeskift osv. Dette medfører et litt uventet resultat for filnavn som inneholder disse:
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

## Variabler ##

Variabler i Bash har en av tre typer:
* streng
* heltall
* array

Siden vi opererer med tekststrømmer, er den første helt klart den vanligste. Variabler tilordnes med en vanlig =. Det er viktig å ikke ha blanke før eller etter likhetstegnet. I så fall vil Bash oppfatte variabelnavnet eller verdien som en operasjon. Innholdet i variabler returneres ved å prefikse dem med $.
```bash
$ DING = BLA
DING: command not found
$ DING= BLA
BLA: command not found
$ DING=BLA
$ echo $DING
BLA
$ DING= ls
'Filnavn med blanke'   Kræsjkurs.md   skript   skript2   skript3   skript4   skript5
$ echo $DING
BLA
```

Vi kan samle inn stdout fra en operasjon inn i en variabel ved å pakke operasjonen inn i $().
```bash
$ DING=$(ls)
$ echo $DING
Filnavn med blanke Kræsjkurs.md skript skript2 skript3 skript4 skript5
```
Merk også her forskjellen på å bruke dobbeltfnupper rundt $DING.

Heltallsvariabler brukes ofte i forbindelse med returverdier fra kjørte programmer. Alle operasjoner i Bash har en returverdi fra 0 til 255. Denne er tilgjengelig i spesialvariabelen $?:
```bash
$ A=$(ls skript 2>/dev/null); echo $?
0
$ A=$(ls skrapt 2>/dev/null); echo $?
2
```
Merk at alle kommandoer setter returverdi, også `echo`.
```bash
$ A=$(ls skrapt 2>/dev/null); echo $?; echo $?
2
0
```
$? kan altså bare brukes én gang, selv tilordningen til en ny variabel setter ny returverdi!
```bash
$ A=$(ls skrapt 2>/dev/null); B=$?; echo "$B - $?"
2 - 0
```

### Spesielle variabler ###

* $0 - skriptets navn
* $1 .. $9 - de ni første parametrene, resten nåes ved å bruke `shift`
* $# - antall parametre
* $@ - alle paramtre som en array
* $? - returverdien til forrige program

## Moduler - Skript og funksjoner ##

Det er mulig å lage moduler i Bash. Det enkleste er å lage nye skript. Et skript kaller et annet skript på samme måte som det kaller et annet program. Kommunikasjonen mellom modulene går via det samme tekstbaserte grensesnittet som vanlig:
* Inn:
  * stdin
  * parametre
  * miljøvariabler
* Ut:
  * stdout
  * stderr
  * exit-kode

Det som er viktig å huske på når man starter andre skript, er at den nye skriptet, arver en kopi av miljøet til det eksisterende skriptet. Alle variabler som er markert med 'export', vil være tilgjengelige for det nye skriptet. Men hvis det nye skriptet gjør endringer, blir de aldri tilbakeført til det opprinnelige skriptet.

*skript6*:
```bash
#!/bin/bash
export A="Hei"
echo "$A fra skript6"
./skript7
echo "Tilbake til skript6: $A"
```
*skript7*:
```bash
#!/bin/bash
echo "$A fra skript7"
export A="Dingding"
echo "Ny $A fra skript7"
```
Kjøring av dette gir:
```bash
$ ./skript6
Hei fra skript6
Hei fra skript7
Ny Dingding fra skript7
Tilbake til skript6: Hei
```

### Funksjoner ###
Funksjoner fungerer veldig likt som separate skript. Den viktigste forskjellen er at funksjonen kjører i samme Bash-miljø som resten av skriptet. Alle endringer i variabler påvirker hele skriptet. 

*skript8*:
```bash
#!/bin/bash
A="Hei"
echo "$A fra skript8"
function funksjon
{
  echo "$A fra funksjon"
  A="Dingding"
  echo "Ny $A fra funksjon"    
}
funksjon
echo "Tilbake til skript8: $A"
```
Variablen `A` i funksjonen `funksjon` kan gjøres intern til funksjonen ved å prefikse den med `local`. Prøv det!

Samhandlingen har dermed fått en ekstra mulighet:
* Inn:
  * stdin
  * parametre
  * miljøvariabler
* Ut:
  * stdout
  * stderr
  * miljøvariabler
  * returverdi

Parametre til funksjoner fungerer på akkurat samme måte for eksterne skript. Det samme gjelder stdin, stdout og stderr. Den viktigste forskjellen er at `exit` avbryter skriptet og setter exit-verdi, mens `return` avslutter en funksjon og setter exit-verdi. Det er derfor vanligvis mest ønskelig å bruke `return` i funksjoner.

*skript9*:
```
#!/bin/bash
function funksjon
{
  local FIL="$1"
  if [ -f "$FIL" ]; then
    cat "$FIL"
    return 1
  fi
  echo "$FIL finnes ikke"
  exit 2
}
A=$(funksjon "$1")
echo "Etter første: $?"
echo "A: '$A'"

funksjon "$1"
echo "Etter andre: $?"
```
Prøv om du klarer å forstå hva som skjer her hvis du gir skriptet navnet på en fil som finnes i forhold til en som ikke finnes.

Hvis vi kaller dette skriptet med en fil som eksisterer, vil A få tilordnet innholdet i filen, returverdien 1 bli skrevet ut, etterfulgt av A. Deretter vil filen blir skrevet ut en gang til, sammen med returverdien 1. Etterpå vil `$?` være 0 på kommandolinjen fordi den siste `echo`-kommandoen gikk fint.

Hvis vi kaller dette skriptet med en fil som ikke eksisterer, vil "\<filnavn> finnes ikke" bli tilordnet A, og `$?` vil være 2 gitt `exit 2`. Andre gang funksjonen kalles, vil `exit 2` rett og slett avslutte hele skriptet og sette `$?` til 2 for kommandolinjen. Forskjellen på første og andre kall, er at det første kjøres i `$()`, som starter en ny Bash-prosess. At det termineres stopper ikke skript9. Andre gangen, derimot, kjøres det i skript9 sin Bash-prosess, og skriptet terminerer.

Sammenlign:
```bash
$ ./skript9 skript; echo $?
$ ./skript9 asdfgh; echo $?
```