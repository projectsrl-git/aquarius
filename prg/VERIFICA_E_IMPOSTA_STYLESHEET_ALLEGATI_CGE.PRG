
WAIT CLEAR

_RISP = MESSAGEBOX("Utility di verifica e reimpostazione Foglio di Stile in files CGE (Allegati fatt. forn. XML)" + REPLICATE(CHR(13),2) + ;
	"Continuare con la verifica?",4+32+256,"Attenzione")
IF _RISP = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .T.
ENDIF

*!*	PRELEVA LA DIRECTORY OVE MEMORIZZARE I FILE PDF
_V_DIRECTORY_FILE_XML = ""
v_seek	  = 'ALLCGE'
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   _V_DIRECTORY_FILE_XML  = "\DOC_AQUARIUS\FATTURE_ELETTRONICHE_FORNITORI"
   APPEND BLANK
   REPLACE CODICE WITH 'ALLCGE'
   REPLACE DESCRI WITH _V_DIRECTORY_FILE_XML
   REPLACE LIBERA WITH ALLTRIM(_V_DIRECTORY_FILE_XML)
   IF !ExecRW(cSql,"PARA","W")
	  return(.f.)
   ENDIF
ELSE
	_V_DIRECTORY_FILE_XML = ALLTRIM(LIBERA)
ENDIF

