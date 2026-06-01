*!*	##############################################################################################################
  
					**********************************************************************************************
					***     		PROJECT SRL - PROCEDURE PER LO SCHEDULATOREErp Aquarius              	   ***
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
 
RELEASE _DATA_BASE_SQL
PUBLIC _DATA_BASE_SQL
_DATA_BASE_SQL = ''
 
RELEASE PUB_DIR
PUBLIC PUB_DIR 
PUB_DIR     = SYS(2003)   &&ALLTRIM(PATH) 
 
DO PRG\STARTSET
DO PRG\ADMINVAR   
   
SET EXCLUSIVE OFF   
   
_PATH_AQUARIUS=LEGGE_CONFIG("AQ_SCHEDULER_CONFIG.CFG","PATH_AQUARIUS")						&& RICERCA VARIABILE
SET DEFA TO &_path_aquarius


_DATA_BASE_SQL=LEGGE_CONFIG("AQ_SCHEDULER_CONFIG.CFG","DATA_BASE_SQL")						&& RICERCA DATABASE
DO PRG\GESTIONE_DBSOCIETA WITH PUB_NOMOPE,_DATA_BASE_SQL  									&& SI CONNETTE AL DATABASE E GESTISCE PUB_LOGO,PUB_LOGO1



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

** ############################################################## (variabili ) ##################################################################################
RELEASE PUB_ANNO,PUB_ANNOP,PUB_ANNOS
PUBLIC PUB_ANNO,PUB_ANNOP,PUB_ANNOS


RELEASE PUB_LCL,PUB_ARCH      && DEFINISCE LA LUNGHEZZA DEL CODICE CLIENTE 
PUBLIC PUB_LCL,PUB_ARCH      && DEFINISCE LA LUNGHEZZA DEL CODICE CLIENTE 
PUB_LCL  = 9


PUB_ANNO =  SUBSTR(XXX_DATA,7,4)
PUB_ANNOX = VAL(PUB_ANNO) - 1
PUB_ANNOP = STR(PUB_ANNOX,4,0)
PUB_ANNOY = VAL(PUB_ANNO) + 1
PUB_ANNOS = STR(PUB_ANNOY,4,0)




=AQUADOCU()			&& GESTIONE DOCUMENTI PREVISTI NEL SISTEMA INFORMATIVO

** ############################################################## (variabili ) ##################################################################################


_SCREEN.Caption   = "E.R.P. Aquarius  www.projectsrl.net    " + "[" + ALLTRIM(XXX_VERSIONE)+"]    " + "Data " + XXX_DATA + " Ora inizio " + XXX_TIME
_SCREEN.BACKCOLOR = RGB(60,112,167)
RELEASE PUB_DINDIR	&& PUNTATORE DINAMICO ALLA RIRECTORY AQUARIUS LOCALE O SUL/SUI SERVER REMOTO/I
PUBLIC PUB_DINDIR	&& PUNTATORE DINAMICO ALLA RIRECTORY AQUARIUS LOCALE O SUL/SUI SERVER REMOTO/I
PUB_DINDIR = SYS(5)+SYS(2003)
RELEASE PUB_DESKTOP
PUBLIC PUB_DESKTOP
PUB_DESKTOP ="\BMP\AMBIENTE\SFONDI\SFONDO_AQUARIUS.JPG"                                                                                                                                                                
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


DO FORM form\aq_scheduler linked

** Uscita dal menu
SET SYSMENU TO DEFAULT
SET TALK ON
ON KEY LABEL "CTRL+Q"
ON KEY LABEL "CTRL+D"
ON KEY LABEL "RIGHTMOUSE"   
ON READERROR
CLEAR WINDOW ALL
DEACTIVATE WINDOW DEBUG
MODIFY WINDOW SCREEN

ON ERROR

ON SHUTDOWN   
ON KEY  && ELIMINA TUTTE LE IMPOSTAZIONI DEL TIPO "ON KEY LABEL" IN UN COLPO SOLO

SET TALK OFF
SET NOTIFY OFF
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


******************************
FUNCTION AQUADOCU       && CARICA I DOCUMENTI PREVISTI NEL SISTEMA INFORMATIVO
******************************

SS=STR(SELECT())

IF !ExecCommand("select * from u_azi_an","u_azi_an")
   return
ENDIF

SELECT u_azi_an
GO TOP 
IF reccount() <> 0
   SCATTER MEMVAR MEMO
ELSE
   WAIT WINDOW "Per cortesia codificare i parametri aziendali"
   RETURN
ENDIF

PUB_MESERR = M.AZI_MESERR
PUB_FAMTU  = M.AZI_FAMTU
PUB_BOLLA  = M.AZI_BOLLA
PUB_FAPRO  = M.AZI_FAPRO
PUB_ORDIN  = M.AZI_ORDIN
PUB_FATTU  = M.AZI_FATTU
PUB_FATTR  = M.AZI_FATTR
PUB_EFFE   = M.AZI_EFFE
PUB_ORFO   = M.AZI_ORFO
PUB_OFFE   = M.AZI_OFFE
PUB_COMM   = M.AZI_COMM
PUB_CTLO   = M.AZI_CTLO
PUB_CODM   = M.AZI_CODM
PUB_SAU    = M.AZI_SAU
PUB_NOSC   = M.AZI_NOSC
PUB_SKART  = M.AZI_SKART
PUB_RISOLU = M.AZI_RISOLU
PUB_IVA    = M.AZI_IVA
PUB_NCR    = M.AZI_NCR
PUB_ESIVA  = M.AZI_ESIVA
PUB_NORD   = M.AZI_NORD
PUB_TFTOP  = M.AZI_TFTOP
PUB_COMCEE = M.AZI_COMCEE
PUB_PREZZI = M.AZI_PREZZI
PUB_NBOBA  = M.AZI_NBOBA
PUB_CTRGIA = M.AZI_CTRGIA
PUB_CTRORF = M.AZI_CTRORF
PUB_CLIDIR = M.AZI_CLIDIR
PUB_CAUDIR = M.AZI_CAUDIR
PUB_CERTIF = M.AZI_CERTIF
PUB_GIAADF = M.AZI_GIAADF
PUB_FORPRE = M.AZI_FORPRE

