/*

	PARAMETRI CONTENUTI NELLA CARTELLA "BILANCI"
	DEL FORM "PARAMETRI MENU_PARAALL"

*/


--- CODICE RAGRUPPAMENTO CONTABILE
delete from para where codice = 'RGC1.'
insert into para (codice,descri,LIBERA) values ('RGC1.','ATTIVO PATRIMONIALE','')



--- CODICE RAGRUPPAMENTO CONTABILE
delete from para where codice = 'RGC2.'
insert into para (codice,descri,LIBERA) values ('RGC2.','PASSIVO PATRIMONIALE','')


--- CODICE RAGRUPPAMENTO CONTABILE
delete from para where codice = 'RGC3.'
insert into para (codice,descri,LIBERA) values ('RGC3.','CONTO ECONOMICO RICAVI','')


--- CODICE RAGRUPPAMENTO CONTABILE
delete from para where codice = 'RGC4.'
insert into para (codice,descri,LIBERA) values ('RGC4.','CONTO ECONOMICO:COSTI ESERCIZIO','')


--- CODICE RAGRUPPAMENTO CONTABILE
delete from para where codice = 'RGC6.'
insert into para (codice,descri,LIBERA) values ('RGC6.','CHIUSURE ESERCIZIO','')


--- CODICE RAGRUPPAMENTO CONTABILE
delete from para where codice = 'RGC7.'
insert into para (codice,descri,LIBERA) values ('RGC7.','CONTI ORDINE','')


select * from para where codice LIKE 'RGC%'



