

delete from para where codice like 'TFC\SO%'
delete from para where codice like 'TFC\CE%'
delete from para where codice like 'TFC\RC%'
delete from para where codice like 'TFC\RV%'


insert into para (codice,descri,libera) values ('TFC\SO','CONTO PER CHIUSURA AUTOMATICA IVA VENDITE IN SOSPENSIONE IVA INCASSATE','44010002')
insert into para (codice,descri,libera) values ('TFC\CE','CONTO IVA CEE','12040006')
insert into para (codice,descri,libera) values ('TFC\RC','CONTO REVERSE CHARGE','12040001')
insert into para (codice,descri,libera) values ('TFC\RV','VENDITE (COMPENSAZIONE) REVERSE CHARGE','44010003')


select * from para where codice like 'TFC%'

