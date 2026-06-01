-- SCARTO IN MM PER OGNI TAGLIO AGGIUNTIVO A QUELLI STANDARD

delete from para where codice like 'SCT%'

insert into para (codice,descri,LIBERA) values ('SCT01','SCARTO IN MM PER OGNI TAGLIO AGGIUNTIVO A QUELLI STANDARD','05')

select * from para where codice like 'SCT%'




-- SCARTO IN MM PER CIMOSA IN FUNZIONE DEL TIPO DI ADESIVO


-- DEFAULT

delete from para where codice like 'SCA%'

insert into para (codice,descri,LIBERA) values ('SCADEFAULT','SCARTO IN MM PER CIMOSA DEFAULT','060')

select * from para where codice like 'SCADEFAULT%'


-- BASE ACQUA

insert into para (codice,descri,LIBERA) values ('SCAA','SCARTO IN MM PER CIMOSA PER ADESIVO BASE ACQUA','060')

select * from para where codice like 'SCAA%'

-- BASE GOMMA

insert into para (codice,descri,LIBERA) values ('SCAR','SCARTO IN MM PER CIMOSA PER ADESIVO BASE GOMMA','080')

select * from para where codice like 'SCAR%'


-- BASE SOLVENTE

insert into para (codice,descri,LIBERA) values ('SCAS','SCARTO IN MM PER CIMOSA PER ADESIVO BASE SOLVENTE','080')

select * from para where codice like 'SCAS%'




-- NUMERO TAGLI STANDARD PREVISTI IN CIMOSA

delete from para where codice like 'NTS%'

insert into para (codice,descri,LIBERA) values ('NTS01','NUMERO TAGLI STANDARD PREVISTI IN CIMOSA','06')

select * from para where codice like 'NTS%'


-- ALTEZZA MASSIMA E MINIMA BOBINA MADRE

delete from para where codice like 'HMB%'

---insert into para (codice,descri,LIBERA,NOTE) values ('HMBP38T','ALTEZZA MASSIMA E MINIMA BOBINA MADRE','2360      1050','DIGITARE NEI PRIMI 10 CARATTERI ALTEZZA MASSIMA E NEI CARATTERI DA 11 IN POI ALTEZZA MINIMA IN MM')
insert into para (codice,descri,LIBERA,NOTE) values ('HMBDEFAULT','ALTEZZA MASSIMA E MINIMA BOBINA MADRE','2360      1050','DIGITARE NEI PRIMI 10 CARATTERI ALTEZZA MASSIMA E NEI CARATTERI DA 11 IN POI ALTEZZA MINIMA IN MM')

select * from para where codice like 'HMB%'

--CORREZIONE PARAMETRO PER PROGRESSIVO PALLET

delete from para where codice like 'PAL%'

insert into para (codice,descri,LIBERA) values ('PAL01','NUMERO PROGRESSIVO PALLET','000000')

select * from para where codice like 'PAL%'