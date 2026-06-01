*************************************************************************************************
*							    CONVERSIONE ANAGRAFICA BANCHE  		  							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline 				 													*
*************************************************************************************************



RIT = MESSAGEBOX("Procedo con la conversione dalla tabella ABICAB  ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

*!*			WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA BANCHE" NOWAIT
*!*			cSql = "delete from U_BAN_AN where CODICE LIKE 'VET%' "
*!*			IF !ExecCommand(cSql,"U_BAN_AN")
*!*			   return(.f.)
*!*			ENDIF

IF !ExecCommand("select * from U_BAN_AN where 1=0","curs_U_BAN_AN")
   return
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR,_CTR_ELA 
PUBLIC __DATINS,_CTR,_CTR_ELA 
__DATINS = DTOC(DATE())
_CTR     = 0
_CTR_ELA = 0


WAIT WINDOWS "Conversione dalla tabella ABICAB ..." NOWAIT
 

_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_ABICAB ORDER BY CODICE"
IF !ExecCommand(cSql,"CX_CARD_ABICAB")
	RETURN .F.
ENDIF
SELECT CX_CARD_ABICAB
GO TOP
SCAN

    SCATTER MEMVAR memo 
  
    M.BAN_CODSOC  = PUB_CODSOC
	M.BAN_CODABI  = APITOSPA(CONV_CLEAR(ALLTRIM(m.abi)))
	M.BAN_CODCAB  = APITOSPA(CONV_CLEAR(ALLTRIM(m.cab)))
	M.BAN_CODBAN  = M.BAN_CODABI + M.BAN_CODCAB
    M.DESCRI 	  = ALLTRIM(APITOSPA(ALLTRIM(m.descrizion)))	
	M.BAN_DESBAN  = APITOSPA(CONV_CLEAR(ALLTRIM(M.DESCRI))) 	
	M.BAN_INDIR   = APITOSPA(CONV_CLEAR(ALLTRIM(m.indirizzo)))
	M.BAN_CAP     = APITOSPA(CONV_CLEAR(ALLTRIM(m.cap)))
    M.BAN_LOCA    = APITOSPA(CONV_CLEAR(ALLTRIM(m.localita)))
    M.BAN_PROVIN  = APITOSPA(CONV_CLEAR(ALLTRIM(m.provincia)))
    M.BAN_DATINS  = __DATINS 
	M.BAN_NOTE1   = APITOSPA(CONV_CLEAR(ALLTRIM(m.descrsport)))
	
      
    _CTR_ELA = _CTR_ELA +1
    WAIT WINDOWS "Movimenti elaborati : " + STR(_CTR_ELA,5,0) nowait	

	cSql = "select * from U_BAN_AN where BAN_CODBAN = '"+ALLTRIM(M.BAN_CODBAN)+"'"
	IF !ExecCommand(cSql,"___temp_u_ban_an")
	   RETURN .F.
	ENDIF
	SELECT ___temp_u_ban_an
	GO TOP
	IF EOF()
	ELSE
       SELECT CX_CARD_ABICAB && scarto il record 
       SKIP +1
       LOOP
    ENDIF       


	SELECT curs_U_BAN_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN



****** AGGIORNA TABELLA U_BAN_AN SQL
IF !ExecRW('','U_BAN_AN','I','','curs_U_BAN_AN')
   return(.f.)
ENDIF
	 
	 
WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale ABICAB convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


