* Simple automation with Excel.  Just copy this faq into prg file and run it.
  
* include an EXCEL header file and reference values by name.
* #INCLUDE C:\MyProject\INCLUDE\xl5en32.h
* If you do not have a header file and need to create one.  Refer to FAQ:
* How to create office header files in VFP FAQ184-2749

* creates random numbers for quarterly data.
* adds some detail records

    
* Excel: HorizontalAlignment
* 2 = Left
* 3 = Center
* 4 = Right


WAIT WINDOW "Attendere prego... elaborazione tabulato Excel in corso" NOWAIT

local oExcel, oSheet
oExcel = CreateObject([Excel.Application])
oExcel.Visible = .F.
oExcel.Workbooks.Add()
*oExcel.Workbooks.Open(SYS(2003)+"\REPORT\TABULATO_TESORERIA.xls")
*oExcel.ActiveWorkbook.SaveAs(SYS(2003)+"\REPORT\TABULATO_TESORERIA_TMP.xls",,,,,.F.)


oSheet = oExcel.ActiveSheet

oExcel.Range("A3").Select
oSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select
oExcel.Selection.ShapeRange.LockAspectRatio = -1
oExcel.Selection.ShapeRange.Height = 65.25
oExcel.Selection.ShapeRange.Width = 159.75


*CLOSE DATABASES ALL
*USE C:\CMOVI  ALIAS MOVIMENTI IN 0 AGAIN
*
*USE C:\SALDI ALIAS SALDI IN 0 AGAIN    

*** FABIANO 18/12/2005
*** NON SELEZIONO SOLO I CONTI CORRENTI UTILIZZATI MA TUTTI
***
*** PRIMA ERA COSI'
* seleziona i conti correnti utilizzati
*
* SELECT * ;
* FROM SALDI ;
* WHERE CONTOCONT IN (;
* 	SELECT CODRIS_DA AS CONTOCONT FROM MOVIMENTI ) ;
* 	OR CONTOCONT IN (;
* 	SELECT CODRIS_A AS CONTOCONT FROM MOVIMENTI ) ;
* ORDER BY DESRISORSA ;
* INTO CURSOR _CURCC

*** SELEZIONO TUTTI I CONTI CORRENTI
SELECT * ;
FROM SALDI ;
ORDER BY DESRISORSA ;
INTO CURSOR _CURCC

SELECT 	RECNO() AS POSIZIONE,;
		_CURCC.* ;
FROM _CURCC ;
INTO CURSOR SOLO_QUESTE


* SELECT SUBSTR(DES_MOVIME,1,4) AS TIPOMOVI,;
* 		* ;
* FROM MOVIMENTI ;
* INTO CURSOR _CURMOVI

SELECT TIPOLOGIA AS TIPOMOVI,;
		* ;
FROM MOVIMENTI ;
INTO CURSOR _CURMOVI

SELECT * ;
FROM _CURMOVI AS T1 ;
LEFT OUTER JOIN SOLO_QUESTE AS T2 ;
ON T1.CODRIS_DA=T2.CONTOCONT ;
ORDER BY T1.DT_CONTAB ,T1.TIPOMOVI ;
INTO CURSOR PER_STAMPA READWRITE

oSheet.Cells(1,1).Value = [RIEPILOGO MOVIMENTI DI TESORERIA]
oSheet.Cells(1,1).Font.Bold = .T.
oSheet.Cells(1,1).HorizontalAlignment = 3


nColonna=3

oSheet.Cells(1,nColonna).Value = [ABI]
oSheet.Cells(1,nColonna).Font.Bold = .T.
oSheet.Cells(1,nColonna).HorizontalAlignment = 3

oSheet.Cells(2,nColonna).Value = [CAB]
oSheet.Cells(2,nColonna).Font.Bold = .T.
oSheet.Cells(2,nColonna).HorizontalAlignment = 3

oSheet.Cells(3,nColonna).Value = [CONTO CORRENTE]
oSheet.Cells(3,nColonna).Font.Bold = .T.
oSheet.Cells(3,nColonna).HorizontalAlignment = 3

oSheet.Cells(4,nColonna).Value = [BANCA]
oSheet.Cells(4,nColonna).Font.Bold = .T.
oSheet.Cells(4,nColonna).HorizontalAlignment = 3

