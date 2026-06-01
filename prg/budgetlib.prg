*!*	##############################################################################################################
  
					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI BUDGET	                           ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  
 

***********************************************************************************
FUNCTION DEF_BUD
***********************************************************************************
**
** DEFINISCE IL CURSORE PER LA GESTIONE DEL BUDGET
**


**==> CURSORI DI SUPPORTO PER LA GESTIONE DEI BENI DA AMMORTIZZARE
IF !ExecCommand("select * from BUDGET where 0=1","BUDGET")
   return(.f.)
ENDIF
SELECT BUDGET
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)

CREATE CURSOR Cu_BUDGET FROM ARRAY TRANSITO
INDEX ON BUD_SOC+BUD_ANNO+BUD_CONTO TAG I_budget ADDITIVE    

  

RETURN(.T.)



