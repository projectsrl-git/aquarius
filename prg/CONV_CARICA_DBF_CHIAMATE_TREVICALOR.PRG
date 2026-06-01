*************************************************************************************************
*			CARICAMENTO RICHIESTE INTERVENTO TREVICALOR DA PIANIFICAZIONE LAVORI                *
*							 																	*
*	Gennaio 2024 :Trevicalor 			 														*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR

__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
PERCORSO_TREVICALOR=legge_config(__config_name,"PERCORSO_ASTERDAT")						&& RICERCA VARIABILE
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR

RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLE TABELLE RICHIESTE INTERVENTO DA PIANIFICAZIONE LAVORI NON CONSOLIDATE (LAVORI) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   SET DEFAULT TO &PUB_DIR
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF

*** CANCELLAZIONE TABELLE INTERVENTI
WAIT WINDOWS "Cancellazione RICHIESTE INTERVENTI ...  -  Prego Attendere" NOWAIT

cSql = "truncate table IMPIANTI_RI" 
IF !ExecCommand(cSql,"IMPIANTI_RI")
   return(.f.)
ENDIF

cSql = "UPDATE para SET LIBERA = '0' where CODICE LIKE 'NUMRIC%'"
IF !ExecCommand(cSql,"UPD_PARA")
   return(.f.)
ENDIF


_V_PERCORSO = PERCORSO_TREVICALOR

SET EXCLUSIVE ON

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("LAVORI")
SELECT LAVORI
INDEX ON ALLTRIM(ID_LAVORI)  TAG ID_LAVORI ADDITIVE
SET ORDER TO ID_LAVORI
GO TOP

=OPENDB("LAVORI_PRESTAZIONI")
SELECT LAVORI_PRESTAZIONI
INDEX ON ALLTRIM(ID_LAVORI)  TAG ID_LAVORI ADDITIVE
SET ORDER TO ID_LAVORI
GO TOP

*!*	=OPENDB("SCHEDETEST")
*!*	SELECT SCHEDETEST
*!*	INDEX ON ALLTRIM(CCODSCHE)  TAG ID_CODSC  ADDITIVE
*!*	SET ORDER TO ID_CODSC  
*!*	GO TOP



_CONTA_INT = 0
SET DEFAULT TO &PUB_DIR


RELEASE M.ORD_CODRIC,M.ORD_CLOSE,M.ORD_CCODSCHE,M.ORD_ZONA,M.ORD_CODCLI,M.ORD_RAGSOC,M.ORD_RAGDUE,M.ORD_PARIVA,M.ORD_INDIRI,M.ORD_LOCALI,M.ORD_CAP,M.ORD_PROVIN,M.ORD_TELEFO,M.ORD_CELLU,M.ORD_DATA,M.ORD_DATREG,M.ORD_ORAREG, ;
	M.ORD_NOTERIC,M.ORD_SYSRINT,M.ORD_APECLO,M.TNUMERO
PUBLIC M.ORD_CODRIC,M.ORD_CLOSE,M.ORD_CCODSCHE,M.ORD_ZONA,M.ORD_CODCLI,M.ORD_RAGSOC,M.ORD_RAGDUE,M.ORD_PARIVA,M.ORD_INDIRI,M.ORD_LOCALI,M.ORD_CAP,M.ORD_PROVIN,M.ORD_TELEFO,M.ORD_CELLU,M.ORD_DATA,M.ORD_DATREG,M.ORD_ORAREG, ;
	M.ORD_NOTERIC,M.ORD_SYSRINT,M.ORD_APECLO,M.TNUMERO

