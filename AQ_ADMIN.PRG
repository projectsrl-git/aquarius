*!*	##############################################################################################################
  
					**********************************************************************************************
					***     		PROJECT SRL - PROCEDURE DI AMMINISTRAZIONE Erp Aquarius              	   ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  




CLEAR ALL
CLOSE ALL
SET MULTILOCKS ON 
SET CENTURY ON 
SET DATE TO GERMAN 
CLOSE DATABASES ALL

SET TALK OFF
SET NOTIFY OFF
CLEAR ALL
SET SYSMENU TO

SET MULTILOCKS ON 
PUBLIC pub_sqlhd,pub_datawh
pub_sqlhd  = 0
pub_datawh = ""
 
RELEASE PUB_DIR
PUBLIC PUB_DIR 
PUB_DIR     = SYS(2003)   &&ALLTRIM(PATH) 
 
DO PRG\STARTSET
DO PRG\ADMINVAR   
   
SET EXCLUSIVE OFF   
   
_path_aquarius=legge_config("build_config.cfg","PATH_AQUARIUS")						&& RICERCA VARIABILE
SET DEFA TO &_path_aquarius

**=> ERASMO - INIZIO 21/06/2023
_nome_database=legge_config("build_config.cfg","DATA_BASE_SQL")						&& RICERCA NOME DB
PUB_NOMEDB = ALLTRIM(_nome_database)
**=> ERASMO - FINE 21/06/2023

SET PROCEDURE TO ADMINSQL.PRG 				ADDITIVE
SET PROCEDURE TO UTILITA.PRG 				ADDITIVE
SET PROCEDURE TO PRG\PJOfficeMarker 		ADDITIVE

*!*	** Creazione ZToolbar dalla libreria ZClassLib
*!*	SET CLASSLIB TO ZCLASLIB ADDITIVE
*!*	PUBLIC ZTB
*!*	ZTB=CREATEOBJECT("ZTOOLBAR")
*!*	ZTB.DOCK(0)

=OPENDB("VERSIONE")
SELECT versione
GO top
IF EOF()
   XXX_VERSIONE    = "MANCA LA TABELLA DELLE VERSIONI"
   XXX_NOME_SERVER = ""
ELSE
   XXX_VERSIONE    = VER_VERSIO
   XXX_NOME_SERVER = VER_SERVER
ENDIF

XXX_DATA = DTOC(DATE())
XXX_TIME = TIME()


_SCREEN.Caption   = "E.R.P. Aquarius  www.projectsrl.net    " + "[" + ALLTRIM(XXX_VERSIONE)+"]    " + "Data " + XXX_DATA + " Ora inizio " + XXX_TIME
_SCREEN.BACKCOLOR = RGB(60,112,167)
RELEASE PUB_DINDIR	&& PUNTATORE DINAMICO ALLA RIRECTORY AQUARIUS LOCALE O SUL/SUI SERVER REMOTO/I
PUBLIC PUB_DINDIR	&& PUNTATORE DINAMICO ALLA RIRECTORY AQUARIUS LOCALE O SUL/SUI SERVER REMOTO/I
PUB_DINDIR = SYS(5)+SYS(2003)
RELEASE PUB_DESKTOP
PUBLIC PUB_DESKTOP
*PUB_DESKTOP ="\BMP\AMBIENTE\SFONDI\SFONDO_AQUARIUS.JPG"   
PUB_DESKTOP	= '\BMP\AMBIENTE\SFONDI\SFONDO_AZZURRO_1.JPG'
                                                                                                                                                             
_SCREEN.WindowState = 2

_SCREEN.Visible = .T.  && ERASMO - 03/03/2025

_PATH_SFONDO_AQUARIUS = PUB_DINDIR+PUB_DESKTOP
_resolution_bckgrnd = SetResolutionBackground(_PATH_SFONDO_AQUARIUS)
*!*	IF !EMPTY(_resolution_bckgrnd) AND FILE(_resolution_bckgrnd)
*!*		_SCREEN.Picture = _resolution_bckgrnd
*!*	ELSE
	_SCREEN.Picture = ""
	IF !EMPTY(_PATH_SFONDO_AQUARIUS) .AND. FILE(_PATH_SFONDO_AQUARIUS)
		IF !TYPE("_SCREEN.oBackImage") == "O"
			_SCREEN.AddObject("oBackImage","IMAGE")
		ENDIF
		_SCREEN.oBackImage.Picture = _PATH_SFONDO_AQUARIUS
		_SCREEN.oBackImage.BackStyle = 1
		_SCREEN.oBackImage.Top = 0
		_SCREEN.oBackImage.Left = 0
		_SCREEN.oBackImage.Height = _SCREEN.Height
		_SCREEN.oBackImage.Width = _SCREEN.Width
		_SCREEN.oBackImage.Stretch = 2
		_SCREEN.oBackImage.Visible = .T.
	ENDIF
*!*	ENDIF

SET MESSAGE TO ""

_SCREEN.AddObject("IMAGE2","IMAGE")
_SCREEN.Image2.Picture=PUB_DINDIR +'\AQ_SCRITTA.GIF'
_SCREEN.Image2.BackStyle= 0
_SCREEN.Image2.Top=SYSMETRIC(2)-_SCREEN.Image2.Height-100-20
_SCREEN.Image2.LEFT=SYSMETRIC(1)-_SCREEN.Image2.WIDTH+1-40
_SCREEN.Image2.Visible= .T.

_PATH_ICONA_AQUARIUS = SYS(5)+SYS(2003) + "\BMP\ambiente\iconaaquarius\Icona_Aquarius.ico"

IF FILE(_PATH_ICONA_AQUARIUS)
   _SCREEN.ICON = _PATH_ICONA_AQUARIUS
ENDIF


DO FORM form\aq_admin linked


return
**QUIT


*************************************************************************
* Funzione - STR_EXTRACT      Data: 26.07.94     Autore: Project
*************************************************************************
* Questa funzione permette di estrarre da una stringa determinate
* sottostringhe contenute tra il delimitatore specificato.
* Esempio:
*     AA="Pippo,Pluto,Paperino"
*     ? STR_EXTRACT(AA,",",2)      && Ritornerà  "Pluto"
* Sintassi:
*     STR_EXTRACT(<ExpC1>,<ExpC2>,<ExpN1>)
*     ExpC1 - Stringa di origine
*     ExpC2 - Carattere delimitatore di lista
*     ExpN1 - Numero di occorrenze nella lista
*
*************************************************************************
FUNCTION STR_EXTRACT
********************

PARA SRIG,DEL,OCC

SRIG=SRIG+DEL

FOR K=1 TO OCC-1
   STAR=AT(DEL,SRIG)+1
   IF STAR >LEN(SRIG)
      SRIG=""
      EXIT
   ENDIF
   SRIG=SUBSTR(SRIG,STAR)
