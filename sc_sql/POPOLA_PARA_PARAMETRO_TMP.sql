
--******************************************************
-- INSERIMENTO PARAMETRO TIPOLOGIE MANUTENZIONI IMPIANTI
--******************************************************

delete from para where codice like 'TMP%'
                                                                                                                                                                                                                                  
insert into para (codice,descri,libera,note,PAR_COSTCAD1,PAR_RICCAD1,PERANT) values ('TMP001','Manutenzione programmata DAM','MANU-DAM','',14,34.8,24)
insert into para (codice,descri,libera,note,PAR_COSTCAD1,PAR_RICCAD1,PERANT) values ('TMP002','Manutenzione ordinaria obbligatoria IMPIANTO 80 kw (DA 35kw AI 350kw)','MANU-ORD-OBBL','',35,350,12)
insert into para (codice,descri,libera,note,PAR_COSTCAD1,PAR_RICCAD1,PERANT) values ('TMP003','Manutenzione ordinaria (IMPIANTO 14 kw (DA 14 A 34,8)','MANU-ORD','',14,34.8,12)
insert into para (codice,descri,libera,note,PAR_COSTCAD1,PAR_RICCAD1,PERANT) values ('TMP004','Manutenzione analisi fumi obbligatoria con acqua sanitaria (IMPIANTO 400kw (maggiore di 350kw)','MANU-SI-FUMI-OBBL','',350,9999,6)
insert into para (codice,descri,libera,note,PAR_COSTCAD1,PAR_RICCAD1,PERANT) values ('TMP005','Manutenzione analisi fumi obbligatoria NO acqua sanitaria (IMPIANTO 400kw (maggiore di 350kw)','MANU-NO-FUMI-OBBL','',350,9999,12)

select * from para where codice like 'TMP%'