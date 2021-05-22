# Projektplan

## 1. Projektbeskrivning (Beskriv vad sidan ska kunna göra).
Jag ska göra en schemaapplikation som visar ditt schema beroende på vilken klass ditt inlogg tillhör. Funktionaliteten av hemsidan inkluderar, att skapa ett konto som kopplas till ett personligt schema, logga in och se ditt schema samt alla registrerade användare. Eftersom det hade varit konstigt om elever kunde redigera sitt eget schema så har istället endast Administratören tillgång till att ändra klassernas scheman samt ta bort användare.
## 2. Vyer (visa bildskisser på dina sidor).

Skiss på sidan (I figma)
![vy](/img/vyer.PNG)


Registreringssidan
![register](/img/register.PNG)
Log in sida
![images](/img/log-in.PNG)
Huvudsidan, En vanlig användare kan bara se sitt eget schema och alla användare men admin (Som är inloggad i nuläget, kan se administratörsinställningarna)
![schema](/img/schema.PNG)
    
En edit sida endast tillgänglig för administratörer. 
![edit](/img/edit.PNG)

## 3. Databas med ER-diagram (Bild på ER-diagram).
![ER-diagram](/img/ER-diagram.PNG)



## 4. Arkitektur (Beskriv filer och mappar - vad gör/innehåller de?).

Projektstrukturen består av ett antal mappar som skiljer sig starkt i funktion från varandra. Först och främst består projektet av ett antal diverse basmappar. Img mappen består av en samling bilder som endast används för dokumentering. Public mappen består endast av ett CSS dokument som ansvarar för all CSS i projektet. Under views finns en slim fil vid namn layout.slim som ansvarar för grundläggande HTML (EX språk och nav bar). Inuti views mappen finns dessutom 3 andra mappar. Users mappen, som finns under views, har alla slim filer som anvarar för hantering av användaren i sig. Dessa inkluderar, login.slim som visar ett formulär för inloggning av användaren och register.slim som visar ett formulär för registrering av användaren. I schedule mappen (Under views) finns index.slim filen som har huvudinnehållet på sig och all funktionalitet för en inloggad användare. På index.slim visas varje användares schema och ifall man är administratör finner man också administratörs inställningar där. I administrator mappen under views finns en slim fil för att administratören ska kunna ändra på varje klass schema.

I basmappen finns de två huvudsakliga ruby filerna, app.rb och model.rb. Model.rb skiljer sig från app.rb eftersom model.rb bara har funktioner i sig som app.rb anropar för att göra app.rb lättare att läsa. Databasen redigeras alltså endast i model.rb. I app.rb finns alla mina get och post routes samt ett before block som kollar om man är inloggad genom sessions. Vi finner också i basmappen en helpers ruby fil som endast har en funktion i sig för att hämta schemat från en specifik klass.

I basmappen finns också mapparna som behövs för yardoc dokumenteringen. Dessa är; .yardoc och doc. Dessa är båda endast till för yardoc dokumentering och dokumenterar koden i projektet.

Sist finns en backup mapp, som namnet föreslår, är en backup av projektet samt en db mapp där databasen finns. Resterande filer i basmappen är antingen obetydliga filer som är relaterade till kursens eller uppgiften (Exempelvis bedömnings)