PUB_TIPCON = M.AZI_TIPCON  
PUB_PRZBAS = M.AZI_PRZBAS  
PUB_DATOLD = M.AZI_DATOLD  
PUB_CAMCOS = M.AZI_CAMCOS 

PUB_CAUANT = M.AZI_CAUANT
PUB_CAUAVA = M.AZI_CAUAVA
PUB_CAUSAL = M.AZI_CAUSAL
PUB_COMSEM = M.AZI_COMSEM
PUB_CPAINC = M.AZI_CPAINC
PUB_ARTINC = M.AZI_ARTINC
PUB_CAUCFO = M.AZI_CAUCFO
PUB_CAUCSP = M.AZI_CAUCSP
PUB_CAUSSP = M.AZI_CAUSSP
PUB_CAUSFA = M.AZI_CAUSFA
PUB_OREGIO = M.AZI_OREGIO
PUB_CAUCMA = M.AZI_CAUCMA
PUB_DDTRIC = M.AZI_DDTRIC

IF EMPTY(PUB_IVA)
   PUB_IVA = "21 "
ENDIF

PUB_PERCENTUALE_IVA_DEFAULT  = 0
=DETERMINA_ALIQUOTA_IVA_DEFAULT()

PUB_UM     = M.AZI_UM
IF EMPTY(PUB_UM)
   PUB_UM = "NR"
ENDIF
PUB_VERYD  = M.AZI_VERYD
PUB_SPINC  = M.AZI_SPINC
PUB_SCAFA  = M.AZI_SCAFA
PUB_CFDEF  = M.AZI_CFDEF
PUB_CADEF  = M.AZI_CADEF
PUB_WEBRCF = M.AZI_WEBRCF
PUB_WEBRCD = M.AZI_WEBRCD
PUB_WEBTRF = M.AZI_WEBTRF
PUB_WEBTRD = M.AZI_WEBTRD

PUB_MLPLTU = M.AZI_MLPLTU
PUB_MLPLDT = M.AZI_MLPLDT
PUB_MLEBDT = M.AZI_MLEBDT
PUB_QTAORF = M.AZI_QTAORF
PUB_MAGLOG = M.AZI_MAGLOG
PUB_PROGAA = M.AZI_PROGAA
PUB_NOSPOO = M.AZI_NOSPOO
PUB_CAULES = M.AZI_CAULES

PUB_SC1    = M.AZI_SC1
PUB_SC2    = M.AZI_SC2
PUB_SC3    = M.AZI_SC3
PUB_PROVVI = M.AZI_PROVVI

PUB_PAGANT = M.AZI_PAGANT
PUB_BFO    = M.AZI_BFO
PUB_BOLFOR = M.AZI_BOLFOR
PUB_CTRLBF = M.AZI_CTRLBF
PUB_CODBUN = M.AZI_CODBUN
PUB_VISRIC = M.AZI_VISRIC
PUB_VISRID = M.AZI_VISRID
PUB_CAUPDV = M.AZI_CAUPDV
PUB_FTPROT = M.AZI_FTPROT
PUB_FTPRIC = M.AZI_FTPRIC
PUB_CAUTRA = ALLTRIM(M.AZI_CAUTRA)
PUB_RESCLI = ALLTRIM(M.AZI_RESCLI)
PUB_GESTIONE_MULTIANNO = M.AZI_MULTIANNO    		
PUB_NFATDIFFERITA      = M.AZI_NFATDIFFERITA    	
PUB_CAUSOS = M.AZI_CAUSOS
PUB_RICONF = M.AZI_RICONF   

PUB_DECQTA = M.AZI_DECQTA   
PUB_DECPRZ = M.AZI_DECPRZ  
PUB_DECVAL = M.AZI_DECVAL  

PUB_CARORF = M.AZI_CARORF
PUB_CQUMPC = M.AZI_CQUMPC
PUB_CQUMPN = M.AZI_CQUMPN
PUB_SPAPRO = M.AZI_SPAPRO
PUB_SPAMPR = M.AZI_SPAMPR
PUB_SPACQS = M.AZI_SPACQS
PUB_CQUSLC = M.AZI_CQUSLC
PUB_CQUSLN = M.AZI_CQUSLN
PUB_RIBPRO = M.AZI_RIBPRO
PUB_RIBSLR = M.AZI_RIBSLR
PUB_RIBSLO = M.AZI_RIBSLO
PUB_TAGPRO = M.AZI_TAGPRO
PUB_TAGSLR = M.AZI_TAGSLR
PUB_TAGPFO = M.AZI_TAGPFO
PUB_ALTLUN = M.AZI_ALTLUN
=RICERCA_DESMAGPROD()
SELECT u_azi_an

IF EMPTY(PUB_CADEF)
   PUB_CADEF = '0001004         '
ENDIF

