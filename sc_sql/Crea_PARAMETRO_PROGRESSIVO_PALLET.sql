-- PARAMETRO PER PROGRESSIVO PALLET

delete from para where codice like 'PAL%'

insert into para (codice,descri,LIBERA) values ('PAL','NUMERO PROGRESSIVO PALLET','000000')

select * from para where codice like 'PAL%'

