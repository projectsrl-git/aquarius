********************************************************************************
* PJOfficeMarker
********************************************************************************

***********************************
* Procedure ApriDocumentoExcel
***********************************
PROCEDURE ApriDocumentoExcel

LPARAMETERS pFileName,flgVisibile

oExcel=createobject("Excel.Application")
oDoc = oExcel.Documents.Open(pFileName)
oExcel.visible = flgVisibile
oExcel.windowstate = 1
RETURN oWord
ENDPROC
***********************************


***********************************
* Procedure ApriDocumento
***********************************
PROCEDURE ApriDocumento

LPARAMETERS pFileName,flgVisibile

IF !FILE(pFileName)
	MESSAGEBOX("File inesistente "+ALLTRIM(pFileName),48,"Attenzione!")
	RETURN
ENDIF

oWord=createobject("Word.Application")
oDoc = oWord.Documents.Open(pFileName)
oWord.visible = flgVisibile
oWord.windowstate = 1
RETURN oWord
ENDPROC
***********************************

***********************************
* Procedure ApriDocumentoVisibile
***********************************
PROCEDURE ApriDocumentoVisibile

LPARAMETERS pFileName

RETURN ApriDocumento(pFileName,.t.)
ENDPROC
***********************************

***********************************
* Procedure ApriDocumentoNonVisibile
***********************************
PROCEDURE ApriDocumentoNonVisibile
LPARAMETERS pFileName
RETURN ApriDocumento(pFileName,.f.)
ENDPROC
***********************************

***********************************
* Procedure ImpostaTabella
***********************************
PROCEDURE ImpostaTabella

LPARAMETERS oWord,;
			cAlias,;
			cCampi
			

LOCAL	wdCharacter,;
		wdExtend,;
		wdLine,;
		wdFindContinue,;
		wdCollapseStart,;
		wdCollapseEnd,;
		wdReplaceOne,;
		wdCell,;
		cPrimoCampo,;
		nRighe,;
		nColonne

LOCAL cAliasCorrente
cAliasCorrente=SELECT()

wdCharacter		=1
wdExtend		=1
wdLine			=5
wdFindContinue	=1
wdCollapseStart	=1
wdCollapseEnd	=0
wdReplaceOne	=1
wdCell			=12

*** ricava i campi da sostituire in tabella
CREATE CURSOR COLONNE (CNOMECOL C(20))

_valore=""
_stringa=cCampi

DO WHILE !EMPTY(_stringa)
	_posizione=AT(",",_stringa)
	IF _posizione>0
		_valore=SUBSTR(_stringa,1,_posizione-1)
		_stringa=SUBSTR(_stringa,_posizione+1)
	ELSE
		_valore=_stringa
		_stringa=""
	ENDIF
	SELECT COLONNE
	APPEND BLANK
	REPLACE CNOMECOL WITH _valore
ENDDO


* set step on

* oWord.visible=.t.

SELECT &cAlias
nRighe=RECCOUNT()

SELECT COLONNE
nColonne=RECCOUNT()
GO TOP
cPrimoCampo=ALLT(CNOMECOL)

*** Sostituirci alla ricga imposrtata come riga di esempio
*** i campi con indice di prima riga
DO WHILE !EOF()
	Sostituisci(oWord,"#"+cAlias+"."+ALLT(CNOMECOL)+"#","#"+cAlias+".1."+ALLT(CNOMECOL)+"#")
	SELECT COLONNE
	SKIP
ENDDO

*** prepara la tabella con tutti i campi e gli indici
WITH oWord.Selection.Find
	    .ClearFormatting
    	.Replacement.ClearFormatting
        .Text = "#"+cAlias+".1."+cPrimoCampo+"#"
        .Replacement.Text = ""
        .Forward = .t.
        .Wrap = wdFindContinue
        .Format = .f.
        .MatchCase = .f.
        .MatchWholeWord = .f.
        .MatchWildcards = .f.
        .MatchSoundsLike = .f.
        .MatchAllWordForms = .f.
