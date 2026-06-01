**********************************************************************************************
*                     		       *  AQUARIUS   * 					    					 *
*           																				 *
*          							 ZAP ARCHIVI	 										 *
*          			    		MAGAZZINO A LOCAZIONI 		 										 *
*           										  	            						 *
********************************************************************************************** 

** Impostazione SET Iniziali       

PUB_TIMER = .F.             && DISATTIVA GESTIONE POSTA ELETTRONICA


PUB_ARCH = "U_LOC_GI"
ZAPPALOC.BARRA(50)
cSql = "DELETE FROM U_LOC_GI WHERE 1=1"
IF !ExecCommand(cSql,"U_LOC_GI")
   RETURN .F.
ENDIF

PUB_ARCH = "U_LOC_MO"
ZAPPALOC.BARRA(100)
cSql = "DELETE FROM U_LOC_MO WHERE 1=1"
IF !ExecCommand(cSql,"U_LOC_MO")
   RETURN .F.
ENDIF

PUB_TIMER = .T.             && ATTIVA GESTIONE POSTA ELETTRONICA****************************************************