NEXT

FINE=AT(DEL,SRIG)

IF SRIG==""
   RETURN("")
ELSE
   RETURN(SUBSTR(SRIG,1,FINE-1))
ENDIF


*************************
FUNCTION CERCA_CHR
*************************
* RESTITUISCE LA POSIZIONE DEL PUNTATORE DELLA STRINGA DA CERCARE

PARA _STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE

_LA_STRINGA_PARTE_DA_QUI = 0
IST = 0

DO WHILE .T.

   IST=IST + 1
   CARATT = SUBSTR(_STRINGA,IST,1)
   IF CARATT = SUBSTR(_STRINGA_DA_CERCARE,1,1)
   
      IF SUBSTR(_STRINGA,IST,_LUNGHEZZA_DA_CERCARE) = SUBSTR(_STRINGA_DA_CERCARE,1,_LUNGHEZZA_DA_CERCARE)
	      
	      _LA_STRINGA_PARTE_DA_QUI = LEN(SUBSTR(_STRINGA,1,IST))
          EXIT
      
      ENDIF
   
   ENDIF

   IF IST = 300
     EXIT
   ENDIF

ENDDO

RETURN(_LA_STRINGA_PARTE_DA_QUI)



*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore

_valore=""

IF FILE(_configfile)	  && Esiste il file? 

	gnConfigFile = FOPEN(_configfile)	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  					&& Verifica errore in apertura del file
											&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if	chiave=_proprieta
					_valore=valore
				endif
			endif
		enddo
	ENDIF
	=FCLOSE(gnConfigFile)	

ENDIF

return _valore

ENDPROC




***********************************************************************
* Funzione - RIBALTA2     Data: 15.11.95   Autore: Project
***********************************************************************
*
*  Consente di convertire il formato data
*  AAAA.MM.GG in GG.MM.AAAA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(10)
*
***********************************************************************
FUNCTION RIBALTA2
*****************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && GG.MM.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _GIORNO=SUBSTR(_VALCAMPO,1,2)
        _MESE  =SUBSTR(_VALCAMPO,4,2)
        _ANNO  =SUBSTR(_VALCAMPO,7,4)
        _TUTTO =_ANNO+_SEPARA+_MESE+_SEPARA+_GIORNO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.MM.GG
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _GIORNO=SUBSTR(_VALCAMPO,9,2)
        _MESE  =SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(10)
ENDCASE

RETURN(_TUTTO)


************************************************************************
FUNCTION GET_FORMCONF
************************************************************************
LPARAMETERS _par_objectref

IF PCOUNT() < 1
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF TYPE("_par_objectref") == "O" AND !ISNULL(_par_objectref)
ELSE
	MESSAGEBOX("Nessun oggetto di riferimento al form",16,"Attenzione")
	RETURN .F.
ENDIF

_O_ObjectRef = _par_objectref
IF _O_ObjectRef.baseclass = "Form"
ELSE
	MESSAGEBOX("L'oggetto chiamante non è un form",16,"Attenzione")
	RETURN .F.
ENDIF

*** PRELEVO LE INFORMAZIONI SUL PROGRAMMA CHIAMANTE
RELEASE ArrayStackInfo
ASTACKINFO(ArrayStackInfo)
_nStackLevels = ALEN(ArrayStackInfo, 1)
_nCallingLevel = _nStackLevels - 1
_cCallingProgramFileName = UPPER(ALLTRIM(ArrayStackInfo(_nCallingLevel,2)))
_C_SrcFileName = ALLTRIM(STRTRAN(UPPER(ALLTRIM(_cCallingProgramFileName)),UPPER(SYS(5)+SYS(2003)),""))
_C_FormName = ALLTRIM(_O_ObjectRef.Name)

LOCAL _OLD_SELECT
_OLD_SELECT = SELECT()

IF USED("CX_IDFORMCONF")
	SELECT CX_IDFORMCONF
	USE
ENDIF
IF USED("CX_FORMCONF")
	SELECT CX_FORMCONF
	USE
ENDIF
x_fnam = "SRCFILENAME = '" + _C_SrcFileName + "'"
x_gnam = "FORMNAME = '" + _C_FormName + "'"
x_user = "UTENTI LIKE '%" + PUB_CODOPE + "%'"
x_cond = x_fnam + " and " + x_gnam + " and " + x_user 
cSql = "SELECT IDFORMCONF FROM FORMCONF WHERE " + x_cond + " GROUP BY IDFORMCONF"
IF !ExecCommand(cSql,"CX_IDFORMCONF")
	return(.f.)
ENDIF
SELECT CX_IDFORMCONF
GO TOP
IF EOF()
	x_fnam = "SRCFILENAME = '" + _C_SrcFileName + "'"
	x_gnam = "FORMNAME = '" + _C_FORMName + "'"
	x_user = "SUBSTRING(UTENTI,1,10) = ''"
	x_cond = x_fnam + " and " + x_gnam + " and " + x_user 
	cSql = "SELECT IDFORMCONF FROM FORMCONF WHERE " + x_cond + " GROUP BY IDFORMCONF"
	IF !ExecCommand(cSql,"CX_IDFORMCONF")
		return(.f.)
	ENDIF
	SELECT CX_IDFORMCONF
	GO TOP
	IF EOF()
		SELECT(_OLD_SELECT)
		RETURN .F.
	ENDIF
ENDIF

SELECT CX_IDFORMCONF
GO TOP
_IDFORMCONF = IDFORMCONF
x_idgc = "IDFORMCONF = '" + _IDFORMCONF + "'"
x_cond = x_idgc
cSql = "SELECT * FROM FORMCONF WHERE " + x_cond
IF !ExecCommand(cSql,"CX_FORMCONF")
	return(.f.)
ENDIF
SELECT CX_FORMCONF
GO TOP
IF EOF()
	SELECT(_OLD_SELECT)
	RETURN .F.
ENDIF
SCAN
	_cObject = "_O_ObjectRef." + ALLTRIM(OBJPATH)
	IF TYPE(_cObject) == "O" AND !ISNULL(&_cObject)
		_cObjectProperty = "_O_ObjectRef." + ALLTRIM(OBJPATH) + '.' + ALLTRIM(PROPNAME)
		IF PemStatus(&_cObject,ALLTRIM(PROPNAME),5)
			_cCustomValueCommand = _cObjectProperty + ' = ' + IIF(PROPTYPE = 'C','"','') + ALLTRIM(PROPVALUE) + IIF(PROPTYPE = 'C','"','')
			&_cCustomValueCommand 
		ENDIF
	ENDIF	
ENDSCAN

SELECT(_OLD_SELECT)

RETURN


