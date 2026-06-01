
*** DEFINIZIONE CLASSE PER CheckBox CHE RAPPRESENTANO I TECNICI 
DEFINE CLASS CheckBoxTecnico AS CheckBox

	PROCEDURE Valid	

		THISFORM.ricarica_interventi()
		THISFORM.Refresh

	ENDPROC
	
	PROCEDURE RightClick
	
		_choice = 0
		DEFINE POPUP generatePop SHORTCUT RELATIVE FROM MROW(),MCOL()
		DEFINE BAR 1 OF generatePop PROMPT "\<Modifica colore"
		&&DEFINE BAR 3 OF generatePop PROMPT "\<Riprogrammazione scadenze ordine" SKIP FOR M.CHIUSO
		ON SELECTION BAR 1 OF generatePop _choice = 1

		ACTIVATE POPUP generatePop

		DO CASE
			CASE _choice = 1
								
				x_cond = "codice = 'TEI" + THIS.Tag + "'"
				cSql   = "select SUBSTRING(CODICE,4,6) AS CODICE, DESCRI, CODPGO from para where " + x_cond
				IF !ExecCommand(cSql,"TMP_TECNICO")
				   return(.f.)
				ENDIF
				SELECT TMP_TECNICO
				GO TOP
				IF EOF()
					MESSAGEBOX("Tecnico non trovato",16,"Attenzione")
					RETURN .F.
				ENDIF
				
				_actColor = THIS.BackColor
				nNewColor = GETCOLOR(_actColor)
				IF nNewColor > 0
					THIS.BACKCOLOR = nNewColor
					x_cond = "codice = 'TEI" + THIS.Tag + "'"
					cSql   = "select * from para where " + x_cond
					IF !ExecRW(cSql,"PARA","R")
					  return(.f.)
					ENDIF
					SELECT PARA
					GO TOP
					IF !EOF()
						REPLACE CODPGO WITH STR(nNewColor,10,0)
					ENDIF
					IF !ExecRW(cSql,"PARA","W")
					  return(.f.)
					ENDIF
					
					THISFORM.ricarica_interventi()
				ELSE
					MESSAGEBOX("Nessun colore selezionato",64,"Informazione")
				ENDIF
				
				
			OTHERWISE
				
				RETURN .F.

		ENDCASE
	
	ENDPROC

ENDDEFINE


*** DEFINIZIONE CLASSE PER Shape CONTENUTA IN Container CHE RAPPRESENTA IL GIORNO NEL CALENDARIO
DEFINE CLASS ShapeGGCalendar AS Shape
	
*!*		PROCEDURE MouseLeave
*!*		
*!*			LPARAMETERS nButton, nShift, nXCoord, nYCoord

*!*			*this.BorderStyle = 0
*!*			THISFORM.container1.shape2.BorderWidth = 1
*!*			
*!*			THIS.Parent.label1.FontBold = .F.
*!*			
*!*			*THIS.Parent.label1.FORECOLOR = RGB(0,0,160)
*!*					
*!*		ENDPROC


*!*		PROCEDURE MouseEnter
*!*		
*!*			LPARAMETERS nButton, nShift, nXCoord, nYCoord

