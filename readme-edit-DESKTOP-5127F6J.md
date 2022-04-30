

# The Ransomator 
Ransomware angrep er en av de største truslene mot et selskap. Et års arbeid kan forsvinne i et øyeblikk om en ansatt trykker på en feil lenke, og bedriften havner i en situasjon hvor alt arbeidet er låst, og de må betale for å få disse dataene tilbake. Et slik angrep kan være veldig frustrernde dersom man ikke er beskyttet mot det. <br>
 I prosjektet vårt ble vi bedt om å lage en app som beskytter mot ransomware. For å lage denne appen må det kartlegges hvilke vinkler ransomware angriper fra, og hvordan det gjennomføres. <br>
 Ifølge [Wikepedia](https://en.wikipedia.org/wiki/Ransomware) så er ransomware en infisert fil som ser veldig legetim ut. Svindleren prøver å overtale offeret til å laste ned og kjøre en fil som inneholder en kode som svindeleren vil kjøre på offeret sin pc. Dette fører til at alle data i ofret i offerpcen blir kryptert og låst. Offeret får kanskje tilbake dataene sine dersom han betaler, men det er ingen garanti for dette. Ikke bare er det mulig at vedkommende ikke får igjen dataene hvis han betaler, men han kan også bli truet med offentliggjøring av stjålet data. Basert på dette kan vi konkludere med følgende problemer som vi skal finne en løsning på <br>

 <ol>
 <li>Det er sannsynlig at du ikke får de stjelte dataene tilbake.</li>
 <li>Det er en infisert fil som kan kjøre en ondsinnet kode i bakgrunnen, og aksessere datane inni pcen.</li>
  </ol>

  De overnevnte punktene ble grunnlaget for sammensettningen av scriptet mitt. Ved å se på angrepsvinklene, kan man tenke ut hvordan man skal beskytte arbeidet sitt mot ransomware. Dette kan man gjøre på følgende måte:

<ol>
 <li>Ta en ekstern datakopi. Dette er den beste måten å beskytte sine data. Rett og slett lage en beskyttet kopi av dataene eksternt</li>
 <li>Hold antivirus oppdatert, og scan regelmessig for å hindre infiserte koder fra å bli værende.</li>
 <li>Hold arbeids- og operativsystemfilene beskyttet mot fremmede applikasjoner. det kan hindre at en ransomware starter.</li>
  </ol>


## Hva scripet gjør
Jeg lagde et script som hovedsaklig tar en daglig backup av dataene som blir laget. Scriptet begynner med å laste ned og installerer de nødvendige verktøyene som skal til for å få prossessen til å skje. Scriptet benytter seg av en extern app som heter 7-zip. valget falt på 7-zip fordi den har alle de funksjonene som skal til å ta en sikker backup. <br> <br>
Når scriptet kjøres, så spør det om fire forskjellige inputer. Appen starter med å spørre om hvilke filer det skal tas backup av, hvilke kilder de kommer fra og hvor de skal plasseres. Det er mulig å få appen til å sende backup til flere ulike ekterne destinasjoner dersom man vil ha mer enn en backup, noe som er enda tryggere. 
Etter å ha gitt de første to inputene, spør appen brukeren om å lage et passord til backupfilene. Dette fører til at Backupfilen blir låst med det ønskede passordet, og blir kryptert slik at filens innhold blir usynlig. Laging av passord er valgfritt, og man kan velge å ikke ha passord ved å la være å taste inn passord i inputfeltet. Backupfiler blir kompressert med 7z, noe som kan hjelpe med å krympe størrelsen på filene.<br>

Jeg lagde to varianter av samme script, og den andre varianten er med innebygd schedulerfunksjon. Dette gjøre at etter å tastet de fire ønskede inputene så kan scriptet automatisk kjøres daglig med de samme tastede info. Jeg valgte å sette at prossesen skal skje hver dag kl 12:00 am, nemlig når det er minst mulig som belaster nettverket. <br> <br>

Backupprossessen i helgene er litt ulik hverdager. På hverdager så tar scriptet en inkrementel-backup. Dette betyr at det er bare de modifiserte filene som blir tatt med, og hvis en fil blir slettet, så blir den også slettet fra Backupfilen. Rett før en backup blir tatt, så blir Windows Defender aktivert (dersom den ikke allerede er det) og holdt oppdatert for maksimal sikkerhet. Deretter starter den en rask antivirusscan, i tillegg til scanning av folder-pathen som det blir tatt backup av, og så slettes eventuelle trussler som blir oppdaget. <br>

I helgene så blir det isteden tatt en full backup markert med datoen til dagens backup. Dette betyr at det blir laget et nytt bilde av datane hver uke, og man kan gå tilbake til eldre utgaver av Dataene hvis mand ønsker. Rett før det så blir det kjørt en full Antivirus scan for å holde hele systemet trygt fra infiserte filer. <br> <br> <br>

Microsoft har en innebygd tjeneste i Windows Defender som heter "Ransomware protection". Mekanismen til Ransomware protection funker slik at fremmede filer ikke klarer å få tilgang til de beskyttede mapene som inneholder filene. Dette er implemetert i scriptet. Måten scriptet tar i bruk dette er at det aktiverer tjenesten (dersom den ikke er aktivert), for så å legge de ønskede mappene til listen over beskyttede mapper. Systemfolderne blir automatisk beskyttet når denne tjenesten blir aktivert. <br>

Dette fører oss til siste input som spør brukeren om å taste inn en epost hvis brukeren vil ha rapport fra scriptet. Etter at backupprossessen er ferdig, sender scriptet en rapport på epost til backup-ansvarlig hvis backupen var vellykket. Dersom det oppstod en error så varsler den backup-ansvarlig om at backupen ikke gikk som den skulle. Scriptet varsler også om det ble oppdaget trussler som ikke ble fjernet. Dette er svært viktig for å holde den ansvarlige oppdatert med backup-prossessen.


## Sikkerheten til Scriptet
Hvordan scripet sikrer filene er basert på problempunktene i introen. Det tar utgangspunkt i hvilke angripsvinker ransomware har, og hvilke skader det kan gjøre. det å ta en backup i seg selv vil ikke beskytte mot en ransomware-angrep, men vil redusere angrepets skader. Hvis en uheldig bedrift blir angrepet, så kan bedriften komme tilbake i drift raskest mulig ved gjøre en gjenoppretting. Sikkerheten i å gjøre en backup ligger i at dataene blir lagret i en sky, eller i en ekstern harddisk. Dersom hele systemet blir låst, så har man en sikkerhetkopi av dataene trygt utenfor systemet. Måten jeg kunne sikre backupfilene enda mer på er å holde dem kryptert og låst med et passord slik at inneholdet blir usynlig. Bare administratoren har privilegiet å modifisere filene. <br> <br>
Vi vet fra før at en infisert fil kan få angrepet til å skje, men små detaljer som hvor filen akkurat ligger kan variere. Ved å kjøre en rask virusscan hver dag, så kan vi trygge de viktigste mappene i systemet. Rett etter scanner antivirusen filene som det skal tas backup av. Dette sikrer at hvis det er en infisert fil blant filene, så blir den fjernet før backupen blit tatt. Dersom en feil oppstår og virusene ikke fjernes, så får backupansvarlig en epost som varsler ham om dette. Man kan også gå tilbake til eldre backupversjoner dersom det er noe galt med de nye. I tillegg til disse, så blir det tatt opp en full scan hver helg for å sikre at hele systemet er trygt. Det er også viktig å holde windows defender oppdatert slik at de nye virusene ikke slipper igjennom. 
<br>
Den siste delen av sikkerheten til scriptet er 'Controlled access folder'. Det er den delen som faktisk kan stoppe et angrep fra å skje. Ved å hindre en fremmed applikasjon fra å få tilgang til dataene, så hindrer den et angrep fra å i det hele tatt starte. Antivirus alene kan virke litt ubrukelig dersom den ikke oppdager viruset med en gang, men med 'Controlled access folder' så kan viruset bli stanset fram til antivirus scanner og fjerner den når scriptet her kjører klokken 12. Det er mulig å legge en applikasjon som unntak om ønskelig, dersom man vil at applikasjonen skal kunne få tilgang og ikke bli stoppet. 
<br><br>
Med disse løsningene, så har scriptet oppfylt de tre forskjellige løsningsforslagene som ble nevnt i introen.

## Arbeidsprosessen 
Arbeidsprosessen startet med å gjøre meg mer kjent med powershell. Jeg var så lite kjent med syntaksene, særlig når de er forskjellige fra andre scriptspråk. Men Forskjellen var ikke så stor! At vi lærte linux og java script tidligere har faktisk gjort det lettere for meg å komme fort inn i det. 
<br>
Deretter, Startet jeg å øve meg på gitlab siden jeg så vidt brukt den i programmering ifjord. Denne delen tok ikke stor del av arbeidstiden, men det ble brukt noen timer og videoer.
<br>
Tilslutt så beygnte jeg å førske på metodene man kan beskytte seg selv fra ransomware. Etter å ha lest en del av råd og metoder, kunne jeg forme introen som vi diskuterte i starten som ble grunnlaget til scriptet. <br>
Omformingen av scriptet startet med eksperimentere de ulike måter jeg kunne ta backup på før valget falt på '7-zip'. Etterpå, begynte jeg å få nye ideer og tanker hverdag, som får meg til å leite etter kommandoer og måter jeg kan implementere dem på i scriptet. Med tiden gå, dag etter dag så ble scriptet større og større til den ble til koden dere kan se n.
## kilder
[Link test](www.youtube.com)