*************************************************************************
FUNCTION FORMCONF_CTRL_OBLIGATORY_FIELDS
*************************************************************************
*** PASSATO L'OGGETTO FORM DI RIFERIMENTO, RITORNA .T. SE ESISTE UN CAMPO 
*** OBBLIGATORIO CONFIGURATO IN FORMCONF, ALTRIMENTI RITORNA .F.
*************************************************************************
LPARAMETERS _par_objectref,_par_yesmsg

IF PCOUNT() < 1
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_yesmsg = .T.
ENDIF

IF TYPE("_par_objectref") == "O" AND !ISNULL(_par_objectref)
ELSE
	*MESSAGEBOX("Nessun oggetto di riferimento al form",16,"Attenzione")
	RETURN .F.
ENDIF

_O_ObjectRef = _par_objectref
IF _O_ObjectRef.baseclass = "Form" OR _O_ObjectRef.baseclass = "Formset"
ELSE
	*MESSAGEBOX("L'oggetto chiamante non è un form",16,"Attenzione")
	RETURN .F.
ENDIF

*** PRELEVO LE INFORMAZIONI SUL PROGRAMMA CHIAMANTE
_C_SrcFileName = STRTRAN(ALLTRIM(STRTRAN(UPPER(ALLTRIM(SYS(1271, _O_ObjectRef))),UPPER(SYS(5)+SYS(2003)),"")),".SCX",".SCT")
_C_FormName = ALLTRIM(_O_ObjectRef.Name)

LOCAL _OLD_SELECT
_OLD_SELECT = SELECT()

IF USED("CX_IDFORMCONF")
	SELECT CX_IDFORMCONF
	USE
ENDIF
IF USED("CX_FORMCONF")
	SELECT CX_FORMCONF
	USE
ENDIF
x_fnam = "SRCFILENAME = '" + _C_SrcFileName + "'"
x_gnam = "FORMNAME = '" + _C_FormName + "'"
x_user = "UTENTI LIKE '%" + PUB_CODOPE + "%'"
x_csrc = "PROPNAME = 'CONTROLSOURCE'"
x_pval = "PROPVALUE <> ''"
x_expr = "EXPROBLIGATORY <> ''"
x_cond = x_fnam + " and " + x_gnam + " and " + x_user + " and " + x_csrc + " and " + x_pval + " and " + x_expr 
cSql = "SELECT IDFORMCONF FROM FORMCONF WHERE " + x_cond + " GROUP BY IDFORMCONF"
IF !ExecCommand(cSql,"CX_IDFORMCONF")
	return(.f.)
ENDIF
SELECT CX_IDFORMCONF
GO TOP
IF EOF()
	x_fnam = "SRCFILENAME = '" + _C_SrcFileName + "'"
	x_gnam = "FORMNAME = '" + _C_FORMName + "'"
	x_user = "SUBSTRING(UTENTI,1,10) = ''"
	x_csrc = "PROPNAME = 'CONTROLSOURCE'"
	x_pval = "PROPVALUE <> ''"
	x_expr = "EXPROBLIGATORY <> ''"
	x_cond = x_fnam + " and " + x_gnam + " and " + x_user + " and " + x_csrc + " and " + x_pval + " and " + x_expr 
	cSql = "SELECT IDFORMCONF FROM FORMCONF WHERE " + x_cond + " GROUP BY IDFORMCONF"
	IF !ExecCommand(cSql,"CX_IDFORMCONF")
		return(.f.)
	ENDIF
	SELECT CX_IDFORMCONF
	GO TOP
	IF EOF()
		SELECT(_OLD_SELECT)
		RETURN .F.
	ENDIF
ENDIF

SELECT CX_IDFORMCONF
GO TOP
_IDFORMCONF = IDFORMCONF
x_idgc = "IDFORMCONF = '" + _IDFORMCONF + "'"
x_csrc = "PROPNAME = 'CONTROLSOURCE'"
x_pval = "PROPVALUE <> ''"
x_expr = "EXPROBLIGATORY <> ''"
x_cond = x_idgc + " and " + x_csrc + " and " + x_pval + " and " + x_expr 
cSql = "SELECT * FROM FORMCONF WHERE " + x_cond
IF !ExecCommand(cSql,"CX_FORMCONF")
	return(.f.)
ENDIF
SELECT CX_FORMCONF
GO TOP
IF EOF()
	SELECT(_OLD_SELECT)
	RETURN .F.
ENDIF
SCAN
	_cObject = "_O_ObjectRef." + ALLTRIM(OBJPATH)
	IF TYPE(_cObject) == "O" AND !ISNULL(&_cObject)
	
		IF PemStatus(&_cObject,ALLTRIM(PROPNAME),5)
			_cPropType = ALLTRIM(PROPTYPE)
			_cControlSource = ALLTRIM(PROPVALUE)
			_cExprObligatory = ALLTRIM(EXPROBLIGATORY)
			_cFldNameObligatory = ALLTRIM(FLDNAMEOBLIGATORY)
			_cObjectRef = "_O_ObjectRef." + ALLTRIM(OBJPATH)
			
			IF &_cExprObligatory
				
				*** SETTAGGIO COLORE DI SFONDO, SE DEFINITO NEI PARAMETRI AZIENDALI
				IF PUB_OBLGBCKCOL > 0
					IF PemStatus(&_cObjectRef,"BackColor",5)
						_cBackColorCommand = _cObjectRef + ".BackColor = " + ALLTRIM(STR(PUB_OBLGBCKCOL))
						&_cBackColorCommand
					ENDIF
				ENDIF
				
				_lOkCtrl = .T.
				DO CASE
					CASE _cPropType = 'C'
						IF ISNULL(&_cControlSource) OR EMPTY(&_cControlSource)
							_lOkCtrl = .F.
						ENDIF
					CASE _cPropType = 'N'
						IF ISNULL(&_cControlSource) OR &_cControlSource = 0
							_lOkCtrl = .F.
						ENDIF
					CASE _cPropType = 'L'
						IF ISNULL(&_cControlSource)
							_lOkCtrl = .F.
						ENDIF
				ENDCASE
				
				IF !_lOkCtrl
					IF _par_yesmsg
						_cMsgTxt = "Campo '" + IIF(!EMPTY(_cFldNameObligatory),_cFldNameObligatory, _cControlSource) + "' è obbligatorio!"
						MESSAGEBOX(_cMsgTxt,48,"Attenzione")
						
						IF PemStatus(&_cObjectRef,"setfocus",5)
							_cSetFocusCommand = _cObjectRef + ".setfocus"
							&_cSetFocusCommand 
						ENDIF
					ENDIF
					
					SELECT(_OLD_SELECT)
					RETURN .T.
				ENDIF
			ENDIF
		ENDIF
		
	ENDIF	
ENDSCAN

SELECT(_OLD_SELECT)

RETURN .F.

