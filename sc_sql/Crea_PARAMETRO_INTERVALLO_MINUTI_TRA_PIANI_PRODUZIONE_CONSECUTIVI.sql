-- PARAMETRO PER INTERVALLO IN MINUTI TRA PIANI DI PRODUZIONE

delete from para where codice like 'ITP%'

insert into para (codice,descri,LIBERA) values ('ITP001','INTERVALLO IN MINUTI TRA PIANI DI PRODUZIONE','120')

select * from para where codice like 'ITP%'