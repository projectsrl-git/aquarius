************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
*
* Sintassi:
* 
* DO ESTRXLS WITH <cursore o tabella>,<titolo>
*
* <cursore o tabella>           : é la tabella/cursore che si vuole rappresentare nel file excel
* <titolo>                      : titolo da visualizzare nel file excel
*
********************************************************************************************************************
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

*___INIZIO = TIME()

SELECT &_NOMECUR
GO TOP
IF RECCOUNT() > 65530
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

__numerorighe = RECCOUNT()

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2
xlPrintNoComments = -4142
xlPaperA4 = 9
xlDownThenOver = 1
xlPrintErrorsDisplayed = 0
xlAutomatic = -4105

WITH objExcel 
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 8
   .Range("A1").Select
   
   IF FILE(PUB_LOGO1)
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .ActiveSheet.PageSetup.Orientation = xlLandscape && foglio in orizzontale
      
      With .ActiveSheet.PageSetup
             .PrintTitleRows = ""
             .PrintTitleColumns = ""
			 .PrintArea = ""
	        .LeftHeader = ""
	        .CenterHeader = ""
	        .RightHeader = ""
	        .LeftFooter = ""
	        .CenterFooter = ""
	        .RightFooter = ""
	        .LeftMargin = objExcel.InchesToPoints(0.275590551181102)
	        .RightMargin = objExcel.InchesToPoints(0.275590551181102)
	        .TopMargin = objExcel.InchesToPoints(0.393700787401575)
	        .BottomMargin = objExcel.InchesToPoints(0.393700787401575)
	        .HeaderMargin = objExcel.InchesToPoints(0.393700787401575)
	        .FooterMargin = objExcel.InchesToPoints(0.393700787401575)
*	        .PrintHeadings = False
*	        .PrintGridlines = False
*	        .PrintComments = xlPrintNoComments
*	        .PrintQuality = 1200
*	        .CenterHorizontally = False
*	        .CenterVertically = False
	        .Orientation = xlLandscape
*	        .Draft = False
	        .PaperSize = xlPaperA4
	        .FirstPageNumber = xlAutomatic
	        .Order = xlDownThenOver
*	        .BlackAndWhite = False
*	        .Zoom = False
	        .FitToPagesWide = 1
	        .FitToPagesTall = 10000
	        .PrintErrors = xlPrintErrorsDisplayed
         EndWith
   ENDIF
ENDWITH

nFieldNumber = 1
_STRING      = ""

_NUMEROCAMPI = 29
nFieldNumber = 30

*!*	DO WHILE .T.
*!*	   _STRING = FIELDS(nFieldNumber,_NOMECUR)
*!*	   IF EMPTY(ALLTRIM(_STRING))
*!*	      EXIT
*!*	   ENDIF
*!*	   _NUMEROCAMPI = _NUMEROCAMPI + 1
*!*	   nFieldNumber = nFieldNumber + 1
*!*	ENDDO

*MESSAGEBOX("Il cursore contiene " + ALLTRIM(STR(_NUMEROCAMPI)) + " campi",64,"Informazione")
_RIGA_MESI = 5


