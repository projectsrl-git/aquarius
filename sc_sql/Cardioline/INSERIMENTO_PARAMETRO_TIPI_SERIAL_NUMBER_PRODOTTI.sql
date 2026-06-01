/******************************************************************************
 INSERIMENTO PARAMETRO "TIPI SERIAL NUMBER PRODOTTI"
*******************************************************************************/

DELETE FROM PARA WHERE CODICE LIKE 'TSN%'

INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNACQ','Acquisto esterno','[A]NNNNNNN','','0002236')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNKEY','Chiave Hardware','[KEY]NNNNN','','04476')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNLOT','Acquisto esterno a lotto','[L]NNNNNNN','','0000150')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNOLD','Old format SN for ELAN and other','[E]LLLNNNN','AAA','0288')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNPRD','Apparecchio della produzione','','','')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNSIS','Sistema (cube, ecc)','[S]NNNNNNN','','0000260')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNSN6','Serial Number a 6 caratteri','[A]LLLNN','AAK','29')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA) VALUES ('TSNVEN','Prodotto di vendita','','','')

UPDATE PARA SET NOTE = 'La gestione permette di definire che formato di SN dovrà avere l’apparecchio, infatti il SN di Default sarà quello per la produzione (TYP_APPARECCHIO = PRD), ovvero :

	[numero lotto][anno][num progressivo]

mentre potrà essere definito un SN custom a piacimento tramite la presente gestione.

Quindi se nel campo LIBERA viene lasciato il valore vuoto il sistema crea come SN quello di Default, mentre nel caso si trovi qualcosa produrrà un SN diverso.

Il formato DEVE seguire le presenti REGOLE:

	1) Nel campo LIBERA i caratteri ammessi sono:

		[carattere] = indica un carattere fisso che verrà sempre riportato
		L = indica una lettera alfabetica
		N = indica un numero

	2) Nel campo Tipologia (PARA.DESIVA) dovrà essere inserito il numero di partenza del contatore (che il sistema incrementerà automaticamente) nel formato stringa, ovvero se inserisco NN -> il Tipologia (PARA.DESIVA) deve essere inserito come XX, ovvero con lo stesso numero di caratteri.
		
		Ad esempio 
		
			[E]LLLNN -> sarà 00
			[E]LLLNNNN -> sarà 0000

	3) Nel campo Codice Conv. (PARA.CODPGO) dovrà essere inserito il numero di partenza del contatore (che il sistema incrementerà automaticamente) nel formato stringa, ovvero se inserisco LL -> il Codice Conv. (PARA.CODPGO) deve essere inserito come XX, ovvero con lo stesso numero di caratteri.
		
		Ad esempio 

			[E]LNN -> sarà A
			[E]LLLNN -> sarà AAA'

WHERE CODICE LIKE 'TSN%'

SELECT * FROM PARA WHERE CODICE LIKE 'TSN%'