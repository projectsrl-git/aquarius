/****************************************************************************************
 INSERIMENTO CAUSALE PER SCARTO E RICICLO MASSIVO PANNELLI GREZZI DA LEVIGARE
*****************************************************************************************/

DELETE FROM PARA WHERE CODICE IN ('TOPSCG')

INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('TOPSCG','SCARTO GREZZO DA LEVIGARE',	'SN      NNNN                      RM+    M')

SELECT * FROM PARA WHERE CODICE IN ('TOPSCG') ORDER BY CODICE