PUB_NBOIE  = M.AZI_NBOIE
PUB_NFANC  = M.AZI_NFANC
PUB_LIS01  = M.AZI_LIS01
PUB_LIS02  = M.AZI_LIS02
PUB_LIS03  = M.AZI_LIS03
PUB_LIS04  = M.AZI_LIS04
PUB_LIS05  = M.AZI_LIS05
PUB_LIS06  = M.AZI_LIS06
PUB_LIS07  = M.AZI_LIS07
PUB_LIS08  = M.AZI_LIS08
PUB_LIS09  = M.AZI_LIS09

*** MICHELA  *** 29/11/2004 *** INIZIO  
PUB_LIS10  = M.AZI_LIS10
*** MICHELA  *** 29/11/2004 *** FINE

PUB_LIS0A  = M.AZI_LIS0A
PUB_LINEA  = M.AZI_LINEA
PUB_STFAD  = M.AZI_STFAD
PUB_STFAT  = M.AZI_STFAT
PUB_STFAP  = M.AZI_STFAP

IF EMPTY(PUB_LINEA)
   PUB_LINEA = "1 "
ENDIF
PUB_CPA    = M.AZI_CPA
IF EMPTY(PUB_CPA)
   PUB_CPA = "101"
ENDIF
PUB_AGE    = M.AZI_AGE
IF EMPTY(PUB_AGE)
   PUB_AGE = "001"
ENDIF
PUB_VALU  = M.AZI_VALU
IF EMPTY(PUB_VALU)
   PUB_VALU = PUB_VALRIF
ENDIF
PUB_NAZI  = M.AZI_NAZI
IF EMPTY(PUB_NAZI)
   PUB_NAZI = "ITL"
ENDIF

PUB_CLISOC = AZI_CODCLI
PUB_RAGSOC = AZI_RAGSOC
PUB_FORMAR = AZI_FORMAR
PUB_LOCALI = ALLTRIM(AZI_LOCALI)   		&& SERGIO 10/08/2011

PUB_PIVA   = AZI_PIVA					&& SERGIO 29/04/2012
PUB_CODFIS = AZI_CODFIS					&& SERGIO 29/04/2012
PUB_LIBERA = AZI_LIBERA				    && SERGIO 29/04/2012
PUB_IVACEE = AZI_IVACEE					&& SERGIO 29/04/2012
PUB_TELEFO = AZI_TELEFO					&& SERGIO 29/04/2012
PUB_FAX    = AZI_FAX					&& SERGIO 29/04/2012
PUB_INDIRI = ALLTRIM(AZI_INDIRI)		&& SERGIO 29/04/2012


*=> PER CONVERSIONE A SQL-SERVER
PUB_MLDOCA = AZI_MLDOCA
PUB_MASTRO = AZI_MASTRO   && GRUPPO CONTABILITA GENERALE       + 1
PUB_SOTTOG = AZI_SOTTOG   && SOTTOGRUPPO CONTABILITA GENERALE  + 1
PUB_LCL    = AZI_CONTO    && CONTO CONTABILE
PUB_CONTO  = AZI_CONTO

IF PUB_MASTRO <> 0
   PUB_MASTRO = PUB_MASTRO + 1
ELSE
   PUB_MASTRO = 4
ENDIF
IF PUB_SOTTOG <> 0
   PUB_SOTTOG = PUB_SOTTOG + 1
ELSE
   PUB_SOTTOG = 6
ENDIF

** SERGIO 14/12/2004  INIZIO
*!*	IF PUB_LCL <> 0
*!*	   PUB_LCL = 14 - PUB_SOTTOG
*!*	ELSE
*!*	   PUB_LCL = 9
*!*	ENDIF
IF PUB_LCL = 0					&& valore già impostato e valido anche per i clienti/fornitori
   PUB_LCL = (14 - PUB_SOTTOG)
ENDIF
** SERGIO 14/12/2004  FINE

PUB_EAISBN = M.AZI_EAISBN

*=> TAGLIE/COLORI (MILLER)
PUB_CTRTAG = M.AZI_CTRTAG
PUB_CTRCOL = M.AZI_CTRCOL
PUB_CATACO = M.AZI_CATACO
PUB_ARTRES = M.AZI_ARTRES
PUB_CAURES = M.AZI_CAURIF
PUB_CAUREC = M.AZI_CAUREC
PUB_CAUREF = M.AZI_CAUREF
PUB_CAUCAS = M.AZI_CAUCAS
PUB_CODCAS = M.AZI_CODCAS
PUB_GESEDI = M.AZI_GESEDI
PUB_NUMLOT = M.AZI_NUMLOT
PUB_TIPCAS = M.AZI_TIPCAS
PUB_ARTABB = M.AZI_ARTABB
*==>  VARIABILI PER IDENTIFICARE IL FORNITORE
PUB_COSATRATTA 				= M.AZI_COSATRATTA
PUB_GRADOIMPORTANZA 		= M.AZI_GRADOIMPORTANZA
PUB_FORMAPAGAMENTO 			= M.AZI_FORMAPAGAMENTO
PUB_TIPOCONTRATTO 			= M.AZI_TIPOCONTRATTO
PUB_CONAQUISTO 				= M.AZI_CONAQUISTO	
PUB_PRIORITAPAGAMENTO 		= M.AZI_PRIPAGA	
*==>  VARIABILI PER GESTIONE ANNO CONTABILE NON SOLARE
PUB_NOSOL  = AZI_NOSOL
PUB_AACDAL = AZI_AACDAL
PUB_AACAL  = AZI_AACAL

