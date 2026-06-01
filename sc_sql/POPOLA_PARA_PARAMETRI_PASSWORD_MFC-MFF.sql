
DELETE FROM PARA WHERE CODICE = 'PWDMFC'
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('PWDMFC','PASSWORD PER MODIFICA REGISTRAZIONI FATTURE CLIENTI','MFC','','Per attivare la password di protezione per la modifica delle registrazioni di tipo Fattura Cliente abilitare l''opzione gestite nella scheda "Contabilità", sottoscheda "Controlli", dei parametri di sistema Aziendali "Richiedi password di protezione per la modifica delle registrazioni di tipo Fattura Cliente"')

DELETE FROM PARA WHERE CODICE = 'PWDMFF'
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO,ITALIANO) VALUES ('PWDMFF','PASSWORD PER MODIFICA REGISTRAZIONI FATTURE FORNITORI','MFF','','Per attivare la password di protezione per la modifica delle registrazioni di tipo Fattura Fornitore abilitare l''opzione gestite nella scheda "Contabilità", sottoscheda "Controlli", dei parametri di sistema Aziendali "Richiedi password di protezione per la modifica delle registrazioni di tipo Fattura Fornitore"')

SELECT * FROM PARA WHERE CODICE IN ('PWDMFC','PWDMFF')