M.ORD_CODRIC = ""
M.ORD_CLOSE = .F.
M.ORD_CCODSCHE = ""
M.ORD_ZONA = ""
M.ORD_CODCLI = ""
M.ORD_RAGSOC = ""
M.ORD_RAGDUE = ""
M.ORD_PARIVA = ""
M.ORD_INDIRI = ""
M.ORD_LOCALI = ""
M.ORD_CAP = ""
M.ORD_PROVIN = ""
M.ORD_TELEFO = ""
M.ORD_CELLU = ""
M.ORD_DATA = ""
M.ORD_DATREG = ""
M.ORD_ORAREG = ""
M.ORD_NOTERIC = ""
M.ORD_SYSRINT = ""
M.ORD_APECLO = ""
M.TNUMERO = ""

SELECT * FROM LAVORI WHERE CTIPOREC <> '4' AND ID_LAVORI NOT IN (SELECT ID_LAVORI FROM LAVORI_PRESTAZIONI) INTO CURSOR CU_LAVORI
SELECT CU_LAVORI
INDEX ON ALLTRIM(ID_LAVORI) TAG ID_LAVORI ADDITIVE
SET ORDER TO ID_LAVORI
SET FILTER TO RIBALTA2(DTOC(CDATINT)) >= "2022/01/01"
GO TOP

_CONTA_TOT = 0
GO TOP
SCAN
	_CONTA_TOT = _CONTA_TOT + 1
ENDSCAN
GO TOP

DO WHILE .NOT. EOF()

	SCATTER MEMVAR MEMO

	M.CCODSCHE = CONV_CLEAR(APITOSPA(M.CCODSCHE))
	
	_AGGANCIO_ASTER 	= ALLTRIM(M.ID_LAVORI)
	_AGGANCIO_AQUARIUS  = SYS(2015)
	
	_CONTA_INT = _CONTA_INT + 1
	WAIT WINDOWS "Richiesta Intervento elaborata: " + _AGGANCIO_ASTER + " (" + ALLTRIM(STR(_CONTA_INT,10,0)) + " di " + ALLTRIM(STR(_CONTA_TOT)) + ")" NOWAIT

	IF !CARICA_IMPIANTI_RI(_AGGANCIO_AQUARIUS,_AGGANCIO_ASTER)
		SELECT CU_LAVORI
		SKIP + 1	
	    LOOP
	ENDIF
	
*!*		**################
*!*		IF _CONTA_INT > 100
*!*			EXIT
*!*		ENDIF
*!*		**################
	
	
	SELECT CU_LAVORI
	SKIP + 1

ENDDO 


SET EXCLUSIVE OFF

IF USED("LAVORI")
	SELECT LAVORI
	USE
ENDIF
IF USED("LAVORI_PRESTAZIONI")
	SELECT LAVORI_PRESTAZIONI
	USE
ENDIF

IF USED("CU_LAVORI")
	SELECT CU_LAVORI
	USE
ENDIF

WAIT WINDOWS "Numero richieste intervento caricate: " + STR(_CONTA_INT,5,0)

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


**************************************************************************
FUNCTION CARICA_IMPIANTI_RI
**************************************************************************
LPARAMETERS _AGGANCIO_AQUARIUS,_AGGANCIO_ASTER

_SXXS = SELECT()