ENDWITH

oword.selection.Find.Execute()
oword.Selection.MoveRight(wdCharacter,nColonne,wdExtend)
oWord.Selection.Copy()

FOR i = 1 to nRighe-1
	oWord.Selection.InsertRows(1)
	oWord.Selection.Paste()
NEXT

DocTop(oWord)

*SET STEP ON

*oWord.visible = .T.


*SELECT &cAlias
*GO TOP 

FOR contaRighe=1 to nRighe

*	SELECT COLONNE
*	GO TOP
	
	FOR contaColonne=1 to nColonne
		With oWord.Selection.Find
		        .Text = "#"+cAlias+".1"
		        .Replacement.Text = "#"+cAlias+"."+allt(str(contaRighe))
		        *.Text = "#"+cAlias+".1."+ALLT(COLONNE.CNOMECOL)+"#"
		        *_campo=ALLT(cAlias)+"."+ALLT(COLONNE.CNOMECOL)
		        *.Replacement.Text = &_campo
		        .Forward = .t.
		        .Wrap = 1
		        .Format = .f.
		        .MatchCase = .f.
		        .MatchWholeWord = .f.
		        .MatchWildcards = .f.
		        .MatchSoundsLike = .f.
		        .MatchAllWordForms = .f.
		EndWith
		
		*oWord.Selection.Find.Execute()
		With oWord.Selection
			If .Find.Forward =.t.
				.Collapse(wdCollapseStart)
			Else
				.Collapse(wdCollapseEnd)
			EndIf
		
			IF contaRighe=1
				.Find.Execute() 
			ELSE
				.Find.Execute(, ,, , , , , , , , wdReplaceOne, , , , ) 
			ENDIF

			IF .Find.Forward = .t. 
				.Collapse(wdCollapseEnd)
		    Else
				.Collapse(wdCollapseStart)
		    EndIf
		EndWith
		
*		SELECT COLONNE
*		SKIP
	
	NEXT
	
*	SELECT &cAlias
*	SKIP
NEXT    



SELECT &cAlias
GO TOP 

FOR contaRighe=1 to nRighe

	SELECT COLONNE
	GO TOP
	
	FOR contaColonne=1 to nColonne
        _campo=ALLT(cAlias)+"."+ALLT(COLONNE.CNOMECOL)
		SostituisciMarker(oWord,cAlias+"."+ALLTR(STR(contaRighe))+"."+ALLT(COLONNE.CNOMECOL),&_campo)
		
		SELECT COLONNE
		SKIP
	
	NEXT
	
	SELECT &cAlias
	SKIP
NEXT    


SELECT(cAliasCorrente)


RETURN oWord
ENDPROC
* FINE Procedure ImpostaTabella

***********************************
* Procedure Sostituisci
***********************************
PROCEDURE Sostituisci

LPARAMETERS oWord,;
			pParolaDaSostituire,;
			pParolaSostitutiva

WITH oword.selection.Find
	    .ClearFormatting
    	.Replacement.ClearFormatting
        .Text = pParolaDaSostituire
        .Replacement.Text = pParolaSostitutiva
        .Forward = .t.
        .Wrap = 1
        .Format = .f.
        .MatchCase = .f.
        .MatchWholeWord = .f.
        .MatchWildcards = .f.
        .MatchSoundsLike = .f.
        .MatchAllWordForms = .f.

ENDWITH
oword.selection.Find.Execute(, ,, , , , , , , , 2, , , , )
RETURN oWord
ENDPROC
* FINE Procedure Sostituisci


***********************************
* Procedure SostituisciMarker
***********************************
PROCEDURE SostituisciMarker

LPARAMETERS oWord,;
			pParolaDaSostituire,;
			pParolaSostitutiva

Sostituisci(oword,"#"+pParolaDaSostituire+"#",pParolaSostitutiva)

