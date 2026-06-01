
-- PARAMETRO PER SEDE LAVORO nei ticket

delete from para where codice like 'STK%'

insert into para (codice,descri,libera) values ('STK000','APERTO - Ricevuta Richiesta di Intervento','01')
insert into para (codice,descri,libera) values ('STK100','APERTO - Richiesta Preventivo','02')
insert into para (codice,descri,libera) values ('STK110','APERTO - In Lavorazione','03')
insert into para (codice,descri,libera) values ('STK120','APERTO - Stand-By','04')
insert into para (codice,descri,libera) values ('STK300','CHIUSO Positivamente','05')
insert into para (codice,descri,libera) values ('STK200','CHIUSO Negativamente','06')

select * from para where codice like 'STK%'