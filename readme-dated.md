

# The Ransomator 
Ransomware angrip er en av de mest tronde angrip som kan ramme et seleskap. Et års arbeid kan forsvinne i et øyeblikk om en ansatt trykker på en feil lenke, og bedriften hevnser seg i en sitiuasjon hvor alle sine arbeid er låst, og da må de betale for å få sine data tilbake. Et slik angrip er veldig frustrernde om man er ikke beskyttet mot dem. <br>
 I prosjektet vårt ble vi bedt om å lage en app for å beskytte mot ransomware, men for å lage appen som skal beskytte mot ransomware, så må vi kartlegge hvilke vinkler angriper ransomware fra, og hvordan den gjennomføres. <br>
 IFløge [Wikepedia](https://en.wikipedia.org/wiki/Ransomware) så ransomware er en infisert Fil som ser veldig legetimt ut. Svinderen prøver å overtale ofret til å laste ned og kjøre filen som inneholder en kode som svindeleren vil kjør den på ofret sin pc. Dette fører til at alle data i ofret sin pc blir kryptert og låst. Ofret får kanskje tilbake dataene sine om han betale, men det er ikke noe garanti på det. Det er ikke nok at han ikke får dataene sine om han ikke betale, men kan også truet med at alle data som ble stjelt kan publeseres offentlig. ut fra det kan vi konkludere de følgende problemer som vi skulle finne en løsning til <br>

 <ol>
 <li>Det er sannsynlig at du ikke får de stjelte dataene tilbake.</li>
 <li>Det er en infisert file som kan kjøre en ondsinnet kode på bakgrunn som kan aksessere datane inni pcen.</li>
  </ol>

  De forrige punktene som vi diskuterte ble grunnlage til sammensettningen til scriptet mitt. ved å se angripsvinkene, kan man tenke på hvordan skal man beskytte sitt arbeid mot ransomware. dette fikk meg til å kunkludere disse.

<ol>
 <li>Beste måte å beskytte arbeidet til en bedrift er å lage en beskyttet kopi av dataene externt</li>
 <li>Å holde antivirus oppdatert men en regelmessig skanning kan hindre infiserte koder fra å bli varende.</li>
 <li>Å holde arbeids- og operativsystemfilene beskyttet mot fremmede applikasjoner kan hindre at en ransomware tar start.</li>
  </ol>


## Hva scripet gjør
Jeg lagde et script som hovedsaklig tar en daglig backup til dataene som blir laget. Scriptet starter med å laste ned og installerer de nødvendlig verktøy for å få prossessen til å skje. Scriptet benytter seg av en extern app som heter 7-zip. Jeg valgte å bruke 7-zip fordi den har de alle funksjonene jeg trengte til å ta en sikker backup. <br> <br>
Når scriptet kjøres, så spør den om fire forskjellige inputer. Appen starter med å spør om hvilke filer som det skal bli tatt backup av, de kan være fra forskjellige kilder, og hvor skal de bli plassert. Det er mulig å gjøre at den tar backup til forskjellige eksterne destinasjoner om man vil ha mer enn en backup. 
Etter å ha gitt de første to inputer, spør appen brukeren om å sette et passord til filene som ble tatt backup av. Dette fører til at Backup filen blir låst med det ønskede passord, og blir kryptert slik at inneholde av backup filen blir usynlig. Setting av passord er valgfritt, og man kan velge å ikke ha passord med å ikke taste inn passord i inputfeltet. Backup filer som blir laget er kompressert med 7z, og dette kan hjelpe med å minke størrelsen til Backupfilene.<br>

Jeg lagde to varianter av samme scriptet, og den andre varianten er med innebydg schedulerfunksjon. Dette gjøre at etter å tastet de fire ønskede inputer, så kan scriptet automatisk kjøres daglig med de samme tastede info. Jeg valgte å sette at prossesen skal skje hverdag kl 12:00am, nemlig når det er minst mulig som belaster netverket. På vanlige <br> <br>

Backup prossessen i helen er litt forskjellig enn andre dager. På de vanlige dager så tar scriptet en inkrementel-backup. Dette betyr at det er bare de modifiserte filene som blir tatt med, og hvis en fil blir slettet, så blir den også slettet fra BackupFilen. Rett før en backup blir tatt, så blir Windows Defender activert om den er ikke det, og så blir den holdt oppdatert for en maximal sikkerhet, Deretter så starter den en rask antivirus skan, itillegg til skanning av folder-path som blir tatt backup av, og så sletter eventuelle trusler om de blir oppdaget. <br>

I helga så blir det tatt en Full-Backup isteden merkert med dato av dagens backup. Dette betyr at det blir laget en ny bilde av datane hver uke, og man kan gå tilbake til eldre utgaver av Dataene. Rett før det så blir det kjørt en Full-Antivirus scan for å holde hele systemet trygt fra infiserte filer som kan kjøre på bakgrunn. <br> <br> <br>

Microsoft har en innebygd tjeneste i Windows Defender som heter 'Ransomware protection'. Mekanismen til 'Ransomware protection' gjøre at fremmede filer/applikasjoner klarer ikke å aksissere de beskyttede filene. Dette klarte jeg å implemetere i scriptet. Måten den virke på er at den aktivere denne tjenesten dersom den ikke er aktivert, og så legger den de folderne som inneholder dataene som en beskyttet folder. Systemfolderne blir automatisk beskyttet når denne tjenesten blir aktivert. <br>

Det leder oss til det siste input som spør brukeren om å taste inn en epost om brukeren vil ha rapport fra scriptet. Etter å ha backup prossessen ferdig, så sender scriptet en rapport epost til backup-ansvarlig om backup var vellyket. Dersom det ble en error, så varsler den backup-ansvarlig om at backup-en gikk ikke som den skulle. Scriptet varsler også om det ble oppdaget trusler som ikke ble fjernet. Dette er svart viktig til å holde ansvarligen oppdatert med backup-prossessen.


## Sikkerheten til Scriptet
Sikkerheten til scriptet baserte seg på hvilke angripsvinker ransomware kan skje på. Å ta en backup i seg selv vil ikke beskytte mot en ransomware angrip, men minker skadene til angripen. Hvis det er en uheldig bedrift som blir angripet, så kan bedriften komme tilbake i drift raskest mulig ved gjøre en restore. Sikkerheten i å gjøre en backup ligger i at de blir lagret i sky, eller i en ekstern harddisk. Dersom hele systemet blir låst, så har den en sikkerhetkopi av dataene trygt utenfor systemet. Måten jeg kunne sikkre Backup filene enda mer på er å hold dem kryptert, og låst med en et passord slik at inneholder blir usynnlig, og bare administratoren som har privilegiene til å modifisere filene. <br> <br>
Vi vet fra før at det er en infisert fil som kan få angripen til å skje, men små detaljer som hvor akurate ligger filen kan variere. Ved å kjøre en rask virus-scan hverdag, så kan vi sikre de meste viktigste mappene i systemet som virusene kan hevne seg på. Samtidig som det skjer, så skanner antivirusen filene som skal bli tatt backup til, dette sikrer at hvis det er en infisert fil blant filene, så blir dem fjerne før backup blir tatt. Dersom en error skje, og virusene blir ikke fjernet, så får backup-ansvarlig en epost som varsler ham for dette. Man kan også gå tilbake til eldre backup versjoner dersom det er noe galt med de nyere. Itillegg til disse, så blir det tatt opp en Full-scan hver helg for å sikre at hele systemet er trygt. Det er også viktig  å hold windows defender oppdatert slik at de nye virusene slipper ikke gjennom. 
<br>
Siste delen av sikkerheten til scriptet er 'Controlled access folder'. Det er den delen egentlig som kan stoppe et angrep fra å skje. Ved å hindre en fremmed applikasjon fra å aksessere dataene, så hindrer det et angrep fra å i det hele tatt starte. Antivirus alein kan virke litt brukløs dersom den ikke oppdager viruset med engang, men med 'Controlled access folder' så kan viruset bli stanset til antivirus skanner og fjerner den når scriptet her kjører. Det er mulighet for legge en applikasjone som unntak ved ønsket.
<br><br>
Med disse løsningene, så har vi oppfylt de tre forskjellige løsningsforslagene som vi nevnte tidligere i intoen.

## Arbeidsprocessen 
Arbeidsprosessen startet med å gjøre meg mer kjent med powershell. Jeg var så lite kjent med syntaksene, særlig når de er forskjellige fra andre scriptspråker. Men Forskjellen var ikke så stort! At vi lært linux og java script tidligere har faktisk gjord det letter for meg å kom fort inn i det. 
<br> 
Deretter, Startet jeg å øve meg på gitlab siden jeg så vidt brukt den i programmering ifjord. Denne delen tok ikke stor del av arbeidstiden, men det ble brukt noen timer og videoer.
<br>
Tilslutt så beygnte jeg å førske på metodene man kan beskytte seg selv fra ransomware. Etter å ha lest en del av råd og metoder, kunne jeg forme introen som vi diskuterte i starten som ble grunnlaget til scriptet. <br>
Omformingen av scriptet startet med eksperimentere de ulike måter jeg kunne ta backup på før valget falt på '7-zip'. Etterpå, begynte jeg å få nye ideer og tanker hverdag, som får meg til å leite etter kommandoer og måter jeg kan implementere dem på i scriptet. Med tiden gå, dag etter dag så ble scriptet større og større til den ble til koden dere kan se idag.

## kilder
Kildene jeg brukte var mange. Jeg nesten sjekket sytaksene til nesten alle komandoer jeg brukte. Her ramser jeg opp 
[If App Installed Check](https://community.spiceworks.com/topic/2205047-powershell-to-check-for-installed-app-if-app-not-installed-install-it)
[Chocolatey Cheetsheet](https://adamrushuk.github.io/cheatsheets/chocolatey/)
[Documentasjoner til 7-zip](https://sevenzip.osdn.jp/chm/cmdline/syntax.htm) [2](https://superuser.com/questions/544336/incremental-backup-with-7zip)
[Get Credentials Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.1)
[Send-Mail Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage?view=powershell-7.1)
[Check if command has run successfully](https://stackoverflow.com/questions/8693675/check-if-a-command-has-run-successfully)
[Controlled Access Folders](https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-atp/controlled-folders)
[Register-Schedulejob](https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/register-scheduledjob?view=powershell-5.1)
[Tok noen tanker herfra](https://www.youtube.com/watch?v=vq1QEio8JDw)