RETURN oWord
ENDPROC
* FINE Procedure SostituisciMarker


***********************************
* Procedure SalvaConNomeChiudi
***********************************
PROCEDURE SalvaConNomeChiudi

LPARAMETERS oWord,;
			pNomeFile

oword.activedocument.saveas(pNomeFile)
oword.application.quit
ENDPROC
* FINE Procedure SalvaConNomeChiudi


***********************************
* Procedure DocTop
***********************************
PROCEDURE DocTop

LPARAMETERS oWord

LOCAL 	wdStory

wdStory=6

oword.Selection.HomeKey(wdStory)
ENDPROC
* FINE Procedure SalvaConNomeChiudi



***********************************
* Procedure ApriDocumentoPowerPoint
***********************************
PROCEDURE ApriDocumentoPowerPoint

LPARAMETERS pFileName,flgVisibile

*Start PowerPoint and open the presentation.
oPP = CreateObject("PowerPoint.Application")
oPP.Visible = .T.
oPresSet = oPP.Presentations
oPres = oPresSet.Open(pFileName, , , .T.)
        
RETURN
ENDPROC
***********************************




***********************************
* Procedure ApriDocumentoPDF
***********************************
PROCEDURE ApriDocumentoPDF

LPARAMETERS pFileName

loIE = Createobject("internetexplorer.application")
loIE.Visible = .T.
*!*	loIE.left = 50
*!*	loIE.top = 50
*!*	loIE.height = 275
*!*	loIE.width = 360
loIE.menubar = 0
loIE.toolbar = 0
loIE.statusbar = 0
loIE.Navigate("file://"+pFileName)

      
RETURN
ENDPROC
***********************************



***********************************
* Procedure ApriLinkHTML
***********************************
PROCEDURE ApriLinkHTML

*!*	status  		The status bar at the bottom of the window.
*!*	toolbar 		The standard browser toolbar, with buttons such as Back and Forward.
*!*	location 		The Location entry field where you enter the URL.
*!*	menubar 		The menu bar of the window
*!*	directories 	The standard browser directory buttons, such as What's New and What's Cool
*!*	resizable 		Allow/Disallow the user to resize the window.
*!*	scrollbars 		Enable the scrollbars if the document is bigger than the window
*!*	height 			Specifies the height of the window in pixels. (example: height='350')
*!*	width 			Specifies the width of the window in pixels.

LPARAMETERS pURL

loIE = Createobject("internetexplorer.application")
loIE.Visible = .T.
*!*	loIE.left = 50
*!*	loIE.top = 50
*!*	loIE.height = 275
*!*	loIE.width = 360
loIE.menubar = 0
loIE.toolbar = 0
loIE.statusbar = 0
loIE.Navigate(pURL)
      
RETURN
ENDPROC
***********************************




***********************************
* Procedure ApriLinkHTML_HELP
***********************************
PROCEDURE ApriLinkHTML_HELP

*!*	status  		The status bar at the bottom of the window.
*!*	toolbar 		The standard browser toolbar, with buttons such as Back and Forward.
*!*	location 		The Location entry field where you enter the URL.
*!*	menubar 		The menu bar of the window
*!*	directories 	The standard browser directory buttons, such as What's New and What's Cool
*!*	resizable 		Allow/Disallow the user to resize the window.
*!*	scrollbars 		Enable the scrollbars if the document is bigger than the window
*!*	height 			Specifies the height of the window in pixels. (example: height='350')
*!*	width 			Specifies the width of the window in pixels.

LPARAMETERS pURL

loIE = Createobject("internetexplorer.application")
loIE.Visible = .T.
loIE.left = 380
*!*	loIE.top = 50
loIE.height = 738
loIE.width = 644
loIE.menubar = 0
loIE.toolbar = 0
loIE.statusbar = 0
loIE.Navigate(pURL)
loIE.resizable = .F.
      
RETURN
ENDPROC
***********************************
