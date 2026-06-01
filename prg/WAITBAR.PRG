
PARAMETERS _FRMREF,_CURSORE,_CANCEL,_TITOLO

RELEASE _PREC_CUR
PUBLIC _PREC_CUR
_PREC_CUR = SELECT()

IF PARAMETERS() < 2
   RETURN
ENDIF

IF PARAMETERS() > 2
ELSE
   _CANCEL = .F.
ENDIF

IF PARAMETERS() > 3
ELSE
   _TITOLO = "Elaborazione in corso..."
ENDIF

IF !USED(_CURSORE)
   RETURN
ENDIF

RELEASE _FRMREF_WAITBAR,_CURSOR_WAITBAR 
PUBLIC  _FRMREF_WAITBAR,_CURSOR_WAITBAR 
_FRMREF_WAITBAR = _FRMREF
_CURSOR_WAITBAR = _CURSORE

IF TYPE("_OBJ_WAITBAR") <> 'O' .OR. ISNULL(_OBJ_WAITBAR)
   RELEASE _OBJ_WAITBAR
   PUBLIC  _OBJ_WAITBAR
   DEFINE WINDOW WAITBAR FROM 0,0 TO 1,1 NAME _OBJ_WAITBAR TITLE ALLTRIM(_TITOLO)
   WITH _OBJ_WAITBAR
      .Width = 512
      .Height = IIF(_CANCEL,50,27)
      .Top = 5
      .Left = _SCREEN.Width - .Width - 5
      .BackColor = RGB(236,233,216)
      .AddObject("OleProgressBar","olecontrol","COMCTL.ProgCtrl.1")
      .OleProgressBar.Top = 5
      .OleProgressBar.Left = 5
      .OleProgressBar.Width = .Width - 10
      .OleProgressBar.Visible = .T.      
      
      *.AddObject("TmrWaitbar","HarryTimer")
      *.TmrWaitbar.Interval = 1000

      IF _CANCEL
         .AddObject("Cmd_Annulla","HarryCommandButton")
         .Cmd_Annulla.FontName = "Arial"
         .Cmd_Annulla.FontSize = 8
         .Cmd_Annulla.FontBold = .T.
         .Cmd_Annulla.Caption = "Annulla"
         .Cmd_Annulla.ForeColor = RGB(0,0,255)
         .Cmd_Annulla.Top = 25
         .Cmd_Annulla.Left = 5
         .Cmd_Annulla.Width = .OleProgressBar.Width
         .Cmd_Annulla.Height = 20
         .Cmd_Annulla.SpecialEffect = 2
         .Cmd_Annulla.Visible = .T.
         .Cmd_Annulla.SetFocus
      ENDIF
   ENDWITH
ENDIF

RELEASE _VALORE_WAITBAR
PUBLIC  _VALORE_WAITBAR
_VALORE_WAITBAR = 0
SELECT &_CURSOR_WAITBAR
_VALORE_WAITBAR = IIF(RECCOUNT() > 0 .AND. !EOF(),(RECNO() * 100) / RECCOUNT(),0)

IF _VALORE_WAITBAR <= 0 .OR. _VALORE_WAITBAR >= 100
   RELEASE _OBJ_WAITBAR,_VALORE_WAITBAR
   RELEASE WINDOW WAITBAR
   SELECT(_PREC_CUR)
   IF TYPE("_FRMREF_WAITBAR") == 'O'
      _FRMREF_WAITBAR.Enabled = .T.
   ENDIF
   RETURN
ENDIF

MODIFY WINDOW WAITBAR TITLE ALLTRIM(_TITOLO)

_OBJ_WAITBAR.OleProgressBar.Value = _VALORE_WAITBAR

WAIT CLEAR

IF WEXIST("WAITBAR")
   ACTIVATE WINDOW WAITBAR
ENDIF

_FRMREF_WAITBAR.Enabled = .F.

DOEVENTS 

SELECT(_PREC_CUR)

RETURN



DEFINE CLASS HarryCommandButton AS CommandButton
   
   PROCEDURE Click
      
      _RISP = MESSAGEBOX("Annullare l'operazione in corso?",4+48+256,"Attenzione")
      
      IF _RISP = 6
         SELECT &_CURSOR_WAITBAR
         ZAP
         MESSAGEBOX("Operazione annullata",64,"Informazione")
         RELEASE _OBJ_WAITBAR,_VALORE_WAITBAR
         RELEASE WINDOW WAITBAR
         IF USED(_PREC_CUR)
            SELECT(_PREC_CUR)
         ENDIF
         IF TYPE("_FRMREF_WAITBAR") == 'O'
            _FRMREF_WAITBAR.Enabled = .T.
         ENDIF
      ENDIF
      
   ENDPROC
   
ENDDEFINE 


*!*	DEFINE CLASS HarryTimer AS Timer

*!*	   PROCEDURE Timer
*!*	      
*!*	      TEST = .T.
*!*	      IF TEST
*!*	      ELSE
*!*	         RELEASE _OBJ_WAITBAR,_VALORE_WAITBAR
*!*	         RELEASE WINDOW _WAITBAR
*!*	         IF TYPE("_FRMREF_WAITBAR") == 'O'
*!*	            _FRMREF_WAITBAR.Enabled = .T.
*!*	         ENDIF
*!*	         RETURN         
*!*	      ENDIF
*!*	      
*!*	   ENDPROC
*!*	   
*!*	ENDDEFINE