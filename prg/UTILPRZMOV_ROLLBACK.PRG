
****************************************************************************************
*** UTILITY PER IL "Ripristino modifica massiva movimenti di magazzino per articolo" ***
****************************************************************************************

WAIT WINDOWS "Ricerca elaborazioni effettuate in corso..." NOWAIT

cSql = "SELECT SPACE(10) AS SELEZIONE, DATA_ELAB, ORA_ELAB, SYS_ELAB, DESCR_ELAB FROM UTILPRZMOV " + ;
	"GROUP BY DATA_ELAB, ORA_ELAB, SYS_ELAB, DESCR_ELAB ORDER BY DATA_ELAB DESC,ORA_ELAB DESC"
IF !ExecCommand(cSql,"SEL_UTILPRZMOV")
  return(.f.)
ENDIF
SELECT SEL_UTILPRZMOV
GO TOP
IF EOF()
	WAIT CLEAR
	MESSAGEBOX("Nessuna elaborazione effettuata da selezionare",48,"Attenzione")
	RETURN
ENDIF

WAIT CLEAR

DO PRG\browseview WITH "SEL_UTILPRZMOV","Seleziona l'elaborazione da annullare","DATA_ELAB:Data elaboraz.,W:10;ORA_ELAB:Ora elaboraz.,W:10;" + ;
	"DESCR_ELAB:Descrizione,W:120;",600,1000,.F.
IF NumeroRecordLetti > 0
ELSE
	MESSAGEBOX("Nessuna elaborazione selezionata",64,"Attenzione")
	RETURN .F.
ENDIF

_SEL_SYS_ELAB = ""

SELECT * FROM SEL_UTILPRZMOV WHERE ALLTRIM(SELEZIONE) == "==>" INTO CURSOR TMP_SELEZIONATI
SELECT TMP_SELEZIONATI
GO TOP
IF RECCOUNT() > 1
	MESSAGEBOX("Selezionare una elaborazione per volta",16,"Attenzione")
	RETURN .F.
ENDIF

_V_RISP = MESSAGEBOX("Continuare con il ripristino elaborazione del " + RIBALTA2(DATA_ELAB) + " alle " + ORA_ELAB + " ?" + CHR(13) + CHR(13) + ;
			"N.B.: Le tabelle verranno aggiornate allo stato appena precedente l'elaborazione selezionata, e tale elaborazione verrà completamente eliminata.",4+32+256,"Attenzione")
IF _V_RISP = 6
ELSE
	MESSAGEBOX("Operazione annullata",64,"Attenzione")
	RETURN
ENDIF

WAIT WINDOWS "Ripristino elaborazione del " + RIBALTA2(DATA_ELAB) + " alle " + ORA_ELAB + " in corso..." NOWAIT

_SEL_SYS_ELAB = SYS_ELAB

_V_COUNT_MOV = 0
_V_COUNT_MAG = 0
_V_COUNT_BFO = 0

*** RIPRISTINO CAMPI TABELLE AL VALORE APPENA PRECEDENTE L'ELABORAZIONE SELEZIONATA
x_syel = "SYS_ELAB = '" + _SEL_SYS_ELAB + "'"
x_cond = x_syel
cSql = "Select * from UTILPRZMOV where " + x_cond
IF !ExecCommand(cSql,"CX_UTILPRZMOV")
	return(.f.)
