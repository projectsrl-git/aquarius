
--***************************************************
-- INSERIMENTO PARAMETRO TIPOLOGIA INTERVENTI TECNICI
--***************************************************

delete from para where codice like 'TPI%'

insert into para (codice,descri,libera) values ('TPI001','DAM DICHIARARZIONE AUTOCERTIFICAZIONE MANUTENZIONE','')
insert into para (codice,descri,libera) values ('TPI002','MANUTENZIONE ORDINARIA','')
insert into para (codice,descri,libera) values ('TPI003','MANUTENZIONE ORDINARIA OBBLIGATORIA','')
insert into para (codice,descri,libera) values ('TPI004','MANUTENZIONE ANALISI FUMI OBBLIGATORIA PER IMPIANTI PRODUCONO ANCHE ACQUA CALDA SANITARIA','')
insert into para (codice,descri,libera) values ('TPI005','MANUTENZIONE ANALISI FUMI OBBLIGATORIA PER IMPIANTI NON PRODUCONO ANCHE ACQUA CALDA SANITARIA','')

select * from para where codice like 'TPI%'

