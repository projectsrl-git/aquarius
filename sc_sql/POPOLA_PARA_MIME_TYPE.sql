/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "MIME TYPE" DOMINIO 'MIME'
**********************************************************************************************
*/

DELETE FROM PARA WHERE CODICE LIKE 'MIME%'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEtxt','text/plain','text/plain')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEhtml','text/html','text/html')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEpdf','application/pdf','application/pdf')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEdoc','application/msword','application/msword')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEdocx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.openxmlformats-officedocument.wordprocessingml.document')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMExls','application/vnd.ms-excel','application/vnd.ms-excel')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMExlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEjpg','image/jpeg','image/jpeg')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEjpeg','image/jpeg','image/jpeg')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEpng','image/png','image/png')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEgif','image/gif','image/gif')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEzip','application/zip','application/zip')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEmp3','audio/mpeg','audio/mpeg')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MIMEmp4','video/mp4','video/mp4')