*==>  VARIABILI PER GESTIONE ANNO CONTABILE PRECEDENTE NON SOLARE
PUB_AACDAL_P = gdata(alltrim(str(val(substr(ribalta2(PUB_AACDAL),1,4))-1))+SUBSTR(ribalta2(PUB_AACDAL),5,6))
PUB_AACAL_P  = gdata(alltrim(str(val(substr(ribalta2(PUB_AACAL),1,4))-1))+SUBSTR(ribalta2(PUB_AACAL),5,6))


IF PUB_NOSOL
ELSE
   PUB_AACDAL = SPACE(10)
   PUB_AACAL  = SPACE(10)
   PUB_AACDAL_P = SPACE(10)
   PUB_AACAL_P  = SPACE(10)
ENDIF

** SERGIO 05/03/2005  INIZIO
PUB_PAGAFOR = M.AZI_PAGAFOR
** SERGIO 05/03/2005  FINE

*SERGIO 04/04/2005 INIZIO
PUB_TRF   	= AZI_TRF
PUB_PAGANCR = AZI_PAGANCR
*SERGIO 04/04/2005 FINE

PUB_IMPEGN 	 	= AZI_IMPEGN  	&& ERASMO - 24/10/2012



**=_OPERAT(PUB_CODOPE)  && GESTIONE ABILITAZIONE FUNZIONI OPERATORE

*!*	  SERGIO INIZIO 07/08/2004
IF !ExecCommand("select * from u_azi_pa","u_azi_pa")
   return
ENDIF


SELECT u_azi_pa
GO TOP 
IF reccount() <> 0
ELSE
   WAIT WINDOW "Per cortesia codificare i parametri aziendali U_AZI_PA"
   RETURN
ENDIF

PUB_VMAGAZ   =  AZI_VMAGAZ
PUB_VARTIC   =  AZI_VARTIC
PUB_VMAGPE   =  AZI_VMAGPE
PUB_VMAGAR   =  AZI_VMAGAR
PUB_VMARPE   =  AZI_VMARPE
PUB_VFOMAR   =  AZI_VFOMAR
PUB_VFOMAP   =  AZI_VFOMAP
PUB_VFORNI   =  AZI_VFORNI
PUB_VMAGTC   =  AZI_VMAGTC
PUB_VMATCH   =  AZI_VMATCH 
PUB_VAMFTC   =  AZI_VAMFTC  
PUB_POLIEC   =  AZI_POLIEC
PUB_TOPINV   =  AZI_TOPINV
PUB_FISCALE  =  AZI_FISCALE

*** COMMENTATO - ERASMO - 06/08/2010
*!*	PUB_DATSYS   =  AZI_DATSYS
*!*	IF PUB_DATSYS   
*!*	  =caricadatedisistemaaquarius()
*!*	ENDIF

PUB_NOTCEE  =  AZI_NOTCEE
PUB_FATRC   =  AZI_FATRC
PUB_NOTRC   =  AZI_NOTRC
PUB_IVANAG  =  AZI_IVANAG
PUB_PRGPRD  = AZI_PRGPRD
PUB_SISCUR  = AZI_SISCUR
PUB_CODREC  = AZI_CODREC
PUB_LIS11   = AZI_LIS11
PUB_GGDTSP  = AZI_GGDTSP
PUB_STIPE   = AZI_STIPE
PUB_INCCLI  = AZI_INCCLI
PUB_EFFPAS  = AZI_EFFPAS
PUB_EFFATT  = AZI_EFFATT
PUB_CONTR   = AZI_CONTR
PUB_LEASIN  = AZI_LEASIN
PUB_FINAN   = AZI_FINAN
PUB_COMCLI  = AZI_COMCLI
PUB_COMFOR  = AZI_COMFOR
PUB_DARE    = AZI_DARE
PUB_AVERE   = AZI_AVERE
PUB_MOVLOG  = AZI_MOVLOG
PUB_ANTRIB  = AZI_ANTRIB
PUB_USATES = AZI_USATES 
PUB_NRSEBF = AZI_NRSEBF		
PUB_PROTFA = AZI_PROTFA    
PUB_AGGPRO = AZI_AGGPRO 
PUB_PROTCI = AZI_PROTCI 
PUB_NRSEBC = AZI_NRSEBC	
PUB_RRIFOR = AZI_RRIFOR
PUB_CCOSTD = AZI_CCOSTD		
PUB_CCOACLI = AZI_CCOACLI	
PUB_CCOAART = AZI_CCOAART	
PUB_CCOPDC = AZI_CCOPDC	
PUB_CCOCLI = AZI_CCOCLI		
PUB_CCOFOR = AZI_CCOFOR		
PUB_CCOSTD = AZI_CCOSTD		
PUB_MAGNO0 = AZI_MAGNO0		
PUB_TOPCAM = AZI_TOPCAM		
PUB_BENDUR = AZI_BENDUR		&& PROJECT 04/08/2006

PUB_FATRIA = AZI_FATRIA     && SERGIO 01/04/2007
PUB_NUCOCG = AZI_NUCOCG		&& SERGIO 01/04/2007
PUB_NUCOAQ = AZI_NUCOAQ		&& SERGIO 01/04/2007
PUB_NUCOAS = AZI_NUCOAS		&& SERGIO 01/04/2007
PUB_NUCOOK = AZI_NUCOOK		&& SERGIO 01/04/2007
PUB_CLIRIC = AZI_CLIRIC		&& ERASMO 13/04/2007
PUB_CARFOR = AZI_CARFOR		&& SERGIO 15/04/2007
PUB_SDBSIG = AZI_SDBSIG     && SERGIO 01/07/2007
PUB_SDBNOG = AZI_SDBNOG     && SERGIO 01/07/2007
PUB_CDBSIG = AZI_CDBSIG     && SERGIO 01/07/2007
PUB_CDBNOG = AZI_CDBNOG     && SERGIO 01/07/2007
PUB_IDSOCI = AZI_IDSOCI 	&& SERGIO 14/10/2007
PUB_CEEUNO = AZI_CEEUNO 	&& SERGIO 14/01/2008

