
LPARAMETERS p_root_dir_files,p_dir_sia_module_dest,p_dir_safety_test,p_domain,p_user,p_password,p_drive,p_data_versamento_dal,p_data_versamento_al,p_serial_number

IF PCOUNT() <= 8
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 8
ELSE
	p_data_versamento_dal = ""
ENDIF
IF PCOUNT() >= 9
ELSE
	p_data_versamento_al = ""
ENDIF
IF PCOUNT() >= 10
ELSE
	p_serial_number = ""
ENDIF

IF EMPTY(p_data_versamento_dal) AND EMPTY(p_data_versamento_al) AND EMPTY(p_serial_number)
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

_ROOT_DIR_FILES = p_root_dir_files
_DIR_SIA_MODULE_DEST = p_dir_sia_module_dest
_DIR_SAFETY_TEST = p_dir_safety_test
_DOMAIN = p_domain
_USER = p_user
_PASSWORD = p_password
_DRIVE = p_drive

WAIT WINDOWS "Collegamento alla directory principale in corso..." NOWAIT

IF DIRECTORY(_DRIVE)
	_V_RUN = "! /N net use "+_DRIVE+" /DELETE"
	&_V_RUN
ENDIF

_V_RUN = "! /N net use " + _DRIVE + " " + _ROOT_DIR_FILES + " "+_PASSWORD+" /USER:"+_DOMAIN+"\"+_USER
&_V_RUN

lcDir = _DRIVE + "\" + _DIR_SIA_MODULE_DEST

*!*	_ACT_SEC = SECONDS()
*!*	_SEC_MAX = 10
*!*	DO WHILE .T.
*!*		_DELTA_SEC = SECONDS() - _ACT_SEC 
*!*		
*!*		IF _DELTA_SEC > _SEC_MAX
*!*			EXIT
*!*		ENDIF
*!*		
*!*		IF DIRECTORY(lcDir)
*!*			EXIT
*!*		ENDIF
*!*	ENDDO

DO AQM_ATTENDI_N_SECONDI WITH 5

IF !DIRECTORY(lcDir)
	WAIT CLEAR
	MESSAGEBOX("Percorso " + lcDir + " non disponibile al momento",48,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione in corso..." NOWAIT

_NR_DOC_GENERATI = 0
_NR_ELABORATI = 0

x_dtda = IIF(EMPTY(p_data_versamento_dal),"DATAVA = DATAVA","DATAVA >= '" + RIBALTA2(p_data_versamento_dal) + "'")
x_dtal = IIF(EMPTY(p_data_versamento_al),"DATAVA = DATAVA","DATAVA <= '" + RIBALTA2(p_data_versamento_al) + "'")
x_sern = IIF(EMPTY(p_serial_number),"SERIAL = SERIAL","SERIAL = '" + p_serial_number + "'")
x_cond = x_dtda + " and " + x_dtal + " and " + x_sern 
cSql = "SELECT SERIAL,DATAVA,ART_DESRID FROM PROD_CARICHI " + CHR(13) + ;
       "LEFT OUTER JOIN U_ART_PR ON PROD_CARICHI.CODART = U_ART_PR.ART_CODPRI " + CHR(13) + ;
       "WHERE QTAPROD > 0 AND COALESCE(SERIAL,'') <> '' AND CODART IN (SELECT ART_CODPRI FROM U_ART_AN WHERE ART_CODTSN IN ('PRD','SN6')) AND " + X_COND + " ORDER BY SERIAL"
IF !ExecCommand(cSql,"TMP_PROD_CARICHI")
  return(.f.)
ENDIF
SELECT TMP_PROD_CARICHI
GO TOP
SCAN
	_NR_ELABORATI = _NR_ELABORATI + 1
	DO CREA_SIA_MODULE_PDF WITH SERIAL,DATAVA
	DO COPY_SAFETY_TEST_PDF WITH SERIAL,DATAVA,ART_DESRID
ENDSCAN

_V_RUN = "! /N net use "+_DRIVE+" /DELETE"
&_V_RUN

*****************************
PROCEDURE CREA_SIA_MODULE_PDF
*****************************
LPARAMETERS p_serial,p_data

dest_path = lcDir + "\" + STRTRAN(p_data,"/","-")
IF !DIRECTORY(dest_path)
	_COMMAND = "MKDIR '" + ALLTRIM(dest_path) + "'"
	&_COMMAND
ENDIF

lcSerialNumber = ALLTRIM(p_serial)
lcUrl = "http://192.168.30.240/ReportServer/Pages/ReportViewer.aspx?%2f_system%2fwinSIA_ModuloSia%2frptSIA_Testata_by_SN&rs:Command=Render&SerialNumber="+lcSerialNumber+"&rs:Format=PDF"
loRequest = Createobject('MsXml2.XmlHttp')
loRequest.Open("GET",lcUrl,.F.,_DOMAIN+"\"+_USER,_PASSWORD)
loRequest.Send()

body = loRequest.ResponseBody
IF TYPE("body") == "C" OR TYPE("body") == "Q"
	cNOME_FILE = dest_path+"\rptSIA_Testata_by_SN_"+lcSerialNumber+".PDF"
	IF !FILE(cNOME_FILE)
		STRTOFILE(body,cNOME_FILE,0)
		_NR_DOC_GENERATI = _NR_DOC_GENERATI + 1
	ENDIF
ENDIF

ENDPROC


******************************
PROCEDURE COPY_SAFETY_TEST_PDF
******************************
LPARAMETERS p_serial,p_data,p_ref

filename = "REF#"+ALLTRIM(p_ref)+";SN#"+ALLTRIM(p_serial)+".pdf"
source_full_path = _DRIVE+"\"+_DIR_SAFETY_TEST+"\"+filename
IF !FILE(source_full_path)
	RETURN .F.
ENDIF

dest_path = lcDir + "\" + STRTRAN(p_data,"/","-")
IF !DIRECTORY(dest_path)
	_COMMAND = "MKDIR '" + ALLTRIM(dest_path) + "'"
	&_COMMAND
ENDIF
dest_full_path = dest_path + "\" + filename

IF !FILE(dest_full_path)
	_COMMAND = 'COPY FILE "' + source_full_path+ '" TO "' + dest_full_path + '"'
	&_COMMAND
	_NR_DOC_GENERATI = _NR_DOC_GENERATI + 1
ENDIF

ENDPROC