***********************************************************************************************
*  SERVE PER TOGLIERE DAL CODICE ARTICOLO I CARATTERI FORZATI IN INPUTMASK PER EFFETTUARE LA  *
*  RICERCA PER DESCRIZIONE ARTICOLO                                                           *
***********************************************************************************************
FUNCTION TROVARTI     
***********************************************************************************************

PARA _CODART

V_CTR = 1
V_LEN = LEN(ALLTRIM(PUB_FORMAR))
V_CAR = .F.

DO WHILE .T.

   IF V_CTR > V_LEN
      EXIT
   ENDIF
   
   IF SUBSTR(PUB_FORMAR,V_CTR,1) = '.' .OR. SUBSTR(PUB_FORMAR,V_CTR,1) = '-' .OR. ;
      SUBSTR(PUB_FORMAR,V_CTR,1) = '/' .OR. SUBSTR(PUB_FORMAR,V_CTR,1) = ',' 
      V_CAR = .T.
      EXIT
   ENDIF
   
   V_CTR = V_CTR + 1
   
ENDDO

IF V_CAR
ELSE
   RETURN(_CODART)
ENDIF

V_CTR    = 1
V_LEN    = LEN(ALLTRIM(PUB_FORMAR))
V_CAR    = .F.
V_CODART = ""

DO WHILE .T.

   IF V_CTR > V_LEN
      EXIT
   ENDIF
   
   IF SUBSTR(_CODART,V_CTR,1) = '.' .OR. SUBSTR(_CODART,V_CTR,1) = '-' .OR. ;
      SUBSTR(_CODART,V_CTR,1) = '/' .OR. SUBSTR(_CODART,V_CTR,1) = ',' 
      V_CTR = V_CTR + 1
      LOOP
   ENDIF
   
   V_CODART = V_CODART + SUBSTR(_CODART,V_CTR,1)
   
   V_CTR = V_CTR + 1
   
ENDDO

RETURN(V_CODART)


*!*	******************************************************
*!*	Funzione che individua il codice articolo da ricercare
**********************************************************
FUNCTION CERCARTI
**********************************************************
PARAMETERS _CODART

V_TROV = .F.

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF
SELECT ECASH_U_ART_PR
GO TOP
IF EOF()
ELSE
   V_TROV = .T.
   X_ARTI = ART_CODPRI
   RETURN (X_ARTI)
ENDIF

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_cdisbn = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF
SELECT ECASH_U_ART_PR
GO TOP
IF EOF()
ELSE
   V_TROV = .T.
   X_ARTI = ART_CODPRI
   RETURN (X_ARTI)
ENDIF

X_ARTI = ISBNTOEAN(_CODART)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(X_ARTI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF
IF EOF()
ELSE
   V_TROV = .T.
   X_ARTI = ART_CODPRI
   RETURN (X_ARTI)
ENDIF

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_barfor = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF
SELECT ECASH_U_ART_PR
GO TOP
IF EOF()
ELSE
   V_TROV = .T.
   X_ARTI = ART_CODPRI
   RETURN (X_ARTI)
ENDIF

RETURN (X_ARTI)


*********************************************************************************************
* SEEK_NOTE_COM()	funzione per la gestione della tabella NOTE_COM
*********************************************************************************************
* La funzione restituisce dalla tabella NOTE_COM, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_note_com
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_note_com"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT *,SUBSTRING(NOT_TESTO,1,100) AS NOT_VEDI FROM note_com where not_codsoc+not_codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT *,SUBSTRING(NOT_TESTO,1,100) AS NOT_VEDI FROM note_com where not_codsoc+not_codice like "+_seek1+" order by "+_ordinamento

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA = "Codice;Testo"
PUB_VISTA = "NOT_CODICE;NOT_VEDI"
PUB_RIT    = _ritorno

DO FORM FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco commenti"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


* PROCEDURA PER CONVERSIONE DA CODICE ISBN A CODICE EAN
*******************************************************
PROCEDURE ISBNTOEAN
********************

PARAMETERS _ISBN

RELEASE V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA
PUBLIC  V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA

V_ISBN = _ISBN

V_LEN = LEN(ALLTRIM(V_ISBN))
IF V_LEN = 10
ELSE
   RETURN (V_ISBN)
ENDIF

* CONTROLLO ESATTEZZA CODICE ISBN
XXX_SOMMA = 0
K = 10
FOR I=1 TO 9
    XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_ISBN,I,1))*K
    K = K - 1
ENDFOR
IF SUBSTR(V_ISBN,10,1) <> 'X'
   XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_ISBN,10,1))
ELSE
   XXX_SOMMA = XXX_SOMMA + 10
ENDIF
IF (XXX_SOMMA % 11) = 0
ELSE
   RETURN (V_ISBN)
ENDIF

* CONVERSIONE DA ISBN AD EAN
V_EAN  = '978' + SUBSTR(V_ISBN,1,9)

XXX_SOMMA = 0
XXX_CIFRA = SPACE(01)

FOR I=1 TO 12 
    IF (I % 2) = 1
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))
    ELSE
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))*3
    ENDIF
ENDFOR

XXX_CIFRA = STR(10 - (XXX_SOMMA % 10))

V_EAN = V_EAN + ALLTRIM(XXX_CIFRA)

RETURN (V_EAN)


* PROCEDURA PER CONVERSIONE DA CODICE EAN A CODICE ISBN
******************************************************
PROCEDURE EANTOISBN
********************

PARAMETERS _EAN

RELEASE V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA
PUBLIC  V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA

V_EAN = _EAN

V_LEN = LEN(ALLTRIM(V_EAN))
IF V_LEN = 13
ELSE
   V_EAN = SPACE(16)
   RETURN (V_EAN)
ENDIF

* CONTROLLO ESATTEZZA CODICE EAN
XXX_SOMMA = 0
XXX_CIFRA = SPACE(01)
FOR I=1 TO 12 
    IF (I % 2) = 1
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))
    ELSE
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))*3
    ENDIF
ENDFOR
XXX_CIFRA = ALLTRIM(STR(10 - (XXX_SOMMA % 10)))
IF XXX_CIFRA = '10'
   XXX_CIFRA = '0'
ENDIF
IF (XXX_CIFRA = SUBSTR(V_EAN,13,1))
ELSE
   V_EAN = SPACE(16)
   RETURN (V_EAN)
ENDIF

* CONVERSIONE DA EAN AD ISBN
XXX_SOMMA     = 0
XXX_CONTROLLO = 0
XXX_CIFRA     = SPACE(01)
K = 10

V_ISBN = SUBSTR(V_EAN,4,9)

FOR I=1 TO 9
    XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_ISBN,I,1))*K
    K = K - 1
ENDFOR

FOR I=0 TO 10
    XXX_CONTROLLO = XXX_SOMMA + I
    IF (XXX_CONTROLLO % 11 = 0)
       EXIT
    ENDIF
