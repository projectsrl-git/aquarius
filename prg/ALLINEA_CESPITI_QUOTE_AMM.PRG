
_RISP = MESSAGEBOX("Allineare l'ultima quota di ammortamento generata in base ai valori inseriti nelle anagrafiche dei cespiti?",4+32,"Attenzione")

IF _RISP = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informzione")
	RETURN .F.
ENDIF

cSql = "select * from u_amm_at order by amm_codces"
IF !ExecCommand(cSql,"CX_AMM_AT")
  return(.f.)
ENDIF

_CONTA_TOTALI = 0
_CONTA_AGGIORNATE = 0
SET STEP ON
SELECT CX_AMM_AT
GO TOP
SCAN
	
	WAIT WINDOWS "Elaborazione cespite " + ALLTRIM(amm_codces) + " (record " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) + ")" NOWAIT
	
	_CONTA_TOTALI = _CONTA_TOTALI + 1
	
	SCATTER MEMVAR MEMO

	_DELTA_VALRES = 0
	_QUO_UNIQUE = ""
	x_cces = "quo_codces = '" + ALLTRIM(M.AMM_CODCES) + "'"
	x_anno = "quo_annrif = quo_annrif"
	x_ccat = "quo_codcat = quo_codcat"
	x_cond = x_cces + " and " + x_anno + " and " + x_ccat 
	cSql   = "select * from u_quo_am where " + x_cond + " order by quo_annrif DESC"
	IF !ExecCommand(cSql,"Y_QUO_AM")
	   return(.f.)
	ENDIF
	SELECT Y_QUO_AM
	GO TOP
	IF !EOF()
		_DELTA_VALRES = M.AMM_VALRES - QUO_VALRES
		_QUO_UNIQUE = ID_UNIQUE
	ENDIF

	IF _DELTA_VALRES <> 0
		
		*_RISP = MESSAGEBOX("Rilevate differenze rispetto alle quote di ammortamento attualmente presenti." + REPLICATE(CHR(13),2) + ;
		*	"Allineare l'ultima quota di ammortamento generata in base ai valori inseriti?",4+32,"Attenzione")
		
		*IF _RISP = 6
		
			_DELTA_FONORD = M.AMM_VALORD - QUO_FONORD
			_DELTA_FONANT = M.AMM_VALANT - QUO_FONANT
			_DELTA_FONACC = M.AMM_VALACC - QUO_FONACC
			
			cSql = "select * from u_quo_am where ID_UNIQUE = '" + _QUO_UNIQUE + "'"
			IF !ExecRW(cSql,"U_QUO_AM","R")
			   return(.f.)
			ENDIF
			SELECT U_QUO_AM
			GO TOP
			IF !EOF()
				REPLACE QUO_VALORD WITH QUO_VALORD + _DELTA_FONORD
				REPLACE QUO_FONORD WITH QUO_FONORD + _DELTA_FONORD
				REPLACE QUO_VALANT WITH QUO_VALANT + _DELTA_FONANT
				REPLACE QUO_FONANT WITH QUO_FONANT + _DELTA_FONANT
				REPLACE QUO_VALACC WITH QUO_VALACC + _DELTA_FONACC
				REPLACE QUO_FONACC WITH QUO_FONACC + _DELTA_FONACC
				
				IF QUO_VALSTO > 0
					REPLACE QUO_PERORD WITH QUO_VALORD / QUO_VALSTO * 100
					REPLACE QUO_PERANT WITH QUO_VALANT / QUO_VALSTO * 100
					REPLACE QUO_PERACC WITH QUO_VALACC / QUO_VALSTO * 100
				ELSE
					REPLACE QUO_PERORD WITH 0
					REPLACE QUO_PERANT WITH 0
					REPLACE QUO_PERACC WITH 0
				ENDIF
				
				REPLACE QUO_TOTAMM WITH QUO_VALORD + QUO_VALANT + QUO_VALACC
				REPLACE QUO_VALRES WITH M.AMM_VALRES
				
				_CONTA_AGGIORNATE = _CONTA_AGGIORNATE + 1
			ENDIF
			IF !ExecRW(cSql,"U_QUO_AM","W")
			   return(.f.)
			ENDIF
			
		*ENDIF
		
	ENDIF

ENDSCAN

MESSAGEBOX("Totale anagrafiche cespiti elaborate: " + ALLTRIM(STR(_CONTA_TOTALI)) + CHR(13) + ;
	"Totale quote di ammortamento allineate: " + ALLTRIM(STR(_CONTA_AGGIORNATE)),64,"Informazione")

RETURN .T.