PUB_PRENOT = AZI_PRENOT 	&& ERASMO 12/05/2008

PUB_ORDINT = AZI_ORDINT 	&& FABIANO 02/06/2008
PUB_FABBIS = AZI_FABBIS	    && FABIANO 02/06/2008

PUB_PRSSTD  = AZI_PRSSTD   	&& SERGIO 02/08/2008
PUB_PRDFILM = AZI_PRDFILM	&& SERGIO 02/08/2008
PUB_PRMMOL  = AZI_PRMMOL	&& SERGIO 02/08/2008
PUB_PRTTES  = AZI_PRTTES	&& SERGIO 02/08/2008
PUB_ECORIS  = AZI_ECORIS	&& SERGIO 19/08/2008
PUB_SPASCA  = AZI_SPASCA	&& SIMONE - 25/02/2009
PUB_LOGBOL  = AZI_LOGBOL	&& ERASMO - 02/11/2009
PUB_TAGAGE  = AZI_TAGAGE	&& ERASMO - 06/08/2010
PUB_CAUMOV  = AZI_CAUMOV	&& ERASMO - 17/09/2010


PUB_DESKTOP = AZI_DESKTOP   && SERGIO 26/08/2010	
PUB_PASS  	= AZI_PASS  	&& SERGIO 26/08/2010
PUB_PASS_SW	= AZI_PASS_SW	&& SERGIO 26/08/2010
PUB_SCRIT_B	= AZI_SCRIT_B	&& SERGIO 26/08/2010
PUB_SCRIT_N	= AZI_SCRIT_N	&& SERGIO 26/08/2010 
PUB_SCRIT_R	= AZI_SCRIT_R	&& SERGIO 26/08/2010
PUB_AQUAR   = AZI_AQUAR   	&& SERGIO 26/08/2010
PUB_PASS_B  = AZI_PASS_B  	&& SERGIO 26/08/2010
PUB_PASS_N  = AZI_PASS_N 	&& SERGIO 26/08/2010
PUB_PASS_R  = AZI_PASS_R 	&& SERGIO 26/08/2010
PUB_SUBMEN  = AZI_SUBMEN 	&& SERGIO 26/08/2010
PUB_SCRIT   = AZI_SCRIT   	&& SERGIO 26/08/2010
PUB_PRORATA = AZI_PRORATA	&& SERGIO 25/11/2010
PUB_CGMAGA  = AZI_CGMAGA	&& ERASMO - 28/12/2010
PUB_VERSRA  = AZI_VERSRA	&& SERGIO 13/01/2011 INIZIO
PUB_NOQUAD  = AZI_NOQUAD	&& SERGIO 01/02/2011
PUB_FATSTU  = AZI_FATSTU	&& ERASMO - 03/02/2011
PUB_NRSENO  = AZI_NRSENO	&& SIMONE - 07/03/2011
PUB_PROTNO  = AZI_PROTNO	&& SIMONE - 07/03/2011    
PUB_INSBFO  = AZI_INSBFO	&& ERASMO - 27/04/2011
PUB_MPIU    = AZI_MPIU		&& SERGIO - 05/05/2011
PUB_MMEN    = AZI_MMEN		&& SERGIO - 05/05/2011
PUB_ZTLSHW  = AZI_ZTLSHW	&& ERASMO - 18/05/2011
PUB_BFP     = AZI_BFP		&& SERGIO - 23/08/2011
PUB_MAXRDA = AZI_MAXRDA 	&& ERASMO - 02/09/2011 
PUB_MACINA = AZI_MACINA 	&& ERASMO - 02/09/2011
PUB_PRESSA = AZI_PRESSA 	&& ERASMO - 02/09/2011 
PUB_TAGLIO = AZI_TAGLIO 	&& ERASMO - 02/09/2011 
PUB_LEVIGA = AZI_LEVIGA 	&& ERASMO - 02/09/2011 
PUB_NOBILI = AZI_NOBILI 	&& ERASMO - 02/09/2011 
PUB_PROFIN = AZI_PROFIN 	&& ERASMO - 02/09/2011 
PUB_TFATT  = AZI_TFATT	    && SERGIO - 25/09/2011 
PUB_PRGPLET = AZI_PRGPLET   && SERGIO - 16/10/2011 
PUB_CBI     = AZI_CBI       && FABIANO - 27/11/2011 
PUB_ARRNID = AZI_ARRNID     && ERASMO - 29/11/2011 
PUB_LIS12  = AZI_LIS12      && SERGIO - 08/12/2011 
PUB_LIS13  = AZI_LIS13      && SERGIO - 08/12/2011 
PUB_LIS14  = AZI_LIS14      && SERGIO - 08/13/2011 
PUB_TOPTRI = AZI_TOPTRI		&& FABIANO - 23/12/2011
PUB_TOPPNC = AZI_TOPPNC		&& FABIANO - 23/12/2011
PUB_GGRIBA = AZI_GGRIBA		&& FABIANO - 30/12/2011
PUB_YESLOGBOL  	= AZI_YESLOGBOL	&& ERASMO - 19/01/2012
PUB_DOGCOM  	= AZI_DOGCOM  	&& ERASMO - 19/01/2012
PUB_NOPOSTI     = AZI_NOPOSTI   && SERGIO - 18/02/2012
PUB_TRATTA     	= AZI_TRATTA    && FABIANO - 22/03/2012
PUB_NBOREF     	= AZI_NBOREF    && SERGIO - 03/06/2012
PUB_LEVIGA1 	= AZI_LEVIGA1 	&& ERASMO - 28/06/2012 
PUB_LEVIGA2 	= AZI_LEVIGA2 	&& ERASMO - 28/06/2012
PUB_LEVIGA3 	= AZI_LEVIGA3 	&& ERASMO - 28/06/2012
PUB_LIFSCO  	= AZI_LIFSCO    && SERGIO - 09/07/2012
PUB_CAUVBA  	= AZI_CAUVBA	&& SERGIO - 13/07/2012
PUB_CLIMAG  	= AZI_CLIMAG	&& SERGIO - 15/07/2012
PUB_SCAPPT  	= AZI_SCAPPT	&& SERGIO - 18/08/2012
PUB_CAIPPT  	= AZI_CAIPPT	&& SERGIO - 20/08/2012
PUB_ARTPRE	 	= AZI_ARTPRE 	&& ERASMO - 27/08/2012
PUB_GIANEG      = AZI_GIANEG	&& SERGIO - 05/09/2012
PUB_CAUGNE		= AZI_CAUGNE	&& SERGIO - 16/09/2012 
PUB_CAPAGL		= AZI_CAPAGL	&& SERGIO - 16/09/2012 
PUB_CAUSMP 		= AZI_CAUSMP	&& SERGIO - 16/09/2012 
PUB_CAURIM 		= AZI_CAURIM 	&& SERGIO - 16/09/2012
PUB_CAUSPR 		= AZI_CAUSPR 	&& SERGIO - 16/09/2012
PUB_ARTSPR 		= AZI_ARTSPR 	&& SERGIO - 16/09/2012
PUB_CAUCAL 		= AZI_CAUCAL 	&& SERGIO - 16/09/2012
PUB_CAUSCL 		= AZI_CAUSCL 	&& SERGIO - 16/09/2012
PUB_CACARI 		= AZI_CACARI 	&& SERGIO - 16/09/2012
PUB_CASCRI 		= AZI_CASCRI 	&& SERGIO - 16/09/2012
PUB_CACATA 		= AZI_CACATA 	&& SERGIO - 16/09/2012
PUB_CASCTA 		= AZI_CASCTA 	&& SERGIO - 16/09/2012
PUB_CACART 		= AZI_CACART 	&& SERGIO - 16/09/2012
PUB_CASCRT 		= AZI_CASCRT 	&& SERGIO - 16/09/2012
PUB_CASCLE 		= AZI_CASCLE 	&& SERGIO - 16/09/2012
PUB_ARTSLE 		= AZI_ARTSLE 	&& SERGIO - 16/09/2012
PUB_CAPRNO 		= AZI_CAPRNO 	&& SERGIO - 16/09/2012
PUB_SCPRNO 		= AZI_SCPRNO 	&& SERGIO - 16/09/2012
PUB_CASCNO 		= AZI_CASCNO 	&& SERGIO - 16/09/2012
PUB_ARTSNO 		= AZI_ARTSNO 	&& SERGIO - 16/09/2012
PUB_LCKPRE	 	= AZI_LCKPRE 	&& ERASMO - 26/09/2012
PUB_LCKLEV	 	= AZI_LCKLEV 	&& ERASMO - 26/09/2012
PUB_LCKNOB	 	= AZI_LCKNOB 	&& ERASMO - 26/09/2012
PUB_GGCONS 	 	= AZI_GGCONS  	&& ERASMO - 10/10/2012
PUB_FLGPCO 	 	= AZI_FLGPCO  	&& ERASMO - 25/10/2012
PUB_NODBPN 	 	= AZI_NODBPN  	&& ERASMO - 06/11/2012
PUB_CDAPRD 		= AZI_CDAPRD		&& ERASMO - 13/12/2012
PUB_MSGORDNODB 	= AZI_MSGORDNODB	&& ERASMO - 13/12/2012
PUB_LCKORDNODB 	= AZI_LCKORDNODB	&& ERASMO - 13/12/2012
PUB_IVAXCA      = AZI_IVAXCA    && SERGIO - 03/01/2013
PUB_SAUFOR 	 	= AZI_SAUFOR  	&& ERASMO - 29/01/2013
PUB_PRZDIB 		= AZI_PRZDIB 	&& SERGIO - 30/01/2013
PUB_LOGSQL 	 	= AZI_LOGSQL  	&& ERASMO - 12/02/2013
PUB_CESCOM	 	= AZI_CESCOM	&& SERGIO - 22/02/2013
PUB_DOGBOL	 	= AZI_DOGBOL	&& ERASMO - 25/02/2013
PUB_DOGART	 	= AZI_DOGART	&& ERASMO - 25/02/2013
PUB_OPZRSK	 	= AZI_OPZRSK	&& ERASMO - 07/03/2013
PUB_PKRSTA	 	= AZI_PKRSTA	&& ERASMO - 07/03/2013
PUB_BOLIVA1	 	= AZI_BOLIVA1	&& SERGIO - 08/03/2013
PUB_DDTQTADOPPIE = AZI_DDTQTADOPPIE && FABIANO - 09/03/2013
PUB_PKREML 	 	= AZI_PKREML	&& ERASMO - 14/03/2013
PUB_NOSALDI	 	= AZI_NOSALDI	&& SERGIO - 20/03/2013
PUB_PKAUPE 	 	= AZI_PKAUPE	&& ERASMO - 22/03/2013
PUB_DDTLCK 	 	= AZI_DDTLCK	&& ERASMO - 22/03/2013
PUB_PKNCAU 	 	= AZI_PKNCAU	&& ERASMO - 25/03/2013