FOR I = 4 TO _NUMEROCAMPI STEP 2
	_Range_mesi = n2c(I) + ALLTRIM(STR(_RIGA_MESI)) +    ":"    + n2c(I+1) + ALLTRIM(STR(_RIGA_MESI))
	objExcel.ActiveSheet.Range(_Range_mesi).Select
	WITH objExcel.Selection
    	.WrapText = .F.
	    .Orientation = 0
	    .ShrinkToFit = .F.
	    .MergeCells = .T.
	    .Font.Bold = .T.
	    .Font.Size = 10
	    .HorizontalAlignment = 3  
	    .Interior.ColorIndex = 37
	ENDWITH
	
	objExcel.ActiveSheet.Range(_Range_mesi).Select
	xlEdgeLeft   = 7
	xlEdgeTop    = 8
	xlEdgeBottom = 9
	xlEdgeRight   = 10
	xlContinuous = 1
	xlThin       = 2
	xlAutomatic  = -4105
	xlSolid      = 1
	
	WITH objExcel.Selection.Borders(xlEdgeLeft)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.Selection.Borders(xlEdgeTop)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.Selection.Borders(xlEdgeBottom)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.Selection.Borders(xlEdgeRight)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.Selection.Interior
	   .ColorIndex = 37
	   .Pattern = xlSolid
	ENDWITH

	DO CASE
		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '01'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Gennaio' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '02'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Febbraio' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '03'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Marzo' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '04'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Aprile' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '05'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Maggio' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '06'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Giugno' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '07'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Luglio' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '08'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Agosto' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '09'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Settembre' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '10'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Ottobre' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '11'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Novembre' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = '12'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'Dicembre' && NOME CAMPO
   		CASE SUBSTR(FIELD(I,_NOMECUR),2,2) = 'TT'
	    	objExcel.ActiveSheet.Cells(_RIGA_MESI,I).Value = 'TOTALI' && NOME CAMPO
    ENDCASE
ENDFOR


_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
   IF I = 1
	  objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = 'Cliente' && NOME CAMPO
   ENDIF
   IF I > 3
      objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = SUBSTR(FIELD(I,_NOMECUR),5,4) && NOME CAMPO
   ENDIF
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3
   
   	xlEdgeLeft   = 7
	xlEdgeTop    = 8
	xlEdgeBottom = 9
	xlEdgeRight   = 10
	xlContinuous = 1
	xlThin       = 2
	xlAutomatic  = -4105
	xlSolid      = 1
	
	WITH objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Borders(xlEdgeLeft)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Borders(xlEdgeTop)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Borders(xlEdgeBottom)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
	WITH objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Borders(xlEdgeRight)
	   .LineStyle = xlContinuous
	   .Weight = xlThin
	   .ColorIndex = xlAutomatic
	ENDWITH
  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select


WITH objExcel.Selection.Interior
   .ColorIndex = 37
   .Pattern = xlSolid
ENDWITH

objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
**larghezza fissa per codice cliente e ragione sociale (tagliata a 20 caratteri)
objExcel.ActiveSheet.Columns("A:A").ColumnWidth = 7.80
objExcel.ActiveSheet.Columns("B:B").ColumnWidth = 27.70

objExcel.ActiveSheet.Cells(2,2).Value = _TITOLO1
objExcel.ActiveSheet.Cells(2,2).Font.Bold = .T.
objExcel.ActiveSheet.Cells(2,2).Font.Size = 11
objExcel.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

objExcel.ActiveSheet.Cells(3,2).Value = _TITOLO2
objExcel.ActiveSheet.Cells(3,2).Font.Bold = .T.
objExcel.ActiveSheet.Cells(3,2).Font.Size = 10
*objExcel.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

objExcel.ActiveSheet.Cells(4,2).Value = _TITOLO3
objExcel.ActiveSheet.Cells(4,2).Font.Bold = .T.
objExcel.ActiveSheet.Cells(4,2).Font.Size = 11
objExcel.ActiveSheet.Cells(4,2).HorizontalAlignment = 1

** 2 perchè la scritta è nella 2° riga, in questo modo unisco tutte le celle della 3° riga
_Range_titolo1 = n2c(1) + ALLTRIM(STR(2)) +    ":"    + n2c(_NUMEROCAMPI) + ALLTRIM(STR(2))
objExcel.ActiveSheet.Range(_Range_titolo1).Select
WITH objExcel.Selection
	.WrapText = .F.
    .Orientation = 0
    .ShrinkToFit = .F.
    .MergeCells = .T.
    .HorizontalAlignment = 3
ENDWITH

