/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'NUMFVS%'

insert into para (codice,descri,libera) values ('NUMFVS01','Numerazione fatture di vendita in sospensione iva','   0000')


select * from para where codice like 'NUMFVS%'