oSheet.Cells(6,nColonna).Value = [SALDO]
oSheet.Cells(6,nColonna).Font.Bold = .T.
oSheet.Cells(6,nColonna).HorizontalAlignment = 3

oSheet.Cells(7,nColonna).Value = [FIDO]
oSheet.Cells(7,nColonna).Font.Bold = .T.
oSheet.Cells(7,nColonna).HorizontalAlignment = 3

oSheet.Cells(8,nColonna).Value = [TOT (NO INCASSI)]
oSheet.Cells(8,nColonna).Font.Bold = .T.
oSheet.Cells(8,nColonna).HorizontalAlignment = 3

xlUnderlineStyleNone=-4142
xlAutomatic			=-4105
xlCenter			=-4108
xlBottom			=-4107
xlContext			=-5002
False				=.F.
True				=.T.

oExcel.Range("C1:C8").Select
    With oExcel.Selection.Font
        .Name = "Arial Narrow"
        .Size = 8
        .Strikethrough = .F.
        .Superscript = .F.
        .Subscript = .F.
        .OutlineFont = .F.
        .Shadow = .F.
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
        .Bold=.T.
    EndWith
oExcel.Columns("C:C").EntireColumn.AutoFit    

With oExcel.Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText =  .F.
        .Orientation = 0
        .AddIndent =  .F.
        .IndentLevel = 0
        .ShrinkToFit =  .F.
        .ReadingOrder = xlContext
        .MergeCells =  .F.
EndWith

SELECT SOLO_QUESTE
GO TOP
DO WHILE !EOF()

	nColonna=nColonna+1
	oSheet.Cells(1,nColonna).Value = ALLTRIM(SOLO_QUESTE.ABI       )
	oSheet.Cells(2,nColonna).Value = ALLTRIM(SOLO_QUESTE.CAB       )
	oSheet.Cells(3,nColonna).Value = ALLTRIM(SOLO_QUESTE.CC        )
	oSheet.Cells(4,nColonna).Value = ALLTRIM(SOLO_QUESTE.DESRISORSA)
	
*** TOLGO DAL SALDO 
* 		INCASSO 
* 		ANTRIBA 
* 		EFFATT 
	
	oSheet.Cells(6,nColonna).Value = SOLO_QUESTE.SALDO-SOLO_QUESTE.INCASSO-SOLO_QUESTE.ANTRIBA-SOLO_QUESTE.EFFATT
	oSheet.Cells(7,nColonna).Value = SOLO_QUESTE.FIDO
 	oSheet.Cells(8,nColonna).Value = SOLO_QUESTE.DISPONIB-SOLO_QUESTE.INCASSO-SOLO_QUESTE.ANTRIBA-SOLO_QUESTE.EFFATT

	_Range=n2c(nColonna)+"1:"+n2c(nColonna)+"4" && es. D1:D4
    oExcel.Range(_Range).Select
    oExcel.Selection.NumberFormat = "@"
    With  oExcel.Selection.Font
        .Name = "Arial Narrow"
        .Size = 8
        .Bold= .T.
        .Strikethrough = .F.
        .Superscript = .F.
        .Subscript = .F.
        .OutlineFont = .F.
        .Shadow = .F.
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    EndWith

    With oExcel.Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = .F.
        .Orientation = 0
        .AddIndent = .F.
        .IndentLevel = 0
        .ShrinkToFit = .F.
        .ReadingOrder = xlContext
        .MergeCells = .F.
    EndWith

    _Range=n2c(nColonna)+"4" 
    oExcel.Range("D4").Select
    With oExcel.Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = .T.
        .Orientation = 0
        .AddIndent = .F.
        .IndentLevel = 0
        .ShrinkToFit = .F.
        .ReadingOrder = xlContext
        .MergeCells = .F.
    EndWith
    
   	_Range=n2c(nColonna)+"6:"+n2c(nColonna)+"8" && es. D1:D4
    oExcel.Range(_Range).Select
    oExcel.Selection.NumberFormat = "#,##0.00"

    _Range=n2c(nColonna)+":"+n2c(nColonna) && es. D1:D4
    oExcel.Columns(_Range).ColumnWidth = 20
    			
	SELECT SOLO_QUESTE
	SKIP 
