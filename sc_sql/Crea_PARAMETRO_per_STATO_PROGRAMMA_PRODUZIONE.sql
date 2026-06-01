
-- PARAMETRO PER STATO PROGRAMMA DI PRODUZIONE

delete from para where codice like 'SPP%'

insert into para (codice,descri) values ('SPP001','IN PROGRAMMAZIONE')
insert into para (codice,descri) values ('SPP002','PRONTO PER SPALMATURA')
insert into para (codice,descri) values ('SPP003','IN SPALMATURA')
insert into para (codice,descri) values ('SPP004','SPALMATURA SOSPESA')
insert into para (codice,descri) values ('SPP005','SPALMATURA TERMINATA CORRETTAMENTE')
insert into para (codice,descri) values ('SPP006','SPALMATURA TERMINATA FORZATAMENTE')
insert into para (codice,descri) values ('SPP999','P.D.P. EVADIBILE')
insert into para (codice,descri) values ('SPP998','PRONTO PER IL TAGLIO')
insert into para (codice,descri) values ('SPP111','SEQUENZA NASCOSTA')

select * from para where codice like 'SPP%'


