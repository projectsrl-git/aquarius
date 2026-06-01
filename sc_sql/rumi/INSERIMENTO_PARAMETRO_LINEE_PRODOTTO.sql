
/********************************************************************
 PARAMETRO LINEE PRODOTTO RUMI
*********************************************************************
********************************************************************/

delete from para where codice like 'REP%'

insert into para (codice,descri,libera) values ('REPMP','MATERIA PRIMA','')
insert into para (codice,descri,libera) values ('REPPF','PRODOTTO FINITO','')
insert into para (codice,descri,libera) values ('REPPH','SEMILAV. FANTASMA','')
insert into para (codice,descri,libera) values ('REPSE','SEMILAVORATO','')
insert into para (codice,descri,libera) values ('REPSX','SEMILAVORATO ESTERNO','')


select * from para where codice like 'REP%'