*!*	Structure for table:                   D:\TREVICALOR\ASTERDAT\LAVORI.DBF
*!*	Number of data records:       14828   
*!*	Date of last update:           04/01/2024
*!*	Memo file block size:         64
*!*	 Code Page:                   1252    
*!*	                Field        Field Name                                                            Type                                                                                                   Width                           Dec                   Index   Collate                                            Nulls                               Next                               Step
*!*	                    1        ID_LAVORI                                                             Character                                                                                                 10                                                   Asc   Machine                                               No
*!*	                    2        CTIPOREC                                                              Character                                                                                                  1                                                                                                               No
*!*	                    3        CSETTORE                                                              Character                                                                                                  2                                                                                                               No
*!*	                    4        CCODSCHE                                                              Character                                                                                                 20                                                   Asc   Machine                                               No
*!*	                    5        ID_PMCONTR                                                            Character                                                                                                 10                                                                                                               No
*!*	                    6        ID_PMKEY                                                              Character                                                                                                 10                                                                                                               No
*!*	                    7        ID_RIGO                                                               Character                                                                                                  5                                                                                                               No
*!*	                    8        CZONAINS                                                              Character                                                                                                  5                                                                                                               No
*!*	                    9        CCAPINS                                                               Character                                                                                                  5                                                                                                               No
*!*	                   10        CCODCLI                                                               Character                                                                                                  8                                                                                                               No
*!*	                   11        CDATINT                                                               Date                                                                                                       8                                                                                                               No
*!*	                   12        CDATLAV                                                               Date                                                                                                       8                                                                                                               No
*!*	                   13        CDATINGIUL                                                            Character                                                                                                  6                                                                                                               No
*!*	                   14        CNUMINT                                                               Numeric                                                                                                    7                             2                                                                                 No
*!*	                   15        CCODTEC                                                               Character                                                                                                  3                                                                                                               No
*!*	                   16        CCODTEC1                                                              Character                                                                                                  3                                                                                                               No
*!*	                   17        CCODTEC2                                                              Character                                                                                                  3                                                                                                               No
*!*	                   18        CCODTEC3                                                              Character                                                                                                  3                                                                                                               No
*!*	                   19        CCODTEC4                                                              Character                                                                                                  3                                                                                                               No
*!*	                   20        CCODTEC5                                                              Character                                                                                                  3                                                                                                               No
*!*	                   21        CCODTEC6                                                              Character                                                                                                  3                                                                                                               No
*!*	                   22        CCODTEC7                                                              Character                                                                                                  3                                                                                                               No
*!*	                   23        CCODTEC8                                                              Character                                                                                                  3                                                                                                               No
*!*	                   24        CCODTEC9                                                              Character                                                                                                  3                                                                                                               No
*!*	                   25        CCODPRE                                                               Character                                                                                                  3                                                                                                               No
*!*	                   26        CQTA                                                                  Numeric                                                                                                    2                                                                                                               No
*!*	                   27        DURATA_HH                                                             Numeric                                                                                                    2                                                                                                               No
*!*	                   28        DURATA_MN                                                             Numeric                                                                                                    2                                                                                                               No
*!*	                   29        CHH11                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   30        CMN11                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   31        CHH12                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   32        CMN12                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   33        CHH13                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   34        CMN13                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   35        CHH14                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   36        CMN14                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   37        CHH21                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   38        CMN21                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   39        CHH22                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   40        CMN22                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   41        CHH23                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   42        CMN23                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   43        CHH24                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   44        CMN24                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   45        CHH31                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   46        CMN31                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   47        CHH32                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   48        CMN32                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   49        CHH33                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   50        CMN33                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   51        CHH34                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   52        CMN34                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   53        CTOTHH1                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   54        CTOTMN1                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   55        CTOTHH2                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   56        CTOTMN2                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   57        CTOTHH3                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   58        CTOTMN3                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   59        CIMPHH1                                                               Numeric                                                                                                   10                                                                                                               No
*!*	                   60        CIMPHH2                                                               Numeric                                                                                                   10                                                                                                               No
*!*	                   61        CIMPHH3                                                               Numeric                                                                                                   10                                                                                                               No
*!*	                   62        CIVAORE                                                               Character                                                                                                  3                                                                                                               No
*!*	                   63        CIMPPRE                                                               Numeric                                                                                                   10                                                                                                               No
*!*	                   64        CIVAPRE                                                               Character                                                                                                  3                                                                                                               No
*!*	                   65        CRICFIS                                                               Character                                                                                                 10                                                                                                               No
*!*	                   66        CRAPLAV                                                               Character                                                                                                 10                                                                                                               No
*!*	                   67        CCODTAR                                                               Character                                                                                                  3                                                                                                               No
*!*	                   68        CFLAGFAT                                                              Character                                                                                                  1                                                                                                               No
*!*	                   69        CFLAGCORR                                                             Character                                                                                                  1                                                                                                               No
*!*	                   70        CFLAGINIZ                                                             Character                                                                                                  1                                                                                                               No
*!*	                   71        CFLAGESE                                                              Character                                                                                                  1                                                                                                               No
*!*	                   72        CDESPRE                                                               Character                                                                                                 30                                                                                                               No
*!*	                   73        CCONVEN                                                               Character                                                                                                  8                                                                                                               No
*!*	                   74        CCONTRATTO                                                            Character                                                                                                  3                                                                                                               No
*!*	                   75        CNATOPE                                                               Character                                                                                                  2                                                                                                               No
*!*	                   76        CNOTE1                                                                Character                                                                                                 60                                                                                                               No
*!*	                   77        CNOTE2                                                                Character                                                                                                 60                                                                                                               No
*!*	                   78        CNOTE3                                                                Character                                                                                                 60                                                                                                               No
*!*	                   79        CNOTE                                                                 Memo                                                                                                       4                                                                                                               No
*!*	                   80        CCODPAG                                                               Character                                                                                                  3                                                                                                               No
*!*	                   81        CNOFA1                                                                Character                                                                                                 35                                                                                                               No
*!*	                   82        CNOFA2                                                                Character                                                                                                 35                                                                                                               No
*!*	                   83        CNOFA3                                                                Character                                                                                                 35                                                                                                               No
*!*	                   84        CNOFA4                                                                Character                                                                                                 35                                                                                                               No
*!*	                   85        CNOFA5                                                                Character                                                                                                 35                                                                                                               No
*!*	                   86        CNOFA6                                                                Character                                                                                                 35                                                                                                               No
*!*	                   87        CNOFA7                                                                Character                                                                                                 35                                                                                                               No
*!*	                   88        CNOFA8                                                                Character                                                                                                 35                                                                                                               No
*!*	                   89        CNOFA9                                                                Character                                                                                                 35                                                                                                               No
*!*	                   90        CURGENTE                                                              Logical                                                                                                    1                                                                                                               No
*!*	                   91        CRICFISRIG                                                            Character                                                                                                  3                                                                                                               No
*!*	                   92        CONCORDATO                                                            Logical                                                                                                    1                                                                                                               No
*!*	                   93        USER_RICH                                                             Character                                                                                                 20                                                                                                               No
*!*	                   94        USER_LAV                                                              Character                                                                                                 20                                                                                                               No
*!*	                   95        FLAG_PROGR                                                            Logical                                                                                                    1                                                                                                               No
*!*	                   96        FLAG_AGEND                                                            Logical                                                                                                    1                                                                                                               No
*!*	                   97        TIPO_STAG                                                             Character                                                                                                  3                                                                                                               No
*!*	                   98        STAG_DAL_AA                                                           Character                                                                                                  4                                                                                                               No
*!*	                   99        STAG_AL_AA                                                            Character                                                                                                  4                                                                                                               No
*!*	                  100        ID_ESERCIZIO..                                                        Character                                                                                                 11                                                                                                               No
*!*	                  101        FLAG_PALMARE                                                          Logical                                                                                                    1                                                                                                               No
*!*	                  102        FLAG_ABBINAT..                                                        Integer                                                                                                    4                                                                                                               No
*!*	                  103        ID_MOV_ABBIN                                                          Character                                                                                                 10                                                                                                               No
*!*	                  104        UPD_ID_PMCON..                                                        Integer                                                                                                    4                                                                                                               No
*!*	** Total **                                                                                                                                                                                                 911

