/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'ESC%'

insert into para (codice,descri,libera) values ('ESC00010','Azienda distaccante           :PER ORA NON CONSIDERARE','Non contare cedolini Zucchetti')
insert into para (codice,descri,libera) values ('ESC00020','Agenzia di somministrazione   :PER ORA NON CONSIDERARE','Non contare cedolini Zucchetti')


select * from para where codice like 'ESC%'
/* select * from para where codice like 'ESC%' and descri = 'Agenzia di somministrazione   :' */
