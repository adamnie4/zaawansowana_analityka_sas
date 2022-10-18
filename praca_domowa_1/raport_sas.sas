*Przegladam ciekawe zmienne ktore znalazlem w dokumentacji, w tym celu napisalem proste macro;

%macro ogladanie_zmiennych(zmienna=);
data beeps02;
	set beeps01;
	keep &zmienna;
run;
*warto tez sprawdzic jak wygladaja podstawowe statystyki;
proc means data=beeps02 NMISS N MEAN MEDIAN MAX MIN; run;
%mend;
*stworzenie biblioteki w miejscu gdzie jest plik CSV;
libname mycas 'C:\Users\komeciu\Desktop\STUDIA SGH\sgh sem 3\Zaawansowana analityka biznesowa sila modeli predykcyjnych\zajecia 2\Dane';
*Import pliku CSV jako baze w formacie sasowym;
proc import file='C:\Users\komeciu\Desktop\STUDIA SGH\sgh sem 3\Zaawansowana analityka biznesowa sila modeli predykcyjnych\zajecia 2\Dane\beeps_c.csv'
	out=mycas.beeps
	dbms=csv;
run;
*filtrujemy dane na nasz kraj;
data beeps01;
	set mycas.beeps;
	where country = 'Turkey';
run;
* Wstepny przeglad kandydatow wybranych podczas przegladu dokumentacji:;
*%ogladanie_zmiennych(zmienna= bmb3);
/*
*SZUKANIE KANDYDATA NA ZMIENNA CELU:;
*b3 -> jaki procent firmy jest w posiadaniu najwiekszego udzialowca;
%ogladanie_zmiennych(zmienna= b3);
*c9b -> jakie straty spowodowane przerwami w dostawach pradu;
*nie nada siê bo za du¿o braków danych, az 1573 braki;; 
%ogladanie_zmiennych(zmienna= c9b);
*d3c -> jaki % sprzedazy stanowi direct export (bezposredni);
%ogladanie_zmiennych(zmienna= d3c);
*n2e -> koszt surowych materialow i polproduktow potrzebnych do produkcji w ostatnim roku fiskalnym;
%ogladanie_zmiennych(zmienna= n2e); *umiarkowana l. brakow;
*n2i -> calkowity roczny koszt dobr finalnych/resellerskich ;
%ogladanie_zmiennych(zmienna= n2i); *za duzo brakow na zmienna celu;
*n2p -> calkowity roczny koszt sprzedazy;
%ogladanie_zmiennych(zmienna = n2a); 

*SZUKANIE KANDYDATA NA ZMIENNE OBJASNIAJACE:;
*b7 -> ile lat doswiadczenia w sektorze w ktorym dziala firma ma glowny manager?;
%ogladanie_zmiennych(zmienna = b7); *brak brakow danych 
*a4a -> W jaki sektorze dziala firma;
%ogladanie_zmiennych(zmienna = a4a);
*d12b -> % nak³adów materia³owych i dostaw obcego pochodzenia w ostatnim Roku podatkowy;
%ogladanie_zmiennych(zmienna = b2c);
*/


ods text="*******";
ods text="Tytul: Praca domowa nr 1";
ods text="Autorzy: Grupa 1 (A), Radomska, Niewiadomski, Makaruk, Bajuk, Gulczynski";
ods text="date: 18/10/2022";
ods text="*******";

ods startpage=no;*remove page breaks;

*ZADANIE 1;

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=16pt]
 Zadanie 1}";
ods text="Pytanie badawcze: Co wp³ywa na wzrost kosztu sprzeda¿y przedsiebiorstwa?";
ods text="Hipoteza badawcza: Wzrost kosztu pracy jest dodatnio powiazany ze wzrostem kosztu sprzedazy firmy" ;
ods text="Hipoteza pomocnicza: Posiadanie przez firme okreslonej strategii biznesowej wplywa na zmniejszenie kosztu sprzedazy";

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=16pt]
 Zadanie 2}";
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Sugerowane zmienne objasniajace:}";
ods text=" Calkowity roczny koszt pracy firmy (wyplaty,premie itp.) (n2a)";
ods text=" Posiadanie przez firme formalnie spisanej strategii biznesowej (bmb3)";
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Uzasadnienie:}";
ods text="Zdecydowalismy sie na wybor zmiennej jaka jest calkowity koszt pracy firmy poniewaz wzrost ponoszonych przez firme kosztow
w sposob oczywisty wplywa na wzrost ponoszonych przez nia kosztow sprzedazy w kontekscie ogolnego kosztu. Uwazamy rowniez ze posiadanie 
przez firme zaplanowanej strategii biznesowej powinien doprowadzic do spadku kosztow sprzedazy poniewa planujac miedzy innymi wydatki 
firma jest w stanie ciac koszty i rozwazniej dysponowac budzetem oraz planowac dalszy rozwoj";

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=16pt]
 Zadanie 3}";
 ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Zmienna objasniana d3c:}";

