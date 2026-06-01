/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'DCP%'

insert into para (codice,descri,libera) values ('DCP00010','Cedolini paga programma zucchetti','C:\CEDOLINI\ZUCCHETTI\')
insert into para (codice,descri,libera) values ('DCP00020','Cedolini paga programma copernico','C:\CEDOLINI\COPERNICO\')
insert into para (codice,descri,libera) values ('DCP00030','Cedolini paga programma syspac','C:\CEDOLINI\SYSPAC\')


select * from para where codice like 'DCP%'

