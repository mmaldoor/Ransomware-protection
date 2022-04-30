[Linken To The Repository](https://gitlab.stud.idi.ntnu.no/mmaldoor/ransomware-protection)
# The Ransomator 
Ransomware angrep er en av de største truslene mot et selskap. Et års arbeid kan forsvinne i løpet av et øyeblikk om en ansatt trykker på en feil lenke, og bedriften havner i en situasjon hvor alt arbeidet er låst, og de må betale for å få disse dataene tilbake. Et slikt angrep kan være veldig frustrernde dersom man ikke er beskyttet imot det. <br>
 I prosjektet vårt ble vi bedt om å lage en app som beskytter mot ransomware. For å lage denne appen må det kartlegges hvilke vinkler ransomware angriper fra, og hvordan det gjennomføres. <br>
 Ifølge [Wikepedia](https://en.wikipedia.org/wiki/Ransomware) så er ransomware en infisert fil som ser veldig legitim ut. Svindleren prøver å overtale offeret til å laste ned og kjøre en fil som inneholder en kode som svindeleren vil kjøre på offeret sin pc. Dette fører til at alle data i offerpcen blir kryptert og låst. Offeret får kanskje tilbake dataene sine dersom han betaler, men det er ingen garanti for dette. Ikke bare er det mulig at vedkommende ikke får igjen dataene selv om han betaler, men han kan også bli truet med offentliggjøring av stjålet data. Basert på dette kan vi konkludere med følgende problemer som vi skal finne en løsning på <br>

 <ol>
 <li>Det er sannsynlig at du ikke får de stjelte dataene tilbake.</li>
 <li>Det er en infisert fil som kan kjøre en ondsinnet kode i bakgrunnen, og få tilgang til datane inni pcen.</li>
  </ol>

  De overnevnte punktene ble grunnlaget for sammensettningen av scriptet mitt. Ved å se på angrepsvinklene, kan man tenke ut hvordan man skal beskytte arbeidet sitt mot ransomware. Dette kan man gjøre på følgende måte:

<ol>
 <li>Ta en ekstern datakopi. Dette er den beste måten å beskytte sine data. Rett og slett lage en beskyttet kopi av dataene eksternt</li>
 <li>Hold antivirus oppdatert, og scan regelmessig for å hindre infiserte koder fra å bli værende.</li>
 <li>Hold arbeids- og operativsystemfilene beskyttet mot fremmede applikasjoner. Det kan hindre at en ransomware starter.</li>
  </ol>


## Scriptets funksjon
Jeg lagde et script som hovedsaklig tar en daglig backup av dataene som blir laget. Scriptet må først og fremst kjøres som <b>Administrator</b>. Dette gir bare administratoren rettigheten til å kjøre scriptet. Scriptet begynner med å laste ned og installere de nødvendige verktøyene som skal til for å få prossessen til å skje. Scriptet benytter seg av en ekstern app som heter 7-zip. valget falt på 7-zip fordi den har alle de funksjonene som skal til for å ta en sikker backup. <br> <br>
Når scriptet kjøres, så spør det om fire forskjellige inputer. Appen starter med å spørre om hvilke filer det skal tas backup av, hvilke kilder de kommer fra og hvor de skal plasseres. Det er mulig å få appen til å sende backup til flere ulike eksterne destinasjoner dersom man vil ha mer enn en backup, noe som er enda tryggere. 
Etter å ha gitt de første to inputene, spør appen brukeren om å lage et passord til backupfilene. Dette fører til at backupfilen blir låst med det ønskede passordet, og blir kryptert slik at filens innhold blir usynlig. Laging av passord er valgfritt, og man kan velge å ikke ha passord ved å la være å taste inn passord i inputfeltet. Backupfiler blir kompressert med 7z, noe som kan hjelpe med å krympe størrelsen på filene.<br>

I tillegg lagde jeg en Task-Scheduler som kan automatisere kjøring. Dette gjør at etter å ha tastet de fire ønskede inputene så kan scriptet automatisk kjøres daglig med de samme inntastede info. Jeg valgte å sette opp at prossesen skal skje hver dag kl 12:00 am, nemlig når det er minst mulig som belaster nettverket. <br> <br>

Backupprossessen i helgene er litt ulik hverdager. På hverdager så tar scriptet en inkrementel-backup. Dette betyr at det er bare de modifiserte filene som blir tatt med, og hvis en fil blir slettet, så blir den også slettet fra backupfilen. Rett før en backup blir tatt, så blir Windows Defender aktivert (dersom den ikke allerede er det) og holdt oppdatert for maksimal sikkerhet. Deretter starter den en rask antivirusscan, i tillegg til scanning av folder-pathen som det blir tatt backup av, og så slettes eventuelle trussler som blir oppdaget. <br>

I helgene så blir det isteden tatt en full backup markert med datoen til dagens backup. Dette betyr at det blir laget et nytt bilde av datane hver uke, og man kan gå tilbake til eldre utgaver av dataene hvis man ønsker. Rett før det så blir det kjørt en full Antivirus scan for å holde hele systemet trygt fra infiserte filer. <br> <br> 

Microsoft har en innebygd tjeneste i Windows Defender som heter "Ransomware protection". Mekanismen til Ransomware protection funker slik at fremmede filer ikke klarer å få tilgang til de beskyttede mappene som inneholder filene. Dette er implemetert i scriptet. Måten scriptet tar i bruk dette er at det aktiverer tjenesten (dersom den ikke er aktivert), for så å legge de ønskede mappene til listen over beskyttede mapper. Systemfolderne blir automatisk beskyttet når denne tjenesten blir aktivert. <br>

Dette fører oss til siste input som spør brukeren om å taste inn en epost hvis brukeren vil ha rapport fra scriptet. Etter at backupprossessen er ferdig, sender scriptet en rapport på epost til backup-ansvarlig hvis backupen var vellykket. Dersom det oppstod en feil så varsler den backup-ansvarlig om at backupen ikke gikk slik som den skulle. Scriptet varsler også om det ble oppdaget trussler som ikke ble fjernet. Dette er svært viktig for å holde den ansvarlige oppdatert i backup-prossessen.

### Ting jeg ikke klarte å fikse

Scriptet tar fire Inputer hvorav to av dem er valgfrie. 'Job Scheduler' bruker et parameter -Argumentlist, som overleverer argumentene til scriptet. Problemet ligger i at hvis et 'Argument' er skrevet etter '-Argumentlist', så må det gis en verdi til argumentet, ellers så vil 'Job Scheduler' gi en feilmelding. Dette tar bort fordelen med at passord- og epostinputfelter er valgfrie. Jeg forsøkte å spørre om hjelp, men fikk ikke svar som kunne hjelpe meg med å fikse dette. På grunn av at tiden var litt knapp, valgte jeg å ikke bruke mer tid på dette problemet, men gå over til å skrive rapporten istedet.


## Sikkerheten til Scriptet
Hvordan scripet sikrer filene er basert på problempunktene i introen. Det tar utgangspunkt i hvilke angripsvinker ransomware har, og hvilke skader det kan gjøre. Det å ta en backup i seg selv vil ikke beskytte mot et ransomware-angrep, men vil redusere angrepets skader. Hvis en uheldig bedrift blir angrepet, så kan bedriften komme tilbake i drift raskest mulig ved gjøre en gjenoppretting. Sikkerheten i å gjøre en backup ligger i at dataene blir lagret i en sky, eller i en ekstern harddisk. Dersom hele systemet blir låst, så har man en sikkerhetkopi av dataene trygt utenfor systemet. Måten jeg kunne sikre backupfilene enda mer på er å holde dem kryptert og låst med et passord slik at inneholdet blir usynlig, og bare administratoren har privilegiet å kunne modifisere filene. <br> <br>
Vi vet fra før at en infisert fil kan få angrepet til å skje, men små detaljer som hvor nøyaktig filen ligger kan variere. Ved å kjøre en rask virusscan hver dag, så kan vi trygge de viktigste mappene i systemet. Rett etter scanner antivirusen filene som det skal tas backup av. Dette sikrer at hvis det er en infisert fil blant filene, så blir den fjernet før backupen blit tatt. Dersom en feil oppstår og virusene ikke fjernes, så får backupansvarlig en epost som varsler ham om dette. Man kan også gå tilbake til eldre backupversjoner dersom det er noe galt med de nye. I tillegg til disse, så blir det tatt en full scan hver helg for å sikre at hele systemet er trygt. Det er også viktig å holde windows defender oppdatert slik at de nye virusene ikke slipper igjennom. 
<br>
Den siste delen av sikkerheten til scriptet er 'Controlled access folder'. Det er den delen som faktisk kan stoppe et angrep fra å skje. Ved å hindre en fremmed applikasjon fra å få tilgang til dataene, så hindrer den et angrep fra å i det hele tatt starte. Antivirus alene kan virke litt ubrukelig dersom den ikke oppdager viruset med en gang, men med 'Controlled access folder' så kan viruset bli stanset fram til antivirus scanner og fjerner den når scriptet her kjører klokken 12. Det er mulig å legge en applikasjon som unntak om ønskelig, dersom man vil at applikasjonen skal kunne få tilgang og ikke bli stoppet. 
<br><br>
Med disse løsningene, så har scriptet oppfylt de tre forskjellige løsningsforslagene som ble nevnt i introen.

## Arbeidsprosessen 
Arbeidsprosessen startet med å gjøre meg mer kjent med powershell. Jeg var lite kjent med syntaksene, særlig når de er forskjellige i forhold til andre scriptspråk. Men Forskjellen var ikke så stor! At vi lærte Linux og Java script tidligere har faktisk gjort det lettere for meg å komme fort inn i det. 
<br>
Deretter begynte jeg å øve meg på gitlab siden jeg har såvidt brukt det i programmeringen i fjor. Denne delen tok ikke stor del av arbeidstiden, men det ble brukt noen timer og sett noen videoer.
<br>
Til slutt forsket jeg på metodene man kan bruke til å beskytte seg mot ransomware. Etter å ha lest en del om råd og metoder, kunne jeg forme introen som ble diskutert i starten som gav grunnlaget til scriptet. <br>
Utformingen av scriptet begynte med å eksperimentere med de ulike måtene jeg kunne ta backup på, før valget falt på '7-zip'. Etterpå fikk jeg nye ideer og tanker hver dag, som fikk meg til å lete etter kommandoer og måter å implementere dem på i scriptet. Etter som dagene gikk ble scriptet større og større helt til det ble denne koden som dere kan se nå.

## kilder
Det ble brukt utrolig mange kilder. Jeg sjekket syntaksene til nesten alle kommandoene jeg brukte. <br>
[If App Installed Check](https://community.spiceworks.com/topic/2205047-powershell-to-check-for-installed-app-if-app-not-installed-install-it) <br>
[Chocolatey Cheetsheet](https://adamrushuk.github.io/cheatsheets/chocolatey/)<br>
[Documentasjoner til 7-zip](https://sevenzip.osdn.jp/chm/cmdline/syntax.htm) [Andre](https://superuser.com/questions/544336/incremental-backup-with-7zip) <br>
[Get Credentials Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.1) <br>
[Send-Mail Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage?view=powershell-7.1) <br>
[Check if command has run successfully](https://stackoverflow.com/questions/8693675/check-if-a-command-has-run-successfully) <br>
[Controlled Access Folders](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-atp/controlled-folders) <br>
[Register-Schedulejob](https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/register-scheduledjob?view=powershell-5.1) <br>
[Tok noen tanker herfra](https://www.youtube.com/watch?v=vq1QEio8JDw) <br>
[Task Scheduler](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/register-scheduledtask?view=win10-ps) <br>