ENDIF
SELECT CX_UTILPRZMOV
GO TOP
SCAN

	WAIT WINDOWS "Ripristino elaborazione del " + RIBALTA2(DATA_ELAB) + " alle " + ORA_ELAB + ;
		"  (record " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ") ..." NOWAIT

	_TABLENAME = ALLTRIM(TABLENAME)
	_FIELDNAME = ALLTRIM(FIELDNAME)
	_TIDUNIQUE = ALLTRIM(TIDUNIQUE)
	_ID_UNIQUE = ID_UNIQUE
	_OLD_PREACQ = OLD_PREACQ
	x_cond = "ID_UNIQUE = '" + _TIDUNIQUE + "'"
	cSql = "UPDATE " + _TABLENAME + " SET " + _FIELDNAME + " = " + STRTRAN(ALLTRIM(STR(_OLD_PREACQ,17,6)),",",".") + " WHERE " + x_cond
	IF !ExecCommand(cSql,"TMP_UPDATE")
		return(.f.)
	ENDIF
		
	DO CASE
	
		CASE ALLTRIM(_TABLENAME) = "U_MAG_MO"

			x_cond = "ID_UNIQUE = '" + _TIDUNIQUE + "'"
			cSql = "SELECT * FROM U_MAG_MO WHERE " + x_cond
			IF !ExecRW(cSql,"U_MAG_MO","R")
				return(.f.)
			ENDIF
			SELECT U_MAG_MO
			GO TOP
			IF !EOF()

				*** CERCO L'UNITA' DI MISURA DI ACQUISTO DELL'ARTICOLO PER VALORIZZARE IL MOVIMENTO
				_X_UNIMIS = ""
				_X_QTAXVAL = MOV_QTAMOV
				x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
				x_codi = "art_codpri = '" + ALLTRIM(MOV_ANAART) + "'"
				x_cond = x_soci + " and " + x_codi
				Csql   = "select art_unimis from u_art_pr where " + x_cond
				IF !ExecCommand(cSql,"cur_articoli")
				   return(.f.)
				ENDIF
				SELECT cur_articoli
				GO TOP
				IF !EOF()
					_X_UNIMIS = ART_UNIMIS
				ENDIF
				SELECT U_MAG_MO
				DO CASE
					CASE ALLTRIM(_X_UNIMIS) == "KG"
						_X_QTAXVAL = MOV_QTAKG
					CASE ALLTRIM(_X_UNIMIS) == "MQ"
						_X_QTAXVAL = MOV_QTAMQ
					CASE ALLTRIM(_X_UNIMIS) == "ML"
						_X_QTAXVAL = MOV_QTAML
				ENDCASE
				IF _X_QTAXVAL <= 0
					_X_QTAXVAL = MOV_QTAMOV
				ENDIF
				
				SELECT U_MAG_MO
				REPLACE MOV_VALACQ WITH ROUND(_X_QTAXVAL*MOV_PREACQ,2)
				
				_V_COUNT_MOV = _V_COUNT_MOV + 1
				
				*** ELIMINAZIONE RECORD DI LOG RIPRISTINATO
				x_cond = "ID_UNIQUE = '" + _ID_UNIQUE + "'"
				cSql = "DELETE from UTILPRZMOV where " + x_cond
				IF !ExecCommand(cSql,"DEL_UTILPRZMOV")
					return(.f.)
				ENDIF
				
			ENDIF		
			IF !ExecRW(cSql,"U_MAG_MO","W")
				return(.f.)
			ENDIF

			
		CASE ALLTRIM(_TABLENAME) = "U_BFO_DD"
			
			_AGGANCIO = ""
			x_cond = "ID_UNIQUE = '" + _TIDUNIQUE + "'"
			Csql = "select * FROM U_BFO_DD where " + x_cond
			IF !ExecRW(cSql,"U_BFO_DD","R")
			   return(.f.)
			ENDIF
			SELECT U_BFO_DD
			GO TOP
			IF !EOF()
				
				_AGGANCIO = DAGGANCIO
				
				*** RICALCOLO IL PREZZO EFFETTIVO DAL PREZZO NETTO AGGIUNGENDO EVENTUALI SCONTI
				_ORD_PREZZO = ORD_PRZNET
				_ORD_PREZZO = ROUND(_ORD_PREZZO / (1 - (ORD_SC3/100)),6)
				_ORD_PREZZO = ROUND(_ORD_PREZZO / (1 - (ORD_SC2/100)),6)
				_ORD_PREZZO = ROUND(_ORD_PREZZO / (1 - (ORD_SC1/100)),6)
				REPLACE ORD_VALORE WITH ROUND(ORD_QTAORD*ORD_PRZNET,2)
				REPLACE ORD_PREZZO WITH _ORD_PREZZO
				
				_V_COUNT_BFO = _V_COUNT_BFO + 1
				
				*** ELIMINAZIONE RECORD DI LOG RIPRISTINATO
				x_cond = "ID_UNIQUE = '" + _ID_UNIQUE + "'"
				cSql = "DELETE from UTILPRZMOV where " + x_cond
				IF !ExecCommand(cSql,"DEL_UTILPRZMOV")
					return(.f.)
				ENDIF
				
			ENDIF
			IF !ExecRW(cSql,"U_BFO_DD","W")
			   return(.f.)
			ENDIF
			IF !EMPTY(_AGGANCIO)
				*** RICALCOLO DEL VALORE IN TESTATA DOCUMENTO DI CARICO
				x_agga = "daggancio = '" + _AGGANCIO + "'"
				x_cond = x_agga 
				cSql   = "SELECT * FROM U_BFO_DD WHERE " + x_cond + " ORDER BY ORD_SEQUEN"
				IF !ExecCommand(cSql,"CU_BFO_DD")
				   return(.f.)
				ENDIF 

				x_agga = "taggancio = '" + _AGGANCIO + "'"
				x_cond = x_agga 
				cSql   = "SELECT * FROM U_BFO_TT WHERE " + x_cond
				IF !ExecRW(cSql,"U_BFO_TT","R")
				   return(.f.)
				ENDIF 
				SELECT U_BFO_TT
				GO TOP
				=DEFPUB(SELECT())
				SCATTER MEMVAR MEMO

				RELEASE M.T_IMPONIB
				PUBLIC  M.T_IMPONIB
				M.T_IMPONIB = 0
				SELECT CU_BFO_DD
				DO CALCBFO			  		
				M.ORD_VALIMP = M.T_IMPONIB

				SELECT U_BFO_TT
				GO TOP
				IF !EOF()
				   REPLACE ORD_VALORE WITH M.ORD_VALORE
				   REPLACE ORD_VALIMP WITH M.ORD_VALIMP
				ENDIF
				IF !ExecRW(cSql,"U_BFO_TT","W")
				   return(.f.)
				ENDIF

			ENDIF
			
		CASE ALLTRIM(_TABLENAME) = "U_MAG_GG"
		
			x_cond = "ID_UNIQUE = '" + _TIDUNIQUE + "'"
			cSql = "SELECT * FROM U_MAG_GG WHERE " + x_cond
			IF !ExecCommand(cSql,"TMP_MAG_GG")
				return(.f.)
			ENDIF
			SELECT TMP_MAG_GG
			GO TOP
			IF !EOF()
				
				_V_COUNT_MAG = _V_COUNT_MAG + 1
				
				*** ELIMINAZIONE RECORD DI LOG RIPRISTINATO
				x_cond = "ID_UNIQUE = '" + _ID_UNIQUE + "'"
				cSql = "DELETE from UTILPRZMOV where " + x_cond
				IF !ExecCommand(cSql,"DEL_UTILPRZMOV")
					return(.f.)
				ENDIF
				
			ENDIF
			
	ENDCASE	
	
ENDSCAN

WAIT CLEAR

IF _V_COUNT_MOV > 0 .OR. _V_COUNT_MAG > 0 .OR. _V_COUNT_BFO > 0
	MESSAGEBOX(ALLTRIM(STR(_V_COUNT_MOV,10,0)) + " movimenti ripristinati" + CHR(13) + CHR(13) + ;
		ALLTRIM(STR(_V_COUNT_MAG,10,0)) + " giacenze ripristinate" + CHR(13) + CHR(13) + ;
		ALLTRIM(STR(_V_COUNT_BFO,10,0)) + " dettagli documenti di carico ripristinati",64,"Informazione")
ELSE
	MESSAGEBOX("Nessun movimento ripristinato",64,"Attenzione")
ENDIF

RETURN