ENDFOR

IF I <> 10
   XXX_CIFRA = ALLTRIM(STR(I))
ELSE
   XXX_CIFRA = 'X'
ENDIF

V_ISBN = V_ISBN + XXX_CIFRA

RETURN (V_ISBN)


*******************************************************************************************
  function CALCdocge1  && CALCOLA IL VALORE DEL DOCUMENTO IVE COMPRESE  SU DBASE EFFETTIVO
*******************************************************************************************
*  RICHIAMATA NEL SEGUENTE MODO : =CALCdocge1(_chiave,"fathookd","u_fat_dd","u_fat_tt",.F.)
*  								  _chiave = TAGGANCIO PER FARE LA SEEK
*  								  _IND 	  = INDICE PER LA SEEK
*  								  _DBASED = ARCHIVIO DETTAGLI DA ELABORARE
*  								  _DBASET = ARCHIVIO TESTATA  DA ELABORARE
*  								  _OKAGG  = AGGIORNA O MENO LA TESTATA

PARA  _chiave,_IND,_dettagli,_TESTATA,_OKAGG

SWS=SELECT()


RELEASE V_IVASPTRAS
PUBLIC V_IVASPTRAS
V_IVASPTRAS = ""

M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
MATPUBX     = 0

M.T_ENPACL  = 0
M.T_RA      = 0
M.T_NETTO   = 0

IVA1   = SPACE(3)
IVA2   = SPACE(3)
IVA3   = SPACE(3)
IVA4   = SPACE(3)
IVA5   = SPACE(3)
IMPO1  = 0
IMPO2  = 0
IMPO3  = 0
IMPO4  = 0
IMPO5  = 0
IMPOS1 = 0
IMPOS2 = 0
IMPOS3 = 0
IMPOS4 = 0
IMPOS5 = 0
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0

RELEASE IMPO_MAGG,IMPOS_MAGG
PUBLIC IMPO_MAGG,IMPOS_MAGG
IMPO_MAGG  = 0
IMPOS_MAGG = 0

RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO


_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   


V_SQL = 'select * from ' + _dettagli + ' where daggancio = ?_chiave'
IF !ExecCommand(v_sql,_dettagli)
    return
ENDIF
SELECT &_dettagli


**** STESSA GESTIONE DELLA PROCEDURA CALCdocgen QUI SOPRA 
IF ALLTRIM(_dettagli) = "cu_orf_dd"
   _ALRID      = CERCA_IVA_DEFAULT(_dettagli,"CODICE")  
   _ESENZI     =.F.				&& CLIENTE NON IN ESENZIONE
   _RAPERC     = 0
   _ENPACLPERC = 0
ELSE


   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(m.ord_codcli) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_ana_cl")
      return(.f.)
   ENDIF
   SELECT u_ana_cl
   GO top
   IF !EOF()
    	V_IVASPTRAS      = CLI_IVASPTRAS
   ELSE
   		V_IVASPTRAS      = ""
   ENDIF 

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(m.ord_codcli) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_cli_an")
      return(.f.)
   ENDIF
   SELECT u_cli_an
   IF reccount() <> 0
      _ALRID    = CLI_ALRID
	  IF !EMPTY(CLI_ALRID)
	     _ESENZI = .T.			&& CLIENTE IN ESENZIONE
	  ELSE
	     _ALRID  = CERCA_IVA_DEFAULT(_dettagli,"CODICE")  
	     _ESENZI = .F.			&& CLIENTE NON IN ESENZIONE
	  ENDIF

	  IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	  ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
      ENDIF      
      
   ELSE
	  _ALRID      = CERCA_IVA_DEFAULT(_dettagli,"CODICE")  
	  _ESENZI     =.F.				&& CLIENTE NON IN ESENZIONE
      _RAPERC     = 0
      _ENPACLPERC = 0
   ENDIF
ENDIF

