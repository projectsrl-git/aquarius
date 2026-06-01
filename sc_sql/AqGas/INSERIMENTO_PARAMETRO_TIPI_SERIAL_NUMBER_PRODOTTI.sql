/******************************************************************************
 INSERIMENTO PARAMETRO "TIPI SERIAL NUMBER PRODOTTI" PER PRODUZIONE BOMBOLE GAS
*******************************************************************************/

DELETE FROM PARA WHERE CODICE LIKE 'TSN%'

INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA,ITALIANO) VALUES ('TSNLOT','Prodotto gestito a lotto di produzione','','','','RICHIEDE_SERIAL=NO')
INSERT INTO PARA (CODICE, DESCRI, LIBERA, CODPGO, DESIVA,ITALIANO) VALUES ('TSNPRD','Prodotto gestito a barcode','','','','RICHIEDE_SERIAL=SI')

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