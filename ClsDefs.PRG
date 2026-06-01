
DEFINE CLASS C AS COLUMN
	FONTNAME="Arial"
	SPARSE=.F.
	PROCEDURE INIT
	LPARAMETERS cCtrlSource,cCaption,cTypeCell,cRecordSource
	IF EMPTY(cTypeCell)
		cTypeCell="txt"
	ENDIF
	THIS.ADDOBJECT("H1","myHEADER")
	THIS.H1.FONTBOLD=.F.
	THIS.H1.CAPTION=cCaption
	THIS.H1.Alignment=2
	THIS.H1.BackColor=RGB(0,0,128)
	THIS.H1.ForeColor=RGB(255,255,255)
	DO CASE
		CASE cTypeCell="txt"
			THIS.ADDOBJECT("T1","myText")
			THIS.T1.mousepointer=99
			THIS.T1.mouseicon="h_point.cur"
		CASE cTypeCell="cbo"
			THIS.ADDOBJECT("T1","myCombo")
		CASE cTypeCell="chk"
			THIS.ADDOBJECT("T1","myCheck")
		CASE cTypeCell="edt"
			THIS.ADDOBJECT("T1","myEdit")
		OTHERWISE
			THIS.ADDOBJECT("T1","myText")
			THIS.T1.mousepointer=99
			THIS.T1.mouseicon="h_point.cur"
	ENDCASE
	THIS.CURRENTCONTROL="T1"
	THIS.CONTROLSOURCE=cCtrlSource
	IF cTypeCell="cbo"
		THIS.T1.ROWSOURCE=cRecordSource
		THIS.T1.COLUMNCOUNT=1+OCCURS(",",cRecordSource)
	ENDIF
	THIS.REMOVEOBJECT("Text1")
	THIS.PARENT.SetOtherCharacteristics(THIS,THIS.H1,THIS.T1)
	***********************
	PROCEDURE RIGHTCLICK
	THIS.PARENT.ColumnRightClick(THIS,THIS.H1,THIS.T1)	
ENDDEFINE
**************************************
DEFINE CLASS myHeader AS HEADER
	PROCEDURE INIT
	IF VERSION(5)>=700
		WORDWRAP=.T.
	ENDIF
	**=> ERASMO - INIZIO 02/11/2022
	THIS.mousepointer = 99
	THIS.mouseicon = ""
	**=> ERASMO - FINE 02/11/2022
	*MyHeader::
	PROCEDURE RIGHTCLICK
	*the method HeaderRightClick must exist in the grid
	THIS.PARENT.PARENT.HeaderRightClick(THIS,THIS.PARENT)
	***********************
	PROCEDURE CLICK
	*the method HeaderRightClick must exist in the grid
	THIS.PARENT.PARENT.HeaderClick(THIS,THIS.PARENT)
	***********************
	PROCEDURE DBLCLICK
	*the method HeaderRightClick must exist in the grid
*	THIS.PARENT.PARENT.HeaderDblClick(THIS,THIS.PARENT)

	**=> ERASMO - INIZIO 02/11/2022
	PROCEDURE MOUSEENTER
	LPARAMETERS nButton, nShift, nXCoord, nYCoord
	IF THIS.PARENT.PARENT.attivafunzioniheader
		THIS.FORECOLOR = RGB(255,0,0)
	ENDIF
	
	PROCEDURE MOUSELEAVE
	LPARAMETERS nButton, nShift, nXCoord, nYCoord
	IF THIS.PARENT.PARENT.attivafunzioniheader
		THIS.FORECOLOR = RGB(0,0,0)
	ENDIF
	**=> ERASMO - FINE 02/11/2022
ENDDEFINE
**************************************
DEFINE CLASS myText AS TEXTBOX
	FONTNAME="Arial"
	SPECIALEFFECT=1
	MARGIN=0
	BORDERSTYLE=0
	*Class MyText::
	PROCEDURE RIGHTCLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellRightClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE CLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE DBLCLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellDblClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE KEYPRESS
	*comenta questo evento se non intendi di usarlo
	LPARAMETERS nKeyCode, nShiftAltCtrl
	THIS.PARENT.PARENT.CellKeyPress(THIS,nKeyCode, nShiftAltCtrl)
	****************************
	PROCEDURE INTERACTIVECHANGE
	*comenta questo evento se non intendi di usarlo
	LPARAMETERS nKeyCode, nShiftAltCtrl
	THIS.PARENT.PARENT.CellInteractiveChange(THIS,This.Parent)

ENDDEFINE
**************************************
DEFINE CLASS myCombo AS COMBOBOX
	FONTNAME="Arial"
	SPECIALEFFECT=0
	MARGIN=0
	ROWSOURCETYPE=6 && FIELDS
	*Class MyCombo::
	PROCEDURE RIGHTCLICK
	*the method ComboBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellRightClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE CLICK
	*the method ComboBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE DBLCLICK
	*the method ComboBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellDblClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE KEYPRESS
	*comenta questo evento se non intendi di usarlo
	LPARAMETERS nKeyCode, nShiftAltCtrl
	THIS.PARENT.PARENT.CellKeyPress(THIS,nKeyCode, nShiftAltCtrl)
	****************************
	PROCEDURE INTERACTIVECHANGE
	*comenta questo evento se non intendi di usarlo
	LPARAMETERS nKeyCode, nShiftAltCtrl
	THIS.PARENT.PARENT.CellInteractiveChange(THIS,This.Parent)

ENDDEFINE
***************************************
DEFINE CLASS myCheck AS CHECKBOX
	FONTNAME="Arial"
	SPECIALEFFECT=1
	MARGIN=0
	CAPTION=""
	*Class CheckText::
	PROCEDURE RIGHTCLICK
	*the method CheckBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellRightClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE CLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE DBLCLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellDblClick(THIS,THIS.PARENT)
	***************************************
ENDDEFINE
*****************************************
DEFINE CLASS myEdit AS EDITBOX
	FONTNAME="Arial"
	SPECIALEFFECT=1
	MARGIN=0
	BORDERSTYLE=0
	*Class MyText::
	PROCEDURE RIGHTCLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellRightClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE CLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE DBLCLICK
	*the method TextBoxRightClick must exist in the grid
	THIS.PARENT.PARENT.CellDblClick(THIS,THIS.PARENT)
	****************************
	PROCEDURE KEYPRESS
	*comenta questo evento se non intendi di usarlo
	LPARAMETERS nKeyCode, nShiftAltCtrl
	THIS.PARENT.PARENT.CellKeyPress(THIS,nKeyCode, nShiftAltCtrl)
	****************************
	PROCEDURE INTERACTIVECHANGE
	*comenta questo evento se non intendi di usarlo
	LPARAMETERS nKeyCode, nShiftAltCtrl
	THIS.PARENT.PARENT.CellInteractiveChange(THIS,This.Parent)

ENDDEFINE
**************************************