DO CASE
	CASE SUBSTR(_V_DIRECTORY_FILE_XML,1,2) = "\\"	&& PERCORSO SU SERVER DIVERSO
		_V_DIRECTORY_FILE_XML = _V_DIRECTORY_FILE_XML

	CASE !EMPTY(JUSTDRIVE(_V_DIRECTORY_FILE_XML))	&& PERCORSO FISSO
		_V_DIRECTORY_FILE_XML = _V_DIRECTORY_FILE_XML
	
	OTHERWISE								&& PERCORSO RELATIVO RISPETTO ALLA DIRECTORY DI LAVORO DI AQUARIUS (CARTELLA SUPERIORE)
		_cWorkDir = SYS(5) + SYS(2003)
		_V_DIRECTORY_FILE_XML= SUBSTR(_cWorkDir,1,RAT('\',_cWorkDir,1)-1) + _V_DIRECTORY_FILE_XML
ENDCASE

_StyleSheetName = "FoglioStileFatturaXML.xsl"
_StyleSheetFileName = _V_DIRECTORY_FILE_XML+"\ALLEGATI\" + _StyleSheetName
IF !FILE(_StyleSheetFileName)
	MESSAGEBOX("Foglio di stile " + _StyleSheetFileName + " non disponibile",16,"Attenzione")
	RETURN .F.
ENDIF


WAIT WINDOWS "Lettura files in corso..." NOWAIT

CSQL = 	"SELECT SPACE(10) AS SELEZIONE,INDICE.MOV_DTDOC,INDICE.MOV_NDOC,INDICE.MOV_DTREG,INDICE.MOV_NREGIS,INDICE.MOV_CONTO, " + ;
		"SUBSTRING(('"+_V_DIRECTORY_FILE_XML+"\ALLEGATI\'+RTRIM(ATTACHMENTS.FILENAME)),1,254) AS FULLPATH,ATTACHMENTS.* FROM ATTACHMENTS " + ;
		"RIGHT JOIN INDICE ON ATTACHMENTS.IDDOCUMENTO = INDICE.MOV_SYSDOC " + ;
		"WHERE ATTACHMENTS.TIPO = 'CGE'"
IF !ExecCommand(CSQL,"SEL_ATTACHMENTS_CGE")
   return
ENDIF
SELECT SEL_ATTACHMENTS_CGE
GO TOP
SCAN
	IF !FILE(FULLPATH,1)
		DELETE
		LOOP
	ENDIF
	
	IF UPPER(JUSTEXT(ALLTRIM(FILENAME))) == "XML"
	ELSE
		DELETE
		LOOP
	ENDIF	

	_tipo_file_fattura_eletronica_xml = .F.
	_FILE_XML = FILETOSTR(ALLTRIM(FULLPATH))
	IF "<FatturaElettronicaHeader>" $ _FILE_XML
		_tipo_file_fattura_eletronica_xml = .T.
	ENDIF
	IF _tipo_file_fattura_eletronica_xml
		_TAG_STYLESHEET = '<?xml-stylesheet type="text/xsl" href="' + ALLTRIM(_StyleSheetName) + '"?>'
		IF _TAG_STYLESHEET $ _FILE_XML
			DELETE
			LOOP
		ENDIF
	ELSE
		DELETE
		LOOP	
	ENDIF
ENDSCAN

WAIT CLEAR

SELECT SEL_ATTACHMENTS_CGE
GO TOP
IF EOF()
	MESSAGEBOX("Nessun file XML di tipo Fattura Elettronica con Foglio di stile da reimpostare in directory Allegati CGE",64,"Informazione")
	RETURN .T.
ENDIF

DO prg\browseview WITH "SEL_ATTACHMENTS_CGE","Selezione files XML per reimpostazione Foglio di Stile","MOV_DTDOC:Data doc.,W:10;MOV_NDOC:N.doc.,W:10;MOV_DTREG:Data reg.,W:10;MOV_NREGIS:N.reg.,W:10;MOV_CONTO:Conto,W:10;" + ;
	"FULLPATH:Nome file completo,W:120;",800,1200,.T.,.F.
IF NumeroRecordLetti = 0
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

_RISP = MESSAGEBOX("Proseguire con reimpostazione Foglio di Stile nei files XML di Fattura elettronica CGE selezionati?",4+32+256,"Attenzione")
IF _RISP = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .T.
ENDIF


_TOT_FILES_DA_REIMPOSTARE = 0
_TOT_FILES_REIMPOSTATI = 0

WAIT WINDOWS "Ripristino files in corso..." NOWAIT

SELECT SEL_ATTACHMENTS_CGE
GO TOP
SCAN
	IF SELEZIONE = "==>"
	ELSE
		LOOP
	ENDIF
	
	_TOT_FILES_DA_REIMPOSTARE = _TOT_FILES_DA_REIMPOSTARE + 1
	
	_FILE_XML = FILETOSTR(ALLTRIM(FULLPATH))	
	_NEW_FILE_XML = ""

	*** VERIFICO SE ESISTE GIA' UN FOGLIO DI STILE DEFINITO E IN TAL CASO LO ELIMINO
	IF "<?xml-stylesheet" $ _FILE_XML
		_TMP_FILE_XML1 = SUBSTR(_FILE_XML,1,AT("<?xml-stylesheet",_FILE_XML,1) - 1)
		_TMP_FILE_XML = SUBSTR(_FILE_XML,AT("<?xml-stylesheet",_FILE_XML,1))
		_TMP_FILE_XML2 = SUBSTR(_TMP_FILE_XML,AT(">",_TMP_FILE_XML,1) + 1)
		_FILE_XML = _TMP_FILE_XML1 + _TMP_FILE_XML2
	ENDIF
	*** AGGIUNGO AL FILE L'INDICAZIONE DEL FOGLIO DI STILE (SE PRESENTE SULLA DIRECTORY PRINCIPALE DI AQUARIUS)
	_NEW_FILE_XML = ""
	_posFin1stTag = AT(">",_FILE_XML,1)
	_posIni2ndTag = AT("<",_FILE_XML,2)
	_NEW_FILE_XML = ALLTRIM(SUBSTR(_FILE_XML,1,_posFin1stTag) + '<?xml-stylesheet type="text/xsl" href="' + ALLTRIM(_StyleSheetName) + '"?>' + SUBSTR(_FILE_XML,_posIni2ndTag))
	_NEW_FILE_XML = STRTRAN(_NEW_FILE_XML,">"+CHR(13)+CHR(10),">")

	STRTOFILE(_NEW_FILE_XML,ALLTRIM(FULLPATH),0)

	_TOT_FILES_REIMPOSTATI = _TOT_FILES_REIMPOSTATI + 1
ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata" + REPLICATE(CHR(13),2) + ;
	"Totale files selezionati da REIMPOSTARE: " + ALLTRIM(STR(_TOT_FILES_DA_REIMPOSTARE,10,0)) + CHR(13) + ;
	"Totale files REIMPOSTATI: " + ALLTRIM(STR(_TOT_FILES_REIMPOSTATI,10,0)),64,"Informazione")

RETURN
