* Simple automation with Excel.  Just copy this faq into prg file and run it.
  
* Excel: HorizontalAlignment
* 2 = Left
* 3 = Center
* 4 = Right


WAIT WINDOW "Attendere prego... elaborazione tabulato Excel in corso" NOWAIT

local oExcel, oSheet
oExcel = CreateObject([Excel.Application])
oExcel.Visible = .f.
oExcel.Workbooks.Add()

oSheet = oExcel.ActiveSheet

IF FILE(PUB_LOGO1)
	_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
	oSheet.Pictures.Insert(_FULL_PATH ).Select
	oExcel.Selection.ShapeRange.LockAspectRatio = -1
	oExcel.Selection.ShapeRange.Height = 70
	oExcel.Selection.ShapeRange.Left = 10
	oExcel.Selection.ShapeRange.Top = 10
ENDIF

oSheet.Cells(2,5).Value = PUB_DESCRIZIONE_PROCEDURA
oSheet.Cells(2,5).Font.Bold = .T.
oSheet.Cells(2,5).Font.Size = 14
oSheet.Cells(2,5).HorizontalAlignment = 1


xlUnderlineStyleNone=-4142
xlAutomatic			=-4105
xlCenter			=-4108
xlBottom			=-4107
xlContext			=-5002
False				=.F.
True				=.T.
msoLineSolid = 1
msoShapeRectangle = 1
msoShapeOval = 9
msoShapeDiamond = 4
msoShapeRoundedRectangle = 5
msoShapeTrapezoid = 3
msoShapeParallelogram = 2

_CONTA_BLOCCHI =0

SELECT BLOCCHI
SET ORDER TO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SELECT BLOCCHI
		SKIP
		LOOP
	ENDIF
	
	_CONTA_BLOCCHI = _CONTA_BLOCCHI+1
	
	DO CASE 
		CASE TIPO="sample_start"
			oSheet.Shapes.AddShape(msoShapeOval, LEFT , TOP , WIDTH , HEIGHT ).Select
		CASE TIPO="sample_scelta"
			oSheet.Shapes.AddShape(msoShapeDiamond, LEFT , TOP , WIDTH , HEIGHT ).Select
		CASE TIPO="sample_messaggio"
			oSheet.Shapes.AddShape(msoShapeRectangle, LEFT , TOP , WIDTH , HEIGHT ).Select
		CASE TIPO="sample_output"
			oSheet.Shapes.AddShape(msoShapeRoundedRectangle, LEFT , TOP , WIDTH , HEIGHT ).Select
		CASE TIPO="sample_input"
			oSheet.Shapes.AddShape(msoShapeTrapezoid, LEFT , TOP , WIDTH , HEIGHT ).Select
		CASE TIPO="sample_task"
			oSheet.Shapes.AddShape(msoShapeParallelogram, LEFT , TOP , WIDTH , HEIGHT ).Select
		CASE TIPO="sample_fatturabile"
			oSheet.Shapes.AddShape(msoShapeOval, LEFT , TOP , WIDTH , HEIGHT ).Select
		OTHERWISE
			oSheet.Shapes.AddShape(msoShapeRectangle, LEFT , TOP , WIDTH , HEIGHT ).Select
			
	ENDCASE
				
			
	oExcel.Selection.Characters.Text = TESTO 
	oExcel.Selection.ShapeRange.Fill.Visible = -1
	oExcel.Selection.ShapeRange.Fill.Solid
	oExcel.Selection.ShapeRange.Fill.ForeColor.SchemeColor = 11
	oExcel.Selection.ShapeRange.Line.Visible = True
	oExcel.Selection.ShapeRange.Line.ForeColor.SchemeColor = 64
	oExcel.Selection.ShapeRange.Line.BackColor.RGB = COLORE 
	oExcel.Selection.HorizontalAlignment =2

	_ID_BLOCCO=NOME
	

	SELECT LINEE
	SET ORDER TO BLOCCODA
	SEEK _ID_BLOCCO
	
	DO WHILE !EOF()	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		IF BLOCCODA<>_ID_BLOCCO
			EXIT
		ENDIF

		IF SLANT="\"
			oSheet.Shapes.AddLine(LEFT, TOP,LEFT+WIDTH ,TOP+HEIGHT ).Select
		ELSE
			oSheet.Shapes.AddLine(LEFT, TOP+HEIGHT ,LEFT+WIDTH ,TOP).Select
		ENDIF 
		
		oExcel.Selection.ShapeRange.ZOrder(1)		
		
		
		SELECT LINEE
		SKIP
		
	ENDDO

	SELECT BLOCCHI
	SKIP +1
ENDDO

oExcel.Visible = .T.

RETURN


***************************
* Function C2N
***************************
FUNCTION C2N
LPARAMETERS	cLettera
			
LOCAL lnCol

lnCol=0

IF UPPER(cLettera)>="A"	AND UPPER(cLettera)<"AA"			
	lnCol=ASC(cLettera)-64
ENDIF

IF UPPER(cLettera)>="AA" AND UPPER(cLettera)<"AAA"			
	lnCol=(ASC(SUBSTR(cLettera,1,1))-64)*26+ASC(SUBSTR(cLettera,2,1))-64
ENDIF
		
RETURN lnCol
ENDFUNC
* FINE...Function C2N


***************************
* Function N2C
***************************
FUNCTION N2C
LPARAMETERS	nNumero
			
LOCAL cLettera

IF nNumero<=26
	cLettera=CHR(nNumero+64)
ELSE
	cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)	
ENDIF

RETURN cLettera
ENDFUNC
* FINE...Function C2N


***************************
* Procedure ColoraSelezione
***************************
PROCEDURE ColoraSelezione
LPARAMETERS oExcel,cRangeDiCelle,nColore

IF PCOUNT()<3
	nColore=1
ENDIF


oExcel.Range(cRangeDiCelle).Select
With oExcel.Selection.Interior
    .ColorIndex = nColore
EndWith

RETURN oExcel

ENDPROC
* FINE...Procedure ColoraSelezione
    