SELECT &_dettagli
GO TOP
DO WHILE .NOT. EOF()

   IF DELETED()
      SELECT &_dettagli
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT &_dettagli
      SKIP +1
      LOOP
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)

  
   IF !ExecCommand("select * from para where codice = 'IVA'+?COD_IVA","para")
      return
   ENDIF
   SELECT PARA
   IF reccount() <> 0
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   SELECT &_dettagli

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100



    IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
   ENDIF

   DO CASE
   
   	  CASE ALLTRIM(_DETTAGLI) = "U_FAT_DD"
		   IF ORD_PUBBLI = "S"
		      MATPUBX = MATPUBX + ORD_VALORE
		      _CNT_PUBBLI = _CNT_PUBBLI + 1		
		   ENDIF
	       IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
		      PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
           ENDIF


		   IF ORD_PUBBLI = "O"						&& CONTA ARTICOLO OMAGGIO
			   _CNT_OMAGGI = _CNT_OMAGGI + 1		
		   ENDIF

		   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO' 	&& CALCOLO IMPONIBILE E IMPOSTA POLIECO
		 		_IMPONIBILE_POLIECO = _IMPONIBILE_POLIECO + IMPONIB
				_IMPOSTA_POLIECO    = _IMPOSTA_POLIECO    + IMPOSTA  	   
		   ENDIF


		   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
		      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
		      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
		      SKIP +1
		      LOOP
		   ENDIF
		   
	  CASE ALLTRIM(_DETTAGLI) = "U_BOL_DD"
		   IF ORD_PUBBLI = "S"
		      MATPUBX = MATPUBX + ORD_VALORE
		   ENDIF

		   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
		      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
		      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
		      SKIP +1
		      LOOP
		   ENDIF


	  CASE ALLTRIM(_DETTAGLI) = "U_ORD_DD"
		   IF ORD_PUBBLI = "S"
		      MATPUBX = MATPUBX + ORD_VALORE
		   ENDIF

		   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
		      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
		      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
		      SKIP +1
		      LOOP
		   ENDIF


   ENDCASE


   IF ((IVA1 = SPACE(3)) .OR. (IVA1 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
      IVA1   = COD_IVA
      IMPO1  = IMPO1+IMPONIB
      IMPOS1 = IMPOS1 + IMPOSTA
   ELSE
      IF ((IVA2 = SPACE(3)) .OR. (IVA2 = COD_IVA))  .AND. (DES_ART <> ('*** COMMENTO ***'))
         IVA2   = COD_IVA
         IMPO2  = IMPO2+IMPONIB
         IMPOS2 = IMPOS2 + IMPOSTA
      ELSE
         IF ((IVA3 = SPACE(3)) .OR. (IVA3 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
            IVA3   = COD_IVA
            IMPO3  = IMPO3+IMPONIB
            IMPOS3 = IMPOS3 + IMPOSTA
         ELSE
            IF ((IVA4 = SPACE(3)) .OR. (IVA4 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
               IVA4   = COD_IVA
               IMPO4  = IMPO4+IMPONIB
               IMPOS4 = IMPOS4 + IMPOSTA
            ELSE
               IF ((IVA5 = SPACE(3)) .OR. (IVA5 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
                  IVA5   = COD_IVA
                  IMPO5  = IMPO5+IMPONIB
                  IMPOS5 = IMPOS5 + IMPOSTA
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   
   IF UPPER(ALLTRIM(_DETTAGLI)) = "U_ORD_DD" OR UPPER(ALLTRIM(_DETTAGLI)) = "U_BOL_DD"
      IF ORD_PRZFIN > 0
         _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMFIN)
         IF TYPE(_cNomeCampoQta) == 'N'
         ELSE
            _cNomeCampoQta = "ORD_QTAORD"
         ENDIF
         IMPONIB = &_cNomeCampoQta * ORD_PRZFIN
         IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
         IMPO_MAGG = IMPO_MAGG + IMPONIB 
         IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
      ENDIF
      IF ORD_PRZBAR > 0
         _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMBAR)
         IF TYPE(_cNomeCampoQta) == 'N'
         ELSE
            _cNomeCampoQta = "ORD_QTAORD"
         ENDIF
         IMPONIB = &_cNomeCampoQta * ORD_PRZBAR
         IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
         IMPO_MAGG = IMPO_MAGG + IMPONIB 
         IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
      ENDIF
      IF ORD_PRZSEZ > 0
         _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMSEZ)
         IF TYPE(_cNomeCampoQta) == 'N'
         ELSE
            _cNomeCampoQta = "ORD_QTAORD"
         ENDIF
         IMPONIB = &_cNomeCampoQta * ORD_PRZSEZ
         IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
         IMPO_MAGG = IMPO_MAGG + IMPONIB 
         IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
      ENDIF
   ENDIF

   SELECT &_dettagli
   SKIP +1

ENDDO

IMPO_MAGG = ROUND(IMPO_MAGG,2)
IMPOS_MAGG = ROUND(IMPOS_MAGG,2)

V_SPESE = M.ORD_SPBOLL + M.ORD_SPTRAS

PUB_ALIQ = CERCA_IVA_DEFAULT(_dettagli,"ALIQUOTA")  

IF !_ESENZI      					&& SOLO SE NON IN ESENZIONE
   V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
ELSE
   V_IMPSP = 0		 				&& ESENTE
ENDIF


** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *
PIVA1TRA = ""
DIVA_SPESE_TRASPORTO = ""
IF !EMPTY(V_IVASPTRAS)

	v_seek 	  = 'IVA'+V_IVASPTRAS
	v_chiave  = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   PIVA1TRA					= SUBSTR(LIBERA,1,03)
	   DIVA_SPESE_TRASPORTO		= ALLTRIM(SUBSTR(DESCRI,1,80))
	   SAY_IVA_SPESE_TRASPORTO 	= DIVA_SPESE_TRASPORTO
       ALIQ 					= SUBSTR(LIBERA,1,3)
       NUM_ALIQ 				= VAL(ALIQ)
    ELSE
       NUM_ALIQ 				= 0
       SAY_IVA_SPESE_TRASPORTO 	= ""
	ENDIF

    V_IMPSP = V_SPESE * (NUM_ALIQ/100)

ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *



*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
   IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
       IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
       IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
       M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
       M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
   ENDIF


* -->> inserisco l'iva delle spese nel caso non siA stata gestita sul caso cliente EXTRA CEE
FOR HF=1 TO 5
  _IMPO ="IMPO"+ALLTRIM(STR(HF))
  _IMPOS="IMPOS"+ALLTRIM(STR(HF))
  IF &_IMPO=0
  	LOOP
  ENDIF	
  IF ROUND((&_IMPOS/&_IMPO)*100,0)=PUB_ALIQ   
     &_IMPOS=&_IMPOS+V_IMPSP
     EXIT
  ENDIF
NEXT


IMPOS1		=	ROUND((IMPOS1+.0000),2)
IMPOS2		=	ROUND((IMPOS2+.0000),2)
IMPOS3		=	ROUND((IMPOS3+.0000),2)
IMPOS4		=	ROUND((IMPOS4+.0000),2)		
IMPOS5		=	ROUND((IMPOS5+.0000),2)

M.T_IMPONIB = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5
M.T_IMPOSTA = IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5



M.T_IMPONIB = M.T_IMPONIB + IMPO_MAGG 
M.T_IMPOSTA = M.T_IMPOSTA + IMPOS_MAGG

M.T_IMPONIB = M.T_IMPONIB + V_SPESE

M.T_VALORE  = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX
*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	M.T_VALORE  = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX - PUB_TOTPOLIECO
ENDIF

*!*	CALCOLO ENPACL
IF _ENPACLPERC <> 0
	M.T_ENPACL = ROUND((M.T_IMPONIB * _ENPACLPERC ) / 100,2)
	M.T_IMPONIB = M.T_IMPONIB + M.T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
	_IVA_ENPACL = (M.T_ENPACL * NUM_ALIQ) / 100
	_IVA_ENPACL	=  ROUND((_IVA_ENPACL+.0000),2)
	M.T_IMPOSTA = M.T_IMPOSTA + _IVA_ENPACL
	M.T_VALORE  = M.T_VALORE  + M.T_ENPACL + _IVA_ENPACL && SOMMO A TOTALE DOCUMENTO IL CONTRIBUTO DEL 2% ENPACL + RELATIVA IVA
ENDIF


*!*	CALCOLO RA
IF _RAPERC   <> 0
	_IMPONIBILE_NO_ENPACL = ( M.T_IMPONIB - M.T_ENPACL )
	M.T_RA = ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
	M.T_NETTO = M.T_VALORE - M.T_RA
ENDIF


M.ORD_VALORE  = M.T_VALORE
M.ORD_IMPONIB = M.T_IMPONIB		&& SERGIO - 26/03/2015
M.ORD_IMPOSTA = M.T_IMPOSTA		&& SERGIO - 26/03/2015

IVA1   = ""
IVA2   = ""
IVA3   = ""
IVA4   = ""
IVA5   = ""
IMPO1  = 0
IMPO2  = 0
IMPO3  = 0
IMPO4  = 0
IMPO5  = 0
IMPOS1 = 0
IMPOS2 = 0
IMPOS3 = 0
IMPOS4 = 0
IMPOS5 = 0

IF _OKAGG
  v_sql = 'select * from ' + _testata + ' where taggancio = ?_chiave'
  IF !ExecRW(v_sql,_testata,"R")
     return
  ENDIF
  SELECT &_testata
  IF reccount() <> 0
     REPLACE ORD_VALORE 	 WITH M.ORD_VALORE
	 REPLACE ORD_IMPONIB     WITH M.T_IMPONIB		&& SERGIO - 26/03/2015
	 REPLACE ORD_IMPOSTA     WITH M.T_IMPOSTA		&& SERGIO - 26/03/2015
  ENDIF
  IF !ExecRW("",_testata,"W")
     return
  ENDIF
ENDIF

SELECT(SWS)

RETURN(.T.)


***********************************************************************
* Funzione - checkEmailAddress     Data: 28/09/2007   Autore: Project
***********************************************************************
*
*  Consente di verificare che il contenuto di una stringa passata come 
*  parametro sia formalmente corretto per essere utilizzato come 
*  indirizzo di posta elettronica valido - Valori di ritorno: .T./.F.
*
***********************************************************************
FUNCTION checkEmailAddress     
***********************************************************************

PARAMETER _strEmail

_x_strEmail = ALLTRIM(_strEmail)
_x_return   = .T.

_ADMITTED_LOCAL_STRING  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'*+-/=?^_`{|}~."
_ADMITTED_DOMAIN_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."

IF EMPTY(_strEmail)
	_x_return = .F.
ELSE
	_XX_AT  = OCCURS("@",_x_strEmail) = 1 .AND. !EMPTY(SUBSTR(_x_strEmail,ATC("@",_x_strEmail)-1,1)) .AND. ;
				 !EMPTY(SUBSTR(_x_strEmail,ATC("@",_x_strEmail)+1,1)) .AND. SUBSTR(_x_strEmail,ATC("@",_x_strEmail)+1,1) <> "."
	_XX_DOT = OCCURS(".",_x_strEmail) > 0 .AND. !EMPTY(SUBSTR(_x_strEmail,RAT(".",_x_strEmail)-1,1)) .AND. ;
				 !EMPTY(SUBSTR(_x_strEmail,RAT(".",_x_strEmail)+1,1)) .AND. SUBSTR(_x_strEmail,RAT(".",_x_strEmail)-1,1) <> "@"
	_XX_SPACE = OCCURS(" ",_x_strEmail) = 0
	IF _XX_AT .AND. _XX_DOT .AND. _XX_SPACE
		*** VERIFICA STRINGA LOCAL INDIRIZZO E-MAIL
		_LOCAL_STRING = SUBSTR(_x_strEmail,1,ATC("@",_x_strEmail)-1)
		FOR I = 1 TO LEN(_LOCAL_STRING)
			IF SUBSTR(_LOCAL_STRING,I,1) $ _ADMITTED_LOCAL_STRING
			ELSE
				_x_return = .F.
			ENDIF
		ENDFOR
		IF OCCURS("--",_LOCAL_STRING) > 0
			_x_return = .F.
		ENDIF
		
		*** VERIFICA STRINGA DOMAIN INDIRIZZO E-MAIL
		_DOMAIN_STRING = SUBSTR(_x_strEmail,ATC("@",_x_strEmail)+1)
		FOR I = 1 TO LEN(_DOMAIN_STRING)
			IF SUBSTR(_DOMAIN_STRING,I,1) $ _ADMITTED_DOMAIN_STRING
			ELSE
				_x_return = .F.
			ENDIF
		ENDFOR
		IF OCCURS("--",_DOMAIN_STRING) > 0 .OR. OCCURS("..",_DOMAIN_STRING) > 0
			_x_return = .F.
		ENDIF
	ELSE
		_x_return = .F.
	ENDIF
ENDIF


RETURN(_x_return)


***********************************************************************
* Funzione - checkSMTPserver     Data: 06/06/2011   Autore: Project
***********************************************************************
*
*  Consente di verificare che il contenuto di una stringa passata come 
*  parametro sia formalmente corretto per essere utilizzato come 
*  nome di server SMTP - Valori di ritorno: .T./.F.
*
***********************************************************************
FUNCTION checkSMTPserver
***********************************************************************

PARAMETER _strSMTP

_x_strSMTP = ALLTRIM(_strSMTP)
_x_return  = .T.

_ADMITTED_DOMAIN_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."

IF EMPTY(_strSMTP)
	_x_return = .F.
ELSE
	_XX_DOT = OCCURS(".",_x_strSMTP) > 0 .AND. !EMPTY(SUBSTR(_x_strSMTP,RAT(".",_x_strSMTP)-1,1)) .AND. !EMPTY(SUBSTR(_x_strSMTP,RAT(".",_x_strSMTP)+1,1))
	_XX_SPACE = OCCURS(" ",_x_strSMTP) = 0
	IF _XX_DOT .AND. _XX_SPACE
		*** VERIFICA STRINGA SMTP
		FOR I = 1 TO LEN(_x_strSMTP)
			IF SUBSTR(_x_strSMTP,I,1) $ _ADMITTED_DOMAIN_STRING
			ELSE
				_x_return = .F.
			ENDIF
		ENDFOR
		IF OCCURS("--",_x_strSMTP) > 0 .OR. OCCURS("..",_x_strSMTP) > 0
			_x_return = .F.
		ENDIF
	ELSE
		_x_return = .F.
	ENDIF
ENDIF


RETURN(_x_return)

******************************************
FUNCTION EDITBOX
******************************************
PARAMETERS _VALORE,_CAPTION

IF PCOUNT() >= 1
ELSE
	_VALORE = ""
ENDIF

IF PCOUNT() >= 2
ELSE
	_CAPTION = "Inserire il testo"
ENDIF

PUBLIC _VARIABILE_MEMO AS MEMO, _CONFERMA_TESTO AS Boolean
_VARIABILE_MEMO = _VALORE
_CONFERMA_TESTO = .F.

DO FORM FORM\EDITBOX WITH _CAPTION

IF _CONFERMA_TESTO
	RETURN _VARIABILE_MEMO
ELSE
	RETURN .F.
ENDIF

ENDFUNC


******************************************
FUNCTION HTMLEDITBOX
******************************************
PARAMETERS _VALORE,_CAPTION

IF PCOUNT() >= 1
ELSE
	_VALORE = ""
ENDIF

IF PCOUNT() >= 2
ELSE
	_CAPTION = "Inserire il testo"
ENDIF

PUBLIC _VARIABILE_MEMO AS MEMO, _CONFERMA_TESTO AS Boolean
_VARIABILE_MEMO = _VALORE
_CONFERMA_TESTO = .F.

DO FORM FORM\HTMLEDITBOX WITH _CAPTION

IF _CONFERMA_TESTO
	RETURN _VARIABILE_MEMO
ELSE
	RETURN .F.
ENDIF

ENDFUNC





**************************
FUNCTION CERCA_IVA_DEFAULT
**************************
**********************************************************************************************************************************
*** PASSANDO IL NOME TABELLA OPPURE LA DATA DI RIFERIMENTO RITORNA IL CODICE IVA DI DEFAULT OPPURE L'ALIQUOTA
**********************************************************************************************************************************
*** ESEMPI:
***   PUB_IVADEF = CERCA_IVA_DEFAULT("CU_FAT_DD","CODICE")
**********************************************************************************************************************************
***   PUB_ALIQ = CERCA_IVA_DEFAULT("CU_FAT_DD","ALIQUOTA")
**********************************************************************************************************************************
***   PUB_IVADEF = CERCA_IVA_DEFAULT("","CODICE",M.ORD_DATORD)
**********************************************************************************************************************************
PARAMETERS _par_tabella,_par_ritorno,_par_datarif

IF PCOUNT() >= 2
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF TYPE("_par_tabella") == 'C'
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF TYPE("_par_ritorno") == 'C'
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
	RETURN ""
ENDIF
IF _par_ritorno == 'CODICE' .OR. _par_ritorno == 'ALIQUOTA'
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_datarif = ""
ENDIF

IF EMPTY(_par_tabella)
	IF EMPTY(_par_datarif)
		MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
		RETURN ""
	ENDIF	
ENDIF

_RIT = ""
_data = ""

SWS=SELECT()


IF EMPTY(_par_datarif)
	SELECT &_par_tabella
	GO TOP

	DO CASE
		*CASE 'U_BOL_DD' $ UPPER(ALLTRIM(_par_tabella))
		CASE 'U_BOL_DD' $ UPPER(ALLTRIM(_par_tabella)) OR 'U_BCL_DD' $ UPPER(ALLTRIM(_par_tabella))  && ERASMO - 09/11/2011
			IF TYPE("M.ORD_INTRAS") == 'C'
				_data = M.ORD_INTRAS
			ENDIF
			IF EMPTY(_data)
				IF TYPE("M.ORD_DATORD") == 'C'
					_data = M.ORD_DATORD
				ELSE
					_data = ORS_DATORD
				ENDIF
			ENDIF
			
		OTHERWISE
			IF TYPE("M.ORD_DATORD") == 'C'
				_data = M.ORD_DATORD
			ELSE
				_data = ORS_DATORD
			ENDIF
	ENDCASE
ELSE
	_data = _par_datarif
ENDIF

IF EMPTY(_data)
	_data = RIBALTA2(DTOC(DATE()))
ENDIF

IF SUBSTR(_data,3,1) == '/'
	_data = RIBALTA2(_data)
ENDIF

_CODIVA = ""
x_dtda = "DATADA <= '" + _data + "'"
x_dtal = "DATAAL >= '" + _data + "'"
x_cond = x_dtda + " and " + x_dtal 
Csql = "select * from ivadefault where " + x_cond
IF !ExecCommand(Csql,"cx_ivadefault")
   return(.f.)
ENDIF
SELECT cx_ivadefault
GO TOP
IF EOF()
	_CODIVA = ALLTRIM(PUB_IVA)
ELSE
	_CODIVA = ALLTRIM(CODIVA)
ENDIF

IF _par_ritorno == 'CODICE'
	_RIT = _CODIVA
ELSE
	PERC_ALIQ = 0
	IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(_CODIVA) + "'","cx_para")
	   return
	ENDIF
	SELECT cx_para
	IF reccount() <> 0
	   cALIQ = SUBSTR(LIBERA,1,3)
	   PERC_ALIQ = VAL(cALIQ)
	ENDIF
	RELEASE _RIT
	_RIT = PERC_ALIQ
ENDIF

SELECT(SWS)

RETURN _RIT

ENDFUNC


***********************************
PROCEDURE ORDINA_COLONNA_GRIGLIA
***********************************
PARAMETERS _CURSOR,_CAMPO,_NOME_INDICE

LOCAL _TAG_NAME,_TAG_KEY,_TAG_ORDER,_CONTA_INDICI
LOCAL ARRAY _AINDEX[1]


IF PCOUNT()<3
	MESSAGEBOX("NUMERO PARAMETRI NON VALIDO",48,"PROCEDURE ORDINA_COLONNA_GRIGLIA")
	RETURN
ENDIF

SELECT &_CURSOR

ATAGINFO(_AINDEX)

_TAG_NAME=""
_TAG_KEY=""
_TAG_ORDER="DESCENDING"

IF ASCAN( _AINDEX, _NOME_INDICE , -1, -1, 1, 15 ) > 0

	FOR _CONTA_INDICI=1 TO ALEN(_AINDEX,1)
	 	_TAG_NAME= _AINDEX[_CONTA_INDICI,1]
	 	_TAG_KEY = _AINDEX[_CONTA_INDICI,3]
	 	_TAG_ORDER = _AINDEX[_CONTA_INDICI,5]
	 	
	 	IF _TAG_NAME=_NOME_INDICE
	 		EXIT
	 	ENDIF

	NEXT
ENDIF

*!*	IF _TAG_ORDER = "DESCENDING"
*!*		INDEX ON &_CAMPO TAG &_NOME_INDICE 
*!*	ELSE
*!*		INDEX ON &_CAMPO TAG &_NOME_INDICE DESC
*!*	ENDIF
**=> ERASMO - INIZIO 19/10/2022
IF TYPE(_CAMPO) == 'C'
	LOCAL _NOMECAMPO,_DIMENSIONE_CAMPO
	_DIMENSIONE_CAMPO = 0
	SELECT &_CURSOR
	AFIELDS(_A_CURSORE)
	FOR I = 1 TO ALEN(_A_CURSORE,1)
		_NOMECAMPO = ALLTRIM(_A_CURSORE[I,1])
		IF UPPER(ALLTRIM(_CURSOR)) + '.' + UPPER(ALLTRIM(_NOMECAMPO)) == UPPER(ALLTRIM(_CAMPO))
			_DIMENSIONE_CAMPO = _A_CURSORE[I,3]
			EXIT
		ENDIF
	ENDFOR
	IF _DIMENSIONE_CAMPO > 100
		IF _TAG_ORDER = "DESCENDING"
			INDEX ON SUBSTR(&_CAMPO,1,100) TAG &_NOME_INDICE 
		ELSE
			INDEX ON SUBSTR(&_CAMPO,1,100) TAG &_NOME_INDICE DESC
		ENDIF
	ELSE
		IF _TAG_ORDER = "DESCENDING"
			INDEX ON &_CAMPO TAG &_NOME_INDICE 
		ELSE
			INDEX ON &_CAMPO TAG &_NOME_INDICE DESC
		ENDIF
	ENDIF
ELSE
	IF _TAG_ORDER = "DESCENDING"
		INDEX ON &_CAMPO TAG &_NOME_INDICE 
	ELSE
		INDEX ON &_CAMPO TAG &_NOME_INDICE DESC
	ENDIF
ENDIF
**=> ERASMO - FINE 19/10/2022

RETURN 

* FINE PROCEDURE ORDINA_COLONNA_GRIGLIA
***********************************
