
--****************************************************
-- INSERIMENTO PARAMETRO CATEGORIE DI POTENZA IMPIANTI
--****************************************************

delete from para where codice like 'PIM%'

insert into para (codice,descri,libera,CODPGO) values ('PIM01','IMPIANTI FINO A 14 KW','','8454143')
insert into para (codice,descri,libera,CODPGO) values ('PIM02','IMPIANTI SUPERIORI A 14 KW E INFERIORI A 35 KW','','16777088')
insert into para (codice,descri,libera,CODPGO) values ('PIM03','IMPIANTI SUPERIORI A 35 KW','','16744703')

select * from para where codice like 'PIM%'