**==> CREAZIONE TABELLA TESTATA RICHIESTA INTERVENTO

M.ORD_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CCODCLI))
M.ORD_CCODSCHE = ALLTRIM(M.CCODSCHE)

x_aggan = "CCODSCHE = '" + ALLTRIM(M.CCODSCHE) + "'"
cSql="SELECT * FROM IMPIANTI_TT WHERE " + x_aggan
IF !ExecCommand(cSql,"CX_IMPIANTI_TT")
   return(.f.)
ENDIF 
SELECT CX_IMPIANTI_TT
GO TOP
IF !EOF()
	M.ORD_CODCLI	= ALLTRIM(CCODCLI)
	M.ORD_RAGSOC    = ALLTRIM(CRAGSOC)
	M.ORD_ZONA      = CZONAINS
	M.ORD_INDIRI    = ALLTRIM(CINDINS)
	M.ORD_CAP	    = CCAPINS
	M.ORD_LOCALI    = ALLTRIM(CLOCINS)
	M.ORD_PROVIN    = CPROINS
	*M.ORD_CODLOC 	= ALLTRIM(CRAGSOC1)
ELSE
	WAIT WINDOWS "IMPIANTO '" + ALLTRIM(M.CCODSCHE) + "' NON PRESENTE IN AQUARIUS - IMPOSSIBILE CARICARE LA RICHIESTA DI INTERVENTO" TIMEOUT 5
	RETURN .F.