proc sgplot data=beeps01;
	histogram n2p;
run;
*podstawowe miary:;
ods select BasicMeasures extremeobs MissingValues;
proc univariate data=beeps01;
 var n2p;
run;
proc sgplot data=beeps01;
	vbox n2p;
run;
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Wnioski:}";
 ods text= "Na podstawie danych z tabeli i wykresow mozemy stwierdzic ze wybrana przez nas zmienna
 objasniana posiada 600 brakow danych co stanowi 36.08% calosci, mimo tego pozostaje wiele obserwacji niebedacych brakami
 w zwiazku z czym moglibysmy popracowac nad zmienna. Po usunieciu wierszy, ktore cechuja sie brakami pozostaloby okolo 1000 obserwacji
 jednak moznaby probowac wykorzystac inne metody imputacji takie jak uzupelnienie srednia";
 ods text = "W przypadku obserwacji odstajacych zauwazalne sa, te ktore cechuje wartosc -9 co tlumaczy dokumentacja i jest to odpowiedz 'nie wiem' 
 w zwiazku z czym mozemy podejrzewac, ze jest tak rzeczywiscie lub firma nie chciala udzielic informacji, takie obserwacje zostalyby przez nas usuniete";
 ods text= "Na wykresie pudelkowym z drugiej strony zaobserwowac mozna wiele obserwacji odstajacych, ktore cechuja sie ogromnymi liczbami
 jednak w tym przypadku nie jestesmy w stanie dokladnie stwierdzic czy sa to obserwacje bledne poniewaz w zaleznosci od rozmiaru firmy 
 koszty sprzedazy moga byc rozne a w przypadku ogromnych firm moga byc rowniez znacznie wyzsze niz w przypadku pozostalych";
*usunmy wartosci bledne -9;
proc sql;
	delete from beeps01
	where n2p = -9 or n2a = -9;
quit;
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=11pt]
PRZED PRZYSTAPIENIEM DO DALSZEJ PRACY USUNELISMY WARTOSCI BLEDNE '-9' KTORE MOGA ZABURZAC DALSZE WYNIKI:}";

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
Zmienna objasniajaca n2a:}";
ods text="Korelacje Pearsona";
proc corr data=beeps01;
	var n2p n2a;
run;
ods text="Jak widac korelacja pearsona pomiedzy zmienna n2p a n2a wynosi 0.60318 w zwiazku z czym
mozemy mowic o slabej dodatniej zaleznosci pomiedzy wzrostem kosztu pracy a wzrostem kosztu sprzedazy firmy";
ods text="Rowniez na wykresie widoczna jest dodatnia zaleznosc pomiedzy zmiennymi";
ods text="Wydaje sie, ze w tym przypadku nie jest konieczne wykonanie zadnej transformacji";


proc sgplot data=beeps01;
	scatter x=n2p y=n2a;

proc sql;
	delete from beeps01
	where bmb3 = -9;
quit;

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
Zmienna objasniajaca bmb3:}";
proc sgplot data=beeps01;
	vbox n2p / group= bmb3;
run;
ods text= "Gdzie 1- firma posiada sformuowana strategie biznesowa"; 

ods select MissingValues;
proc univariate data=beeps01;
 var bmb3;
run;

data bmb3_m;
	set beeps01;
	keep bmb3;
run;

proc means data=bmb3_m N NMISS; run;

ods text= 'Jak widac w tabeli w przypadku tej zmiennej braki danych nie wystepuja';

proc sort data=beeps01; 
	by bmb3;
run;
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
Braki zmiennej celu wzgledem kategorii zmiennej bmb3:}";
proc means data=beeps01 N NMISS;
	by bmb3;
	var n2p;
run;

ods text="Jak widzimy istnieje dysproporcja w ilosci brakow danych dla zmiennej celu, w przypadku 
kategorii gdzie firma nie posiada strategii liczba brakow jest znacznie wyzsza";

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
Jaka bedzie wielkosc proby jesli wszystkie 3 zmienne uwzglednimy w jednym modelu?:}";

data fin;
	set beeps01;
	keep n2p n2a bmb3;
run;

proc sql;
	delete from fin
	where bmb3 is null or n2a is null or n2p is null;
quit;

proc means data=fin N; run;

ods text="Tak wiec zbior uwzgledniajacy wszystkie zmienne na raz po wykluczeniu brakow danych i wartosci nieprawidlowych
mialby 600 obserwacji";