PUB_FATIDR      = AZI_FATIDR	&& SERGIO - 06/04/2013
PUB_PERIDR		= AZI_PERIDR	&& SERGIO - 06/04/2013

PUB_PGGCLS 	 	= AZI_PGGCLS	&& ERASMO - 14/05/2013

SELECT &SS

RETURN(.T.)






***************************************
FUNCTION DETERMINA_ALIQUOTA_IVA_DEFAULT
***************************************
SS=STR(SELECT())

PUB_PERCENTUALE_IVA_DEFAULT  = 21
IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(PUB_IVA) + "'","cx_iva_para")
   return
ENDIF

SELECT cx_iva_para
IF reccount() <> 0
   cxxALIQ = SUBSTR(LIBERA,1,3)
   PUB_PERCENTUALE_IVA_DEFAULT = VAL(cxxALIQ)
ENDIF

IF PUB_PERCENTUALE_IVA_DEFAULT = 0			&& SE NON TROVATO PARAMETRO
	PUB_PERCENTUALE_IVA_DEFAULT = 21
ENDIF

SELECT &SS


RETURN

***************************
FUNCTION RICERCA_DESMAGPROD
***************************

*=> Ricerca la descrizione del magazzino in fase di carico con documenti del fornitore
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CARORF) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CARORF = SPACE(50)
ELSE
   DES_CARORF = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi della M.P. con prodotto risultato conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUMPC) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUMPC = SPACE(50)
