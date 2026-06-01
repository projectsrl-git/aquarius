*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* -->> procedura per la stampa in vari formati:
* -->> Parametri:
* -->> 			ActiveConfig	= Se viene attivata la configurazione del sistema
* -->>							  0 se procedura di stampa
* -->>							  1 attiva la form di configurazione
* -->>							  
* -->> 			tnFileType		= Tipo del file da produrre
* -->>							  1 converte in word
* -->>							  2 converte in html
* -->>							  3 converte in rtf
* -->>							  4 converte in excel
* -->>							  5 converte in xml
* -->>							  6 attiva il preview speciale
* -->>							  7 non usato
* -->>							  8 converte in pdf
* -->>							  9 converte in pdf light per produzioni massive
* -->>			txtTabella		= Nome della tebella o cursore con i dati da stampare
* -->>			txtReportPath	= Nome del report completo di path
* -->>			txtExportPath	= Nome del file da creare completo di path (opzionale)
* -->>			txtReportPath	= Flag di funzionamento automatico (opzionale con defoult a 0)
* -->>							  0 visualizza le maschere di gestione stampe
* -->>							  1 non attiva la gestione delle maschere di stampa
* -->>			txtEmailOutput	= Indirizzo e-mail a cui inviare in alegato la stampa
* -->>			txtOggettoOutput= Oggetto della e-mail
* -->>			lResetStampante	= Durante la creazione del file PDF non agisce sulla reimpostazione della stampante fox di default (DA PASSARE A .F. SE UTILIZZATO IN SERVIZI TIPO AQ_SERVICE)
* -->>	Esempio:
* -->>  		do PrgPrint with "0","8","aperte","c:\aquarius\report\aperte.frx"[,"c:\aquarius\filepdf\aperte.exp","0","info@project-online.it","Invio fatture del mese"
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LPARAMETERS ActiveConfig,tnFileType,txtTabella,txtReportPath,txtExportPath,exeAutomatic,txtEmailOutput,txtOggettoOutput,lResetStampante
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IF EMPTY(PARAMETERS())
	SET PROCEDURE TO ApiLib additive
	DO declare_fun && procedura di ApiLib
	lcFileName    = "c:\PrgPrintPara.ini" 

	IF FILE(lcFileName)
		ActiveConfig		= GetPrivKeyValue(lcFileName,"PrinterParameter","ActiveConfig") 
		tnFileType			= GetPrivKeyValue(lcFileName,"PrinterParameter","tnFileType")
		txtTabella			= GetPrivKeyValue(lcFileName,"PrinterParameter","txtTabella")
		txtReportPath		= GetPrivKeyValue(lcFileName,"PrinterParameter","txtReportPath")
		txtExportPath		= GetPrivKeyValue(lcFileName,"PrinterParameter","txtExportPath") 
		exeAutomatic		= GetPrivKeyValue(lcFileName,"PrinterParameter","exeAutomatic")
		txtEmailOutput		= GetPrivKeyValue(lcFileName,"PrinterParameter","txtEmailOutput")
		txtOggettoOutput	= GetPrivKeyValue(lcFileName,"PrinterParameter","txtOggettoOutput")
	ELSE 
		=MESSAGEBOX("Mancano i parametri per la gestione della stampa",16,"*** ATTENZIONE ***")
		RETURN 
	ENDIF 
	restore from c:\memoryfox.vf3 additive
 
ENDIF


ActiveConfig=VAL(ActiveConfig)
tnFileType  =VAL(tnFileType)
*exeAutomatic=VAL(exeAutomatic)

* -->> se attivo il flag di configurazione automatica
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IF ActiveConfig = 1
	SET PROCEDURE TO ApiLib additive
	DO declare_fun && procedura di ApiLib
	DO FORM form\previewconfig linked
	RETURN 
ENDIF 

* -->> se non viene passato file di export assumo per defaul
* -->> il file aquarius.exp in c:\
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IF EMPTY(txtExportPath)
	txtExportPath="c:\aquarius.exp"
ENDIF

* -->> se manca il parametro di gestione interattiva/automatica,
* -->> forzo l'utilizzo in modo interattivo 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IF EMPTY(exeAutomatic)
	exeAutomatic=0
ENDIF 

* -->> Se esiste un indrizzo e-mail deve esistere anche l'oggetto
* -->> altrimenti forzo descrizione standard
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IF !EMPTY(txtEmailOutput)
	IF EMPTY(txtOggettoOutput)
		txtOggettoOutput="Invio automatico E-mail"
	ENDIF 
ENDIF


**=> ERASMO - INIZIO 15/12/2014
IF PCOUNT() >= 9
ELSE
	lResetStampante = .T.
ENDIF
**=> ERASMO - FINE 15/12/2014

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#DEFINE cnWORD 					         		1
#DEFINE cnHTML               			 		2
#DEFINE cnRTF               			 		3
#DEFINE cnEXCEL               			 		4
#DEFINE cnXML	               			 	    5
#DEFINE cnPREVIEW               			 	6		&& FRX2ANY Print Preview
#DEFINE cnPDF	               			 	    8

#DEFINE cnOK 	     				     		0       && Everything is OK.
#DEFINE cnNO_PARAMETERS    				 		1       && No parameter
#DEFINE cnREP_FILE_NOT_FOUND			 		2       && Report file not found
#DEFINE cnNO_BANDS_DEFINED 				 		3       && No bands defined in FRX file (corrupted?)
#DEFINE cnNO_OPEN_TABLE    				 		4       && No open table and no dataenviroment cursors in FRX file
#DEFINE cnEOF           				 		5       && Main alias at EOF() and no dataenvironment cursors
#DEFINE cnCANNOT_INSTANCE_WORD_APP		 		6       && Cannot instance a Word.Application
#DEFINE cnNO_HEADER_RECORD 				 		7       && No header record in FRX file (corrupted?)
#DEFINE cnNO_ANY_OBJECTS   				 		8       && No labels, fields, or images.
#DEFINE cnERR_CREATING_FILE				 		9  	 	&& Error creating DOC
#DEFINE cnUSER_INTERRUPTED				 		10  	&& User interrupted

#DEFINE cnINVALID_BANDTYPE_PARAMETER	 		11  	 
#DEFINE cnINVALID_ARRAY_REPORT_OBJ_PARAMETER	12
#DEFINE cnINVALID_NUMBER_OF_PARAMETER			13
#DEFINE cnINVALID_TYPE_OF_PARAMETER	 			14  	 
#DEFINE cnINVALID_SPECIFIED_OBJECT_TYPE			15
#DEFINE cnWRONG_EXPORT_FILE_TYPE				16
#DEFINE cnDE_INIT_RETURN_FALSE					17		&& DE Init metod return false 
#DEFINE cnCANNOT_INSTANCE_EXCEL_APP		 		18      && Cannot instance a Excel.Application
#DEFINE cnCANNOT_INSTANCE_PREVIEW_FORM          19      && Cannot instance a Preview Form
#DEFINE cnCANNOT_INSTANCE_OUTLOOK_APP		 	20      && Cannot instance a Outlook.OutPut
#DEFINE cnCANNOT_INSTANCE_HTML_FILE				21
#DEFINE cnPAGEHEADER_BAND_IS_TOO_LARGE		 	22      && Page Header band is too large to fit on page
#DEFINE cnTITLE_BAND_IS_TOO_LARGE		 	    23      && Title band is too large to fit on page

#DEFINE cnCANNOT_INSTANCE_BMP_FILE				24
#DEFINE cnCANNOT_CREATE_COMPATIBLE_BITMAP		25
#DEFINE cnCOMPATIBLE_BITMAP_SELECTION_FAILED	26
#DEFINE cnFORM_TO_COMPATIBLE_BIT_FAILED			27
#DEFINE cnWRONG_DEVICE_CONTEXT					28
#DEFINE cnBITMAP_FAILED							29
#DEFINE cnCANNOT_FIND_WINDOW					30
#DEFINE cnOUT_OF_PAGES_RANGE					31
#DEFINE cnTHERE_IS_NO_PAGES_TO_PRINT			32
#DEFINE cnCANNOT_CREATE_BMP_FILE				33

#DEFINE cnCANNOT_INSTANCE_PDF_FILE				34
#DEFINE cnCANNOT_INSTANCE_XML_FILES				35

#DEFINE cnSCOPE_CLAUSE_ALL		         		1
#DEFINE cnSCOPE_CLAUSE_NEXT		         		2
#DEFINE cnSCOPE_CLAUSE_RECORD	         		3
#DEFINE cnSCOPE_CLAUSE_REST 	         		4

#DEFINE cnOUTPUT_SCREEN			         		1
#DEFINE cnOUTPUT_PRINT			         		2
#DEFINE cnOUTPUT_EMAIL			         		3
#DEFINE cnOUTPUT_FILE		 	         		4

#DEFINE cnPREVIEW_WINDOW_TOOLBAR_NOTDOCKED      -1
#DEFINE cnPREVIEW_WINDOW_TOOLBAR_TOP            0
#DEFINE cnPREVIEW_WINDOW_TOOLBAR_LEFT           1
#DEFINE cnPREVIEW_WINDOW_TOOLBAR_RIGHT          2
#DEFINE cnPREVIEW_WINDOW_TOOLBAR_BOTTOM         3

*-- Preview's Window WindowState types
#DEFINE cnPREVIEW_WINDOW_STATE_NORMAL		 	0
#DEFINE cnPREVIEW_WINDOW_STATE_MIN				1
#DEFINE cnPREVIEW_WINDOW_STATE_MAX				2
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LOCAL loFile
LOCAL loOutPutOptions
LOCAL loPreviewOptions

LOCAL lcReportFullName
LOCAL lcReportFile
LOCAL lcExportFile
LOCAL lcExportPath
LOCAL lcErrorMessage

WAIT WINDOW "Elaborazione in corso..." nowait

	
*!*	WITH THISFORM

	lcReportFullName = ALLTRIM(txtReportPath)
	*lcReportFullName = FORCEEXT(lcReportFullName, 'FRX')
	IF '.LBX' $ lcReportFullName
		lcReportFullName = FORCEEXT(lcReportFullName, 'LBX')
	ELSE
		lcReportFullName = FORCEEXT(lcReportFullName, 'FRX')
	ENDIF

	lcReportFile 	 = JUSTSTEM(lcReportFullName)
	lcExportFile 	 = JUSTSTEM(txtExportPath)
	
	IF EMPTY(txtExportPath)
		lcExportPath 	 = ADDBS(JUSTPATH(lcReportFullName))
	ELSE
		lcExportPath 	 = ADDBS(JUSTPATH(txtExportPath))
	ENDIF 

	IF !FILE(lcReportFullName)
		lcErrorMessage = 'Manca il report ' + lcReportFullName
		=MESSAGEBOX(lcErrorMessage, 16, '*** ATTENZIONE ***')
		RETURN 
	ELSE

*!*			CLOSE TABLES ALL
*!*			CLOSE DATABASES ALL

		lcLastSetPath = SET('PATH')
		lcLastSetDir  = SET('DIRECTORY')

*-- Set up the path so we can instantiate the FRX2ANY object
		lcSys16       = SYS(16)
		lcProgram     = SUBSTR(lcSys16, AT(":", lcSys16) - 1)

		CD LEFT(lcProgram, RAT("\", lcProgram))
		
		SET CLASSLIB TO &pub_dir\LIBS\Frx2Any ADDITIVE
		

		DO CASE
			CASE tnFileType = cnWORD OR tnFileType = cnRTF
				loFile = CREATEOBJECT('WordFile', tnFileType)

			CASE tnFileType = cnHTML
				loFile = CREATEOBJECT('HTMLFile')

			CASE tnFileType = cnEXCEL
				loFile = CREATEOBJECT('EXCELFile')

			CASE tnFileType = cnPREVIEW
				loFile = CREATEOBJECT('PREVIEWFile')

			CASE tnFileType = cnPDF
				loFile = CREATEOBJECT('PDFFile')

			CASE tnFileType = cnXML
				loFile = CREATEOBJECT('XMLFile')

			OTHERWISE 
				* -->> genera pdf usando una "Generic PostScript Printer"
*!*					SELECT * from &txtTabella INTO CURSOR _tmp_print
*!*					SELECT _tmp_print
				SELECT &txtTabella

				do print2pdf with txtExportPath, lcReportFullName, lResetStampante  &&FORCEEXT(lcReportFile,'frx')

				SET PATH TO (lcLastSetPath)
				CD (lcLastSetDir)
				RETURN 
				
		ENDCASE

		IF TYPE('loFile') = 'O'

			loFile.nCodePage       = 1252


			loFile.cExportFileName = lcExportFile
			
			
			loFile.cSaveFolder     = lcExportPath

*-- Here we can get current version of FRX2ANY
			lcVersion = loFile.GetVersion()

*-- Set up Report Scope
			IF INLIST(1, cnSCOPE_CLAUSE_ALL, cnSCOPE_CLAUSE_NEXT, cnSCOPE_CLAUSE_RECORD, cnSCOPE_CLAUSE_REST)
				loFile.nScopeClauseType = 1
			ELSE
				loFile.nScopeClauseType = cnSCOPE_CLAUSE_ALL
			ENDIF

*!*				DO CASE
*!*					CASE loFile.nScopeClauseType = cnSCOPE_CLAUSE_NEXT
*!*						loFile.nScopeRecords = .txtNextRecords.VALUE
*!*					CASE loFile.nScopeClauseType = cnSCOPE_CLAUSE_RECORD
*!*						loFile.nScopeRecordNumber = .txtRecord.VALUE
*!*				ENDCASE

			loFile.cFORExpression = ""
			loFile.cWHILEExpression = ""
			loFile.cHeadingText = ""

*!*				IF !EMPTY(.txtFORExpression.VALUE)
*!*					loFile.cFORExpression = ALLTRIM(.txtFORExpression.VALUE)
*!*				ENDIF

*!*				IF !EMPTY(.txtWHILEExpression.VALUE)
*!*					loFile.cWHILEExpression = ALLTRIM(.txtWHILEExpression.VALUE)
*!*				ENDIF

*!*				IF !EMPTY(.txtHeading.VALUE)
*!*					loFile.cHeadingText = ALLTRIM(.txtHeading.VALUE)
*!*				ENDIF

			loFile.lPlain   = .f.
			loFile.lSummary = .f.


			DO CASE
				CASE  tnFileType = cnPREVIEW

*!*						DO FORM PreviewConfig NAME loPreviewOptions LINKED

*!*						IF TYPE('loPreviewOptions') = 'O' AND !ISNULL(loPreviewOptions)
*-- Set up Default ToolBar and Print Preview Form settings


						lcFileName    = SYS(5)+SYS(2003)+"\PrintConfig.ini" 

						loFile.lToolBarDisplay   = VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkDisplay"))
						loFile.lToolBarFind      = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFind"))=1,.t.,.f.)
						loFile.lToolBarPrint     = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkPrint"))=1,.t.,.f.)
						loFile.lToolBarZoom      = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkZoom"))=1,.t.,.f.)
						loFile.lToolBarFRX2Word  = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFRX2Word"))=1,.t.,.f.)
						loFile.lToolBarFRX2Excel = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFRX2Excel"))=1,.t.,.f.)
						loFile.lToolBarFRX2RTF   = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFRX2RTF"))=1,.t.,.f.)
						loFile.lToolBarFRX2HTML  = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFRX2HTML"))=1,.t.,.f.)
						loFile.lToolBarFRX2BMP   = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFRX2BMP"))=1,.t.,.f.)
						loFile.lToolBarFRX2PDF   = IIF(VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","chkFRX2PDF"))=1,.t.,.f.)						

						DO CASE
							CASE VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","opgDockOptions")) = 2
								loFile.nToolBarDockType = cnPREVIEW_WINDOW_TOOLBAR_TOP

							CASE VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","opgDockOptions")) = 3
								loFile.nToolBarDockType = cnPREVIEW_WINDOW_TOOLBAR_LEFT

							CASE VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","opgDockOptions")) = 4
								loFile.nToolBarDockType = cnPREVIEW_WINDOW_TOOLBAR_RIGHT

							CASE VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","opgDockOptions")) = 5
								loFile.nToolBarDockType = cnPREVIEW_WINDOW_TOOLBAR_BOTTOM

							OTHERWISE
								loFile.nToolBarDockType = cnPREVIEW_WINDOW_TOOLBAR_NOTDOCKED

						ENDCASE

						loFile.nToolBarPositionTop       = VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","spnToolBarTop"))
						loFile.nToolBarPositionLeft      = VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","spnToolBarLeft"))
						loFile.cPrintPreviewFormTitle    = IIF(EMPTY(GetPrivKeyValue(lcFileName,"PreviewOptions","txtWindowTitle")), '', ALLTRIM(GetPrivKeyValue(lcFileName,"PreviewOptions","txtWindowTitle")))
						loFile.cPrintPreviewToolBarTitle = IIF(EMPTY(GetPrivKeyValue(lcFileName,"PreviewOptions","txtToolBarTitle")), '', ALLTRIM(GetPrivKeyValue(lcFileName,"PreviewOptions","txtToolBarTitle")))
						loFile.nDefaultPageNumber        = VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","spnDefaultPage"))
						loFile.nBackGroundColor          = VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","cntBackGroundColor"))

						DO CASE
							CASE VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","opgStateOptions")) = 2
								loFile.nWindowState = cnPREVIEW_WINDOW_STATE_MIN
							CASE VAL(GetPrivKeyValue(lcFileName,"PreviewOptions","opgStateOptions")) = 3
								loFile.nWindowState = cnPREVIEW_WINDOW_STATE_MAX
							OTHERWISE
								loFile.nWindowState = cnPREVIEW_WINDOW_STATE_NORMAL
						ENDCASE


				OTHERWISE
					* -->> se eseguo la procedura in modo automatico (batch per creazione file)
					* -->> le uniche opzioni sono creazione file o invio e-mail
					IF exeAutomatic=1

							*-- Force FRX2ANY to copy Img file(s) into the folder with output file (only for HTML)
							IF tnFileType = 2
								loFile.lKeepImgFileWithOutPut =  .t. && loOutPutOptions.chkKeepImgFile.VALUE
							ENDIF 
							*-- Force FRX2ANY to display or not convertation process
							loFile.lDisplayStatus = .f.		&& loOutPutOptions.chkDisplayStatus.VALUE
							*-- Plain output for Excel module
							IF tnFileType = 4
								loFile.lPlainExcel = .f.	&& loOutPutOptions.chkPlainExcel.VALUE
								loFile.lPlainExcelFull = .t.	&& loOutPutOptions.chkPlainExcelFull.VALUE
							ENDIF 					
							
							*-- Force FRX2ANY to include or not used font(s) into PDF output file
							IF tnFileType = 8
								loFile.lIncludeFont = .f.	&& loOutPutOptions.chkIncludeFontdIntoPDF.VALUE
							ENDIF 						
							
							loFile.nOutPutType = cnOUTPUT_FILE
							IF !EMPTY(txtEmailOutput)
									*--E-Mail
									loFile.nOutPutType         = cnOUTPUT_EMAIL
									loFile.lAsAttachment       = .t.
									loFile.lDisplayBeforeEMail = .f.
									loFile.cSendTo             = txtEmailOutput
									loFile.cSendCC             = ""
									loFile.cSubject            = txtOggettoOutput
							ENDIF 
					ELSE 
						*DO FORM ExportOptions NAME loOutPutOptions LINKED WITH tnFileType
						

						*IF TYPE('loOutPutOptions') = 'O' AND !ISNULL(loOutPutOptions)
						IF tnfileType=8
							*-- Force FRX2ANY to copy Img file(s) into the folder with output file (only for HTML)
							IF tnFileType = 2
								loFile.lKeepImgFileWithOutPut =  .t. && loOutPutOptions.chkKeepImgFile.VALUE
							ENDIF 
							*-- Force FRX2ANY to display or not convertation process
							loFile.lDisplayStatus = .t.		&& loOutPutOptions.chkDisplayStatus.VALUE
							*-- Plain output for Excel module
							IF tnFileType = 4
								loFile.lPlainExcel = .f.	&& loOutPutOptions.chkPlainExcel.VALUE
								loFile.lPlainExcelFull = .t.	&& loOutPutOptions.chkPlainExcelFull.VALUE
							ENDIF 					
							
							*-- Force FRX2ANY to include or not used font(s) into PDF output file
							IF tnFileType = 8
								loFile.lIncludeFont = .t.	&& loOutPutOptions.chkIncludeFontdIntoPDF.VALUE
							ENDIF 						
							
							*DO CASE
								*CASE loOutPutOptions.opgOptions.VALUE = 1
									*--Screen
									*loFile.nOutPutType = cnOUTPUT_SCREEN

								*CASE loOutPutOptions.opgOptions.VALUE = 2
									*--Print
									*loFile.nOutPutType = cnOUTPUT_PRINT

								*CASE loOutPutOptions.opgOptions.VALUE = 3
									*--E-Mail
									*loFile.nOutPutType         = cnOUTPUT_EMAIL
									*loFile.lAsAttachment       = loOutPutOptions.chkAttachment.VALUE
									*loFile.lDisplayBeforeEMail = loOutPutOptions.chkDisplay.VALUE
									*loFile.cSendTo             = loOutPutOptions.txtSendTo.VALUE
									*loFile.cSendCC             = loOutPutOptions.txtCc.VALUE
									*loFile.cSubject            = loOutPutOptions.txtSubject.VALUE

								*OTHERWISE
									*--File
									loFile.nOutPutType = cnOUTPUT_FILE
							*ENDCASE

						ELSE
							*--File
							loFile.nOutPutType = cnOUTPUT_FILE
* -->> se scelgo annulla dalla form di creazione, esco dalla procedura
							loFile.RELEASE()
							loFile 			 = .NULL.
							SET PATH TO (lcLastSetPath)
							CD (lcLastSetDir)
							RETURN 

						ENDIF
					ENDIF 

			ENDCASE


*-- Init DE
			IF EMPTY(txtTabella)
				lnSuccess = loFile.InitDataEnvironment(lcReportFullName)

				DO CASE
					CASE lnSuccess = cnDE_INIT_RETURN_FALSE
					OTHERWISE

						DO CASE
							CASE lnSuccess = cnNO_OPEN_TABLE
								USE ?
						ENDCASE

						lnSuccess  		 = loFile.SAVE(lcReportFullName)

						loFile.RELEASE()
						loFile 			 = .NULL.

				ENDCASE


				DO CASE
					CASE lnSuccess = cnDE_INIT_RETURN_FALSE
						lcErrorMessage = 'Init method of dataenvironment returned false.'
						=MESSAGEBOX(lcErrorMessage, 16, 'Error')

					CASE lnSuccess = cnNO_OPEN_TABLE
						lcErrorMessage = 'No open table and no dataenvironment cursors in FRX file.'
						=MESSAGEBOX(lcErrorMessage, 16, 'Error')
				ENDCASE
			ELSE
				
*!*				SELECT * from &txtTabella INTO CURSOR _tmp_print
*!*				SELECT _tmp_print

				SELECT &txtTabella
				
				lnSuccess  		 = loFile.SAVE(lcReportFullName)
				loFile.RELEASE()
				loFile 			 = .NULL.

				DO CASE
					CASE lnSuccess = cnDE_INIT_RETURN_FALSE
						lcErrorMessage = 'Impossibile trovare la sorgente dati.'
						=MESSAGEBOX(lcErrorMessage, 16, '*** ATTENZIONE ***')

					CASE lnSuccess = cnNO_OPEN_TABLE
						lcErrorMessage = 'Nessuna tabella aperta.'
						=MESSAGEBOX(lcErrorMessage, 16, '*** ATTENZIONE ***')
				ENDCASE
			ENDIF 
		ELSE
			lcErrorMessage = "Impossibile inizializzare l'oggetto Frx2Any."
			=MESSAGEBOX(lcErrorMessage, 16, '*** ATTENZIONE ***')
		ENDIF

		SET PATH TO (lcLastSetPath)
		CD (lcLastSetDir)

	ENDIF
	
	
	*DO FORM FORM\EMAIL LINKED WITH txtExportPath
	

*!* ENDWITH

