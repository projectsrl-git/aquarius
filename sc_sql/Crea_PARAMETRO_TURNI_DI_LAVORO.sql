
-- PARAMETRO PER Turni di lavoro standard per operatori in produzione

-- CODICE: Codice Turno
-- DESCRIZIONE: Descrizione Turno
-- LIBERA: Ora Inizio turno + ':' + Ora Fine turno
-- DESIVA: Numero di giorni compresi nel turno (es.: turno di notte)

delete from para where codice like 'TUR%'

insert into para (codice,descri,LIBERA,DESIVA) values ('TUR001','PRIMO TURNO','06:00-14:00','1')
insert into para (codice,descri,LIBERA,DESIVA) values ('TUR002','SECONDO TURNO','14:00-22:00','1')
insert into para (codice,descri,LIBERA,DESIVA) values ('TUR003','TERZO TURNO','22:00-06:00','2')

select * from para where codice like 'TUR%'