
LPARAMETERS _par_cExpressionSought,_par_cReplacement,_par_cStringContainedReportName

IF PCOUNT() >= 2
ELSE
	MESSAGEBOX("Inserire rispettivamente i parametri di ingresso Stringa da cercare, Stringa di sostituzione, [Stringa contenuta nel nome report]",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_cStringContainedReportName = ""
ENDIF

IF TYPE("_par_cExpressionSought") == 'C'
ELSE
	MESSAGEBOX("Primo parametro di ingresso deve essere di tipo STRINGA",16,"Attenzione")
	RETURN .F.
ENDIF

IF TYPE("_par_cReplacement") == 'C'
ELSE
	MESSAGEBOX("Secondo parametro di ingresso deve essere di tipo STRINGA",16,"Attenzione")
	RETURN .F.
ENDIF

IF TYPE("_par_cStringContainedReportName") == 'C'
ELSE
	MESSAGEBOX("Terzo parametro di ingresso deve essere di tipo STRINGA",16,"Attenzione")
	RETURN .F.
ENDIF

_pub_dir_ = sys(5)+sys(2003)
_report_dir_ = _pub_dir_ + "\report"

IF DIRECTORY(_report_dir_)
ELSE
	MESSAGEBOX("Directory '" + _report_dir_ + "' non trovata",48,"Attenzione")
	SET DEFA TO &_pub_dir_
	RETURN
ENDIF

SET DEFAULT TO &_report_dir_
lnTotalFrx=ADIR(aFRX,'*.frx')

_risp = MESSAGEBOX("Sostituire le label conententi la stringa '"+_par_cExpressionSought+"' con la stringa '"+_par_cReplacement+"' su tutti i report della relativa directory di Aquarius" + ;
	IIF(!EMPTY(_par_cStringContainedReportName)," contenenti nel nome file la stringa '" + _par_cStringContainedReportName + "' ","") + "?",4+32+256,"Sostituzione stringa label su tutti i report di Aquarius")
IF _risp = 6
ELSE
	MESSAGEBOX("Operazione annullata",64,"Informazione")
	SET DEFA TO &_pub_dir_
	RETURN
ENDIF

_CONTA = 0
for nF=1 to lnTotalFrx
	cFRX=aFRX(nF,1)
	WAIT WINDOWS "Elaborazione file di report '" + cFRX + "'" NOWAIT
	
	IF !EMPTY(_par_cStringContainedReportName)
		IF UPPER(_par_cStringContainedReportName) $ UPPER(JUSTFNAME(cFRX))
		ELSE
			LOOP
		ENDIF
	ENDIF
	
	_lUpdated = .F.
	
	USE (cFRX) && open the FRX as a table
	SET FILTER TO OBJTYPE = 5  && SOLO CAMPI DI TIPO "label"
	GO TOP
	SCAN
		
		IF _par_cExpressionSought $ Expr
		ELSE
			LOOP
		ENDIF
		
		*** MODIFICA CAMPO "EXPR"
		_prima = Expr
		_dopo  = STRTRAN(_prima,_par_cExpressionSought,_par_cReplacement)
		REPLACE Expr WITH _dopo
		
		_lUpdated = .T.
	
	ENDSCAN
	IF _lUpdated
		_CONTA = _CONTA + 1
	ENDIF
	USE
ENDFOR

SET DEFA TO &_pub_dir_

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
			  "Totale report elaborati e aggiornati: " + ALLTRIM(STR(_CONTA)) + CHR(13) + CHR(13) + ;
			  "Non è necessario ricompilare il progetto",64,"Informazione")

RETURN