ENDDO

oSheet.Cells(8,nColonna+1).Value = [PLAFOND TOTALE]
WITH oSheet.Cells(8,nColonna+1).Font
		.Bold = .T.
        .Name = "Arial Narrow"
        .Size = 8
ENDWITH 
oSheet.Cells(8,nColonna+1).HorizontalAlignment = 3


oExcel.Rows("4:4").EntireRow.AutoFit

nColonnaInizioConti		=3
nColonnaInizioTabulato	=1
nColonnaInizioImporti	=2
nRigaInizioImporti		=10

SELECT SOLO_QUESTE
nColonnaFineConti		=nColonnaInizioConti+RECCOUNT()
nColonnaFineImporti		=nColonnaInizioConti+nColonnaFineConti+1 && aggiungo una colonna di plafond totale
nColonnaFineTabulato	=nColonnaFineImporti+2


*** INIZIO LA VISUALIZZAZIONE DEI MOVIMENTI

SELECT PER_STAMPA
nRigaFineImporti		=nRigaInizioImporti+RECCOUNT()+1 && aggiungo una colonna di riepilogo totale

*** tiraq una riga di separazione tra titoli colonne e colonne
oExcel.Rows(ALLTRIM(STR(nRigaInizioImporti-1))+":"+ALLTRIM(STR(nRigaInizioImporti-1))).RowHeight = 4
_Range=n2c(nColonnaInizioTabulato)+ALLTRIM(STR(nRigaInizioImporti-1))+":"+n2c(nColonnaFineTabulato)+ALLTRIM(STR(nRigaInizioImporti-1)) && es. D1:D4
oExcel=ColoraSelezione(oExcel,_Range,7)

GO TOP

_Range=n2c(nColonnaInizioImporti)+ALLTRIM(STR(nRigaInizioImporti))+":"+n2c(nColonnaFineImporti)+ALLTRIM(STR(nRigaFineImporti)) && es. D1:D4
oExcel.Range(_Range).EntireColumn.NumberFormat = "#,##0.00"

nRiga=nRigaInizioImporti

_tipo=TIPOMOVI
_data=DT_CONTAB
*_des=SUBSTR(DES_MOVIME,1,7)
_des=ALLTRIM(TIPOLOGIA)
_RigaInzioBlocco=nRiga

oSheet.Cells(nRiga,1).Value = _des+" "+RIBALTA2(_data)
oSheet.Cells(nRiga,1).Font.Bold=.T.
oSheet.Cells(nRiga,1).Font.Italic=.T.
_RigaInzioBlocco=nRiga+1
*oSheet.Cells(nRiga,nColonnaFineImporti+1).Value = "=SUM("+n2c(nColonnaInizioConti+1)+ALLTRIM(STR(nRiga))+":"+n2c(nColonnaFineConti)+ALLTRIM(STR(nRiga))+")" && COLONNA C	


