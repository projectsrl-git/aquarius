
--********************************************************************
-- INSERIMENTO PARAMETRO STATO FATTURE ELETTRONICHE (PORTALE BLUENEXT)
--********************************************************************

delete from para where codice like 'SFE%'

insert into para (codice,descri,libera,codpgo,italiano) values ('SFE0','Nessuno','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE1','Upload in corso','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE2','Errore nell upload','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE5','Controllo formale del file e dei contenuti','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE6','Errore durante il controllo formale del file e dei contenuti','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE7','Lettura ed estrazione dei dati delle fatture in corso','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE8','Errore nella lettura ed estrazione dei dati delle fatture','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE9','Firma in corso','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE10','Errore durante le operazioni di firma','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE13','Invio allo SdI in corso','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE14','Errore durante invio allo SdI','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE15','Documento in attesa di esito dallo SdI','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE16','Notifica di avvenuta consegna','','8454016','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE17','Notifica di scarto','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE18','Notifica di mancata consegna','','8454016','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE19','Documento importato ma non inviato allo SdI','','8454143','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE20','Fattura passiva ricevuta dallo SdI','','8454016','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE21','--- (Non utilizzato)','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE22','Accettata (FPA12)','','8454016','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE23','Rifiutata (FPA12)','','8421631','ABILITA_RITRASMISSIONE=SI')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE24','Accettata per decorrenza termini (FPA12)','','8454016','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFE25','Mancata consegna finale (FPA12)','','8421631','ABILITA_RITRASMISSIONE=SI')

insert into para (codice,descri,libera,codpgo,italiano) values ('SFEZZ','Da contabilizzare','','8454143','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFECO','Contabilizzata','','8454016','')
insert into para (codice,descri,libera,codpgo,italiano) values ('SFENC','Non Contabilizzabile','','33023','')

insert into para (codice,descri,libera,codpgo,italiano) values ('SFE4','Impossibile verificare la firma P7M per il file','','8421631','ABILITA_RITRASMISSIONE=SI')

select * from para where codice like 'SFE%'

