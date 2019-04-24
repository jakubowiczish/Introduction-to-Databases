use library

/* 1 */

/*
Napisz polecenie select, za pomocą którego uzyskasz tytuł i
numer książki
*/
select title, title_no
from title


/* Napisz polecenie, które wybiera tytuł o numerze 10 */
select title
from title
where title_no = 10
/* select item.isbn, title.title from item, title where item.title_no = 10 */


/*
Napisz polecenie, które wybiera numer czytelnika, isbn, numer
książki (egzemplarza) i naliczoną karę dla wierszy, dla których
naliczone kary są pomiędzy $8.00 a $9.00
*/
select title.title_no, loanhist.isbn, fine_assessed, copy.copy_no
from title,
     loanhist,
     copy
where fine_assessed between 8 and 9;


/*
Napisz polecenie select, za pomocą którego uzyskasz numer
książki (nr tyułu) i autora z tablicy title dla wszystkich książek,
których autorem jest Charles Dickens lub Jane Austen
 */
select title_no, author
from title
where author = 'Charles Dickens'
   or author = 'Jane Austen'

/*
Napisz polecenie, które wybiera numer tytułu i tytuł dla
wszystkich rekordów zawierających słowo „adventures” gdzieś
w tytule.
*/
select title, title_no
from title
where title like '%adventures%'

/*
Napisz polecenie, które wybiera numer czytelnika, oraz
zapłaconą karę
 */
select title, title.title_no, fine_paid
from title,
     loanhist;

/*
Napisz polecenie, które wybiera wszystkie unikalne pary miast i
stanów z tablicy adult
 */
select distinct city, state
from adult


/*
Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i
wyświetla je w porządku alfabetycznym
 */
select title
from title
order by title asc

/*
wybiera numer członka biblioteki (member_no), isbn książki
(isbn) i watrość naliczonej kary (fine_assessed) z tablicy
loanhist dla wszystkich wypożyczeń dla których naliczono
karę (wartość nie NULL w kolumnie fine_assessed)
 */
select member_no, isbn, fine_assessed
from loanhist
where fine_assessed is not null

/*
stwórz kolumnę wyliczeniową zawierającą podwojoną
wartość kolumny fine_assessed
 */
select fine_assessed * 2
from loanhist
where fine_assessed is not null

/*
stwórz alias ‘double fine’ dla tej kolumny
 */
select fine_assessed * 2 as 'double fine'
from loanhist
where fine_assessed is not null


/*
generuje pojedynczą kolumnę, która zawiera kolumny:
firstname (imię członka biblioteki), middleinitial (inicjał
drugiego imienia) i lastname (nazwisko) z tablicy member dla
wszystkich członków biblioteki, którzy nazywają się
Anderson
 */
select concat(firstname, ' ', middleinitial, ' ', lastname)
from member
where lastname = 'Anderson'

/*
nazwij tak powstałą kolumnę email_name (użyj aliasu
email_name dla kolumny)
 */
select concat(firstname, ' ', middleinitial, ' ', lastname) as email_name
from member
where lastname = 'Anderson'

/*
zmodyfikuj polecenie, tak by zwróciło „listę proponowanych
loginów e-mail” utworzonych przez połączenie imienia
członka biblioteki, z inicjałem drugiego imienia i pierwszymi
dwoma literami nazwiska (wszystko małymi małymi literami).
§ Wykorzystaj funkcję SUBSTRING do uzyskania części kolumny
znakowej oraz LOWER do zwrócenia wyniku małymi literami.
Wykorzystaj operator (+) do połączenia stringów.
 */
select lower(firstname + middleinitial + substring(lastname, 1, 2))
from member

/*
Napisz polecenie, które wybiera title i title_no z tablicy title.
§ Wynikiem powinna być pojedyncza kolumna o formacie jak w
przykładzie poniżej:
The title is: Poems, title number 7

Czyli zapytanie powinno zwracać pojedynczą kolumnę w
oparciu o wyrażenie, które łączy 4 elementy:
stała znakowa ‘The title is:’
wartość kolumny title
stała znakowa ‘title number’
wartość kolumny title_no
 */
select concat('The title is: ', title, ', title number ', title_no)
from title


