
--********************************************************************
-- INSERIMENTO PARAMETRO STATO CONTATTI MANUTENZIONI PROGRAMMATE
--********************************************************************

delete from para where codice like 'SCN%'

insert into para (codice,descri,libera) values ('SCN000','Nessuno','')
insert into para (codice,descri,libera) values ('SCN001','Confermato','')
insert into para (codice,descri,libera) values ('SCN002','Non risponde','')
insert into para (codice,descri,libera) values ('SCN003','Da richiamare','')
insert into para (codice,descri,libera) values ('SCN004','Da richiamare a fine mese','')

select * from para where codice like 'SCN%'