ELSE
   DES_CQUMPC = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi della M.P. con prodotto risultato NON conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUMPN) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUMPN = SPACE(50)
ELSE
   DES_CQUMPN = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino della produzione spalmatura
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPAPRO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPAPRO = SPACE(50)
ELSE
   DES_SPAPRO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il reso della M.P. non spalmata
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPAMPR) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPAMPR = SPACE(50)
ELSE
   DES_SPAMPR = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il film spalmato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPACQS) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPACQS = SPACE(50)
ELSE
   DES_SPACQS = DESCRI
ENDIF

*** SIMONE - 25/02/2009
*=> Ricerca la descrizione del magazzino per il film spalmato
*!*	x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPASCA) + "'"
*!*	cSql   = "select * from para where " + x_cond
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   RETURN
*!*	ENDIF
*!*	IF EOF()
*!*	   DES_SPASCA = SPACE(50)
*!*	ELSE
*!*	   DES_SPASCA = DESCRI
*!*	ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi del S.L. con prodotto risultato conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUSLC) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUSLC = SPACE(50)
ELSE
   DES_CQUSLC = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi del S.L. con prodotto NON risultato conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUSLN) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUSLN = SPACE(50)
ELSE
   DES_CQUSLN = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per la produzione della ribobinatura
x_cond = "codice = 'MAG" + ALLTRIM(PUB_RIBPRO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_RIBPRO = SPACE(50)
ELSE
   DES_RIBPRO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il reso del S.L. non ribobinato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_RIBSLR) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_RIBSLR = SPACE(50)
ELSE
   DES_RIBSLR = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il film ribobinato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_RIBSLO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_RIBSLO = SPACE(50)
ELSE
   DES_RIBSLO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per la produzione del taglio
x_cond = "codice = 'MAG" + ALLTRIM(PUB_TAGPRO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_TAGPRO = SPACE(50)
ELSE
   DES_TAGPRO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il reso del S.L. non tagliato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_TAGSLR) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_TAGSLR = SPACE(50)
ELSE
   DES_TAGSLR = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il film tagliato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_TAGPFO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_TAGPFO = SPACE(50)
ELSE
   DES_TAGPFO = DESCRI
ENDIF

RETURN(.T.)


* SERGIO INIZIO 07/08/2004
**********************************************************************
* -->> FUNZIONE CHE IDENTIFICA SE LA DATA IN OGGETTO E' RIBALTATA
* -->> IN QUESTO CASO LA RIPORTA IN FORMATO GG/MM/AAAA
**********************************************************************
FUNCTION GDATA  
**********************************************************************
PARA _DATA

OUT=_DATA

IF SUBSTR(_DATA,5,1)="/"
  OUT=RIBALTA2(_DATA)
ENDIF  

RETURN(OUT)

*********************************************************************************************
* SEEK_CONTI()	funzione per la gestione della tabella CONTI
*********************************************************************************************
* La funzione restituisce dalla tabella CONTI, il parametro che corrisponde ai criteri 
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
FUNCTION seek_conti
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_CONTI"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+ALLTRIM(SUBSTR(_chiave,7))+"'"
_seek1= "'"+ALLTRIM(SUBSTR(_chiave,7))+"%'"

CSQL_JOIN="SELECT TOP 100 COALESCE(CLI.CLI_PARIVA,FFO.FOR_PARIVA,'') AS PARIVA,CON.* "+;
	" FROM CONTI AS CON "+;
	" LEFT OUTER JOIN (SELECT CLI_CODCLI,CLI_PARIVA FROM U_CLI_AN ) AS CLI ON CON.CON_CONTO  LIKE '%'+RTRIM(CLI.CLI_CODCLI) AND CON.CON_TIPOCO='C' "+;
	" LEFT OUTER JOIN (SELECT FOR_CODCLI,FOR_PARIVA FROM U_FOR_AN ) AS FFO ON CON.CON_CONTO  LIKE '%'+RTRIM(FFO.FOR_CODCLI) AND CON.CON_TIPOCO='F' "