ENDIF
	
IF !ExecRW("select * from IMPIANTI_RI where 0=1","IMPIANTI_RI","R")
   return(.f.)
ENDIF
SELECT IMPIANTI_RI
APPEND BLANK

M.ORD_SYSRINT = _AGGANCIO_AQUARIUS

x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
x_codi = "CLI_CODCLI = '" + M.ORD_CODCLI + "'"
x_cond = x_soci + " and " + x_codi
cSql = "SELECT * FROM U_CLI_AN WHERE " + x_cond
IF !ExecCommand(cSql,"CX_CLI_AN")
	RETURN .F.
ENDIF
SELECT CX_CLI_AN
GO TOP
IF !EOF()
	M.ORD_RAGSOC = CLI_RAGSOC
	M.ORD_RAGDUE = CLI_RAGDUE
	M.ORD_TELEFO = CLI_TELEFO
	M.ORD_CELLU = CLI_FAX
	M.ORD_PARIVA = DECODIFICA_PARTITA_IVA_CEE_INTRASTAT(CLI_PARIVA,CLI_IVACEE)
	IF EMPTY(M.ORD_PARIVA) AND !EMPTY(CLI_CODFIS)
		M.ORD_PARIVA = CLI_CODFIS
	ENDIF
ELSE
	M.ORD_RAGSOC = ""
	M.ORD_RAGDUE = ""
	M.ORD_TELEFO = ""
	M.ORD_CELLU = ""
	M.ORD_PARIVA = ""
ENDIF

M.ORD_CODRIC = ""
M.ORD_CLOSE = .F.
M.ORD_DATA = RIBALTA2(DTOC(M.CDATLAV))
M.ORD_DATREG = RIBALTA2(DTOC(M.CDATINT))
__ANNO = SUBSTR(M.ORD_DATREG,1,4)
M.ORD_ORAREG = "00:00:00"
M.ORD_NOTERIC = ALLTRIM(M.CNOTE)
M.ORD_APECLO = "APERTA"
M.TNUMERO = _AGGANCIO_ASTER
 
v_seek	  = 'NUMRIC'+__ANNO +PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0

   APPEND BLANK
   REPLACE CODICE WITH 'NUMRIC'+__ANNO +PUB_CODSOC
   REPLACE DESCRI WITH "NUMERO INTERVENTI/RIPARAZIONI CLIENTI"

   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_CODRIC = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   M.ORD_CODRIC  = TRC(5,ALLTRIM(M.ORD_CODRIC))
ELSE

   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_CODRIC = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   M.ORD_CODRIC  = TRC(5,ALLTRIM(M.ORD_CODRIC))
ENDIF

IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF


SELECT IMPIANTI_RI
DO IMPIANTI_RI
	

IF !ExecRW("select * from IMPIANTI_RI where 0=1","IMPIANTI_RI","W")
   return(.f.)
ENDIF


SELECT(_SXXS)

RETURN .T.

ENDFUNC
