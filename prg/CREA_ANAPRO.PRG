
*************************************************************************************************
*					       	    CREA TABELLE PER INTERVENTI TECNICI   				            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Maggio 2023 : MEBER		 			 														*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR






RIT = MESSAGEBOX("Procedo con la creazione delle tabelle per interventi in riparazione MEBER ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



WAIT WINDOWS " Creazione delle tabelle per interventi in riparazione MEBER in corso attendere prego ....." NOWAIT


cSql=""
cNomeCursorSql="CU_IMPIANTI_TT"
TEXT TO cSql NOSHOW

	   
      SELECT * 
       FROM IMPIANTI_TT 
	   ORDER BY CCODSCHE 
	   
	   
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF


SELECT CU_IMPIANTI_TT
GO TOP

IF EOF()

   MESSAGEBOX("Operazione abbandonata in quanto IMPIANTI_TT è vuoto",48,"Informazione")
   RETURN

ENDIF


DO WHILE .NOT. EOF()

	SELECT CU_IMPIANTI_TT
	SCATTER MEMVAR MEMO
	
	
	IF ALLTRIM(M.CCODSCHE) = '.'
		SELECT CU_IMPIANTI_TT
		SKIP +1
		LOOP
	ENDIF

	WAIT WINDOWS "Prodotto in elaborazione in corso: "+ ALLTRIM(M.CCODSCHE) nowait
	
	AABBSSIMPIANTI    = SELECT()
	
*!*	    _CERCA_PUNTO = "."
*!*	    _PAROLA = ALLTRIM(SUBSTR(M.CCODSCHE,1,6))	&& CONSIDERA SOLO I PRIMI 6 CHR IN QUANTO SUCCESSIVAMENTE CI POSSONO ESSERE DEI PUNT COME PER ES: AGAZZI IDROTHERMOEL.
*!*	    _POSIZIONE_PUNTO = AT(_CERCA_PUNTO,ALLTRIM(_PAROLA))   
*!*		
*!*		IF _POSIZIONE_PUNTO = 0
*!*			_REPLACE = "BAREL." + ALLTRIM(M.CCODSCHE)
*!*		ELSE
*!*			_REPLACE = "BAREL" + ALLTRIM(SUBSTR(M.CCODSCHE,_POSIZIONE_PUNTO,150))
*!*		ENDIF
		
	_REPLACE = "MEBER." + SYS(2015)
	
	x_cond   = "CCODSCHE = '" + ALLTRIM(M.CCODSCHE) + "'"
	
	Csql     = "select * from IMPIANTI_TT where " + x_cond
	IF !ExecRW(cSql,"IMPIANTI_TT","R")
		return(.f.)
	ENDIF
	SELECT IMPIANTI_TT
	GO TOP
	SCAN
		REPLACE CCODSCHE WITH _REPLACE 
	ENDSCAN
	IF !ExecRW(cSql,"IMPIANTI_TT","W")
		return(.f.)
	ENDIF

	
	Csql     = "select * from IMPIANTI_DD where " + x_cond
	IF !ExecRW(cSql,"IMPIANTI_DD","R")
		return(.f.)
	ENDIF
	SELECT IMPIANTI_DD
	GO TOP
	SCAN
		REPLACE CCODSCHE WITH _REPLACE 
	ENDSCAN
	IF !ExecRW(cSql,"IMPIANTI_DD","W")
		return(.f.)
	ENDIF
	
	
	Csql     = "select * from IMPIANTI_TE where " + x_cond
	IF !ExecRW(cSql,"IMPIANTI_TE","R")
		return(.f.)
	ENDIF
	SELECT IMPIANTI_TE
	GO TOP
	SCAN
		REPLACE CCODSCHE WITH _REPLACE 
	ENDSCAN
	IF !ExecRW(cSql,"IMPIANTI_TE","W")
		return(.f.)
	ENDIF	
	
	
	Csql     = "select * from IMPIANTI_CO where " + x_cond
	IF !ExecRW(cSql,"IMPIANTI_CO","R")
		return(.f.)
	ENDIF
	SELECT IMPIANTI_CO
	GO TOP
	SCAN
		REPLACE CCODSCHE WITH _REPLACE 
	ENDSCAN
	IF !ExecRW(cSql,"IMPIANTI_CO","W")
		return(.f.)
	ENDIF	
		
	

	SELECT(AABBSSIMPIANTI)
	
	SELECT CU_IMPIANTI_TT
	SKIP +1

ENDDO



MESSAGEBOX("Fine elaborazione archivi INTERVENTI MEBER",48,"Informazione")

