/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'FSDPDF%'

insert into para (codice,descri,libera) values ('FSDPDF','SOTTODIRECTORY PER STAMPE PDF GENERICHE','DOCUMENTI-GENERICI')


select * from para where codice like 'FSDPDF%'