cSql     = CSQL_JOIN+;
			"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' and "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1   = CSQL_JOIN+;
			"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' and ( "+_ordinamento+" like "+_seek1+" ) order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione conto contabile;P.IVA"
PUB_VISTA  = "con_conto;con_descr;PARIVA"
PUB_RIT    = _ritorno
___dimensioni= "120;510;120"

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco conti contabili",___dimensioni

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_u_art_pr()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
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
*FUNCTION seek_u_art_pr
*PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
*IF PARAMETERS() < 6
*   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
*   return("")
*ENDIF 
*
*IF EMPTY(_lunghezza)
*   _lunghezza="1"
*ENDIF
*
*IF EMPTY(_nomecursore)
*   _nomecursore="_pj_u_art_pr"
*ENDIF
*
*_ret_valore=""
*
*_pjlib_sele=SELECT()
*
*IF SUBSTR(_nomecursore,1,5) = 'ECASH'
*   IF LEN(ALLTRIM(_chiave)) > 2
*   ELSE
*      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
*      IF !ExecCommand(cSql,_nomecursore)
*         return(.f.)
*      ENDIF
*      V_TESTO = "Bisogna digitare almeno 3 caratteri per iniziare la ricerca"
*      V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
*      &V_FORM
*      SELECT(_pjlib_sele)
*      _ret_valore=""
*      return(_ret_valore)
*   ENDIF
*ELSE
*   IF LEN(ALLTRIM(_chiave)) > 2
*   ELSE
*      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
*      IF !ExecCommand(cSql,_nomecursore)
*         return(.f.)
*      ENDIF
*      PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 3 caratteri per iniziare la ricerca',64,'*** ATTENZIONE ***')
*      SELECT(_pjlib_sele)
*      _ret_valore=""
*      return(_ret_valore)
*   ENDIF
*ENDIF
*
*_seek = "'"+_chiave+"'"
*_seek1= "'"+_chiave+"%'"
*cSql 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
*cSql_1 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" like "+_seek1+" order by "+_ordinamento
*	
*PUB_SELECT = _nomecursore
*PUB_SEEK   = cSql+";"+cSql_1
*PUB_TESTA  = "Codice;Descrizione"
*PUB_VISTA  = "art_codpri;art_descr"
*PUB_RIT    = _ritorno
*
*IF SUBSTR(_nomecursore,1,5) = 'ECASH'
*   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
*ELSE
*   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
*ENDIF
*
*STORE PUB_RIT TO _ret_valore
*
*SELECT(_pjlib_sele)
*
*return(_ret_valore)


*********************************************************************************************
* SEEK_u_art_pr()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
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
FUNCTION seek_u_art_pr
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   IF LEN(ALLTRIM(_chiave)) > 2
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      V_TESTO = "Bisogna digitare almeno 3 caratteri per iniziare la ricerca"
      V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
      &V_FORM
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ELSE
   IF LEN(ALLTRIM(_chiave)) > 0
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 1 carattere per iniziare la ricerca',64,'*** ATTENZIONE ***')
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ENDIF

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
**=> ERASMO - INIZIO 29/12/2010
_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
_seek1= "'"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
**=> ERASMO - FINE 29/12/2010

* -->> query per procedura elenco standard (form elenco)
* ----------------------------------------------------------------
cSql 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" like "+_seek1+" order by "+_ordinamento
	

* -->> query per procedura elenco con paginazione (form elenco_pg)
* ----------------------------------------------------------------------

* -->> parametri per prima query
* ----------------------------------
j_ii_tabella_10 = "u_art_pr"
j_ii_cond_10	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_11	= " and " +_ordinamento+" = "+_seek
j_ii_cond_12	= " and 1=1"
j_ii_cond_13	= " and 1=1"
j_ii_ordine_10	= _ordinamento

* -->> parametri per seconda query
* ----------------------------------
j_ii_tabella_20	= "u_art_pr"
j_ii_cond_20	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_21	= " and " +_ordinamento+" like "+_seek1
j_ii_cond_22	= " and 1=1"
j_ii_cond_23	= " and 1=1"
j_ii_ordine_20	= _ordinamento


cSql_pg 	= j_ii_tabella_10+":"+j_ii_cond_10+":"+j_ii_cond_11+":"+j_ii_cond_12+":"+j_ii_cond_13+":"+j_ii_ordine_10
cSql_1_pg 	= j_ii_tabella_20+":"+j_ii_cond_20+":"+j_ii_cond_21+":"+j_ii_cond_22+":"+j_ii_cond_23+":"+j_ii_ordine_20


PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1

* -->> nuova variabile con le query x elenco con paginazione
* -----------------------------------------------------------------
PUB_SEEK_PG= cSql_pg+";"+cSql_1_pg
* -----------------------------------------------------------------

PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
*   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
   DO Form FORM\ELENCO_PG WITH pub_select,pub_seek_pg,pub_testa,pub_vista,pub_rit,"Elenco articoli"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)




************************************************************************
* Procedura - ZERRORE
************************************************************************
* Procedura tappo per gestione evento VALID
PROCEDURE ZERRORE
RETURN


**************************************************************************
* Procedura - OPENDB                    Data: 10.11.95   Autore: Project
**************************************************************************
* Procedura da utilizzare per aprire un DB
*
**************************************************************************
PROCEDURE OPENDB
*****************

PARA V1

IF !USED(V1)
   USE &V1 IN 0 AGAIN
ENDIF

SELECT &V1
SET FILTER TO
SET ORDER TO
GO TOP
RETURN