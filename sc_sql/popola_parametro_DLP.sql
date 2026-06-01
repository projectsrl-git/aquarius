/********************************************************************
 PARAMETRO GRUPPO LISTINI
********************************************************************/

DELETE FROM PARA WHERE CODICE LIKE 'NUMDLP%'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('NUMDLP01','NUMERI DISTINTA PROVVIGIONI AGENTI','0000000')

/* VISUALIZZO I RECORD INSERITI */
SELECT * FROM PARA WHERE CODICE LIKE 'NUMDLP%'

