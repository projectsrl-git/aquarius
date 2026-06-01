/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'FSDINT%'

insert into para (codice,descri,libera) values ('FSDINT','SOTTODIRECTORY PER INVIO TELEMATICO INTRASTAT','INTRASTAT')


select * from para where codice like 'FSDINT%'

