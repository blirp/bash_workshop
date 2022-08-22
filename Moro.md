# Moro! #

Kraften i Bash kommer i hovedsak fra de programmene vi knytter sammen. Hvis vi benytter kraftige verktøy som `curl`, `wget`, `jq` og `xmlstarlet`, kan vi utføre REST-kall på linje med mer avanserte språk. Samtidig betyr dette at vi må lære oss mye nytt. Ingenting av det som funker for `jq` funker for `xmlstarlet`. `curl` og `wget` har heller ikke noe overlapp. Dette er kanskje det problemet som gjør Bash-skripting mest vanskelig. Men vanskelig er bare gøy!

Entur har API for å sjekke busstider. Det finnes en herlig GUI-basert webløsning som kjører fint på mobilen vår her: https://buss.grevling.dev. Kan vi få til noe sånt i Bash?

### Oppgave 1 ###

Det første API'et vi skal kalle er sted-søket: https://developer.entur.org/pages-geocoder-intro. Vi trenger bare å bruke /autocomplete. Men det er viktig at vi setter header-verdien `ET-Client-Name`.

Lag et skript som tar inn et ønsket sted (for eksempel "Oasen") og viser en liste av steder som passer.

Første steg kan være å sende forespørselen til Entur vha. `curl`. Husk å sette `ET-Client-Name`.

Andre steg er å pipe resultatet `jq`.

Så gjelder det å hente ut bare 'label'-feltet fra 'properties'-objektet fra hvert element i 'features'-tabellen. Dette gjøres vha. spørrespråket til `jq`: https://stedolan.github.io/jq/manual/

### Oppgave 2 ###

Utvid skriptet til å liste ut resultatene som en numerert liste. Bruker må så få mulighet til å velge et nummer i listen. Dette brukes til å hente ut 'coordinates'-tabellen fra 'gemoetry'-objektet for valgt 'feature'-indeks.

### Oppgave 3 ###

Skriptet håndterer ikke norske bokstaver (eller blanke), siden disse må URL-enkodes. Utvid skriptet til å håndtere dette.

Hvis dette blir for vanskelig, holder det å håndtere blanke.

### Oppgave 4 ###

Utvid skriptet til å håndtere at søket bare returnerer ett resultat. Da burde vi kunne få ut koordinatene uten å velge i en liste. Eksempelsøk: "Oasen Terminal"

### Oppgave 5 ###

Utvid skriptet til å ta to parametre, et for fra og et for til. I begge tilfeller gjelder det å håndtere blanke, vise liste ved flere treff og returnere GPS-koordinatene til valgt sted.

### Oppgave 6 ###

For å få faktiske rutetabeller, må vi bruke 'Journey Planner' API'et til Entur: https://developer.entur.org/pages-journeyplanner-journeyplanner

Her skal vi sende inn en GraphQL-spørring pakket inn i en JSON. Det er antagelig enklest å bruke HEREDOC til å generere GraphQL fra de koordinatene som er valgt. Se litt på [GraphQL IDE'en](https://api.entur.io/graphql-explorer/journey-planner-v3) for å se hva som skal til.

Når denne skal pakkes inn som en JSON, må du antagelig kode linjeskift som `\n`.

Utvid skriptet til å utføre GraphQL-spørringen.

### Oppgave 7 ###

Samle sammen alle delene over til et skript som viser en reiserute for to steder angitt som parametre til skriptet.