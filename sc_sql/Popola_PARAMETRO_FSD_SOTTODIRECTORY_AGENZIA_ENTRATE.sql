/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'FSDAGE%'

insert into para (codice,descri,libera) values ('FSDAGE','SOTTODIRECTORY PER INVIO TELEMATICO SPESOMETRO','SPESOMETRO\')


select * from para where codice like 'FSDAGE%'

