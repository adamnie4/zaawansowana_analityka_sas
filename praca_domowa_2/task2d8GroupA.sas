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
*zlogarytmuje zmienna celu bo tak robilem wczesniej;


ods text="*******";
ods text="Tytul: Praca domowa nr 2";
ods text="Autorzy: Grupa 1 (A), Radomska, Niewiadomski, Makaruk, Bajuk, Gulczynski";
ods text="date: 08/11/2022";
ods text="*******";

title "Raport biznesowy";

*wybieramy zmienne ktore zostaly wybrane w zadaniu nr 1 i pozbywamy sie blednych wartosci;
data beeps;
	set beeps01;
	keep n2p n2a bmb3;
run;
*odpowiedzi nie wiem zamieniamy na braki danych:;
data beeps;
	set beeps;
	if bmb3 = -9 then bmb3 = .;
	if n2a = -9 then n2a = .;
	if n2p = -9 then n2p = .;
run;
*zlogarytmuje zmienna celu bo tak robilem wczesniej;
data beeps;
	set beeps;
	ln_n2p = log(n2p);
	drop n2p
run;

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Ponizej prezentujemy liczbe brakow danych dla zmiennej celu przed przystapieniem do pracy:}";

ods select  MissingValues ;
proc univariate data=beeps NORMAL;;
 var ln_n2p;
run;
ods text='Zgodnie ze wskazowkami prowadzacego (po 1 zadaniu) uznajemy, ze braki danych w naszych zmiennych nie sa typu MCAR w zwiazku z czym ich usuniecie nie bedzie dobrym pomyslem.
Wiaze sie to z tym, ze przykladowo badana przez nas zmienna celu jaka sa koszty sprzedazy z pewnoscia zalezy od wartosci innych zmiennych jak i samej siebie (firmy moga nie chciec dzielic sie informacja o tym jakie ponosza koszty)';
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Weryfikacja wzorca brakujacych danych:}";
*weryfikacja wzorca naszych brakow danych;
proc mi data=beeps nimpute=0;
var ln_n2p n2a bmb3;
run;
ods text='Niestety wzorzec naszych danych nie jest monotoniczny, co wiecej w naszym przypadku nie sprawdza
sie metody Complete-case analysis i available-case analysis poniewaz odsetek braków danych jest duzy';
ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Wykonanie procedury PROC MI:}";
ods text='stosujemy metode mcmc (monte carlo dzialajaca na podstawie lancuchow markowa
dziala ona przy zalozeniu ze mamy doczynienia z rozkladem normalnym i to zalozenie jest spelnione';
*metoda fcs bylaby zastosowana jesli mielibysmy skokowa zmienna celu; 
ods text='Podczas pracy natknelismy siê na problem z nastepujacym bledem: Each observation has analysis variables either all missing or all observed in the data set.
jak wyszukalismy w internecie powodem byla zbyt mala ilosc brakow dla zmiennej bmb3 (4) i konieczne bylo ich usuniecie aby program dzialal poprawnie';

data beeps;
	set beeps;
	if bmb3 = . then delete;
run;

proc sort data=beeps out=beeps_01;
 by bmb3;
run;

ods select ParameterEstimates;
proc mi data= beeps_01 out= beeps_02 seed=2022 nimpute=100 ;
	var ln_n2p n2a;
	by bmb3;
	mcmc initial=em;
run;


ods text='Po pierwszym wykonaniu procedury (zakladajac 100 imputacji) wska¿nik Wydajnoœci wzglêdnej 
znajdowa³ siê powy¿ej 0.99 (kryterium z zajec) w zwiazku z czym postanowilismy sprobowac zmniejszyc ilosc imputacji';

*Przy 90,80 imputacjach wskaznik nadal znajdowal sie powyzej 0.99;
/*
proc mi data= beeps_01 out= beeps_02 seed=2022 nimpute=90 ;
	var ln_n2p n2a;
	*by bmb3;
	mcmc initial=em;
run;

proc mi data= beeps_01 out= beeps_02 seed=2022 nimpute=80 ;
	var ln_n2p n2a;
	*by bmb3;
	mcmc initial=em;
run;
proc mi data= beeps_01 out= beeps_02 seed=2022 nimpute=45 ;
	var ln_n2p n2a;
	*by bmb3;
	mcmc initial=em;
run;
*/
Ods text='W kolejnych krokach zmniejszalismy ilosc imputacji tak aby sprawdzic jaka najmniejsza ilosc
pozwoli nam pozostac powyzej 0.99 wydajnosci wzglednej. Udalo sie nam ustalic, ze najnizsza wartosc to 47';

ods text="(*ESC*){style[font_style=italic just=c fontweight=bold fontsize=10pt]
 Wyniki dla 47 imputacji:}";
proc mi data= beeps_01 out= beeps_02 seed=2022 nimpute=47 ;
	var ln_n2p n2a;
	*by bmb3;
	mcmc initial=em;
run;