** 3 perchè la scritta è nella 3° riga, in questo modo unisco tutte le celle della 3° riga
_Range_titolo2 = n2c(1) + ALLTRIM(STR(3)) +    ":"    + n2c(_NUMEROCAMPI) + ALLTRIM(STR(3))
objExcel.ActiveSheet.Range(_Range_titolo2).Select
WITH objExcel.Selection
	.WrapText = .F.
    .Orientation = 0
    .ShrinkToFit = .F.
    .MergeCells = .T.
    .HorizontalAlignment = 3
ENDWITH
	

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
      
      	xlEdgeLeft   = 7
		xlEdgeTop    = 8
		xlEdgeBottom = 9
		xlEdgeLeft   = 10
		xlContinuous = 1
		xlThin       = 2
		xlAutomatic  = -4105
		xlSolid      = 1
		
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeLeft)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeTop)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeBottom)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeLeft)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
		
		
		** se sono nella prima colonna dalla riga dei titoli unisco le 2 celle per avere un unico codice cliente	
		IF I = 1 AND _nRIGA > 6 AND _nRIGA%2<>0
			_Range_cliente = n2c(I) + ALLTRIM(STR(_nRIGA)) +    ":"    + n2c(I) + ALLTRIM(STR(_nRIGA+1))
			objExcel.ActiveSheet.Range(_Range_cliente).Select
			WITH objExcel.Selection
		    	.WrapText = .F.
			    .Orientation = 0
			    .ShrinkToFit = .F.
			    .MergeCells = .T.
			    .HorizontalAlignment = 1  
			    .VerticalAlignment = 2
			ENDWITH
		ENDIF

		
		** se sono nella prima colonna dalla riga dei titoli unisco le 2 celle per avere un' unica ragione sociale
		IF I = 2 AND _nRIGA > 6 AND _nRIGA%2<>0
			_Range_cliente = n2c(I) + ALLTRIM(STR(_nRIGA)) +    ":"    + n2c(I) + ALLTRIM(STR(_nRIGA+1))
			objExcel.ActiveSheet.Range(_Range_cliente).Select
			WITH objExcel.Selection
		    	.WrapText = .F.
			    .Orientation = 0
			    .ShrinkToFit = .F.
			    .MergeCells = .T.
			    .HorizontalAlignment = 1  
			    .VerticalAlignment = 2
			ENDWITH
		ENDIF
		

		** metto mq e € in grassetto
		IF I = 3
		    objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
		ENDIF
		

		IF (_nRIGA = __numerorighe+_RIGA_INIZIALE-2) OR (_nRIGA = __numerorighe+_RIGA_INIZIALE-3)
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
		ENDIF
		
		IF (_nRIGA > __numerorighe+_RIGA_INIZIALE-2)
			objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
		ENDIF
				
		
		xlEdgeLeft   = 7
		xlEdgeTop    = 8
		xlEdgeBottom = 9
		xlEdgeLeft   = 10
		xlContinuous = 1
		xlThin       = 2
		xlAutomatic  = -4105
		xlSolid      = 1
		
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeLeft)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeTop)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeBottom)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH
*!*			WITH objExcel.ActiveSheet.Cells(_nRIGA,I).Borders(xlEdgeLeft)
*!*			   .LineStyle = xlContinuous
*!*			   .Weight = xlThin
*!*			   .ColorIndex = xlAutomatic
*!*			ENDWITH

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

*___FINE = TIME()

*WAIT WINDOW "TEMPO : START="+___INIZIO+"  - STOP="+___FINE

objExcel.Range("A1").Select
objExcel.ActiveSheet.Cells.EntireColumn.AutoFit
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
	*cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)	
	
	**=> ERASMO INIZIO - 06/10/2008 - MODIFICA FATTA TRAMITE SEGNALAZIONE LUCA
	if mod (nNumero,26)<>0
		cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)
	else		
	** i multipli di 26 sono un caso particolare che causa il salto della cella xZ es: AZ => B@
	** la formula viene forzata per sistemare il problema
		cLettera=CHR(INT(nNumero/26)+63)+chr(90)	
	ENDIF
	**=> ERASMO FINE - 06/10/2008
ENDIF

RETURN cLettera
ENDFUNC