DO WHILE !EOF()

	nRiga=nRiga+1
	
	IF  PER_STAMPA.TIPOMOVI!= _tipo OR PER_STAMPA.DT_CONTAB!=_data
			FOR xxx=nColonnaInizioConti+1 to nColonnaFineConti
				oSheet.Cells(nRiga,xxx).Value ="=SUM("+N2C(xxx)+ALLTRIM(STR(_RigaInzioBlocco-3))+","+N2C(xxx)+ALLTRIM(STR(_RigaInzioBlocco))+":"+N2C(xxx)+ALLTRIM(STR(nRiga-1))+")"
			NEXT
			oSheet.Cells(nRiga,1).Value ="TOTALE AL "+RIBALTA2(_data)
			oExcel.Rows(ALLTRIM(STR(nRiga))+":"+ALLTRIM(STR(nRiga))).EntireRow.Font.Bold=.T.
			oSheet.Cells(nRiga,nColonnaFineConti+1).Value = "=SUM("+N2C(nColonnaInizioConti+1)+ALLTRIM(STR(nRiga))+":"+N2C(nColonnaFineConti)+ALLTRIM(STR(nRiga))+")"
				
			nRiga=nRiga+2
			SELECT PER_STAMPA		
			_tipo=TIPOMOVI
			_data=DT_CONTAB
			*_des=SUBSTR(DES_MOVIME,1,7)
			_des=ALLTRIM(TIPOLOGIA)
			oSheet.Cells(nRiga,1).Value = _des+" "+RIBALTA2(_data)
			oSheet.Cells(nRiga,1).Font.Bold=.T.
			oSheet.Cells(nRiga,1).Font.Italic=.T.
			nRiga=nRiga+1
			_RigaInzioBlocco=nRiga

	ENDIF

	DO CASE
		CASE PER_STAMPA.TIPOMOVI="TRAS-FONDI"
			oSheet.Cells(nRiga,1).Value = PER_STAMPA.DES_A
			oSheet.Cells(nRiga,2).Value = PER_STAMPA.IMPORTO && COLONNA B
			oSheet.Cells(nRiga,PER_STAMPA.POSIZIONE+nColonnaInizioConti).Value = -PER_STAMPA.IMPORTO 
        	
			_destinazione=ALLTRIM(PER_STAMPA.CODRIS_A)
			
			SELECT POSIZIONE FROM SOLO_QUESTE WHERE ALLTRIM(CONTOCONT)=ALLTRIM(_destinazione) INTO ARRAY _DEST
			oSheet.Cells(nRiga,_dest+nColonnaInizioConti).Value = PER_STAMPA.IMPORTO 
			SELECT PER_STAMPA

		OTHERWISE
			oSheet.Cells(nRiga,2).Value = PER_STAMPA.IMPORTO && COLONNA B
			oSheet.Cells(nRiga,1).Value = PER_STAMPA.DES_A && COLONNA A
			oSheet.Cells(nRiga,PER_STAMPA.POSIZIONE+nColonnaInizioConti).Value = PER_STAMPA.IMPORTO && COLONNA C
	ENDCASE

	SELECT PER_STAMPA
	SKIP 
ENDDO

nRiga=nRiga+1

FOR xxx=nColonnaInizioConti+1 to nColonnaFineConti
	oSheet.Cells(nRiga,xxx).Value ="=SUM("+N2C(xxx)+ALLTRIM(STR(_RigaInzioBlocco-3))+","+N2C(xxx)+ALLTRIM(STR(_RigaInzioBlocco))+":"+N2C(xxx)+ALLTRIM(STR(nRiga-1))+")"
NEXT
oSheet.Cells(nRiga,1).Value ="TOTALE AL "+RIBALTA2(_data)
oExcel.Rows(ALLTRIM(STR(nRiga))+":"+ALLTRIM(STR(nRiga))).EntireRow.Font.Bold=.T.
oSheet.Cells(nRiga,nColonnaFineConti+1).Value = "=SUM("+N2C(nColonnaInizioConti+1)+ALLTRIM(STR(nRiga))+":"+N2C(nColonnaFineConti)+ALLTRIM(STR(nRiga))+")"
	
nRiga=nRiga+2
SELECT PER_STAMPA		
_tipo=TIPOMOVI
_data=DT_CONTAB
*_des=SUBSTR(DES_MOVIME,1,7)
_des=ALLTRIM(TIPOLOGIA)
oSheet.Cells(nRiga,1).Value = _des+" "+RIBALTA2(_data)

oSheet.Columns("A:A").EntireColumn.AutoFit
oSheet.Columns("B:B").EntireColumn.AutoFit
oSheet.Columns(N2C(nColonnaFineConti+1)+":"+N2C(nColonnaFineConti+1)).EntireColumn.AutoFit
oSheet.Columns(N2C(nColonnaFineConti+2)+":"+N2C(nColonnaFineConti+2)).EntireColumn.AutoFit

*oExcel.ActiveWorkbook.SaveAs(SYS(2003)+"\REPORT\TABULATO_TESORERIA_"+ALLT(PUB_CODOPE)+".xls",,,,,.F.)

oExcel.Visible = .T.
*oExcel.Workbooks.Add()
*oExcel.Workbooks.Open(SYS(2003)+"\REPORT\TABULATO_TESORERIA.xls")
*oExcel.ActiveWorkbook.SaveAs(SYS(2003)+"\REPORT\TABULATO_TESORERIA_TMP.xls",,,,,.F.)

DELETE FROM MOVIMENTI WHERE TIPOLOGIA='INCASSO PREVISTO'

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
    