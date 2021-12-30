/*
Széchenyi István Egyetem
Gépészmérnöki, Informatikai és Villamosmérnöki Kar
Informatika Tanszék

Modellezés és optimalizálás a gyakorlatban
GKLB_INTM019

Debnárik Roland
Mérnökinformatikus BSc

*/


param vallakozok;
param cimpenz;
param csomagok;
set VALLAKOZOK := 1..vallakozok;

set CSOMAGOK := 1..csomagok;

set VALLAKOZO_FIZETES := 1..vallakozok;

param kapacitas{VALLAKOZOK};

param fizetesek{VALLAKOZO_FIZETES};

param csomagMeret{CSOMAGOK};

param uzemanyagDij{VALLAKOZOK};

param cimPenz := cimpenz;

param CsomagVallakozoUtvonal{CSOMAGOK, VALLAKOZOK};

var vallViheti{CSOMAGOK, VALLAKOZOK}, binary;

var vallMegy{VALLAKOZOK}, binary;


csomagFerjenFelaKocsiraEsUtvonalonLegyen{vall in VALLAKOZOK}:
      sum{csom in CSOMAGOK} csomagMeret[csom] * vallViheti[csom,vall] <= kapacitas[vall] * vallMegy[vall];

ferjenFelAzOsszesCsomagKocsira:
      sum{vall in VALLAKOZOK} kapacitas[vall] * vallMegy[vall] >= sum{csom in CSOMAGOK} csomagMeret[csom];


utvonalonLegyenaCim{vall in VALLAKOZOK, csom in CSOMAGOK}:
      vallViheti[csom,vall] <= vallMegy[vall];

vallAmiUtvonalon{csom in CSOMAGOK}:
      sum{vall in VALLAKOZOK} CsomagVallakozoUtvonal[csom,vall] * vallViheti[csom,vall] = 1;
      

minimize osszKiadas: (sum {vall in VALLAKOZOK} uzemanyagDij[vall] * vallMegy[vall]) + (sum{vallFiz in VALLAKOZO_FIZETES} fizetesek[vallFiz] * vallMegy[vallFiz]) + (sum{csom in CSOMAGOK, vall in VALLAKOZOK} vallViheti[csom,vall] * cimPenz) ;

solve;

printf "\nOssz kiadasa a vallalatnak a vallalkozok iranyaba: %s\n\n", (sum {vall in VALLAKOZOK:vallMegy[vall]==1} uzemanyagDij[vall] * vallMegy[vall])
			+ (sum{vallFiz in VALLAKOZO_FIZETES} fizetesek[vallFiz] * vallMegy[vallFiz])
			+ (sum{csom in CSOMAGOK, vall in VALLAKOZOK} vallViheti[csom,vall] * cimPenz);
			
for {v in VALLAKOZOK:vallMegy[v]==1}{
	printf "Melyik vallakozo szallit: %d\n", v;
		for{cs in CSOMAGOK:vallViheti[cs,v]==1}{
			printf "\tKiszallitott csomagok: %s\n", cs;
		}
		printf "Vallakozo bevételei:\n";
		printf "\tUtvonal dij: %s\n", fizetesek[v];
		printf "\tUzemanyag dij: %s\n", uzemanyagDij[v];
		printf "\tCimpenz: %s\n", (sum{csom in CSOMAGOK} vallViheti[csom,v] * cimPenz);
		printf "\n\n";
}


data;

param vallakozok := 10;
param csomagok:= 20;
param cimpenz := 300;

param kapacitas :=
      1 800 
	  2 600
	  3 400
	  4 400
	  5 200
	  6 600
	  7 400
	  8 200
	  9 800
	 10 200;

param fizetesek :=
	1 35000
	2 25000
	3 18000
	4 17500
	5 14000
	6 22750
	7 21800
	8 13990
	9 32500
	10 16500;

param csomagMeret :=
	1	70
	2	100
	3	30
	4	70
	5	60
	6	20
	7	10
	8	70
	9	30
	10	80
	11	40
	12	80
	13	20
	14	60
	15	40
	16	70
	17	80
	18	70
	19	40
	20	90;


param uzemanyagDij :=
      1 22000
	  2 18500
	  3 16000
	  4 15500
	  5 12000
	  6 18000
	  7 15500
	  8 10000
	  9 19800
	 10 10000;

param CsomagVallakozoUtvonal (tr):
	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20 :=
1	0	1	1	0	0	0	0	0	0	1	0	0	1	1	1	0	0	0	0	0
2	0	1	0	1	0	0	1	0	0	0	0	0	1	1	1	1	0	0	1	1
3	1	1	1	0	1	1	0	1	0	1	0	1	1	0	0	1	0	1	0	1
4	0	0	0	1	0	1	0	0	1	0	1	1	1	1	1	0	1	1	1	0
5	1	0	1	0	1	1	0	1	0	1	0	0	1	1	1	1	1	0	0	1
6	0	0	1	0	1	1	0	1	1	0	0	0	0	1	0	0	1	0	1	0
7	0	1	1	0	1	1	0	1	0	1	1	0	0	1	1	0	1	1	0	1
8	1	1	1	0	1	0	0	0	0	1	1	1	1	1	1	0	1	0	1	0
9	0	0	0	0	1	1	0	0	1	0	0	1	1	0	1	0	1	0	1	1
10	1	1	0	1	1	0	0	0	0	1	0	1	1	0	0	0	1	1	1	1;


end;
