
*!****************************************************************************!*
*!* Beginning of program VFPExcel.prg                                        *!*
*!****************************************************************************!*
                                                                                
PARAMETER _NOMECUR,_TITOLO

SELECT &_NOMECUR
GO TOP
IF RECCOUNT() > 65530
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()

WITH objExcel 
*!*	   .Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*	   .Visible = .f.
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 8
*!*	   .Range("A1:IV1").Select
*!*	   .Selection.Font.Size = 10
*!*	   .Selection.Font.Bold = .t.
*!*	   .Columns().EntireColumn.AutoFit
*!*	   .Rows("1:1").EntireRow.Select
*!*	   .Selection.Insert
*!*	   .Selection.Insert
*!*	   .Selection.Insert
   .Range("A1").Select
   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
*!*	   .ActiveWorkbook.Save
*!*	   .ActiveWorkbook.Close
ENDWITH

nFieldNumber = 1
_STRING      = ""
_NUMEROCAMPI = 0
DO WHILE .T.
   _STRING = FIELDS(nFieldNumber,_NOMECUR)
   IF EMPTY(ALLTRIM(_STRING))
      EXIT
   ENDIF
   _NUMEROCAMPI = _NUMEROCAMPI + 1
   nFieldNumber = nFieldNumber + 1
ENDDO

*MESSAGEBOX("Il cursore contiene " + ALLTRIM(STR(_NUMEROCAMPI)) + " campi",64,"Informazione")
_RIGA_INIZIALE = 4

FOR I = 1 TO _NUMEROCAMPI
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeTop    = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin       = 2
xlAutomatic  = -4105
xlSolid      = 1
WITH objExcel.Selection.Borders(xlEdgeBottom)
   .LineStyle = xlContinuous
   .Weight = xlThin
   .ColorIndex = xlAutomatic
ENDWITH
WITH objExcel.Selection.Borders(xlEdgeTop)
   .LineStyle = xlContinuous
   .Weight = xlThin
   .ColorIndex = xlAutomatic
ENDWITH
WITH objExcel.Selection.Interior
   .ColorIndex = 37
   .Pattern = xlSolid
ENDWITH
     
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
objExcel.ActiveSheet.Cells(2,3).Value = _TITOLO
objExcel.ActiveSheet.Cells(2,3).Font.Bold = .T.
objExcel.ActiveSheet.Cells(2,3).Font.Size = 12
objExcel.ActiveSheet.Cells(2,3).HorizontalAlignment = 1

_nRIGA = _RIGA_INIZIALE + 1
SELECT &_NOMECUR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
   
   FOR I = 1 TO _NUMEROCAMPI
      _NOMECAMPO = FIELD(I,_NOMECUR)
      _VALORE = &_NOMECAMPO
      _Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0)) && + ":" + n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      IF TYPE(_NOMECAMPO) = "N"
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "#,##0.00"
      ELSE
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "@"
      ENDIF
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR

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
