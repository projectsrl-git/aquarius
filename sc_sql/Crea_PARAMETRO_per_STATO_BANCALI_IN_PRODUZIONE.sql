
-- PARAMETRO PER STATO BANCALI IN PRODUZIONE

delete from para where codice like 'STB%'

insert into para (codice,descri) values ('STB01','IN LAVORAZIONE REPARTO TAGLIO')
insert into para (codice,descri) values ('STB02','PRONTO PER IMBALLO')
insert into para (codice,descri) values ('STB03','INCOMPLETO')
insert into para (codice,descri) values ('STB04','IMBALLATO')
insert into para (codice,descri) values ('STB05','ASSEGNATO A PACKING LIST')
insert into para (codice,descri) values ('STB06','SPEDITO')

select * from para where codice like 'STB%'


