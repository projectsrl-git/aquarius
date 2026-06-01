
*********************************************************************************************
*		 						  															*
*		              STAMPA BOLLATO IVA CLIENTI FATTURE IN SOSPENSIONE IVA 		     	*
*		 						  															*
*********************************************************************************************
* EMETTE I SEGUENTI DOCUMENTI :
*
* REGISTRO_CON_FATTURE_ELETTRONICHE
* REGISTRO_SENZA_FATTURE_ELETTRONICHE 
* ELENCO FATTURE INCASSATE NEL MESE
 


IF  REGISTRO_SOLO_FATTURE_ELETTRONICHE			&& SPLIT PAYMENT

	DO PRG\IVAFATSIELE		&& SI 8XXXXX
	
ENDIF 


IF  REGISTRO_ESCLUSO_FATTURE_ELETTRONICHE		&& FATTURE IN SOSPENSIONE IVA

	DO PRG\IVAFATNOELE		&& TUTTE LE ALTRE

ENDIF 



IF  ELENCO_FATTURE_INCASSATE

 	DO PRG\IVAFATSOSINC
 	
ENDIF 



 
RETURN

 



