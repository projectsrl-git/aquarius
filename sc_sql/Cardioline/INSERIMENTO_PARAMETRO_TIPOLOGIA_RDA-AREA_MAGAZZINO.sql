/******************************************************************************
 INSERIMENTO PARAMETRO "TIPOLOGIA / AREA MAGAZZINO" PER RDA
*******************************************************************************/

DELETE FROM PARA WHERE CODICE LIKE 'ARE%'

INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('ARE01','Materiale di consumo, Cancelleria','','','')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('ARE02','Fiere, Manifestazioni, Congressi','','','')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('ARE03','Computer, Cellulari, Macchine Elettroniche','','','')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('ARE04','Catering','','','')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('ARE05','Servizi vari','','','')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('ARE06','Materiali Ricerca e Sviluppo','','','')

SELECT * FROM PARA WHERE CODICE LIKE 'ARE%'

