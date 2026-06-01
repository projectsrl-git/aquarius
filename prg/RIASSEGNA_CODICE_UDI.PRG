
_RISP = MESSAGEBOX("Utilità di riassegnazione Codice UDI (U_ART_PR.ART_BARCLI):" + REPLICATE(CHR(13),2) + ;
			"1) Azzera il numeratore NUMUDI" + CHR(13) + ;
			"2) Svuota il campo U_ART_PR.ART_BARCLI su tutti gli articoli" + CHR(13) + ;
			"3) Popola il campo U_ART_PR.ART_BARCLI su tutti gli articoli di 'Produzione', con flag 'Dispositivo Medico' e Prezzo di vendita valorizzato" + REPLICATE(CHR(13),2) + ;
			"Continuare?",4+32,"Attenzione")

IF _RISP = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Azzeramento il numeratore NUMUDI..." NOWAIT

_seek = 'NUMUDI' + PUB_CODSOC
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = ?_seek
	order by codice
ENDTEXT
IF !ExecRW(cSql,"para","R")
  return(.f.)
ENDIF
IF RECCOUNT() > 0
	REPLACE LIBERA WITH "0"
ELSE
	IF !ExecRW(cSql,"para","W")
	  return(.f.)
	ENDIF
	MESSAGEBOX('Parametro << NUMUDI >> non trovato',16,'*** ATTENZIONE ***')
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF
IF !ExecRW(cSql,"para","W")
  return(.f.)
ENDIF

WAIT WINDOWS "Svuotamento il campo U_ART_PR.ART_BARCLI su tutti gli articoli..." NOWAIT

IF !ExecCommand("UPDATE U_ART_PR SET ART_BARCLI = '' where ART_BARCLI <> ''","UPD_ART_PR")
  return(.f.)
ENDIF

WAIT WINDOWS "Riassegnazione codice UDI..." NOWAIT

_TOT_NUOVI_UDI = 0

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_tart = "ART_TIPART = 'P'"
x_prez = "(ART_PRZVEN > 0 OR ART_PRZVE2 > 0)"
x_fudi = "ART_CODPRI IN (SELECT ART_CODPRI FROM U_ART_AN WHERE ART_FLGUDI = 1)"
x_cond = x_soci + " and " + x_tart + " and " + x_prez + " and " + x_fudi 
Csql   = "select ART_CODPRI,ART_DESCR from u_art_pr where " + x_cond + " order by art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
BROWSE NORMAL
SCAN
	
	WAIT WINDOWS "Riassegnazione codice UDI all'articolo " + ALLTRIM(ART_CODPRI) + " ..." NOWAIT
	
	_cCodUdi = NUOVO_CODICE_UDI()
	IF EMPTY(_cCodUdi)
		EXIT
	ENDIF
	
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + ALLTRIM(ART_CODPRI) + "'"
	x_cond = x_soci + " and " + x_codi 
	cSql   = "UPDATE U_ART_PR SET ART_BARCLI = '" + _cCodUdi +  "' WHERE " + x_cond
	IF !ExecCommand(cSql,"UPD_ART_PR")
	  return(.f.)
	ENDIF
	
	_TOT_NUOVI_UDI = _TOT_NUOVI_UDI + 1
	
ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione completata" + REPLICATE(CHR(13),2) + ;
	"Totale articoli: " + ALLTRIM(STR(_TOT_NUOVI_UDI,10,0)),64,"Informazione")

RETURN .T.
