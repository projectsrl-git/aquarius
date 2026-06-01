
-- PARAMETRO PER NUMERAZIONE LISTA DI PROGRAMMI DI TAGLIO

delete from para where codice like 'NUMSEQUEN%'

insert into para (codice,descri,libera) values ('NUMSEQUEN01','NUMERAZIONE LISTA DI PROGRAMMI DI TAGLIO',0000000000)

select * from para where codice like 'NUMSEQUEN%'