*!*			*this.BorderStyle = 1
*!*			THISFORM.container1.shape2.BorderWidth = 2
*!*			
*!*			THIS.Parent.label1.FontBold = .T.
*!*			
*!*			*THIS.Parent.label1.ForeColor = RGB(255,0,0)
*!*			
*!*		ENDPROC


	PROCEDURE Click
	
		IF TYPE("THIS.Parent.Parent.LblSpostamentoIntTec") == 'O'
					
			THIS.Parent.Parent.TimerSposta.Interval = 0
			
			IF ALLTRIM(THIS.Parent.Parent.LblSpostamentoIntTec.data_intervento) = ALLTRIM(THIS.Parent.Tag)
				MESSAGEBOX("Nessuno spostamento effettuato",64,"Attenzione")
			ELSE
				_RISP = MESSAGEBOX("Spostare l'intervento al " + ALLTRIM(THIS.Parent.Tag) + " ?",4+32,"Attenzione")
				IF _RISP = 6
					x_agga = "DAGGANCIO = '" + ALLTRIM(THIS.Parent.Parent.LblSpostamentoIntTec.daggancio) + "'"
					x_csys = "ORD_CODSYS = '" + ALLTRIM(THIS.Parent.Parent.LblSpostamentoIntTec.codsys) + "'"
					x_cond = x_agga + " and " + x_csys
					cSql   = "select * from VENDITE_DT where " + x_cond
					IF !ExecRW(cSql,"VENDITE_DT","R")
					   return(.f.)
					ENDIF
					SELECT VENDITE_DT
					GO TOP
					IF !EOF()
						REPLACE ORD_DTPROGR WITH RIBALTA2(ALLTRIM(THIS.Parent.Tag))
					ENDIF
					IF !ExecRW(cSql,"VENDITE_DT","W")
					   return(.f.)
					ENDIF
				ELSE
					MESSAGEBOX("Nessuno spostamento effettuato",64,"Attenzione")
				ENDIF
			ENDIF
			
			THIS.Parent.Parent.LblSpostamentoIntTec.spostamento_attivo = .F.
			THIS.Parent.Parent.RemoveObject("LblSpostamentoIntTec")
			
		ENDIF
		
		_V_DATSEL = CTOD(THIS.Parent.Tag)
		THISFORM.redraw_calendar(.T.)
		
	ENDPROC
	
	PROCEDURE RightClick
		
		LOCAL _actForm
		_actForm = THISFORM
		_V_DATSEL = CTOD(THIS.Parent.Tag)
		THISFORM.redraw_calendar(.T.)
		
		_choice = 0
		DEFINE POPUP generatePop SHORTCUT RELATIVE FROM MROW(),MCOL()
		DEFINE BAR 1 OF generatePop PROMPT "\<Inserisci Nuovo Intervento..."
		&&DEFINE BAR 3 OF generatePop PROMPT "\<Riprogrammazione scadenze ordine" SKIP FOR M.CHIUSO
		ON SELECTION BAR 1 OF generatePop _choice = 1

		ACTIVATE POPUP generatePop

		DO CASE
			CASE _choice = 1
				_actForm.Hide
				WAIT WINDOWS "Apertura gestionale in corso..." nowait
				*DO FORM FORM\MENU_INR000 WITH .T. LINKED
				DO FORM FORM\MENU_INR000 LINKED
				_actForm.Show
				
				_actForm.redraw_calendar(.T.)
				
			OTHERWISE
				
				RETURN .F.

		ENDCASE

		
	ENDPROC

ENDDEFINE


*** DEFINIZIONE CLASSE PER Label CHE RAPPRESENTANO GLI INTERVENTI ALL'INTERNO delle ShapeGGCalendar
DEFINE CLASS LblInterventoTecnico AS Label
	
	PROCEDURE Init
		
		This.AddProperty("codice_tecnico", "", 1, "Codice Tecnico")
		This.AddProperty("daggancio", "", 1, "Daggancio")
		This.AddProperty("codsys", "", 1, "Ord_CodSys")
		This.AddProperty("orainipro", "", 1, "Ora inizio")
		This.AddProperty("orafinpro", "", 1, "Ora fine")
		This.AddProperty("durata_sec", "", 1, "Durata intervento in secondi")
	
	ENDPROC
	
	
	PROCEDURE RightClick
		
		LOCAL _actForm
		_actForm = THISFORM
		_V_DATSEL = CTOD(THIS.Parent.Tag)
		THISFORM.evidenzia_datasel()
		
		_choice = 0
		DEFINE POPUP generatePop SHORTCUT RELATIVE FROM MROW(),MCOL()
		DEFINE BAR 1 OF generatePop PROMPT "\<Gestione Intervento"
		DEFINE BAR 2 OF generatePop PROMPT "\<Sposta"
		ON SELECTION BAR 1 OF generatePop _choice = 1
		ON SELECTION BAR 2 OF generatePop _choice = 2

		ACTIVATE POPUP generatePop

		DO CASE
			CASE _choice = 1
				_actForm.Hide
				WAIT WINDOWS "Apertura gestionale in corso..." nowait
				SET STEP ON
				*DO FORM FORM\MENU_INR000 WITH .F.,ALLTRIM(THIS.codice_tecnico),ALLTRIM(THIS.daggancio) LINKED
				DO FORM FORM\MENU_INR000 WITH ALLTRIM(THIS.daggancio),"",ALLTRIM(THIS.codice_tecnico),.F. LINKED
				_actForm.Show
				
				_actForm.redraw_calendar(.T.)
				
				
			CASE _choice = 2
			
				_actCnt = THIS.PARENT
				_actPageFrame = THIS.PARENT.PARENT
				_actPageFrame.AddObject("LblSpostamentoIntTec","LblSpostamento")
				_actPageFrame.LblSpostamentoIntTec.Left = THIS.Left
				_actPageFrame.LblSpostamentoIntTec.Top = THIS.Top
				_actPageFrame.LblSpostamentoIntTec.Width = THIS.Width
				_actPageFrame.LblSpostamentoIntTec.Height = THIS.Height
				_actPageFrame.LblSpostamentoIntTec.BackColor = THIS.BackColor
				_actPageFrame.LblSpostamentoIntTec.ForeColor = THIS.ForeColor
				_actPageFrame.LblSpostamentoIntTec.Caption = THIS.Caption
				_actPageFrame.LblSpostamentoIntTec.Visible = .T.
				_actPageFrame.LblSpostamentoIntTec.daggancio = THIS.daggancio
				_actPageFrame.LblSpostamentoIntTec.codsys = THIS.codsys
				_actPageFrame.LblSpostamentoIntTec.data_intervento = _actCnt.Tag
				_actPageFrame.LblSpostamentoIntTec.spostamento_attivo = .T.
				_actPageFrame.TimerSposta.Interval = 50
				THIS.VISIBLE = .F.
				
			OTHERWISE
				
				_actForm.redraw_calendar(.T.)
				RETURN .F.

		ENDCASE
		
	ENDPROC
	
	
	PROCEDURE MOUSEENTER
	
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		this.BorderStyle = 1
		
	ENDPROC
	
	PROCEDURE MOUSELEAVE
	
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		this.BorderStyle = 0
		
	ENDPROC

