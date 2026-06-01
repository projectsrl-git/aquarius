
DELETE FROM PARA WHERE CODICE LIKE 'NTI%'
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('NTIWHA','NOTIFICA INTERVENTI WHATSAPP','','','HXf71085626351b3180d5dc08cdd199718')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('NTISMS','NOTIFICA INTERVENTI SMS','','','Trevicalor: Promemoria appuntamento {{date}} {{time}}. Disdetta entro 12h per evitare oneri di mancato preavviso (60 euro). Info: 036343657. Cordialmente.')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('NTIEML','NOTIFICA INTERVENTI E-MAIL','Trevicalor: promemoria riparazione caldaia/pdc','','Gentile cliente,
le ricordiamo l’appuntamento per la riparazione della caldaia e o la manutenzione impianto termico previsto per il giorno {{date}} {{time}} concordato con il nostro ufficio
Per qualsiasi necessità o modifica, non esiti a contattarci.
Qualora l’appuntamento non venga disdettato entro le 12 ore precedenti verrà comunque addebitato l’importo di € 60,00.

Grazie, Trevicalor')

DELETE FROM PARA WHERE CODICE LIKE 'NTM%'
--INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('NTMWHA','NOTIFICA INTERVENTI WHATSAPP','','','HX2ae0b0634553d63cdb3136b56d79003b')
--INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('NTMSMS','NOTIFICA INTERVENTI SMS','','','Trevicalor: promemoria riparazione caldaia/pdc il {{date}} ore {{time}}. Penale €60 se non disdetto con 12h di preavviso. Per info o modifiche +39 0363 43657. Grazie.')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO,DESIVA) VALUES ('NTMEML','NOTIFICA INTERVENTI E-MAIL','Trevicalor: PROMEMORIA SCADENZA MANUTENZIONE IMPIANTO TERMICO {{codsche}}','30','Gentile {{name}},
con la presente desideriamo ricordarle che la manutenzione periodica del suo impianto, con o senza prova fumi, deve essere effettuata entro il mese successivo alla ricezione della presente comunicazione.
In ogni caso, al fine di evitare eventuali sanzioni previste dalla normativa vigente, in caso di versamento dell''autocertificazione in scadenza, l''intervento dovrà essere eseguito entro e non oltre il 31/07.
Restiamo a disposizione per concordare l’appuntamento o per qualsiasi ulteriore chiarimento.
Può contattarci rispondendo a questa email o al numero 0363/43657 oppure inviando una e-mail all''indirizzo da cui ha ricevuto la presente comunicazione.

Cordiali Saluti
Trevicalor sas
','info@trevicalor.it')


SELECT * FROM PARA WHERE CODICE LIKE ('NTI%') ORDER BY CODICE
SELECT * FROM PARA WHERE CODICE LIKE ('NTM%') ORDER BY CODICE
