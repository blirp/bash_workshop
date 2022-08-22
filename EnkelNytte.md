# Enkel Nytte #

Hvis Bash er helt ukjent, kan litt info om struktur og kommandoer finnes i [Kræsjkurs.md](Kr%C3%A6sjkurs.md).

Utover det er [DuckDuckGo](http://duckduckgo.com) din venn.

Noe av det vanligste å bruke Bash skripting til, er å automatisere vanlige operasjoner. En av de vanligste vi utviklere gjør er å bruke git. Ettersom git er så fleksibelt, lager alle sin egen arbeidsflyt. Det betyr egne regler for hovran git skal brukes i akkurat det prosjektet. Mao. et perfekt eksempel for å lage noen enkle skript.

## Oppsett ##

Skriptet `setUp.sh` starter opp en instans av GitLab ved hjelp av Docker. Deretter startes et skript som gjør diverse git-kommandoer som å lage brancher, legge til filer, redigere filer og merge brancher. Alt dette gjøres som brukeren 'annen'. Din jobb, som brukeren 'du', er å lage skript for å jobbe med dine egne brancher samtidig i underkatalogen `ditt`.

Skriptet som genererer aktivitet i git-repoet, 'oppdater.sh' er skrevet så sjansen for merge konflikt er minimal. Alle branchene begynner med 'branch/', alle filene som lages og redigeres i en branch, begynner med branch-navnet.

Alt ditt arbeid bør gjøres i en separat utsjekket klone av repoet. `setUp.sh` lager en katalog `ditt` for dette formålet.

Så lenge dine brancher **ikke** begynner med 'branch/' blir det lite konflikter. Det enkleste er kanskje å lage en branch 'minbranch':
```bash
$ cd ditt
$ git checkout -b minbranch
$ git push --set-upstream origin minbranch
```

Hvis du gjør endringer i 'main', kan du potensielt lage problemer. Da kan du terminiere 'oppdater.sh' og starte den igjen fra rotkatalogen til dette repoet med kommandoen 
```bash
$ ./oppdater.sh annen
```

Du kan også bruke dette skriptet til å lage noen tilfeldige endringer:
```bash
$ ../oppdater.sh 2
```

Parameteren `2` her, gjør at skriptet bare venter 2 sekunder mellom hver endring. 

Merk at skriptet ikke avslutter før du trykker Ctrl-C.

## gitk ##

gitk gir et enkelt grafisk bilde av et git repo. De to vanligste er å se på aktiv branch sammen med 'main', eller å se på alle brancher for totalt kaos.

### Oppgave 1 ###

Lag et skript som starter gitk og viser aktiv branch sammen med main.

### Oppgave 2 ###

Utvid skriptet slik at hvis det får parametre, så sendes de til gitk, mens hvis det ikke er parametre, vises aktiv branch og main

### Oppgave 3 ###

Utvid skriptet til å håndtere at default branch heter noe annet enn 'main'.

## rebase ##

Det er `git-rebase` som er valgt som strategi, ikke `git-pull`. 


### Oppgave 4 ###
Lag et skript som oppdaterer både akiv branch og hovedbranchen, uavhengig av hva hovedbranchen heter.

### Oppgave 5 ###
Rebase er veldig enkelt, men det lager mye krøll ved konflikter. Sannsynligheten er nemlig stor for at hvis det først er konflikt, er det konflikt i mange av de commit'ene vi har gjort lokalt. 

Oppdater skriptet så det minimerer sjansen for konflikt.

Du kan gjøre endringer med brukeren `team` for å teste dette. setUp.sh laget en katalog 'team' for dette.

### Oppgave 6 ###
Oppdater skriptet til å automatisk merge hovedbranchen inn i egen branch.

### Oppgave 7 ###
Lag et skript som oppdaterer alle brancher som er sjekket ut lokalt. Siden du ikke gjør aktiv utvikling på disse, skal de ikke merges med hovedbranchen.

