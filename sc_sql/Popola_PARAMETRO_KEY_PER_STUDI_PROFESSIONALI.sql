/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'KEY%'

insert into para (codice,descri,libera) values ('KEY00010','Chiave di accesso per determinare 13ma mensilità zucchetti','8822')
insert into para (codice,descri,libera) values ('KEY00020','Chiave di accesso per determinare 14ma mensilità zucchetti','8822')
insert into para (codice,descri,libera) values ('KEY00030','Chiave di accesso per determinare co.co.pro zucchetti','Co.Co.Co')
insert into para (codice,descri,libera) values ('KEY00040','Chiave di accesso per determinare TFR zucchetti','9830')
insert into para (codice,descri,libera) values ('KEY00050','Chiave di accesso per determinare anticipo TFR zucchetti','0184')
insert into para (codice,descri,libera) values ('KEY00060','Chiave di accesso per determinare BORSISTI zucchetti','Borsista')


select * from para where codice like 'KEY%'

