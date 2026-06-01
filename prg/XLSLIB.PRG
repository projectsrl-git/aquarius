*!*	##############################################################################################################
  
					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI PER LA GENERAZIONE                   ***
					***                                       FOGLI EXCEL                                      ***
					**********************************************************************************************

*!*	##############################################################################################################
  
 
************************************************************************
PROCEDURE GENERA_FILE_ORF_CONSEGNA_URGENTE
************************************************************************
*
* Tale procedura permette la creazione del file excel "Ordini per consegna urgente",
* in base al cursore passato nei parametri che DEVE avere la stessa struttura della tabella U_ORF_DD
*
* Sintassi:
* 
* DO GENERA_FILE_ORF_CONSEGNA_URGENTE WITH <cursore o tabella>,<titolo>
*
* <cursore o tabella>           : é la tabella/cursore che si vuole rappresentare nel file excel
* <titolo>                      : titolo da visualizzare nel file excel
*
*************************************************************************************************************************************

PARAMETER _NOMECUR,_TITOLO

_NPARA = PARAMETERS()

IF _NPARA < 1
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF _NPARA < 2
   _TITOLO = "Ordini per consegna urgente"
ENDIF

_cursore = ALLTRIM(_NOMECUR)
_intesta = ALLTRIM(_TITOLO)

SELECT &_cursore
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

SELECT &_cursore
_OLD_ORDER = ORDER()
INDEX ON ORS_CODCLI+ORD_DATCON TAG I_CLICON ADDITIVE
SET ORDER TO I_CLICON

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()

xlCenter  = -4108
xlBottom  = -4107
xlContext = -5002

xlDiagonalDown = 5
xlDiagonalUp = 6
         
xlNone = -4142
xlContinuous = 1
xlThin = 2
xlMedium = -4138
xlAutomatic = -4105

xlEdgeLeft = 7
xlEdgeTop = 8
xlEdgeBottom = 9
xlEdgeRight = 10
*!*	xlInsideVertical = 11
*!*	xlInsideHorizontal = 12

xlSolid = 1

xlLandscape = 2
xlPrintNoComments = -4142
xlPaperA4 = 9
xlDownThenOver = 1
xlPrintErrorsDisplayed = 0

_ULT_CODICE = ""
_ULT_DATCON = ""
_N_RIGA     = 0
_TOT_KG     = 0

SELECT &_cursore
GO TOP
DO WHILE .T.

   IF EOF()
   
      *** SCRIVO IL TOTALE QTA' KG A ROTTURA DI SCADENZA
      _N_RIGA = _N_RIGA + 1
      
      WITH objExcel 
         
         _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = "Totale Kg"
         .Range(_RANGE).Select
         .Selection.NumberFormat = "@"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .t.
         
         _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = _TOT_KG
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .t.
         
         .Range("A1").Select
      
      ENDWITH
      
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR
   
   IF ALLTRIM(_ULT_CODICE) == ALLTRIM(M.ORS_CODCLI)
   ELSE
      *** PREPARO LE VARIE INTESTAZIONI
      WITH objExcel 

         IF EMPTY(ALLTRIM(_ULT_CODICE))
         ELSE
            *** SCRIVO IL TOTALE QTA' KG A ROTTURA DI SCADENZA
            _N_RIGA = _N_RIGA + 1
            
            _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
            _VALORE = "Totale Kg"
            .Range(_RANGE).Select
            .Selection.NumberFormat = "@"
            .Selection.Value = _VALORE
            .Selection.Font.Bold = .t.
            
            _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
            _VALORE = _TOT_KG
            .Range(_RANGE).Select
            .Selection.NumberFormat = "#,##0.00"
            .Selection.Value = _VALORE
            .Selection.Font.Bold = .t.
         ENDIF

         last_strNome = ""
         .Range("A1").Select
         
         IF EMPTY(ALLTRIM(_ULT_CODICE))
         ELSE
            last_strNome = .ActiveSheet.Name
            .Sheets.Add
         ENDIF
         
         strNome = .ActiveSheet.Name
         .Sheets(strNome).Select
         .Sheets(strNome).Name = SUBSTR(ALLTRIM(M.ORS_CODCLI) + " - " + ALLTRIM(M.ORS_RAGSOC),1,30)
         
         IF EMPTY(ALLTRIM(_ULT_CODICE))
         ELSE
            strNome = .ActiveSheet.Name
            .Sheets(strNome).Select
            .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
         ENDIF
         
         .Range("A1:IV65536").Select
         .Selection.Font.Size = 10
         .Range("A1").Select
         *IF FILE(PUB_LOGO1)
         IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
            _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
            .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
            .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
            *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
            *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
            *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
            .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
            .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
            .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
         ENDIF
         .ActiveSheet.PageSetup.Orientation = xlLandscape
      
         .Range("C2:J2").Select
         .Selection.HorizontalAlignment = xlCenter
         .Selection.VerticalAlignment = xlBottom
         .Selection.WrapText = .F.
         .Selection.Orientation = 0
         .Selection.AddIndent = .F.
         .Selection.IndentLevel = 0
         .Selection.ShrinkToFit = .F.
         .Selection.ReadingOrder = xlContext
         .Selection.MergeCells = .F.
         .Selection.Merge
         .Selection.Value = UPPER(_intesta)
         .Selection.Font.Bold = .t.
         
         .Range("A7").Select
         .Selection.Value = "FORNITORE: " + ALLTRIM(M.ORS_CODCLI) + " - " + ALLTRIM(M.ORS_RAGSOC)
         .Selection.Font.Bold = .t.
         
         .Range("A9").Select
         .Selection.Value = "Consegna"
         .Selection.Font.Bold = .t.
         .Range("B9").Select
         .Selection.Value = "N° ordine"
         .Selection.Font.Bold = .t.
         .Range("C9").Select
         .Selection.Value = "N° ordine int."
         .Selection.Font.Bold = .t.
         .Range("D9").Select
         .Selection.Value = "Articolo"
         .Selection.Font.Bold = .t.
         .Range("E9").Select
         .Selection.Value = "Spessore"
         .Selection.Font.Bold = .t.
         .Range("F9").Select
         .Selection.Value = "Altezza"
         .Selection.Font.Bold = .t.
         .Range("G9").Select
         .Selection.Value = "Lunghezza"
         .Selection.Font.Bold = .t.
         .Range("H9").Select
         .Selection.Value = "N° bobine"
         .Selection.Font.Bold = .t.
         .Range("I9").Select
         .Selection.Value = "Mtl"
         .Selection.Font.Bold = .t.
         .Range("J9").Select
         .Selection.Value = "Kg"
         .Selection.Font.Bold = .t.
         
         .Columns("A:A").ColumnWidth = 10
         .Columns("B:B").ColumnWidth = 8
         .Columns("C:C").ColumnWidth = 12
         .Columns("D:D").ColumnWidth = 40
         .Columns("E:E").ColumnWidth = 8
         .Columns("F:F").ColumnWidth = 7
         .Columns("G:G").ColumnWidth = 10
         .Columns("H:H").ColumnWidth = 9
         .Columns("I:I").ColumnWidth = 10
         .Columns("J:J").ColumnWidth = 10
         
         .Range("A9:J9").Select
         .Selection.Borders(xlDiagonalDown).LineStyle = xlNone
         .Selection.Borders(xlDiagonalUp).LineStyle = xlNone
         With .Selection.Borders(xlEdgeLeft)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
         With .Selection.Borders(xlEdgeTop)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
         With .Selection.Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
         With .Selection.Borders(xlEdgeRight)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
*!*	         With .Selection.Borders(xlInsideVertical)
*!*	            .LineStyle = xlContinuous
*!*	            .Weight = xlMedium
*!*	            .ColorIndex = xlAutomatic
*!*	         EndWith
*!*	         With .Selection.Borders(xlInsideHorizontal)
*!*	            .LineStyle = xlContinuous
*!*	            .Weight = xlMedium
*!*	            .ColorIndex = xlAutomatic
*!*	         EndWith
         WITH objExcel.Selection.Interior
            .ColorIndex = 37
            .Pattern = xlSolid
         ENDWITH
         
         With .ActiveSheet.PageSetup
             .PrintTitleRows = ""
             .PrintTitleColumns = ""
         EndWith
         .ActiveSheet.PageSetup.PrintArea = ""
         With .ActiveSheet.PageSetup
             .LeftHeader = ""
             .CenterHeader = ""
             .RightHeader = "Data: &D" + " Ora: &T"
             .LeftFooter = "File: &F"
             .CenterFooter = "Scheda: &A"
             .RightFooter = "Pagina &P"
             .LeftMargin = objExcel.InchesToPoints(0.787401575)
             .RightMargin = objExcel.InchesToPoints(0.787401575)
             .TopMargin = objExcel.InchesToPoints(0.984251969)
             .BottomMargin = objExcel.InchesToPoints(0.984251969)
             .HeaderMargin = objExcel.InchesToPoints(0.5)
             .FooterMargin = objExcel.InchesToPoints(0.5)
             .PrintHeadings = .F.
             *.PrintGridlines = .F.
             .PrintGridlines = .T.  && ERASMO - 23/06/2008
             .PrintComments = xlPrintNoComments
             *.PrintQuality = 600
             .CenterHorizontally = .F.
             .CenterVertically = .F.
             .Orientation = xlLandscape
             .Draft = .F.
             .PaperSize = xlPaperA4
             .FirstPageNumber = xlAutomatic
             .Order = xlDownThenOver
             .BlackAndWhite = .F.
             .Zoom = 100
             .PrintErrors = xlPrintErrorsDisplayed
         EndWith
              
      ENDWITH
      
      _ULT_CODICE = M.ORS_CODCLI
      _ULT_DATCON = M.ORD_DATCON
      _TOT_KG     = 0
      _N_RIGA     = 9
   
   ENDIF
   
   IF ALLTRIM(M.ORD_DATCON) == ALLTRIM(_ULT_DATCON)
   ELSE
      
      *** SCRIVO IL TOTALE QTA' KG A ROTTURA DI SCADENZA
      _N_RIGA = _N_RIGA + 1
      
      WITH objExcel 
         
         _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = "Totale Kg"
         .Range(_RANGE).Select
         .Selection.NumberFormat = "@"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .t.
         
         _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = _TOT_KG
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .t.
      
      ENDWITH      
      
      _TOT_KG     = 0
      _ULT_DATCON = M.ORD_DATCON
      _N_RIGA     = _N_RIGA + 1
      
   ENDIF
   
   
   
   *** SCRIVO I VALORI
   
   _N_RIGA = _N_RIGA + 1
   
   M.ORS_RIFERI = ""
   x_agga = "taggancio = '" + M.DAGGANCIO + "'"
   x_cond = x_agga
   cSql   = "select ORD_RIFERI from U_ORF_TT where " + x_cond
   IF !ExecCommand(cSql,"CC_ORF_TT")
      return(.f.)
   ENDIF  
   SELECT CC_ORF_TT
   GO TOP
   IF EOF()
   ELSE
      M.ORS_RIFERI = ALLTRIM(ORD_RIFERI)
   ENDIF
   _RIFERI = ""
   _LUNGH  = LEN(M.ORS_RIFERI)
   FOR I = 1 TO _LUNGH
      IF ISDIGIT(SUBSTR(M.ORS_RIFERI,I,1))
         _RIFERI = ALLTRIM(SUBSTR(M.ORS_RIFERI,I))
         EXIT
      ENDIF
   ENDFOR
   M.ORS_RIFERI = _RIFERI
   
   WITH objExcel 
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = RIBALTA2(M.ORD_DATCON)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      
      _RANGE  = "B" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.ORS_NUMORD)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      
      _RANGE  = "C" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.ORS_RIFERI)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      
      _RANGE  = "D" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.ORD_CODART) + " - " + ALLTRIM(M.ORD_DESART)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
   
      _RANGE  = "E" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_SPESSO
      .Range(_RANGE).Select
      .Selection.NumberFormat = "###"
      .Selection.Value = _VALORE
      
      _RANGE  = "F" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_ALTEZZ
      .Range(_RANGE).Select
      .Selection.NumberFormat = "######"
      .Selection.Value = _VALORE
   
      _RANGE  = "G" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_LUNGHE
      .Range(_RANGE).Select
      .Selection.NumberFormat = "######"
      .Selection.Value = _VALORE
   
      _RANGE  = "H" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_NUMBOB
      .Range(_RANGE).Select
      .Selection.NumberFormat = "######"
      .Selection.Value = _VALORE
      
      _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_QTAML
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      
      _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_QTAKG
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      
   ENDWITH
   
   _TOT_KG = _TOT_KG + M.ORD_QTAKG
   
   SELECT &_cursore
   SKIP +1

ENDDO

objExcel.Sheets(1).Select
objExcel.Range("A1").Select
objExcel.Visible = .t.

SELECT &_cursore
SET ORDER TO &_OLD_ORDER
GO TOP

RETURN


************************************************************************
PROCEDURE GENERA_FILE_ORF_RIEPILOGO_ANNUO 
************************************************************************
*
* Tale procedura permette la creazione del file excel "Riepilogo annuo Ordini",
* in base al cursore passato nei parametri che DEVE avere la stessa struttura della tabella U_ORF_DD
*
* Sintassi:
* 
* DO GENERA_FILE_ORF_RIEPILOGO_ANNUO WITH <cursore o tabella>,<titolo>
*
* <cursore o tabella>           : é la tabella/cursore che si vuole rappresentare nel file excel
* <titolo>                      : titolo da visualizzare nel file excel
*
*************************************************************************************************************************************

PARAMETER _NOMECUR,_TITOLO

_NPARA = PARAMETERS()

IF _NPARA < 1
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF _NPARA < 2
   _TITOLO = "Riepilogo annuo Ordini"
ENDIF

_cursore = ALLTRIM(_NOMECUR)
_intesta = ALLTRIM(_TITOLO)

SELECT &_cursore
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

SELECT &_cursore
_OLD_ORDER = ORDER()
INDEX ON SUBSTR(ORD_DATCON,1,4)+ORS_CODCLI+ORD_DATCON TAG I_AACLCO ADDITIVE
SET ORDER TO I_AACLCO 

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()

xlCenter  = -4108
xlBottom  = -4107
xlContext = -5002

xlDiagonalDown = 5
xlDiagonalUp = 6
         
xlNone = -4142
xlContinuous = 1
xlThin = 2
xlMedium = -4138
xlAutomatic = -4105

xlEdgeLeft = 7
xlEdgeTop = 8
xlEdgeBottom = 9
xlEdgeRight = 10
*!*	xlInsideVertical = 11
*!*	xlInsideHorizontal = 12

xlSolid = 1

xlLandscape = 2
xlPrintNoComments = -4142
xlPaperA4 = 9
xlDownThenOver = 1
xlPrintErrorsDisplayed = 0

_ULT_ANNO   = ""
_ULT_CODICE = ""
_ULT_MESCON = ""
_N_RIGA     = 0

_TOT_ML     = 0
_TOT_KG     = 0
_TOT_MLCON  = 0
**=> LUCA - INIZIO 22/10/2009
_TOT_KGCON   = 0
**=> LUCA - FINE 22/10/2009

SELECT &_cursore
GO TOP
DO WHILE .T.

   IF EOF()
      objExcel.Range("A1").Select
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR
   
   *** SE CAMBIO ANNO AZZERO VARIABILI
   IF ALLTRIM(_ULT_ANNO) == SUBSTR(M.ORD_DATCON,1,4)   
   ELSE
      IF EMPTY(ALLTRIM(_ULT_ANNO))
      ELSE
         _ULT_CODICE = ""
         _ULT_MESCON = ""
         _N_RIGA     = 0
         _TOT_ML     = 0
         _TOT_KG     = 0
         _TOT_MLCON  = 0
         **=> LUCA - INIZIO 22/10/2009
         _TOT_KGCON   = 0
		 **=> LUCA - FINE 22/10/2009
      ENDIF
   ENDIF
   
   IF ALLTRIM(_ULT_CODICE) == ALLTRIM(M.ORS_CODCLI)
   ELSE
      *** PREPARO LE VARIE INTESTAZIONI
      WITH objExcel

         last_strNome = ""
         .Range("A1").Select
         
         IF EMPTY(ALLTRIM(_ULT_CODICE)) .AND. EMPTY(ALLTRIM(_ULT_ANNO))
         ELSE
            last_strNome = .ActiveSheet.Name
            .Sheets.Add
         ENDIF
         
         strNome = .ActiveSheet.Name
         .Sheets(strNome).Select
         .Sheets(strNome).Name = SUBSTR(M.ORD_DATCON,1,4) + "_" + SUBSTR(ALLTRIM(M.ORS_CODCLI) + " - " + ALLTRIM(M.ORS_RAGSOC),1,26)
         
         IF EMPTY(ALLTRIM(_ULT_CODICE)) .AND. EMPTY(ALLTRIM(_ULT_ANNO))
         ELSE
            strNome = .ActiveSheet.Name
            .Sheets(strNome).Select
            .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
         ENDIF
         
         .Range("A1:IV65536").Select
         .Selection.Font.Size = 8
         .Range("A1").Select
         *IF FILE(PUB_LOGO1)
         IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
            _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
            .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
            .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
            *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
            *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
            *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
            .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
            .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
            .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
         ENDIF
         .ActiveSheet.PageSetup.Orientation = xlLandscape
      
         .Range("C2:I2").Select
         .Selection.HorizontalAlignment = xlCenter
         .Selection.VerticalAlignment = xlBottom
         .Selection.WrapText = .F.
         .Selection.Orientation = 0
         .Selection.AddIndent = .F.
         .Selection.IndentLevel = 0
         .Selection.ShrinkToFit = .F.
         .Selection.ReadingOrder = xlContext
         .Selection.MergeCells = .F.
         .Selection.Merge
         .Selection.Value = UPPER(_intesta)
         .Selection.Font.Bold = .t.
         
         .Range("A7").Select
         .Selection.Value = "ANNO: " + SUBSTR(M.ORD_DATCON,1,4) + " - FORNITORE: " + ALLTRIM(M.ORS_CODCLI) + " - " + ALLTRIM(M.ORS_RAGSOC)
         .Selection.Font.Bold = .t.
         
         .Range("A9").Select
         .Selection.Value = "Consegna"
         .Selection.Font.Bold = .t.
         .Range("B9").Select
         *.Selection.Value = "N° ordine"
         .Selection.Value = "N° ord."  && ERASMO - 03/10/2008
         .Selection.Font.Bold = .t.
         .Range("C9").Select
         *.Selection.Value = "N° ordine int."
         .Selection.Value = "N° ord.int."  && ERASMO - 03/10/2008
         .Selection.Font.Bold = .t.
         .Range("D9").Select
         .Selection.Value = "Articolo"
         .Selection.Font.Bold = .t.
         .Range("E9").Select
         *.Selection.Value = "Spessore"
         .Selection.Value = "My"  && ERASMO - 03/10/2008
         .Selection.Font.Bold = .t.
         .Range("F9").Select
         *.Selection.Value = "Altezza"
         .Selection.Value = "H"  && ERASMO - 03/10/2008
         .Selection.Font.Bold = .t.
         .Range("G9").Select
         *.Selection.Value = "Lunghezza"
         .Selection.Value = "L"  && ERASMO - 03/10/2008
         .Selection.Font.Bold = .t.
         .Range("H9").Select
         *.Selection.Value = "N° bobine"
         .Selection.Value = "N° bob."  && ERASMO - 03/10/2008
         .Selection.Font.Bold = .t.
         .Range("I9").Select
         .Selection.Value = "Mtl"
         .Selection.Font.Bold = .t.
         .Range("J9").Select
         .Selection.Value = "Kg"
         .Selection.Font.Bold = .t.
         .Range("K9").Select
         .Selection.Value = "Arrivo effettivo"
         .Selection.Font.Bold = .t.
*!*	         .Range("L9").Select
*!*	         .Selection.Value = "Mtl consegnati"
*!*	         .Selection.Font.Bold = .t.
         **=> ERASMO - INIZIO 03/10/2008
         .Range("L9").Select
         .Selection.Value = "Riferimento" 
         .Selection.Font.Bold = .t.
         
         
         **=> LUCA - INIZIO 22/10/2009
         .Range("M9").Select
         .Selection.Value = "Kg consegnati"
         .Selection.Font.Bold = .t.
         .Range("N9").Select
         .Selection.Value = "Mtl consegnati"
         .Selection.Font.Bold = .t.
         **=> LUCA - FINE 22/10/2009
         

         **=> ERASMO - FINE 03/10/2008

*!*	         .Columns("A:A").ColumnWidth = 8
*!*	         .Columns("B:B").ColumnWidth = 7
*!*	         .Columns("C:C").ColumnWidth = 10
*!*	         .Columns("D:D").ColumnWidth = 15
*!*	         .Columns("E:E").ColumnWidth = 8
*!*	         .Columns("F:F").ColumnWidth = 7
*!*	         .Columns("G:G").ColumnWidth = 9
*!*	         .Columns("H:H").ColumnWidth = 8
*!*	         .Columns("I:I").ColumnWidth = 9
*!*	         .Columns("J:J").ColumnWidth = 9
*!*	         .Columns("K:K").ColumnWidth = 21
*!*	         .Columns("L:L").ColumnWidth = 12
         
         **=> ERASMO - INIZIO 03/10/2008
         .Columns("A:A").ColumnWidth = 8
         .Columns("B:B").ColumnWidth = 5
         .Columns("C:C").ColumnWidth = 8
         .Columns("D:D").ColumnWidth = 15
         .Columns("E:E").ColumnWidth = 2.5
         .Columns("F:F").ColumnWidth = 3.5
         .Columns("G:G").ColumnWidth = 4.5
         .Columns("H:H").ColumnWidth = 7.5
         .Columns("I:I").ColumnWidth = 9
         .Columns("J:J").ColumnWidth = 8
         .Columns("K:K").ColumnWidth = 21
         .Columns("L:L").ColumnWidth = 18
         .Columns("M:M").ColumnWidth = 12
         **=> ERASMO - FINE 03/10/2008
          **=> LUCA - INIZIO 22/10/2009
         .Columns("N:N").ColumnWidth = 12
          **=> LUCA - FINE 22/10/2009
          
         
         *.Range("A9:L9").Select
         .Range("A9:N9").Select  && ERASMO - 03/10/2008 ; LUCA 22/10/2009
         .Selection.Borders(xlDiagonalDown).LineStyle = xlNone
         .Selection.Borders(xlDiagonalUp).LineStyle = xlNone
         With .Selection.Borders(xlEdgeLeft)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
         With .Selection.Borders(xlEdgeTop)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
         With .Selection.Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith
         With .Selection.Borders(xlEdgeRight)
            .LineStyle = xlContinuous
            .Weight = xlMedium
            .ColorIndex = xlAutomatic
         EndWith

         WITH objExcel.Selection.Interior
            .ColorIndex = 37
            .Pattern = xlSolid
         ENDWITH
         
         *.Rows("1:9").Select
         *.Range("A9").Activate
         .Rows("1:10").Select  && ERASMO - 03/10/2008
         .Range("A10").Activate  && ERASMO - 03/10/2008
         .ActiveWindow.FreezePanes = .T.
    
         With .ActiveSheet.PageSetup
             .PrintTitleRows = ""
             .PrintTitleColumns = ""
         EndWith
         .ActiveSheet.PageSetup.PrintArea = ""
         With .ActiveSheet.PageSetup
             .LeftHeader = ""
             .CenterHeader = ""
             .RightHeader = "Data: &D" + " Ora: &T"
             .LeftFooter = "File: &F"
             .CenterFooter = "Scheda: &A"
             .RightFooter = "Pagina &P"
             .LeftMargin = objExcel.InchesToPoints(0.787401575)
             .RightMargin = objExcel.InchesToPoints(0.787401575)
             .TopMargin = objExcel.InchesToPoints(0.984251969)
             .BottomMargin = objExcel.InchesToPoints(0.984251969)
             .HeaderMargin = objExcel.InchesToPoints(0.5)
             .FooterMargin = objExcel.InchesToPoints(0.5)
             .PrintHeadings = .F.
             *.PrintGridlines = .F.
             .PrintGridlines = .T.  && ERASMO - 23/06/2008
             .PrintComments = xlPrintNoComments
             *.PrintQuality = 600
             .CenterHorizontally = .F.
             .CenterVertically = .F.
             .Orientation = xlLandscape
             .Draft = .F.
             .PaperSize = xlPaperA4
             .FirstPageNumber = xlAutomatic
             .Order = xlDownThenOver
             .BlackAndWhite = .F.
             .Zoom = 100
             .PrintErrors = xlPrintErrorsDisplayed
         EndWith
              
      ENDWITH
      
      *_ULT_CODICE = M.ORS_CODCLI
      _TOT_ML     = 0
      _TOT_KG     = 0
      _TOT_MLCON  = 0
      _N_RIGA     = 9
      **=> LUCA - INIZIO 22/10/2009
      _TOT_KGCON   = 0
	  **=> LUCA - FINE 22/10/2009
   
   ENDIF


   *** INSERISCO IL NUOVO MESE
   IF (SUBSTR(M.ORD_DATCON,1,7) <> ALLTRIM(_ULT_MESCON)) .OR. (ALLTRIM(_ULT_CODICE) <> ALLTRIM(M.ORS_CODCLI) .OR. ALLTRIM(_ULT_ANNO) <> SUBSTR(M.ORD_DATCON,1,4))
         
      _TOT_ML     = 0
      _TOT_KG     = 0
      _TOT_MLCON  = 0
      **=> LUCA - INIZIO 22/10/2009
      _TOT_KGCON   = 0
	  **=> LUCA - FINE 22/10/2009
      
      IF ALLTRIM(_ULT_CODICE) == ALLTRIM(M.ORS_CODCLI) .AND. ALLTRIM(_ULT_ANNO) == SUBSTR(M.ORD_DATCON,1,4)   
         _N_RIGA = _N_RIGA + 2
      ELSE
         _N_RIGA = _N_RIGA + 1
      ENDIF
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0)) + ":" + "L" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ""
      DO CASE
         CASE SUBSTR(M.ORD_DATCON,6,2) = "01"
            _VALORE = "GENNAIO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "02"
            _VALORE = "FEBBRAIO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "03"
            _VALORE = "MARZO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "04"
            _VALORE = "APRILE"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "05"
            _VALORE = "MAGGIO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "06"
            _VALORE = "GIUGNO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "07"
            _VALORE = "LUGLIO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "08"
            _VALORE = "AGOSTO"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "09"
            _VALORE = "SETTEMBRE"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "10"
            _VALORE = "OTTOBRE"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "11"
            _VALORE = "NOVEMBRE"
         CASE SUBSTR(M.ORD_DATCON,6,2) = "12"
            _VALORE = "DICEMBRE"
         OTHERWISE
            _VALORE = "???"
      ENDCASE
      
      WITH objExcel
         .Range(_RANGE).Select
         .Selection.HorizontalAlignment = xlCenter
         .Selection.VerticalAlignment = xlBottom
         .Selection.WrapText = .F.
         .Selection.Orientation = 0
         .Selection.AddIndent = .F.
         .Selection.IndentLevel = 0
         .Selection.ShrinkToFit = .F.
         .Selection.ReadingOrder = xlContext
         .Selection.MergeCells = .F.
         .Selection.Merge
         .Selection.Value = UPPER(_intesta)
         .Selection.Font.Bold = .t.         
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .t.
      ENDWITH
      
      _ULT_MESCON = SUBSTR(M.ORD_DATCON,1,7)
      
   ENDIF
   
   
   
   *** SCRIVO I VALORI
   
   _N_RIGA = _N_RIGA + 1
   
   M.ORS_RIFERI = ""
   x_agga = "taggancio = '" + M.DAGGANCIO + "'"
   x_cond = x_agga
   cSql   = "select ORD_RIFERI from U_ORF_TT where " + x_cond
   IF !ExecCommand(cSql,"CC_ORF_TT")
      return(.f.)
   ENDIF  
   SELECT CC_ORF_TT
   GO TOP
   IF EOF()
   ELSE
      M.ORS_RIFERI = ALLTRIM(ORD_RIFERI)
   ENDIF
   _RIFERI = ""
   _LUNGH  = LEN(M.ORS_RIFERI)
   FOR I = 1 TO _LUNGH
      IF ISDIGIT(SUBSTR(M.ORS_RIFERI,I,1))
         _RIFERI = ALLTRIM(SUBSTR(M.ORS_RIFERI,I))
         EXIT
      ENDIF
   ENDFOR
   M.ORS_RIFERI = _RIFERI
   
   WITH objExcel 
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = RIBALTA2(M.ORD_DATCON)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      
      _RANGE  = "B" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.ORS_NUMORD)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      
      _RANGE  = "C" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.ORS_RIFERI)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      
      _RANGE  = "D" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.ORD_CODART) + " - " + ALLTRIM(M.ORD_DESART)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
   
      _RANGE  = "E" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_SPESSO
      .Range(_RANGE).Select
      .Selection.NumberFormat = "###"
      .Selection.Value = _VALORE
      
      _RANGE  = "F" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_ALTEZZ
      .Range(_RANGE).Select
      .Selection.NumberFormat = "######"
      .Selection.Value = _VALORE
   
      _RANGE  = "G" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_LUNGHE
      .Range(_RANGE).Select
      .Selection.NumberFormat = "######"
      .Selection.Value = _VALORE
   
      _RANGE  = "H" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_NUMBOB
      .Range(_RANGE).Select
      .Selection.NumberFormat = "######"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .F.
      
      _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_QTAML
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .F.
      
      _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.ORD_QTAKG
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .F.
      
      *** INSERIMENTO CAMPI PER IL CONSEGNATO
      DO trova_quantita_bfo_consegnate_da_orf WITH M.ORD_LEGSYS
      SELECT CUR_CONSEGNE
      GO TOP
      IF EOF()
         _RANGE  = "K" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = ""
         .Range(_RANGE).Select
         .Selection.NumberFormat = "@"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
      
*!*	         _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
*!*	         _VALORE = 0
*!*	         .Range(_RANGE).Select
*!*	         .Selection.NumberFormat = "#,##0.00"
*!*	         .Selection.Value = _VALORE
*!*	         .Selection.Font.Bold = .F.
         
         **=> ERASMO - INIZIO 03/10/2008
         _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = ""
         .Range(_RANGE).Select
         .Selection.NumberFormat = "@"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
         
         _RANGE  = "M" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = 0
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
         **=> ERASMO - FINE 03/10/2008
         **=> LUCA - INIZIO 22/10/2009
         _RANGE  = "N" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = 0
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
         **=> LUCA - FINE 22/10/2009
      ENDIF
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         
         IF RECNO() = 1
         ELSE
            _N_RIGA = _N_RIGA + 1
         ENDIF
         
         _RANGE  = "K" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = "Doc.N° " + ALLTRIM(ORS_NUMORD) + " del " + RIBALTA2(ORS_DATORD)
         .Range(_RANGE).Select
         .Selection.NumberFormat = "@"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
      
*!*	         _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
*!*	         _VALORE = ORD_QTAML
*!*	         .Range(_RANGE).Select
*!*	         .Selection.NumberFormat = "#,##0.00"
*!*	         .Selection.Value = _VALORE
*!*	         .Selection.Font.Bold = .F.
         
         **=> ERASMO - INIZIO 03/10/2008
         _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = ALLTRIM(ORS_RIFBFO)
         .Range(_RANGE).Select
         .Selection.NumberFormat = "@"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
          **=> LUCA - INIZIO 22/10/2009          
         _RANGE  = "M" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = ORD_QTAKG
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
         **=> ERASMO - FINE 03/10/2008
       
         _RANGE  = "N" + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = ORD_QTAML
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _VALORE
         .Selection.Font.Bold = .F.
         **=> LUCA - FINE 22/10/2009
         
         SELECT CUR_CONSEGNE
         SKIP +1
      ENDDO
      
   ENDWITH
   
   _ULT_CODICE = M.ORS_CODCLI
   _ULT_ANNO   = SUBSTR(M.ORD_DATCON,1,4)
   
   *** SCRIVO IL TOTALE QTA' ML E KG A ROTTURA DI MESE
   _T_RIGA = _N_RIGA + 1
   _TOT_ML = _TOT_ML + M.ORD_QTAML
   _TOT_KG = _TOT_KG + M.ORD_QTAKG
   _TOT_MLCON = _TOT_MLCON + _CON_QTAML
   **=> LUCA - INIZIO 22/10/2009
   _TOT_KGCON = _TOT_KGCON + _CON_QTAKG
   **=> LUCA - FINE 22/10/2009
         
   WITH objExcel 
      
      _RANGE  = "H" + ALLTRIM(STR(_T_RIGA,10,0))
      _VALORE = "Tot.mese"
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .t.
      
      _RANGE  = "I" + ALLTRIM(STR(_T_RIGA,10,0))
      _VALORE = _TOT_ML
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .t.
         
      _RANGE  = "J" + ALLTRIM(STR(_T_RIGA,10,0))
      _VALORE = _TOT_KG
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .t.
      
*!*	      _RANGE  = "L" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	      _VALORE = _TOT_MLCON
*!*	      .Range(_RANGE).Select
*!*	      .Selection.NumberFormat = "#,##0.00"
*!*	      .Selection.Value = _VALORE
*!*	      .Selection.Font.Bold = .t.
      
      **=> LUCA - INIZIO 22/10/2009
      _RANGE  = "M" + ALLTRIM(STR(_T_RIGA,10,0))
      _VALORE = _TOT_KGCON
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .t.
      **=> ERASMO - FINE 03/10/2008
      
      
      _RANGE  = "N" + ALLTRIM(STR(_T_RIGA,10,0))
      _VALORE = _TOT_MLCON
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Font.Bold = .t.
      **=> LUCA - FINE 22/10/2009
            
      *.Range("A1").Select
            
   ENDWITH
      
   SELECT &_cursore
   SKIP +1

ENDDO

objExcel.Sheets(1).Select
objExcel.Range("A1").Select
objExcel.Visible = .t.

SELECT &_cursore
SET ORDER TO &_OLD_ORDER
GO TOP

RETURN


************************************************************************
PROCEDURE ESTRXLS
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
*
* Sintassi:
* 
* DO ESTRXLS WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
* <subtotale>                   : subtotale di tutti i valori numerici alla fine del file excel [booleano .t./.f.]
* <def_decimali>                : esiste un cursore dal nome 'CUR_ESTRXLS_DEF_DECIMALS' dal quale dedurre i decimali da riportare per i campi numerici [booleano .t./.f.]
*
********************************************************************************************************************
                                                                                
*PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS
*PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS,_OBJGRIDRIF  && ERASMO - 21/04/2020
*PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS,_OBJGRIDRIF,_NOMEFILE  && ERASMO - 03/02/2022
LPARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS,_OBJGRIDRIF,_NOMEFILE  && ERASMO - 04/05/2023

*IF PARAMETERS() = 0
IF PCOUNT() = 0  && ERASMO - 04/05/2023
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

*IF PARAMETERS() < 2
IF PCOUNT() < 2  && ERASMO - 04/05/2023
   _TITOLO1 = ""
ENDIF
*IF PARAMETERS() < 3
IF PCOUNT() < 3  && ERASMO - 04/05/2023
   _TITOLO2 = ""
ENDIF
*IF PARAMETERS() < 4
IF PCOUNT() < 4  && ERASMO - 04/05/2023
   _TITOLO3 = ""
ENDIF

*** PARAMETRO PER LA SCRITTURA DEI TOTALI GENERALI A FINE TABELLA, CON DEFAULT A TRUE
*IF PARAMETERS() < 5
IF PCOUNT() < 5  && ERASMO - 04/05/2023
   _SUBTOTALS = .T.
ENDIF

*** PARAMETRO PER LA SEGNALAZIONE CHE NEL CURSORE DAL NOME 'CUR_ESTRXLS_DEF_DECIMALS' SONO DEFINITI I DECIMALI DA RIPORTARE PER I CAMPI NUMERICI, CON DEFAULT A FALSE
*IF PARAMETERS() < 6
IF PCOUNT() < 6  && ERASMO - 04/05/2023
   _DEFDECIMALS = .F.
ENDIF

**=> ERASMO - INIZIO 21/04/2020
*IF PARAMETERS() < 7
IF PCOUNT() < 7  && ERASMO - 04/05/2023
   _OBJGRIDRIF = .F.
ENDIF
**=> ERASMO - FINE 21/04/2020

**=> ERASMO - INIZIO 03/02/2022
*IF PARAMETERS() < 8
IF PCOUNT() < 8  && ERASMO - 04/05/2023
   _NOMEFILE = ""
ENDIF
**=> ERASMO - FINE 03/02/2022


SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local objExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
objExcel.DisplayAlerts = .F.  && ERASMO - 07/04/2014
xlLandscape = 2

WITH objExcel 
*!*	   .Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*	   .Visible = .f.
   .Range("A1:IV65536").Select
   *.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*	   .Range("A1:IV1").Select
*!*	   .Selection.Font.Size = 10
*!*	   .Selection.Font.Bold = .t.
*!*	   .Columns().EntireColumn.AutoFit
*!*	   .Rows("1:1").EntireRow.Select
*!*	   .Selection.Insert
*!*	   .Selection.Insert
*!*	   .Selection.Insert
   .Range("A1").Select
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 31/03/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
      *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
      *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
*!*	      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      **=> ERASMO - INIZIO 10/02/2014
      .Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
      .Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
      **=> ERASMO - FINE 10/02/2014
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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

*_RIGA_INIZIALE = 6
**=> ERASMO - INIZIO 31/03/2015
IF PUB_INTXLS
	_RIGA_INIZIALE = 6
ELSE
	_RIGA_INIZIALE = 1
ENDIF
**=> ERASMO - FINE 31/03/2015


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

*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
			
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"

*!*	         IF 'METRIQUADRI' $ ALLTRIM(_TITOLO2) OR 'METRICUBI' $ ALLTRIM(_TITOLO2)
*!*	            A=0
*!*				_NFORMAT = ''
*!*	         	FOR A=1 TO PUB_DECQTA STEP 1
*!*	         		_NFORMAT = _NFORMAT + '0'
*!*	         	ENDFOR
*!*	         	_NFORMAT = '#,##0.' + _NFORMAT
*!*	         	objExcel.Selection.NumberFormat = _NFORMAT
*!*	         ENDIF
*!*	         IF AT('Unità',ALLTRIM(_TITOLO2)) <> 0
*!*	            A=0
*!*				_NFORMAT = ''
*!*	         	FOR A=1 TO PUB_DECQTA STEP 1
*!*	         		_NFORMAT = _NFORMAT + '0'
*!*	         	ENDFOR
*!*	         	_NFORMAT = '#,##0.' + _NFORMAT
*!*	         	objExcel.Selection.NumberFormat = _NFORMAT
*!*	         ENDIF
*!*	         IF AT('Unità',ALLTRIM(_TITOLO3)) <> 0
*!*	            A=0
*!*				_NFORMAT = ''
*!*	         	FOR A=1 TO PUB_DECQTA STEP 1
*!*	         		_NFORMAT = _NFORMAT + '0'
*!*	         	ENDFOR
*!*	         	_NFORMAT = '#,##0.' + _NFORMAT
*!*	         	objExcel.Selection.NumberFormat = _NFORMAT
*!*	         ENDIF
*!*	         IF AT('Valuta',ALLTRIM(_TITOLO2)) <> 0
*!*	            A=0
*!*				_NFORMAT = ''
*!*	         	FOR A=1 TO PUB_DECVAL STEP 1
*!*	         		_NFORMAT = _NFORMAT + '0'
*!*	         	ENDFOR
*!*	         	_NFORMAT = '#,##0.' + _NFORMAT
*!*	         	objExcel.Selection.NumberFormat = _NFORMAT
*!*	         ENDIF
*!*	         IF AT('Valuta',ALLTRIM(_TITOLO3)) <> 0
*!*	            A=0
*!*				_NFORMAT = ''
*!*	         	FOR A=1 TO PUB_DECVAL STEP 1
*!*	         		_NFORMAT = _NFORMAT + '0'
*!*	         	ENDFOR
*!*	         	_NFORMAT = '#,##0.' + _NFORMAT
*!*	         	objExcel.Selection.NumberFormat = _NFORMAT
*!*	         ENDIF
		
		IF _DEFDECIMALS AND USED("CUR_ESTRXLS_DEF_DECIMALS")
			SELECT CUR_ESTRXLS_DEF_DECIMALS
			SET ORDER TO I_FLDNAME
			GO TOP
			_SEEK = ALLTRIM(_NOMECAMPO)
			SEEK _SEEK
			IF FOUND()
				_nDecimals = NDECIMALS
				IF _nDecimals > 0
					_NFORMAT = "#,##0." + REPLICATE('0',_nDecimals)
				ENDIF
			ENDIF
			SELECT &_NOMECUR
		ENDIF
		
	**=> ERASMO - INIZIO 31/03/2015
	*** SE IL CAMPO IN LINEA DI TIPO TESTO CONTIENE DEI VALORI CON FORMATO AAAA/MM/GG OPPURE GG/MM/AAAA LO SETTO COME FORMATO DATA
	*** QUESTO PER FAR FUNZIONARE CORRETTAMENTE L'ORDINAMENTO PER DATA SUL FINE EXCEL RISULTANTE
	*** N.B.: I DATI CON FORMATO NATIVO AAAA/MM/GG VENGONO SEMPRE RIBALTATI IN GG/MM/AAAA
	ELSE
		*IF TYPE(_NOMECAMPO) = "C" AND FSIZE(_NOMECAMPO) = 10
		IF TYPE(_NOMECAMPO) = "C" AND FSIZE(_NOMECAMPO) = 10 AND ALLTRIM(_NOMECAMPO) <> "TOP"  && ERASMO - 23/05/2022
			_cSelCommand = "SELECT &_NOMECAMPO FROM &_NOMECUR WHERE (SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/') " + ;
				"OR (SUBSTR(ALLTRIM(&_NOMECAMPO),3,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),6,1) = '/') INTO CURSOR TMP_CUR_XLS"
			&_cSelCommand
			SELECT TMP_CUR_XLS
			GO TOP
			IF !EOF()
				*_NFORMAT = "m/d/yyyy"
				_NFORMAT = "General"
			ENDIF
			USE
			SELECT &_NOMECUR
		ENDIF
	**=> ERASMO - FINE 31/03/2015
		
	ENDIF
	
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR


_lUndo = .F.  && ERASMO - 07/04/2014
_nRIGA = _RIGA_INIZIALE + 1

**=> ERASMO - INIZIO 10/06/2024
_TOT_RECORD = 0
SELECT &_NOMECUR
GO TOP
SCAN
	_TOT_RECORD = _TOT_RECORD + 1
ENDSCAN
**=> ERASMO - FINE 10/06/2024

_CONTA_RECORD=0

SELECT &_NOMECUR
GO TOP
SCAN
	
   *WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
	_CONTA_RECORD=_CONTA_RECORD+1
	
	**=> ERASMO - INIZIO 28/10/2014
	*IF !AQ_WAITBAR("",_NOMECUR,.T.,"Creazione foglio excel in corso... - riga " + ALLTRIM(STR(_CONTA_RECORD)) + " di " + ALLTRIM(STR(RECCOUNT())),_CONTA_RECORD)
	IF !AQ_WAITBAR("",_NOMECUR,.T.,"Creazione foglio excel in corso... - riga " + ALLTRIM(STR(_CONTA_RECORD)) + " di " + ALLTRIM(STR(_TOT_RECORD)),_CONTA_RECORD,_TOT_RECORD)  && ERASMO - 10/06/2024
		_lUndo = .T.
		EXIT
	ENDIF
	**=> ERASMO - FINE 28/10/2014
   
   FOR I = 1 TO _NUMEROCAMPI
      _Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      _NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
      _VALORE = &_NOMECAMPO
      
      IF TYPE(_NOMECAMPO) = "C"
         *_VALORE = ALLTRIM(&_NOMECAMPO)
         _VALORE = RTRIM(&_NOMECAMPO)
*!*			 *** SE DATA ROVESCIATA, LA RIBALTO
*!*			 IF SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/'
*!*			 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
*!*			 ENDIF

		 *** SE DATA (10 CARATTERI) RIBALTATA, LA ROVESCIO
		 IF SUBSTR(ALLTRIM(&_NOMECAMPO),3,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),6,1) = '/' AND FSIZE(_NOMECAMPO) = 10
		 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
		 ENDIF

      ENDIF
      
      objExcel.ActiveSheet.Range(_Range).Select
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
   ENDFOR
   
   _nRIGA = _nRIGA + 1
ENDSCAN
GO TOP  && ERASMO - 10/06/2024

**=> ERASMO - INIZIO 07/04/2014
*** OPERAZIONE ANNULLATA DALL'UTENTE
IF _lUndo
	objExcel.Workbooks.Close()
	RELEASE objExcel
	RETURN .F.
ENDIF
objExcel.DisplayAlerts = .T.
**=> ERASMO - FINE 07/04/2014

**=> ERASMO - INIZIO 21/04/2020
*** INTESTAZIONI DI COLONNA COME DA GRIGLIA PASSATA NEI PARAMETRI
IF TYPE("_OBJGRIDRIF") = "O"
	_T_RIGA = _RIGA_INIZIALE
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		FOR G = 1 TO _OBJGRIDRIF.COLUMNCOUNT
			*IF (ALLTRIM(_OBJGRIDRIF.RECORDSOURCE) + '.' + ALLTRIM(_NOMECAMPO)) $ ALLTRIM(_OBJGRIDRIF.COLUMNS(G).CONTROLSOURCE)
			IF UPPER(ALLTRIM(_OBJGRIDRIF.RECORDSOURCE) + '.' + ALLTRIM(_NOMECAMPO)) $ UPPER(ALLTRIM(_OBJGRIDRIF.COLUMNS(G).CONTROLSOURCE))  && ERASMO - 19/09/2023
				_Range = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				objExcel.Range(_RANGE).Select
				*objExcel.Selection.Value = _OBJGRIDRIF.COLUMNS(G).HEADER1.CAPTION
				**=> ERASMO - INIZIO 19/09/2023
				IF UPPER(ALLTRIM(_OBJGRIDRIF.CLASS)) == "GRIDS"
					objExcel.Selection.Value = _OBJGRIDRIF.COLUMNS(G).H1.CAPTION
				ELSE
					objExcel.Selection.Value = _OBJGRIDRIF.COLUMNS(G).HEADER1.CAPTION
				ENDIF
				**=> ERASMO - FINE 19/09/2023				
				EXIT
			ENDIF
		NEXT
	ENDFOR
ENDIF
**=> ERASMO - FINE 21/04/2020

*** AUTOFIT COLONNE
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
IF _SUBTOTALS
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF

IF PUB_INTXLS  && ERASMO - 31/03/2015
	*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
	WITH objExcel
		.ActiveSheet.Cells(2,6).Value = _TITOLO1
		.ActiveSheet.Cells(2,6).Font.Bold = .T.
		.ActiveSheet.Cells(2,6).Font.Size = 11
		.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(2,6).WrapText = .F.

		.ActiveSheet.Cells(3,6).Value = _TITOLO2
		.ActiveSheet.Cells(3,6).Font.Bold = .T.
		.ActiveSheet.Cells(3,6).Font.Size = 11
		.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(3,6).WrapText = .F.

		.ActiveSheet.Cells(4,6).Value = _TITOLO3
		.ActiveSheet.Cells(4,6).Font.Bold = .T.
		.ActiveSheet.Cells(4,6).Font.Size = 11
		.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(4,6).WrapText = .F.
	ENDWITH
ENDIF  && ERASMO - 31/03/2015

objExcel.Range("A1").Select

*objExcel.Visible = .t.

**=> ERASMO - INIZIO 03/02/2022
IF !EMPTY(_NOMEFILE)
	objExcel.ActiveWorkbook.SaveCopyAs(_NOMEFILE)
	objExcel.ActiveWorkbook.Close(.F.)
ELSE
	objExcel.Visible = .t.
ENDIF
**=> ERASMO - FINE 03/02/2022

IF USED("CUR_ESTRXLS_DEF_DECIMALS")
	SELECT CUR_ESTRXLS_DEF_DECIMALS
	USE
ENDIF

WAIT CLEAR


*!*	***************************
*!*	* Function N2C
*!*	***************************
*!*	FUNCTION N2C
*!*	LPARAMETERS	nNumero
*!*				
*!*	LOCAL cLettera
*!*	cLettera = ""

*!*	IF nNumero<=26
*!*		cLettera=CHR(nNumero+64)
*!*	ELSE
*!*		*cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)	
*!*		
*!*		**=> ERASMO INIZIO - 06/10/2008 - MODIFICA FATTA TRAMITE SEGNALAZIONE LUCA
*!*		if mod (nNumero,26)<>0
*!*			cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)
*!*		else		
*!*		** i multipli di 26 sono un caso particolare che causa il salto della cella xZ es: AZ => B@
*!*		** la formula viene forzata per sistemare il problema
*!*			cLettera=CHR(INT(nNumero/26)+63)+chr(90)	
*!*		ENDIF
*!*		**=> ERASMO FINE - 06/10/2008
*!*		
*!*	ENDIF

*!*	RETURN cLettera
*!*	ENDFUNC

**=> ERASMO INIZIO - 04/12/2013 - RIFACIMENTO COMPLETO DELLA FUNCTION N2C
***************************
* Function N2C
***************************
FUNCTION N2C
LPARAMETERS	nNumero
			
LOCAL cStringa
cStringa= ""

nNumero = ABS(INT(nNumero))
pNumero = nNumero

DO WHILE .T.
	IF pNumero = 0
		EXIT
	ENDIF
	
	_nChr = MOD(pNumero,26) + 64
	IF _nChr = 64
		_nChr = 90
		pNumero = INT(pNumero/26) - 1
	ELSE
		pNumero = INT(pNumero/26)
	ENDIF
	_cChr = CHR(_nChr)
	
	cStringa = _cChr + cStringa
ENDDO

RETURN cStringa
ENDFUNC
**=> ERASMO FINE - 04/12/2013 - RIFACIMENTO COMPLETO DELLA FUNCTION N2C


**=> ERASMO INIZIO - 04/12/2013
***************************
* Function C2N
***************************
FUNCTION C2N
LPARAMETERS	cLettera
			
LOCAL nNumero
nNumero = 0

cLettera = UPPER(ALLTRIM(cLettera))
nLenLettera = LEN(cLettera)

LOCAL i
FOR i = 1 TO nLenLettera
	_nChr = ASC(RIGHT(cLettera,i)) - 64
	nNumero = nNumero + (26^(i-1)) * _nChr
NEXT

RETURN nNumero
ENDFUNC
**=> ERASMO FINE - 04/12/2013


************************************************************************
PROCEDURE GENERA_FILE_CONSUNTIVI_BDG_STC 
************************************************************************
*
* Tale procedura permette la creazione del file excel "Consuntivi su budget annuale e statistiche"
*
* Sintassi:
* 
* DO GENERA_FILE_CONSUNTIVI_BDG_STC WITH <anno>,<unità di misura>,<opzione per sottocartelle da creare>
*
*************************************************************************************************************************************

PARAMETER _ANNO,_UM,_OPZSUBCART,_MESEAL

_NPARA = PARAMETERS()

*!*	IF _NPARA < 3
IF _NPARA < 4  && ERASMO - 11/11/2008
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

_annosel = ALLTRIM(_ANNO)
_unitmis = ALLTRIM(_UM)
_subcart = _OPZSUBCART
**=> ERASMO - INIZIO 11/11/2008
_mese_al = _MESEAL
_des_mese_al = ""
DO CASE
   CASE _mese_al = 1
      _des_mese_al = "GENNAIO"
   CASE _mese_al = 2
      _des_mese_al = "FEBBRAIO"
   CASE _mese_al = 3
      _des_mese_al = "MARZO"
   CASE _mese_al = 4
      _des_mese_al = "APRILE"
   CASE _mese_al = 5
      _des_mese_al = "MAGGIO"
   CASE _mese_al = 6
      _des_mese_al = "GIUGNO"
   CASE _mese_al = 7
      _des_mese_al = "LUGLIO"
   CASE _mese_al = 8
      _des_mese_al = "AGOSTO"
   CASE _mese_al = 9
      _des_mese_al = "SETTEMBRE"
   CASE _mese_al = 10
      _des_mese_al = "OTTOBRE"
   CASE _mese_al = 11
      _des_mese_al = "NOVEMBRE"
   CASE _mese_al = 12
      _des_mese_al = "DICEMBRE"
ENDCASE
**=> ERASMO - FINE 11/11/2008

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()

xlCenter  = -4108
xlBottom  = -4107
xlContext = -5002

xlDiagonalDown = 5
xlDiagonalUp = 6
         
xlNone = -4142
xlContinuous = 1
xlThin = 2
xlMedium = -4138
xlAutomatic = -4105

xlEdgeLeft = 7
xlEdgeTop = 8
xlEdgeBottom = 9
xlEdgeRight = 10
*!*	xlInsideVertical = 11
*!*	xlInsideHorizontal = 12

xlSolid = 1

xlLandscape = 2
xlPortrait = 1
xlPrintNoComments = -4142
xlPaperA4 = 9
xlDownThenOver = 1
xlPrintErrorsDisplayed = 0
    
_prima_scheda = .t.
_n_riga_ini = 0
_n_riga_fin = 0

DO CASE

   CASE _subcart = 1

      BDG_ACQUA_ITALIA = 0
      BDG_ACQUA_ESTERO = 0
      BDG_GOMMA_ITALIA = 0
      BDG_GOMMA_ESTERO = 0
      BDG_SOLVENTE_ITALIA = 0
      BDG_SOLVENTE_ESTERO = 0
      
      STC_ACQUA_ITALIA = 0
      STC_ACQUA_ESTERO = 0
      STC_GOMMA_ITALIA = 0
      STC_GOMMA_ESTERO = 0
      STC_SOLVENTE_ITALIA = 0
      STC_SOLVENTE_ESTERO = 0
      
      STC_ALTRI_ARTICOLI_ITALIA = 0
      STC_ALTRI_ARTICOLI_ESTERO = 0
               
      *** CREAZIONE SCHEDA "ACQUA ESTERO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ACQUA ESTERO) ..." nowait
      _TOTALE_QTA_BDG = 0
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_BDG_STC WITH "ACQUA ESTERO",'A',""
      BDG_ACQUA_ESTERO = _TOTALE_QTA_BDG
      STC_ACQUA_ESTERO = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "ACQUA ITALIA"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ACQUA ITALIA) ..." nowait
      _TOTALE_QTA_BDG = 0
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_BDG_STC WITH "ACQUA ITALIA",'A',"ITA"
      BDG_ACQUA_ITALIA = _TOTALE_QTA_BDG
      STC_ACQUA_ITALIA = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "GOMMA ESTERO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda GOMMA ESTERO) ..." nowait
      _TOTALE_QTA_BDG = 0
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_BDG_STC WITH "GOMMA ESTERO",'R',""
      BDG_GOMMA_ESTERO = _TOTALE_QTA_BDG
      STC_GOMMA_ESTERO = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "GOMMA ITALIA"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda GOMMA ITALIA) ..." nowait
      _TOTALE_QTA_BDG = 0
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_BDG_STC WITH "GOMMA ITALIA",'R',"ITA"
      BDG_GOMMA_ITALIA = _TOTALE_QTA_BDG
      STC_GOMMA_ITALIA = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "SOLVENTE ESTERO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda SOLVENTE ESTERO) ..." nowait
      _TOTALE_QTA_BDG = 0
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_BDG_STC WITH "SOLVENTE ESTERO",'S',""
      BDG_SOLVENTE_ESTERO = _TOTALE_QTA_BDG
      STC_SOLVENTE_ESTERO = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "SOLVENTE ITALIA"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda SOLVENTE ITALIA) ..." nowait
      _TOTALE_QTA_BDG = 0
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_BDG_STC WITH "SOLVENTE ITALIA",'S',"ITA"
      BDG_SOLVENTE_ITALIA = _TOTALE_QTA_BDG
      STC_SOLVENTE_ITALIA = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "ALTRI ARTICOLI ESTERO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ALTRI ARTICOLI ESTERO) ..." nowait
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_STC WITH "ALTRI ARTICOLI ESTERO",""
      STC_ALTRI_ARTICOLI_ESTERO = _TOTALE_QTA_STC

      *** CREAZIONE SCHEDA "ALTRI ARTICOLI ITALIA"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ALTRI ARTICOLI ITALIA) ..." nowait
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_STC WITH "ALTRI ARTICOLI ITALIA","ITA"
      STC_ALTRI_ARTICOLI_ITALIA = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "RIEPILOGO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda RIEPILOGO) ..." nowait
      DO CREA_SCHEDA_RIEPILOGO_BDG_STC WITH "RIEPILOGO"
      
   CASE _subcart = 2
      
      STC_TUTTI_ARTICOLI_ITALIA = 0
      STC_TUTTI_ARTICOLI_ESTERO = 0
      
      *** CREAZIONE SCHEDA "ARTICOLI ESTERO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ARTICOLI ESTERO) ..." nowait
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_STC_ALL WITH "ARTICOLI ESTERO",""
      STC_TUTTI_ARTICOLI_ESTERO = _TOTALE_QTA_STC

      *** CREAZIONE SCHEDA "ARTICOLI ITALIA"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ARTICOLI ITALIA) ..." nowait
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_STC_ALL WITH "ARTICOLI ITALIA","ITA"
      STC_TUTTI_ARTICOLI_ITALIA = _TOTALE_QTA_STC
      
      *** CREAZIONE SCHEDA "RIEPILOGO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda RIEPILOGO) ..." nowait
      DO CREA_SCHEDA_RIEPILOGO_STC_ITA_EXP WITH "RIEPILOGO"
      
   CASE _subcart = 3
      
      STC_TUTTI_ARTICOLI_ITALIA_ESTERO = 0
      
      *** CREAZIONE SCHEDA "ARTICOLI ITALIA-ESTERO"
      WAIT WINDOWS "Creazione foglio excel in corso (scheda ARTICOLI ITALIA-ESTERO) ..." nowait
      _TOTALE_QTA_STC = 0
      DO CREA_SCHEDA_CONSUNTIVI_STC_ITALIA_ESTERO WITH "ARTICOLI ITALIA-ESTERO"
      STC_TUTTI_ARTICOLI_ITALIA_ESTERO = _TOTALE_QTA_STC
   
   OTHERWISE
   
ENDCASE
      
objExcel.Sheets(1).Select
objExcel.Range("A1").Select
objExcel.Visible = .t.

RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_CONSUNTIVI_BDG_STC 
************************************************************************
PARAMETER _NOME_SCH,_TIPO_ART,_NAZION

_nome_scheda = ALLTRIM(_NOME_SCH)
_tipart      = ALLTRIM(_TIPO_ART)
_nazione     = IIF(!EMPTY(ALLTRIM(_NAZION)),ALLTRIM(_NAZION),"")

x_anno = "bdg_anno = '" + _annosel + "'"
x_nazi = IIF(EMPTY(ALLTRIM(_nazione)),"bdg_codnaz <> 'ITA'","bdg_codnaz = '" + ALLTRIM(_nazione) + "'")
x_unit = "bdg_um = '" + _unitmis + "'"
x_tipo = "bdg_tipart = '" + _tipart + "'"
x_cond = x_anno + " and " + x_nazi + " and " + x_unit  + " and " + x_tipo 
cSql = "select * from U_BDG_AN where " + x_cond + " order by bdg_codnaz,bdg_codcli"
IF !ExecCommand(cSql,"CX_BDG_AN")
  return(.f.)
ENDIF
SELECT CX_BDG_AN
GO TOP
IF RECCOUNT() > 65500
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF
INDEX ON BDG_CODNAZ TAG I_NAZCLI ADDITIVE
SET ORDER TO I_NAZCLI 
GO TOP

*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
      
   .Range("C3:J3").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = _nome_scheda + " " + _annosel + " - Unità di misura: " + _unitmis
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO bordo_fine
         
   .Range("A5").Select
   .Selection.Value = "NAZIONE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("B5").Select
   .Selection.Value = "CLIENTE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C5:D5").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Merge
   .Selection.Value = "QTA' CONCORDATA"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("E5:F5").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Merge
   .Selection.Value = "QTA' TOTALE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "ANNO"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("D6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MESE ATTUALE"
   .Selection.Value = _des_mese_al  && ERASMO - 11/11/2008
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("E6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "RICEVUTA"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("F6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "%"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("G6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GEN"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("H6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "FEB"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("I6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("J6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "APR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("K6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("L6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GIU"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("M6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "LUG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("N6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "AGO"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("O6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "SET"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("P6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "OTT"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("Q6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "NOV"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("R6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "DIC"
   .Selection.Font.Bold = .t.
    DO bordo_fine

   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlLandscape
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 60
      .PrintErrors = xlPrintErrorsDisplayed
   EndWith
              
ENDWITH

_N_RIGA = 8
_n_riga_ini = 8
_n_riga_fin = 8

*** VALORIZZAZIONE CONDIZIONE CLIENTI DIVERSI DA 'ITALIA'
z_clie = ""
SELECT BDG_CODCLI AS CLIENTE FROM CX_BDG_AN WHERE BDG_CODCLI <> 'VARI' INTO CURSOR APPOGGIO
SELECT APPOGGIO
GO TOP
SCAN
   IF EMPTY(z_clie)
      z_clie = "stc_codcli <> '" + CLIENTE + "'"
   ELSE
      z_clie = z_clie + " and stc_codcli <> '" + CLIENTE + "'"
   ENDIF
ENDSCAN

SELECT CX_BDG_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   _n_riga_fin = _N_RIGA 
   
   SCATTER MEMVAR
   
   *** VALORIZZAZIONE CAMPI DA BUDGET ANNUALE
   WITH objExcel 
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.BDG_DESNAZ)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
      _RANGE  = "B" + ALLTRIM(STR(_N_RIGA,10,0))
      *_VALORE = ALLTRIM(M.BDG_CODCLI) + " - " + ALLTRIM(M.BDG_RAGSOC)
      _VALORE = SUBSTR(ALLTRIM(M.BDG_RAGSOC),1,15)  && ERASMO - 06/11/2008
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
      _RANGE  = "C" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = M.BDG_QTATOT
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
   ENDWITH
   
   *** VALORIZZAZIONE CAMPI DA ARCHIVIO STATISTICO
   FOR I=1 TO 12
      x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
      x_clie = IIF(ALLTRIM(M.BDG_CODCLI)="VARI",IIF(EMPTY(z_clie),"stc_codcli = stc_codcli",z_clie),"stc_codcli = '" + M.BDG_CODCLI + "'")
      x_unit = "stc_unimis = '" + _unitmis + "'"
      x_ames = "stc_data = '" + _annosel + TRC(2,STR(I,2,0)) + "'"
      x_nazi = IIF(EMPTY(ALLTRIM(_nazione)),"cli_nazion <> 'ITA'","cli_nazion = '" + ALLTRIM(_nazione) + "'")
      *x_tipo = "substring(stc_codart,1,1) = '" + _tipart + "'"
      x_tipo = "art_basade = '" + _tipart + "'"  && ERASMO - 09/06/2008
      x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_nazi + " and " + x_tipo 
	  ***cSql = "select SUM(STC_QTAVEN) AS QUANTITA from U_STC_AN INNER JOIN U_CLI_AN ON U_STC_AN.STC_CODCLI = U_CLI_AN.CLI_CODCLI WHERE " + x_cond
      *cSql = "select SUM(ORD_QTAMQ) AS QUANTITA from U_STC_AN INNER JOIN U_CLI_AN ON U_STC_AN.STC_CODCLI = U_CLI_AN.CLI_CODCLI WHERE " + x_cond      
      cSql = "select SUM(ORD_QTAMQ) AS QUANTITA from U_STC_AN INNER JOIN U_CLI_AN ON U_STC_AN.STC_CODCLI = U_CLI_AN.CLI_CODCLI " + ;
             "INNER JOIN U_ART_PR ON U_STC_AN.STC_CODART = U_ART_PR.ART_CODPRI WHERE " + x_cond  && ERASMO - 09/06/2008
      IF !ExecCommand(cSql,"CX_STC_AN")
        return(.f.)
      ENDIF
      SELECT CX_STC_AN
      _QUANTITA = IIF(ISNULL(QUANTITA),0,QUANTITA)
      DO CASE
         CASE I = 1
            _RANGE  = "G" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 2
            _RANGE  = "H" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 3
            _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 4
            _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 5
            _RANGE  = "K" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 6
            _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 7
            _RANGE  = "M" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 8
            _RANGE  = "N" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 9
            _RANGE  = "O" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 10
            _RANGE  = "P" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 11
            _RANGE  = "Q" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 12
            _RANGE  = "R" + ALLTRIM(STR(_N_RIGA,10,0))
      ENDCASE
      WITH objExcel 
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _QUANTITA
         DO bordi_lato
      ENDWITH
   ENDFOR
   
   _N_RIGA = _N_RIGA + 1
   
   SELECT CX_BDG_AN
   SKIP +1
ENDDO

*** TOTALI
_T_RIGA  = _n_riga_fin + 2
_RIF_SUM = _n_riga_fin - _n_riga_ini + 2
WITH objExcel 
   
   _RANGE  = "B" + ALLTRIM(STR(_T_RIGA,10,0))
   _VALORE = "Totale"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
   .Selection.Font.Bold = .t.
   _RANGE_TOTALE_QTA_BDG = _RANGE
   
   _RANGE  = "D" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
   .Selection.Font.Bold = .t.
   *_RANGE_TOTALE_QTA_STC = _RANGE
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('F') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
      .Selection.Font.Bold = .t.
      **=> ERASMO - INIZIO 11/11/2008
      *** CALCOLO IL TOTALE DELLA QTA' VENDUTA SOMMANDO I TOTALI FINO DEL MESE SELEZIONATO
      IF _mese_al >= I
         _TOTALE_QTA_STC = _TOTALE_QTA_STC + .Selection.Value
      ENDIF
      **=> ERASMO - FINE 11/11/2008
   ENDFOR
   
   .Range("A1").Select

ENDWITH


*** GIORNI LAVORATIVI MENSILI E TOTALI
_T_RIGA = _n_riga_fin + 10
WITH objExcel 

   _RANGE  = "E" + ALLTRIM(STR(_T_RIGA,10,0))
   _VALORE = "Giorni lav."
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Bold = .t.   
   
   FOR I = 1 TO 12
      cSql = "select count(*) as N_GIORNI_LAV from u_cal_la where cal_lavo = 1 and substring(cal_datamg,1,7) = '" + _annosel + "/" + TRC(2,ALLTRIM(STR(I,2,0))) + "'"
      IF !ExecCommand(cSql,"CU_CAL_LA")
        return(.f.)
      ENDIF
      _ANSI_CODE = ASC('F') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      _VALORE = IIF(ISNULL(N_GIORNI_LAV),0,N_GIORNI_LAV)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "##"
      .Selection.Value = _VALORE
   ENDFOR
   
   _RANGE  = "S" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "###"
   .ActiveCell.FormulaR1C1 = "=SUM(RC[-12]:RC[-1])"
   .Selection.Font.Bold = .t.
   
   .Range("A1").Select

ENDWITH

*** PERCENTUALI GIORNI
_T_RIGA = _n_riga_fin + 8
WITH objExcel 
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('F') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "0.0%"
      .ActiveCell.FormulaR1C1 = "=R[2]C/R[2]C19"
      .Selection.Font.ColorIndex = 3
   ENDFOR
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('F') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA+1,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "0.0%"
      .ActiveCell.FormulaR1C1 = "=RC[-1]+R[-1]C"
      .Selection.Font.ColorIndex = 5
      **=> ERASMO - INIZIO 11/11/2008
      IF _mese_al = I
         _PERC_TOTALE_QTA_BDG = .Selection.value
      ENDIF
      **=> ERASMO - FINE 11/11/2008
   ENDFOR
   
   _RANGE  = "F" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(RC[1]:RC[12])"
   *.Selection.Font.ColorIndex = 3
   
   .Range("A1").Select

ENDWITH

*** BUDGET MESE ATTUALE, QTA' TOTALE RICEVUTA, %
*_ATT_MESE = MONTH(DATE())
_ATT_MESE = _mese_al  && ERASMO - 11/11/2008
_RIF_COL1 = _ATT_MESE + 6
_RIF_COL2 = 6
_RIF_ROW = _n_riga_fin + 8
_RIF_FUNC1 = "R" + ALLTRIM(STR(_RIF_ROW,10,0)) + "C" + ALLTRIM(STR(_RIF_COL1,10,0))
_RIF_FUNC2 = "R" + ALLTRIM(STR(_RIF_ROW,10,0)) + "C" + ALLTRIM(STR(_RIF_COL2,10,0))
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
   
      _RANGE  = "D" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "="+_RIF_FUNC1+"*RC[-1]"
      .Range("A1").Select
      
      _RANGE  = "E" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(RC[2]:RC[13])"
      
      _RANGE  = "F" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "0.0%"
      .ActiveCell.FormulaR1C1 = "=RC[-1]/(RC[-3]*"+_RIF_FUNC2+")-100%"
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR
WITH objExcel 
   _RANGE  = "F" + ALLTRIM(STR(_n_riga_fin+2,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-1]/(RC[-3]*"+_RIF_FUNC2+")-100%"
ENDWITH


*** PIANO MENSILE, CUMULATIVO E PERCENTUALE
_T_RIGA  = _n_riga_fin + 4
_RIF_COL = 3
_RIF_ROW = _n_riga_fin + 2
_RIF_FUNC = "R" + ALLTRIM(STR(_RIF_ROW,10,0)) + "C" + ALLTRIM(STR(_RIF_COL,10,0))
WITH objExcel 
   _RANGE  = "E" + ALLTRIM(STR(_T_RIGA,10,0))
   _VALORE = "Piano mensile"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   *.Selection.Font.Bold = .t.
   
   _RANGE  = "E" + ALLTRIM(STR(_T_RIGA+1,10,0))
   _VALORE = "Piano cumulativo"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   *.Selection.Font.Bold = .t.
   
   _RANGE  = "E" + ALLTRIM(STR(_T_RIGA+2,10,0))
   _VALORE = "% sul piano"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   *.Selection.Font.Bold = .t.
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('F') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0"
      .ActiveCell.FormulaR1C1 = "="+_RIF_FUNC+"*R[4]C"
      
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA+1,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0"
      .ActiveCell.FormulaR1C1 = "=R[-1]C+RC[-1]"
      
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA+2,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "0.0%"
      .ActiveCell.FormulaR1C1 = "=R[-4]C/R[-2]C-100%"
   ENDFOR
   
   _RANGE  = "G" + ALLTRIM(STR(_T_RIGA+2,10,0)) + ":R" + ALLTRIM(STR(_T_RIGA+2,10,0))
   .Range(_RANGE).Select
   DO bordo_fine
   
   .Range("A1").Select

ENDWITH

    
*** SFONDO GRIGIO ALTERNATO
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      IF MOD(I,2) <> 0  && SOLO RIGHE PARI
         LOOP
      ENDIF
      
      _RANGE  = "D" + ALLTRIM(STR(I,10,0)) + ":R" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.Interior.ColorIndex = 15
      .Selection.Interior.Pattern = xlSolid
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR
    
WITH objExcel 
    .Columns("A:A").EntireColumn.AutoFit
    .Columns("B:B").EntireColumn.AutoFit
    .Columns("C:C").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("E:E").EntireColumn.AutoFit
    .Columns("F:F").EntireColumn.AutoFit
    .Columns("G:G").EntireColumn.AutoFit
    .Columns("H:H").EntireColumn.AutoFit
    .Columns("I:I").EntireColumn.AutoFit
    .Columns("J:J").EntireColumn.AutoFit
    .Columns("K:K").EntireColumn.AutoFit
    .Columns("L:L").EntireColumn.AutoFit
    .Columns("M:M").EntireColumn.AutoFit
    .Columns("N:N").EntireColumn.AutoFit
    .Columns("O:O").EntireColumn.AutoFit
    .Columns("P:P").EntireColumn.AutoFit
    .Columns("Q:Q").EntireColumn.AutoFit
    .Columns("R:R").EntireColumn.AutoFit
    .Columns("S:S").EntireColumn.AutoFit
ENDWITH

_prima_scheda = .F.

*!*	WITH objExcel 
*!*	   .Range(_RANGE_TOTALE_QTA_BDG).Select
*!*	   _TOTALE_QTA_BDG = .Selection.value
*!*	   .Range(_RANGE_TOTALE_QTA_STC).Select
*!*	   _TOTALE_QTA_STC = .Selection.value
*!*	   .Range("A1").Select
*!*	ENDWITH

**=> ERASMO - INIZIO 11/11/2008
WITH objExcel 
   *** CALCOLO IL TOTALE DELLA QTA' BUDGET RISPETTO ALLA PERCENTUALE CUMULATIVA DEL MESE SELEZIONATO
   .Range(_RANGE_TOTALE_QTA_BDG).Select
   _TOTALE_QTA_BDG = .Selection.value * ROUND(_PERC_TOTALE_QTA_BDG,3)
   .Range("A1").Select
ENDWITH
**=> ERASMO - FINE 11/11/2008
      
RETURN



************************************************************************
PROCEDURE CREA_SCHEDA_CONSUNTIVI_STC 
************************************************************************
PARAMETER _NOME_SCH,_NAZION

_nome_scheda = ALLTRIM(_NOME_SCH)
_nazione     = IIF(!EMPTY(ALLTRIM(_NAZION)),ALLTRIM(_NAZION),"")


*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
      
   .Range("C3:O3").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = _nome_scheda + " " + _annosel + " - Unità di misura: " + _unitmis
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO bordo_fine
         
   .Range("A5").Select
   .Selection.Value = "NAZIONE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("B5").Select
   .Selection.Value = "CLIENTE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C5:C5").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Merge
   .Selection.Value = "QTA' TOTALE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "RICEVUTA"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("D6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GEN"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("E6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "FEB"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("F6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("G6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "APR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("H6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("I6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GIU"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("J6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "LUG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("K6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "AGO"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("L6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "SET"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("M6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "OTT"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("N6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "NOV"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("O6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "DIC"
   .Selection.Font.Bold = .t.
    DO bordo_fine

   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlLandscape
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 60
      .PrintErrors = xlPrintErrorsDisplayed
   EndWith
              
ENDWITH

_N_RIGA = 8
_n_riga_ini = 8
_n_riga_fin = 8

*** LETTURA ARCHIVIO STATISTICO
x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
x_clie = "stc_codcli = stc_codcli"
x_unit = "stc_unimis = '" + _unitmis + "'"
x_ames = "substring(stc_data,1,4) = '" + _annosel + "'"
****** simone - 2008/11/06 - inizio
***x_tipo = "substring(stc_codart,1,1) <> 'A' AND substring(stc_codart,1,1) <> 'R' AND substring(stc_codart,1,1) <> 'S'"
x_tipo = "STC_CODART NOT IN (SELECT art_CODPRI FROM U_ART_PR WHERE ART_BASADE = 'A' OR art_basade = 'R' OR  art_basade = 'S')"  
****** simone - 2008/11/06 - fine
x_nazi = IIF(EMPTY(ALLTRIM(_nazione)),"cli_nazion <> 'ITA'","cli_nazion = '" + ALLTRIM(_nazione) + "'")
x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_tipo + " and " + x_nazi 
cSql = "select STC_CODCLI,CLI_NAZION from U_STC_AN INNER JOIN U_CLI_AN ON U_STC_AN.STC_CODCLI = U_CLI_AN.CLI_CODCLI WHERE " + x_cond + " GROUP BY STC_CODCLI,CLI_NAZION"
IF !ExecCommand(cSql,"CU_STC_AN")
  return(.f.)
ENDIF
SELECT CU_STC_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   _n_riga_fin = _N_RIGA 
   
   SCATTER MEMVAR
   
   M.CLI_RAGSOC = ""
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "cli_codcli = '" + M.STC_CODCLI + "'"
   x_cond = x_soci + " and " + x_clie
   cSql = "select cli_codcli,cli_ragsoc from U_CLI_AN WHERE " + x_cond + " order by cli_codcli,cli_ragsoc"
   IF !ExecCommand(cSql,"CX_CLI_AN")
     return(.f.)
   ENDIF
   SELECT CX_CLI_AN
   GO TOP
   IF EOF()
   ELSE
      M.CLI_RAGSOC = CLI_RAGSOC
   ENDIF
   
   M.CLI_DESNAZ = ""
   x_codi = "codice = 'STA" + M.CLI_NAZION + "'"
   x_cond = x_codi
   cSql = "select * from PARA WHERE " + x_cond
   IF !ExecCommand(cSql,"CX_PARA")
     return(.f.)
   ENDIF
   SELECT CX_PARA
   GO TOP
   IF EOF()
   ELSE
      M.CLI_DESNAZ = DESCRI
   ENDIF
   
   *** VALORIZZAZIONE CAMPI CLIENTE
   WITH objExcel 
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.CLI_DESNAZ)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
      _RANGE  = "B" + ALLTRIM(STR(_N_RIGA,10,0))
      *_VALORE = ALLTRIM(M.STC_CODCLI) + " - " + ALLTRIM(M.CLI_RAGSOC)
      _VALORE = SUBSTR(ALLTRIM(M.CLI_RAGSOC),1,15)  && ERASMO - 06/11/2008
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
   ENDWITH
   
   *** VALORIZZAZIONE CAMPI DA ARCHIVIO STATISTICO
   FOR I=1 TO 12
      x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
      x_clie = "stc_codcli = '" + M.STC_CODCLI + "'"
      x_unit = "stc_unimis = '" + _unitmis + "'"
      x_ames = "stc_data = '" + _annosel + TRC(2,STR(I,2,0)) + "'"
      ***** simone - 2008/11/06 - inizio
      *x_tipo = "substring(stc_codart,1,1) <> 'A' AND substring(stc_codart,1,1) <> 'R' AND substring(stc_codart,1,1) <> 'S'"
      x_tipo = "STC_CODART NOT IN (SELECT art_CODPRI FROM U_ART_PR WHERE ART_BASADE = 'A' OR art_basade = 'R' OR  art_basade = 'S')"  
      ***** simone - 2008/11/06 - inizio      
      x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_tipo 
      ***cSql = "select SUM(STC_QTAVEN) AS QUANTITA from U_STC_AN WHERE " + x_cond
      cSql = "select SUM(ORD_QTAMQ) AS QUANTITA from U_STC_AN WHERE " + x_cond      
      IF !ExecCommand(cSql,"CX_STC_AN")
        return(.f.)
      ENDIF
      SELECT CX_STC_AN
      _QUANTITA = IIF(ISNULL(QUANTITA),0,QUANTITA)
      DO CASE
         CASE I = 1
            _RANGE  = "D" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 2
            _RANGE  = "E" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 3
            _RANGE  = "F" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 4
            _RANGE  = "G" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 5
            _RANGE  = "H" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 6
            _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 7
            _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 8
            _RANGE  = "K" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 9
            _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 10
            _RANGE  = "M" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 11
            _RANGE  = "N" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 12
            _RANGE  = "O" + ALLTRIM(STR(_N_RIGA,10,0))
      ENDCASE
      WITH objExcel 
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _QUANTITA
         DO bordi_lato
      ENDWITH
   ENDFOR
   
   _N_RIGA = _N_RIGA + 1
   
   SELECT CU_STC_AN
   SKIP +1
ENDDO

*** QTA' TOTALE RICEVUTA
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      _RANGE  = "C" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(RC[1]:RC[12])"
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR

*** TOTALI
_T_RIGA  = _n_riga_fin + 2
_RIF_SUM = _n_riga_fin - _n_riga_ini + 2
WITH objExcel 
   
   _RANGE  = "B" + ALLTRIM(STR(_T_RIGA,10,0))
   _VALORE = "Totale"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
   .Selection.Font.Bold = .t.
   *_RANGE_TOTALE_QTA_STC = _RANGE
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('C') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
      .Selection.Font.Bold = .t.
      **=> ERASMO - INIZIO 11/11/2008
      *** CALCOLO IL TOTALE DELLA QTA' VENDUTA SOMMANDO I TOTALI FINO DEL MESE SELEZIONATO
      IF _mese_al >= I
         _TOTALE_QTA_STC = _TOTALE_QTA_STC + .Selection.Value
      ENDIF
      **=> ERASMO - FINE 11/11/2008
   ENDFOR
   
   .Range("A1").Select

ENDWITH


*** SFONDO GRIGIO ALTERNATO
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      IF MOD(I,2) <> 0  && SOLO RIGHE PARI
         LOOP
      ENDIF
      
      _RANGE  = "C" + ALLTRIM(STR(I,10,0)) + ":O" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.Interior.ColorIndex = 15
      .Selection.Interior.Pattern = xlSolid
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR
    
WITH objExcel 
    .Columns("A:A").EntireColumn.AutoFit
    .Columns("B:B").EntireColumn.AutoFit
    .Columns("C:C").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("E:E").EntireColumn.AutoFit
    .Columns("F:F").EntireColumn.AutoFit
    .Columns("G:G").EntireColumn.AutoFit
    .Columns("H:H").EntireColumn.AutoFit
    .Columns("I:I").EntireColumn.AutoFit
    .Columns("J:J").EntireColumn.AutoFit
    .Columns("K:K").EntireColumn.AutoFit
    .Columns("L:L").EntireColumn.AutoFit
    .Columns("M:M").EntireColumn.AutoFit
    .Columns("N:N").EntireColumn.AutoFit
    .Columns("O:O").EntireColumn.AutoFit
ENDWITH

_prima_scheda = .F.

*!*	WITH objExcel
*!*	   .Range(_RANGE_TOTALE_QTA_STC).Select
*!*	   _TOTALE_QTA_STC = .Selection.value
*!*	   .Range("A1").Select
*!*	ENDWITH

RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_RIEPILOGO_BDG_STC
************************************************************************
PARAMETER _NOME_SCH

_nome_scheda = ALLTRIM(_NOME_SCH)

xl3DPie = -4102
xlColumns = 2
xlLocationAsObject = 2

*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
      
   .Range("C3:I3").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   *.Selection.Value = "CUMULATIVO VENDUTO" + " " + _annosel + " - " + _unitmis
   .Selection.Value = "CUMULATIVO VENDUTO ANNO " + _annosel + " AL MESE DI " + _des_mese_al + " - " + _unitmis  && ERASMO - 11/11/2008
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO bordo_fine
         
   .Range("E6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "PIANO"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   .Range("G6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "VENDUTO"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   .Range("I6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlPortrait
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 65
      .PrintErrors = xlPrintErrorsDisplayed
   EndWith
              
ENDWITH

*** SCRIVO I DATI STATISTICI
WITH objExcel 
      
   _RANGE  = "C8"
   _VALORE = "ACQUA ITALIA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C9"
   _VALORE = "ACQUA ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C10"
   _VALORE = "TOTALE ACQUA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E8"
   _VALORE = BDG_ACQUA_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E9"
   _VALORE = BDG_ACQUA_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E10"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G8"
   _VALORE = STC_ACQUA_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G9"
   _VALORE = STC_ACQUA_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G10"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I8"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I9"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I10"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   *******************************
   
   _RANGE  = "C12"
   _VALORE = "GOMMA ITALIA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C13"
   _VALORE = "GOMMA ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C14"
   _VALORE = "TOTALE GOMMA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E12"
   _VALORE = BDG_GOMMA_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E13"
   _VALORE = BDG_GOMMA_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E14"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G12"
   _VALORE = STC_GOMMA_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G13"
   _VALORE = STC_GOMMA_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G14"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   
   _RANGE  = "I12"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I13"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I14"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   *******************************
   
   _RANGE  = "C16"
   _VALORE = "SOLVENTE ITALIA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C17"
   _VALORE = "SOLVENTE ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C18"
   _VALORE = "TOTALE SOLVENTE"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E16"
   _VALORE = BDG_SOLVENTE_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E17"
   _VALORE = BDG_SOLVENTE_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E18"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G16"
   _VALORE = STC_SOLVENTE_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G17"
   _VALORE = STC_SOLVENTE_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G18"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   
   _RANGE  = "I16"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I17"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I18"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   *******************************
   
   _RANGE  = "C20"
   _VALORE = "ALTRI ARTICOLI ITALIA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C21"
   _VALORE = "ALTRI ARTICOLI ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C22"
   _VALORE = "TOTALE ALTRI ARTICOLI"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
*!*	   _RANGE  = "E20"
*!*	   _VALORE = 0
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0"
*!*	   .Selection.Value = _VALORE
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "E21"
*!*	   _VALORE = 0
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0"
*!*	   .Selection.Value = _VALORE
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "E22"
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
   
   _RANGE  = "G20"
   _VALORE = STC_ALTRI_ARTICOLI_ITALIA
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G21"
   _VALORE = STC_ALTRI_ARTICOLI_ESTERO
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G22"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   
*!*	   _RANGE  = "I20"
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "0.0%"
*!*	   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "I21"
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "0.0%"
*!*	   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "I22"
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "0.0%"
*!*	   .ActiveCell.FormulaR1C1 = "=RC[-2]/RC[-4]-100%"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
   
   
   *******************************
   
   _RANGE  = "C24"
   _VALORE = "TOTALE ITALIA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E24"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G24"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I24"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   
   _RANGE  = "C25"
   _VALORE = "TOTALE ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E25"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G25"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I25"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   
   _RANGE  = "C26"
   _VALORE = "TOTALE ITALIA + ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "E26"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "G26"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I26"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "0.0%"
   .ActiveCell.FormulaR1C1 = "=R[-16]C+R[-12]C+R[-8]C+R[-4]C"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   .Range("A1").Select
      
ENDWITH


*** GENERO IL GRAFICO A TORTA "QUOTA PER MERCATO"
WITH objExcel 
     
     *** CREO IL GRAFICO A TORTA ED IMPOSTO LE CELLE DI ORIGINE DATI
    .Charts.Add
    .ActiveChart.ChartType = xl3DPie
    .ActiveChart.SetSourceData(.Sheets("RIEPILOGO").Range("G8;G9;G12;G13;G16;G17;G20;G21"),xlColumns)
    .ActiveChart.SeriesCollection(1).XValues = "=(RIEPILOGO!R8C3,RIEPILOGO!R9C3,RIEPILOGO!R12C3,RIEPILOGO!R13C3,RIEPILOGO!R16C3,RIEPILOGO!R17C3,RIEPILOGO!R20C3,RIEPILOGO!R21C3)"
    .ActiveChart.Location(xlLocationAsObject,"RIEPILOGO")
    .ActiveChart.HasTitle = .F.
    
     *** IMPOSTO IL TITOLO DEL GRAFICO
    .ActiveChart.PlotArea.Select
    .ActiveChart.HasTitle = .T.
    .ActiveChart.ChartTitle.Characters.Text = "QUOTA PER MERCATO"

     *** IMPOSTO LA FORMATTAZIONE DEL GRAFICO
    .ActiveChart.HasLegend = .T.
    .ActiveChart.Legend.Select
    .Selection.Position = xlBottom
    .ActiveChart.ApplyDataLabels(NULL,.F.,.T.,.T.,.F.,.F.,.F.,.T.,.F.,NULL)
    .ActiveChart.PlotArea.Select
    .ActiveChart.PlotArea.Border.Weight = xlThin
    .ActiveChart.PlotArea.Border.LineStyle = xlNone
    .ActiveChart.PlotArea.Interior.ColorIndex = xlNone

     *** IMPOSTO LE DIMENSIONI E LA POSIZIONE DEL GRAFICO
    .ActiveChart.ChartArea.Select
    _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,"RIEPILOGO",""))
    
    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(-360)
    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementTop(183.75)
    
    .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(3).Left
    .ActiveSheet.Shapes(_NOME_GRAFICO).Top = 500

    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(0.65,0,0)
    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(0.75,0,0)

    .Sheets("RIEPILOGO").Range("A1").Select
ENDWITH


*** GENERO IL GRAFICO A TORTA "QUOTA EXPORT"
WITH objExcel 
     
     *** CREO IL GRAFICO A TORTA ED IMPOSTO LE CELLE DI ORIGINE DATI
    .Charts.Add
    .ActiveChart.ChartType = xl3DPie
    .ActiveChart.SetSourceData(.Sheets("RIEPILOGO").Range("G24;G25"),xlColumns)
    .ActiveChart.SeriesCollection(1).XValues = "=(RIEPILOGO!R24C3,RIEPILOGO!R25C3)"
    .ActiveChart.Location(xlLocationAsObject,"RIEPILOGO")
    .ActiveChart.HasTitle = .F.
    
     *** IMPOSTO IL TITOLO DEL GRAFICO
    .ActiveChart.PlotArea.Select
    .ActiveChart.HasTitle = .T.
    .ActiveChart.ChartTitle.Characters.Text = "QUOTA EXPORT"

     *** IMPOSTO LA FORMATTAZIONE DEL GRAFICO
    .ActiveChart.HasLegend = .T.
    .ActiveChart.Legend.Select
    .Selection.Position = xlBottom
    .ActiveChart.ApplyDataLabels(NULL,.F.,.T.,.T.,.F.,.F.,.F.,.T.,.F.,NULL)
    .ActiveChart.PlotArea.Select
    .ActiveChart.PlotArea.Border.Weight = xlThin
    .ActiveChart.PlotArea.Border.LineStyle = xlNone
    .ActiveChart.PlotArea.Interior.ColorIndex = xlNone
    
     *** IMPOSTO LE DIMENSIONI E LA POSIZIONE DEL GRAFICO
    .ActiveChart.ChartArea.Select
    _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,"RIEPILOGO",""))
    
    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(-360)
    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementTop(183.75)
    
    .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(3).Left
    .ActiveSheet.Shapes(_NOME_GRAFICO).Top = 800

    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(0.65,0,0)
    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(0.75,0,0)

    .Sheets("RIEPILOGO").Range("A1").Select
ENDWITH


WITH objExcel 
    .Columns("C:C").ColumnWidth = 20
    .Columns("D:D").ColumnWidth = 12
    .Columns("E:E").ColumnWidth = 20
    .Columns("F:F").ColumnWidth = 12
    .Columns("G:G").ColumnWidth = 20
    .Columns("H:H").ColumnWidth = 12
    .Columns("I:I").ColumnWidth = 20
ENDWITH

RETURN


************************************************************************
PROCEDURE bordo_fine
************************************************************************
.Selection.Borders(xlDiagonalDown).LineStyle = xlNone
.Selection.Borders(xlDiagonalUp).LineStyle = xlNone
With .Selection.Borders(xlEdgeLeft)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
EndWith
With .Selection.Borders(xlEdgeTop)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
EndWith
With .Selection.Borders(xlEdgeBottom)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
EndWith
With .Selection.Borders(xlEdgeRight)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
EndWith

RETURN

************************************************************************
PROCEDURE bordi_lato
************************************************************************
.Selection.Borders(xlDiagonalDown).LineStyle = xlNone
.Selection.Borders(xlDiagonalUp).LineStyle = xlNone
With .Selection.Borders(xlEdgeLeft)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
EndWith
With .Selection.Borders(xlEdgeRight)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
EndWith

RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_CONSUNTIVI_STC_ALL
************************************************************************
PARAMETER _NOME_SCH,_NAZION

_nome_scheda = ALLTRIM(_NOME_SCH)
_nazione     = IIF(!EMPTY(ALLTRIM(_NAZION)),ALLTRIM(_NAZION),"")


*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
      
   .Range("C3:O3").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = _nome_scheda + " " + _annosel + " - Unità di misura: " + _unitmis
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO bordo_fine
         
   .Range("A5").Select
   .Selection.Value = "NAZIONE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("B5").Select
   .Selection.Value = "CLIENTE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C5:C5").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Merge
   .Selection.Value = "QTA' TOTALE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "RICEVUTA"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("D6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GEN"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("E6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "FEB"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("F6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("G6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "APR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("H6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("I6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GIU"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("J6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "LUG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("K6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "AGO"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("L6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "SET"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("M6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "OTT"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("N6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "NOV"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("O6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "DIC"
   .Selection.Font.Bold = .t.
    DO bordo_fine

   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlLandscape
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 60
      .PrintErrors = xlPrintErrorsDisplayed
   EndWith
              
ENDWITH

_N_RIGA = 8
_n_riga_ini = 8
_n_riga_fin = 8

*** LETTURA ARCHIVIO STATISTICO
x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
x_clie = "stc_codcli = stc_codcli"
x_unit = "stc_unimis = '" + _unitmis + "'"
x_ames = "substring(stc_data,1,4) = '" + _annosel + "'"
x_tipo = "stc_codart = stc_codart"
x_nazi = IIF(EMPTY(ALLTRIM(_nazione)),"cli_nazion <> 'ITA'","cli_nazion = '" + ALLTRIM(_nazione) + "'")
x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_tipo + " and " + x_nazi 
cSql = "select STC_CODCLI,CLI_NAZION from U_STC_AN INNER JOIN U_CLI_AN ON U_STC_AN.STC_CODCLI = U_CLI_AN.CLI_CODCLI WHERE " + x_cond + " GROUP BY STC_CODCLI,CLI_NAZION"
IF !ExecCommand(cSql,"CU_STC_AN")
  return(.f.)
ENDIF
SELECT CU_STC_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   _n_riga_fin = _N_RIGA 
   
   SCATTER MEMVAR
   
   M.CLI_RAGSOC = ""
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "cli_codcli = '" + M.STC_CODCLI + "'"
   x_cond = x_soci + " and " + x_clie
   cSql = "select cli_codcli,cli_ragsoc from U_CLI_AN WHERE " + x_cond + " order by cli_codcli,cli_ragsoc"
   IF !ExecCommand(cSql,"CX_CLI_AN")
     return(.f.)
   ENDIF
   SELECT CX_CLI_AN
   GO TOP
   IF EOF()
   ELSE
      M.CLI_RAGSOC = CLI_RAGSOC
   ENDIF
   
   M.CLI_DESNAZ = ""
   x_codi = "codice = 'STA" + M.CLI_NAZION + "'"
   x_cond = x_codi
   cSql = "select * from PARA WHERE " + x_cond
   IF !ExecCommand(cSql,"CX_PARA")
     return(.f.)
   ENDIF
   SELECT CX_PARA
   GO TOP
   IF EOF()
   ELSE
      M.CLI_DESNAZ = DESCRI
   ENDIF
   
   *** VALORIZZAZIONE CAMPI CLIENTE
   WITH objExcel 
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.CLI_DESNAZ)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
      _RANGE  = "B" + ALLTRIM(STR(_N_RIGA,10,0))
      *_VALORE = ALLTRIM(M.STC_CODCLI) + " - " + ALLTRIM(M.CLI_RAGSOC)
      _VALORE = SUBSTR(ALLTRIM(M.CLI_RAGSOC),1,15)  && ERASMO - 06/11/2008
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
   ENDWITH
   
   *** VALORIZZAZIONE CAMPI DA ARCHIVIO STATISTICO
   FOR I=1 TO 12
      x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
      x_clie = "stc_codcli = '" + M.STC_CODCLI + "'"
      x_unit = "stc_unimis = '" + _unitmis + "'"
      x_ames = "stc_data = '" + _annosel + TRC(2,STR(I,2,0)) + "'"
      x_tipo = "stc_codart = stc_codart"
      x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_tipo 
      ***cSql = "select SUM(STC_QTAVEN) AS QUANTITA from U_STC_AN WHERE " + x_cond
      cSql = "select SUM(ORD_QTAMQ) AS QUANTITA from U_STC_AN WHERE " + x_cond      
      IF !ExecCommand(cSql,"CX_STC_AN")
        return(.f.)
      ENDIF
      SELECT CX_STC_AN
      _QUANTITA = IIF(ISNULL(QUANTITA),0,QUANTITA)
      DO CASE
         CASE I = 1
            _RANGE  = "D" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 2
            _RANGE  = "E" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 3
            _RANGE  = "F" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 4
            _RANGE  = "G" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 5
            _RANGE  = "H" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 6
            _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 7
            _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 8
            _RANGE  = "K" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 9
            _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 10
            _RANGE  = "M" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 11
            _RANGE  = "N" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 12
            _RANGE  = "O" + ALLTRIM(STR(_N_RIGA,10,0))
      ENDCASE
      WITH objExcel 
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _QUANTITA
         DO bordi_lato
      ENDWITH
   ENDFOR
   
   _N_RIGA = _N_RIGA + 1
   
   SELECT CU_STC_AN
   SKIP +1
ENDDO

*** QTA' TOTALE RICEVUTA
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      _RANGE  = "C" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(RC[1]:RC[12])"
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR

*** TOTALI
_T_RIGA  = _n_riga_fin + 2
_RIF_SUM = _n_riga_fin - _n_riga_ini + 2
WITH objExcel 
   
   _RANGE  = "B" + ALLTRIM(STR(_T_RIGA,10,0))
   _VALORE = "Totale"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
   .Selection.Font.Bold = .t.
   _RANGE_TOTALE_QTA_STC = _RANGE
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('C') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
      .Selection.Font.Bold = .t.
   ENDFOR
   
   .Range("A1").Select

ENDWITH


*** SFONDO GRIGIO ALTERNATO
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      IF MOD(I,2) <> 0  && SOLO RIGHE PARI
         LOOP
      ENDIF
      
      _RANGE  = "C" + ALLTRIM(STR(I,10,0)) + ":O" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.Interior.ColorIndex = 15
      .Selection.Interior.Pattern = xlSolid
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR
    
WITH objExcel 
    .Columns("A:A").EntireColumn.AutoFit
    .Columns("B:B").EntireColumn.AutoFit
    .Columns("C:C").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("E:E").EntireColumn.AutoFit
    .Columns("F:F").EntireColumn.AutoFit
    .Columns("G:G").EntireColumn.AutoFit
    .Columns("H:H").EntireColumn.AutoFit
    .Columns("I:I").EntireColumn.AutoFit
    .Columns("J:J").EntireColumn.AutoFit
    .Columns("K:K").EntireColumn.AutoFit
    .Columns("L:L").EntireColumn.AutoFit
    .Columns("M:M").EntireColumn.AutoFit
    .Columns("N:N").EntireColumn.AutoFit
    .Columns("O:O").EntireColumn.AutoFit
ENDWITH

_prima_scheda = .F.

WITH objExcel
   .Range(_RANGE_TOTALE_QTA_STC).Select
   _TOTALE_QTA_STC = .Selection.value
   .Range("A1").Select
ENDWITH

RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_RIEPILOGO_STC_ITA_EXP
************************************************************************
PARAMETER _NOME_SCH

_nome_scheda = ALLTRIM(_NOME_SCH)

xl3DPie = -4102
xlColumns = 2
xlLocationAsObject = 2

*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
      
   .Range("C3:I3").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = "CUMULATIVO VENDUTO" + " " + _annosel + " - " + _unitmis
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO bordo_fine
         
*!*	   .Range("E6").Select
*!*	   .Selection.HorizontalAlignment = xlCenter
*!*	   .Selection.Value = "PIANO"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
   
   .Range("I6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "VENDUTO"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
*!*	   .Range("I6").Select
*!*	   .Selection.HorizontalAlignment = xlCenter
*!*	   .Selection.Value = "%"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
   
   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlPortrait
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 65
      .PrintErrors = xlPrintErrorsDisplayed
   EndWith
              
ENDWITH

*** SCRIVO I DATI STATISTICI
WITH objExcel 
   
   _RANGE  = "C8"
   _VALORE = "ARTICOLI ITALIA"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C9"
   _VALORE = "ARTICOLI ESTERO"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C10"
   _VALORE = "TOTALE"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I8"
   _VALORE = STC_TUTTI_ARTICOLI_ITALIA 
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I9"
   _VALORE = STC_TUTTI_ARTICOLI_ESTERO 
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   _RANGE  = "I10"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-2]C:R[-1]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
   .Range("A1").Select
      
ENDWITH


*** GENERO IL GRAFICO A TORTA "QUOTA EXPORT"
WITH objExcel 
     
     *** CREO IL GRAFICO A TORTA ED IMPOSTO LE CELLE DI ORIGINE DATI
    .Charts.Add
    .ActiveChart.ChartType = xl3DPie
    .ActiveChart.SetSourceData(.Sheets("RIEPILOGO").Range("I8;I9"),xlColumns)
    .ActiveChart.SeriesCollection(1).XValues = "=(RIEPILOGO!R8C3,RIEPILOGO!R9C3)"
    .ActiveChart.Location(xlLocationAsObject,"RIEPILOGO")
    .ActiveChart.HasTitle = .F.
    
     *** IMPOSTO IL TITOLO DEL GRAFICO
    .ActiveChart.PlotArea.Select
    .ActiveChart.HasTitle = .T.
    .ActiveChart.ChartTitle.Characters.Text = "QUOTA EXPORT"

     *** IMPOSTO LA FORMATTAZIONE DEL GRAFICO
    .ActiveChart.HasLegend = .T.
    .ActiveChart.Legend.Select
    .Selection.Position = xlBottom
    .ActiveChart.ApplyDataLabels(NULL,.F.,.T.,.T.,.F.,.F.,.F.,.T.,.F.,NULL)
    .ActiveChart.PlotArea.Select
    .ActiveChart.PlotArea.Border.Weight = xlThin
    .ActiveChart.PlotArea.Border.LineStyle = xlNone
    .ActiveChart.PlotArea.Interior.ColorIndex = xlNone
    
     *** IMPOSTO LE DIMENSIONI E LA POSIZIONE DEL GRAFICO
    .ActiveChart.ChartArea.Select
    _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,"RIEPILOGO",""))
    
    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(-360)
    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementTop(183.75)
    
    .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(3).Left
    .ActiveSheet.Shapes(_NOME_GRAFICO).Top = 200

    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(0.65,0,0)
    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(0.75,0,0)

    .Sheets("RIEPILOGO").Range("A1").Select
ENDWITH


WITH objExcel 
    .Columns("C:C").ColumnWidth = 20
    .Columns("D:D").ColumnWidth = 12
    .Columns("E:E").ColumnWidth = 20
    .Columns("F:F").ColumnWidth = 12
    .Columns("G:G").ColumnWidth = 20
    .Columns("H:H").ColumnWidth = 12
    .Columns("I:I").ColumnWidth = 20
ENDWITH

RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_CONSUNTIVI_STC_ITALIA_ESTERO
************************************************************************
PARAMETER _NOME_SCH

_nome_scheda = ALLTRIM(_NOME_SCH)


*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
      
   .Range("C3:O3").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = _nome_scheda + " " + _annosel + " - Unità di misura: " + _unitmis
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO bordo_fine
         
   .Range("A5").Select
   .Selection.Value = "NAZIONE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("B5").Select
   .Selection.Value = "CLIENTE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C5:C5").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Merge
   .Selection.Value = "QTA' TOTALE"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("C6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "RICEVUTA"
   .Selection.Font.Bold = .t.
   DO bordo_fine
   
   .Range("D6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GEN"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("E6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "FEB"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("F6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("G6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "APR"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("H6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "MAG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("I6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "GIU"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("J6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "LUG"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("K6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "AGO"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("L6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "SET"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("M6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "OTT"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("N6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "NOV"
   .Selection.Font.Bold = .t.
    DO bordo_fine
   .Range("O6").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.Value = "DIC"
   .Selection.Font.Bold = .t.
    DO bordo_fine

   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlLandscape
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 60
      .PrintErrors = xlPrintErrorsDisplayed
   EndWith
              
ENDWITH

_N_RIGA = 8
_n_riga_ini = 8
_n_riga_fin = 8

*** LETTURA ARCHIVIO STATISTICO
x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
x_clie = "stc_codcli = stc_codcli"
x_unit = "stc_unimis = '" + _unitmis + "'"
x_ames = "substring(stc_data,1,4) = '" + _annosel + "'"
x_tipo = "stc_codart = stc_codart"
x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_tipo
cSql = "select STC_CODCLI,CLI_NAZION from U_STC_AN INNER JOIN U_CLI_AN ON U_STC_AN.STC_CODCLI = U_CLI_AN.CLI_CODCLI WHERE " + x_cond + " GROUP BY STC_CODCLI,CLI_NAZION"
IF !ExecCommand(cSql,"CU_STC_AN")
  return(.f.)
ENDIF
SELECT CU_STC_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   _n_riga_fin = _N_RIGA 
   
   SCATTER MEMVAR
   
   M.CLI_RAGSOC = ""
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "cli_codcli = '" + M.STC_CODCLI + "'"
   x_cond = x_soci + " and " + x_clie
   cSql = "select cli_codcli,cli_ragsoc from U_CLI_AN WHERE " + x_cond + " order by cli_codcli,cli_ragsoc"
   IF !ExecCommand(cSql,"CX_CLI_AN")
     return(.f.)
   ENDIF
   SELECT CX_CLI_AN
   GO TOP
   IF EOF()
   ELSE
      M.CLI_RAGSOC = CLI_RAGSOC
   ENDIF
   
   M.CLI_DESNAZ = ""
   x_codi = "codice = 'STA" + M.CLI_NAZION + "'"
   x_cond = x_codi
   cSql = "select * from PARA WHERE " + x_cond
   IF !ExecCommand(cSql,"CX_PARA")
     return(.f.)
   ENDIF
   SELECT CX_PARA
   GO TOP
   IF EOF()
   ELSE
      M.CLI_DESNAZ = DESCRI
   ENDIF
   
   *** VALORIZZAZIONE CAMPI CLIENTE
   WITH objExcel 
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(M.CLI_DESNAZ)
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
      _RANGE  = "B" + ALLTRIM(STR(_N_RIGA,10,0))
      *_VALORE = ALLTRIM(M.STC_CODCLI) + " - " + ALLTRIM(M.CLI_RAGSOC)
      _VALORE = SUBSTR(ALLTRIM(M.CLI_RAGSOC),1,15)  && ERASMO - 06/11/2008
      .Range(_RANGE).Select
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Interior.ColorIndex = 6
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
      
   ENDWITH
   
   *** VALORIZZAZIONE CAMPI DA ARCHIVIO STATISTICO
   FOR I=1 TO 12
      x_soci = "stc_codsoc = '" + PUB_CODSOC + "'"
      x_clie = "stc_codcli = '" + M.STC_CODCLI + "'"
      x_unit = "stc_unimis = '" + _unitmis + "'"
      x_ames = "stc_data = '" + _annosel + TRC(2,STR(I,2,0)) + "'"
      x_tipo = "stc_codart = stc_codart"
      x_cond = x_soci + " and " + x_clie + " and " + x_unit + " and " + x_ames + " and " + x_tipo 
      ***cSql = "select SUM(STC_QTAVEN) AS QUANTITA from U_STC_AN WHERE " + x_cond
      cSql = "select SUM(ORD_QTAMQ) AS QUANTITA from U_STC_AN WHERE " + x_cond      
      IF !ExecCommand(cSql,"CX_STC_AN")
        return(.f.)
      ENDIF
      SELECT CX_STC_AN
      _QUANTITA = IIF(ISNULL(QUANTITA),0,QUANTITA)
      DO CASE
         CASE I = 1
            _RANGE  = "D" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 2
            _RANGE  = "E" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 3
            _RANGE  = "F" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 4
            _RANGE  = "G" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 5
            _RANGE  = "H" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 6
            _RANGE  = "I" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 7
            _RANGE  = "J" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 8
            _RANGE  = "K" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 9
            _RANGE  = "L" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 10
            _RANGE  = "M" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 11
            _RANGE  = "N" + ALLTRIM(STR(_N_RIGA,10,0))
         CASE I = 12
            _RANGE  = "O" + ALLTRIM(STR(_N_RIGA,10,0))
      ENDCASE
      WITH objExcel 
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0.00"
         .Selection.Value = _QUANTITA
         DO bordi_lato
      ENDWITH
   ENDFOR
   
   _N_RIGA = _N_RIGA + 1
   
   SELECT CU_STC_AN
   SKIP +1
ENDDO

*** QTA' TOTALE RICEVUTA
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      _RANGE  = "C" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(RC[1]:RC[12])"
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR

*** TOTALI
_T_RIGA  = _n_riga_fin + 2
_RIF_SUM = _n_riga_fin - _n_riga_ini + 2
WITH objExcel 
   
   _RANGE  = "B" + ALLTRIM(STR(_T_RIGA,10,0))
   _VALORE = "Totale"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Bold = .t.
   
   _RANGE  = "C" + ALLTRIM(STR(_T_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0.00"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
   .Selection.Font.Bold = .t.
   _RANGE_TOTALE_QTA_STC = _RANGE
   
   FOR I = 1 TO 12
      _ANSI_CODE = ASC('C') + I
      _ANSI_CHAR = CHR(_ANSI_CODE)
      _RANGE  = _ANSI_CHAR + ALLTRIM(STR(_T_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0.00"
      .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
      .Selection.Font.Bold = .t.
   ENDFOR
   
   .Range("A1").Select

ENDWITH


*** SFONDO GRIGIO ALTERNATO
FOR I = _n_riga_ini TO _n_riga_fin 
   WITH objExcel 
      
      IF MOD(I,2) <> 0  && SOLO RIGHE PARI
         LOOP
      ENDIF
      
      _RANGE  = "C" + ALLTRIM(STR(I,10,0)) + ":O" + ALLTRIM(STR(I,10,0))
      .Range(_RANGE).Select
      .Selection.Interior.ColorIndex = 15
      .Selection.Interior.Pattern = xlSolid
      
      .Range("A1").Select
      
   ENDWITH
ENDFOR
    
WITH objExcel 
    .Columns("A:A").EntireColumn.AutoFit
    .Columns("B:B").EntireColumn.AutoFit
    .Columns("C:C").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("D:D").EntireColumn.AutoFit
    .Columns("E:E").EntireColumn.AutoFit
    .Columns("F:F").EntireColumn.AutoFit
    .Columns("G:G").EntireColumn.AutoFit
    .Columns("H:H").EntireColumn.AutoFit
    .Columns("I:I").EntireColumn.AutoFit
    .Columns("J:J").EntireColumn.AutoFit
    .Columns("K:K").EntireColumn.AutoFit
    .Columns("L:L").EntireColumn.AutoFit
    .Columns("M:M").EntireColumn.AutoFit
    .Columns("N:N").EntireColumn.AutoFit
    .Columns("O:O").EntireColumn.AutoFit
ENDWITH

_prima_scheda = .F.

WITH objExcel
   .Range(_RANGE_TOTALE_QTA_STC).Select
   _TOTALE_QTA_STC = .Selection.value
   .Range("A1").Select
ENDWITH

RETURN



************************************************************************
PROCEDURE GENERA_FILE_FATTURABILE
************************************************************************
*
* Tale procedura permette la creazione del file excel "Analisi dei Costi/Ricavi/Utili da Fatturabile Commessa"
*
* Sintassi:
* 
* DO GENERA_FILE_FATTURABILE WITH <nome cursore>,<tipo soggetto>,[<codice commessa>]
*
* Es:
* 
* DO GENERA_FILE_FATTURABILE WITH "CU_FATTURABILE_R","R","BA-01/2008/00003/ICT/SW "
*
* Genera un file excel per l'analisi Costi/Ricavi/Utili del fatturabile delle risorse umane (tipo soggetto R) per la commessa selezionata
*
*************************************************************************************************************************************

PARAMETERS _NOME_CUR,_TIPO_SOG,_COD_COMMESSA

_NPARA = PARAMETERS()

IF _NPARA < 3
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

_nomecur     = ALLTRIM(_NOME_CUR)
_tiposog     = ALLTRIM(_TIPO_SOG)
_codcommessa = ALLTRIM(_COD_COMMESSA)


WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()

xlCenter  = -4108
xlBottom  = -4107
xlContext = -5002

xlDiagonalDown = 5
xlDiagonalUp = 6
         
xlNone = -4142
xlContinuous = 1
xlThin = 2
xlMedium = -4138
xlAutomatic = -4105

xlEdgeLeft = 7
xlEdgeTop = 8
xlEdgeBottom = 9
xlEdgeRight = 10
*!*	xlInsideVertical = 11
*!*	xlInsideHorizontal = 12

xlSolid = 1

xlLandscape = 2
xlPortrait = 1
xlPrintNoComments = -4142
xlPaperA4 = 9
xlDownThenOver = 1
xlPrintErrorsDisplayed = 0
    
_prima_scheda = .t.

*!*	DO CASE

*!*	   CASE _tiposog = "R"
*!*	      
*!*	      *** CREAZIONE SCHEDA "COSTI"
*!*	      WAIT WINDOWS "Creazione foglio excel in corso (scheda COSTI) ..." nowait
*!*	      DO CREA_SCHEDA_FATTURABILE WITH "COSTI"
*!*	      
*!*	      *** CREAZIONE SCHEDA "RICAVI"
*!*	      WAIT WINDOWS "Creazione foglio excel in corso (scheda RICAVI) ..." nowait
*!*	      DO CREA_SCHEDA_FATTURABILE WITH "RICAVI"
*!*	      
*!*	      *** CREAZIONE SCHEDA "UTILI"
*!*	      WAIT WINDOWS "Creazione foglio excel in corso (scheda UTILI) ..." nowait
*!*	      DO CREA_SCHEDA_FATTURABILE WITH "UTILI"
*!*	   
*!*	   OTHERWISE
*!*	   
*!*	ENDCASE

_n_riga_riftot = 0  && ERASMO - 12/06/2009

*** CREAZIONE SCHEDA "COSTI"
WAIT WINDOWS "Creazione foglio excel in corso (scheda COSTI) ..." nowait
DO CREA_SCHEDA_FATTURABILE WITH "COSTI"

*** CREAZIONE SCHEDA "RICAVI"
WAIT WINDOWS "Creazione foglio excel in corso (scheda RICAVI) ..." nowait
DO CREA_SCHEDA_FATTURABILE WITH "RICAVI"

*** CREAZIONE SCHEDA "UTILI"
WAIT WINDOWS "Creazione foglio excel in corso (scheda UTILI) ..." nowait
DO CREA_SCHEDA_FATTURABILE WITH "UTILI"

**=> ERASMO - INIZIO 07/04/2009
*** CREAZIONE SCHEDA confronti "COSTI/RICAVI/UTILI"
WAIT WINDOWS "Creazione foglio excel in corso (scheda confronti COSTI/RICAVI/UTILI) ..." nowait
DO CREA_SCHEDA_FATTURABILE_CONFRONTI WITH "Confronti COSTI-RICAVI-UTILI"
**=> ERASMO - FINE 07/04/2009
      
objExcel.Sheets(1).Select
objExcel.Range("A1").Select
objExcel.Visible = .t.

RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_FATTURABILE
************************************************************************
PARAMETER _NOME_SCH

_nome_scheda = ALLTRIM(_NOME_SCH)

xlLocationAsObject = 2
xlLineMarkers = 65
xlColumnClustered = 51  && ERASMO - 07/04/2009
xlRows = 1
xlCategory = 1
xlPrimary = 1
xlValue = 2

_n_riga_ini = 0
_n_riga_fin = 0

*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   *.Range("A1:IV65536").Select
   .Cells.Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
   
   IF EMPTY(ALLTRIM(_codcommessa))
   ELSE
      .Range("A6:I6").Select
      .Selection.HorizontalAlignment = xlCenter
      .Selection.VerticalAlignment = xlBottom
      .Selection.WrapText = .F.
      .Selection.Orientation = 0
      .Selection.AddIndent = .F.
      .Selection.IndentLevel = 0
      .Selection.ShrinkToFit = .F.
      .Selection.ReadingOrder = xlContext
      .Selection.MergeCells = .F.
      .Selection.Merge
      *.Selection.Value = "COMMESSA COD. " + " " + _cod_commessa
      .Selection.Value = ALLTRIM(_cod_commessa)
      .Selection.Font.Size = 18
      .Selection.Font.Bold = .t.
      .Selection.Interior.ColorIndex = 6  && GIALLO
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
   ENDIF
   
   .Range("A7:I7").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = "Riepilogo " + _nome_scheda
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   DO CASE
      CASE _nome_scheda = "COSTI"
         .Selection.Interior.ColorIndex = 3  && ROSSO
      CASE _nome_scheda = "RICAVI"
         .Selection.Interior.ColorIndex = 43  && VERDE
      CASE _nome_scheda = "UTILI"
         .Selection.Interior.ColorIndex = 41  && BLU
   ENDCASE
   .Selection.Interior.Pattern = xlSolid
   DO bordo_fine
         
*!*	   .Range("A10").Select
*!*	   .Selection.HorizontalAlignment = xlCenter
*!*	   .Selection.Value = "MESE ATTIVITA'"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   .Selection.Font.ColorIndex = 3
*!*	   
*!*	   .Range("C10").Select
*!*	   *.Selection.HorizontalAlignment = xlCenter
*!*	   .Selection.Value = "RISORSA"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   .Selection.Font.ColorIndex = 3
*!*	   
*!*	   .Range("E10").Select
*!*	   *.Selection.HorizontalAlignment = xlCenter
*!*	   .Selection.Value = "TIPO ATTIVITA'"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   .Selection.Font.ColorIndex = 3
*!*	   
*!*	   .Range("I10").Select
*!*	   .Selection.HorizontalAlignment = xlCenter
*!*	   .Selection.Value = "VALORE"
*!*	   .Selection.Font.Size = 14
*!*	   .Selection.Font.Bold = .t.
*!*	   .Selection.Font.ColorIndex = 3
   
   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlPortrait
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 65
      .PrintErrors = xlPrintErrorsDisplayed
   ENDWITH
   
   _n_riga_ini = 11
   _n_riga_fin = _n_riga_ini
              
ENDWITH

_prima_scheda = .F.

*** CREO IL CURSORE DEI MESI
SELECT distinct aaaamm FROM &_nomecur ORDER BY AAAAMM INTO CURSOR CUR_MESI
SELECT CUR_MESI
GO TOP

*** SCRIVO LE INTESTAZIONI DEI MESI
WITH objExcel 
   
   SELECT CUR_MESI
   GO TOP
   _colonna = 2
   SCAN
   
      _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_n_riga_ini - 1,10,0))
      _VALORE = ALLTRIM(SUBSTR(AAAAMM,6,2)) + "/" + ALLTRIM(SUBSTR(AAAAMM,1,4))
      .Range(_RANGE).Select
      .Selection.HorizontalAlignment = xlCenter
      .Selection.NumberFormat = "[$-410]mmmm yyyy;@"
      .Selection.Value = _VALORE
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      .Selection.Font.ColorIndex = 3
      
      _colonna = _colonna + 1
   
   ENDSCAN
   
   **=> ERASMO - INIZIO 08/06/2009
   *** INSERISCO IL TOTALE MESI SU UN'ULTIMA COLONNA
   _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_n_riga_ini - 1,10,0))
   _VALORE = "Tot.mesi"
   .Range(_RANGE).Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   .Selection.Font.ColorIndex = 3
   **=> ERASMO - FINE 08/06/2009
              
ENDWITH

*** CREO IL CURSORE SOGGETTI COINVOLTI
*SELECT distinct codsogg,dessogg FROM &_nomecur ORDER BY codsogg INTO CURSOR CUR_SOGGETTI
SELECT distinct tiposogg,codsogg,dessogg FROM &_nomecur ORDER BY codsogg INTO CURSOR CUR_SOGGETTI  && ERASMO - 07/07/2009
SELECT CUR_SOGGETTI
GO TOP

*** SCRIVO I DATI STATISTICI
_N_RIGA = _n_riga_ini - 1
WITH objExcel 
   
   SELECT CUR_SOGGETTI
   GO TOP
   SCAN
      _N_RIGA = _N_RIGA + 1
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(CODSOGG) + " - " + ALLTRIM(DESSOGG)
      .Range(_RANGE).Select
      *.Selection.HorizontalAlignment = xlCenter
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      .Selection.Font.ColorIndex = 3
      
      _CODSOGG = CODSOGG
      _TIPOSOGG = TIPOSOGG  && ERASMO - 07/07/2009
      
      SELECT CUR_MESI
      GO TOP
      _colonna = 2
      SCAN
         
         _AAAAMM = AAAAMM
      
         _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
         _VALORE = NULL
         *SELECT AAAAMM,CODSOGG,DESSOGG,SUM(TOTCOSTO) AS SUM_TOTCOSTO,SUM(TOTRICAVO) AS SUM_TOTRICAVO,SUM(TOTUTILE) AS SUM_TOTUTILE FROM &_nomecur ;
         *WHERE AAAAMM = _AAAAMM .AND. CODSOGG = _CODSOGG GROUP BY AAAAMM,CODSOGG,DESSOGG INTO CURSOR TEMP_VALORI
         **=> ERASMO - INIZIO 07/07/2009
         SELECT AAAAMM,CODSOGG,DESSOGG,SUM(TOTCOSTO) AS SUM_TOTCOSTO,SUM(TOTRICAVO) AS SUM_TOTRICAVO,SUM(TOTUTILE) AS SUM_TOTUTILE FROM &_nomecur ;
         WHERE AAAAMM = _AAAAMM .AND. CODSOGG = _CODSOGG .AND. TIPOSOGG = _TIPOSOGG GROUP BY AAAAMM,CODSOGG,DESSOGG INTO CURSOR TEMP_VALORI
         **=> ERASMO - FINE 07/07/2009
         SELECT TEMP_VALORI
         GO TOP
         IF EOF()
         ELSE
            DO CASE
               CASE _nome_scheda = "COSTI"
                  _VALORE = SUM_TOTCOSTO
               CASE _nome_scheda = "RICAVI"
                  _VALORE = SUM_TOTRICAVO
               CASE _nome_scheda = "UTILI"
                  _VALORE = SUM_TOTUTILE
            ENDCASE 
         ENDIF
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0"
         .Selection.Value = _VALORE
         .Selection.Font.Size = 14
         .Selection.Font.Bold = .t.
         
         _colonna = _colonna + 1
      
      ENDSCAN
      
      **=> ERASMO - INIZIO 08/06/2009
      *** INSERISCO IL TOTALE MESI SU UN'ULTIMA COLONNA
      _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0"
      .ActiveCell.FormulaR1C1 = "=SUM(RC[-"+ALLTRIM(STR(_colonna - 2,10,0))+"]:RC[-1])"
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      **=> ERASMO - FINE 08/06/2009
      
   ENDSCAN
   
   _n_riga_fin = _N_RIGA 
   
   .Range("A1").Select
      
ENDWITH

IF _N_RIGA < _n_riga_ini 
   RETURN
ENDIF

**=> ERASMO - INIZIO 10/06/2009
*** INSERISCO IL TOTALE ATTIVITA' SU UN'ULTIMA RIGA
_N_RIGA = _N_RIGA + 2

WITH objExcel 

   _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
   _VALORE = "Totale"
   .Range(_RANGE).Select
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   .Selection.Font.ColorIndex = 3

   SELECT CUR_MESI
   GO TOP
   _colonna = 2
   SCAN
      
      _AAAAMM = AAAAMM
   
      _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0"
      .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_N_RIGA - _n_riga_ini,10,0))+"]C:R[-2]C)"
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      
      _colonna = _colonna + 1
      
   ENDSCAN
   
   _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
   .Range(_RANGE).Select
   .Selection.NumberFormat = "#,##0"
   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_N_RIGA - _n_riga_ini,10,0))+"]C:R[-2]C)"
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   
ENDWITH
_n_riga_riftot = _N_RIGA  && ERASMO - 12/06/2009
**=> ERASMO - FINE 10/06/2009
   
*!*	WITH objExcel 
*!*	    .Columns("A:A").ColumnWidth = 21
*!*	    .Columns("B:B").ColumnWidth = 12
*!*	    .Columns("C:C").ColumnWidth = 21
*!*	    .Columns("D:D").ColumnWidth = 21
*!*	    .Columns("E:E").ColumnWidth = 21
*!*	    .Columns("F:F").ColumnWidth = 12
*!*	    .Columns("G:G").ColumnWidth = 12
*!*	    .Columns("H:H").ColumnWidth = 12
*!*	    .Columns("I:I").ColumnWidth = 15
*!*	ENDWITH

WITH objExcel
   *.Columns("A").EntireColumn.AutoFit
   .Columns("A").ColumnWidth = 37  && ERASMO - 05/06/2009
   SELECT CUR_MESI
   GO TOP
   _colonna = 2
   SCAN
      _RANGE = ALLTRIM(n2c(_colonna))
      .Columns(_RANGE).EntireColumn.AutoFit
      _colonna = _colonna + 1
   ENDSCAN
   **=> ERASMO - INIZIO 08/06/2009
   *** EFFETTUO L'AUTOFIT ANCHE PER IL TOTALE MESI
   _RANGE = ALLTRIM(n2c(_colonna))
   .Columns(_RANGE).EntireColumn.AutoFit
   **=> ERASMO - FINE 08/06/2009
   .Range("A1").Select
ENDWITH

*** GENERO IL GRAFICO
SELECT CUR_MESI
GO TOP
IF EOF()
   RETURN
ENDIF
_nmax_colonna = RECCOUNT() + 1
_RANGE = "A" + ALLTRIM(STR(_n_riga_ini - 1,10,0)) + ":" + ALLTRIM(n2c(_nmax_colonna)) + ALLTRIM(STR(_n_riga_fin,10,0))
WITH objExcel 
   _nome_foglio = ALLTRIM(.ActiveSheet.Name)
   *** CREO IL GRAFICO A LINEE ED IMPOSTO IL RANGE DI CELLE PER L'ORIGINE DATI
   .Range(_RANGE).Select
   .Charts.Add
   *.ActiveChart.ChartType = xlLineMarkers
   .ActiveChart.ChartType = xlColumnClustered  && ERASMO - 07/04/2009
   .ActiveChart.SetSourceData(.Sheets(_nome_foglio).Range(_RANGE),xlRows)
   .ActiveChart.Location(xlLocationAsObject,_nome_foglio)
   *** IMPOSTO IL TITOLO DEL GRAFICO
   .ActiveChart.PlotArea.Select
   .ActiveChart.HasTitle = .T.
   .ActiveChart.ChartTitle.Characters.Text = "Grafico " + _nome_scheda
   *** IMPOSTO IL TITOLO DELLE SERIE
   .ActiveChart.Axes(xlCategory, xlPrimary).HasTitle = .T.
   .ActiveChart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "MESE"
   .ActiveChart.Axes(xlValue, xlPrimary).HasTitle = .T.
   .ActiveChart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = IIF(_nome_scheda = "COSTI","COSTO €",IIF(_nome_scheda = "RICAVI","RICAVO €",IIF(_nome_scheda = "UTILI","UTILE €","")))
   *.ActiveChart.HasDataTable = False
   *** IMPOSTO LA POSIZIONE DEL GRAFICO
   .ActiveChart.ChartArea.Select
   _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,_nome_foglio,""))
   *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(-360)
   *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementTop(183.75)
   .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(1).Left
   .ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(25)
   *.ActiveSheet.Shapes(_NOME_GRAFICO).Top = 200
   *.ActiveSheet.Shapes(_NOME_GRAFICO).Top = .ActiveSheet.Rows(_n_riga_fin+3).Top
   .ActiveSheet.Shapes(_NOME_GRAFICO).Top = .ActiveSheet.Rows(_n_riga_fin+5).Top  && ERASMO - 10/06/2009
   *** IMPOSTO LE DIMENSIONI DEL GRAFICO
   .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(1.23,0,0)
   .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(1.10,0,0)
   *** IMPOSTO IL FORMATO DELL'ASSE DELLE CATEGORIE
   .ActiveChart.Axes(xlCategory).TickLabels.NumberFormat = "[$-410]mmmm yyyy;@"
    
    .Sheets(_nome_foglio).Range("A1").Select    
ENDWITH

*!*	*** GENERO IL GRAFICO A TORTA
*!*	WITH objExcel 
*!*	     
*!*		_nome_foglio = ALLTRIM(.ActiveSheet.Name)
*!*		_elenco_range = ""
*!*		_elenco_serie = ""
*!*		FOR I = _n_riga_ini TO _n_riga_fin
*!*			IF I = _n_riga_ini
*!*				_elenco_range = "I" + ALLTRIM(STR(I,10,0))
*!*				_elenco_serie = "=(" + _nome_foglio + "!R" + ALLTRIM(STR(I,10,0)) + "C3"
*!*			ELSE
*!*				_elenco_range = _elenco_range + ";I" + ALLTRIM(STR(I,10,0))
*!*				_elenco_serie = _elenco_serie + "," + _nome_foglio + "!R" + ALLTRIM(STR(I,10,0)) + "C3"
*!*			ENDIF	
*!*		ENDFOR
*!*		_elenco_serie = _elenco_serie + ")"

*!*	     *** CREO IL GRAFICO A TORTA ED IMPOSTO LE CELLE DI ORIGINE DATI
*!*	    .Charts.Add
*!*	    .ActiveChart.ChartType = xl3DPie
*!*	    .ActiveChart.SetSourceData(.Sheets(_nome_foglio).Range(_elenco_range),xlColumns)
*!*	    .ActiveChart.SeriesCollection(1).XValues = _elenco_serie
*!*	    .ActiveChart.Location(xlLocationAsObject,_nome_foglio)
*!*	    .ActiveChart.HasTitle = .F.
*!*	    
*!*	     *** IMPOSTO IL TITOLO DEL GRAFICO
*!*	    .ActiveChart.PlotArea.Select
*!*	    .ActiveChart.HasTitle = .T.
*!*	    .ActiveChart.ChartTitle.Characters.Text = "Grafico " + _nome_scheda

*!*	     *** IMPOSTO LA FORMATTAZIONE DEL GRAFICO
*!*	    .ActiveChart.HasLegend = .T.
*!*	    .ActiveChart.Legend.Select
*!*	    .Selection.Position = xlBottom
*!*	    .ActiveChart.ApplyDataLabels(NULL,.F.,.T.,.T.,.F.,.F.,.F.,.T.,.F.,NULL)
*!*	    .ActiveChart.PlotArea.Select
*!*	    .ActiveChart.PlotArea.Border.Weight = xlThin
*!*	    .ActiveChart.PlotArea.Border.LineStyle = xlNone
*!*	    .ActiveChart.PlotArea.Interior.ColorIndex = xlNone
*!*	    
*!*	     *** IMPOSTO LE DIMENSIONI E LA POSIZIONE DEL GRAFICO
*!*	    .ActiveChart.ChartArea.Select
*!*	    _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,_nome_foglio,""))
*!*	    
*!*	    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(-360)
*!*	    *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementTop(183.75)
*!*	    
*!*	    .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(3).Left
*!*	    *.ActiveSheet.Shapes(_NOME_GRAFICO).Top = 200
*!*	    .ActiveSheet.Shapes(_NOME_GRAFICO).Top = .ActiveSheet.Rows(_n_riga_fin+3).Top

*!*	    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(0.55,0,0)
*!*	    .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(0.75,0,0)

*!*	    .Sheets(_nome_foglio).Range("A1").Select
*!*	ENDWITH


RETURN


************************************************************************
PROCEDURE CREA_SCHEDA_FATTURABILE_CONFRONTI
************************************************************************
PARAMETER _NOME_SCH

_nome_scheda = ALLTRIM(_NOME_SCH)

xlLocationAsObject = 2
xlLineMarkers = 65
xlColumnClustered = 51
xlRows = 1
xlCategory = 1
xlPrimary = 1
xlValue = 2

_n_riga_ini = 0
_n_riga_fin = 0


*** PREPARO LE VARIE INTESTAZIONI
WITH objExcel 

   last_strNome = ""
   .Range("A1").Select
   IF _prima_scheda
   ELSE
      last_strNome = .ActiveSheet.Name
      .Sheets.Add
   ENDIF
   strNome = .ActiveSheet.Name
   .Sheets(strNome).Select
   .Sheets(strNome).Name = _nome_scheda
         
   IF _prima_scheda
   ELSE
      strNome = .ActiveSheet.Name
      .Sheets(strNome).Select
      .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
   ENDIF
         
   *.Range("A1:IV65536").Select
   .Cells.Select
   .Selection.Font.Size = 12
   .Selection.Font.Name = "Graphite Light"
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 28 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
   .ActiveSheet.PageSetup.Orientation = xlLandscape
   
   IF EMPTY(ALLTRIM(_codcommessa))
   ELSE
      .Range("A6:I6").Select
      .Selection.HorizontalAlignment = xlCenter
      .Selection.VerticalAlignment = xlBottom
      .Selection.WrapText = .F.
      .Selection.Orientation = 0
      .Selection.AddIndent = .F.
      .Selection.IndentLevel = 0
      .Selection.ShrinkToFit = .F.
      .Selection.ReadingOrder = xlContext
      .Selection.MergeCells = .F.
      .Selection.Merge
      *.Selection.Value = "COMMESSA COD. " + " " + _cod_commessa
      .Selection.Value = ALLTRIM(_cod_commessa)
      .Selection.Font.Size = 18
      .Selection.Font.Bold = .t.
      .Selection.Interior.ColorIndex = 6  && GIALLO
      .Selection.Interior.Pattern = xlSolid
      DO bordo_fine
   ENDIF
   
   .Range("A7:I7").Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.VerticalAlignment = xlBottom
   .Selection.WrapText = .F.
   .Selection.Orientation = 0
   .Selection.AddIndent = .F.
   .Selection.IndentLevel = 0
   .Selection.ShrinkToFit = .F.
   .Selection.ReadingOrder = xlContext
   .Selection.MergeCells = .F.
   .Selection.Merge
   .Selection.Value = "Riepilogo " + _nome_scheda
   .Selection.Font.Size = 18
   .Selection.Font.Bold = .t.
   .Selection.Interior.ColorIndex = 34  && TURCHESE
   .Selection.Interior.Pattern = xlSolid
   DO bordo_fine
   
   .ActiveWindow.Zoom = 75
    
   With .ActiveSheet.PageSetup
       .PrintTitleRows = ""
       .PrintTitleColumns = ""
   EndWith
   .ActiveSheet.PageSetup.PrintArea = ""
   With .ActiveSheet.PageSetup
      .LeftHeader = ""
      .CenterHeader = ""
      .RightHeader = "Data: &D" + " Ora: &T"
      .LeftFooter = "File: &F"
      .CenterFooter = "Scheda: &A"
      .RightFooter = "Pagina &P"
*!*	      .LeftMargin = objExcel.InchesToPoints(0.787401575)
*!*	      .RightMargin = objExcel.InchesToPoints(0.787401575)
      .LeftMargin = objExcel.InchesToPoints(0.17)
      .RightMargin = objExcel.InchesToPoints(0.17)
      .TopMargin = objExcel.InchesToPoints(0.984251969)
      .BottomMargin = objExcel.InchesToPoints(0.984251969)
      .HeaderMargin = objExcel.InchesToPoints(0.5)
      .FooterMargin = objExcel.InchesToPoints(0.5)
      .PrintHeadings = .F.
      .PrintGridlines = .F.
      .PrintComments = xlPrintNoComments
      *.PrintQuality = 600
      .CenterHorizontally = .F.
      .CenterVertically = .F.
      .Orientation = xlPortrait
      .Draft = .F.
      .PaperSize = xlPaperA4
      .FirstPageNumber = xlAutomatic
      .Order = xlDownThenOver
      .BlackAndWhite = .F.
      .Zoom = 65
      .PrintErrors = xlPrintErrorsDisplayed
   ENDWITH
   
   _n_riga_ini = 11
   _n_riga_fin = _n_riga_ini
              
ENDWITH

_prima_scheda = .F.

*** CREO IL CURSORE DEI MESI
SELECT distinct aaaamm FROM &_nomecur ORDER BY AAAAMM INTO CURSOR CUR_MESI
SELECT CUR_MESI
GO TOP

*** SCRIVO LE INTESTAZIONI DEI MESI
WITH objExcel 
   
   SELECT CUR_MESI
   GO TOP
   _colonna = 2
   SCAN
   
      _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_n_riga_ini - 1,10,0))
      _VALORE = ALLTRIM(SUBSTR(AAAAMM,6,2)) + "/" + ALLTRIM(SUBSTR(AAAAMM,1,4))
      .Range(_RANGE).Select
      .Selection.HorizontalAlignment = xlCenter
      .Selection.NumberFormat = "[$-410]mmmm yyyy;@"
      .Selection.Value = _VALORE
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      .Selection.Font.ColorIndex = 3
      
      _colonna = _colonna + 1
   
   ENDSCAN
   
   **=> ERASMO - INIZIO 08/06/2009
   *** INSERISCO IL TOTALE MESI SU UN'ULTIMA COLONNA
   _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_n_riga_ini - 1,10,0))
   _VALORE = "Tot.mesi"
   .Range(_RANGE).Select
   .Selection.HorizontalAlignment = xlCenter
   .Selection.NumberFormat = "@"
   .Selection.Value = _VALORE
   .Selection.Font.Size = 14
   .Selection.Font.Bold = .t.
   .Selection.Font.ColorIndex = 3
   **=> ERASMO - FINE 08/06/2009
              
ENDWITH

*** CREO IL CURSORE PER CONFRONTI COSTI/RICAVI/UTILI
CREATE CURSOR CUR_COSRICUTI (ORDINE N(1,0), TIPO C(1), DESCRIZIONE C(30))
INDEX ON ORDINE TAG I_ORDINE
SELECT CUR_COSRICUTI
APPEND BLANK
REPLACE ORDINE WITH 1
REPLACE TIPO WITH "C"
REPLACE DESCRIZIONE WITH "Totale COSTO"
APPEND BLANK
REPLACE ORDINE WITH 2
REPLACE TIPO WITH "R"
REPLACE DESCRIZIONE WITH "Totale RICAVO"
APPEND BLANK
REPLACE ORDINE WITH 3
REPLACE TIPO WITH "U"
REPLACE DESCRIZIONE WITH "Totale UTILE"

SET ORDER TO I_ORDINE
GO TOP

*** SCRIVO I DATI STATISTICI
_N_RIGA = _n_riga_ini - 1
WITH objExcel 
   
   SELECT CUR_COSRICUTI
   GO TOP
   SCAN
      _N_RIGA = _N_RIGA + 1
      
      _RANGE  = "A" + ALLTRIM(STR(_N_RIGA,10,0))
      _VALORE = ALLTRIM(DESCRIZIONE)
      .Range(_RANGE).Select
      *.Selection.HorizontalAlignment = xlCenter
      .Selection.NumberFormat = "@"
      .Selection.Value = _VALORE
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      .Selection.Font.ColorIndex = 3
      
      _TIPO = TIPO
      
      SELECT CUR_MESI
      GO TOP
      _colonna = 2
      SCAN
         
*!*	         _AAAAMM = AAAAMM
*!*	      
*!*	         _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
*!*	         _VALORE = NULL
*!*	         SELECT AAAAMM,SUM(TOTCOSTO) AS SUM_TOTCOSTO,SUM(TOTRICAVO) AS SUM_TOTRICAVO,SUM(TOTUTILE) AS SUM_TOTUTILE FROM &_nomecur ;
*!*	         WHERE AAAAMM = _AAAAMM GROUP BY AAAAMM INTO CURSOR TEMP_VALORI
*!*	         SELECT TEMP_VALORI
*!*	         GO TOP
*!*	         IF EOF()
*!*	         ELSE
*!*	            DO CASE
*!*	               CASE _TIPO = "C"
*!*	                  _VALORE = SUM_TOTCOSTO
*!*	               CASE _TIPO = "R"
*!*	                  _VALORE = SUM_TOTRICAVO
*!*	               CASE _TIPO = "U"
*!*	                  _VALORE = SUM_TOTUTILE
*!*	            ENDCASE 
*!*	         ENDIF
*!*	         .Range(_RANGE).Select
*!*	         .Selection.NumberFormat = "#,##0"
*!*	         .Selection.Value = _VALORE
*!*	         .Selection.Font.Size = 14
*!*	         .Selection.Font.Bold = .t.        
         
         **=> ERASMO - INIZIO 12/06/2009
         _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
         .Range(_RANGE).Select
         .Selection.NumberFormat = "#,##0"
         DO CASE
            CASE _TIPO = "C"
               .ActiveCell.FormulaR1C1 = "=COSTI!R[" + ALLTRIM(STR(_n_riga_riftot - _N_RIGA,10,0)) + "]C"
            CASE _TIPO = "R"
               .ActiveCell.FormulaR1C1 = "=RICAVI!R[" + ALLTRIM(STR(_n_riga_riftot - _N_RIGA,10,0)) + "]C"
            CASE _TIPO = "U"
               .ActiveCell.FormulaR1C1 = "=UTILI!R[" + ALLTRIM(STR(_n_riga_riftot - _N_RIGA,10,0)) + "]C"
         ENDCASE
         .Selection.Font.Size = 14
         .Selection.Font.Bold = .t.
         **=> ERASMO - FINE 12/06/2009
         
         _colonna = _colonna + 1
      
      ENDSCAN
      
      **=> ERASMO - INIZIO 08/06/2009
      *** INSERISCO IL TOTALE MESI SU UN'ULTIMA COLONNA
      _RANGE = ALLTRIM(n2c(_colonna)) + ALLTRIM(STR(_N_RIGA,10,0))
      .Range(_RANGE).Select
      .Selection.NumberFormat = "#,##0"
      .ActiveCell.FormulaR1C1 = "=SUM(RC[-"+ALLTRIM(STR(_colonna - 2,10,0))+"]:RC[-1])"
      .Selection.Font.Size = 14
      .Selection.Font.Bold = .t.
      **=> ERASMO - FINE 08/06/2009
      
   ENDSCAN
   
   _n_riga_fin = _N_RIGA 
   
   .Range("A1").Select
      
ENDWITH

IF _N_RIGA < _n_riga_ini 
   RETURN
ENDIF

*!*	WITH objExcel 
*!*	    .Columns("A:A").ColumnWidth = 21
*!*	    .Columns("B:B").ColumnWidth = 12
*!*	    .Columns("C:C").ColumnWidth = 21
*!*	    .Columns("D:D").ColumnWidth = 21
*!*	    .Columns("E:E").ColumnWidth = 21
*!*	    .Columns("F:F").ColumnWidth = 12
*!*	    .Columns("G:G").ColumnWidth = 12
*!*	    .Columns("H:H").ColumnWidth = 12
*!*	    .Columns("I:I").ColumnWidth = 15
*!*	ENDWITH

WITH objExcel
   *.Columns("A").EntireColumn.AutoFit
   .Columns("A").ColumnWidth = 37
   SELECT CUR_MESI
   GO TOP
   _colonna = 2
   SCAN
      _RANGE = ALLTRIM(n2c(_colonna))
      .Columns(_RANGE).EntireColumn.AutoFit
      _colonna = _colonna + 1
   ENDSCAN
   **=> ERASMO - INIZIO 08/06/2009
   *** EFFETTUO L'AUTOFIT ANCHE PER IL TOTALE MESI
   _RANGE = ALLTRIM(n2c(_colonna))
   .Columns(_RANGE).EntireColumn.AutoFit
   **=> ERASMO - FINE 08/06/2009
   .Range("A1").Select
ENDWITH

*** GENERO IL GRAFICO
SELECT CUR_MESI
GO TOP
IF EOF()
   RETURN
ENDIF
_nmax_colonna = RECCOUNT() + 1
_RANGE = "A" + ALLTRIM(STR(_n_riga_ini - 1,10,0)) + ":" + ALLTRIM(n2c(_nmax_colonna)) + ALLTRIM(STR(_n_riga_fin,10,0))
WITH objExcel 
   _nome_foglio = ALLTRIM(.ActiveSheet.Name)
   *** CREO IL GRAFICO A LINEE ED IMPOSTO IL RANGE DI CELLE PER L'ORIGINE DATI
   .Range(_RANGE).Select
   .Charts.Add
   *.ActiveChart.ChartType = xlLineMarkers
   .ActiveChart.ChartType = xlColumnClustered  && ERASMO - 07/04/2009
   .ActiveChart.SetSourceData(.Sheets(_nome_foglio).Range(_RANGE),xlRows)
   .ActiveChart.Location(xlLocationAsObject,_nome_foglio)
   *** IMPOSTO IL TITOLO DEL GRAFICO
   .ActiveChart.PlotArea.Select
   .ActiveChart.HasTitle = .T.
   .ActiveChart.ChartTitle.Characters.Text = "Grafico " + _nome_scheda
   *** IMPOSTO IL TITOLO DELLE SERIE
   .ActiveChart.Axes(xlCategory, xlPrimary).HasTitle = .T.
   .ActiveChart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "MESE"
   .ActiveChart.Axes(xlValue, xlPrimary).HasTitle = .T.
   .ActiveChart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "€"
   *.ActiveChart.HasDataTable = False
   *** IMPOSTO LA POSIZIONE DEL GRAFICO
   .ActiveChart.ChartArea.Select
   _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,_nome_foglio,""))
   *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(-360)
   *.ActiveSheet.Shapes(_NOME_GRAFICO).IncrementTop(183.75)
   .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(1).Left
   .ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(25)
   *.ActiveSheet.Shapes(_NOME_GRAFICO).Top = 200
   .ActiveSheet.Shapes(_NOME_GRAFICO).Top = .ActiveSheet.Rows(_n_riga_fin+3).Top
   *** IMPOSTO LE DIMENSIONI DEL GRAFICO
   .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(1.23,0,0)
   .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(1.10,0,0)
   *** IMPOSTO IL FORMATO DELL'ASSE DELLE CATEGORIE
   .ActiveChart.Axes(xlCategory).TickLabels.NumberFormat = "[$-410]mmmm yyyy;@"
    
    .Sheets(_nome_foglio).Range("A1").Select    
ENDWITH


RETURN


************************************************************************
PROCEDURE REPORT_TO_XLS								 && ERASMO - 08/2010
************************************************************************
*
* Questa procedura permette la creazione di un file excel in base al
* cursore e al file di report passato nei parametri, riportando i soli
* campi contenuti nel report di stampa
*
*
* Sintassi:
* 
* DO REPORT_TO_XLS WITH <cursore o tabella>,<nome_report>
*
* <cursore o tabella>           : 	é la tabella/cursore che si vuole 
*									rappresentare nel file excel
* <nome_report>                 : 	è il file di report sul quale deve 
*									basarsi la visualizzazione o meno 
*									dei campi in tabella
*
************************************************************************
                                                                                
LPARAMETER _NOME_CURSORE,_NOME_FILE_REPORT,_RITORNA_SOLO_NOME_REPORT,_NON_FORMATTATO

IF PCOUNT() < 2
	RETURN .F.
ENDIF

IF PCOUNT() >= 3
ELSE
	_RITORNA_SOLO_NOME_REPORT = .F.
ENDIF

**=> ERASMO - INIZIO 25/10/2017
IF PCOUNT() >= 4
ELSE
	_NON_FORMATTATO = .F.
ENDIF
**=> ERASMO - FINE 25/10/2017

_OLD_SELECT = SELECT()

_NOME_CURSORE = ALLTRIM(_NOME_CURSORE)
_NOME_FILE_REPORT = ALLTRIM(_NOME_FILE_REPORT)

_NOME_COMPLETO_REPORT = "REPORT\" + _NOME_FILE_REPORT
IF FILE(_NOME_COMPLETO_REPORT)
ELSE
*!*		SELECT(_OLD_SELECT)
*!*		RETURN .F.
	**=> ERASMO - INIZIO 16/12/2021
	_NOME_COMPLETO_REPORT = _NOME_FILE_REPORT
	IF FILE(_NOME_COMPLETO_REPORT)
	ELSE
		SELECT(_OLD_SELECT)
		RETURN .F.
	ENDIF
	**=> ERASMO - FINE 16/12/2021
ENDIF

IF !USED(_NOME_COMPLETO_REPORT)
   USE &_NOME_COMPLETO_REPORT ALIAS MY_FRX_CURSOR IN 0 AGAIN
ENDIF

*!*	_HEADER_BAND_INITIAL_POSITION = 0
*!*	_GENERIC_BAND_HEIGHT = 2083.333  && ALTEZZA STANDARD DELLA PRIMA BANDA
*!*	_DETAIL_BAND_FINAL_POSITION = 0

*!*	SELECT MY_FRX_CURSOR
*!*	SET FILTER TO
*!*	SET ORDER TO
*!*	GO TOP

*!*	*** ALTEZZA HEADER BAND
*!*	LOCATE FOR Objtype = 9 AND Objcode = 1
*!*	IF !EOF()
*!*		_HEADER_BAND_INITIAL_POSITION = Height
*!*	ENDIF
*!*	GO TOP

*!*	*** ALTEZZE DA SOMMARE DELLE BANDE DI RAGGRUPPAMENTO
*!*	SCAN
*!*		IF Objtype = 9 AND Objcode = 3
*!*			_GENERIC_BAND_HEIGHT = _GENERIC_BAND_HEIGHT + Height + 2083.333
*!*		ENDIF
*!*	ENDSCAN
*!*	GO TOP

*!*	*** ALTEZZA DETAIL BAND
*!*	LOCATE FOR Objtype = 9 AND Objcode = 4
*!*	IF !EOF()
*!*		_DETAIL_BAND_FINAL_POSITION = Height + _GENERIC_BAND_HEIGHT + _HEADER_BAND_INITIAL_POSITION
*!*	ENDIF
*!*	GO TOP

**=> ERASMO - INIZIO 19/01/2018 - RIDEFINIZIONE POSIZIONI BANDE
***************************************************************
*!*	  When OBJTYPE = 9 (a band), the following values are used:
*!*	 
*!*	  0 = Title 
*!*	  1 = Page header
*!*	  2 = Column header
*!*	  3 = Group header
*!*	  4 = Detail
*!*	  5 = Group footer
*!*	  6 = Column footer
*!*	  7 = Page footer
*!*	  8 = Summary
***************************************************************

_HEADER_BAND_INITIAL_POSITION = 0
_DETAIL_BAND_INITIAL_POSITION = 0
_DETAIL_BAND_FINAL_POSITION = 0

SELECT MY_FRX_CURSOR
SET FILTER TO
SET ORDER TO
GO TOP
SCAN
	IF Objtype <> 9
		LOOP
	ENDIF
	
	IF Objcode = 0  && Title
		_HEADER_BAND_INITIAL_POSITION = _HEADER_BAND_INITIAL_POSITION + Height + 2083.333
		_DETAIL_BAND_INITIAL_POSITION = _DETAIL_BAND_INITIAL_POSITION + Height + 2083.333
	ENDIF

	IF Objcode = 1  && Page header
		_HEADER_BAND_INITIAL_POSITION = _HEADER_BAND_INITIAL_POSITION + Height + 2083.333
		_DETAIL_BAND_INITIAL_POSITION = _DETAIL_BAND_INITIAL_POSITION + Height + 2083.333
	ENDIF
	
	IF Objcode = 2  && Column header
		_DETAIL_BAND_INITIAL_POSITION = _DETAIL_BAND_INITIAL_POSITION + Height + 2083.333
	ENDIF
	
	IF Objcode = 3  && Group header
		_DETAIL_BAND_INITIAL_POSITION = _DETAIL_BAND_INITIAL_POSITION + Height + 2083.333
	ENDIF
	
	IF Objcode = 4  && Detail
		_DETAIL_BAND_FINAL_POSITION = _DETAIL_BAND_INITIAL_POSITION + Height
	ENDIF
ENDSCAN
**=> ERASMO - FINE 19/01/2018

IF _HEADER_BAND_INITIAL_POSITION = 0 .OR. _DETAIL_BAND_FINAL_POSITION = 0 .OR. (_DETAIL_BAND_FINAL_POSITION < _HEADER_BAND_INITIAL_POSITION)
	SELECT MY_FRX_CURSOR
	USE
	SELECT(_OLD_SELECT)
	RETURN .F.
ENDIF

CREATE CURSOR ELENCO_CAMPI (NOME_CAMPO C(100), EXPR_CAMPO C(254), VPOS N(20,3), HPOS N(20,3))
INDEX ON STR(HPOS,20,3)+STR(VPOS,20,3) TAG I_POSIZ
INDEX ON NOME_CAMPO TAG I_NOME  && ERASMO - 10/02/2014

CREATE CURSOR ELENCO_TITOLI (EXPR_CAMPO C(254), VPOS N(20,3), HPOS N(20,3))
INDEX ON STR(VPOS,20,3)+STR(HPOS,20,3) TAG I_POSIZ

*!*	SELECT MY_FRX_CURSOR
*!*	GO TOP
*!*	SCAN
*!*		
*!*		*** SOLO LE CASELLE DI TESTO
*!*		IF Objtype = 8 .AND. Objcode = 0
*!*		ELSE
*!*			LOOP
*!*		ENDIF
*!*		
*!*		*** SOLO QUELLE CONTENUTE NELLA DETAIL BAND
*!*		IF VPos > _HEADER_BAND_INITIAL_POSITION .AND. VPos <= _DETAIL_BAND_FINAL_POSITION 
*!*		ELSE
*!*			LOOP
*!*		ENDIF
*!*		_FIELD_NAME = UPPER(ALLTRIM(Expr))
*!*		_VPOSIZ = Vpos
*!*		_HPOSIZ = Hpos
*!*		
*!*		*** VERIFICO CHE IL CAMPO SIA CONTENUTO ALL'INTERNO DEL CURSORE CHE POPOLA IL REPORT
*!*		_OK_FIELD = .F.
*!*		nFieldNumber = 1
*!*		_STRING = ""
*!*		SELECT &_NOME_CURSORE
*!*		GO TOP
*!*		DO WHILE .T.
*!*			_STRING = UPPER(ALLTRIM(FIELDS(nFieldNumber,_NOME_CURSORE)))
*!*			IF EMPTY(_STRING)
*!*				EXIT
*!*			ENDIF
*!*			IF _STRING $ _FIELD_NAME
*!*				_OK_FIELD = .T.
*!*				EXIT
*!*			ENDIF
*!*			nFieldNumber = nFieldNumber + 1
*!*		ENDDO
*!*		IF _OK_FIELD
*!*			SELECT ELENCO_CAMPI 
*!*			APPEND BLANK
*!*			REPLACE NOME_CAMPO WITH _STRING
*!*			REPLACE EXPR_CAMPO WITH _FIELD_NAME
*!*			REPLACE VPOS WITH _VPOSIZ 
*!*			REPLACE HPOS WITH _HPOSIZ 
*!*		ENDIF
*!*		
*!*	ENDSCAN

**=> ERASMO - INIZIO 10/02/2014
SELECT MY_FRX_CURSOR
GO TOP
SCAN
	
	*** SOLO LE CASELLE DI TESTO
	IF Objtype = 8 .AND. Objcode = 0
	ELSE
		LOOP
	ENDIF
	
	*** SOLO QUELLE CONTENUTE NELLA DETAIL BAND
	*IF VPos > _HEADER_BAND_INITIAL_POSITION .AND. VPos <= _DETAIL_BAND_FINAL_POSITION 
	IF (VPos >= _HEADER_BAND_INITIAL_POSITION AND VPos <= _DETAIL_BAND_FINAL_POSITION) OR ((VPos + Height) >= _HEADER_BAND_INITIAL_POSITION AND (VPos + Height) <= _DETAIL_BAND_FINAL_POSITION)  && ERASMO - 19/01/2018
	ELSE
		LOOP
	ENDIF
	_FIELD_EXPR = UPPER(ALLTRIM(Expr))
	_VPOSIZ = Vpos
	_HPOSIZ = Hpos
	
	*** VERIFICO CHE IL CAMPO SIA CONTENUTO ALL'INTERNO DEL CURSORE CHE POPOLA IL REPORT
	_OK_FIELD = .F.
	nFieldNumber = 1
	_STRING_NOME_CAMPO = ""
	
	SELECT &_NOME_CURSORE
	GO TOP
	DO WHILE .T.
		_STRING_NOME_CAMPO = UPPER(ALLTRIM(FIELDS(nFieldNumber,_NOME_CURSORE)))
		IF EMPTY(_STRING_NOME_CAMPO)
			EXIT
		ENDIF	
		IF _STRING_NOME_CAMPO $ _FIELD_EXPR
			LOCAL _nOccurs
			FOR _nOccurs = 1 TO OCCURS(_STRING_NOME_CAMPO,_FIELD_EXPR)
				_cCaratterePrec = SUBSTR(_FIELD_EXPR,AT(_STRING_NOME_CAMPO,_FIELD_EXPR,_nOccurs) - 1,1)
				_cCarattereSucc = SUBSTR(_FIELD_EXPR,AT(_STRING_NOME_CAMPO,_FIELD_EXPR,_nOccurs) + LEN(_STRING_NOME_CAMPO),1)
				*** SE CARATTERE APPENA PRECEDENTE O QUELLO APPENA SUCCESSIVO ESISTE E SONO LETTERE COMPRESE FRA 'A' E 'Z' OPPURE '_', ALLORA IL CAMPO E' UNA SEMPLICE SOTTOSTRINGA, QUINDI DA NON INSERIRE NELLA LISTA DEI CAMPI
				IF ((ASC(_cCaratterePrec) >= ASC('A') AND ASC(_cCaratterePrec) <= ASC('Z')) OR ASC(_cCaratterePrec) = ASC('_')) OR ;
					((ASC(_cCarattereSucc) >= ASC('A') AND ASC(_cCarattereSucc) <= ASC('Z')) OR ASC(_cCarattereSucc) = ASC('_'))
				ELSE
					SELECT ELENCO_CAMPI
					SET ORDER TO I_NOME
					GO TOP
					SEEK _STRING_NOME_CAMPO
					IF !FOUND()
						APPEND BLANK
						REPLACE NOME_CAMPO WITH _STRING_NOME_CAMPO
						*REPLACE EXPR_CAMPO WITH _FIELD_EXPR  && NON PIU' USATO
						REPLACE VPOS WITH _VPOSIZ 
						REPLACE HPOS WITH _HPOSIZ 
					ENDIF
				ENDIF
			NEXT
		ENDIF
		nFieldNumber = nFieldNumber + 1
	ENDDO
	
ENDSCAN
**=> ERASMO - FINE 10/02/2014

*** DETERMINO EVENTUALI TITOLI PRESENTI NEL PAGE HEADER
SELECT MY_FRX_CURSOR
GO TOP
SCAN
	
	*** SOLO LE LABEL E LE CASELLE DI TESTO
	IF (Objtype = 5 .OR. Objtype = 8).AND. Objcode = 0
	ELSE
		LOOP
	ENDIF
	
	*** SOLO QUELLE CONTENUTE NELLA HEADER BAND
	IF VPos <= _HEADER_BAND_INITIAL_POSITION 
	ELSE
		LOOP
	ENDIF
	_FIELD_EXPR = UPPER(ALLTRIM(Expr))
	
	IF "GETTESTO" $ _FIELD_EXPR
		LOOP
	ENDIF
	
	_VPOSIZ = Vpos
	_HPOSIZ = Hpos
	
	SELECT ELENCO_TITOLI 
	APPEND BLANK
	REPLACE EXPR_CAMPO WITH _FIELD_EXPR 
	REPLACE VPOS WITH _VPOSIZ 
	REPLACE HPOS WITH _HPOSIZ 
	
ENDSCAN

SELECT ELENCO_TITOLI 
SET ORDER TO I_POSIZ
GO TOP
*_EXPR_TITOLO1 = EXPR_CAMPO
**=> ERASMO - INIZIO 18/06/2012
*** SE _EXPR_TITOLO1  CONTIENE UN RITORNO A CAPO IL COMANDO &_EXPR_TITOLO1 DA' ERRORE, QUINDI ELIMINO EVENTUALI CHR(13) PRESENTI NELLA STRINGA
_EXPR_TITOLO1 = ALLTRIM(EXPR_CAMPO)
_EXPR_TITOLO1 = STRTRAN(_EXPR_TITOLO1,CHR(13),'')
**=> ERASMO - FINE 18/06/2012
SELECT &_NOME_CURSORE
GO TOP
*!*	_TITOLO1 = &_EXPR_TITOLO1
*!*	_TITOLO1 = STRTRAN(_TITOLO1,CHR(13),CHR(10))
*!*	_TITOLO1 = STRTRAN(_TITOLO1,CHR(10)+CHR(10),CHR(10))
**=> ERASMO - INIZIO 29/10/2013

*** SE _EXPR_TITOLO1 NON E' DI TIPO CARATTERE, NON LO CONSIDERO
_TITOLO1 = ""
IF TYPE(_EXPR_TITOLO1) == 'C'
	_TITOLO1 = &_EXPR_TITOLO1
	_TITOLO1 = STRTRAN(_TITOLO1,CHR(13),CHR(10))
	_TITOLO1 = STRTRAN(_TITOLO1,CHR(10)+CHR(10),CHR(10))
ENDIF
**=> ERASMO - FINE 29/10/2013

SELECT MY_FRX_CURSOR
USE

_STRINGA_CAMPI = ""
SELECT ELENCO_CAMPI 
SET ORDER TO I_POSIZ
GO TOP
IF EOF()
	USE
	RETURN .F.
ENDIF
SCAN
*!*		IF EMPTY(ALLTRIM(_STRINGA_CAMPI))
*!*			_STRINGA_CAMPI = _STRINGA_CAMPI + ALLTRIM(EXPR_CAMPO) + " AS " + ALLTRIM(NOME_CAMPO)
*!*		ELSE
*!*			_STRINGA_CAMPI = _STRINGA_CAMPI + ", " + ALLTRIM(EXPR_CAMPO) + " AS " + ALLTRIM(NOME_CAMPO)
*!*		ENDIF

	**=> ERASMO - INIZIO 16/07/2015
	*** SE ESTRAZIONE EXCEL DEL REPORT DI LISTA PARAMETRI, ESTRAGGO I CAMPI "PAR_VALIDDAL" E "PAR_VALIDDAL" SOLO SU PARAMETRO "TPO" (TIPOLOGIA DOCUMENTO)
	_cNomeCampo = ALLTRIM(NOME_CAMPO)
	IF _NOME_FILE_REPORT = "PARALIST.FRX" AND (UPPER(_cNomeCampo) = "PAR_VALIDDAL" OR UPPER(_cNomeCampo) = "PAR_VALIDAL")
		SELECT &_NOME_CURSORE
		GO TOP
		IF !EOF()
			IF SUBSTR(CODICE,1,3) = 'TPO'
			ELSE
				SELECT ELENCO_CAMPI
				LOOP
			ENDIF
		ENDIF
	ENDIF
	SELECT ELENCO_CAMPI
	**=> ERASMO - FINE 16/07/2015

	**=> ERASMO - INIZIO 10/02/2014
	IF EMPTY(ALLTRIM(_STRINGA_CAMPI))
		_STRINGA_CAMPI = _STRINGA_CAMPI + ALLTRIM(NOME_CAMPO)
	ELSE
		_STRINGA_CAMPI = _STRINGA_CAMPI + ", " + ALLTRIM(NOME_CAMPO)
	ENDIF
	**=> ERASMO - FINE 10/02/2014
ENDSCAN
USE

IF !_RITORNA_SOLO_NOME_REPORT

	_STRINGA_SELECT = "SELECT " + _STRINGA_CAMPI + " FROM " + _NOME_CURSORE + " INTO CURSOR CURSORE_XLS"
	&_STRINGA_SELECT
	*DO ESTRXLS WITH "CURSORE_XLS",_TITOLO1	
	**=> ERASMO - INIZIO 25/10/2017
	SELECT CURSORE_XLS
	GO TOP
	IF _NON_FORMATTATO
		DO ESTRXLS_NON_FORMATTATO
	ELSE
		DO ESTRXLS WITH "CURSORE_XLS",_TITOLO1	
	ENDIF
	**=> ERASMO - FINE 25/10/2017
	
ELSE
	
	SELECT(_OLD_SELECT)
	RETURN _TITOLO1
	
ENDIF

SELECT(_OLD_SELECT)

RETURN


************************************************************************
PROCEDURE ESTRXLS_CONTABILESINTETICA
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
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_V_OPZST,_RIS_DARE,_RIS_AVERE,_RIS_SALDO 

**=> ERASMO - INIZIO 10/08/2010
IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF
**=> ERASMO - FINE 10/08/2010

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

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
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
      *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
      *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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
_RIGA_INIZIALE = 6

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

**=> ERASMO - INIZIO 10/08/2010
WITH objExcel
	.ActiveSheet.Cells(2,3).Value = _TITOLO1
	.ActiveSheet.Cells(2,3).Font.Bold = .T.
	.ActiveSheet.Cells(2,3).Font.Size = 11
	.ActiveSheet.Cells(2,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,3).Value = _TITOLO2
	.ActiveSheet.Cells(3,3).Font.Bold = .T.
	.ActiveSheet.Cells(3,3).Font.Size = 11
	.ActiveSheet.Cells(3,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,3).Value = _TITOLO3
	.ActiveSheet.Cells(4,3).Font.Bold = .T.
	.ActiveSheet.Cells(4,3).Font.Size = 11
	.ActiveSheet.Cells(4,3).HorizontalAlignment = 1
ENDWITH
**=> ERASMO - FINE 10/08/2010

** LUCA
*objExcel.ActiveSheet.Rows(2).RowHeight = 50

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
         objExcel.Selection.NumberFormat = "#,##0.000"
      ELSE
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "@"
      ENDIF
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
      IF _NOMECAMPO == 'TIPOIMPORTO'
	      IF (_VALORE) == '0'
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	      ENDIF
	      IF (_VALORE) == '1'
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	      ENDIF
	      IF (_VALORE) == '2'
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	      ENDIF
	  ENDIF
	  IF _NOMECAMPO == 'MOV_CONTO'
	      IF (_VALORE) == 'xxxxxxxxxxxxx'
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	   	  ENDIF
	  ENDIF
	  IF _NOMECAMPO == 'DESCONTO'
		  IF ALLTRIM(_VALORE) == 'Totale COSTI'
			  objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
		  ENDIF
		  IF ALLTRIM(_VALORE) == 'Totale RICAVI'
		  	  objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
		  ENDIF
	  ENDIF
	  
	  
	  

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

**=> ERASMO - INIZIO 10/08/2010
*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
objExcel.ActiveSheet.Cells(_nRIGA+1,3).Value = "Totale RISULTATO"
IF _V_OPZST == 2
	objExcel.ActiveSheet.Cells(_nRIGA+1,3).Value = "Totale COSTI"
ENDIF
IF _V_OPZST == 3
	objExcel.ActiveSheet.Cells(_nRIGA+1,3).Value = "Totale RICAVI"
ENDIF
objExcel.ActiveSheet.Cells(_nRIGA+1,3).Font.Bold = .T.

IF _V_OPZST <> 2 AND _V_OPZST <> 3
	objExcel.ActiveSheet.Cells(_nRIGA+1,4).Value = _RIS_DARE
	objExcel.ActiveSheet.Cells(_nRIGA+1,4).NumberFormat = "#,##0.000"
	objExcel.ActiveSheet.Cells(_nRIGA+1,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_nRIGA+1,5).Value = _RIS_AVERE
	objExcel.ActiveSheet.Cells(_nRIGA+1,5).NumberFormat = "#,##0.000"
	objExcel.ActiveSheet.Cells(_nRIGA+1,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_nRIGA+1,6).Value = _RIS_SALDO
	objExcel.ActiveSheet.Cells(_nRIGA+1,6).NumberFormat = "#,##0.000"
	objExcel.ActiveSheet.Cells(_nRIGA+1,6).Font.Bold = .T.
ELSE
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.000"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,1).Value = '' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'CONTO' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'DESCRIZIONE CONTO' 

objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR


















************************************************************************
PROCEDURE ESTRXLS_CONTABILEDETTAGLIO
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
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_V_OPZST,_RIS_DARE,_RIS_AVERE,_RIS_SALDO 

**=> ERASMO - INIZIO 10/08/2010
IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF
**=> ERASMO - FINE 10/08/2010

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

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
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
      *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
      *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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
_RIGA_INIZIALE = 6

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

**=> ERASMO - INIZIO 10/08/2010
WITH objExcel
	.ActiveSheet.Cells(2,3).Value = _TITOLO1
	.ActiveSheet.Cells(2,3).Font.Bold = .T.
	.ActiveSheet.Cells(2,3).Font.Size = 11
	.ActiveSheet.Cells(2,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,3).Value = _TITOLO2
	.ActiveSheet.Cells(3,3).Font.Bold = .T.
	.ActiveSheet.Cells(3,3).Font.Size = 11
	.ActiveSheet.Cells(3,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,3).Value = _TITOLO3
	.ActiveSheet.Cells(4,3).Font.Bold = .T.
	.ActiveSheet.Cells(4,3).Font.Size = 11
	.ActiveSheet.Cells(4,3).HorizontalAlignment = 1
ENDWITH
**=> ERASMO - FINE 10/08/2010

** LUCA
*objExcel.ActiveSheet.Rows(2).RowHeight = 50

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
         objExcel.Selection.NumberFormat = "#,##0.000"
      ELSE
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "@"
      ENDIF
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
*!*	      IF _NOMECAMPO == 'TIPOIMPORTO'
*!*		      IF (_VALORE) == '0'
*!*		   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
*!*		      ENDIF
*!*		      IF (_VALORE) == '1'
*!*		   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
*!*		      ENDIF
*!*		      IF (_VALORE) == '2'
*!*		   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
*!*		      ENDIF
*!*		  ENDIF
*!*		  IF _NOMECAMPO == 'DESCONTO'
*!*			  IF ALLTRIM(_VALORE) == 'Totale COSTI'
*!*				  objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
*!*			  ENDIF
*!*			  IF ALLTRIM(_VALORE) == 'Totale RICAVI'
*!*			  	  objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
*!*			  ENDIF
*!*		  ENDIF

	  IF _NOMECAMPO == 'DESCRIOPE'
	      IF ALLTRIM(_VALORE) == 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	   	  ENDIF
	   	  IF ALLTRIM(_VALORE) <> ''
	   	      objExcel.ActiveSheet.Cells(_nRIGA,2).Value = ''
	   	  ENDIF
	  ENDIF
	  IF _NOMECAMPO == 'MOV_CONTO' 
	  		objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
	  		IF ALLTRIM(_VALORE) == 'xxxxxxxxxxxxx'
		  		objExcel.ActiveSheet.Cells(_nRIGA,1).Font.Bold = .T.
		  		objExcel.ActiveSheet.Cells(_nRIGA,2).Font.Bold = .T.
		  		objExcel.ActiveSheet.Cells(_nRIGA,3).Font.Bold = .T.
		  		objExcel.ActiveSheet.Cells(_nRIGA,7).Font.Bold = .T.
		  		objExcel.ActiveSheet.Cells(_nRIGA,8).Font.Bold = .T.
		  		objExcel.ActiveSheet.Cells(_nRIGA,9).Font.Bold = .T.
	  		ENDIF
	  ENDIF
	  IF _NOMECAMPO == 'MOV_NREGIS' 
	  		IF ALLTRIM(_VALORE) == 'dexcel'
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	   	      objExcel.ActiveSheet.Cells(_nRIGA,I).Font.Bold = .T.
	   	      objExcel.ActiveSheet.Cells(_nRIGA,3).Font.Bold = .T.
	   	      *objExcel.ActiveSheet.Cells(_nRIGA,1).Value = ''
   	   	      objExcel.ActiveSheet.Cells(_nRIGA,2).Value = ''
	   	    ENDIF
	  ENDIF
	  IF _NOMECAMPO == 'TIPOIMPORTO'
	  		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = ''
	  ENDIF
	  
	  
	  

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

**=> ERASMO - INIZIO 10/08/2010
*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
objExcel.ActiveSheet.Cells(_nRIGA+1,3).Value = "Totale RISULTATO"
IF _V_OPZST == 2
	objExcel.ActiveSheet.Cells(_nRIGA+1,3).Value = "Totale COSTI"
ENDIF
IF _V_OPZST == 3
	objExcel.ActiveSheet.Cells(_nRIGA+1,3).Value = "Totale RICAVI"
ENDIF
objExcel.ActiveSheet.Cells(_nRIGA+1,3).Font.Bold = .T.

IF _V_OPZST <> 2 AND _V_OPZST <> 3
	objExcel.ActiveSheet.Cells(_nRIGA+1,7).Value = _RIS_DARE
	objExcel.ActiveSheet.Cells(_nRIGA+1,7).NumberFormat = "#,##0.000"
	objExcel.ActiveSheet.Cells(_nRIGA+1,7).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_nRIGA+1,8).Value = _RIS_AVERE
	objExcel.ActiveSheet.Cells(_nRIGA+1,8).NumberFormat = "#,##0.000"
	objExcel.ActiveSheet.Cells(_nRIGA+1,8).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_nRIGA+1,9).Value = _RIS_SALDO
	objExcel.ActiveSheet.Cells(_nRIGA+1,9).NumberFormat = "#,##0.000"
	objExcel.ActiveSheet.Cells(_nRIGA+1,9).Font.Bold = .T.
ELSE
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.000"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)/2"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,1).Value = '' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'CONTO' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'DESCRIZIONE CONTO' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,4).Value = 'DESCRIZIONE OPERAZIONE' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,5).Value = 'NR. REG.' 
objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,6).Value = 'PROT.' 

objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR


************************************************************************
PROCEDURE PORT_ORD_ESTRXLS_PRODUZIONE
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel per Produzione (" + ALLTRIM(_TITOLO1) + ") in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
*!*		.Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*		.Visible = .f.
	.Range("A1:IV65536").Select
	*.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*		.Range("A1:IV1").Select
*!*		.Selection.Font.Size = 10
*!*		.Selection.Font.Bold = .t.
*!*		.Columns().EntireColumn.AutoFit
*!*		.Rows("1:1").EntireRow.Select
*!*		.Selection.Insert
*!*		.Selection.Insert
*!*		.Selection.Insert
	.Range("A1").Select
*!*		.ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*		.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*		.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
	
*!*		IF FILE(PUB_LOGO1)
*!*			_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
*!*			.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
*!*			.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
*!*			*.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*			*.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
*!*			*.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
*!*			.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
*!*			.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
*!*			.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
*!*		ENDIF

*!*		.ActiveWorkbook.Save
*!*		.ActiveWorkbook.Close
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108
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

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura = _nRIGA
_cRigheXSubTotale = ""
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
	
	WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
	_cActStringaRottura = ALLTRIM(FRONTE) + ALLTRIM(RETRO) + ALLTRIM(STR(LATO1,5,0)) + ALLTRIM(STR(LATO2,6,0))
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = FIELD(I,_NOMECUR)
		_VALORE = &_NOMECAMPO
		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.Font.Size = 10
		IF TYPE(_NOMECAMPO) = "N"
			*_cNumberFormat = "#,##0"
			*objExcel.Selection.NumberFormat = "#,##0.00"
		ELSE
			objExcel.Selection.NumberFormat = "@"
			_VALORE = RTRIM(_VALORE)
		ENDIF
		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
		
		IF ALLTRIM(_NOMECAMPO) $ "RIGA/FRONTE/RETRO/DA_PROD/SP/LATO1/LATO2"
			objExcel.Selection.HorizontalAlignment = xlCenter
		ENDIF
		
		WITH objExcel.Selection.Borders(xlEdgeLeft)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeRight)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
		WITH objExcel.Selection.Borders(xlEdgeBottom)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeTop)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1
	
	_lRottura = .F.
	IF EOF()
		_lRottura = .T.
	ELSE
		_cProxStringaRottura = ALLTRIM(FRONTE) + ALLTRIM(RETRO) + ALLTRIM(STR(LATO1,5,0)) + ALLTRIM(STR(LATO2,6,0))
		IF _cActStringaRottura <> _cProxStringaRottura
			_lRottura = .T.
		ENDIF
	ENDIF
	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE A ROTTURA DI COLORE FRONTE + COLORE RETRO + LATO1 + LATO2
	IF _lRottura
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			*** AGGIUNGO IL TOTALE PARZIALE
			IF _NOMECAMPO = "DA_PROD" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura 
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					*.Selection.NumberFormat = "#,##0.00"
					.Selection.NumberFormat = "#,##0"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
					.Selection.HorizontalAlignment = xlCenter
					_cRigheXSubTotale = _cRigheXSubTotale + ALLTRIM(STR(_T_RIGA,10,0)) + ';'
					*_COLUMN = n2c(I) + ":" + n2c(I)
					*.Columns(_COLUMN).EntireColumn.AutoFit
				ENDWITH
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		ENDFOR

		_nRIGA = _nRIGA + 1
		_nRigaInizialeRottura = _nRIGA
		
		SELECT &_NOMECUR
	ENDIF
	
ENDDO

*** AGGIUNGO IL SUBTOTALE
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = FIELD(I,_NOMECUR)
	_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = "@"
	objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
	
	*** AGGIUNGO L'ETICHETTA "Totale"
	IF _NOMECAMPO = "FRONTE" AND TYPE(_NOMECAMPO) = "C"
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "@"
			.Selection.Value = "Totale:"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL VALORE TOTALE
	IF _NOMECAMPO = "DA_PROD" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
			.Selection.HorizontalAlignment = xlCenter
		ENDWITH
	ENDIF
ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** AGGIUNGO LE NOTE ANAGRAFICHE RIEPILOGATE PER CLIENTE
SELECT XLS_NOTEANAGR
GO TOP
IF !EOF()
	_nRIGA = _nRIGA + 1
	DO WHILE !EOF()
		
		_nRIGA = _nRIGA + 1
		_Range  = n2c(1) + ALLTRIM(STR(_nRIGA,10,0))
		WITH objExcel
			.ActiveSheet.Range(_Range).Select
			.Selection.NumberFormat = "@"
			.Selection.Value = "Nota cliente " + ALLTRIM(CLIENTE) + ":"
			.Selection.Font.Bold = .t.
		ENDWITH
		
		_NOTE_ANAGRAFICHE = ALLTRIM(NOTE_ANAGRAFICHE)
		DO WHILE OCCURS(CHR(13),_NOTE_ANAGRAFICHE) + 1 > 0 AND !EMPTY(_NOTE_ANAGRAFICHE)
			IF OCCURS(CHR(13),_NOTE_ANAGRAFICHE) > 0
				_RIGA_NOTA_I_ESIMA = STRTRAN(SUBSTR(_NOTE_ANAGRAFICHE,1,AT(CHR(13),_NOTE_ANAGRAFICHE)-1),CHR(10),'')
				_NOTE_ANAGRAFICHE = SUBSTR(_NOTE_ANAGRAFICHE,AT(CHR(13),_NOTE_ANAGRAFICHE)+1)
			ELSE
				_RIGA_NOTA_I_ESIMA = STRTRAN(ALLTRIM(_NOTE_ANAGRAFICHE),CHR(10),'')
				_NOTE_ANAGRAFICHE = ""
			ENDIF
			_nRIGA = _nRIGA + 1
			_Range  = n2c(2) + ALLTRIM(STR(_nRIGA,10,0))
			WITH objExcel
				.Range(_RANGE).Select
				.Selection.NumberFormat = "@"
				.Selection.Value = ALLTRIM(_RIGA_NOTA_I_ESIMA)
			ENDWITH
		ENDDO
				
		SELECT XLS_NOTEANAGR
		SKIP +1
	ENDDO
ENDIF

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,2).Value = _TITOLO2
	.ActiveSheet.Cells(3,2).Font.Bold = .T.
	.ActiveSheet.Cells(3,2).Font.Size = 11
	.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,2).Value = _TITOLO3
	.ActiveSheet.Cells(4,2).Font.Bold = .T.
	.ActiveSheet.Cells(4,2).Font.Size = 11
	.ActiveSheet.Cells(4,2).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE GRAPHXLS_MESCLI
************************************************************************
                                                                                
PARAMETER _NOMECUR,_TITOLO

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione grafico su foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
   .Range("A1:IV65536").Select
   .Range("A1").Select
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
      *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
      *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
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

_RIGA_INIZIALE = 6

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
   
   WAIT WINDOWS "Creazione grafico su foglio excel in corso... - elaborazione dati riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
   
   FOR I = 1 TO _NUMEROCAMPI
      _NOMECAMPO = FIELD(I,_NOMECUR)
      _VALORE = &_NOMECAMPO
      _Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0)) && + ":" + n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      objExcel.ActiveSheet.Range(_Range).Select
      IF TYPE(_NOMECAMPO) = "N"
         objExcel.Selection.NumberFormat = "#,##0.00"
      ELSE
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "@"
         _VALORE = ALLTRIM(_VALORE)
      ENDIF
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

WAIT WINDOWS "Creazione grafico su foglio excel in corso..." NOWAIT

*** AGGIUNGO IL GRAFICO
xl3DColumnClustered = 54
xlColumnClustered = 51
xlRows = 1
xlColumns = 2
xlLocationAsObject = 2
xlCategory = 1
xlPrimary = 1
xlValue = 2

SELECT &_NOMECUR
GO TOP
IF !EOF()
	_RANGE = "A" + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + ALLTRIM(n2c(_NUMEROCAMPI)) + ALLTRIM(STR(_nRIGA - 1,10,0))
	WITH objExcel 
	   _nome_foglio = ALLTRIM(.ActiveSheet.Name)
	   *** CREO IL GRAFICO A LINEE ED IMPOSTO IL RANGE DI CELLE PER L'ORIGINE DATI
	   .Range(_RANGE).Select
	   .Charts.Add
	   .ActiveChart.ChartType = xlColumnClustered
	   .ActiveChart.SetSourceData(.Sheets(_nome_foglio).Range(_RANGE),xlColumns)
	   .ActiveChart.Location(xlLocationAsObject,_nome_foglio)
	   
	   **** IMPOSTO IL TITOLO DEL GRAFICO
	   *.ActiveChart.PlotArea.Select
	   *.ActiveChart.HasTitle = .T.
	   *.ActiveChart.ChartTitle.Characters.Text = ALLTRIM(_TITOLO)
	   
	   .ActiveChart.ChartArea.Select
	   .ActiveChart.PlotVisibleOnly = .F.  && RENDO I DATI DEL GRAFICO VISIBILI ALL'INTERNO DEL GRAFICO ANCHE SE APPARTENENTI A CELLE NASCOSTE
	   
	   *** IMPOSTO IL TITOLO DELLE SERIE
	   .ActiveChart.Axes(xlCategory, xlPrimary).HasTitle = .T.
	   .ActiveChart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "CLIENTE"
	   .ActiveChart.Axes(xlValue, xlPrimary).HasTitle = .T.
	   .ActiveChart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "VALORE"
	   
	   *** IMPOSTO LA POSIZIONE DEL GRAFICO
	   .ActiveChart.ChartArea.Select
	   _NOME_GRAFICO = ALLTRIM(STRTRAN(.ActiveChart.Name,_nome_foglio,""))
	   .ActiveSheet.Shapes(_NOME_GRAFICO).Left = .ActiveSheet.Columns(1).Left
	   .ActiveSheet.Shapes(_NOME_GRAFICO).IncrementLeft(25)
	   .ActiveSheet.Shapes(_NOME_GRAFICO).Top = .ActiveSheet.Rows(_nRIGA - 1).Top
	   
	   *** IMPOSTO LE DIMENSIONI DEL GRAFICO
	   .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleWidth(2.2,0,0)
	   .ActiveSheet.Shapes(_NOME_GRAFICO).ScaleHeight(1.6,0,0)
	   
	ENDWITH
ENDIF

*** NASCONDO LA TABELLA DEI DATI
_RANGE = ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + ALLTRIM(STR(_nRIGA - 1,10,0))
objExcel.Rows(_RANGE).Select
objExcel.Selection.EntireRow.Hidden = .T.

*** TITOLO
WITH objExcel
	.ActiveSheet.Cells(2,4).Value = _TITOLO
	.ActiveSheet.Cells(2,4).Font.Bold = .T.
	.ActiveSheet.Cells(2,4).Font.Size = 14
	.ActiveSheet.Cells(2,4).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE ESTRXLS_BILANCIO
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
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,VA_TOTALE,VD_TOTALE

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

_RECCOUNT=RECCOUNT() +100


WITH objExcel 
   .Range("A1:IV"+ALLTRIM(STR(_RECCOUNT))).Select
   .Selection.Font.Size = 10
   .Range("A1").Select
   
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Height = 20 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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
_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 12
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

WITH objExcel
	.ActiveSheet.Cells(2,3).Value = _TITOLO1
	.ActiveSheet.Cells(2,3).Font.Bold = .T.
	.ActiveSheet.Cells(2,3).Font.Size = 12
	.ActiveSheet.Cells(2,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,3).Value = _TITOLO2
	.ActiveSheet.Cells(3,3).Font.Bold = .T.
	.ActiveSheet.Cells(3,3).Font.Italic = .T.
	.ActiveSheet.Cells(3,3).Font.Size = 12
	.ActiveSheet.Cells(3,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,3).Value = _TITOLO3
	.ActiveSheet.Cells(4,3).Font.Bold = .T.
	.ActiveSheet.Cells(4,3).Font.Size = 12
	.ActiveSheet.Cells(4,3).HorizontalAlignment = 1
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
      
      IF ALLTRIM(da_tipo) = 'ZZ'
      	objExcel.ActiveSheet.Range(_Range).Select
      	objExcel.Selection.Font.Bold = .T.
      ENDIF
      
      IF TYPE(_NOMECAMPO) = "N"
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "#,##0.00"
         IF AT('METRIQUADRI',ALLTRIM(_TITOLO2)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECQTA STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Unità',ALLTRIM(_TITOLO2)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECQTA STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Unità',ALLTRIM(_TITOLO3)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECQTA STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Valuta',ALLTRIM(_TITOLO2)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECVAL STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Valuta',ALLTRIM(_TITOLO3)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECVAL STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
      ELSE
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "@"
      ENDIF
      IF TYPE(_NOMECAMPO) = "N" AND _VALORE = 0
	  ELSE
	  	  objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
	  ENDIF

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

*** TOTALI
_T_RIGA  = _nRIGA + 1
_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1

IF ALLTRIM(_TITOLO2) = "Stato Patrimoniale"
	
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'DESCRIZIONE CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,4).Value = 'SALDO INIZIALE' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,7).Value = "ATTIVITA'" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,8).Value = "PASSIVITA'" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,10).Value = 'SALDO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,11).Value = 'perc.' 
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit


	objExcel.ActiveSheet.Columns("N").Delete
	objExcel.ActiveSheet.Columns("M").Delete
	objExcel.ActiveSheet.Columns("L").Delete
	objExcel.ActiveSheet.Columns("K").Delete
	objExcel.ActiveSheet.Columns("I").Delete
	objExcel.ActiveSheet.Columns("F").Delete
	objExcel.ActiveSheet.Columns("E").Delete
	objExcel.ActiveSheet.Columns("A").Delete
	

	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Value = 'Riepilogo totali Attività/Passività'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Value = 'Totale'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Value = ROUND(VA_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Value = ROUND(VD_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Value = "Risultato d'esercizio in corso"
	IF VA_TOTALE<VD_TOTALE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = round(va_totale,2)-round(vd_totale,2)
		objExcel.ActiveSheet.Cells(_T_RIGA+4,4).NumberFormat = "#,##0.00"
	ELSE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = ''
	ENDIF
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = round(va_totale,2)-round(vd_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Value = 'Totale a pareggio'
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Value = round(vd_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Value = round(va_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).NumberFormat = "#,##0.00"
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Font.Bold = .T.
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Italic = .T.

ENDIF


IF ALLTRIM(_TITOLO2) = "Conto Economico"
	
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'DESCRIZIONE CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,4).Value = 'SALDO INIZIALE' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,7).Value = "COSTI" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,8).Value = "RICAVI" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,10).Value = 'SALDO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,11).Value = '%' 
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

	objExcel.ActiveSheet.Columns("N").Delete
	objExcel.ActiveSheet.Columns("M").Delete
	objExcel.ActiveSheet.Columns("L").Delete
	objExcel.ActiveSheet.Columns("I").Delete
	objExcel.ActiveSheet.Columns("F").Delete
	objExcel.ActiveSheet.Columns("E").Delete
	objExcel.ActiveSheet.Columns("A").Delete
	

	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Value = 'Riepilogo totali Costi/Ricavi'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Value = 'Totale'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Value = ROUND(VA_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Value = ROUND(VD_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Value = "Risultato d'esercizio in corso"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = round(vd_totale,2)-round(va_totale,2)
	IF va_totale>=vd_totale
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = round(vd_totale,2)-round(va_totale,2)
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).NumberFormat = "#,##0.00"
	ELSE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = ''
	ENDIF
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Value = 'Totale a pareggio'
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Value = round(vd_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Value = round(va_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).NumberFormat = "#,##0.00"
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Font.Bold = .T.
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Italic = .T.

ENDIF


objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR



************************************************************************
PROCEDURE ESTRXLS_STAT_MCMQ
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
*!*		.Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*		.Visible = .f.
	.Range("A1:IV65536").Select
	*.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*		.Range("A1:IV1").Select
*!*		.Selection.Font.Size = 10
*!*		.Selection.Font.Bold = .t.
*!*		.Columns().EntireColumn.AutoFit
*!*		.Rows("1:1").EntireRow.Select
*!*		.Selection.Insert
*!*		.Selection.Insert
*!*		.Selection.Insert
	.Range("A1").Select
*!*		.ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*		.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*		.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		*.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
		*.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
		*.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF

*!*		.ActiveWorkbook.Save
*!*		.ActiveWorkbook.Close
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = FIELD(I,_NOMECUR)
	IF ALLTRIM(_NOMECAMPO) $ "TIPO_GN/TIPO_G/TIPO_N/SCELTA"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
		LOOP
	ENDIF
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108
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

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura = _nRIGA
_cRigheXSubTotale = ""
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
	
	WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
	_cActStringaRottura = ALLTRIM(TIPO_GN) + ALLTRIM(TIPO_G) + ALLTRIM(TIPO_N) + ALLTRIM(SCELTA)
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF ALLTRIM(_NOMECAMPO) $ "TIPO_GN/TIPO_G/TIPO_N/SCELTA"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
			LOOP
		ENDIF
		_VALORE = &_NOMECAMPO
		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.Font.Size = 10
		IF TYPE(_NOMECAMPO) = "N"
			DO CASE
				CASE ALLTRIM(_NOMECAMPO) = "PREZZO_MEDIO_MC"
					objExcel.Selection.NumberFormat = "#,##0.000000"
				CASE ALLTRIM(_NOMECAMPO) = "PREZZO_MEDIO_MQ"
					objExcel.Selection.NumberFormat = "#,##0.000000"
				CASE ALLTRIM(_NOMECAMPO) = "IMPORTO"
					objExcel.Selection.NumberFormat = "#,##0.00"
				OTHERWISE
					objExcel.Selection.NumberFormat = "#,##0.000"
			ENDCASE
		ELSE
			objExcel.Selection.NumberFormat = "@"
			_VALORE = RTRIM(_VALORE)
		ENDIF
		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
		
		IF _NOMECAMPO = "PREZZO_MEDIO_MC"
			_RIF_DIVIDENDO = -1
			_RIF_DIVISORE = -3
			objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
		ENDIF
		
		IF _NOMECAMPO = "PREZZO_MEDIO_MQ"
			_RIF_DIVIDENDO = -2
			_RIF_DIVISORE = -3
			objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
		ENDIF
		
		*IF ALLTRIM(_NOMECAMPO) $ "ARTICOLO/DESCRIZIONE/QUANTITA_MC/QUANTITA_MQ/IMPORTO/PREZZO_MEDIO_MC/PREZZO_MEDIO_MQ"
		*	objExcel.Selection.HorizontalAlignment = xlCenter
		*ENDIF
				
		WITH objExcel.Selection.Borders(xlEdgeLeft)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeRight)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
		WITH objExcel.Selection.Borders(xlEdgeBottom)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeTop)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1
	
	_lRottura = .F.
	IF EOF()
		_lRottura = .T.
	ELSE
		_cProxStringaRottura = ALLTRIM(TIPO_GN) + ALLTRIM(TIPO_G) + ALLTRIM(TIPO_N) + ALLTRIM(SCELTA)
		IF _cActStringaRottura <> _cProxStringaRottura
			_lRottura = .T.
		ENDIF
	ENDIF
	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI GREZZO/NOBILITATO + TIPO GREZZO + TIPO NOBILITATO + SCELTA
	IF _lRottura
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MC
			IF _NOMECAMPO = "QUANTITA_MC" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura 
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
					*.Selection.HorizontalAlignment = xlCenter
					_cRigheXSubTotale = _cRigheXSubTotale + ALLTRIM(STR(_T_RIGA,10,0)) + ';'  && AGGIUNGO A QUESTA STRINGA LA CELLA DA RIPORTARE NELLA SOMMA GENERALE (SUBTOTALE)
					*_COLUMN = n2c(I) + ":" + n2c(I)
					*.Columns(_COLUMN).EntireColumn.AutoFit
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MQ
			IF _NOMECAMPO = "QUANTITA_MQ" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura 
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELL'IMPORTO
			IF _NOMECAMPO = "IMPORTO" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura 
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MC
			IF _NOMECAMPO = "PREZZO_MEDIO_MC" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -1
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MQ
			IF _NOMECAMPO = "PREZZO_MEDIO_MQ" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -2
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		ENDFOR

		_nRIGA = _nRIGA + 1
		_nRigaInizialeRottura = _nRIGA
		
		SELECT &_NOMECUR
	ENDIF
	
ENDDO

*** AGGIUNGO IL SUBTOTALE
_cSaveRigheXSubTotale = _cRigheXSubTotale
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = FIELD(I,_NOMECUR)
	_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = "@"
	objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
	
	*** AGGIUNGO L'ETICHETTA "Totale"
	IF _NOMECAMPO = "DESCRIZIONE" AND TYPE(_NOMECAMPO) = "C"
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "@"
			.Selection.Value = "Totale:"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO LA QUANTITA' MC TOTALE
	IF _NOMECAMPO = "QUANTITA_MC" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO LA QUANTITA' MQ TOTALE
	IF _NOMECAMPO = "QUANTITA_MQ" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL VALORE TOTALE
	IF _NOMECAMPO = "IMPORTO" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.00"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL PREZZO MEDIO MC
	IF _NOMECAMPO = "PREZZO_MEDIO_MC" AND TYPE(_NOMECAMPO) = "N"
		_T_RIGA  = _nRIGA
		_RIF_DIVIDENDO = -1
		_RIF_DIVISORE = -3
		WITH objExcel 
			_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000000"
			.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL PREZZO MEDIO MQ
	IF _NOMECAMPO = "PREZZO_MEDIO_MQ" AND TYPE(_NOMECAMPO) = "N"
		_T_RIGA  = _nRIGA
		_RIF_DIVIDENDO = -2
		_RIF_DIVISORE = -3
		WITH objExcel 
			_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000000"
			.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,2).Value = _TITOLO2
	.ActiveSheet.Cells(3,2).Font.Bold = .T.
	.ActiveSheet.Cells(3,2).Font.Size = 11
	.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,2).Value = _TITOLO3
	.ActiveSheet.Cells(4,2).Font.Bold = .T.
	.ActiveSheet.Cells(4,2).Font.Size = 11
	.ActiveSheet.Cells(4,2).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC



************************************************************************
PROCEDURE ESTRXLS_ENTRATO_FORNITORI
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
	.Range("A1:IV65536").Select
	.Range("A1").Select	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = FIELD(I,_NOMECUR)
	IF ALLTRIM(_NOMECAMPO) $ "TIPO_RIGA/LAVORATIVO"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
		LOOP
	ENDIF
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
	IF USED("CUR_COLS")
		SELECT CUR_COLS
		GO TOP
		SCAN
			IF RECNO() = I
				objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = ALLTRIM(DSTCAT)
				EXIT
			ENDIF
		ENDSCAN
	ENDIF
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlRight = -4152
xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108
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

_nRIGA = _RIGA_INIZIALE + 1
_nRigaIniziale = _nRIGA
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
	
	WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF ALLTRIM(_NOMECAMPO) $ "TIPO_RIGA/LAVORATIVO"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
			LOOP
		ENDIF
		_VALORE = &_NOMECAMPO
		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.Font.Size = 10
		IF TYPE(_NOMECAMPO) = "N"
			objExcel.Selection.NumberFormat = "#,##0.000"
		ELSE
			objExcel.Selection.NumberFormat = "@"
			objExcel.Selection.Font.Bold = .t.
			objExcel.Selection.HorizontalAlignment = xlRight
			_VALORE = RTRIM(_VALORE)
		ENDIF
		
		DO CASE
			CASE ALLTRIM(GIORNO) == 'Tot.Entrato Qtà' AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaIniziale
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
				objExcel.Selection.Font.Bold = .t.
				
			CASE ALLTRIM(GIORNO) == 'Tot.Entrato Val.' AND TYPE(_NOMECAMPO) = "N"
				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				objExcel.Selection.Font.Bold = .t.
							
			CASE ALLTRIM(GIORNO) == 'FABBISOGNO' AND TYPE(_NOMECAMPO) = "N"
				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				objExcel.Selection.Font.Bold = .t.
				
			CASE ALLTRIM(GIORNO) == 'COSTO MEDIO' AND TYPE(_NOMECAMPO) = "N"
				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				objExcel.Selection.Font.Bold = .t.
				
			CASE ALLTRIM(GIORNO) == 'Risultato Qtà' AND TYPE(_NOMECAMPO) = "N"
				objExcel.ActiveCell.FormulaR1C1 = "=R[-4]C - R[-2]C"
				objExcel.Selection.Font.Bold = .t.
				
			CASE ALLTRIM(GIORNO) == 'Risultato Val.' AND TYPE(_NOMECAMPO) = "N"
				objExcel.ActiveCell.FormulaR1C1 = "=R[-2]C * R[-1]C"
				objExcel.Selection.Font.Bold = .t.
				
			OTHERWISE
				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
		ENDCASE
		
		_cNomeCampoTipoRiga = _NOMECUR + ".TIPO_RIGA"
		_cNomeCampoLavorativo = _NOMECUR + ".LAVORATIVO"
		_cBackColor = IIF(&_cNomeCampoTipoRiga='2_RIEP' or &_cNomeCampoTipoRiga='2_RIEPV','RGB(255,255,128)',IIF(&_cNomeCampoTipoRiga='3_FABB' OR &_cNomeCampoTipoRiga='4_COST', ;
			'RGB(206,231,255)',IIF(&_cNomeCampoTipoRiga='5_RISQ' OR &_cNomeCampoTipoRiga='6_RISV','RGB(174,255,174)', ;
			IIF(&_cNomeCampoTipoRiga='1_DETT' AND &_cNomeCampoLavorativo = .F.,'RGB(192,192,192)','RGB(255,255,255)'))))
		objExcel.Selection.Interior.Color = &_cBackColor
		
		_cForeColor = IIF(&_cNomeCampoTipoRiga='2_RIEPV','RGB(255,0,0)','RGB(0,0,0)')
		objExcel.Selection.Font.Color = &_cForeColor
		
		WITH objExcel.Selection.Borders(xlEdgeLeft)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeRight)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
		WITH objExcel.Selection.Borders(xlEdgeBottom)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeTop)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1
ENDDO

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,2).Value = _TITOLO2
	.ActiveSheet.Cells(3,2).Font.Bold = .T.
	.ActiveSheet.Cells(3,2).Font.Size = 11
	.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,2).Value = _TITOLO3
	.ActiveSheet.Cells(4,2).Font.Bold = .T.
	.ActiveSheet.Cells(4,2).Font.Size = 11
	.ActiveSheet.Cells(4,2).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE PORT_ORD_ESTRXLS_CARTE
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel per approvvigionamento Carte in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
*!*		.Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*		.Visible = .f.
	.Range("A1:IV65536").Select
	*.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*		.Range("A1:IV1").Select
*!*		.Selection.Font.Size = 10
*!*		.Selection.Font.Bold = .t.
*!*		.Columns().EntireColumn.AutoFit
*!*		.Rows("1:1").EntireRow.Select
*!*		.Selection.Insert
*!*		.Selection.Insert
*!*		.Selection.Insert
	.Range("A1").Select
*!*		.ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*		.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*		.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		*.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
		*.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
		*.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF

*!*		.ActiveWorkbook.Save
*!*		.ActiveWorkbook.Close
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108
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

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura = _nRIGA
*_cRigheXSubTotale = ""
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
	
	WAIT WINDOWS "Creazione foglio excel per approvvigionamento Carte in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
	_cActStringaRottura = ALLTRIM(COLORE_FRONTE) + ALLTRIM(COLORE_RETRO) + ALLTRIM(STR(LUNGHEZZA_LATO2,6,0)) + ALLTRIM(STR(ALTEZZA_LATO1,5,0))
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = FIELD(I,_NOMECUR)
		_VALORE = &_NOMECAMPO
		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.Font.Size = 10
		IF TYPE(_NOMECAMPO) = "N"
			*_cNumberFormat = "#,##0"
			*objExcel.Selection.NumberFormat = "#,##0.00"
		ELSE
			objExcel.Selection.NumberFormat = "@"
			_VALORE = RTRIM(_VALORE)
		ENDIF
		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
		
		IF "NR_" $ ALLTRIM(_NOMECAMPO)
			objExcel.Selection.HorizontalAlignment = xlCenter
		ENDIF
		
		WITH objExcel.Selection.Borders(xlEdgeLeft)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeRight)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
		WITH objExcel.Selection.Borders(xlEdgeBottom)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeTop)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1
	
	_lRottura = .F.
	IF EOF()
		_lRottura = .T.
	ELSE
		_cProxStringaRottura = ALLTRIM(COLORE_FRONTE) + ALLTRIM(COLORE_RETRO) + ALLTRIM(STR(LUNGHEZZA_LATO2,6,0)) + ALLTRIM(STR(ALTEZZA_LATO1,5,0))
		IF _cActStringaRottura <> _cProxStringaRottura
			_lRottura = .T.
		ENDIF
	ENDIF
	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE A ROTTURA DI COLORE FRONTE + COLORE RETRO + LATO1 + LATO2
	IF _lRottura
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			*** AGGIUNGO IL TOTALE PARZIALE
			*IF _NOMECAMPO = "NR_PEZZI_ORDINATI" AND TYPE(_NOMECAMPO) = "N"
			IF TYPE(_NOMECAMPO) = "N" AND "NR_" $ ALLTRIM(_NOMECAMPO)
				_RIGA_INIZIALE = _nRigaInizialeRottura 
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					*.Selection.NumberFormat = "#,##0.00"
					.Selection.NumberFormat = "#,##0"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
					.Selection.HorizontalAlignment = xlCenter

					*_cRigheXSubTotale = _cRigheXSubTotale + ALLTRIM(STR(_T_RIGA,10,0)) + ';'
					
					*_COLUMN = n2c(I) + ":" + n2c(I)
					*.Columns(_COLUMN).EntireColumn.AutoFit
				ENDWITH
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		ENDFOR

		_nRIGA = _nRIGA + 1
		_nRigaInizialeRottura = _nRIGA
		
		SELECT &_NOMECUR
	ENDIF
	
ENDDO

*!*	_cRigheXSubTotaleSave = _cRigheXSubTotale

*!*	*** AGGIUNGO IL SUBTOTALE
*!*	FOR I = 1 TO _NUMEROCAMPI
*!*		_NOMECAMPO = FIELD(I,_NOMECUR)
*!*		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
*!*		objExcel.ActiveSheet.Range(_Range).Select
*!*		objExcel.Selection.NumberFormat = "@"
*!*		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
*!*		
*!*		*** AGGIUNGO L'ETICHETTA "Totale"
*!*		IF _NOMECAMPO = "DESCR_PRODOTTO" AND TYPE(_NOMECAMPO) = "C"
*!*			WITH objExcel 
*!*				.Range(_RANGE).Select
*!*				.Selection.NumberFormat = "@"
*!*				.Selection.Value = "Totale:"
*!*				.Selection.Font.Bold = .t.
*!*			ENDWITH
*!*		ENDIF
*!*		
*!*		*** AGGIUNGO IL VALORE TOTALE
*!*		*IF _NOMECAMPO = "NR_PEZZI_ORDINATI" AND TYPE(_NOMECAMPO) = "N"
*!*		IF TYPE(_NOMECAMPO) = "N" AND "NR_" $ ALLTRIM(_NOMECAMPO)
*!*			_RIF_SUM = ""
*!*			_cRigheXSubTotale = _cRigheXSubTotaleSave
*!*			DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
*!*				_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
*!*				_nRigaDaSommare = VAL(_cRigaDaSommare)
*!*				_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
*!*				_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
*!*				_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
*!*				_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
*!*			ENDDO
*!*			IF !EMPTY(_RIF_SUM)
*!*				WITH objExcel 
*!*					.Range(_RANGE).Select
*!*					.Selection.NumberFormat = "#,##0"
*!*					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"  && DA VERIFICARE PERCHE' IN QUESTA RIGA DA' ERRORE
*!*					.Selection.Font.Bold = .t.
*!*					.Selection.HorizontalAlignment = xlCenter
*!*				ENDWITH
*!*			ENDIF
*!*		ENDIF
*!*	ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15


*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,3).Value = _TITOLO1
	.ActiveSheet.Cells(2,3).Font.Bold = .T.
	.ActiveSheet.Cells(2,3).Font.Size = 11
	.ActiveSheet.Cells(2,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,3).Value = _TITOLO2
	.ActiveSheet.Cells(3,3).Font.Bold = .T.
	.ActiveSheet.Cells(3,3).Font.Size = 11
	.ActiveSheet.Cells(3,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,3).Value = _TITOLO3
	.ActiveSheet.Cells(4,3).Font.Bold = .T.
	.ActiveSheet.Cells(4,3).Font.Size = 11
	.ActiveSheet.Cells(4,3).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC



************************************************************************
PROCEDURE ESTRXLS_STAT_MCMQ_RAGGR
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
*!*		.Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*		.Visible = .f.
	.Range("A1:IV65536").Select
	*.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*		.Range("A1:IV1").Select
*!*		.Selection.Font.Size = 10
*!*		.Selection.Font.Bold = .t.
*!*		.Columns().EntireColumn.AutoFit
*!*		.Rows("1:1").EntireRow.Select
*!*		.Selection.Insert
*!*		.Selection.Insert
*!*		.Selection.Insert
	.Range("A1").Select
*!*		.ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*		.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*		.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		*.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
		*.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
		*.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF

*!*		.ActiveWorkbook.Save
*!*		.ActiveWorkbook.Close
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = FIELD(I,_NOMECUR)
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108
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

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura3 = _nRIGA
*_nRigaInizialeRottura2 = _nRIGA
*_nRigaInizialeRottura1 = _nRIGA
_cRigheXSubTotale = ""
_cRigheXTotale2 = ""
_cRigheXTotale1 = ""
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
	
	WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
	_cActStringaRottura3 = ALLTRIM(TIPO_GN) + ALLTRIM(COLORE) + ALLTRIM(GRUPPO_PRODUTTIVO)
	_cActStringaRottura2 = ALLTRIM(TIPO_GN) + ALLTRIM(COLORE)
	_cActStringaRottura1 = ALLTRIM(TIPO_GN)
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = FIELD(I,_NOMECUR)
		*IF ALLTRIM(_NOMECAMPO) $ "TIPO_GN/TIPO_G/TIPO_N/SCELTA"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
		*	LOOP
		*ENDIF
		_VALORE = &_NOMECAMPO
		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.Font.Size = 10
		IF TYPE(_NOMECAMPO) = "N"
			DO CASE
				CASE ALLTRIM(_NOMECAMPO) = "PREZZO_MEDIO_MC"
					objExcel.Selection.NumberFormat = "#,##0.000000"
				CASE ALLTRIM(_NOMECAMPO) = "PREZZO_MEDIO_MQ"
					objExcel.Selection.NumberFormat = "#,##0.000000"
				CASE ALLTRIM(_NOMECAMPO) = "IMPORTO"
					objExcel.Selection.NumberFormat = "#,##0.00"
				OTHERWISE
					objExcel.Selection.NumberFormat = "#,##0.000"
			ENDCASE
		ELSE
			objExcel.Selection.NumberFormat = "@"
			_VALORE = RTRIM(_VALORE)
		ENDIF
		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
		
		IF _NOMECAMPO = "PREZZO_MEDIO_MC"
			_RIF_DIVIDENDO = -1
			_RIF_DIVISORE = -3
			objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
		ENDIF
		
		IF _NOMECAMPO = "PREZZO_MEDIO_MQ"
			_RIF_DIVIDENDO = -2
			_RIF_DIVISORE = -3
			objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
		ENDIF
		
		*IF ALLTRIM(_NOMECAMPO) $ "ARTICOLO/DESCRIZIONE/QUANTITA_MC/QUANTITA_MQ/IMPORTO/PREZZO_MEDIO_MC/PREZZO_MEDIO_MQ"
		*	objExcel.Selection.HorizontalAlignment = xlCenter
		*ENDIF
				
		WITH objExcel.Selection.Borders(xlEdgeLeft)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeRight)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
		WITH objExcel.Selection.Borders(xlEdgeBottom)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		WITH objExcel.Selection.Borders(xlEdgeTop)
			.LineStyle = xlContinuous
			*.Weight = xlThin
			*.ColorIndex = xlAutomatic
		ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1
	
	_lRottura3 = .F.
	IF EOF()
		_lRottura3 = .T.
	ELSE
		_cProxStringaRottura3 = ALLTRIM(TIPO_GN) + ALLTRIM(COLORE) + ALLTRIM(GRUPPO_PRODUTTIVO)
		IF _cActStringaRottura3 <> _cProxStringaRottura3
			_lRottura3 = .T.
		ENDIF
	ENDIF
	
	_lRottura2 = .F.
	IF EOF()
		_lRottura2 = .T.
	ELSE
		_cProxStringaRottura2 = ALLTRIM(TIPO_GN) + ALLTRIM(COLORE)
		IF _cActStringaRottura2 <> _cProxStringaRottura2
			_lRottura2 = .T.
		ENDIF
	ENDIF
	
	_lRottura1 = .F.
	IF EOF()
		_lRottura1 = .T.
	ELSE
		_cProxStringaRottura1 = ALLTRIM(TIPO_GN)
		IF _cActStringaRottura1 <> _cProxStringaRottura1
			_lRottura1 = .T.
		ENDIF
	ENDIF
	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI TIPO GREZZO/NOBILITATO + COLORE + GRUPPO PRODUTTIVO
	IF _lRottura3 
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			*** AGGIUNGO L'ETICHETTA "Totale GRUPPO PRODUTTIVO"
			IF _NOMECAMPO = "GRUPPO_PRODUTTIVO" AND TYPE(_NOMECAMPO) = "C"
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "@"
					.Selection.Value = "Totale GRUPPO PRODUTTIVO:"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MC
			IF _NOMECAMPO = "QUANTITA_MC" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura3
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
					_cRigheXTotale2 = _cRigheXTotale2 + ALLTRIM(STR(_T_RIGA,10,0)) + ';'  && AGGIUNGO A QUESTA STRINGA LA CELLA DA RIPORTARE NEL TOTALE PER TIPO G/N COLORE
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MQ
			IF _NOMECAMPO = "QUANTITA_MQ" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura3
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELL'IMPORTO
			IF _NOMECAMPO = "IMPORTO" AND TYPE(_NOMECAMPO) = "N"
				_RIGA_INIZIALE = _nRigaInizialeRottura3
				_T_RIGA  = _nRIGA
				_RIF_SUM = _nRIGA - _RIGA_INIZIALE
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-1]C)"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MC
			IF _NOMECAMPO = "PREZZO_MEDIO_MC" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -1
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MQ
			IF _NOMECAMPO = "PREZZO_MEDIO_MQ" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -2
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		ENDFOR

		_nRIGA = _nRIGA + 1
		_nRigaInizialeRottura3 = _nRIGA
		
		SELECT &_NOMECUR
	ENDIF
	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI TIPO GREZZO/NOBILITATO + COLORE
	IF _lRottura2
		_cSaveRigheXTotale2 = _cRigheXTotale2 
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			*** AGGIUNGO L'ETICHETTA "Totale COLORE"
			IF _NOMECAMPO = "COLORE" AND TYPE(_NOMECAMPO) = "C"
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "@"
					.Selection.Value = "Totale COLORE:"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MC
			IF _NOMECAMPO = "QUANTITA_MC" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale2 = _cSaveRigheXTotale2
				DO WHILE OCCURS(';',_cRigheXTotale2) > 0
					_cRigaDaSommare = SUBSTR(_cRigheXTotale2,1,AT(';',_cRigheXTotale2)-1)
					_nRigaDaSommare = VAL(_cRigaDaSommare)
					_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
					_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
					_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
					_cRigheXTotale2 = SUBSTR(_cRigheXTotale2,AT(';',_cRigheXTotale2)+1)
				ENDDO
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
					.Selection.Font.Bold = .t.
					_cRigheXTotale1 = _cRigheXTotale1 + ALLTRIM(STR(_nRIGA,10,0)) + ';'  && AGGIUNGO A QUESTA STRINGA LA CELLA DA RIPORTARE NEL TOTALE PER TIPO G/N
				ENDWITH
				_cRigheXTotale2 = ""
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MC
			IF _NOMECAMPO = "QUANTITA_MQ" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale2 = _cSaveRigheXTotale2
				DO WHILE OCCURS(';',_cRigheXTotale2) > 0
					_cRigaDaSommare = SUBSTR(_cRigheXTotale2,1,AT(';',_cRigheXTotale2)-1)
					_nRigaDaSommare = VAL(_cRigaDaSommare)
					_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
					_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
					_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
					_cRigheXTotale2 = SUBSTR(_cRigheXTotale2,AT(';',_cRigheXTotale2)+1)
				ENDDO
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
					.Selection.Font.Bold = .t.
				ENDWITH
				_cRigheXTotale2 = ""
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELL'IMPORTO
			IF _NOMECAMPO = "IMPORTO" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale2 = _cSaveRigheXTotale2
				DO WHILE OCCURS(';',_cRigheXTotale2) > 0
					_cRigaDaSommare = SUBSTR(_cRigheXTotale2,1,AT(';',_cRigheXTotale2)-1)
					_nRigaDaSommare = VAL(_cRigaDaSommare)
					_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
					_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
					_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
					_cRigheXTotale2 = SUBSTR(_cRigheXTotale2,AT(';',_cRigheXTotale2)+1)
				ENDDO
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
					.Selection.Font.Bold = .t.
				ENDWITH
				_cRigheXTotale2 = ""
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MC
			IF _NOMECAMPO = "PREZZO_MEDIO_MC" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -1
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MQ
			IF _NOMECAMPO = "PREZZO_MEDIO_MQ" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -2
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		ENDFOR

		_nRIGA = _nRIGA + 1
		
		_nRigaInizialeRottura3 = _nRIGA
		
		SELECT &_NOMECUR
	ENDIF
	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI TIPO GREZZO/NOBILITATO
	IF _lRottura1
		_cSaveRigheXTotale1 = _cRigheXTotale1 
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			*** AGGIUNGO L'ETICHETTA "Totale TIPO G/N"
			IF _NOMECAMPO = "TIPO_GN" AND TYPE(_NOMECAMPO) = "C"
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "@"
					.Selection.Value = "Totale TIPO G/N:"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MC
			IF _NOMECAMPO = "QUANTITA_MC" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale1 = _cSaveRigheXTotale1
				DO WHILE OCCURS(';',_cRigheXTotale1) > 0
					_cRigaDaSommare = SUBSTR(_cRigheXTotale1,1,AT(';',_cRigheXTotale1)-1)
					_nRigaDaSommare = VAL(_cRigaDaSommare)
					_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
					_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
					_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
					_cRigheXTotale1 = SUBSTR(_cRigheXTotale1,AT(';',_cRigheXTotale1)+1)
				ENDDO
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
					.Selection.Font.Bold = .t.
					_cRigheXSubTotale = _cRigheXSubTotale + ALLTRIM(STR(_nRIGA,10,0)) + ';'  && AGGIUNGO A QUESTA STRINGA LA CELLA DA RIPORTARE NEL SUBTOTALE
				ENDWITH
				_cRigheXTotale1 = ""
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELLA QUANTITA' IN MC
			IF _NOMECAMPO = "QUANTITA_MQ" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale1 = _cSaveRigheXTotale1
				DO WHILE OCCURS(';',_cRigheXTotale1) > 0
					_cRigaDaSommare = SUBSTR(_cRigheXTotale1,1,AT(';',_cRigheXTotale1)-1)
					_nRigaDaSommare = VAL(_cRigaDaSommare)
					_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
					_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
					_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
					_cRigheXTotale1 = SUBSTR(_cRigheXTotale1,AT(';',_cRigheXTotale1)+1)
				ENDDO
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000"
					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
					.Selection.Font.Bold = .t.
				ENDWITH
				_cRigheXTotale1 = ""
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE DELL'IMPORTO
			IF _NOMECAMPO = "IMPORTO" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale1 = _cSaveRigheXTotale1
				DO WHILE OCCURS(';',_cRigheXTotale1) > 0
					_cRigaDaSommare = SUBSTR(_cRigheXTotale1,1,AT(';',_cRigheXTotale1)-1)
					_nRigaDaSommare = VAL(_cRigaDaSommare)
					_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
					_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
					_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
					_cRigheXTotale1 = SUBSTR(_cRigheXTotale1,AT(';',_cRigheXTotale1)+1)
				ENDDO
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
					.Selection.Font.Bold = .t.
				ENDWITH
				_cRigheXTotale1 = ""
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MC
			IF _NOMECAMPO = "PREZZO_MEDIO_MC" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -1
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL PREZZO MEDIO MQ
			IF _NOMECAMPO = "PREZZO_MEDIO_MQ" AND TYPE(_NOMECAMPO) = "N"
				_T_RIGA  = _nRIGA
				_RIF_DIVIDENDO = -2
				_RIF_DIVISORE = -3
				WITH objExcel 
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.000000"
					.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		ENDFOR

		_nRIGA = _nRIGA + 1
		
		_nRigaInizialeRottura3 = _nRIGA
		
		SELECT &_NOMECUR
	ENDIF
	
ENDDO

*** AGGIUNGO IL SUBTOTALE
_cSaveRigheXSubTotale = _cRigheXSubTotale
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = FIELD(I,_NOMECUR)
	_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = "@"
	objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
	
	*** AGGIUNGO L'ETICHETTA "Totale"
	IF _NOMECAMPO = "TIPO_GN" AND TYPE(_NOMECAMPO) = "C"
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "@"
			.Selection.Value = "Totale Generale:"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO LA QUANTITA' MC TOTALE
	IF _NOMECAMPO = "QUANTITA_MC" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO LA QUANTITA' MQ TOTALE
	IF _NOMECAMPO = "QUANTITA_MQ" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL VALORE TOTALE
	IF _NOMECAMPO = "IMPORTO" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.00"
			.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL PREZZO MEDIO MC
	IF _NOMECAMPO = "PREZZO_MEDIO_MC" AND TYPE(_NOMECAMPO) = "N"
		_T_RIGA  = _nRIGA
		_RIF_DIVIDENDO = -1
		_RIF_DIVISORE = -3
		WITH objExcel 
			_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000000"
			.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL PREZZO MEDIO MQ
	IF _NOMECAMPO = "PREZZO_MEDIO_MQ" AND TYPE(_NOMECAMPO) = "N"
		_T_RIGA  = _nRIGA
		_RIF_DIVIDENDO = -2
		_RIF_DIVISORE = -3
		WITH objExcel 
			_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.000000"
			.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_DIVIDENDO,10,0))+"]/RC["+ALLTRIM(STR(_RIF_DIVISORE,10,0))+"]"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,2).Value = _TITOLO2
	.ActiveSheet.Cells(3,2).Font.Bold = .T.
	.ActiveSheet.Cells(3,2).Font.Size = 11
	.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,2).Value = _TITOLO3
	.ActiveSheet.Cells(4,2).Font.Bold = .T.
	.ActiveSheet.Cells(4,2).Font.Size = 11
	.ActiveSheet.Cells(4,2).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE ESTRXLS_SCADENZ_SCARXFOR
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
	.Range("A1:IV65536").Select
	.Range("A1").Select
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	*IF ALLTRIM(_NOMECAMPO) = "wc_ragsoc"  && QUESTO CAMPO NON VIENE SCRITTO ALLO STESSO LIVELLO DELLA RIGA DI DETTAGLIO
	*	LOOP
	*ENDIF
	_VALORE = _NOMECAMPO
	DO CASE
		CASE _NOMECAMPO == "W_CODFOR"
			_VALORE = "Fornitore"
		CASE _NOMECAMPO == "WC_RAGSOC"
			_VALORE = "Rag. sociale"
		CASE _NOMECAMPO == "WC_DTSCA"
			_VALORE = "Dt.scad."
		CASE _NOMECAMPO == "WC_NFAT"
			_VALORE = "Nr.fatt."
		CASE _NOMECAMPO == "WC_DTFAT"
			_VALORE = "Dt.fatt."
		CASE _NOMECAMPO == "WC_NPROT"
			_VALORE = "Nr.prot."
		CASE _NOMECAMPO == "WC_NPART"
			_VALORE = "Nr.part."
		CASE _NOMECAMPO == "WC_DESCPA"
			_VALORE = "Pagamento"
		CASE _NOMECAMPO == "WC_ANOMAX"
			_VALORE = "An."
		CASE _NOMECAMPO == "WC_BLOCCO"
			_VALORE = "R.c."
		CASE _NOMECAMPO == "WC_FLRIBA_NATURA"
			_VALORE = "R-I"
		CASE _NOMECAMPO == "WC_SCADNN"
			_VALORE = "-oltre"
		CASE _NOMECAMPO == "WC_SCAD90"
			_VALORE = "-90"
		CASE _NOMECAMPO == "WC_SCAD60"
			_VALORE = "-60"
		CASE _NOMECAMPO == "WC_SCAD30"
			_VALORE = "-30"
		CASE _NOMECAMPO == "WC_SCAD"
			_VALORE = "Scaduto"
		CASE _NOMECAMPO == "WC_ASCA30"
			_VALORE = "+30"
		CASE _NOMECAMPO == "WC_ASCA60"
			_VALORE = "+60"
		CASE _NOMECAMPO == "WC_ASCA90"
			_VALORE = "+90"
		CASE _NOMECAMPO == "WC_ASCANN"
			_VALORE = "+oltre"
		CASE _NOMECAMPO == "WC_ASCA"
			_VALORE = "A Scadere"	
		CASE _NOMECAMPO == "WC_SCAD_ASCA"
			_VALORE = "Scaduto + A Scadere"
	ENDCASE
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _VALORE
*!*		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
*!*		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
*!*		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108

objExcel.Selection.Font.Bold = .T.
objExcel.Selection.Font.Size = 10
objExcel.Selection.HorizontalAlignment = 3 

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

WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... " NOWAIT

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura2 = _nRIGA
_cRigheXSubTotale = ""
_cRigheXTotale1 = ""
_CONTA_RIGHE_FORNITORE=0

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
	
	IF RECNO()%10 ==0
		WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	ENDIF
	
	_cActStringaRottura2 = ALLTRIM(wc_ragsoc) + ALLTRIM(wc_dtsca)
	_cActStringaRottura1 = ALLTRIM(wc_ragsoc)
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = UPPER(ALLTRIM((FIELD(I,_NOMECUR))))
		*IF ALLTRIM(_NOMECAMPO) $ "TIPO_GN/TIPO_G/TIPO_N/SCELTA"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
		*	LOOP
		*ENDIF
		
		DO CASE
			CASE _NOMECAMPO == "WC_SCAD"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_FINE = -1
				_RIF_SOMMA_INIZIO = -4
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(RC["+ALLTRIM(STR(_RIF_SOMMA_INIZIO,10,0))+"]:RC["+ALLTRIM(STR(_RIF_SOMMA_FINE,10,0))+"])"
				
			CASE _NOMECAMPO == "WC_ASCA"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_FINE = -1
				_RIF_SOMMA_INIZIO = -4
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(RC["+ALLTRIM(STR(_RIF_SOMMA_INIZIO,10,0))+"]:RC["+ALLTRIM(STR(_RIF_SOMMA_FINE,10,0))+"])"
			
			CASE _NOMECAMPO == "WC_SCAD_ASCA"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_SCADUTO = -6
				_RIF_SOMMA_SCADERE = -1
				objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_SOMMA_SCADUTO,10,0))+"]+RC["+ALLTRIM(STR(_RIF_SOMMA_SCADERE,10,0))+"]"
											  
			OTHERWISE
				IF _NOMECAMPO == "WC_NPART"
					_VALORE = ALLTRIM(STR(&_NOMECAMPO,10,0))
				ELSE
					_VALORE = &_NOMECAMPO
				ENDIF
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				IF TYPE(_NOMECAMPO) = "N" AND _NOMECAMPO <> "WC_NPART"
					objExcel.Selection.NumberFormat = "#,##0.00"
					IF _VALORE <> 0
						objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
					ENDIF
				ELSE
					IF TYPE(_NOMECAMPO) = "C"  && ERASMO - 14/03/2017
						objExcel.Selection.NumberFormat = "@"
						_VALORE = RTRIM(_VALORE)
					ENDIF					
					objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				ENDIF
		ENDCASE
		
*!*			WITH objExcel.Selection.Borders(xlEdgeLeft)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
*!*			WITH objExcel.Selection.Borders(xlEdgeRight)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
*!*			
*!*			WITH objExcel.Selection.Borders(xlEdgeBottom)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
*!*			WITH objExcel.Selection.Borders(xlEdgeTop)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1

	
	_lRottura1 = .F.
	IF EOF()
		_lRottura1 = .T.
	ELSE
		_cProxStringaRottura1 = ALLTRIM(wc_ragsoc)
		IF _cActStringaRottura1 <> _cProxStringaRottura1
			_lRottura1 = .T.
		ELSE
			_CONTA_RIGHE_FORNITORE=_CONTA_RIGHE_FORNITORE+1
		ENDIF
	ENDIF

	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI FORNITORE
	IF _lRottura1
		_cSaveRigheXTotale1 = _cRigheXTotale1 
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			*** AGGIUNGO L'ETICHETTA "Totale FORNITORE"
			IF _NOMECAMPO == "WC_ASCA"
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "@"
					.Selection.Value = "Totale FORNITORE:"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE
			IF _NOMECAMPO = "WC_SCAD_ASCA" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale1 = _cSaveRigheXTotale1
*!*					DO WHILE OCCURS(';',_cRigheXTotale1) > 0
*!*						_cRigaDaSommare = SUBSTR(_cRigheXTotale1,1,AT(';',_cRigheXTotale1)-1)
*!*						_nRigaDaSommare = VAL(_cRigaDaSommare)
*!*						_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
*!*						_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
*!*						_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
*!*						_cRigheXTotale1 = SUBSTR(_cRigheXTotale1,AT(';',_cRigheXTotale1)+1)
*!*					ENDDO
				WITH objExcel 
					_Range  = n2c(I+1) + ALLTRIM(STR(_nRIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_CONTA_RIGHE_FORNITORE+1,10,0))+"]C[-1]:R[-1]C[-1])"
					.Selection.Font.Bold = .t.
					_cRigheXSubTotale = _cRigheXSubTotale + ALLTRIM(STR(_nRIGA,10,0)) + ';'  && AGGIUNGO A QUESTA STRINGA LA CELLA DA RIPORTARE NEL SUBTOTALE
				ENDWITH
				_cRigheXTotale1 = ""
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
*!*			FOR I = 1 TO _NUMEROCAMPI
*!*				_NOMECAMPO = FIELD(I,_NOMECUR)
*!*				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
*!*				objExcel.ActiveSheet.Range(_Range).Select
*!*				objExcel.Selection.NumberFormat = "@"
*!*				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
*!*			ENDFOR
*!*			_nRIGA = _nRIGA + 1
		_CONTA_RIGHE_FORNITORE=0

		SELECT &_NOMECUR
	ENDIF
	
ENDDO

	
*** AGGIUNGO IL SUBTOTALE
_cSaveRigheXSubTotale = _cRigheXSubTotale
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = "@"
	objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
	
	*** AGGIUNGO L'ETICHETTA "Totale Generale"
	IF _NOMECAMPO == "WC_ASCA"
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "@"
			.Selection.Value = "Totale Generale:"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL TOTALE GENERALE
	IF _NOMECAMPO == "WC_SCAD_ASCA" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.00"
			***.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_nRIGA-7,10,0))+"]C:R[-1]C)"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,2).Value = _TITOLO2
	.ActiveSheet.Cells(3,2).Font.Bold = .T.
	.ActiveSheet.Cells(3,2).Font.Size = 11
	.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,2).Value = _TITOLO3
	.ActiveSheet.Cells(4,2).Font.Bold = .T.
	.ActiveSheet.Cells(4,2).Font.Size = 11
	.ActiveSheet.Cells(4,2).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC



************************************************************************
PROCEDURE ESTRXLS_SCADENZ_SCARXFOR_RAGGRUPPATO
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF


SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
	.Range("A1").Select
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	_VALORE = _NOMECAMPO
	DO CASE
		CASE _NOMECAMPO == "W_CODFOR"
			*_VALORE = "COD.FOR."
			_VALORE = "CODICE"  && ERASMO - 27/03/2018
		CASE _NOMECAMPO == "WC_RAGSOC"
			*_VALORE = "FORNITORE"
			_VALORE = "RAG.SOCIALE"  && ERASMO - 27/03/2018
		CASE _NOMECAMPO == "WC_SCADNN"
			_VALORE = "-oltre"
		CASE _NOMECAMPO == "WC_SCAD90"
			_VALORE = "-90"
		CASE _NOMECAMPO == "WC_SCAD60"
			_VALORE = "-60"
		CASE _NOMECAMPO == "WC_SCAD30"
			_VALORE = "-30"
		CASE _NOMECAMPO == "WC_SCAD"
			_VALORE = "Scaduto"
		CASE _NOMECAMPO == "WC_ASCA30"
			_VALORE = "+30"
		CASE _NOMECAMPO == "WC_ASCA60"
			_VALORE = "+60"
		CASE _NOMECAMPO == "WC_ASCA90"
			_VALORE = "+90"
		CASE _NOMECAMPO == "WC_ASCANN"
			_VALORE = "+oltre"
		CASE _NOMECAMPO == "WC_ASCA"
			_VALORE = "A Scadere"	
		CASE _NOMECAMPO == "WC_SCAD_ASCA"
			_VALORE = "Scaduto + A Scadere"
	ENDCASE
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _VALORE
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108

objExcel.Selection.Font.Bold = .T.
objExcel.Selection.Font.Size = 10
objExcel.Selection.HorizontalAlignment = 3 

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

WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... " NOWAIT

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura2 = _nRIGA
_cRigheXSubTotale = ""
_cRigheXTotale1 = ""


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
	
	IF RECNO()%10 ==0
		WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	ENDIF
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = UPPER(ALLTRIM((FIELD(I,_NOMECUR))))
		
		DO CASE
			CASE _NOMECAMPO == "WC_SCAD"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_FINE = -1
				_RIF_SOMMA_INIZIO = -4
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(RC["+ALLTRIM(STR(_RIF_SOMMA_INIZIO,10,0))+"]:RC["+ALLTRIM(STR(_RIF_SOMMA_FINE,10,0))+"])"
				
			CASE _NOMECAMPO == "WC_ASCA"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_FINE = -1
				_RIF_SOMMA_INIZIO = -4
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(RC["+ALLTRIM(STR(_RIF_SOMMA_INIZIO,10,0))+"]:RC["+ALLTRIM(STR(_RIF_SOMMA_FINE,10,0))+"])"
			
			CASE _NOMECAMPO == "WC_SCAD_ASCA"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_SCADUTO = -6
				_RIF_SOMMA_SCADERE = -1
				objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_SOMMA_SCADUTO,10,0))+"]+RC["+ALLTRIM(STR(_RIF_SOMMA_SCADERE,10,0))+"]"
											  
			OTHERWISE
				_VALORE = &_NOMECAMPO
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				IF TYPE(_NOMECAMPO) = "N" 
					objExcel.Selection.NumberFormat = "#,##0.00"
					IF _VALORE <> 0
						objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
					ENDIF
				ELSE
					objExcel.Selection.NumberFormat = "@"
					_VALORE = RTRIM(_VALORE)
					objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				ENDIF
		ENDCASE
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1

	
ENDDO

	


*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC



************************************************************************
PROCEDURE ESTRXLS_SCADENZ_SCARXCLI
************************************************************************
																										  
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
	.Range("A1:IV65536").Select
	.Range("A1").Select
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	*IF ALLTRIM(_NOMECAMPO) = "wc_ragsoc"  && QUESTO CAMPO NON VIENE SCRITTO ALLO STESSO LIVELLO DELLA RIGA DI DETTAGLIO
	*	LOOP
	*ENDIF
	_VALORE = _NOMECAMPO
	DO CASE
		CASE _NOMECAMPO == "WC_RAGSOC"
			_VALORE = "CLIENTE"
		CASE _NOMECAMPO == "WC_DTSCA"
			_VALORE = "Dt.scad."
		CASE _NOMECAMPO == "WC_NFAT"
			_VALORE = "Nr.fatt."
		CASE _NOMECAMPO == "WC_DTFAT"
			_VALORE = "Dt.fatt."
		CASE _NOMECAMPO == "WC_NREG"
			_VALORE = "Nr.regi."
		CASE _NOMECAMPO == "WC_NPART"
			_VALORE = "Nr.part."
		CASE _NOMECAMPO == "WC_ANOMAX"
			_VALORE = "An."
		CASE _NOMECAMPO == "WC_FLRIBA_NATURA"
			_VALORE = "R-I"
		CASE _NOMECAMPO == "WC_SCADNN"
			_VALORE = "-oltre"
		CASE _NOMECAMPO == "WC_SCAD90"
			_VALORE = "-90"
		CASE _NOMECAMPO == "WC_SCAD60"
			_VALORE = "-60"
		CASE _NOMECAMPO == "WC_SCAD30"
			_VALORE = "-30"
		CASE _NOMECAMPO == "WC_SCAD"
			_VALORE = "Scaduto"
		CASE _NOMECAMPO == "WC_ASCA30"
			_VALORE = "+30"
		CASE _NOMECAMPO == "WC_ASCA60"
			_VALORE = "+60"
		CASE _NOMECAMPO == "WC_ASCA90"
			_VALORE = "+90"
		CASE _NOMECAMPO == "WC_ASCANN"
			_VALORE = "+oltre"
		CASE _NOMECAMPO == "WC_ASCA"
			_VALORE = "A Scadere"	
		CASE _NOMECAMPO == "WC_SCAD_ASCA"
			_VALORE = "Scaduto + A Scadere"
			
		CASE _NOMECAMPO == "WC_CODAGE"
			_VALORE = "COD.AGENTE"
		CASE _NOMECAMPO == "WC_DESAGE"
			_VALORE = "DES.AGENTE"
		CASE _NOMECAMPO == "WC_CODTPA"
			_VALORE = "TIPO PARTITA"
		CASE _NOMECAMPO == "WC_DESTPA"
			_VALORE = "DES.TIPO PARTITA"
			
	ENDCASE
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _VALORE
*!*		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
*!*		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
*!*		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108

objExcel.Selection.Font.Bold = .T.
objExcel.Selection.Font.Size = 10
objExcel.Selection.HorizontalAlignment = 3 

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

WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... " NOWAIT

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura2 = _nRIGA
_cRigheXSubTotale = ""
_cRigheXTotale1 = ""
_CONTA_RIGHE_CLIENTE=0

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
	
	IF RECNO()%10 ==0
		WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	ENDIF
	
	_cActStringaRottura2 = ALLTRIM(wc_ragsoc) + ALLTRIM(wc_dtsca)
	_cActStringaRottura1 = ALLTRIM(wc_ragsoc)
	
	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = UPPER(ALLTRIM((FIELD(I,_NOMECUR))))
		*IF ALLTRIM(_NOMECAMPO) $ "TIPO_GN/TIPO_G/TIPO_N/SCELTA"  && QUESTI CAMPI NON VENGONO SCRITTI IN EXCEL, ANCHE SE SONO ALL'INTERNO DEL CURSORE
		*	LOOP
		*ENDIF
		
		DO CASE
			CASE _NOMECAMPO == "WC_SCAD"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_FINE = -1
				_RIF_SOMMA_INIZIO = -4
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(RC["+ALLTRIM(STR(_RIF_SOMMA_INIZIO,10,0))+"]:RC["+ALLTRIM(STR(_RIF_SOMMA_FINE,10,0))+"])"
				
			CASE _NOMECAMPO == "WC_ASCA"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_FINE = -1
				_RIF_SOMMA_INIZIO = -4
				objExcel.ActiveCell.FormulaR1C1 = "=SUM(RC["+ALLTRIM(STR(_RIF_SOMMA_INIZIO,10,0))+"]:RC["+ALLTRIM(STR(_RIF_SOMMA_FINE,10,0))+"])"
			
			CASE _NOMECAMPO == "WC_SCAD_ASCA"
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				objExcel.Selection.NumberFormat = "#,##0.00"
				_RIF_SOMMA_SCADUTO = -6
				_RIF_SOMMA_SCADERE = -1
				objExcel.ActiveCell.FormulaR1C1 = "=RC["+ALLTRIM(STR(_RIF_SOMMA_SCADUTO,10,0))+"]+RC["+ALLTRIM(STR(_RIF_SOMMA_SCADERE,10,0))+"]"
											  
			OTHERWISE
				IF _NOMECAMPO == "WC_NPART"
					_VALORE = ALLTRIM(STR(&_NOMECAMPO,10,0))
				ELSE
					_VALORE = &_NOMECAMPO
				ENDIF
				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
				objExcel.ActiveSheet.Range(_Range).Select
				objExcel.Selection.Font.Size = 10
				IF TYPE(_NOMECAMPO) = "N" AND _NOMECAMPO <> "WC_NPART"
					objExcel.Selection.NumberFormat = "#,##0.00"
					IF _VALORE <> 0
						objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
					ENDIF
				ELSE
					objExcel.Selection.NumberFormat = "@"
					_VALORE = RTRIM(_VALORE)
					objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				ENDIF
		ENDCASE
		
*!*			WITH objExcel.Selection.Borders(xlEdgeLeft)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
*!*			WITH objExcel.Selection.Borders(xlEdgeRight)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
*!*			
*!*			WITH objExcel.Selection.Borders(xlEdgeBottom)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
*!*			WITH objExcel.Selection.Borders(xlEdgeTop)
*!*				.LineStyle = xlContinuous
*!*			ENDWITH
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1

	
	_lRottura1 = .F.
	IF EOF()
		_lRottura1 = .T.
	ELSE
		_cProxStringaRottura1 = ALLTRIM(wc_ragsoc)
		IF _cActStringaRottura1 <> _cProxStringaRottura1
			_lRottura1 = .T.
		ELSE
			_CONTA_RIGHE_CLIENTE=_CONTA_RIGHE_CLIENTE+1
		ENDIF
	ENDIF

	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI CLIENTE
	IF _lRottura1
		_cSaveRigheXTotale1 = _cRigheXTotale1 
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			*** AGGIUNGO L'ETICHETTA "Totale CLIENTE"
			IF _NOMECAMPO == "WC_ASCA"
				WITH objExcel 
					.Range(_RANGE).Select
					.Selection.NumberFormat = "@"
					.Selection.Value = "Totale CLIENTE:"
					.Selection.Font.Bold = .t.
				ENDWITH
			ENDIF
			
			*** AGGIUNGO IL TOTALE PARZIALE
			IF _NOMECAMPO = "WC_SCAD_ASCA" AND TYPE(_NOMECAMPO) = "N"
				_RIF_SUM = ""
				_cRigheXTotale1 = _cSaveRigheXTotale1
*!*					DO WHILE OCCURS(';',_cRigheXTotale1) > 0
*!*						_cRigaDaSommare = SUBSTR(_cRigheXTotale1,1,AT(';',_cRigheXTotale1)-1)
*!*						_nRigaDaSommare = VAL(_cRigaDaSommare)
*!*						_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
*!*						_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
*!*						_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
*!*						_cRigheXTotale1 = SUBSTR(_cRigheXTotale1,AT(';',_cRigheXTotale1)+1)
*!*					ENDDO
				WITH objExcel 
					_Range  = n2c(I+1) + ALLTRIM(STR(_nRIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_CONTA_RIGHE_CLIENTE+1,10,0))+"]C[-1]:R[-1]C[-1])"
					.Selection.Font.Bold = .t.
					_cRigheXSubTotale = _cRigheXSubTotale + ALLTRIM(STR(_nRIGA,10,0)) + ';'  && AGGIUNGO A QUESTA STRINGA LA CELLA DA RIPORTARE NEL SUBTOTALE
				ENDWITH
				_cRigheXTotale1 = ""
			ENDIF
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
*!*			FOR I = 1 TO _NUMEROCAMPI
*!*				_NOMECAMPO = FIELD(I,_NOMECUR)
*!*				_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
*!*				objExcel.ActiveSheet.Range(_Range).Select
*!*				objExcel.Selection.NumberFormat = "@"
*!*				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
*!*			ENDFOR
*!*			_nRIGA = _nRIGA + 1
		_CONTA_RIGHE_CLIENTE=0

		SELECT &_NOMECUR
	ENDIF
	
ENDDO

	
*** AGGIUNGO IL SUBTOTALE
_cSaveRigheXSubTotale = _cRigheXSubTotale
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = "@"
	objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
	
	*** AGGIUNGO L'ETICHETTA "Totale Generale"
	IF _NOMECAMPO == "WC_ASCA"
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "@"
			.Selection.Value = "Totale Generale:"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
	
	*** AGGIUNGO IL TOTALE GENERALE
	IF _NOMECAMPO == "WC_SCAD_ASCA" AND TYPE(_NOMECAMPO) = "N"
		_RIF_SUM = ""
		_cRigheXSubTotale = _cSaveRigheXSubTotale
		DO WHILE OCCURS(';',_cRigheXSubTotale) > 0
			_cRigaDaSommare = SUBSTR(_cRigheXSubTotale,1,AT(';',_cRigheXSubTotale)-1)
			_nRigaDaSommare = VAL(_cRigaDaSommare)
			_nRigaDaSommareRelativa = _nRIGA - _nRigaDaSommare
			_cRigaDaSommareRelativa = ALLTRIM(STR(_nRigaDaSommareRelativa,10,0))
			_RIF_SUM = _RIF_SUM + IIF(EMPTY(_RIF_SUM),'',',') + "R[-" + _cRigaDaSommareRelativa + "]C"
			_cRigheXSubTotale = SUBSTR(_cRigheXSubTotale,AT(';',_cRigheXSubTotale)+1)
		ENDDO
		WITH objExcel 
			.Range(_RANGE).Select
			.Selection.NumberFormat = "#,##0.00"
			***.ActiveCell.FormulaR1C1 = "=SUM(" + _RIF_SUM + ")"
			.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_nRIGA-7,10,0))+"]C:R[-1]C)"
			.Selection.Font.Bold = .t.
		ENDWITH
	ENDIF
ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,2).Value = _TITOLO1
	.ActiveSheet.Cells(2,2).Font.Bold = .T.
	.ActiveSheet.Cells(2,2).Font.Size = 11
	.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,2).Value = _TITOLO2
	.ActiveSheet.Cells(3,2).Font.Bold = .T.
	.ActiveSheet.Cells(3,2).Font.Size = 11
	.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,2).Value = _TITOLO3
	.ActiveSheet.Cells(4,2).Font.Bold = .T.
	.ActiveSheet.Cells(4,2).Font.Size = 11
	.ActiveSheet.Cells(4,2).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE ESTRXLS_STD_GIACXPROD
************************************************************************

PARAMETER _TITOLO1,_TITOLO2,_TITOLO3

IF PARAMETERS() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PARAMETERS() < 2
	_TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
	_TITOLO2 = ""
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .F.
objExcel.Workbooks.Add()
objExcel.ActiveWindow.Zoom = 75

WITH objExcel
	*.Cells.Select
	.Range("A1").Select
	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
ENDWITH

*********************************
*** VALORIZZAZIONE COSTANTI EXCEL
*********************************
xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlThick		 = 4

xlCenter = -4108

xlExpression = 2
xlCellValue = 1
xlGreater = 5
xlLess = 6
xlEqual = 3
xlAutomatic = -4105


**********************************************
*** SCRITTURA INTESTAZIONE PRODOTTI E DETTAGLI
**********************************************
SELECT PRODOTTI AS PRODOTTO, QUANTI FROM CU_GIACXPROD_DETT WHERE FLGMAIN ORDER BY PRODOTTO INTO CURSOR CX_PRODOTTI

_nColonnePerProdotto = 5
_nColonnaIniziale = 1
_nRigaIniziale = 6
_nProdotto = 0
_nRigaMax = 0
_nColonnaMax = 0
_nProdottiMax = 0

SELECT CX_PRODOTTI
GO TOP
SCAN
	_nProdotto = _nProdotto + 1
	
	_nProdottiMax = _nProdotto 
	
	_PRODOTTO = ALLTRIM(PRODOTTO)
	
	WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettaglio prodotto " + ALLTRIM(_PRODOTTO) + " ..." NOWAIT
	
	* SCRITTURA INTESTAZIONE PRODOTTO
	_nRiga = _nRigaIniziale
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_nProdotto - 1)) + 1
	_VALORE = ALLTRIM(PRODOTTO)
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		.Value = _VALORE
		*.Font.Size = 10
		.Font.Bold = .T.
		.Borders(xlEdgeLeft).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeRight).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeTop).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
	ENDWITH
	
	_nRiga = _nRigaIniziale
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_nProdotto - 1)) + 1 + 1
	_VALORE = QUANTI
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		.Value = _VALORE
		*.Font.Size = 10
		.Font.Bold = .T.
		.Borders(xlEdgeLeft).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeRight).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeTop).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
	ENDWITH
	
	* SCRITTURA DETTAGLI ARTICOLI
	SELECT * FROM CU_GIACXPROD_DETT WHERE !FLGMAIN AND ALLTRIM(GRUPPO) == ALLTRIM(_PRODOTTO) ORDER BY CODART INTO CURSOR CX_PRODOTTI_DETT
	SELECT CX_PRODOTTI_DETT
	GO TOP
	_nRiga = _nRigaIniziale + 2
	SCAN
		_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_nProdotto - 1)) + 1
		FOR _I = 1 TO _nColonnePerProdotto
			DO CASE
				CASE _I = 1
					_VALORE = ALLTRIM(CODART)
				CASE _I = 2
					_VALORE = DISQTA
				CASE _I = 3
					_VALORE = ALLTRIM(DESART)
				CASE _I = 4
					_VALORE = NULL
				CASE _I = 5
					_VALORE = NULL
			ENDCASE
			_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			WITH objExcel.Selection
				.Value = _VALORE
				IF _I = 4
					.Borders(xlEdgeRight).LineStyle = xlContinuous
					.Borders(xlEdgeRight).Weight = xlThick
				ENDIF
			ENDWITH
			
			_nRigaMax = MAX(_nRigaMax,_nRiga)
			_nColonnaMax = MAX(_nColonnaMax,_nColonna)
			
			_nColonna = _nColonna + 1
		ENDFOR
		_nRiga = _nRiga + 1
	ENDSCAN
ENDSCAN

*****************************
*** RIDIMENSIONAMENTO COLONNE
*****************************
FOR _H = 1 TO _nProdotto
	FOR _I = 1 TO _nColonnePerProdotto
		_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_H - 1)) + _I
		_RangeColumn = n2c(_nColonna) + ":" + n2c(_nColonna)
		DO CASE
			CASE _I = 1
				_WIDTH = 15
			CASE _I = 2
				_WIDTH = 6
			CASE _I = 3
				_WIDTH = 20
			CASE _I = 4
				_WIDTH = 6
			CASE _I = 5
				_WIDTH = 6
		ENDCASE
		objExcel.ActiveSheet.Columns(_RangeColumn).ColumnWidth = _WIDTH 
	ENDFOR
ENDFOR

**************************************************************
*** FORMATTAZIONE CONDIZIONALE GIACENZE MINORI O UGUALI A ZERO
**************************************************************

* SELEZIONE CELLE QTA' RIMANANTE 
_RangeColumnRow = ""
FOR _H = 1 TO _nProdotto
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_H - 1)) + 4
	_RangeColumnRow = _RangeColumnRow + IIF(EMPTY(_RangeColumnRow),"",";") + ;
		n2c(_nColonna) + ALLTRIM(STR(_nRigaIniziale + 2,10,0)) + ":" + n2c(_nColonna) + ALLTRIM(STR(_nRigaMax,10,0))
ENDFOR
objExcel.ActiveSheet.Range(_RangeColumnRow).Select

* CELLE QTA' RIMANANTE CON CARATTERE ROSSO GRASSETTO SE UGUALI A ZERO
objExcel.Selection.FormatConditions.Add(xlCellValue, xlEqual, "0")
objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
With objExcel.Selection.FormatConditions(1).Font
	.Bold = .T.
	.Italic = .F.
	.Color = RGB(255,0,0)
	.TintAndShade = 0
EndWith
objExcel.Selection.FormatConditions(1).StopIfTrue = .T.

* CELLE QTA' RIMANANTE CON SFONDO ROSSO E CARATTERE GRASSETTO BIANCO SE MINORI DI ZERO
objExcel.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
With objExcel.Selection.FormatConditions(1).Font
	.Bold = .T.
	.Italic = .F.
	.Color = RGB(255,255,255)
	.TintAndShade = 0
EndWith
With objExcel.Selection.FormatConditions(1).Interior
	.PatternColorIndex = xlAutomatic
	.Color = 255
	.TintAndShade = 0
EndWith
objExcel.Selection.FormatConditions(1).StopIfTrue = .T.


* SELEZIONE CELLE DESCRIZIONE
_RangeColumnRow = ""
_1stCellRef = ""
FOR _H = 1 TO _nProdotto
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_H - 1)) + 3
	_RangeColumnRow = _RangeColumnRow + IIF(EMPTY(_RangeColumnRow),"",";") + ;
		n2c(_nColonna) + ALLTRIM(STR(_nRigaIniziale + 2,10,0)) + ":" + n2c(_nColonna) + ALLTRIM(STR(_nRigaMax,10,0))
	IF EMPTY(_1stCellRef)
		_1stCellRef = n2c(_nColonna + 1) + ALLTRIM(STR(_nRigaIniziale + 2,10,0))
	ENDIF
ENDFOR
objExcel.ActiveSheet.Range(_RangeColumnRow).Select

* CELLE DESCRIZIONE CON CARATTERE ROSSO GRASSETTO SE QTA' RIMANANTE MINORE O UGUALE A ZERO
objExcel.Selection.FormatConditions.Add(xlExpression, , "=" + _1stCellRef + "<=0")
objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
With objExcel.Selection.FormatConditions(1).Font
	.Bold = .T.
	.Italic = .F.
	.Color = RGB(255,0,0)
	.TintAndShade = 0
EndWith
objExcel.Selection.FormatConditions(1).StopIfTrue = .T.


*******************************
*** SCRITTURA DETTAGLI GIACENZE
*******************************

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettagli giacenze..." NOWAIT

SELECT CODART, DESART, GIACEN, QTAPRD, QTAORF FROM CU_GIACXPROD_DETT WHERE !FLGMAIN GROUP BY CODART, DESART, GIACEN, QTAPRD, QTAORF ORDER BY CODART INTO CURSOR CX_ART_GIACEN

* SCRITTURA LINEA DI SEPARAZIONE
_nRiga = _nRigaMax + 3
_Range = n2c(_nColonnaIniziale + 1) + ALLTRIM(STR(_nRiga,10,0)) + ":" + n2c(_nColonnaMax) + ALLTRIM(STR(_nRiga,10,0))
objExcel.ActiveSheet.Range(_Range).Select
WITH objExcel.Selection
	.Borders(xlEdgeBottom).LineStyle = xlContinuous
	.Borders(xlEdgeBottom).Weight = xlThick
ENDWITH

* SCRITTURA INTESTAZIONI DI COLONNA
_nRiga = _nRiga + 3
_nColonna = _nColonnaIniziale
FOR _I = 1 TO 3
	_nColonna = _nColonna + 1
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		DO CASE
			CASE _I = 1
				.Value = "CODICE"
			CASE _I = 2
				.Value = "GIACENZA"
			CASE _I = 3
				.Value = "ARTICOLI COMUNI"
		ENDCASE
		.Font.Bold = .T.
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		.Borders(xlEdgeBottom).Weight = xlThin
	ENDWITH
ENDFOR

_nColonna = _nColonna + 3
_nColonnaSave = _nColonna
FOR _I = 1 TO _nProdottiMax + 6
	_nColonna = _nColonna + 1
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		DO CASE
			CASE _I = 1
				.Value = "FABBISOGNO PER PRODOTTO"
			CASE _I = _nProdottiMax + 2
				.Value = "FABBISOGNO TOTALE"
			CASE _I = _nProdottiMax + 3
				.Value = "QTA' GIA' IN PRODUZIONE"
			CASE _I = _nProdottiMax + 4
				IF _R_OPZORF
					.Value = "QTA' IN ORD.FORN."
				ENDIF
			CASE _I = _nProdottiMax + 5
				.Value = "NUOVA GIACENZA"
			CASE _I = _nProdottiMax + 6
				.Value = "QTA' DA ORDINARE"
		ENDCASE
		.Font.Bold = .T.
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		.Borders(xlEdgeBottom).Weight = xlThin
	ENDWITH
ENDFOR

_nRiga = _nRiga + 1

_nColonna = _nColonnaSave
FOR _I = 1 TO _nProdottiMax
	_nColonna = _nColonna + 1
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	_cValore = "R" + ALLTRIM(STR(_nRigaIniziale)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 1))
	objExcel.ActiveCell.FormulaR1C1 = '=' + _cValore
	objExcel.Selection.Font.Bold = .T.
	objExcel.Selection.HorizontalAlignment = xlCenter
ENDFOR


_nRigaIniGiac = 0
_nRigaFinGiac = 0
_nColonnaIniGiac = _nColonnaIniziale + 1
_nColonnaFinGiac = 0

* SCRITTURA DETTAGLI ARTICOLI COMPONENTI
SELECT CX_ART_GIACEN
GO TOP
SCAN
	WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettagli giacenza " + ;
		ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) + " ..." NOWAIT
	
	_nRiga = _nRiga + 1
	IF _nRigaIniGiac = 0
		_nRigaIniGiac = _nRiga
	ENDIF
	_nRigaFinGiac = _nRiga
	_nColonna = _nColonnaIniziale
	FOR _I = 1 TO 3
		_nColonna = _nColonna + 1
		_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		WITH objExcel.Selection
			DO CASE
				CASE _I = 1
					.Value = ALLTRIM(CODART)
				CASE _I = 2
					.Value = GIACEN
					.Font.Color = RGB(0,0,255)
				CASE _I = 3
					.Value = ALLTRIM(DESART)
			ENDCASE
		ENDWITH
	ENDFOR
	
	_nColonna = _nColonna + 3
	FOR _I = 1 TO _nProdottiMax + 6
		_nColonna = _nColonna + 1
		_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		
		IF _I >= 1 AND _I <= _nProdottiMax
			WITH objExcel
				_cValore = "RC" + ALLTRIM(STR(_nColonnaIniGiac,10,0))
				_cMatriceTabella = "R" + ALLTRIM(STR(_nRigaIniziale + 2)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 1)) + ;
					":" + "R" + ALLTRIM(STR(_nRigaMax)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 2))
				_cMoltiplicatore = "R" + ALLTRIM(STR(_nRigaIniziale)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 2))
				*.ActiveCell.FormulaR1C1 = '=IfError(VLOOKUP(' + _cValore + ',' + _cMatriceTabella + ',2,FALSE)*' + _cMoltiplicatore + ',"")'
				*** LA FUNZIONE "IFERROR" ESISTE A PARTIRE DALLA VERSIONE EXCEL 2007 IN POI: SOSTITUISCO CON "IF(ISERROR..."
				_cVlookupFormula = 'VLOOKUP(' + _cValore + ',' + _cMatriceTabella + ',2,FALSE)*' + _cMoltiplicatore
				.ActiveCell.FormulaR1C1 = '=IF(ISERROR(' + _cVlookupFormula + '),"",' + _cVlookupFormula + ')'
				
				.Selection.Borders(xlEdgeLeft).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeLeft).Weight = xlThin
				.Selection.Borders(xlEdgeRight).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeRight).Weight = xlThin
				.Selection.Borders(xlEdgeBottom).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeBottom).Weight = xlThin
				.Selection.Borders(xlEdgeTop).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeTop).Weight = xlThin
				.Selection.Font.Color = RGB(0,0,255)
			ENDWITH
		ENDIF
		
		IF _I = _nProdottiMax + 2
			WITH objExcel
				.ActiveCell.FormulaR1C1 = "=SUM(RC[-" + ALLTRIM(STR(_nProdottiMax + 1)) + "]:RC[-2])"
				.Selection.Borders(xlEdgeLeft).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeLeft).Weight = xlThin
				.Selection.Borders(xlEdgeRight).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeRight).Weight = xlThin
				.Selection.Borders(xlEdgeBottom).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeBottom).Weight = xlThin
				.Selection.Borders(xlEdgeTop).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeTop).Weight = xlThin
			ENDWITH
		ENDIF
		
		IF _I = _nProdottiMax + 3 AND QTAPRD > 0
			objExcel.Selection.Value = QTAPRD
		ENDIF
		
		IF _I = _nProdottiMax + 4 AND _R_OPZORF AND QTAORF > 0
			objExcel.Selection.Value = QTAORF
		ENDIF
		
		IF _I = _nProdottiMax + 5
			WITH objExcel
				*.ActiveCell.FormulaR1C1 = "=RC[-" + ALLTRIM(STR(_nProdottiMax + 9)) + "]-RC[-3]"
				IF _R_OPZORF
					.ActiveCell.FormulaR1C1 = "=RC[-" + ALLTRIM(STR(_nProdottiMax + 9)) + "]-RC[-3]-RC[-2]+RC[-1]"
				ELSE
					.ActiveCell.FormulaR1C1 = "=RC[-" + ALLTRIM(STR(_nProdottiMax + 9)) + "]-RC[-3]-RC[-2]"
				ENDIF
				.Selection.Font.Bold = .T.
			ENDWITH
			_nColonnaFinGiac = MAX(_nColonnaFinGiac,_nColonna)
		ENDIF
		
		IF _I = _nProdottiMax + 6
			WITH objExcel
				.ActiveCell.FormulaR1C1 = '=IF(RC[-1] < 0, -1 * RC[-1],"")'
			ENDWITH
		ENDIF
		
	ENDFOR
ENDSCAN


******************************************
*** VALORIZZAZIONE DETTAGLI NUOVA GIACENZA
******************************************

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettagli nuova giacenza..." NOWAIT

FOR _H = 1 TO _nProdottiMax

	FOR _nRiga = _nRigaIniziale + 2 TO _nRigaMax

		_nColonna = _nColonnaIniziale + 1 + (_nColonnePerProdotto * (_H - 1)) + 3
		_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga))
		
		objExcel.ActiveSheet.Range(_Range).Select
		
		_cValore = "RC" + ALLTRIM(STR(_nColonna - 3))
		_cMatriceTabella = "R" + ALLTRIM(STR(_nRigaIniGiac)) + "C" + ALLTRIM(STR(_nColonnaIniGiac)) + ;
			":" + "R" + ALLTRIM(STR(_nRigaFinGiac)) + "C" + ALLTRIM(STR(_nColonnaFinGiac))
		_cIndice = ALLTRIM(STR(_nColonnaFinGiac - 1))
		
		objExcel.ActiveCell.FormulaR1C1 = '=IF(AND(' + _cValore + ' <> """",NOT(ISBLANK(' + _cValore + '))) ,VLOOKUP(' + _cValore + ',' + ;
			_cMatriceTabella + ',' + _cIndice + ',FALSE),"")'
		
	ENDFOR
ENDFOR


*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,4).Value = _TITOLO1
	.ActiveSheet.Cells(2,4).Font.Bold = .T.
	.ActiveSheet.Cells(2,4).Font.Size = 16
	.ActiveSheet.Cells(2,4).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,4).Value = _TITOLO2
	.ActiveSheet.Cells(3,4).Font.Bold = .T.
	.ActiveSheet.Cells(3,4).Font.Size = 14
	.ActiveSheet.Cells(3,4).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,4).Value = _TITOLO3
	.ActiveSheet.Cells(4,4).Font.Bold = .T.
	.ActiveSheet.Cells(4,4).Font.Size = 14
	.ActiveSheet.Cells(4,4).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

MESSAGEBOX("Creazione foglio excel terminata",64,"Informazione")

ENDPROC

************************************************************************
PROCEDURE ESTRXLS_BILANCIO_SEZIONI_CONTRAPPOSTE
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
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,VA_TOTALE,VD_TOTALE

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel 
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 10
   .Range("A1").Select
   
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select 	&& carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 		&& imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Height = 50 				&& regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  					&& allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  					&& allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

ENDWITH


** CONTA NUMERO CAMPI CURSORE
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

_RIGA_INIZIALE = 6

** FORMATTAZIONE DI TUTTE LE CELLE DEL FILE EXCEL IN BASE AI CAMPI DEL CURSORE
FOR I = 1 TO _NUMEROCAMPI
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 12
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

WITH objExcel
	.ActiveSheet.Cells(2,3).Value = _TITOLO1
	.ActiveSheet.Cells(2,3).Font.Bold = .T.
	.ActiveSheet.Cells(2,3).Font.Size = 12
	.ActiveSheet.Cells(2,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,3).Value = _TITOLO2
	.ActiveSheet.Cells(3,3).Font.Bold = .T.
	.ActiveSheet.Cells(3,3).Font.Italic = .T.
	.ActiveSheet.Cells(3,3).Font.Size = 12
	.ActiveSheet.Cells(3,3).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,3).Value = _TITOLO3
	.ActiveSheet.Cells(4,3).Font.Bold = .T.
	.ActiveSheet.Cells(4,3).Font.Size = 12
	.ActiveSheet.Cells(4,3).HorizontalAlignment = 1
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
   
   ** SE MASTRO MOSTRA TUTTA LA RIGA DARE IN GRASSETTO   
   _lFontBoldDa = .F.
   IF LEN(ALLTRIM(da_codcon)) <  PUB_SOTTOG 
      _lFontBoldDa = .T.
   ENDIF

   ** SE MASTRO MOSTRA TUTTA LA RIGA DARE IN GRASSETTO   
   _lFontBoldAv = .F.
   IF LEN(ALLTRIM(av_codcon)) <  PUB_SOTTOG 
      _lFontBoldAv = .T.
   ENDIF
      
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
      IF TYPE(_NOMECAMPO) = "N" AND _VALORE = 0
	  ELSE
	  	  objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
	  ENDIF
	  
	  IF _lFontBoldDa AND I >= 1 AND I <= 3
         objExcel.Selection.Font.Bold = .T.
	  ENDIF
	  
	  IF _lFontBoldAv AND I >= 5 AND I <= 7
         objExcel.Selection.Font.Bold = .T.
	  ENDIF
   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

*** TOTALI
_T_RIGA  = _nRIGA + 1
_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1

IF ALLTRIM(_TITOLO2) = "Stato Patrimoniale"
	
	** PRENDERE I VALORI IN BASE ALLA POSIZIONE DELLE CELLE NEL CURSORE 1,2,3,5,6,7
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,1).Value = 'CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'DESCRIZIONE CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'SALDO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,5).Value = "CONTO" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,6).Value = "DESCRIZIONE CONTO" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,7).Value = 'SALDO' 
	
	** CICLO PER NON MOSTRARE NEL FOGLIO EXCELL IL CAMPO ZA_SALDOI CONTENUTO NEL CURSORE
	FOR U = 1 TO 100
		IF (objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,U).Value = 'ZA_SALDOI')
			objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,U).Value = '' 
		ENDIF
	ENDFOR
	** CICLO PER NON MOSTRARE NEL FOGLIO EXCELL IL CAMPO ZA_SALDOI CONTENUTO NEL CURSORE
	
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

	** NON MOSTRA COLONNE IDENTIFICATE CON D,H,I
	objExcel.ActiveSheet.Columns("D").Delete
	objExcel.ActiveSheet.Columns("G").Delete
	objExcel.ActiveSheet.Columns("H").Delete
	objExcel.ActiveSheet.Columns("I").Delete
	objExcel.ActiveSheet.Columns("J").Delete
	objExcel.ActiveSheet.Columns("L").Delete
	objExcel.ActiveSheet.Columns("M").Delete
	objExcel.ActiveSheet.Columns("N").Delete
	objExcel.ActiveSheet.Columns("O").Delete
	objExcel.ActiveSheet.Columns("P").Delete
	objExcel.ActiveSheet.Columns("Q").Delete
	objExcel.ActiveSheet.Columns("R").Delete
	objExcel.ActiveSheet.Columns("S").Delete
	objExcel.ActiveSheet.Columns("T").Delete
	objExcel.ActiveSheet.Columns("U").Delete
	objExcel.ActiveSheet.Columns("V").Delete
	objExcel.ActiveSheet.Columns("W").Delete
	objExcel.ActiveSheet.Columns("X").Delete
	objExcel.ActiveSheet.Columns("Y").Delete
	objExcel.ActiveSheet.Columns("Z").Delete
	

	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Value = 'Riepilogo totali Attività/Passività'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Value = 'Totale'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Value = ROUND(VA_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Value = ROUND(VD_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Value = "Risultato d'esercizio in corso"
	IF VA_TOTALE<VD_TOTALE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = round(va_totale,2)-round(vd_totale,2)
		objExcel.ActiveSheet.Cells(_T_RIGA+4,4).NumberFormat = "#,##0.00"
	ELSE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = ''
	ENDIF
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = round(va_totale,2)-round(vd_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Value = 'Totale a pareggio'
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Value = round(vd_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Value = round(va_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).NumberFormat = "#,##0.00"
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Font.Bold = .T.
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Italic = .T.

ENDIF


IF ALLTRIM(_TITOLO2) = "Conto Economico"
	

	** PRENDERE I VALORI IN BASE ALLA POSIZIONE DELLE CELLE NEL CURSORE 1,2,3,5,6,7
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,1).Value = 'CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'DESCRIZIONE CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'SALDO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,5).Value = "CONTO" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,6).Value = "DESCRIZIONE CONTO" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,7).Value = 'SALDO' 
	
	** CICLO PER NON MOSTRARE NEL FOGLIO EXCELL IL CAMPO ZA_SALDOI CONTENUTO NEL CURSORE
	FOR U = 1 TO 100
		IF (objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,U).Value = 'ZA_SALDOI')
			objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,U).Value = '' 
		ENDIF
	ENDFOR
	** CICLO PER NON MOSTRARE NEL FOGLIO EXCELL IL CAMPO ZA_SALDOI CONTENUTO NEL CURSORE


	** NON MOSTRA COLONNE IDENTIFICATE CON D,H,I
	objExcel.ActiveSheet.Columns("D").Delete
	objExcel.ActiveSheet.Columns("G").Delete
	objExcel.ActiveSheet.Columns("H").Delete
	objExcel.ActiveSheet.Columns("I").Delete
	objExcel.ActiveSheet.Columns("J").Delete
	objExcel.ActiveSheet.Columns("L").Delete
	objExcel.ActiveSheet.Columns("M").Delete
	objExcel.ActiveSheet.Columns("N").Delete
	objExcel.ActiveSheet.Columns("O").Delete
	objExcel.ActiveSheet.Columns("P").Delete
	objExcel.ActiveSheet.Columns("Q").Delete
	objExcel.ActiveSheet.Columns("R").Delete
	objExcel.ActiveSheet.Columns("S").Delete
	objExcel.ActiveSheet.Columns("T").Delete
	objExcel.ActiveSheet.Columns("U").Delete
	objExcel.ActiveSheet.Columns("V").Delete
	objExcel.ActiveSheet.Columns("W").Delete
	objExcel.ActiveSheet.Columns("X").Delete
	objExcel.ActiveSheet.Columns("Y").Delete
	objExcel.ActiveSheet.Columns("Z").Delete
	
	

	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Value = 'Riepilogo totali Costi/Ricavi'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Value = 'Totale'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Value = ROUND(VA_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Value = ROUND(VD_TOTALE,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Value = "Risultato d'esercizio in corso"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = round(vd_totale,2)-round(va_totale,2)
	IF va_totale>=vd_totale
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = round(vd_totale,2)-round(va_totale,2)
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).NumberFormat = "#,##0.00"
	ELSE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = ''
	ENDIF
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Value = 'Totale a pareggio'
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Value = round(vd_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Value = round(va_totale,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).NumberFormat = "#,##0.00"
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Font.Bold = .T.
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Italic = .T.

ENDIF


objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR

RETURN


************************************************************************
PROCEDURE ESTRXLS_BILANCIO_CENTRO_COSTO_SEZIONI_CONTRAPPOSTE 
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
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_TITOLO4,_TITOLO5,VA_TOTALE_CCOS,VD_TOTALE_CCOS 

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel 
   .Range("A1:IV65536").Select
   .Selection.Font.Size = 10
   .Range("A1").Select
   

   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select 	&& carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 		&& imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Height = 50 				&& regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  					&& allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  					&& allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

ENDWITH


** CONTA NUMERO CAMPI CURSORE
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

_RIGA_INIZIALE = 9

** FORMATTAZIONE DI TUTTE LE CELLE DEL FILE EXCEL IN BASE AI CAMPI DEL CURSORE
FOR I = 1 TO _NUMEROCAMPI
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 12
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

   ** SE MASTRO MOSTRA TUTTA LA RIGA DARE IN GRASSETTO   
   _lFontBoldDa = .F.
   IF LEN(ALLTRIM(da_codcon)) <  PUB_SOTTOG 
      _lFontBoldDa = .T.
   ENDIF

   ** SE MASTRO MOSTRA TUTTA LA RIGA DARE IN GRASSETTO   
   _lFontBoldAv = .F.
   IF LEN(ALLTRIM(av_codcon)) <  PUB_SOTTOG 
      _lFontBoldAv = .T.
   ENDIF

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
      IF TYPE(_NOMECAMPO) = "N" AND _VALORE = 0
	  ELSE
	  	  objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
	  ENDIF

	  IF _lFontBoldDa AND I >= 1 AND I <= 3
         objExcel.Selection.Font.Bold = .T.
	  ENDIF
	  
	  IF _lFontBoldAv AND I >= 5 AND I <= 7
         objExcel.Selection.Font.Bold = .T.
	  ENDIF

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TOTALI
_T_RIGA  = _nRIGA + 1
_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1


IF ALLTRIM(_TITOLO2) = "Conto Economico"
	

	** PRENDERE I VALORI IN BASE ALLA POSIZIONE DELLE CELLE NEL CURSORE 1,2,3,5,6,7
	objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,1).Value = 'CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,2).Value = 'DESCRIZIONE CONTO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,3).Value = 'SALDO' 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,5).Value = "CONTO" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,6).Value = "DESCRIZIONE CONTO" 
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,7).Value = 'SALDO' 
	
	** CICLO PER NON MOSTRARE NEL FOGLIO EXCELL IL CAMPO ZA_SALDOI CONTENUTO NEL CURSORE
	FOR U = 1 TO 100
		IF (objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,U).Value = 'ZA_SALDOI')
			objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,U).Value = '' 
		ENDIF
	ENDFOR
	** CICLO PER NON MOSTRARE NEL FOGLIO EXCELL IL CAMPO ZA_SALDOI CONTENUTO NEL CURSORE


	** NON MOSTRA COLONNE IDENTIFICATE CON D,H,I
	objExcel.ActiveSheet.Columns("D").Delete
	objExcel.ActiveSheet.Columns("G").Delete
	objExcel.ActiveSheet.Columns("H").Delete
	objExcel.ActiveSheet.Columns("I").Delete
	objExcel.ActiveSheet.Columns("J").Delete
	objExcel.ActiveSheet.Columns("L").Delete
	objExcel.ActiveSheet.Columns("M").Delete
	objExcel.ActiveSheet.Columns("N").Delete
	objExcel.ActiveSheet.Columns("O").Delete
	objExcel.ActiveSheet.Columns("P").Delete
	objExcel.ActiveSheet.Columns("Q").Delete
	objExcel.ActiveSheet.Columns("R").Delete
	objExcel.ActiveSheet.Columns("S").Delete
	objExcel.ActiveSheet.Columns("T").Delete
	objExcel.ActiveSheet.Columns("U").Delete
	objExcel.ActiveSheet.Columns("V").Delete
	objExcel.ActiveSheet.Columns("W").Delete
	objExcel.ActiveSheet.Columns("X").Delete
	objExcel.ActiveSheet.Columns("Y").Delete
	objExcel.ActiveSheet.Columns("Z").Delete
	
	

	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Value = 'Riepilogo totali Costi/Ricavi'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Value = 'Totale'
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Value = ROUND(va_totale_ccos,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Value = ROUND(vd_totale_ccos ,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Value = "Risultato d'esercizio in corso"
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Value = round(vd_totale_ccos ,2)-round(va_totale_ccos,2)
	IF va_totale_ccos>=vd_totale_ccos 
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = round(vd_totale_ccos ,2)-round(va_totale_ccos,2)
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).NumberFormat = "#,##0.00"
	ELSE
		objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Value = ''
	ENDIF
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Value = 'Totale a pareggio'
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Value = round(vd_totale_ccos ,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).NumberFormat = "#,##0.00"
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Value = round(va_totale_ccos,2)
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).NumberFormat = "#,##0.00"
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,5).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,4).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,5).Font.Bold = .T.
	
	objExcel.ActiveSheet.Cells(_T_RIGA+2,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+3,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+4,2).Font.Italic = .T.
	objExcel.ActiveSheet.Cells(_T_RIGA+5,2).Font.Italic = .T.

ENDIF


WITH objExcel
	.ActiveSheet.Cells(2,5).Value = _TITOLO1
	.ActiveSheet.Cells(2,5).Font.Bold = .T.
	.ActiveSheet.Cells(2,5).Font.Size = 12
	.ActiveSheet.Cells(2,5).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,5).Value = _TITOLO2
	.ActiveSheet.Cells(3,5).Font.Bold = .T.
	.ActiveSheet.Cells(3,5).Font.Italic = .T.
	.ActiveSheet.Cells(3,5).Font.Size = 12
	.ActiveSheet.Cells(3,5).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,5).Value = _TITOLO3
	.ActiveSheet.Cells(4,5).Font.Bold = .T.
	.ActiveSheet.Cells(4,5).Font.Size = 12
	.ActiveSheet.Cells(4,5).HorizontalAlignment = 1
	
	.ActiveSheet.Cells(5,5).Value = ""
	.ActiveSheet.Cells(5,5).Font.Bold = .T.
	.ActiveSheet.Cells(5,5).Font.Size = 12
	.ActiveSheet.Cells(5,5).HorizontalAlignment = 1
	
	.ActiveSheet.Cells(6,5).Value = _TITOLO4
	.ActiveSheet.Cells(6,5).Font.Bold = .T.
	.ActiveSheet.Cells(6,5).Font.Size = 12
	.ActiveSheet.Cells(6,5).HorizontalAlignment = 1
	
	.ActiveSheet.Cells(7,5).Value = _TITOLO5
	.ActiveSheet.Cells(7,5).Font.Bold = .T.
	.ActiveSheet.Cells(7,5).Font.Size = 12
	.ActiveSheet.Cells(7,5).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
   
objExcel.Visible = .t.

WAIT CLEAR

RETURN




************************************************************************
PROCEDURE ESTRXLS_SIT100
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri, personalizzato per la funzione di esportazione excel per SIT100
*
* Sintassi:
* 
* DO ESTRXLS WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
* <subtotale>                   : subtotale di tutti i valori numerici alla fine del file excel [booleano .t./.f.]
* <def_decimali>                : esiste un cursore dal nome 'CUR_ESTRXLS_DEF_DECIMALS' dal quale dedurre i decimali da riportare per i campi numerici [booleano .t./.f.]
*
********************************************************************************************************************
                                                                                
*PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS,_OBJGRIDRIF
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS,_OBJGRIDRIF,_NOMEFILE  && ERASMO - 27/09/2019

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF

*** PARAMETRO PER LA SCRITTURA DEI TOTALI GENERALI A FINE TABELLA, CON DEFAULT A TRUE
IF PARAMETERS() < 5
   _SUBTOTALS = .T.
ENDIF

*** PARAMETRO PER LA SEGNALAZIONE CHE NEL CURSORE DAL NOME 'CUR_ESTRXLS_DEF_DECIMALS' SONO DEFINITI I DECIMALI DA RIPORTARE PER I CAMPI NUMERICI, CON DEFAULT A FALSE
IF PARAMETERS() < 6
   _DEFDECIMALS = .F.
ENDIF

**=> ERASMO - INIZIO 27/09/2019
IF PARAMETERS() < 7
   _OBJGRIDRIF = .F.
ENDIF

IF PARAMETERS() < 8
   _NOMEFILE = ""
ENDIF
**=> ERASMO - FINE 27/09/2019

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
   .Range("A1:IV65536").Select
   .Range("A1").Select

   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
      .Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF
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

_RIGA_INIZIALE = 7

*FOR I = 1 TO _NUMEROCAMPI
FOR I = 1 TO _NUMEROCAMPI + 5  && ERASMO - 26/06/2019 - AGGIUNTA CAMPI VARIABILI CON FORMULE
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

*_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI + 5) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))  && ERASMO - 26/06/2019
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

*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

**=> ERASMO - INIZIO 26/06/2019
_Range = n2c(_NUMEROCAMPI + 1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select
objExcel.Selection.Interior.Color = 5296274

_Range = n2c(_NUMEROCAMPI + 2) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI + 5) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select
objExcel.Selection.Interior.Color = 65535

xlCenter    = -4108
xlAutomatic = -4105
xlCellValue = 1
xlEqual		= 3
xlLess		= 6
**=> ERASMO - FINE 26/06/2019

**=> ERASMO - INIZIO 07/02/2020
CREATE CURSOR TMP_DATE_FIELDS (FLDNAME C(30))
INDEX ON FLDNAME TAG I_FLDNAME
**=> ERASMO - FINE 07/02/2020

_nRIGA = _RIGA_INIZIALE + 1
SELECT &_NOMECUR
GO TOP
SCAN
   
*!*	   IF CODART = '16002379'
*!*		      SET STEP ON
*!*	   ENDIF
   
   WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
   
   FOR I = 1 TO _NUMEROCAMPI
      _Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      _NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
      _VALORE = &_NOMECAMPO
      
      IF TYPE(_NOMECAMPO) = "C"
         _VALORE = ALLTRIM(&_NOMECAMPO)
		 *** SE DATA ROVESCIATA, LA RIBALTO
		 IF SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/'
		 	*_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
		 	**=> ERASMO - INIZIO 07/02/2020
			SELECT TMP_DATE_FIELDS
			SET ORDER TO I_FLDNAME
			GO TOP
			_SEEK = ALLTRIM(_NOMECAMPO)
			SEEK _SEEK
			IF !FOUND()
				APPEND BLANK
				REPLACE FLDNAME WITH _NOMECAMPO
			ENDIF
			SELECT &_NOMECUR
		 	**=> ERASMO - FINE 07/02/2020
		 ENDIF
      ENDIF
      
      objExcel.ActiveSheet.Range(_Range).Select
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
            
      SELECT &_NOMECUR
      IF CONSIST < 0
         objExcel.Selection.Interior.Color = RGB(255,128,0)
      ELSE
         IF QTADISP < 0
            objExcel.Selection.Interior.Color = RGB(255,255,0)
         ENDIF
      ENDIF
   ENDFOR
   
   **=> ERASMO - INIZIO 26/06/2019
   FOR I = _NUMEROCAMPI + 1 TO _NUMEROCAMPI + 5
      _Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      
      objExcel.ActiveSheet.Range(_Range).Select
      
      DO CASE
         CASE I = _NUMEROCAMPI + 1
            *objExcel.ActiveCell.FormulaR1C1 = "=RC[-10]/12"
            *objExcel.ActiveCell.FormulaR1C1 = "=RC[-12]/12"  && ERASMO - 29/01/2020
            objExcel.ActiveCell.FormulaR1C1 = "=RC[-13]/12"  && ERASMO - 11/11/2025
            objExcel.Selection.NumberFormat = "#,##0"
      
         CASE I = _NUMEROCAMPI + 2
            *objExcel.ActiveCell.FormulaR1C1 = "=(RC[-14]+RC[-10])/" + ALLTRIM(STR(MONTH(DATE()),2,0))
            *objExcel.ActiveCell.FormulaR1C1 = "=(RC[-16]+RC[-12])/" + ALLTRIM(STR(MONTH(DATE()),2,0))  && ERASMO - 29/01/2020
            objExcel.ActiveCell.FormulaR1C1 = "=(RC[-17]+RC[-13])/" + ALLTRIM(STR(MONTH(DATE()),2,0))  && ERASMO - 11/11/2025
            objExcel.Selection.NumberFormat = "#,##0"
            
         CASE I = _NUMEROCAMPI + 3
            *objExcel.ActiveCell.FormulaR1C1 = "=RC[-10]+RC[-6]+RC[-5]"
            *objExcel.ActiveCell.FormulaR1C1 = "=RC[-10]+RC[-8]+RC[-6]+RC[-5]"  && ERASMO - 16/09/2019
            *objExcel.ActiveCell.FormulaR1C1 = "=RC[-12]+RC[-10]+RC[-8]+RC[-7]"  && ERASMO - 29/01/2020
            objExcel.ActiveCell.FormulaR1C1 = "=RC[-13]+RC[-11]+RC[-9]+RC[-8]"  && ERASMO - 11/11/2025
            objExcel.Selection.NumberFormat = "#,##0"
            
            objExcel.Selection.FormatConditions.Add(xlCellValue, xlLess, "=0")
            objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
            objExcel.Selection.FormatConditions(1).Font.Color = -16776961
            objExcel.Selection.FormatConditions(1).Font.TintAndShade = 0      
            objExcel.Selection.FormatConditions(1).StopIfTrue = .F.

         CASE I = _NUMEROCAMPI + 4
            *objExcel.ActiveCell.FormulaR1C1 = '=IF((RC[-6]+RC[-7])>(RC[-2]/2),"OK","ALERT")'
            *objExcel.ActiveCell.FormulaR1C1 = '=IF(RC[-2]<1,"N.A.",IF(RC[-1]>(RC[-2]/2),"OK",IF(RC[-1]<(RC[-2]/2),"ALERT")))'  && ERASMO - 16/09/2019
            **=> ERASMO - INIZIO 07/02/2020
            *** Nella prima parte dell'anno (fino a maggio) questa colonna deve far riferimento all'anno precedente
            *** Passati 5 mesi, da giugno in poi deve far riferimento all'anno corrente
            IF SUBSTR(DTOC(DATE()),4,2) <= '05'
            	objExcel.ActiveCell.FormulaR1C1 = '=IF(RC[-3]<1,"N.A.",IF(RC[-1]>(RC[-3]/2),"OK",IF(RC[-1]<(RC[-3]/2),"ALERT")))'
            ELSE
            	objExcel.ActiveCell.FormulaR1C1 = '=IF(RC[-3]<1,"N.A.",IF(RC[-1]>(RC[-3]/2),"OK",IF(RC[-1]<(RC[-3]/2),"ALERT")))'
            ENDIF
            **=> ERASMO - FINE 07/02/2020
            
            objExcel.Selection.NumberFormat = "@"
            objExcel.Selection.HorizontalAlignment = xlCenter
            
            objExcel.Selection.FormatConditions.Add(xlCellValue, xlEqual, "OK")
            objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
            objExcel.Selection.FormatConditions(1).Font.Color = -16752384
            objExcel.Selection.FormatConditions(1).Font.TintAndShade = 0
            objExcel.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
            objExcel.Selection.FormatConditions(1).Interior.Color = 13561798
            objExcel.Selection.FormatConditions(1).Interior.TintAndShade = 0            
            objExcel.Selection.FormatConditions(1).StopIfTrue = .F.
            
            objExcel.Selection.FormatConditions.Add(xlCellValue, xlEqual, "ALERT")
            objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
            objExcel.Selection.FormatConditions(1).Font.Color = -16383844
            objExcel.Selection.FormatConditions(1).Font.TintAndShade = 0
            objExcel.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
            objExcel.Selection.FormatConditions(1).Interior.Color = 13551615
            objExcel.Selection.FormatConditions(1).Interior.TintAndShade = 0            
            objExcel.Selection.FormatConditions(1).StopIfTrue = .F.
            
         CASE I = _NUMEROCAMPI + 5
            *objExcel.ActiveCell.FormulaR1C1 = "=IF(RC[-3]>0,RC[-2]/RC[-3],0)"
            **=> ERASMO - INIZIO 07/02/2020
            *** Nella prima parte dell'anno (fino a maggio) questa colonna deve far riferimento all'anno precedente
            *** Passati 5 mesi, da giugno in poi deve far riferimento all'anno corrente
            IF SUBSTR(DTOC(DATE()),4,2) <= '05'
            	objExcel.ActiveCell.FormulaR1C1 = "=IF(RC[-4]>0,RC[-2]/RC[-4],0)"
            ELSE
            	objExcel.ActiveCell.FormulaR1C1 = "=IF(RC[-3]>0,RC[-2]/RC[-3],0)"
            ENDIF
            **=> ERASMO - FINE 07/02/2020
            objExcel.Selection.NumberFormat = "#,##0"
            
            objExcel.Selection.FormatConditions.Add(xlCellValue, xlLess, "=0")
            objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
            objExcel.Selection.FormatConditions(1).Font.Color = -16776961
            objExcel.Selection.FormatConditions(1).Font.TintAndShade = 0      
            objExcel.Selection.FormatConditions(1).StopIfTrue = .F.
         
      ENDCASE
   ENDFOR
   **=> ERASMO - FINE 26/06/2019
   
   _nRIGA = _nRIGA + 1
ENDSCAN

*** FORMATTAZIONE COLONNE
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_nRIGA-1,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
	
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"
		
		IF _DEFDECIMALS AND USED("CUR_ESTRXLS_DEF_DECIMALS")
			SELECT CUR_ESTRXLS_DEF_DECIMALS
			SET ORDER TO I_FLDNAME
			GO TOP
			_SEEK = ALLTRIM(_NOMECAMPO)
			SEEK _SEEK
			IF FOUND()
				_nDecimals = NDECIMALS
				IF _nDecimals > 0
					_NFORMAT = "#,##0." + REPLICATE('0',_nDecimals)
				ENDIF
			ENDIF
			SELECT &_NOMECUR
		ENDIF
	**=> ERASMO - INIZIO 07/02/2020
	ELSE
		SELECT TMP_DATE_FIELDS
		SET ORDER TO I_FLDNAME
		GO TOP
		_SEEK = ALLTRIM(_NOMECAMPO)
		SEEK _SEEK
		IF FOUND()
			_NFORMAT = "m/d/yyyy"
		ENDIF
		SELECT &_NOMECUR
    **=> ERASMO - FINE 07/02/2020
	ENDIF
    
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR

*** INTESTAZIONI DI COLONNA COME DA GRIGLIA PASSATA NEI PARAMETRI
_T_RIGA = 7
FOR I = 1 TO FCOUNT(_NOMECUR)
	_NOMECAMPO = FIELD(I,_NOMECUR)
	FOR G = 1 TO _OBJGRIDRIF.COLUMNCOUNT
		*IF (ALLTRIM(_OBJGRIDRIF.RECORDSOURCE) + '.' + ALLTRIM(_NOMECAMPO)) = _OBJGRIDRIF.COLUMNS(G).CONTROLSOURCE
		IF (ALLTRIM(_OBJGRIDRIF.RECORDSOURCE) + '.' + ALLTRIM(_NOMECAMPO)) $ ALLTRIM(_OBJGRIDRIF.COLUMNS(G).CONTROLSOURCE)  && ERASMO - 07/02/2020
			_Range = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
			objExcel.Range(_RANGE).Select
			objExcel.Selection.Value = _OBJGRIDRIF.COLUMNS(G).HEADER1.CAPTION
*!*				**=> ERASMO - INIZIO 30/09/2019
*!*				IF !_OBJGRIDRIF.COLUMNS(G).VISIBLE
*!*					objExcel.Selection.EntireColumn.Hidden = .T.
*!*				ENDIF
*!*				**=> ERASMO - FINE 30/09/2019
			EXIT
		ENDIF
	NEXT
ENDFOR

**=> ERASMO - INIZIO 26/06/2019
FOR I = _NUMEROCAMPI + 1 TO _NUMEROCAMPI + 5
      _Range = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
      objExcel.ActiveSheet.Range(_Range).Select
      
      DO CASE
         CASE I = _NUMEROCAMPI + 1
            objExcel.Selection.Value = "Velocità " + SUBSTR(_V_DTPRAL,7,4)
      
         CASE I = _NUMEROCAMPI + 2
            objExcel.Selection.Value = "Velocità al " + PADL(ALLTRIM(STR(MONTH(DATE()),2,0)),2,'0') + "/" + SUBSTR(_V_DTCNAL,7,4)
            
         CASE I = _NUMEROCAMPI + 3
            *objExcel.Selection.Value = "Devices a Magazzino"
            objExcel.Selection.Value = "Magazzino con WIP e OF"  && ERASMO - 16/09/2019

         CASE I = _NUMEROCAMPI + 4
            objExcel.Selection.Value = "Disponib. + WIP > 15gg"
            
         CASE I = _NUMEROCAMPI + 5
            objExcel.Selection.Value = "Autonomia in mesi"
         
      ENDCASE
ENDFOR
**=> ERASMO - FINE 26/06/2019

*** AUTOFIT COLONNE
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
IF _SUBTOTALS
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF

*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
WITH objExcel
	.ActiveSheet.Cells(2,6).Value = _TITOLO1
	.ActiveSheet.Cells(2,6).Font.Bold = .T.
	.ActiveSheet.Cells(2,6).Font.Size = 11
	.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(2,6).WrapText = .F.

	.ActiveSheet.Cells(3,6).Value = _TITOLO2
	.ActiveSheet.Cells(3,6).Font.Bold = .T.
	.ActiveSheet.Cells(3,6).Font.Size = 11
	.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(3,6).WrapText = .F.

	.ActiveSheet.Cells(4,6).Value = _TITOLO3
	.ActiveSheet.Cells(4,6).Font.Bold = .T.
	.ActiveSheet.Cells(4,6).Font.Size = 11
	.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(4,6).WrapText = .F.
ENDWITH

*** AGGIUNGO LEGENDA PER DISPONIBILITA' E CONSISTENZA
WITH objExcel
	.ActiveSheet.Cells(6,1).Value = "Disponibilità < 0"
	.ActiveSheet.Cells(6,1).Font.Bold = .T.
	.ActiveSheet.Cells(6,1).Font.Size = 10
	.ActiveSheet.Cells(6,1).HorizontalAlignment = 1
	.ActiveSheet.Cells(6,1).WrapText = .F.
	.ActiveSheet.Cells(6,1).Interior.Color = RGB(255,255,0)
	.ActiveSheet.Cells(6,2).Interior.Color = RGB(255,255,0)
	.ActiveSheet.Cells(6,3).Interior.Color = RGB(255,255,0)

	.ActiveSheet.Cells(6,5).Value = "Disponibilità e Consistenza < 0"
	.ActiveSheet.Cells(6,5).Font.Bold = .T.
	.ActiveSheet.Cells(6,5).Font.Size = 10
	.ActiveSheet.Cells(6,5).HorizontalAlignment = 1
	.ActiveSheet.Cells(6,5).WrapText = .F.
	.ActiveSheet.Cells(6,5).Interior.Color = RGB(255,128,0)
	.ActiveSheet.Cells(6,6).Interior.Color = RGB(255,128,0)
	.ActiveSheet.Cells(6,7).Interior.Color = RGB(255,128,0)
ENDWITH

objExcel.Range("A1").Select

*objExcel.Visible = .t.

**=> ERASMO - INIZIO 27/09/2019
IF !EMPTY(_NOMEFILE)
	*xlOpenXMLWorkbook = 51
	*objExcel.ActiveWorkbook.SaveAs(_NOMEFILE,xlOpenXMLWorkbook)	
	objExcel.ActiveWorkbook.SaveCopyAs(_NOMEFILE)  && ERASMO - 12/10/2019 - USO IL METODO "SaveCopyAs" IN QUANTO RICHIAMANDO LA PROCEDURA DA UN SERVIZIO WINDOWS (AQ_SERVICE) NON VIENE RICONOSCIUTO IL METODO "SaveAs"
	objExcel.ActiveWorkbook.Close(.F.)
ELSE
	objExcel.Visible = .t.
ENDIF
**=> ERASMO - FINE 27/09/2019

IF USED("CUR_ESTRXLS_DEF_DECIMALS")
	SELECT CUR_ESTRXLS_DEF_DECIMALS
	USE
ENDIF

WAIT CLEAR

ENDPROC



************************************************************************
PROCEDURE ESTRXLS_NON_FORMATTATO
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
* SENZA FORMATTAZIONE
*
********************************************************************************************************************

LOCAL _NOME_REPORT

_NOME_REPORT=SYS(5)+SYS(2003)+"\"+ PUB_CODOPE+SYS(2015)+".XLS"

WAIT WINDOW "ATTENDERE PREGO: creazione excel in corso..." NOWAIT

*COPY TO &_NOME_REPORT TYPE XLS
COPY TO &_NOME_REPORT TYPE XL5  && ERASMO - 16/10/2015

release oexcel
public oexcel

oexcel=createobject("excel.application")
oexcel.Workbooks.Open(_NOME_REPORT)
oexcel.visible=.t.

WAIT CLEAR  && ERASMO - 16/10/2015


*************************************************************************
FUNCTION XLS_TO_VFP_CURSOR
*************************************************************************
* Tale procedura permette l'estrazione dati da un file excel di qualsiasi
* versione e la creazione di un cursore vfp contenente i dati estratti
*************************************************************************

LPARAMETERS _par_nomefile_in,_par_nomecur_out

IF PCOUNT() >= 2
ELSE
	_par_nomecur_out = "CUR_EXCEL"
ENDIF

IF !FILE(_par_nomefile_in)
	MESSAGEBOX("File: " + _par_nomefile_in + " inesistente",16,"Attenzione")
	RETURN .F.
ENDIF

LOCAL _BEFORE_TABLE_SEL
_BEFORE_TABLE_SEL = SELECT()

gnErrFile = FOPEN(_par_nomefile_in,12)
IF gnErrFile < 0  && Check for error opening file
	MESSAGEBOX("File già aperto da un altro programma." + CHR(13) + CHR(13) + ;
		"Chiudere il file prima di proseguire",16,"Attenzione")
	SELECT(_BEFORE_TABLE_SEL)
	RETURN .F.
ENDIF
=FCLOSE(gnErrFile)

WAIT WINDOW "Estrazione dati da file excel in corso..." NOWAIT

*!*	LOCAL oexcel,xlExcel5,cNomeFileVer5,cDbfName,cTableName

*!*	oexcel=createobject("excel.application")
*!*	oexcel.Workbooks.Open(_par_nomefile_in)
*!*	xlExcel5 = 39  && VERSIONE 5.0/95
*!*	cNomeFileVer5 = SYS(5)+SYS(2003)+"\"+ALLTRIM(PUB_CODOPE)+SYS(2015)+".XLS"
*!*	cDbfName = STRTRAN(cNomeFileVer5,".XLS",".DBF")
*!*	cTableName = STRTRAN(JUSTFNAME(cDbfName),".DBF","")

*!*	oexcel.Workbooks(1).SaveAs(cNomeFileVer5,xlExcel5)
*!*	oexcel.Workbooks.Close

*!*	IF !FILE(cNomeFileVer5)
*!*		WAIT CLEAR
*!*		MESSAGEBOX("File excel " + ALLTRIM(cNomeFileVer5) + " in versione estraibile non trovato",16,"Attenzione")
*!*		SELECT(_BEFORE_TABLE_SEL)
*!*		RETURN .F.
*!*	ENDIF

*!*	*** CREO E SELEZIONO UN CURSORE FITTIZIO CHE IL COMANDO IMPORT STRANAMENTE ELIMINERA'
*!*	CREATE CURSOR CU_FITTIZIO (CAMPO C(100))
*!*	SELECT CU_FITTIZIO

*!*	_cCommand = "IMPORT FROM '" + cNomeFileVer5 + "' TYPE XLS"
*!*	&_cCommand

*!*	_cCommand = "ERASE '" + cNomeFileVer5 + "'"
*!*	&_cCommand

*!*	IF !FILE(cDbfName)
*!*		WAIT CLEAR
*!*		MESSAGEBOX("Tabella DBF " + ALLTRIM(cDbfName) + " non trovata",16,"Attenzione")
*!*		SELECT(_BEFORE_TABLE_SEL)
*!*		RETURN .F.
*!*	ENDIF

*!*	LOCAL _TABLE_SEL
*!*	_TABLE_SEL = SELECT()

*!*	_cCommand = "SELECT * FROM '" + cTableName + "' INTO CURSOR " + _par_nomecur_out
*!*	&_cCommand

*!*	SELECT(_TABLE_SEL)
*!*	USE
*!*	_cCommand = "ERASE '" + cDbfName + "'"
*!*	&_cCommand

**=> ERASMO - INIZIO 18/07/2016
LOCAL oexcel,xlText,cNomeFileText

oexcel=createobject("excel.application")
oexcel.Workbooks.Open(_par_nomefile_in)
oexcel.DisplayAlerts = .F.
xlText = 19  && FORMATO CSV DELIMITATO DA TABULAZIONI
cNomeFileText = SYS(5)+SYS(2003)+"\"+ALLTRIM(PUB_CODOPE)+SYS(2015)+".txt"


*** RIPULISCO IL FILE EXCEL DA EVENTUALI TABULAZIONI E DOPPI APICI CHE SFASEREBBERO L'ESPORTAZIONE IN TXT SEPARATO DA TABULAZIONE
*ActiveCell.Replace What:="""", Replacement:="*", LookAt:=xlPart, SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, ReplaceFormat:=False
oexcel.Range("A1:IV65536").Select
oexcel.Selection.Replace(CHR(9),"")		&& TABULAZIONE SOSTITUITA CON VUOTO
oexcel.Range("A1:IV65536").Select
oexcel.Selection.Replace(CHR(34),"`")	&& DOPPIO APICE SOSTITUITO CON `
oexcel.Range("A1:IV65536").Select
oexcel.Selection.Replace(CHR(248),"o")	&& SIMBOLO DIAMETRO SOSTITUITO CON o

**oexcel.VISIBLE = .T.	&& SERGIO QUESTA ISTRUZIONE MOSTRA SUBITO IL FOGLIO EXCEL PRIMA DI ELABORARLO


*ActiveWorkbook.SaveAs Filename:=fnameProject, FileFormat:=xlCSV,CreateBackup:=False, Local:=True
*oexcel.Workbooks(1).SaveAs(cNomeFileCSV,xlCSV)
oexcel.ActiveWorkbook.SaveAs(cNomeFileText,xlText,.F.,.F.)
oexcel.ActiveWorkbook.Close(.F.)
IF !FILE(cNomeFileText)
	WAIT CLEAR
	MESSAGEBOX("File " + ALLTRIM(cNomeFileText) + " in versione estraibile non trovato",16,"Attenzione")
	SELECT(_BEFORE_TABLE_SEL)
	RETURN .F.
ENDIF
		
*** LEGGO IL NUMERO DI COLONNE DEL CSV
gnFileHandle = FOPEN(cNomeFileText)
*lcLine = FGETS(gnFileHandle)
lcLine = FGETS(gnFileHandle,8192)  && ERASMO - 30/11/2018
nCols = OCCURS(CHR(9),lcLine) + 1
FCLOSE(gnFileHandle)

*** CREO IL CURSORE NEL QUALE IMPORTERO' I DATI
_cCommand = "CREATE CURSOR " + _par_nomecur_out + "("
_cColumns = ""
FOR I=1 TO nCols
	_cColDef = ALLTRIM(n2c(I)) + " C(254)"
	_cColumns = ALLTRIM(_cColumns) + IIF(EMPTY(_cColumns),"",", ") + _cColDef
NEXT
_cCommand = _cCommand + _cColumns + ")"
&_cCommand

SELECT &_par_nomecur_out
_cCommand = "APPEND FROM '" + cNomeFileText + "' DELIMITED WITH TAB"
&_cCommand

_cCommand = "ERASE '" + cNomeFileText + "'"
&_cCommand

SELECT &_par_nomecur_out
GO TOP
**=> ERASMO - FINE 18/07/2016

WAIT CLEAR

SELECT(_BEFORE_TABLE_SEL)

RETURN .T.

ENDFUNC


************************************************************************
PROCEDURE ESTRXLS_ORDINATO_PASSIVO
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
* La procedura è poersonalizzata rispetto al richiamo del form MENU_ORDINATO_PASSIVO
*
* Sintassi:
* 
* DO ESTRXLS_ORDINATO_PASSIVO WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
* <subtotale>                   : subtotale di tutti i valori numerici alla fine del file excel [booleano .t./.f.]
* <def_decimali>                : esiste un cursore dal nome 'CUR_ESTRXLS_DEF_DECIMALS' dal quale dedurre i decimali da riportare per i campi numerici [booleano .t./.f.]
*
********************************************************************************************************************
                                                                                
*PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS
LPARAMETERS _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS,_NOMEFILE  && ERASMO - 25/10/2019

IF PCOUNT() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PCOUNT() < 2
   _TITOLO1 = ""
ENDIF
IF PCOUNT() < 3
   _TITOLO2 = ""
ENDIF
IF PCOUNT() < 4
   _TITOLO3 = ""
ENDIF

*** PARAMETRO PER LA SCRITTURA DEI TOTALI GENERALI A FINE TABELLA, CON DEFAULT A TRUE
IF PCOUNT() < 5
   _SUBTOTALS = .T.
ENDIF

*** PARAMETRO PER LA SEGNALAZIONE CHE NEL CURSORE DAL NOME 'CUR_ESTRXLS_DEF_DECIMALS' SONO DEFINITI I DECIMALI DA RIPORTARE PER I CAMPI NUMERICI, CON DEFAULT A FALSE
IF PCOUNT() < 6
   _DEFDECIMALS = .F.
ENDIF

**=> ERASMO - INIZIO 25/10/2019
IF PCOUNT() < 7
   _NOMEFILE = ""
ENDIF
**=> ERASMO - FINE 25/10/2019

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local objExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
objExcel.DisplayAlerts = .F.  && ERASMO - 07/04/2014
xlLandscape = 2

WITH objExcel 
*!*	   .Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*	   .Visible = .f.
   .Range("A1:IV65536").Select
   *.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*	   .Range("A1:IV1").Select
*!*	   .Selection.Font.Size = 10
*!*	   .Selection.Font.Bold = .t.
*!*	   .Columns().EntireColumn.AutoFit
*!*	   .Rows("1:1").EntireRow.Select
*!*	   .Selection.Insert
*!*	   .Selection.Insert
*!*	   .Selection.Insert
   .Range("A1").Select
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   *IF FILE(PUB_LOGO1)
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
      *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
      *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
*!*	      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      **=> ERASMO - INIZIO 10/02/2014
      .Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
      .Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
      **=> ERASMO - FINE 10/02/2014
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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
   IF UPPER(ALLTRIM(_STRING)) $ "N_ORDINE#ORD_CHIUSO#DAGGANCIO#DATCONMOD"  && NON VISUALIZZO NEL FILE EXCEL ALCUNI CAMPI DI SOLO UTILIZZO INTERNO
      nFieldNumber = nFieldNumber + 1
      LOOP
   ENDIF
   _NUMEROCAMPI = _NUMEROCAMPI + 1
   nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6

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

xlCenter  = -4108
xlLeft    = -4131
xlContext = -5002

*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
	
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"
		
		IF _DEFDECIMALS AND USED("CUR_ESTRXLS_DEF_DECIMALS")
			SELECT CUR_ESTRXLS_DEF_DECIMALS
			SET ORDER TO I_FLDNAME
			GO TOP
			_SEEK = ALLTRIM(_NOMECAMPO)
			SEEK _SEEK
			IF FOUND()
				_nDecimals = NDECIMALS
				IF _nDecimals > 0
					_NFORMAT = "#,##0." + REPLICATE('0',_nDecimals)
				ENDIF
			ENDIF
			SELECT &_NOMECUR
		ENDIF
	ENDIF
	
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR


_lUndo = .F.  && ERASMO - 07/04/2014
_nRIGA = _RIGA_INIZIALE + 1

SELECT &_NOMECUR
GO TOP
_OLD_AGGANCIO = ""
_ULT_NRIGA_MERGE = 0
SCAN
	
   WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
*!*		**=> ERASMO - INIZIO 07/04/2014
*!*		IF !AQ_WAITBAR("",_NOMECUR,.T.,"Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())))
*!*			_lUndo = .T.
*!*			EXIT
*!*		ENDIF
*!*		**=> ERASMO - FINE 07/04/2014
   
   _ROTTURA = .F.
   IF _OLD_AGGANCIO <> DAGGANCIO
      _ROTTURA = .T.
      _OLD_AGGANCIO = DAGGANCIO
      _ULT_NRIGA_MERGE = _nRIGA
   ENDIF
   
   FOR I = 1 TO _NUMEROCAMPI
      _Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      _NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
      _VALORE = &_NOMECAMPO
      
      IF TYPE(_NOMECAMPO) = "C"
         _VALORE = ALLTRIM(&_NOMECAMPO)
		 *** SE DATA ROVESCIATA, LA RIBALTO
		 IF SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/'
		 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
		 ENDIF
      ENDIF
      
*!*	      IF _ROTTURA
*!*	      ELSE
*!*	         IF UPPER(ALLTRIM(_NOMECAMPO)) $ "CONF#COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
*!*	            _VALORE = ""
*!*	         ENDIF
*!*	      ENDIF
      
      objExcel.ActiveSheet.Range(_Range).Select
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
      
      IF UPPER(ALLTRIM(_NOMECAMPO)) $ "QTA_ORDINATA#QTA_EVASA#QTA_RESIDUA"
         objExcel.Selection.Interior.Color = IIF(ORD_CHIUSO, RGB(0,255,0), IIF(QTA_EVASA > 0 AND (QTA_ORDINATA - QTA_EVASA) > 0, RGB(255,128,0), IIF(MOD(N_ORDINE,2)=0, RGB(217,217,255), RGB(255,255,255))))
      ELSE
         objExcel.Selection.Interior.Color = IIF(ORD_CHIUSO, RGB(0,255,0), IIF(MOD(N_ORDINE,2)=0, RGB(217,217,255), RGB(255,255,255)))
      ENDIF
      
      **=> ERASMO - INIZIO 19/04/2017
      SELECT &_NOMECUR
      IF TYPE("DATCONMOD") <> 'U'	&& ERASMO - 19/01/2018
	      IF UPPER(ALLTRIM(_NOMECAMPO)) = "DATA_PREV_CONSEGNA" AND DATCONMOD
	         objExcel.Selection.Font.ColorIndex = 3
	      ENDIF
      ENDIF							&& ERASMO - 19/01/2018
      **=> ERASMO - FINE 19/04/2017
      
*!*	      *** UNISCI E CENTRA
*!*	      IF UPPER(ALLTRIM(_NOMECAMPO)) $ "COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
*!*		      _Range = n2c(I) + ALLTRIM(STR(_ULT_NRIGA_MERGE,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
*!*		      objExcel.ActiveSheet.Range(_Range).Select
*!*		      objExcel.Selection.Merge
*!*		      WITH objExcel.Selection
*!*		        .HorizontalAlignment = xlLeft
*!*		        .VerticalAlignment = xlCenter
*!*		        .WrapText = .F.
*!*		        .Orientation = 0
*!*		        .AddIndent = .F.
*!*		        .IndentLevel = 0
*!*		        .ShrinkToFit = .F.
*!*		        .ReadingOrder = xlContext
*!*		        .MergeCells = .T.
*!*		      ENDWITH
*!*		   ENDIF
	      
*!*	    With Selection
*!*	        .HorizontalAlignment = xlCenter
*!*	        .VerticalAlignment = xlBottom
*!*	        .WrapText = False
*!*	        .Orientation = 0
*!*	        .AddIndent = False
*!*	        .IndentLevel = 0
*!*	        .ShrinkToFit = False
*!*	        .ReadingOrder = xlContext
*!*	        .MergeCells = False
*!*	    End With
*!*	    Selection.Merge
*!*	    With Selection
*!*	        .HorizontalAlignment = xlCenter
*!*	        .VerticalAlignment = xlCenter
*!*	        .WrapText = False
*!*	        .Orientation = 0
*!*	        .AddIndent = False
*!*	        .IndentLevel = 0
*!*	        .ShrinkToFit = False
*!*	        .ReadingOrder = xlContext
*!*	        .MergeCells = True
*!*	    End With
*!*	    With Selection
*!*	        .HorizontalAlignment = xlLeft
*!*	        .VerticalAlignment = xlCenter
*!*	        .WrapText = False
*!*	        .Orientation = 0
*!*	        .AddIndent = False
*!*	        .IndentLevel = 0
*!*	        .ShrinkToFit = False
*!*	        .ReadingOrder = xlContext
*!*	        .MergeCells = True
*!*	    End With
   ENDFOR
   
   _nRIGA = _nRIGA + 1
ENDSCAN

**=> ERASMO - INIZIO 07/04/2014
*** OPERAZIONE ANNULLATA DALL'UTENTE
IF _lUndo
	objExcel.Workbooks.Close()
	RELEASE objExcel
	RETURN .F.
ENDIF
objExcel.DisplayAlerts = .T.
**=> ERASMO - FINE 07/04/2014

*** AUTOFIT COLONNE
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
IF _SUBTOTALS
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF

*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
WITH objExcel
	.ActiveSheet.Cells(2,6).Value = _TITOLO1
	.ActiveSheet.Cells(2,6).Font.Bold = .T.
	.ActiveSheet.Cells(2,6).Font.Size = 11
	.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(2,6).WrapText = .F.

	.ActiveSheet.Cells(3,6).Value = _TITOLO2
	.ActiveSheet.Cells(3,6).Font.Bold = .T.
	.ActiveSheet.Cells(3,6).Font.Size = 11
	.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(3,6).WrapText = .F.

	.ActiveSheet.Cells(4,6).Value = _TITOLO3
	.ActiveSheet.Cells(4,6).Font.Bold = .T.
	.ActiveSheet.Cells(4,6).Font.Size = 11
	.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(4,6).WrapText = .F.
ENDWITH

objExcel.Range("A1").Select

*objExcel.Visible = .t.
**=> ERASMO - INIZIO 25/10/2019
IF !EMPTY(_NOMEFILE)
	objExcel.ActiveWorkbook.SaveCopyAs(_NOMEFILE)  && USO IL METODO "SaveCopyAs" IN QUANTO RICHIAMANDO LA PROCEDURA DA UN SERVIZIO WINDOWS (AQ_SERVICE) NON VIENE RICONOSCIUTO IL METODO "SaveAs"
	objExcel.ActiveWorkbook.Close(.F.)
ELSE
	objExcel.Visible = .t.
ENDIF
**=> ERASMO - FINE 25/10/2019

IF USED("CUR_ESTRXLS_DEF_DECIMALS")
	SELECT CUR_ESTRXLS_DEF_DECIMALS
	USE
ENDIF

WAIT CLEAR


**=> ERASMO - INIZIO 23/03/2015
************************************************************************
PROCEDURE ESTRXLS_PMI_GIACXPROD
************************************************************************

LPARAMETERS _TITOLO1,_TITOLO2,_TITOLO3

IF PCOUNT() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() < 2
	_TITOLO2 = ""
ENDIF
IF PCOUNT() < 3
	_TITOLO3 = ""
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .F.
objExcel.Workbooks.Add()
objExcel.ActiveWindow.Zoom = 75

WITH objExcel
	*.Cells.Select
	.Range("A1").Select
	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
ENDWITH

*********************************
*** VALORIZZAZIONE COSTANTI EXCEL
*********************************
xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlThick		 = 4

xlCenter = -4108

xlExpression = 2
xlCellValue = 1
xlGreater = 5
xlLess = 6
xlEqual = 3
xlAutomatic = -4105


**********************************************
*** SCRITTURA INTESTAZIONE PRODOTTI E DETTAGLI
**********************************************
SELECT PRODOTTI AS PRODOTTO, QUANTI FROM CU_GIACXPROD_DETT WHERE FLGMAIN ORDER BY PRODOTTO INTO CURSOR CX_PRODOTTI

_nColonnePerProdotto = 5
*_nColonnaIniziale = 1
_nColonnaIniziale = 0
_nRigaIniziale = 6
_nProdotto = 0
_nRigaMax = 0
_nColonnaMax = 0
_nProdottiMax = 0

SELECT CX_PRODOTTI
GO TOP
SCAN
	_nProdotto = _nProdotto + 1
	
	_nProdottiMax = _nProdotto 
	
	_PRODOTTO = ALLTRIM(PRODOTTO)
	
	WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettaglio prodotto " + ALLTRIM(_PRODOTTO) + " ..." NOWAIT
	
	* SCRITTURA INTESTAZIONE PRODOTTO
	_DESPRODOTTO = ""
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + _PRODOTTO + "'"
	x_cond = x_soci + " and " + x_codi
	cSql   = "select ART_DESCR from u_art_pr where " + x_cond
	IF !ExecCommand(cSql,"TMP_ARTICOLI")
		RETURN .F.
	ENDIF	
	SELECT TMP_ARTICOLI
	GO TOP
	IF !EOF()
		_DESPRODOTTO = ALLTRIM(ART_DESCR)
	ENDIF
	SELECT CX_PRODOTTI
	
	_nRiga = _nRigaIniziale
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_nProdotto - 1)) + 1
	_VALORE = ALLTRIM(PRODOTTO) + " ("  + _DESPRODOTTO + ")"
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		.Value = _VALORE
		.NumberFormat = "@"
		*.Font.Size = 10
		.Font.Bold = .T.
		.Borders(xlEdgeLeft).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeRight).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeTop).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
	ENDWITH
	
	_nRiga = _nRigaIniziale
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_nProdotto - 1)) + 1 + 1
	_VALORE = QUANTI
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		.Value = _VALORE
		*.Font.Size = 10
		.Font.Bold = .T.
		.Borders(xlEdgeLeft).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeRight).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
		.Borders(xlEdgeTop).LineStyle = xlContinuous
		*.Borders(xlEdgeLeft).Weight = xlThin
	ENDWITH
	
	* SCRITTURA DETTAGLI ARTICOLI
	SELECT * FROM CU_GIACXPROD_DETT WHERE !FLGMAIN AND ALLTRIM(GRUPPO) == ALLTRIM(_PRODOTTO) ORDER BY CODART INTO CURSOR CX_PRODOTTI_DETT
	SELECT CX_PRODOTTI_DETT
	GO TOP
	_nRiga = _nRigaIniziale + 2
	SCAN
		_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_nProdotto - 1)) + 1
		FOR _I = 1 TO _nColonnePerProdotto
			DO CASE
				CASE _I = 1
					_VALORE = ALLTRIM(CODART)
				CASE _I = 2
					_VALORE = DISQTA
				CASE _I = 3
					_VALORE = ALLTRIM(DESART)
				CASE _I = 4
					_VALORE = NULL
				CASE _I = 5
					_VALORE = NULL
			ENDCASE
			_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			WITH objExcel.Selection
				.Value = _VALORE
				IF _I = 1 OR _I = 3
					.NumberFormat = "@"
				ENDIF
				IF _I = 4
					.Borders(xlEdgeRight).LineStyle = xlContinuous
					.Borders(xlEdgeRight).Weight = xlThick
				ENDIF
			ENDWITH
			
			_nRigaMax = MAX(_nRigaMax,_nRiga)
			_nColonnaMax = MAX(_nColonnaMax,_nColonna)
			
			_nColonna = _nColonna + 1
		ENDFOR
		_nRiga = _nRiga + 1
	ENDSCAN
ENDSCAN

*****************************
*** RIDIMENSIONAMENTO COLONNE
*****************************
FOR _H = 1 TO _nProdotto
	FOR _I = 1 TO _nColonnePerProdotto
		_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_H - 1)) + _I
		_RangeColumn = n2c(_nColonna) + ":" + n2c(_nColonna)
		DO CASE
			CASE _I = 1
				_WIDTH = 15
			CASE _I = 2
				_WIDTH = 6
			CASE _I = 3
				_WIDTH = 20
			CASE _I = 4
				_WIDTH = 6
			CASE _I = 5
				_WIDTH = 6
		ENDCASE
		objExcel.ActiveSheet.Columns(_RangeColumn).ColumnWidth = _WIDTH 
	ENDFOR
ENDFOR

**************************************************************
*** FORMATTAZIONE CONDIZIONALE GIACENZE MINORI O UGUALI A ZERO
**************************************************************

* SELEZIONE CELLE QTA' RIMANENTE 
_RangeColumnRow = ""
FOR _H = 1 TO _nProdotto
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_H - 1)) + 4
	_RangeColumnRow = _RangeColumnRow + IIF(EMPTY(_RangeColumnRow),"",";") + ;
		n2c(_nColonna) + ALLTRIM(STR(_nRigaIniziale + 2,10,0)) + ":" + n2c(_nColonna) + ALLTRIM(STR(_nRigaMax,10,0))
ENDFOR
objExcel.ActiveSheet.Range(_RangeColumnRow).Select

* CELLE QTA' RIMANENTE CON CARATTERE ROSSO GRASSETTO SE UGUALI A ZERO
objExcel.Selection.FormatConditions.Add(xlCellValue, xlEqual, "0")
objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
With objExcel.Selection.FormatConditions(1).Font
	.Bold = .T.
	.Italic = .F.
	.Color = RGB(255,0,0)
	.TintAndShade = 0
EndWith
objExcel.Selection.FormatConditions(1).StopIfTrue = .T.

* CELLE QTA' RIMANENTE CON SFONDO ROSSO E CARATTERE GRASSETTO BIANCO SE MINORI DI ZERO
objExcel.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
With objExcel.Selection.FormatConditions(1).Font
	.Bold = .T.
	.Italic = .F.
	.Color = RGB(255,255,255)
	.TintAndShade = 0
EndWith
With objExcel.Selection.FormatConditions(1).Interior
	.PatternColorIndex = xlAutomatic
	.Color = 255
	.TintAndShade = 0
EndWith
objExcel.Selection.FormatConditions(1).StopIfTrue = .T.


* SELEZIONE CELLE DESCRIZIONE
_RangeColumnRow = ""
_1stCellRef = ""
FOR _H = 1 TO _nProdotto
	_nColonna = _nColonnaIniziale + (_nColonnePerProdotto * (_H - 1)) + 3
	_RangeColumnRow = _RangeColumnRow + IIF(EMPTY(_RangeColumnRow),"",";") + ;
		n2c(_nColonna) + ALLTRIM(STR(_nRigaIniziale + 2,10,0)) + ":" + n2c(_nColonna) + ALLTRIM(STR(_nRigaMax,10,0))
	IF EMPTY(_1stCellRef)
		_1stCellRef = n2c(_nColonna + 1) + ALLTRIM(STR(_nRigaIniziale + 2,10,0))
	ENDIF
ENDFOR
objExcel.ActiveSheet.Range(_RangeColumnRow).Select

* CELLE DESCRIZIONE CON CARATTERE ROSSO GRASSETTO SE QTA' RIMANANTE MINORE O UGUALE A ZERO
objExcel.Selection.FormatConditions.Add(xlExpression, , "=" + _1stCellRef + "<=0")
objExcel.Selection.FormatConditions(objExcel.Selection.FormatConditions.Count).SetFirstPriority
With objExcel.Selection.FormatConditions(1).Font
	.Bold = .T.
	.Italic = .F.
	.Color = RGB(255,0,0)
	.TintAndShade = 0
EndWith
objExcel.Selection.FormatConditions(1).StopIfTrue = .T.


*******************************
*** SCRITTURA DETTAGLI GIACENZE
*******************************

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettagli giacenze..." NOWAIT

SELECT CODART, DESART, GIACEN, QTAPRD, QTAORF FROM CU_GIACXPROD_DETT WHERE !FLGMAIN GROUP BY CODART, DESART, GIACEN, QTAPRD, QTAORF ORDER BY CODART INTO CURSOR CX_ART_GIACEN

* SCRITTURA LINEA DI SEPARAZIONE
_nRiga = _nRigaMax + 3
_Range = n2c(_nColonnaIniziale + 1) + ALLTRIM(STR(_nRiga,10,0)) + ":" + n2c(_nColonnaMax) + ALLTRIM(STR(_nRiga,10,0))
objExcel.ActiveSheet.Range(_Range).Select
WITH objExcel.Selection
	.Borders(xlEdgeBottom).LineStyle = xlContinuous
	.Borders(xlEdgeBottom).Weight = xlThick
ENDWITH

* SCRITTURA INTESTAZIONI DI COLONNA
_nRiga = _nRiga + 3
_nColonna = _nColonnaIniziale
FOR _I = 1 TO 3
	_nColonna = _nColonna + 1
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		DO CASE
			CASE _I = 1
				.Value = "CODICE"
			CASE _I = 2
				.Value = "GIACENZA"
			CASE _I = 3
				.Value = "DESCRIZIONE"
		ENDCASE
		.Font.Bold = .T.
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		.Borders(xlEdgeBottom).Weight = xlThin
	ENDWITH
ENDFOR

_nColonna = _nColonna + 3
_nColonnaSave = _nColonna
FOR _I = 1 TO _nProdottiMax + 6
	_nColonna = _nColonna + 1
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	WITH objExcel.Selection
		DO CASE
			CASE _I = 1
				.Value = "FABBISOGNO PER PRODOTTO"
			CASE _I = _nProdottiMax + 2
				.Value = "FABBISOGNO TOTALE"
			CASE _I = _nProdottiMax + 3
				.Value = "QTA' NEC. ALTRE PRODUZIONI"
			CASE _I = _nProdottiMax + 4
				IF _R_OPZORF
					.Value = "QTA' IN ORD.FORN."
				ENDIF
			CASE _I = _nProdottiMax + 5
				.Value = "NUOVA GIACENZA"
			CASE _I = _nProdottiMax + 6
				.Value = "QTA' DA ORDINARE"
		ENDCASE
		.Font.Bold = .T.
		.Borders(xlEdgeBottom).LineStyle = xlContinuous
		.Borders(xlEdgeBottom).Weight = xlThin
	ENDWITH
ENDFOR

_nRiga = _nRiga + 1

_nColonna = _nColonnaSave
FOR _I = 1 TO _nProdottiMax
	_nColonna = _nColonna + 1
	_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	_cValore = "R" + ALLTRIM(STR(_nRigaIniziale)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 1))
	objExcel.ActiveCell.FormulaR1C1 = '=' + _cValore
	objExcel.Selection.Font.Bold = .T.
	objExcel.Selection.HorizontalAlignment = xlCenter
ENDFOR


_nRigaIniGiac = 0
_nRigaFinGiac = 0
_nColonnaIniGiac = _nColonnaIniziale + 1
_nColonnaFinGiac = 0

* SCRITTURA DETTAGLI ARTICOLI COMPONENTI
SELECT CX_ART_GIACEN
GO TOP
SCAN
	WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettagli giacenza " + ;
		ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) + " ..." NOWAIT
	
	_nRiga = _nRiga + 1
	IF _nRigaIniGiac = 0
		_nRigaIniGiac = _nRiga
	ENDIF
	_nRigaFinGiac = _nRiga
	_nColonna = _nColonnaIniziale
	FOR _I = 1 TO 3
		_nColonna = _nColonna + 1
		_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		WITH objExcel.Selection
			DO CASE
				CASE _I = 1
					.Value = ALLTRIM(CODART)
					.NumberFormat = "@"
				CASE _I = 2
					.Value = GIACEN
					.Font.Color = RGB(0,0,255)
				CASE _I = 3
					.Value = ALLTRIM(DESART)
					.NumberFormat = "@"
			ENDCASE
		ENDWITH
	ENDFOR
	
	_nColonna = _nColonna + 3
	FOR _I = 1 TO _nProdottiMax + 6
		_nColonna = _nColonna + 1
		_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		
		IF _I >= 1 AND _I <= _nProdottiMax
			WITH objExcel
				_cValore = "RC" + ALLTRIM(STR(_nColonnaIniGiac,10,0))
				_cMatriceTabella = "R" + ALLTRIM(STR(_nRigaIniziale + 2)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 1)) + ;
					":" + "R" + ALLTRIM(STR(_nRigaMax)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 2))
				_cMoltiplicatore = "R" + ALLTRIM(STR(_nRigaIniziale)) + "C" + ALLTRIM(STR(_nColonnaIniziale + (_nColonnePerProdotto * (_I - 1)) + 2))
				*.ActiveCell.FormulaR1C1 = '=IfError(VLOOKUP(' + _cValore + ',' + _cMatriceTabella + ',2,FALSE)*' + _cMoltiplicatore + ',"")'
				*** LA FUNZIONE "IFERROR" ESISTE A PARTIRE DALLA VERSIONE EXCEL 2007 IN POI: SOSTITUISCO CON "IF(ISERROR..."
				_cVlookupFormula = 'VLOOKUP(' + _cValore + ',' + _cMatriceTabella + ',2,FALSE)*' + _cMoltiplicatore
				.ActiveCell.FormulaR1C1 = '=IF(ISERROR(' + _cVlookupFormula + '),"",' + _cVlookupFormula + ')'
				
				.Selection.Borders(xlEdgeLeft).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeLeft).Weight = xlThin
				.Selection.Borders(xlEdgeRight).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeRight).Weight = xlThin
				.Selection.Borders(xlEdgeBottom).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeBottom).Weight = xlThin
				.Selection.Borders(xlEdgeTop).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeTop).Weight = xlThin
				.Selection.Font.Color = RGB(0,0,255)
			ENDWITH
		ENDIF
		
		IF _I = _nProdottiMax + 2
			WITH objExcel
				.ActiveCell.FormulaR1C1 = "=SUM(RC[-" + ALLTRIM(STR(_nProdottiMax + 1)) + "]:RC[-2])"
				.Selection.Borders(xlEdgeLeft).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeLeft).Weight = xlThin
				.Selection.Borders(xlEdgeRight).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeRight).Weight = xlThin
				.Selection.Borders(xlEdgeBottom).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeBottom).Weight = xlThin
				.Selection.Borders(xlEdgeTop).LineStyle = xlContinuous
				.Selection.Borders(xlEdgeTop).Weight = xlThin
			ENDWITH
		ENDIF
		
		IF _I = _nProdottiMax + 3 AND QTAPRD > 0
			objExcel.Selection.Value = QTAPRD
		ENDIF
		
		IF _I = _nProdottiMax + 4 AND _R_OPZORF AND QTAORF > 0
			objExcel.Selection.Value = QTAORF
		ENDIF
		
		IF _I = _nProdottiMax + 5
			WITH objExcel
				*.ActiveCell.FormulaR1C1 = "=RC[-" + ALLTRIM(STR(_nProdottiMax + 9)) + "]-RC[-3]"
				IF _R_OPZORF
					.ActiveCell.FormulaR1C1 = "=RC[-" + ALLTRIM(STR(_nProdottiMax + 9)) + "]-RC[-3]-RC[-2]+RC[-1]"
				ELSE
					.ActiveCell.FormulaR1C1 = "=RC[-" + ALLTRIM(STR(_nProdottiMax + 9)) + "]-RC[-3]-RC[-2]"
				ENDIF
				.Selection.Font.Bold = .T.
			ENDWITH
			_nColonnaFinGiac = MAX(_nColonnaFinGiac,_nColonna)
		ENDIF
		
		IF _I = _nProdottiMax + 6
			WITH objExcel
				.ActiveCell.FormulaR1C1 = '=IF(RC[-1] < 0, -1 * RC[-1],"")'
			ENDWITH
		ENDIF
		
	ENDFOR
ENDSCAN


******************************************
*** VALORIZZAZIONE DETTAGLI NUOVA GIACENZA
******************************************

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " - Dettagli nuova giacenza..." NOWAIT

FOR _H = 1 TO _nProdottiMax

	FOR _nRiga = _nRigaIniziale + 2 TO _nRigaMax

		_nColonna = _nColonnaIniziale + 1 + (_nColonnePerProdotto * (_H - 1)) + 3
		_Range = n2c(_nColonna) + ALLTRIM(STR(_nRiga))
		
		objExcel.ActiveSheet.Range(_Range).Select
		
		_cValore = "RC" + ALLTRIM(STR(_nColonna - 3))
		_cMatriceTabella = "R" + ALLTRIM(STR(_nRigaIniGiac)) + "C" + ALLTRIM(STR(_nColonnaIniGiac)) + ;
			":" + "R" + ALLTRIM(STR(_nRigaFinGiac)) + "C" + ALLTRIM(STR(_nColonnaFinGiac))
		_cIndice = ALLTRIM(STR(_nColonnaFinGiac - 1))
		
		objExcel.ActiveCell.FormulaR1C1 = '=IF(AND(' + _cValore + ' <> """",NOT(ISBLANK(' + _cValore + '))) ,VLOOKUP(' + _cValore + ',' + ;
			_cMatriceTabella + ',' + _cIndice + ',FALSE),"")'
		
	ENDFOR
ENDFOR

*** NASCONDO INTESTAZIONE PRODOTTI E DETTAGLI
_cRowsRange = ALLTRIM(STR(_nRigaIniziale,10,0)) + ":" + ALLTRIM(STR(_nRigaMax,10,0))
objExcel.ActiveSheet.Rows(_cRowsRange).Select
objExcel.Selection.EntireRow.Hidden = .T.

*** BLOCCO INTESTAZIONI COLONNE DETTAGLI COMPONENTI
_cRowsRange = ALLTRIM(STR(_nRigaIniziale,10,0)) + ":" + ALLTRIM(STR(_nRigaMax + 8,10,0))
objExcel.ActiveSheet.Rows(_cRowsRange).Select
_cRange = "A" + ALLTRIM(STR(_nRigaMax + 8,10,0))
objExcel.ActiveSheet.Range(_cRange).Activate
objExcel.ActiveWindow.FreezePanes = .T.

*** AUTOFIT COLONNE DETTAGLI COMPONENTI
_COLUMN = n2c(_nColonnaIniziale + 1) + ":" + n2c(_nProdottiMax + 6 + 8)
objExcel.Columns(_COLUMN).EntireColumn.AutoFit

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,4).Value = _TITOLO1
	.ActiveSheet.Cells(2,4).Font.Bold = .T.
	.ActiveSheet.Cells(2,4).Font.Size = 16
	.ActiveSheet.Cells(2,4).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,4).Value = _TITOLO2
	.ActiveSheet.Cells(3,4).Font.Bold = .T.
	.ActiveSheet.Cells(3,4).Font.Size = 14
	.ActiveSheet.Cells(3,4).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,4).Value = _TITOLO3
	.ActiveSheet.Cells(4,4).Font.Bold = .T.
	.ActiveSheet.Cells(4,4).Font.Size = 14
	.ActiveSheet.Cells(4,4).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

MESSAGEBOX("Creazione foglio excel terminata",64,"Informazione")

ENDPROC
**=> ERASMO - FINE 23/03/2015

**=> ERASMO - INIZIO 09/12/2015
************************************************************************
PROCEDURE ESTRXLS_PIANIF_ACQ
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri (procedura dedicata per richiamo da PIANIFICAZIONE ACQUISTI)
*
* Sintassi:
* 
* DO ESTRXLS WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
* <subtotale>                   : subtotale di tutti i valori numerici alla fine del file excel [booleano .t./.f.]
* <def_decimali>                : esiste un cursore dal nome 'CUR_ESTRXLS_DEF_DECIMALS' dal quale dedurre i decimali da riportare per i campi numerici [booleano .t./.f.]
*
********************************************************************************************************************
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF

*** PARAMETRO PER LA SCRITTURA DEI TOTALI GENERALI A FINE TABELLA, CON DEFAULT A TRUE
IF PARAMETERS() < 5
   _SUBTOTALS = .T.
ENDIF

*** PARAMETRO PER LA SEGNALAZIONE CHE NEL CURSORE DAL NOME 'CUR_ESTRXLS_DEF_DECIMALS' SONO DEFINITI I DECIMALI DA RIPORTARE PER I CAMPI NUMERICI, CON DEFAULT A FALSE
IF PARAMETERS() < 6
   _DEFDECIMALS = .F.
ENDIF

SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local objExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
objExcel.DisplayAlerts = .F.  && ERASMO - 07/04/2014
xlLandscape = 2

WITH objExcel 
*!*	   .Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*	   .Visible = .f.
   .Range("A1:IV65536").Select
   *.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*	   .Range("A1:IV1").Select
*!*	   .Selection.Font.Size = 10
*!*	   .Selection.Font.Bold = .t.
*!*	   .Columns().EntireColumn.AutoFit
*!*	   .Rows("1:1").EntireRow.Select
*!*	   .Selection.Insert
*!*	   .Selection.Insert
*!*	   .Selection.Insert
   .Range("A1").Select
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 31/03/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
      .Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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

*_RIGA_INIZIALE = 6
IF PUB_INTXLS
	_RIGA_INIZIALE = 6
ELSE
	_RIGA_INIZIALE = 1
ENDIF

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

*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
			
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"

		IF _DEFDECIMALS AND USED("CUR_ESTRXLS_DEF_DECIMALS")
			SELECT CUR_ESTRXLS_DEF_DECIMALS
			SET ORDER TO I_FLDNAME
			GO TOP
			_SEEK = ALLTRIM(_NOMECAMPO)
			SEEK _SEEK
			IF FOUND()
				_nDecimals = NDECIMALS
				IF _nDecimals > 0
					_NFORMAT = "#,##0." + REPLICATE('0',_nDecimals)
				ENDIF
			ENDIF
			SELECT &_NOMECUR
		ENDIF
		
	*** SE IL CAMPO IN LINEA DI TIPO TESTO CONTIENE DEI VALORI CON FORMATO AAAA/MM/GG OPPURE GG/MM/AAAA LO SETTO COME FORMATO DATA
	*** QUESTO PER FAR FUNZIONARE CORRETTAMENTE L'ORDINAMENTO PER DATA SUL FINE EXCEL RISULTANTE
	*** N.B.: I DATI CON FORMATO NATIVO AAAA/MM/GG VENGONO SEMPRE RIBALTATI IN GG/MM/AAAA
	ELSE
		*IF TYPE(_NOMECAMPO) = "C" AND FSIZE(_NOMECAMPO) = 10
		IF TYPE(_NOMECAMPO) = "C" AND FSIZE(_NOMECAMPO) = 10 AND ALLTRIM(_NOMECAMPO) <> "TOP"  && ERASMO - 23/05/2022
			_cSelCommand = "SELECT &_NOMECAMPO FROM &_NOMECUR WHERE (SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/') " + ;
				"OR (SUBSTR(ALLTRIM(&_NOMECAMPO),3,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),6,1) = '/') INTO CURSOR TMP_CUR_XLS"
			&_cSelCommand
			SELECT TMP_CUR_XLS
			GO TOP
			IF !EOF()
				*_NFORMAT = "m/d/yyyy"
				_NFORMAT = "General"
			ENDIF
			USE
			SELECT &_NOMECUR
		ENDIF
		
	ENDIF
	
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR


*** ARRAY CONTENENTE MESI E DESCRIZIONI DEL PERIODO DI PIANIFICAZIONE
_nMonth = VAL(SUBSTR(_F_PERDA,4,2))
_nYear  = VAL(SUBSTR(_F_PERDA,7,4))
RELEASE X_PERIODI_ORF
IF _F_NPERIODS > 0
	PUBLIC X_PERIODI_ORF[_F_NPERIODS,4]
ENDIF
FOR _i = 1 TO _F_NPERIODS
	_cDesMonth = SUBSTR(DMESE(ALLTRIM(STR(_nMonth,2,0))),1,3) + " " + ALLTRIM(STR(_nYear,4,0))
	X_PERIODI_ORF(_i,1) = _i
	X_PERIODI_ORF(_i,2) = _cDesMonth
	X_PERIODI_ORF(_i,3) = PADL(ALLTRIM(STR(_nYear,4,0)),4,'0')
	X_PERIODI_ORF(_i,4) = PADL(ALLTRIM(STR(_nMonth,2,0)),2,'0')
	_nMonth = _nMonth + 1
	IF _nMonth = 13
		_nMonth = 1
		_nYear = _nYear + 1
	ENDIF
NEXT



_lUndo = .F.
_nRIGA = _RIGA_INIZIALE + 1

_CONTA_RECORD=0

SELECT &_NOMECUR
GO TOP
SCAN
	
	_CONTA_RECORD=_CONTA_RECORD+1
	
	IF !AQ_WAITBAR("",_NOMECUR,.T.,"Creazione foglio excel in corso... - riga " + ALLTRIM(STR(_CONTA_RECORD)) + " di " + ALLTRIM(STR(RECCOUNT())),_CONTA_RECORD)
		_lUndo = .T.
		EXIT
	ENDIF
   
   FOR I = 1 TO _NUMEROCAMPI
      _Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      _NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
      _VALORE = &_NOMECAMPO
      
      IF TYPE(_NOMECAMPO) = "C"
         *_VALORE = ALLTRIM(&_NOMECAMPO)
         _VALORE = RTRIM(&_NOMECAMPO)

		 *** SE DATA (10 CARATTERI) RIBALTATA, LA ROVESCIO
		 IF SUBSTR(ALLTRIM(&_NOMECAMPO),3,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),6,1) = '/' AND FSIZE(_NOMECAMPO) = 10
		 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
		 ENDIF
      ENDIF
            
      objExcel.ActiveSheet.Range(_Range).Select
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
		
		*#####################################################################
		*** SFONDO CELLA IN BASE ALLE CONDIZIONI DELLA PIANIFICAZIONE ACQUISTI
		_cProgreQtaP = ""
		_cProgreQtaA = ""
		FOR _i = 1 TO _F_NPERIODS
			_cProgreQtaP = ALLTRIM(_cProgreQtaP) + IIF(EMPTY(_cProgreQtaP),""," + ") + "PIANIF_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
			_cProgreQtaA = ALLTRIM(_cProgreQtaA) + IIF(EMPTY(_cProgreQtaA),""," + ") + "IN_ORD_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
			_cQtaA = "IN_ORD_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
			_cNonConf = "NON_CONF_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
			
			DO CASE
				CASE _NOMECAMPO = "PIANIF_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
					_cCond = "(" + _cProgreQtaA + ") >= (" + _cProgreQtaP + ")"
					IF &_cCond
						*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
						_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
						&_cCommand
					ENDIF
					
				CASE _NOMECAMPO = "IN_ORD_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
					_cCond1 = "(" + _cQtaA + " > 0 AND " + _cNonConf + ")"
					_cCond2 = "(" + _cProgreQtaA + ") >= (" + _cProgreQtaP + ")"
					IF &_cCond1
						_cCommand = "objExcel.Selection.Interior.ColorIndex = 6"  && GIALLO
						&_cCommand
					ELSE
						IF &_cCond2
							*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
							_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
							&_cCommand
						ENDIF
					ENDIF
					
				CASE _NOMECAMPO = "DA_ORD_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
					_cCond = "(" + _cProgreQtaA + ") >= (" + _cProgreQtaP + ")"
					IF &_cCond
						*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
						_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
						&_cCommand
					ENDIF
					
				CASE _NOMECAMPO = "CONS_" + STRTRAN(ALLTRIM(X_PERIODI_ORF(_i,2))," ","_")
					_cCond = "(" + _cProgreQtaA + ") >= (" + _cProgreQtaP + ")"
					IF &_cCond
						*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
						_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
						&_cCommand
					ENDIF
				
			ENDCASE
		NEXT
		*#####################################################################
      
   ENDFOR
   
   _nRIGA = _nRIGA + 1
ENDSCAN

*** OPERAZIONE ANNULLATA DALL'UTENTE
IF _lUndo
	objExcel.Workbooks.Close()
	RELEASE objExcel
	RETURN .F.
ENDIF
objExcel.DisplayAlerts = .T.

*** AUTOFIT COLONNE
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
IF _SUBTOTALS
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF

IF PUB_INTXLS
	*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
	WITH objExcel
		.ActiveSheet.Cells(2,6).Value = _TITOLO1
		.ActiveSheet.Cells(2,6).Font.Bold = .T.
		.ActiveSheet.Cells(2,6).Font.Size = 11
		.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(2,6).WrapText = .F.

		.ActiveSheet.Cells(3,6).Value = _TITOLO2
		.ActiveSheet.Cells(3,6).Font.Bold = .T.
		.ActiveSheet.Cells(3,6).Font.Size = 11
		.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(3,6).WrapText = .F.

		.ActiveSheet.Cells(4,6).Value = _TITOLO3
		.ActiveSheet.Cells(4,6).Font.Bold = .T.
		.ActiveSheet.Cells(4,6).Font.Size = 11
		.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(4,6).WrapText = .F.
	ENDWITH
ENDIF

*** NASCONDO COLONNE NON NECESSARIE
FOR I = 1 TO FCOUNT(_NOMECUR)
	_NOMECAMPO = FIELD(I,_NOMECUR)
	IF SUBSTR(_NOMECAMPO,1,9) = "NON_CONF_"
		WITH objExcel
			_COLUMN = n2c(I) + ":" + n2c(I)
			.Columns(_COLUMN).EntireColumn.Hidden = .T.
		ENDWITH
	ENDIF
ENDFOR

objExcel.Range("A1").Select

objExcel.Visible = .t.

IF USED("CUR_ESTRXLS_DEF_DECIMALS")
	SELECT CUR_ESTRXLS_DEF_DECIMALS
	USE
ENDIF

WAIT CLEAR
**=> ERASMO - FINE 09/12/2015

**=> ERASMO - INIZIO 01/07/2020
************************************************************************
PROCEDURE ESTRXLS_PIANIF
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri (procedura dedicata per richiamo da PIANIFICAZIONE PRODUZIONE)
*
* Sintassi:
* 
* DO ESTRXLS WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
* <subtotale>                   : subtotale di tutti i valori numerici alla fine del file excel [booleano .t./.f.]
* <def_decimali>                : esiste un cursore dal nome 'CUR_ESTRXLS_DEF_DECIMALS' dal quale dedurre i decimali da riportare per i campi numerici [booleano .t./.f.]
*
********************************************************************************************************************
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS

IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF

*** PARAMETRO PER LA SCRITTURA DEI TOTALI GENERALI A FINE TABELLA, CON DEFAULT A TRUE
IF PARAMETERS() < 5
   _SUBTOTALS = .T.
ENDIF

*** PARAMETRO PER LA SEGNALAZIONE CHE NEL CURSORE DAL NOME 'CUR_ESTRXLS_DEF_DECIMALS' SONO DEFINITI I DECIMALI DA RIPORTARE PER I CAMPI NUMERICI, CON DEFAULT A FALSE
IF PARAMETERS() < 6
   _DEFDECIMALS = .F.
ENDIF

SELECT &_NOMECUR
GO TOP
IF RECCOUNT() > 1048575
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local objExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
objExcel.DisplayAlerts = .F.
xlLandscape = 2

WITH objExcel 
*!*	   .Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*	   .Visible = .f.
   *.Range("A1:IV65536").Select
   *.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*	   .Range("A1:IV1").Select
*!*	   .Selection.Font.Size = 10
*!*	   .Selection.Font.Bold = .t.
*!*	   .Columns().EntireColumn.AutoFit
*!*	   .Rows("1:1").EntireRow.Select
*!*	   .Selection.Insert
*!*	   .Selection.Insert
*!*	   .Selection.Insert
   .Range("A1").Select
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 31/03/2015
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      .Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
      .Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

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

*_RIGA_INIZIALE = 6
IF PUB_INTXLS
	_RIGA_INIZIALE = 6
ELSE
	_RIGA_INIZIALE = 1
ENDIF

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

*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
			
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"

		IF _DEFDECIMALS AND USED("CUR_ESTRXLS_DEF_DECIMALS")
			SELECT CUR_ESTRXLS_DEF_DECIMALS
			SET ORDER TO I_FLDNAME
			GO TOP
			_SEEK = ALLTRIM(_NOMECAMPO)
			SEEK _SEEK
			IF FOUND()
				_nDecimals = NDECIMALS
				IF _nDecimals > 0
					_NFORMAT = "#,##0." + REPLICATE('0',_nDecimals)
				ENDIF
			ENDIF
			SELECT &_NOMECUR
		ENDIF
		
	*** SE IL CAMPO IN LINEA DI TIPO TESTO CONTIENE DEI VALORI CON FORMATO AAAA/MM/GG OPPURE GG/MM/AAAA LO SETTO COME FORMATO DATA
	*** QUESTO PER FAR FUNZIONARE CORRETTAMENTE L'ORDINAMENTO PER DATA SUL FINE EXCEL RISULTANTE
	*** N.B.: I DATI CON FORMATO NATIVO AAAA/MM/GG VENGONO SEMPRE RIBALTATI IN GG/MM/AAAA
	ELSE
		*IF TYPE(_NOMECAMPO) = "C" AND FSIZE(_NOMECAMPO) = 10
		IF TYPE(_NOMECAMPO) = "C" AND FSIZE(_NOMECAMPO) = 10 AND ALLTRIM(_NOMECAMPO) <> "TOP"  && ERASMO - 23/05/2022
			_cSelCommand = "SELECT &_NOMECAMPO FROM &_NOMECUR WHERE (SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/') " + ;
				"OR (SUBSTR(ALLTRIM(&_NOMECAMPO),3,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),6,1) = '/') INTO CURSOR TMP_CUR_XLS"
			&_cSelCommand
			SELECT TMP_CUR_XLS
			GO TOP
			IF !EOF()
				*_NFORMAT = "m/d/yyyy"
				_NFORMAT = "General"
			ENDIF
			USE
			SELECT &_NOMECUR
		ENDIF
		
	ENDIF
	
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR


*** ARRAY CONTENENTE MESI E DESCRIZIONI DEL PERIODO DI PIANIFICAZIONE
_nMonth = VAL(SUBSTR(_V_PERDA,4,2))
_nYear  = VAL(SUBSTR(_V_PERDA,7,4))
RELEASE X_PERIODI_PNF
IF _V_NPERIODS > 0
	PUBLIC X_PERIODI_PNF[_V_NPERIODS,4]
ENDIF
FOR _i = 1 TO _V_NPERIODS
	_cDesMonth = SUBSTR(DMESE(ALLTRIM(STR(_nMonth,2,0))),1,3) + " " + ALLTRIM(STR(_nYear,4,0))
	X_PERIODI_PNF(_i,1) = _i
	X_PERIODI_PNF(_i,2) = _cDesMonth
	X_PERIODI_PNF(_i,3) = PADL(ALLTRIM(STR(_nYear,4,0)),4,'0')
	X_PERIODI_PNF(_i,4) = PADL(ALLTRIM(STR(_nMonth,2,0)),2,'0')
	_nMonth = _nMonth + 1
	IF _nMonth = 13
		_nMonth = 1
		_nYear = _nYear + 1
	ENDIF
NEXT



_lUndo = .F.
_nRIGA = _RIGA_INIZIALE + 1

_CONTA_RECORD=0

SELECT &_NOMECUR
GO TOP
SCAN
	
	_CONTA_RECORD=_CONTA_RECORD+1
	
	IF !AQ_WAITBAR("",_NOMECUR,.T.,"Creazione foglio excel in corso... - riga " + ALLTRIM(STR(_CONTA_RECORD)) + " di " + ALLTRIM(STR(RECCOUNT())),_CONTA_RECORD)
		_lUndo = .T.
		EXIT
	ENDIF
   
   FOR I = 1 TO _NUMEROCAMPI
      _Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      _NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
      _VALORE = &_NOMECAMPO
      
      IF TYPE(_NOMECAMPO) = "C"
         *_VALORE = ALLTRIM(&_NOMECAMPO)
         _VALORE = RTRIM(&_NOMECAMPO)

		 *** SE DATA (10 CARATTERI) RIBALTATA, LA ROVESCIO
		 IF SUBSTR(ALLTRIM(&_NOMECAMPO),3,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),6,1) = '/' AND FSIZE(_NOMECAMPO) = 10
		 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
		 ENDIF
      ENDIF
            
      objExcel.ActiveSheet.Range(_Range).Select
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
      
      SELECT &_NOMECUR
      IF TIPO = 'V'
	      objExcel.Selection.Font.Bold = .t.
	  ENDIF
		
		*#####################################################################
		*** SFONDO CELLA IN BASE ALLE CONDIZIONI DELLA PIANIFICAZIONE
		_cProgreQtaP = ""
		_cProgreQtaA = ""
		FOR _i = 1 TO _V_NPERIODS
			_cProgreQtaP = ALLTRIM(_cProgreQtaP) + IIF(EMPTY(_cProgreQtaP),""," + ") + "PIANIFICATO_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
			_cProgreQtaA = ALLTRIM(_cProgreQtaA) + IIF(EMPTY(_cProgreQtaA),""," + ") + "ORDINATO_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
			_cProgreQtaF = ALLTRIM(_cProgreQtaF) + IIF(EMPTY(_cProgreQtaF),""," + ") + "FATTIBILE_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
			_cQtaP = "PIANIFICATO_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
			_cQtaA = "ORDINATO_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
			_cQtaF = "FATTIBILE_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
			
			DO CASE
				CASE _NOMECAMPO = "PIANIFICATO_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
					_cCond = "!(TIPO = 'V') AND (" + _cProgreQtaA + ") >= (" + _cProgreQtaP + ")"
					IF &_cCond
						*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
						_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
						&_cCommand
					ENDIF
					
				CASE _NOMECAMPO = "ORDINATO_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
					_cCond = "!(TIPO = 'V') AND (" + _cProgreQtaA + ") >= (" + _cProgreQtaP + ")"
					IF &_cCond
						*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
						_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
						&_cCommand
					ENDIF
					
				CASE _NOMECAMPO = "FATTIBILE_" + STRTRAN(ALLTRIM(X_PERIODI_PNF(_i,2))," ","_")
					_cCond1 = "(" + _cQtaF + " >= " + _cQtaP + ")"
					_cCond2 = "!(TIPO = 'V') AND (" + _cQtaA + ") >= (" + _cQtaP + ")"
					IF &_cCond1
						IF &_cCond2
							*_cCommand = "objExcel.Selection.Interior.ColorIndex = 43"  && VERDE
							_cCommand = "objExcel.Selection.Interior.Color = 5296274"  && VERDE
							&_cCommand
						ENDIF
					ELSE
						_cCommand = "objExcel.Selection.Interior.Color = 33023"  && ARANCIO
						&_cCommand    
					ENDIF
				
			ENDCASE
		NEXT
		*#####################################################################
      
   ENDFOR
   
   _nRIGA = _nRIGA + 1
ENDSCAN

*** OPERAZIONE ANNULLATA DALL'UTENTE
IF _lUndo
	objExcel.Workbooks.Close()
	RELEASE objExcel
	RETURN .F.
ENDIF
objExcel.DisplayAlerts = .T.

*** AUTOFIT COLONNE
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
IF _SUBTOTALS
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF

IF PUB_INTXLS
	*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
	WITH objExcel
		.ActiveSheet.Cells(2,6).Value = _TITOLO1
		.ActiveSheet.Cells(2,6).Font.Bold = .T.
		.ActiveSheet.Cells(2,6).Font.Size = 11
		.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(2,6).WrapText = .F.

		.ActiveSheet.Cells(3,6).Value = _TITOLO2
		.ActiveSheet.Cells(3,6).Font.Bold = .T.
		.ActiveSheet.Cells(3,6).Font.Size = 11
		.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(3,6).WrapText = .F.

		.ActiveSheet.Cells(4,6).Value = _TITOLO3
		.ActiveSheet.Cells(4,6).Font.Bold = .T.
		.ActiveSheet.Cells(4,6).Font.Size = 11
		.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(4,6).WrapText = .F.
	ENDWITH
ENDIF

*** NASCONDO COLONNE NON NECESSARIE
FOR I = 1 TO FCOUNT(_NOMECUR)
	_NOMECAMPO = FIELD(I,_NOMECUR)
	IF SUBSTR(_NOMECAMPO,1,9) = "NON_CONF_"
		WITH objExcel
			_COLUMN = n2c(I) + ":" + n2c(I)
			.Columns(_COLUMN).EntireColumn.Hidden = .T.
		ENDWITH
	ENDIF
ENDFOR

objExcel.Range("A1").Select

objExcel.Visible = .t.

IF USED("CUR_ESTRXLS_DEF_DECIMALS")
	SELECT CUR_ESTRXLS_DEF_DECIMALS
	USE
ENDIF

WAIT CLEAR
**=> ERASMO - FINE 01/07/2020


************************************************************************
PROCEDURE ESTRXLS_FATTURE_PROFORMA_PER_CLIENTE
************************************************************************
LPARAMETERS  _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3


IF PCOUNT() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() < 2
	_TITOLO1 = ""
ENDIF
IF PCOUNT() < 3
	_TITOLO2 = ""
	_TITOLO1 = ""
ENDIF

IF PCOUNT() < 4
	_TITOLO3 = ""
	_TITOLO2 = ""
	_TITOLO1 = ""
ENDIF



SELECT &_NOMECUR
GO TOP
*IF RECCOUNT() > 65530
IF RECCOUNT() > 1048575  && ERASMO - 07/07/2016
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel " + ALLTRIM(_TITOLO1) + " in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel
	.Range("A1:IV65536").Select
	.Range("A1").Select
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select 		&& carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 				&& imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Height = 50 						&& regola l'altezza del logo azienda
		.Selection.ShapeRange.Top = 0  							&& allinea l'immagine in alto  
		.Selection.ShapeRange.Left = 0  						&& allinea l'immagine a sinistra 
	ENDIF
	
	*** SETTAGGIO IMPOSTAZIONI DI STAMPA
	.ActiveSheet.PageSetup.LeftMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.RightMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.TopMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.BottomMargin = .Application.InchesToPoints(0.196850393700787)
	.ActiveSheet.PageSetup.HeaderMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.FooterMargin = .Application.InchesToPoints(0.31496062992126)
	.ActiveSheet.PageSetup.Orientation = xlLandscape
	
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6
_NUMEROCAMPI_HEADER = 0
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	_VALORE = _NOMECAMPO
	DO CASE
		CASE _NOMECAMPO == "ORD_CODCLI"
			_VALORE = "Cliente"
		CASE _NOMECAMPO == "ORD_RAGSOC"
			_VALORE = "Ragione sociale"
		CASE _NOMECAMPO == "ORD_DATORD"
			_VALORE = "Data nota prof."
		CASE _NOMECAMPO == "ORD_NUMORD"
			_VALORE = "Numero nota prof."
		CASE _NOMECAMPO == "ORD_VALORE"
			_VALORE = "Valore lordo"
		CASE _NOMECAMPO == "T_NETTO"
			_VALORE = "Valore netto"
		CASE _NOMECAMPO == "ORD_MMESPO"
			_VALORE = "Mesi esposizione"
	ENDCASE
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _VALORE
	_NUMEROCAMPI_HEADER = _NUMEROCAMPI_HEADER + 1
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI_HEADER) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeLeft   = 7
xlEdgeRight  = 10
xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		 = 1
xlCenter     = -4108

objExcel.Selection.Font.Bold = .T.
objExcel.Selection.Font.Size = 10
objExcel.Selection.HorizontalAlignment = 3 

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

WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... " NOWAIT

_nRIGA = _RIGA_INIZIALE + 1
_nRigaInizialeRottura2 = _nRIGA
_cRigheXSubTotale = ""
_cRigheXTotale1 = ""
_CONTA_RIGHE_CLIENTE=0
TT_ORDVALORE = 0
TT_TNETTO    = 0
TTGE_ORDVALORE = 0
TTGE_TNETTO    = 0

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
	
	IF RECNO()%10 ==0
		WAIT WINDOWS "Creazione foglio excel (" + ALLTRIM(_TITOLO1) + ") in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	ENDIF
	
	_cActStringaRottura2 = ALLTRIM(ORD_CODCLI)  
	_cActStringaRottura1 = ALLTRIM(ORD_CODCLI)
	
	FOR I = 1 TO _NUMEROCAMPI
	
		_NOMECAMPO = UPPER(ALLTRIM((FIELD(I,_NOMECUR))))
		
		DO CASE
		
			CASE _NOMECAMPO == "ORD_VALORE"
				_VALORE = ALLTRIM(STR(&_NOMECAMPO,13,2))
				TT_ORDVALORE = TT_ORDVALORE  + VAL(_VALORE)
				TTGE_ORDVALORE = TTGE_ORDVALORE  + VAL(_VALORE)
								
			CASE _NOMECAMPO == "T_NETTO"
				_VALORE = ALLTRIM(STR(&_NOMECAMPO,13,2))
				TT_TNETTO    = TT_TNETTO  + VAL(_VALORE)
				TTGE_TNETTO  = TTGE_TNETTO  + VAL(_VALORE)
				
				
			CASE _NOMECAMPO == "ORD_MMESPO"	
				_VALORE = ALLTRIM(STR(&_NOMECAMPO,10,0))
				
			CASE _NOMECAMPO == "ORD_DATORD"	
				_VALORE = RIBALTA2(&_NOMECAMPO)
	
				
			OTHERWISE		
				_VALORE = &_NOMECAMPO
				
		ENDCASE

		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.Font.Size = 10
				

		objExcel.Selection.NumberFormat = "@"
		_VALORE = RTRIM(_VALORE)
		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE

		
	
		
	ENDFOR
	
	_nRIGA = _nRIGA + 1

	SELECT &_NOMECUR
	SKIP +1

	
	_lRottura1 = .F.
	IF EOF()
		_lRottura1 = .T.
	ELSE
		_cProxStringaRottura1 = ALLTRIM(ORD_CODCLI)
		IF _cActStringaRottura1 <> _cProxStringaRottura1
			_lRottura1 = .T.
		ELSE
			_CONTA_RIGHE_CLIENTE=_CONTA_RIGHE_CLIENTE+1
		ENDIF
	ENDIF

	
	*** AGGIUNGO UNA RIGA DI SEPARAZIONE ED I TOTALI PARZIALI A ROTTURA DI CLIENTE
	IF _lRottura1
		_cSaveRigheXTotale1 = _cRigheXTotale1 
		FOR I = 1 TO _NUMEROCAMPI
			_NOMECAMPO = FIELD(I,_NOMECUR)
			_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			objExcel.ActiveSheet.Range(_Range).Select
			objExcel.Selection.NumberFormat = "@"
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
			
			IF _NOMECAMPO = "ORD_VALORE"  
				objExcel.Selection.NumberFormat = "@"
				_VALORE = "Totali CLIENTE:"											&& AGGIUNGO L'ETICHETTA "Totale CLIENTE"
				objExcel.ActiveSheet.Cells(_nRIGA,I-1).Value = _VALORE 
								
				objExcel.Selection.NumberFormat = "@"
				_VALORE = RTRIM(STR(TT_ORDVALORE,13,2))								&& AGGIUNGO TOTALE LORDO A PAGARE
				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE 
				TT_ORDVALORE = 0 													&& AZZERO IL SUBTOTALE PER IL CLIENTE SUCCESSIVO
			ENDIF

			IF _NOMECAMPO = "T_NETTO"  
				objExcel.Selection.NumberFormat = "@"
				_VALORE = RTRIM(STR(TT_TNETTO,13,2))								&& AGGIUNGO TOTALE NETTO A PAGARE
				objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE 
				TT_TNETTO = 0 														&& AZZERO IL SUBTOTALE PER IL CLIENTE SUCCESSIVO
			ENDIF
	
		ENDFOR
		
		_nRIGA = _nRIGA + 1  && AGGIUNGO UNA RIGA VUOTA
		_CONTA_RIGHE_CLIENTE=0

		SELECT &_NOMECUR
	ENDIF
	
ENDDO

	
*** AGGIUNGO IL SUBTOTALE
_cSaveRigheXSubTotale = _cRigheXSubTotale
FOR I = 1 TO _NUMEROCAMPI
	_NOMECAMPO = UPPER(ALLTRIM(FIELD(I,_NOMECUR)))
	_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = "@"
	objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL

	FOR I = 1 TO _NUMEROCAMPI
		_NOMECAMPO = FIELD(I,_NOMECUR)
		_Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.NumberFormat = "@"
		objExcel.ActiveSheet.Cells(_nRIGA,I).Value = NULL
		
		*** AGGIUNGO L'ETICHETTA "Totale GENERALE"
		IF _NOMECAMPO = "ORD_VALORE"  
			objExcel.Selection.NumberFormat = "@"
			_VALORE = "Totali GENERALE:"
			objExcel.ActiveSheet.Cells(_nRIGA,I-1).Value = _VALORE 
							
			objExcel.Selection.NumberFormat = "@"
			_VALORE = RTRIM(STR(TTGE_ORDVALORE,13,2))
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE 
			TT_ORDVALORE = 0 	&& AZZERO IL SUBTOTALE PER IL CLIENTE SUCCESSIVO
		ENDIF

		IF _NOMECAMPO = "T_NETTO"  
			objExcel.Selection.NumberFormat = "@"
			_VALORE = RTRIM(STR(TTGE_TNETTO,13,2))
			objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE 
			TT_TNETTO = 0 	&& AZZERO IL SUBTOTALE PER IL CLIENTE SUCCESSIVO
		ENDIF

	ENDFOR
	
	
ENDFOR

*** RIDIMENSIONAMENTO COLONNE IN BASE AL CONTENUTO
objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	*** RIDIMENSIONAMENTO FISSO COLONNE
*!*	objExcel.ActiveSheet.Columns("D:D").ColumnWidth = 15

*** TITOLI
WITH objExcel
	.ActiveSheet.Cells(2,4).Value = _TITOLO1
	.ActiveSheet.Cells(2,4).Font.Bold = .T.
	.ActiveSheet.Cells(2,4).Font.Size = 11
	.ActiveSheet.Cells(2,4).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,4).Value = _TITOLO2
	.ActiveSheet.Cells(3,4).Font.Bold = .T.
	.ActiveSheet.Cells(3,4).Font.Size = 11
	.ActiveSheet.Cells(3,4).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,4).Value = _TITOLO3
	.ActiveSheet.Cells(4,4).Font.Bold = .T.
	.ActiveSheet.Cells(4,4).Font.Size = 11
	.ActiveSheet.Cells(4,4).HorizontalAlignment = 1
ENDWITH

objExcel.Range("A1").Select
	
objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE ESTRXLS_RICAVI_SITFINAN
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
* La procedura è personalizzata rispetto al richiamo del form MENU_SITFINAN, scheda "Ricavi progressivi"
*
* Sintassi:
* 
* DO ESTRXLS_ORDINATO_PASSIVO WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
*
********************************************************************************************************************
                                                                                
LPARAMETERS _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PCOUNT() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() < 2
	_TITOLO1 = ""
ENDIF
IF PCOUNT() < 3
	_TITOLO2 = ""
ENDIF
IF PCOUNT() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
IF RECCOUNT() > 1048575
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local objExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
objExcel.DisplayAlerts = .F.
xlLandscape = 2

WITH objExcel 
*!*		.Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*		.Visible = .f.
	.Range("A1:IV65536").Select
	*.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*		.Range("A1:IV1").Select
*!*		.Selection.Font.Size = 10
*!*		.Selection.Font.Bold = .t.
*!*		.Columns().EntireColumn.AutoFit
*!*		.Rows("1:1").EntireRow.Select
*!*		.Selection.Insert
*!*		.Selection.Insert
*!*		.Selection.Insert
	.Range("A1").Select
*!*		.ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*		.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*		.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
	
	*IF FILE(PUB_LOGO1)
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		*.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
		*.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
		*.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
*!*			.Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
		**=> ERASMO - INIZIO 10/02/2014
		.Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
		.Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
		**=> ERASMO - FINE 10/02/2014
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF

*!*		.ActiveWorkbook.Save
*!*		.ActiveWorkbook.Close
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
*!*		IF UPPER(ALLTRIM(_STRING)) $ "N_ORDINE#ORD_CHIUSO#DAGGANCIO#DATCONMOD"  && NON VISUALIZZO NEL FILE EXCEL ALCUNI CAMPI DI SOLO UTILIZZO INTERNO
*!*			nFieldNumber = nFieldNumber + 1
*!*			LOOP
*!*		ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
	_cNomeCampo = ALLTRIM(FIELD(I,_NOMECUR))
	_cIntestazione = ""
	IF "ANNO" $ _cNomeCampo
		_nAnno = VAL(PUB_ANNO) - VAL(RIGHT(_cNomeCampo,1)) + 1
		_cIntestazione = ALLTRIM(STR(_nAnno,4,0))
	ENDIF
	IF "PERC" $ _cNomeCampo
		_cIntestazione = ""
	ENDIF
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _cIntestazione
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 14
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		= 1
*!*	WITH objExcel.Selection.Borders(xlEdgeBottom)
*!*		.LineStyle = xlContinuous
*!*		.Weight = xlThin
*!*		.ColorIndex = xlAutomatic
*!*	ENDWITH
*!*	WITH objExcel.Selection.Borders(xlEdgeTop)
*!*		.LineStyle = xlContinuous
*!*		.Weight = xlThin
*!*		.ColorIndex = xlAutomatic
*!*	ENDWITH
*!*	WITH objExcel.Selection.Interior
*!*		.ColorIndex = 37
*!*		.Pattern = xlSolid
*!*	ENDWITH

xlCenter  = -4108
xlLeft	 = -4131
xlContext = -5002

xlCellValue = 1
xlGreater = 5
xlLess = 6
xlEqual = 3

*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
	
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"
	ENDIF
	
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR


_nRIGA = _RIGA_INIZIALE + 1

SELECT &_NOMECUR
GO TOP
_OLD_AGGANCIO = ""
_ULT_NRIGA_MERGE = 0
SCAN
	
	WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
*!*		_ROTTURA = .F.
*!*		IF _OLD_AGGANCIO <> DAGGANCIO
*!*			_ROTTURA = .T.
*!*			_OLD_AGGANCIO = DAGGANCIO
*!*			_ULT_NRIGA_MERGE = _nRIGA
*!*		ENDIF
	
	FOR I = 1 TO _NUMEROCAMPI
		_Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
		_VALORE = &_NOMECAMPO
		
		IF TYPE(_NOMECAMPO) = "C"
			_VALORE = ALLTRIM(&_NOMECAMPO)
			 *** SE DATA ROVESCIATA, LA RIBALTO
			 IF SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/'
			 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
			 ENDIF
		ENDIF
		
*!*			IF _ROTTURA
*!*			ELSE
*!*				IF UPPER(ALLTRIM(_NOMECAMPO)) $ "CONF#COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
*!*					_VALORE = ""
*!*				ENDIF
*!*			ENDIF
		
		WITH objExcel
			.ActiveSheet.Range(_Range).Select
			IF "PERC" $ _NOMECAMPO
				.Selection.NumberFormat = "0%"
				IF _NOMECAMPO = "PERC7"
					.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
				ELSE
					.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
				ENDIF
				
    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
    			.Selection.FormatConditions(1).Font.Color = -16752384
    			.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13561798
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
				.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
				.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
				.Selection.FormatConditions(1).Font.Color = -16383844
				.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13551615
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
			ELSE
				.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
			ENDIF
		ENDWITH
		
*!*			IF UPPER(ALLTRIM(_NOMECAMPO)) $ "QTA_ORDINATA#QTA_EVASA#QTA_RESIDUA"
*!*				objExcel.Selection.Interior.Color = IIF(ORD_CHIUSO, RGB(0,255,0), IIF(QTA_EVASA > 0 AND (QTA_ORDINATA - QTA_EVASA) > 0, RGB(255,128,0), IIF(MOD(N_ORDINE,2)=0, RGB(217,217,255), RGB(255,255,255))))
*!*			ELSE
*!*				objExcel.Selection.Interior.Color = IIF(ORD_CHIUSO, RGB(0,255,0), IIF(MOD(N_ORDINE,2)=0, RGB(217,217,255), RGB(255,255,255)))
*!*			ENDIF
		
*!*			**=> ERASMO - INIZIO 19/04/2017
*!*			SELECT &_NOMECUR
*!*			IF TYPE("DATCONMOD") <> 'U'	&& ERASMO - 19/01/2018
*!*				IF UPPER(ALLTRIM(_NOMECAMPO)) = "DATA_PREV_CONSEGNA" AND DATCONMOD
*!*					objExcel.Selection.Font.ColorIndex = 3
*!*				ENDIF
*!*			ENDIF							&& ERASMO - 19/01/2018
*!*			**=> ERASMO - FINE 19/04/2017
		
*!*			*** UNISCI E CENTRA
*!*			IF UPPER(ALLTRIM(_NOMECAMPO)) $ "COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
*!*				_Range = n2c(I) + ALLTRIM(STR(_ULT_NRIGA_MERGE,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
*!*				objExcel.ActiveSheet.Range(_Range).Select
*!*				objExcel.Selection.Merge
*!*				WITH objExcel.Selection
*!*				  .HorizontalAlignment = xlLeft
*!*				  .VerticalAlignment = xlCenter
*!*				  .WrapText = .F.
*!*				  .Orientation = 0
*!*				  .AddIndent = .F.
*!*				  .IndentLevel = 0
*!*				  .ShrinkToFit = .F.
*!*				  .ReadingOrder = xlContext
*!*				  .MergeCells = .T.
*!*				ENDWITH
*!*			ENDIF
			
*!*		 With Selection
*!*			  .HorizontalAlignment = xlCenter
*!*			  .VerticalAlignment = xlBottom
*!*			  .WrapText = False
*!*			  .Orientation = 0
*!*			  .AddIndent = False
*!*			  .IndentLevel = 0
*!*			  .ShrinkToFit = False
*!*			  .ReadingOrder = xlContext
*!*			  .MergeCells = False
*!*		 End With
*!*		 Selection.Merge
*!*		 With Selection
*!*			  .HorizontalAlignment = xlCenter
*!*			  .VerticalAlignment = xlCenter
*!*			  .WrapText = False
*!*			  .Orientation = 0
*!*			  .AddIndent = False
*!*			  .IndentLevel = 0
*!*			  .ShrinkToFit = False
*!*			  .ReadingOrder = xlContext
*!*			  .MergeCells = True
*!*		 End With
*!*		 With Selection
*!*			  .HorizontalAlignment = xlLeft
*!*			  .VerticalAlignment = xlCenter
*!*			  .WrapText = False
*!*			  .Orientation = 0
*!*			  .AddIndent = False
*!*			  .IndentLevel = 0
*!*			  .ShrinkToFit = False
*!*			  .ReadingOrder = xlContext
*!*			  .MergeCells = True
*!*		 End With
	ENDFOR
	
	_nRIGA = _nRIGA + 1
ENDSCAN

*** AUTOFIT COLONNE
*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
WITH objExcel
     .Columns("A:A").ColumnWidth = 15
     .Columns("B:B").ColumnWidth = 20
     .Columns("C:C").ColumnWidth = 20
     .Columns("D:D").ColumnWidth = 7
     .Columns("E:E").ColumnWidth = 20
     .Columns("F:F").ColumnWidth = 7
     .Columns("G:G").ColumnWidth = 20
     .Columns("H:H").ColumnWidth = 7
     .Columns("I:I").ColumnWidth = 20
     .Columns("J:J").ColumnWidth = 7
     .Columns("K:K").ColumnWidth = 20
     .Columns("L:L").ColumnWidth = 7
     .Columns("M:M").ColumnWidth = 20
     .Columns("N:N").ColumnWidth = 7
     .Columns("O:O").ColumnWidth = 20
     .Columns("P:P").ColumnWidth = 7
ENDWITH

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
WITH objExcel
	_T_RIGA  = _nRIGA + 1
	.ActiveSheet.Cells(_T_RIGA,1).Value = "Totale anno"
	_Range  = n2c(1) + ALLTRIM(STR(_T_RIGA,10,0))
	.Range(_RANGE).Select
	.Selection.Font.Bold = .t.
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			IF "PERC" $ _NOMECAMPO
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "0%"
				IF _NOMECAMPO = "PERC7"
					.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
				ELSE
					.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
				ENDIF
    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
    			.Selection.FormatConditions(1).Font.Color = -16752384
    			.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13561798
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
				.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
				.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
				.Selection.FormatConditions(1).Font.Color = -16383844
				.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13551615
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
			ELSE
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .T.
			ENDIF
		ENDIF
	ENDFOR
ENDWITH

*** MEDIE DINAMICHE SU TUTTI I CAMPI NUMERICI (CON PERCENTUALI PROGRESSIVE)
WITH objExcel
	_T_RIGA  = _nRIGA + 2
	.ActiveSheet.Cells(_T_RIGA,1).Value = "Media mensile"
	_Range  = n2c(1) + ALLTRIM(STR(_T_RIGA,10,0))
	.Range(_RANGE).Select
	.Selection.Font.Bold = .T.
	.Selection.Font.Italic = .T.
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			IF "PERC" $ _NOMECAMPO
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "0%"
				IF _NOMECAMPO = "PERC7"
					.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
				ELSE
					.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
				ENDIF
    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
    			.Selection.FormatConditions(1).Font.Color = -16752384
    			.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13561798
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
				.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
				.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
				.Selection.FormatConditions(1).Font.Color = -16383844
				.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13551615
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
			ELSE
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C) / 12"
				.Selection.Font.Bold = .T.
			ENDIF
			.Selection.Font.Italic = .T.
		ENDIF
	ENDFOR
ENDWITH

*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
WITH objExcel
	.ActiveSheet.Cells(2,6).Value = _TITOLO1
	.ActiveSheet.Cells(2,6).Font.Bold = .T.
	.ActiveSheet.Cells(2,6).Font.Size = 11
	.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(2,6).WrapText = .F.

	.ActiveSheet.Cells(3,6).Value = _TITOLO2
	.ActiveSheet.Cells(3,6).Font.Bold = .T.
	.ActiveSheet.Cells(3,6).Font.Size = 11
	.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(3,6).WrapText = .F.

	.ActiveSheet.Cells(4,6).Value = _TITOLO3
	.ActiveSheet.Cells(4,6).Font.Bold = .T.
	.ActiveSheet.Cells(4,6).Font.Size = 11
	.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(4,6).WrapText = .F.
ENDWITH

objExcel.Range("A1").Select

objExcel.Visible = .t.

WAIT CLEAR

ENDPROC


************************************************************************
PROCEDURE ESTRXLS_FATRIEP_ANNO
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
* La procedura è personalizzata rispetto al richiamo del form FATRIEP_ANNO, scheda "Fatturato clienti"
*
* Sintassi:
* 
* DO ESTRXLS_ORDINATO_PASSIVO WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
*
********************************************************************************************************************
                                                                                
LPARAMETERS _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3

IF PCOUNT() = 0
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() < 2
	_TITOLO1 = ""
ENDIF
IF PCOUNT() < 3
	_TITOLO2 = ""
ENDIF
IF PCOUNT() < 4
	_TITOLO3 = ""
ENDIF

SELECT &_NOMECUR
GO TOP
IF RECCOUNT() > 1048575
	MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local objExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
objExcel.DisplayAlerts = .F.
xlLandscape = 2

WITH objExcel
	.Range("A1:IV65536").Select
	.Range("A1").Select
	
	IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
		_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
		.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
		.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
		.Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
		.Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
		.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
		.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
	ENDIF
ENDWITH

nFieldNumber = 1
_STRING		= ""
_NUMEROCAMPI = 0
DO WHILE .T.
	_STRING = FIELDS(nFieldNumber,_NOMECUR)
	IF EMPTY(ALLTRIM(_STRING))
		EXIT
	ENDIF
*!*		IF UPPER(ALLTRIM(_STRING)) $ "N_ORDINE#ORD_CHIUSO#DAGGANCIO#DATCONMOD"  && NON VISUALIZZO NEL FILE EXCEL ALCUNI CAMPI DI SOLO UTILIZZO INTERNO
*!*			nFieldNumber = nFieldNumber + 1
*!*			LOOP
*!*		ENDIF
	_NUMEROCAMPI = _NUMEROCAMPI + 1
	nFieldNumber = nFieldNumber + 1
ENDDO

_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
	_cNomeCampo = ALLTRIM(FIELD(I,_NOMECUR))
	_cIntestazione = ""
	IF "ANNO" $ _cNomeCampo
		_nAnno = VAL(PUB_ANNO) - VAL(RIGHT(_cNomeCampo,1)) + 1
		_cIntestazione = ALLTRIM(STR(_nAnno,4,0))
	ENDIF
	IF "PERC" $ _cNomeCampo
		_cIntestazione = ""
	ENDIF
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _cIntestazione
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 14
	objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeTop	 = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin		 = 2
xlAutomatic  = -4105
xlSolid		= 1
*!*	WITH objExcel.Selection.Borders(xlEdgeBottom)
*!*		.LineStyle = xlContinuous
*!*		.Weight = xlThin
*!*		.ColorIndex = xlAutomatic
*!*	ENDWITH
*!*	WITH objExcel.Selection.Borders(xlEdgeTop)
*!*		.LineStyle = xlContinuous
*!*		.Weight = xlThin
*!*		.ColorIndex = xlAutomatic
*!*	ENDWITH
*!*	WITH objExcel.Selection.Interior
*!*		.ColorIndex = 37
*!*		.Pattern = xlSolid
*!*	ENDWITH

xlCenter  = -4108
xlLeft	 = -4131
xlContext = -5002

xlCellValue = 1
xlGreater = 5
xlLess = 6
xlEqual = 3

*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
SELECT &_NOMECUR
GO TOP
FOR I = 1 TO _NUMEROCAMPI
	_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
	_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
	_NFORMAT = "@"
	
	IF TYPE(_NOMECAMPO) = "N"
		_NFORMAT = "#,##0.00"
	ENDIF
	
	objExcel.ActiveSheet.Range(_Range).Select
	objExcel.Selection.NumberFormat = _NFORMAT
ENDFOR


_nRIGA = _RIGA_INIZIALE + 1

SELECT &_NOMECUR
GO TOP
_OLD_AGGANCIO = ""
_ULT_NRIGA_MERGE = 0
SCAN
	
	WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
*!*		_ROTTURA = .F.
*!*		IF _OLD_AGGANCIO <> DAGGANCIO
*!*			_ROTTURA = .T.
*!*			_OLD_AGGANCIO = DAGGANCIO
*!*			_ULT_NRIGA_MERGE = _nRIGA
*!*		ENDIF
	
	FOR I = 1 TO _NUMEROCAMPI
		_Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
		_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
		_VALORE = &_NOMECAMPO
		
		IF TYPE(_NOMECAMPO) = "C"
			_VALORE = ALLTRIM(&_NOMECAMPO)
			 *** SE DATA ROVESCIATA, LA RIBALTO
			 IF SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/'
			 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
			 ENDIF
		ENDIF
		
*!*			IF _ROTTURA
*!*			ELSE
*!*				IF UPPER(ALLTRIM(_NOMECAMPO)) $ "CONF#COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
*!*					_VALORE = ""
*!*				ENDIF
*!*			ENDIF
		
		WITH objExcel
			.ActiveSheet.Range(_Range).Select
			IF "PERC" $ _NOMECAMPO
				.Selection.NumberFormat = "0%"
				IF _NOMECAMPO = "PERC7"
					.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
				ELSE
					.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
				ENDIF
				
    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
    			.Selection.FormatConditions(1).Font.Color = -16752384
    			.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13561798
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
				.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
				.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
				.Selection.FormatConditions(1).Font.Color = -16383844
				.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13551615
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
			ELSE
				.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
			ENDIF
		ENDWITH
		
*!*			IF UPPER(ALLTRIM(_NOMECAMPO)) $ "QTA_ORDINATA#QTA_EVASA#QTA_RESIDUA"
*!*				objExcel.Selection.Interior.Color = IIF(ORD_CHIUSO, RGB(0,255,0), IIF(QTA_EVASA > 0 AND (QTA_ORDINATA - QTA_EVASA) > 0, RGB(255,128,0), IIF(MOD(N_ORDINE,2)=0, RGB(217,217,255), RGB(255,255,255))))
*!*			ELSE
*!*				objExcel.Selection.Interior.Color = IIF(ORD_CHIUSO, RGB(0,255,0), IIF(MOD(N_ORDINE,2)=0, RGB(217,217,255), RGB(255,255,255)))
*!*			ENDIF
		
*!*			**=> ERASMO - INIZIO 19/04/2017
*!*			SELECT &_NOMECUR
*!*			IF TYPE("DATCONMOD") <> 'U'	&& ERASMO - 19/01/2018
*!*				IF UPPER(ALLTRIM(_NOMECAMPO)) = "DATA_PREV_CONSEGNA" AND DATCONMOD
*!*					objExcel.Selection.Font.ColorIndex = 3
*!*				ENDIF
*!*			ENDIF							&& ERASMO - 19/01/2018
*!*			**=> ERASMO - FINE 19/04/2017
		
*!*			*** UNISCI E CENTRA
*!*			IF UPPER(ALLTRIM(_NOMECAMPO)) $ "COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
*!*				_Range = n2c(I) + ALLTRIM(STR(_ULT_NRIGA_MERGE,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
*!*				objExcel.ActiveSheet.Range(_Range).Select
*!*				objExcel.Selection.Merge
*!*				WITH objExcel.Selection
*!*				  .HorizontalAlignment = xlLeft
*!*				  .VerticalAlignment = xlCenter
*!*				  .WrapText = .F.
*!*				  .Orientation = 0
*!*				  .AddIndent = .F.
*!*				  .IndentLevel = 0
*!*				  .ShrinkToFit = .F.
*!*				  .ReadingOrder = xlContext
*!*				  .MergeCells = .T.
*!*				ENDWITH
*!*			ENDIF
			
*!*		 With Selection
*!*			  .HorizontalAlignment = xlCenter
*!*			  .VerticalAlignment = xlBottom
*!*			  .WrapText = False
*!*			  .Orientation = 0
*!*			  .AddIndent = False
*!*			  .IndentLevel = 0
*!*			  .ShrinkToFit = False
*!*			  .ReadingOrder = xlContext
*!*			  .MergeCells = False
*!*		 End With
*!*		 Selection.Merge
*!*		 With Selection
*!*			  .HorizontalAlignment = xlCenter
*!*			  .VerticalAlignment = xlCenter
*!*			  .WrapText = False
*!*			  .Orientation = 0
*!*			  .AddIndent = False
*!*			  .IndentLevel = 0
*!*			  .ShrinkToFit = False
*!*			  .ReadingOrder = xlContext
*!*			  .MergeCells = True
*!*		 End With
*!*		 With Selection
*!*			  .HorizontalAlignment = xlLeft
*!*			  .VerticalAlignment = xlCenter
*!*			  .WrapText = False
*!*			  .Orientation = 0
*!*			  .AddIndent = False
*!*			  .IndentLevel = 0
*!*			  .ShrinkToFit = False
*!*			  .ReadingOrder = xlContext
*!*			  .MergeCells = True
*!*		 End With
	ENDFOR
	
	_nRIGA = _nRIGA + 1
ENDSCAN

*** AUTOFIT COLONNE
*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
WITH objExcel
     .Columns("A:A").ColumnWidth = 15
     .Columns("B:B").ColumnWidth = 20
     .Columns("C:C").ColumnWidth = 20
     .Columns("D:D").ColumnWidth = 7
     .Columns("E:E").ColumnWidth = 20
     .Columns("F:F").ColumnWidth = 7
     .Columns("G:G").ColumnWidth = 20
     .Columns("H:H").ColumnWidth = 7
     .Columns("I:I").ColumnWidth = 20
     .Columns("J:J").ColumnWidth = 7
     .Columns("K:K").ColumnWidth = 20
     .Columns("L:L").ColumnWidth = 7
     .Columns("M:M").ColumnWidth = 20
     .Columns("N:N").ColumnWidth = 7
     .Columns("O:O").ColumnWidth = 20
     .Columns("P:P").ColumnWidth = 7
ENDWITH

*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
WITH objExcel
	_T_RIGA  = _nRIGA + 1
	.ActiveSheet.Cells(_T_RIGA,1).Value = "Totale anno"
	_Range  = n2c(1) + ALLTRIM(STR(_T_RIGA,10,0))
	.Range(_RANGE).Select
	.Selection.Font.Bold = .t.
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			IF "PERC" $ _NOMECAMPO
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "0%"
				IF _NOMECAMPO = "PERC7"
					.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
				ELSE
					.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
				ENDIF
    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
    			.Selection.FormatConditions(1).Font.Color = -16752384
    			.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13561798
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
				.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
				.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
				.Selection.FormatConditions(1).Font.Color = -16383844
				.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13551615
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
			ELSE
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .T.
			ENDIF
		ENDIF
	ENDFOR
ENDWITH

*** MEDIE DINAMICHE SU TUTTI I CAMPI NUMERICI (CON PERCENTUALI PROGRESSIVE)
WITH objExcel
	_T_RIGA  = _nRIGA + 2
	.ActiveSheet.Cells(_T_RIGA,1).Value = "Media mensile"
	_Range  = n2c(1) + ALLTRIM(STR(_T_RIGA,10,0))
	.Range(_RANGE).Select
	.Selection.Font.Bold = .T.
	.Selection.Font.Italic = .T.
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			IF "PERC" $ _NOMECAMPO
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "0%"
				IF _NOMECAMPO = "PERC7"
					.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
				ELSE
					.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
				ENDIF
    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
    			.Selection.FormatConditions(1).Font.Color = -16752384
    			.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13561798
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
				.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
				.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
				.Selection.FormatConditions(1).Font.Color = -16383844
				.Selection.FormatConditions(1).Font.TintAndShade = 0
				.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
				.Selection.FormatConditions(1).Interior.Color = 13551615
				.Selection.FormatConditions(1).Interior.TintAndShade = 0
				.Selection.FormatConditions(1).StopIfTrue = .F.
			ELSE
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C) / 12"
				.Selection.Font.Bold = .T.
			ENDIF
			.Selection.Font.Italic = .T.
		ENDIF
	ENDFOR
ENDWITH

*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
WITH objExcel
	.ActiveSheet.Cells(2,6).Value = _TITOLO1
	.ActiveSheet.Cells(2,6).Font.Bold = .T.
	.ActiveSheet.Cells(2,6).Font.Size = 11
	.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(2,6).WrapText = .F.

	.ActiveSheet.Cells(3,6).Value = _TITOLO2
	.ActiveSheet.Cells(3,6).Font.Bold = .T.
	.ActiveSheet.Cells(3,6).Font.Size = 11
	.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(3,6).WrapText = .F.

	.ActiveSheet.Cells(4,6).Value = _TITOLO3
	.ActiveSheet.Cells(4,6).Font.Bold = .T.
	.ActiveSheet.Cells(4,6).Font.Size = 11
	.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
	.ActiveSheet.Cells(4,6).WrapText = .F.
ENDWITH

_newSheetName = "Complessivo"
WITH objExcel
	_activeSheet = .ActiveSheet
	_strNome = .ActiveSheet.Name
	.Sheets(_strNome).Select
	.Sheets(_strNome).Name = _newSheetName
ENDWITH

objExcel.Range("A1").Select


*** SE PRESENTI RIEPILOGHI PER CATEGORIE NON VUOTE, COSTRUISCE NUOVI FOGLI PER CATEGORIA
_NOMECUR_CATEG = _NOMECUR + "_CATEG"
IF !USED(_NOMECUR_CATEG)
	objExcel.Visible = .t.
	RETURN
ENDIF

_TOT_CATEGORIE_NON_VUOTE = 0
SELECT CATEGORIA, DESCR_CATEGORIA FROM &_NOMECUR_CATEG GROUP BY CATEGORIA, DESCR_CATEGORIA INTO CURSOR TMP_ELEN_CATEG
SELECT TMP_ELEN_CATEG
GO TOP
SCAN
	IF ALLTRIM(CATEGORIA) == "Z"
		LOOP
	ENDIF
	_TOT_CATEGORIE_NON_VUOTE = _TOT_CATEGORIE_NON_VUOTE + 1
ENDSCAN

IF _TOT_CATEGORIE_NON_VUOTE > 0
ELSE
	objExcel.Visible = .t.
	RETURN
ENDIF

_strMainSheetName = objExcel.ActiveSheet.Name

SELECT TMP_ELEN_CATEG
GO TOP
SCAN
	
	SCATTER MEMVAR
	
	_newSheetName = STRTRAN(ALLTRIM(SUBSTR(ALLTRIM(M.DESCR_CATEGORIA),1,31)),"/","-")
	IF EMPTY(_newSheetName)
		_newSheetName = "Altro"
	ENDIF
	
	SELECT &_NOMECUR_CATEG
	SET FILTER TO ALLTRIM(CATEGORIA) = ALLTRIM(M.CATEGORIA)
	SET ORDER TO I_C_MESE
	GO TOP
	
	WITH objExcel
		_activeSheet = .ActiveSheet
		.Sheets.Add(,_activeSheet)
	    _strNome = .ActiveSheet.Name
	    .Sheets(_strNome).Select
	    .Sheets(_strNome).Name = _newSheetName
	ENDWITH
         
*!*	         IF EMPTY(ALLTRIM(_ULT_CODICE))
*!*	         ELSE
*!*	            strNome = .ActiveSheet.Name
*!*	            .Sheets(strNome).Select
*!*	            .Sheets(strNome).Move(NULL,.Sheets(last_strNome))
*!*	         ENDIF

	WITH objExcel
		.Range("A1:IV65536").Select
		.Range("A1").Select
		
		IF FILE(PUB_LOGO1) AND PUB_INTXLS  && ERASMO - 25/09/2015
			_FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
			.ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
			.Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
			.Selection.ShapeRange.Width = MIN(.Selection.ShapeRange.Width,300) && regola la larghezza massima del logo azienda 
			.Selection.ShapeRange.Height = MIN(.Selection.ShapeRange.Height,50) && regola l'altezza massima del logo azienda
			.Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009	 
			.Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
		ENDIF
	ENDWITH

*!*		nFieldNumber = 1
*!*		_STRING		= ""
*!*		_NUMEROCAMPI = 0
*!*		DO WHILE .T.
*!*			_STRING = FIELDS(nFieldNumber,_NOMECUR_CATEG)
*!*			IF EMPTY(ALLTRIM(_STRING))
*!*				EXIT
*!*			ENDIF
*!*		*!*		IF UPPER(ALLTRIM(_STRING)) $ "N_ORDINE#ORD_CHIUSO#DAGGANCIO#DATCONMOD"  && NON VISUALIZZO NEL FILE EXCEL ALCUNI CAMPI DI SOLO UTILIZZO INTERNO
*!*		*!*			nFieldNumber = nFieldNumber + 1
*!*		*!*			LOOP
*!*		*!*		ENDIF
*!*			_NUMEROCAMPI = _NUMEROCAMPI + 1
*!*			nFieldNumber = nFieldNumber + 1
*!*		ENDDO

	_RIGA_INIZIALE = 6

	FOR I = 1 TO _NUMEROCAMPI
		_cNomeCampo = ALLTRIM(FIELD(I,_NOMECUR_CATEG))
		_cIntestazione = ""
		IF "ANNO" $ _cNomeCampo
			_nAnno = VAL(PUB_ANNO) - VAL(RIGHT(_cNomeCampo,1)) + 1
			_cIntestazione = ALLTRIM(STR(_nAnno,4,0))
		ENDIF
		IF "PERC" $ _cNomeCampo
			_cIntestazione = ""
		ENDIF
		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = _cIntestazione
		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 14
		objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
	ENDFOR

	_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
	objExcel.ActiveSheet.Range(_Range).Select

	xlEdgeTop	 = 8
	xlEdgeBottom = 9
	xlContinuous = 1
	xlThin		 = 2
	xlAutomatic  = -4105
	xlSolid		= 1
	*!*	WITH objExcel.Selection.Borders(xlEdgeBottom)
	*!*		.LineStyle = xlContinuous
	*!*		.Weight = xlThin
	*!*		.ColorIndex = xlAutomatic
	*!*	ENDWITH
	*!*	WITH objExcel.Selection.Borders(xlEdgeTop)
	*!*		.LineStyle = xlContinuous
	*!*		.Weight = xlThin
	*!*		.ColorIndex = xlAutomatic
	*!*	ENDWITH
	*!*	WITH objExcel.Selection.Interior
	*!*		.ColorIndex = 37
	*!*		.Pattern = xlSolid
	*!*	ENDWITH

	xlCenter  = -4108
	xlLeft	 = -4131
	xlContext = -5002

	xlCellValue = 1
	xlGreater = 5
	xlLess = 6
	xlEqual = 3

	*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

	*** FORMATTAZIONE COLONNE (PRIMA DI TUTTO ALTRIMENTI SBALLA SUI FORMATI DATA(GESTITI COME TESTO) --> GENERAL)
	SELECT &_NOMECUR_CATEG
	GO TOP
	FOR I = 1 TO _NUMEROCAMPI
		_Range = n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + 1,10,0)) + ":" + n2c(I) + ALLTRIM(STR(_RIGA_INIZIALE + RECCOUNT() + 2,10,0))
		_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR_CATEG))
		_NFORMAT = "@"
		
		IF TYPE(_NOMECAMPO) = "N"
			_NFORMAT = "#,##0.00"
		ENDIF
		
		objExcel.ActiveSheet.Range(_Range).Select
		objExcel.Selection.NumberFormat = _NFORMAT
	ENDFOR
	
	_TOT_RECORD = 0
	SELECT &_NOMECUR_CATEG
	GO TOP
	SCAN
		_TOT_RECORD = _TOT_RECORD + 1
	ENDSCAN
	_CONTA_RECORD = 0

	_nRIGA = _RIGA_INIZIALE + 1

	SELECT &_NOMECUR_CATEG
	GO TOP
	_OLD_AGGANCIO = ""
	_ULT_NRIGA_MERGE = 0
	SCAN
	
		_CONTA_RECORD = _CONTA_RECORD + 1
		
		WAIT WINDOWS "Creazione foglio excel in corso (foglio '" + _newSheetName + "')... - riga " + ALLTRIM(STR(_CONTA_RECORD)) + " di " + ALLTRIM(STR(_TOT_RECORD)) NOWAIT
		
	*!*		_ROTTURA = .F.
	*!*		IF _OLD_AGGANCIO <> DAGGANCIO
	*!*			_ROTTURA = .T.
	*!*			_OLD_AGGANCIO = DAGGANCIO
	*!*			_ULT_NRIGA_MERGE = _nRIGA
	*!*		ENDIF
		
		FOR I = 1 TO _NUMEROCAMPI
			_Range = n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
			_NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR_CATEG))
			_VALORE = &_NOMECAMPO
			
			IF TYPE(_NOMECAMPO) = "C"
				_VALORE = ALLTRIM(&_NOMECAMPO)
				 *** SE DATA ROVESCIATA, LA RIBALTO
				 IF SUBSTR(ALLTRIM(&_NOMECAMPO),5,1) = '/' AND SUBSTR(ALLTRIM(&_NOMECAMPO),8,1) = '/'
				 	_VALORE = RIBALTA2(ALLTRIM(&_NOMECAMPO))
				 ENDIF
			ENDIF
			
	*!*			IF _ROTTURA
	*!*			ELSE
	*!*				IF UPPER(ALLTRIM(_NOMECAMPO)) $ "CONF#COD_FORNITORE#RAG_SOCIALE#CAUSALE#NUM_ORDINE#DATA_ORDINE#CONDIZ_PAGAMENTO"
	*!*					_VALORE = ""
	*!*				ENDIF
	*!*			ENDIF
			
			WITH objExcel
				.ActiveSheet.Range(_Range).Select
				IF "PERC" $ _NOMECAMPO
					.Selection.NumberFormat = "0%"
					IF _NOMECAMPO = "PERC7"
						.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
					ELSE
						.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
					ENDIF
					
	    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
	    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
	    			.Selection.FormatConditions(1).Font.Color = -16752384
	    			.Selection.FormatConditions(1).Font.TintAndShade = 0
					.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
					.Selection.FormatConditions(1).Interior.Color = 13561798
					.Selection.FormatConditions(1).Interior.TintAndShade = 0
					.Selection.FormatConditions(1).StopIfTrue = .F.
					.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
					.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
					.Selection.FormatConditions(1).Font.Color = -16383844
					.Selection.FormatConditions(1).Font.TintAndShade = 0
					.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
					.Selection.FormatConditions(1).Interior.Color = 13551615
					.Selection.FormatConditions(1).Interior.TintAndShade = 0
					.Selection.FormatConditions(1).StopIfTrue = .F.
				ELSE
					.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE
				ENDIF
			ENDWITH
		ENDFOR
		
		_nRIGA = _nRIGA + 1
	ENDSCAN

	*** AUTOFIT COLONNE
	*objExcel.ActiveSheet.Columns().EntireColumn.AutoFit
	WITH objExcel
	     .Columns("A:A").ColumnWidth = 15
	     .Columns("B:B").ColumnWidth = 20
	     .Columns("C:C").ColumnWidth = 20
	     .Columns("D:D").ColumnWidth = 7
	     .Columns("E:E").ColumnWidth = 20
	     .Columns("F:F").ColumnWidth = 7
	     .Columns("G:G").ColumnWidth = 20
	     .Columns("H:H").ColumnWidth = 7
	     .Columns("I:I").ColumnWidth = 20
	     .Columns("J:J").ColumnWidth = 7
	     .Columns("K:K").ColumnWidth = 20
	     .Columns("L:L").ColumnWidth = 7
	     .Columns("M:M").ColumnWidth = 20
	     .Columns("N:N").ColumnWidth = 7
	     .Columns("O:O").ColumnWidth = 20
	     .Columns("P:P").ColumnWidth = 7
	ENDWITH

	*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
	WITH objExcel
		_T_RIGA  = _nRIGA + 1
		.ActiveSheet.Cells(_T_RIGA,1).Value = "Totale anno"
		_Range  = n2c(1) + ALLTRIM(STR(_T_RIGA,10,0))
		.Range(_RANGE).Select
		.Selection.Font.Bold = .t.
		_RIF_SUM = _nRIGA - _RIGA_INIZIALE
		FOR I = 1 TO FCOUNT(_NOMECUR_CATEG)
			_NOMECAMPO = FIELD(I,_NOMECUR_CATEG)
			IF TYPE(_NOMECAMPO) = "N"
				IF "PERC" $ _NOMECAMPO
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "0%"
					IF _NOMECAMPO = "PERC7"
						.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
					ELSE
						.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
					ENDIF
	    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
	    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
	    			.Selection.FormatConditions(1).Font.Color = -16752384
	    			.Selection.FormatConditions(1).Font.TintAndShade = 0
					.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
					.Selection.FormatConditions(1).Interior.Color = 13561798
					.Selection.FormatConditions(1).Interior.TintAndShade = 0
					.Selection.FormatConditions(1).StopIfTrue = .F.
					.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
					.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
					.Selection.FormatConditions(1).Font.Color = -16383844
					.Selection.FormatConditions(1).Font.TintAndShade = 0
					.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
					.Selection.FormatConditions(1).Interior.Color = 13551615
					.Selection.FormatConditions(1).Interior.TintAndShade = 0
					.Selection.FormatConditions(1).StopIfTrue = .F.
				ELSE
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
					.Selection.Font.Bold = .T.
				ENDIF
			ENDIF
		ENDFOR
	ENDWITH

	*** MEDIE DINAMICHE SU TUTTI I CAMPI NUMERICI (CON PERCENTUALI PROGRESSIVE)
	WITH objExcel
		_T_RIGA  = _nRIGA + 2
		.ActiveSheet.Cells(_T_RIGA,1).Value = "Media mensile"
		_Range  = n2c(1) + ALLTRIM(STR(_T_RIGA,10,0))
		.Range(_RANGE).Select
		.Selection.Font.Bold = .T.
		.Selection.Font.Italic = .T.
		_RIF_SUM = _nRIGA - _RIGA_INIZIALE
		FOR I = 1 TO FCOUNT(_NOMECUR_CATEG)
			_NOMECAMPO = FIELD(I,_NOMECUR_CATEG)
			IF TYPE(_NOMECAMPO) = "N"
				IF "PERC" $ _NOMECAMPO
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "0%"
					IF _NOMECAMPO = "PERC7"
						.ActiveCell.FormulaR1C1 = "=IF(RC[-2] <> 0, (RC[-1] - RC[-2]) / RC[-2], 0)"
					ELSE
						.ActiveCell.FormulaR1C1 = "=IF(RC[-3] <> 0, (RC[-1] - RC[-3]) / RC[-3], 0)"
					ENDIF
	    			.Selection.FormatConditions.Add(xlCellValue, xlGreater, "0")    			
	    			.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
	    			.Selection.FormatConditions(1).Font.Color = -16752384
	    			.Selection.FormatConditions(1).Font.TintAndShade = 0
					.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
					.Selection.FormatConditions(1).Interior.Color = 13561798
					.Selection.FormatConditions(1).Interior.TintAndShade = 0
					.Selection.FormatConditions(1).StopIfTrue = .F.
					.Selection.FormatConditions.Add(xlCellValue, xlLess, "0")
					.Selection.FormatConditions(.Selection.FormatConditions.Count).SetFirstPriority
					.Selection.FormatConditions(1).Font.Color = -16383844
					.Selection.FormatConditions(1).Font.TintAndShade = 0
					.Selection.FormatConditions(1).Interior.PatternColorIndex = xlAutomatic
					.Selection.FormatConditions(1).Interior.Color = 13551615
					.Selection.FormatConditions(1).Interior.TintAndShade = 0
					.Selection.FormatConditions(1).StopIfTrue = .F.
				ELSE
					_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
					.Range(_RANGE).Select
					.Selection.NumberFormat = "#,##0.00"
					.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C) / 12"
					.Selection.Font.Bold = .T.
				ENDIF
				.Selection.Font.Italic = .T.
			ENDIF
		ENDFOR
	ENDWITH

	*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
	WITH objExcel
		.ActiveSheet.Cells(2,6).Value = _TITOLO1 + " (" + _newSheetName + ")"
		.ActiveSheet.Cells(2,6).Font.Bold = .T.
		.ActiveSheet.Cells(2,6).Font.Size = 11
		.ActiveSheet.Cells(2,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(2,6).WrapText = .F.

		.ActiveSheet.Cells(3,6).Value = _TITOLO2
		.ActiveSheet.Cells(3,6).Font.Bold = .T.
		.ActiveSheet.Cells(3,6).Font.Size = 11
		.ActiveSheet.Cells(3,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(3,6).WrapText = .F.

		.ActiveSheet.Cells(4,6).Value = _TITOLO3
		.ActiveSheet.Cells(4,6).Font.Bold = .T.
		.ActiveSheet.Cells(4,6).Font.Size = 11
		.ActiveSheet.Cells(4,6).HorizontalAlignment = 1
		.ActiveSheet.Cells(4,6).WrapText = .F.
	ENDWITH

	objExcel.Range("A1").Select

	WAIT CLEAR

ENDSCAN

objExcel.Sheets(_strMainSheetName).Select

objExcel.Visible = .t.

WAIT CLEAR

ENDPROC