ENDDEFINE


*** DEFINIZIONE CLASSE PER Label PER SPOSTARE GLI INTERVENTI ALL'INTERNO delle ShapeGGCalendar
DEFINE CLASS LblSpostamento AS Label
	
	PROCEDURE Init
		
		This.AddProperty("daggancio", "", 1, "Daggancio")
		This.AddProperty("codsys", "", 1, "Ord_CodSys")
		This.AddProperty("data_intervento", "", 1, "")
		This.AddProperty("spostamento_attivo", .F., 1, "")
	
	ENDPROC
	
	
	PROCEDURE Click
		
		This.spostamento_attivo = .F.
	
	ENDPROC


ENDDEFINE


*** DEFINIZIONE CLASSE PER Label GIORNO ShapeGGCalendar
DEFINE CLASS LblGGCalendar AS Label
	
	PROCEDURE Click
	
*!*			IF TYPE("THIS.Parent.Parent.LblSpostamentoIntTec") == 'O'
*!*						
*!*				THIS.Parent.Parent.TimerSposta.Interval = 0
*!*				
*!*				IF ALLTRIM(THIS.Parent.Parent.LblSpostamentoIntTec.data_intervento) = ALLTRIM(THIS.Parent.Tag)
*!*					MESSAGEBOX("Nessuno spostamento effettuato",64,"Attenzione")
*!*				ELSE
*!*					_RISP = MESSAGEBOX("Spostare l'intervento al " + ALLTRIM(THIS.Parent.Tag) + " ?",4+32,"Attenzione")
*!*					IF _RISP = 6
*!*						x_agga = "DAGGANCIO = '" + ALLTRIM(THIS.Parent.Parent.LblSpostamentoIntTec.daggancio) + "'"
*!*						x_csys = "ORD_CODSYS = '" + ALLTRIM(THIS.Parent.Parent.LblSpostamentoIntTec.codsys) + "'"
*!*						x_cond = x_agga + " and " + x_csys
*!*						cSql   = "select * from VENDITE_DT where " + x_cond
*!*						IF !ExecRW(cSql,"VENDITE_DT","R")
*!*						   return(.f.)
*!*						ENDIF
*!*						SELECT VENDITE_DT
*!*						GO TOP
*!*						IF !EOF()
*!*							REPLACE ORD_DTPROGR WITH RIBALTA2(ALLTRIM(THIS.Parent.Tag))
*!*						ENDIF
*!*						IF !ExecRW(cSql,"VENDITE_DT","W")
*!*						   return(.f.)
*!*						ENDIF
*!*					ELSE
*!*						MESSAGEBOX("Nessuno spostamento effettuato",64,"Attenzione")
*!*					ENDIF
*!*				ENDIF
*!*				
*!*				THIS.Parent.Parent.LblSpostamentoIntTec.spostamento_attivo = .F.
*!*				THIS.Parent.Parent.RemoveObject("LblSpostamentoIntTec")
*!*				
*!*			ENDIF

		_V_DATSEL = CTOD(THIS.Parent.Tag)
		THISFORM.redraw_calendar(.T.)
		
	ENDPROC


ENDDEFINE