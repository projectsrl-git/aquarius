
-- #############################################################################
--   CANCELLAZIONE PARAMETRI ESISTENTI
-- #############################################################################
delete from para where codice like 'CSP%'


-- #############################################################################
--   PARAMETRO PER MESSAGGI NON CONFORMITA RELATIVI AL SEMAFORO "ROSSO"
-- #############################################################################
insert into para (codice,descri) values ('CSPROS001','Grammatura sbagliata')
insert into para (codice,descri) values ('CSPROS002','Pieghe / buchi')
insert into para (codice,descri) values ('CSPROS003','Adesivo non asciutto')
insert into para (codice,descri) values ('CSPROS004','Manca adesivo')
insert into para (codice,descri) values ('CSPROS005','Avviamento / scarto')


-- #############################################################################
-- #############################################################################
--   PARAMETRO PER MESSAGGI NON CONFORMITA RELATIVI AL SEMAFORO "GIALLO"
-- #############################################################################
-- #############################################################################
insert into para (codice,descri) values ('CSPGIA001','Bobina sbandata')
insert into para (codice,descri) values ('CSPGIA002','Primi metri pieghe (dopo cambio)')
insert into para (codice,descri) values ('CSPGIA003','Presenza pieghe')
insert into para (codice,descri) values ('CSPGIA004','Fascia maggiore')
insert into para (codice,descri) values ('CSPGIA005','Fascia minore')
insert into para (codice,descri) values ('CSPGIA006','Albero sgonfio')


-- #############################################################################
--   VISUALIZZAZIONE LISTA PARAMETRI CREATI
-- #############################################################################
select * from para where codice like 'CSP%' order by codice

