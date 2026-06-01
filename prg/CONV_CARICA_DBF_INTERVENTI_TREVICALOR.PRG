*************************************************************************************************
*					         	    CARICAMENTO DBF INTERVENTI TREVICALOR			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2022 :Trevicalor 			 														*
*************************************************************************************************

*!*	PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
*!*	WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
*!*	SET DEFAULT TO &PERCORSO_TREVICALOR

**=> ERASMO - INIZIO 03/01/2024
SET DEFAULT TO &PUB_DIR

__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
PERCORSO_TREVICALOR=legge_config(__config_name,"PERCORSO_ASTERDAT")						&& RICERCA VARIABILE
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR
**=> ERASMO - FINE 03/01/2024

RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLE TABELLE INTERVENTI (MOVITEST/MOVITECN/MOVIARTI) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   SET DEFAULT TO &PUB_DIR  && ERASMO - 03/01/2024
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*!*	*** CANCELLAZIONE TABELLE INTERVENTI
*!*	WAIT WINDOWS "Cancellazione INTERVENTI ...  -  Prego Attendere" NOWAIT


*!*	cSql   = "truncate table VENDITE_TT" 
*!*	IF !ExecCommand(cSql,"VENDITE_TT")
*!*	   return(.f.)
*!*	ENDIF

*!*	cSql   = "truncate table VENDITE_DT" 
*!*	IF !ExecCommand(cSql,"VENDITE_DT")
*!*	   return(.f.)
*!*	ENDIF

*!*	cSql   = "truncate table VENDITE_DD" 
*!*	IF !ExecCommand(cSql,"VENDITE_DD")
*!*	   return(.f.)
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 03/01/2024
*!*	cSql   = "truncate table VENDITE_DC" 
*!*	IF !ExecCommand(cSql,"VENDITE_DC")
*!*	   return(.f.)
*!*	ENDIF

*!*	cSql   = "truncate table VENDITE_CO" 
*!*	IF !ExecCommand(cSql,"VENDITE_CO")
*!*	   return(.f.)
*!*	ENDIF
*!*	**=> ERASMO - FINE 03/01/2024

*!*	**=> ERASMO - INIZIO 29/11/2023
*!*	cSql = "UPDATE para SET LIBERA = '0' where CODICE LIKE 'NUMINR%'"
*!*	IF !ExecCommand(cSql,"UPD_PARA")
*!*	   return(.f.)
*!*	ENDIF
*!*	**=> ERASMO - FINE 29/11/2023

*_V_PERCORSO= "D:\Trevicalor\asterdat"
_V_PERCORSO = PERCORSO_TREVICALOR  && ERASMO - 03/01/2024

SET EXCLUSIVE ON

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("MOVITEST")
SELECT MOVITEST
INDEX ON ALLTRIM(ID_MOV)  TAG ID_MOVI  ADDITIVE
SET ORDER TO ID_MOVI  
GO TOP

=OPENDB("MOVITECN")
SELECT MOVITECN
INDEX ON ALLTRIM(ID_MOV)  TAG ID_TEK  ADDITIVE
SET ORDER TO ID_TEK  
GO TOP

=OPENDB("MOVIARTI")
SELECT MOVIARTI
INDEX ON ALLTRIM(ID_MOV)  TAG ID_RIC  ADDITIVE
SET ORDER TO ID_RIC  
GO TOP

=OPENDB("SCHEDETEST")
SELECT SCHEDETEST
INDEX ON ALLTRIM(CCODSCHE)  TAG ID_CODSC  ADDITIVE
SET ORDER TO ID_CODSC  
GO TOP



_CONTA_INT = 0
SET DEFAULT TO &PUB_DIR


RELEASE M.ORD_CODCLI,M.ORD_RAGSOC,M.ORD_INDIRI,M.ORD_CAP,M.ORD_LOCALI,M.ORD_PROVIN,M.ORD_PARIVA,M.ORD_RAGDUE,M.ORD_CPA,M.ORD_BANCA,M.ORD_CODNAZ,M.ORD_VALUTA,M.ORD_AGE,M.ORD_SEQUE,M.ORD_SEQUE2
PUBLIC M.ORD_CODCLI,M.ORD_RAGSOC,M.ORD_INDIRI,M.ORD_CAP,M.ORD_LOCALI,M.ORD_PROVIN,M.ORD_PARIVA,M.ORD_RAGDUE,M.ORD_CPA,M.ORD_BANCA,M.ORD_CODNAZ,M.ORD_VALUTA,M.ORD_AGE,M.ORD_SEQUE,M.ORD_SEQUE2   

M.ORD_CODCLI = "" 
M.ORD_RAGSOC = "" 
M.ORD_INDIRI = "" 
M.ORD_CAP    = ""
M.ORD_LOCALI = "" 
M.ORD_PROVIN = "" 
M.ORD_PARIVA = ""
M.ORD_RAGDUE = ""
M.ORD_CPA    = ""
M.ORD_BANCA	 = ""
M.ORD_CODNAZ = ""
M.ORD_VALUTA = ""
M.ORD_AGE    = ""
M.ORD_SEQUE  = 0
M.ORD_SEQUE2 = 0


RELEASE  M.ORD_CODSYS,M.ORD_ORAINIPRO,M.ORD_ORAFINPRO,M.ORD_NUMORD,M.ORD_DATORDM,M.ORD_DTPROGR,M.ORD_CCODSCHE,M.ORD_NOME_TECN,M.ORD_VALPRE,M.ORD_DTINIINT,M.ORD_ZONA
PUBLIC  M.ORD_CODSYS,M.ORD_ORAINIPRO,M.ORD_ORAFINPRO,M.ORD_NUMORD,M.ORD_DATORD,M.ORD_DTPROGR,M.ORD_CCODSCHE,M.ORD_NOME_TECN,M.ORD_VALPRE,M.ORD_DTINIINT,M.ORD_ZONA
M.ORD_CODSYS = ''
M.ORD_ORAINIPRO = ""
M.ORD_ORAFINPRO = ""	
M.ORD_NUMORD    = ""
M.ORD_DATORD    = ""	
M.ORD_DTPROGR   = ""
M.ORD_CCODSCHE  = ""
M.ORD_NOME_TECN = ""
M.ORD_VALPRE    = 0
M.ORD_DTINIINT  = ""
M.ORD_ZONA      = ""

**=> ERASMO - INIZIO 03/01/2024
RELEASE M.ORD_ORAREGI,M.ORD_DAFATT,M.ORD_FATTURAT,M.ORD_INTCLOSE,M.ORD_NUMFAT,M.ORD_DATFAT,M.ORD_CONFERMATO,M.ORD_TIPORD,M.ORD_TIPOLOGIA,M.ORD_CCODLIS
PUBLIC M.ORD_ORAREGI,M.ORD_DAFATT,M.ORD_FATTURAT,M.ORD_INTCLOSE,M.ORD_NUMFAT,M.ORD_DATFAT,M.ORD_CONFERMATO,M.ORD_TIPORD,M.ORD_TIPOLOGIA,M.ORD_CCODLIS
M.ORD_ORAREGI = ""
M.ORD_DAFATT = .F.
M.ORD_FATTURAT = .F.
M.ORD_INTCLOSE = .F.
M.ORD_NUMFAT = ""
M.ORD_DATFAT = ""
M.ORD_CONFERMATO = .F.
M.ORD_TIPORD = ""
M.ORD_TIPOLOGIA = ""
M.ORD_CCODLIS = ""
**=> ERASMO - FINE 03/01/2024

**=> ERASMO - INIZIO 09/01/2024
RELEASE M.ORD_CODLOC,M.ORD_RAGC,M.ORD_INDC,M.ORD_CAPC,M.ORD_LOCC,M.ORD_PROC,M.ORD_DSNAZC,PUB_LINKINTE
PUBLIC M.ORD_CODLOC,M.ORD_RAGC,M.ORD_INDC,M.ORD_CAPC,M.ORD_LOCC,M.ORD_PROC,M.ORD_DSNAZC,PUB_LINKINTE
M.ORD_CODLOC = ""
M.ORD_RAGC = ""
M.ORD_INDC = ""
M.ORD_CAPC = ""
M.ORD_LOCC = ""
M.ORD_PROC = ""
M.ORD_DSNAZC = ""
PUB_LINKINTE = ""
**=> ERASMO - FINE 09/01/2024

SELECT MOVITEST
*SET FILTER TO RIBALTA2(DTOC(CDATINT)) >= "2022/01/01"
SET FILTER TO RIBALTA2(DTOC(CDATINT)) >= "2021/01/01" AND RIBALTA2(DTOC(CDATINT)) <= "2021/12/31"  && ERASMO - 06/02/2024 - MODIFICA POST CONVERSIONI DEFINITIVE
SET ORDER TO ID_MOVI 
GO TOP

**=> ERASMO - INIZIO 03/01/2024
_CONTA_TOT = 0
GO TOP
SCAN
	_CONTA_TOT = _CONTA_TOT + 1
ENDSCAN
GO TOP
**=> ERASMO - FINE 03/01/2024

DO WHILE .NOT. EOF()

	SCATTER MEMVAR MEMO
	
	M.CCODSCHE = CONV_CLEAR(APITOSPA(M.CCODSCHE))		&& ERASMO - 03/01/2024
	
	_AGGANCIO_ASTER 	= ALLTRIM(M.ID_MOV)
	_AGGANCIO_AQUARIUS  = SYS(2015)
    _DATA_INTERVENTO    = DTOC(M.CDATINT)
    PUB_LINKINTE		= ""  && ERASMO - 09/01/2024
		
	*WAIT WINDOWS "Intervento caricato: " + _AGGANCIO_ASTER  NOWAIT
	**=> ERASMO - INIZIO 03/01/2024
	_CONTA_INT = _CONTA_INT + 1
	WAIT WINDOWS "Intervento elaborato: " + _AGGANCIO_ASTER + " (" + ALLTRIM(STR(_CONTA_INT,10,0)) + " di " + ALLTRIM(STR(_CONTA_TOT)) + ")" NOWAIT
	**=> ERASMO - FINE 03/01/2024
	
	_ANNO_INT = SUBSTR(_DATA_INTERVENTO,7,4)
*!*		IF VAL(_ANNO_INT) > 2020	&& CARICA SOLO GLI INTERVENTI DAL 2021 IN POI
*!*		ELSE
*!*			SELECT MOVITEST
*!*			SKIP + 1	
*!*		    LOOP
*!*		ENDIF

	=CARICA_VENDITE_TT(_AGGANCIO_AQUARIUS,_AGGANCIO_ASTER)

	=CARICA_VENDITE_DT(_AGGANCIO_AQUARIUS,_AGGANCIO_ASTER)

	*WAIT WINDOWS "Intervento caricato: " + _AGGANCIO_ASTER + " anno " +  _ANNO_INT  NOWAIT

	
	
*!*		**################
*!*		IF _CONTA_INT > 10
*!*			EXIT
*!*		ENDIF
*!*		**################
	
	
	SELECT MOVITEST
	SKIP + 1

ENDDO 


SET EXCLUSIVE OFF

**=> ERASMO - INIZIO 03/01/2024
IF USED("MOVITEST")
	SELECT MOVITEST
	USE
ENDIF

IF USED("MOVITECN")
	SELECT MOVITECN
	USE
ENDIF
IF USED("MOVITEST")
	SELECT MOVITEST
	USE
ENDIF
IF USED("MOVIARTI")
	SELECT MOVIARTI
	USE
ENDIF
IF USED("SCHEDETEST")
	SELECT SCHEDETEST
	USE
ENDIF
**=> ERASMO - FINE 03/01/2024

WAIT WINDOWS "Numero interventi caricati: " + STR(_CONTA_INT,5,0)

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


**************************************************************************
FUNCTION CARICA_VENDITE_TT
**************************************************************************
LPARAMETERS _AGGANCIO_AQUARIUS,_AGGANCIO_ASTER

_SXXS = SELECT()

		** CAMPI TESTATA INTERVENTO: MOVITEST
		*!*  Field        Field Name                                                            Type                                                                                                   Width                           Dec                   Index   Collate                                            Nulls                               Next                               Step
		*!*      1        ID_MOV                                                                Character                                                                                                 10                                                                                                               No
		*!*      2        STATUS                                                                Integer                                                                                                    4                                                                                                               No
		*!*      3        CSETTORE                                                              Character                                                                                                  2                                                                                                               No
		*!*      4        ID_PMKEY                                                              Character                                                                                                 10                                                                                                               No
		*!*      5        CCODSCHE                                                              Character                                                                                                 20                                                                                                               No
		*!*      6        CDATINT                                                               Date                                                                                                       8                                                                                                               No
		*!*      7        CDATINGIUL                                                            Character                                                                                                  6                                                                                                               No
		*!*      8        CCODINT                                                               Character                                                                                                  3                                                                                                               No
		*!*      9        CNOTE                                                                 Memo                                                                                                       4                                                                                                               No
		*!*     10        CNOTE1                                                                Character                                                                                                 60                                                                                                               No
		*!*     11        CNOTE2                                                                Character                                                                                                 60                                                                                                               No
		*!*     12        CNOTE3                                                                Character                                                                                                 60                                                                                                               No
		*!*     13        CCODCLI                                                               Character                                                                                                  8                                                                                                               No
		*!*     14        CRICFIS                                                               Character                                                                                                 10                                                                                                               No
		*!*     15        CNATOPE                                                               Character                                                                                                  2                                                                                                               No
		*!*     16        CNOFA1                                                                Character                                                                                                 44                                                                                                               No
		*!*     17        CNOFA2                                                                Character                                                                                                 50                                                                                                               No
		*!*     18        CNOFA3                                                                Character                                                                                                 50                                                                                                               No
		*!*     19        CNOFA4                                                                Character                                                                                                 50                                                                                                               No
		*!*     20        CNOFA5                                                                Character                                                                                                 50                                                                                                               No
		*!*     21        CNOFA6                                                                Character                                                                                                 50                                                                                                               No
		*!*     22        CNOFA7                                                                Character                                                                                                 50                                                                                                               No
		*!*     23        CNOFA8                                                                Character                                                                                                 50                                                                                                               No
		*!*     24        CNOFA9                                                                Character                                                                                                 50                                                                                                               No
		*!*     25        CNOFA10                                                               Character                                                                                                 50                                                                                                               No
		*!*     26        CNOFA11                                                               Character                                                                                                 50                                                                                                               No
		*!*     27        CNOFA12                                                               Character                                                                                                 50                                                                                                               No
		*!*     28        CNOFA13                                                               Character                                                                                                 50                                                                                                               No
		*!*     29        CNOFA14                                                               Character                                                                                                 50                                                                                                               No
		*!*     30        CNOFA15                                                               Character                                                                                                 50                                                                                                               No
		*!*     31        CNOFA16                                                               Character                                                                                                 50                                                                                                               No
		*!*     32        CNOFA17                                                               Character                                                                                                 50                                                                                                               No
		*!*     33        CNOFA18                                                               Character                                                                                                 50                                                                                                               No
		*!*     34        CNOFA19                                                               Character                                                                                                 50                                                                                                               No
		*!*     35        CNOFA20                                                               Character                                                                                                 50                                                                                                               No
		*!*     36        CFLAGCORR                                                             Character                                                                                                  1                                                                                                               No
		*!*     37        CFLAGFAT                                                              Character                                                                                                  1                                                                                                               No
		*!*     38        CNUMFATT                                                              Numeric                                                                                                    6                                                                                                               No
		*!*     39        CDATAFATT                                                             Date                                                                                                       8                                                                                                               No
		*!*     40        CFBOLTR                                                               Numeric                                                                                                    9                             2                                                                                 No
		*!*     41        CFBOLLO                                                               Numeric                                                                                                    9                             2                                                                                 No
		*!*     42        CFTRASP                                                               Numeric                                                                                                    9                             2                                                                                 No
		*!*     43        CFALIVATR                                                             Character                                                                                                  3                                                                                                               No
		*!*     44        CCODPAG                                                               Character                                                                                                  3                                                                                                               No
		*!*     45        CDAT_RICH                                                             Date                                                                                                       8                                                                                                               No
		*!*     46        CHH_RICH                                                              Numeric                                                                                                    2                                                                                                               No
		*!*     47        CMN_RICH                                                              Numeric                                                                                                    2                                                                                                               No
		*!*     48        PERC_RATA1                                                            Numeric                                                                                                    3                                                                                                               No
		*!*     49        PERC_RATA2                                                            Numeric                                                                                                    3                                                                                                               No
		*!*     50        DATA1_PERC                                                            Date                                                                                                       8                                                                                                               No
		*!*     51        DATA2_PERC                                                            Date                                                                                                       8                                                                                                               No
		*!*     52        FATT_RATA1                                                            Character                                                                                                  1                                                                                                               No
		*!*     53        FATT_RATA2                                                            Character                                                                                                  1                                                                                                               No
		*!*     54        FATTO_RAT1                                                            Character                                                                                                  1                                                                                                               No
		*!*     55        FATTO_RAT2                                                            Character                                                                                                  1                                                                                                               No
		*!*     56        DT_REGIST                                                             Date                                                                                                       8                                                                                                               No
		*!*     57        ORA_REGIST                                                            Character                                                                                                  8                                                                                                               No
		*!*     58        COMMESSA                                                              Character                                                                                                 15                                                                                                               No
		*!*     59        TIPO_STAG                                                             Character                                                                                                  3                                                                                                               No
		*!*     60        STAG_DAL_AA                                                           Character                                                                                                  4                                                                                                               No
		*!*     61        STAG_AL_AA                                                            Character                                                                                                  4                                                                                                               No
		*!*     62        ID_ESERCIZIO..                                                        Character                                                                                                 11                                                                                                               No

**==> CREAZIONE TABELLA TESTATA INTERVENTO
	
IF !ExecRW("select * from VENDITE_TT where 0=1","VENDITE_TT","R")
   return(.f.)
ENDIF
SELECT VENDITE_TT
APPEND BLANK

*_CONTA_INT = _CONTA_INT + 1

REPLACE TAGGANCIO  WITH _AGGANCIO_AQUARIUS
REPLACE ORD_CODSOC WITH PUB_CODSOC
M.ORD_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CCODCLI))

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
	M.ORD_INDIRI = CLI_INDIR
	M.ORD_CAP    = CLI_CAP
	M.ORD_LOCALI = CLI_LOCALI
	M.ORD_PROVIN = CLI_PROVIN
	M.ORD_PARIVA = CLI_PARIVA
	M.ORD_RAGDUE = CLI_RAGDUE
	*__ORD_CDIMBA = CLI_CODIMB
	__ORD_CPA = CLI_CONPAG
	__ORD_BANCA	 = CLI_BAE
	M.ORD_CODNAZ = CLI_NAZION
	M.ORD_VALUTA = CLI_VALUTA
	M.ORD_AGE    = CLI_AGE
	**=> ERASMO - INIZIO 04/01/2024
	M.ORD_PARIVA = DECODIFICA_PARTITA_IVA_CEE_INTRASTAT(CLI_PARIVA,CLI_IVACEE)		&& SE NON CODIFICATA LA PARTITA IVA VERIFICA SE E' UNA PARTITA IVA CEE 
	IF EMPTY(M.ORD_PARIVA) AND !EMPTY(CLI_CODFIS)
		M.ORD_PARIVA = CLI_CODFIS
	ENDIF
	**=> ERASMO - FINE 04/01/2024
ELSE
	M.ORD_RAGSOC = ""
	M.ORD_INDIRI = ""
	M.ORD_CAP	 = ""
	M.ORD_LOCALI = ""
	M.ORD_PROVIN = ""
	M.ORD_PARIVA = ""
	M.ORD_RAGDUE = ""
	*__ORD_CDIMBA = ""
	__ORD_CPA	 = ""
	__ORD_BANCA	 = ""
	M.ORD_CODNAZ = ""
	M.ORD_VALUTA = ""
	M.ORD_AGE    = "000"
	**=> ERASMO - INIZIO 04/01/2024
	M.ORD_PARIVA = ""
	**=> ERASMO - FINE 04/01/2024
ENDIF

*_DATAX= DTOC(M.CDATINT)
*__ANNO = SUBSTR(_DATAX,7,4)
*M.ORD_DATORD = RIBALTA2(_DATAX) 

**=> ERASMO - INIZIO 03/01/2024
x_aggan = "CCODSCHE = '" + ALLTRIM(M.CCODSCHE) + "'"
cSql="SELECT * FROM IMPIANTI_TT WHERE " + x_aggan
IF !ExecCommand(cSql,"CX_IMPIANTI_TT")
   return(.f.)
ENDIF 
SELECT CX_IMPIANTI_TT
GO TOP
IF !EOF()
	M.ORD_RAGSOC    = ALLTRIM(CRAGSOC)
	M.ORD_ZONA      = CZONAINS
	M.ORD_INDIRI    = ALLTRIM(CINDINS)
	M.ORD_CAP	    = CCAPINS
	M.ORD_LOCALI    = ALLTRIM(CLOCINS)
	M.ORD_PROVIN    = CPROINS
	M.ORD_CODLOC 	= ALLTRIM(CRAGSOC1)
ENDIF

M.ORD_DTPROGR = RIBALTA2(DTOC(M.CDATINT))
M.ORD_DATORD = RIBALTA2(DTOC(M.DT_REGIST))
__ANNO = SUBSTR(M.ORD_DATORD,1,4)
M.ORD_ORAREGI = M.ORA_REGIST
M.ORD_DAFATT = IIF(M.CFLAGFAT = 'S', .T., .F.)
M.ORD_FATTURAT = IIF(M.CFLAGFAT = 'S', .T., .F.)
M.ORD_INTCLOSE = .F.
M.ORD_NUMFAT = IIF(M.CNUMFATT > 0, PADL(ALLTRIM(STR(M.CNUMFATT,10,0)),6,'0'), "")
M.ORD_DATFAT = RIBALTA2(DTOC(M.CDATAFATT))
M.ORD_CONFERMATO = .T.
M.ORD_TIPORD = ALLTRIM(M.CSETTORE)
M.ORD_TIPOLOGIA = "000"
M.ORD_CCODLIS = ""
x_codi = "CCODSCHE = '" + ALLTRIM(M.CCODSCHE) + "'"
cSql = "select * from IMPIANTI_TE where " + x_codi + " order by ID_RIGO"
IF !ExecCommand(cSql,"IMPIANTI_TE")
   RETURN .F.
ENDIF
SELECT IMPIANTI_TE
GO TOP
IF !EOF()
	M.ORD_CCODLIS = CCODLIS
ENDIF
**=> ERASMO - FINE 03/01/2024

**=> ERASMO - INIZIO 09/01/2024
M.ORD_RAGC = ""
M.ORD_INDC = ""
M.ORD_CAPC = ""
M.ORD_LOCC = ""
M.ORD_PROC = ""
M.ORD_DSNAZC = "" 
IF EMPTY(ALLTRIM(M.ORD_CODLOC))
ELSE
   X_SOCI = "LOC_CODSOC = '" + PUB_CODSOC + "'"
   X_TIPO = "LOC_CF = 'C'"
   X_CODI = "LOC_CODCLI = '" + ALLTRIM(M.ORD_CODCLI) + "'"
   X_LOCA = "LOC_CODLOC = '" + ALLTRIM(M.ORD_CODLOC) + "'"
   X_COND = X_SOCI + " AND " + X_TIPO + " AND " + X_CODI + " AND " + X_LOCA
   CSQL   = "SELECT * FROM U_LOC_AN WHERE " + X_COND + " ORDER BY LOC_CODSOC,LOC_CF,LOC_CODCLI,LOC_CODLOC"
   IF !EXECCOMMAND(CSQL,"CUR_LOCALITA")
      RETURN(.F.)
   ENDIF
   SELECT CUR_LOCALITA
   GO TOP
   IF EOF()
   ELSE
      M.ORD_RAGC = LOC_RAGSOC
      M.ORD_INDC = LOC_INDIRI
      M.ORD_CAPC = LOC_CAP
      M.ORD_LOCC = LOC_LOCALI
      M.ORD_PROC = LOC_PROVIN
      M.ORD_DSNAZC = LOC_DESNAZ       
   ENDIF 
ENDIF  
**=> ERASMO - FINE 09/01/2024
 
v_seek	  = 'NUMINR'+__ANNO +PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0

   APPEND BLANK
   REPLACE CODICE WITH 'NUMINR'+__ANNO +PUB_CODSOC
   REPLACE DESCRI WITH "NUMERO INTERVENTI/RIPARAZIONI CLIENTI"

   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   _LEN_NUMINTER = LEN(M.ORD_NUMORD)
   _DIFF = 6 - _LEN_NUMINTER 
   IF _DIFF = 1
   		M.ORD_NUMORD = '0' + M.ORD_NUMORD 
   ENDIF
   IF _DIFF = 2 
   		M.ORD_NUMORD = '00' + M.ORD_NUMORD 
   ENDIF  
   IF _DIFF = 3
   		M.ORD_NUMORD = '000' + M.ORD_NUMORD 
   ENDIF  
   IF _DIFF = 4 
   		M.ORD_NUMORD = '0000' + M.ORD_NUMORD 
   ENDIF  
   IF _DIFF = 5 
   		M.ORD_NUMORD = '00000' + M.ORD_NUMORD 
   ENDIF  
   M.TNUMERO    = M.ORD_NUMORD
ELSE

   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   _LEN_NUMINTER = LEN(M.ORD_NUMORD)
   _DIFF = 6 - _LEN_NUMINTER 
   IF _DIFF = 1
   		M.ORD_NUMORD = '0' + M.ORD_NUMORD 
   ENDIF
   IF _DIFF = 2 
   		M.ORD_NUMORD = '00' + M.ORD_NUMORD 
   ENDIF  
   IF _DIFF = 3
   		M.ORD_NUMORD = '000' + M.ORD_NUMORD 
   ENDIF  
   IF _DIFF = 4 
   		M.ORD_NUMORD = '0000' + M.ORD_NUMORD 
   ENDIF  
   IF _DIFF = 5 
   		M.ORD_NUMORD = '00000' + M.ORD_NUMORD 
   ENDIF  
   M.TNUMERO    = M.ORD_NUMORD
ENDIF

IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF


SELECT VENDITE_TT
REPLACE TNUMERO    WITH M.TNUMERO
REPLACE ORD_CODCLI WITH M.ORD_CODCLI
REPLACE ORD_RAGSOC WITH M.ORD_RAGSOC
REPLACE ORD_RAGDUE WITH M.ORD_RAGDUE
REPLACE ORD_INDIRI WITH M.ORD_INDIRI
REPLACE ORD_CAP    WITH M.ORD_CAP
REPLACE ORD_LOCALI WITH M.ORD_LOCALI
REPLACE ORD_PARIVA WITH M.ORD_PARIVA
REPLACE ORD_VALUTA WITH M.ORD_VALUTA
REPLACE ORD_CAMBIO WITH 1

REPLACE ORD_NUMORD WITH M.ORD_NUMORD
=CAMBIADT(M.ORD_DATORD,"ORD_DATORD")
*REPLACE ORD_ORA    WITH M.ORD_ORA
REPLACE ORD_NUMORC WITH M.ORD_NUMORD
=CAMBIADT(M.ORD_DATORD,"ORD_DATORC")
REPLACE ORD_PESO   WITH 0
REPLACE ORD_COLLI  WITH ""
REPLACE ORD_CAUS   WITH PUB_INTE
REPLACE ORD_RIFERI WITH ""
REPLACE ORD_CPA    WITH M.CCODPAG
REPLACE ORD_BANCA  WITH ""
REPLACE ORD_AGE    WITH M.ORD_AGE
REPLACE ORD_PROVVI WITH 0
REPLACE ORD_ASPETT WITH ""
REPLACE ORD_SCOGLO WITH 0
REPLACE ORD_PORTO  WITH ""
REPLACE ORD_BOLLI  WITH ""
REPLACE ORD_SPBOLL WITH 0
REPLACE ORD_SPTRAS WITH 0
REPLACE ORD_MEZZO  WITH ""
REPLACE ORD_VETTO1 WITH ""
REPLACE ORD_VETTO2 WITH ""
REPLACE ORD_VETTO3 WITH ""
REPLACE ORD_LISTIN WITH ""
REPLACE ORD_ALTDES WITH 0
REPLACE ORD_CODLOC WITH ""
REPLACE ORD_RAGC   WITH ""
REPLACE ORD_INDC   WITH ""
REPLACE ORD_CAPC   WITH ""
REPLACE ORD_LOCC   WITH ""
REPLACE ORD_CODNAZ WITH M.ORD_CODNAZ
REPLACE ORD_TOTPRV WITH 0
REPLACE ORD_VALORE WITH 0
REPLACE ORD_FLBOL  WITH ""
=CAMBIADT(M.ORD_DATORD,"ORD_DTCONS")
REPLACE ORD_CONST  WITH .F.
REPLACE ORD_CHIUSO WITH .F.					&& ???????????????????
REPLACE SELEZIONE  WITH ""
REPLACE ORD_COMMES WITH ""
REPLACE ORD_SCAR   WITH ""
REPLACE ORD_MAGS   WITH PUB_CODM
REPLACE ORD_MAGD   WITH PUB_CODM
=CAMBIADT(M.ORD_DATORD,"ORD_INTRAS")
REPLACE ORD_FORNI  WITH .F.

REPLACE ORD_NOTE   WITH ALLTRIM(M.CNOTE)
REPLACE ORD_NOTE_INTERVENTI WITH ALLTRIM(M.CNOTE)

IF EMPTY(M.CNOTE)
	REPLACE ORD_NOTE   			WITH "INTERVENTO TECNICO"
	REPLACE ORD_NOTE_INTERVENTI WITH "INTERVENTO TECNICO"
ENDIF

REPLACE ORD_ACURA  WITH ""
REPLACE ORD_ITAEXP WITH ""
REPLACE ORD_PARTOT WITH ""
REPLACE ORD_FLGAGG WITH ""
REPLACE ORD_NUMCTL WITH ""
REPLACE ORD_DATCTL WITH ""					&& =CAMBIADT(M.ORD_DATCTL,"ORD_DATCTL")

M.ORD_CODSYS = SYS(2015)
REPLACE ORD_CODSYS WITH M.ORD_CODSYS
*REPLACE ORD_MERCRE WITH ""
REPLACE ORD_MERCRE WITH "##DA INTERV. ASTER##"  && PER IDENTIFICARE GLI INTERVENTI CARICATI DA INTERVENTI ASTER
REPLACE ORD_TISPE  WITH ""
REPLACE ORD_CODEMI WITH ""
REPLACE ORD_RAGEMI WITH ""
REPLACE ORD_CCOSTO WITH ""
REPLACE ORD_NUMTRX WITH ""
REPLACE ORD_DATTRX WITH ""					&& =CAMBIADT(M.ORD_DATTRX,"ORD_DATTRX")
REPLACE ORD_ORATRX WITH ""

REPLACE ORD_DATRCX WITH ""					&& =CAMBIADT(M.ORD_DATRCX,"ORD_DATRCX")
REPLACE ORD_ORARCX WITH ""
REPLACE ORD_VALDAF WITH 0
REPLACE ORD_TIPORD WITH ""
REPLACE ORD_FLGSTA WITH .F.

REPLACE ORD_DATSTA WITH ""					&& =CAMBIADT(M.ORD_DATSTA,"ORD_DATSTA")


REPLACE ORD_FLTRAS WITH ""
REPLACE ORD_DESFAT WITH ""
REPLACE ORD_DESTIN WITH ""
*REPLACE ORD_SYSCOD WITH M.ORD_CODSYS
REPLACE ORD_SYSCOD WITH _AGGANCIO_ASTER  && ERASMO - 03/01/2024
REPLACE ORD_PRORIT WITH 0
REPLACE ORD_SC1T   WITH 0
REPLACE ORD_SC2T   WITH 0
REPLACE ORD_SC3T   WITH 0
REPLACE ORD_TOTIMB WITH 0
REPLACE ORD_PESEST WITH 0
REPLACE ORD_CODIMB WITH ""
REPLACE ORD_CLIFAT WITH ""
REPLACE ORD_RAGFAT WITH ""
REPLACE ORD_ORATRA WITH ""
REPLACE ORD_TRASME WITH .F.
REPLACE ORD_ANNO   WITH SUBSTR(ORD_DATORD,1,4)           
REPLACE ORD_PROVIN WITH M.ORD_PROVIN
REPLACE ORD_PROC   WITH ""
REPLACE ORD_CODBUN WITH ""
REPLACE ORD_DESBUN WITH ""
*REPLACE ORD_FLGCON WITH .F.
REPLACE ORD_NUMDDT WITH ""
REPLACE ORD_DATDDT WITH ""
REPLACE ORD_ANNDDT WITH ""
REPLACE ORD_AGGDDT WITH ""
REPLACE T_OMAGGIO  WITH 0   
REPLACE I_OMAGGIO  WITH 0

REPLACE ORD_DATFAT WITH ""					&& =CAMBIADT(M.ORD_DATFAT,"ORD_DATFAT")

REPLACE ORD_PESNET WITH 0 
REPLACE TIPRENDO   WITH SYS(2015)  	 
REPLACE ORD_AAMMFA WITH ""	 

*!*	REPLACE MOD_CODOPE WITH PUB_CODOPE
*!*	REPLACE MOD_NOMOPE WITH PUB_NOMOPE
*!*	REPLACE MOD_DATREG WITH RIBALTA2(DTOC(DATE()))
*!*	REPLACE MOD_ORAREG WITH TIME()
**=> ERASMO - INIZIO 03/01/2024
REPLACE REG_CODOPE WITH PUB_CODOPE
REPLACE REG_NOMOPE WITH PUB_NOMOPE
REPLACE REG_DATREG WITH RIBALTA2(DTOC(DATE()))
REPLACE REG_ORAREG WITH TIME()
**=> ERASMO - FINE 03/01/2024

REPLACE ORD_SGNCLL WITH .F.    		 
REPLACE ORD_PERPAG WITH 0 			 
REPLACE ORD_RIFCTL WITH 0			 
REPLACE ORD_PAGCTL WITH 0			 
REPLACE ORD_ATTENZIONE  WITH ""	 
REPLACE ORD_VARIE   	WITH ""   	 
REPLACE ORD_BOLLATOIVA	WITH ""	 
REPLACE ORD_VETXTR WITH ""  			 
REPLACE ORD_CONCON      WITH ""		 
REPLACE ORD_PEDANE WITH 0			 
REPLACE ORD_TIPOLOGIA   WITH ""     
REPLACE ORD_NOTET  WITH ""				 
REPLACE ORD_CUP    WITH ""			     
REPLACE ORD_CIG    WITH ""		     
REPLACE ORD_CSTTRA WITH 0			 
REPLACE ORD_DSNAZC WITH ""      		 
REPLACE ORD_IMPONIB     WITH 0		 
REPLACE ORD_IMPOSTA     WITH 0		 
REPLACE ORD_NOPOLIEC    WITH .F.

REPLACE ORD_DATCOL WITH ""					&& =CAMBIADT(M.ORD_DATCOL,"ORD_DATCOL")				 

REPLACE ORD_PROSPECT 	WITH .F.				
REPLACE ORD_CDC 		WITH ""						
REPLACE ORD_COGNOM 		WITH "" 					
REPLACE ORD_NOME 		WITH ""						
REPLACE ORD_NOMCAM 		WITH ""						
REPLACE ORD_CAMPAN 		WITH ""						
REPLACE ORD_PIANOS 		WITH ""						
REPLACE ORD_TELEFO 		WITH ""						
REPLACE ORD_CELLU 		WITH ""						
REPLACE ORD_MATDAUT 	WITH ""	 					
REPLACE ORD_MATDAOR 	WITH ""						
REPLACE ORD_RAPPORT 	WITH ""						
REPLACE ORD_INCASS 		WITH 0

 					
=CAMBIADT(M.ORD_DATORD,"ORD_DATSCA")						
=CAMBIADT(M.ORD_DATORD,"ORD_DATCOM")						



*M.ORD_DTPROGR = DTOC(M.CDAT_RICH)
=CAMBIADT(M.ORD_DTPROGR,"ORD_DTPROGR") 	
IF SUBSTR(M.ORD_DTPROGR,1,2) = ''
	M.ORD_DTPROGR = M.ORD_DATORD
	=CAMBIADT(M.ORD_DTPROGR,"ORD_DTPROGR")
ENDIF

_HH_PROGRAMMATA = ALLTRIM(STR(M.CHH_RICH,2,0))
IF LEN(_HH_PROGRAMMATA) < 2
	_HH_PROGRAMMATA = "0" + _HH_PROGRAMMATA
ENDIF

_MM_PROGRAMMATI = ALLTRIM(STR(M.CMN_RICH,2,0))
IF LEN(_MM_PROGRAMMATI) < 2
	_MM_PROGRAMMATI = "0" + _MM_PROGRAMMATI 
ENDIF


M.ORD_ORAINIPRO = _HH_PROGRAMMATA  + ":" +	_MM_PROGRAMMATI	+ ":00" 
M.ORD_ORAFINPRO = _HH_PROGRAMMATA  + ":" +	_MM_PROGRAMMATI	+ ":00" 		
		
* #################################################### SISTEMAZIONE DATI MANCANTI ####################################################		
IF VAL(_HH_PROGRAMMATA) = 0		
	M.ORD_ORAINIPRO = "09" + ":" +	"00"  + ":00" 
	M.ORD_ORAFINPRO = "10" + ":" +	"00"  + ":00" 
ENDIF
* #################################################### SISTEMAZIONE DATI MANCANTI ####################################################		
		
					
*!*	REPLACE  ORD_ORAINIPRO   WITH  M.ORD_ORAINIPRO  	 
*!*	REPLACE  ORD_ORAFINPRO   WITH  M.ORD_ORAFINPRO 

REPLACE ORD_INTCLOSE WITH .T.  && ERASMO - 21/12/2022



SELECT MOVITECN
SET ORDER TO ID_TEK
_SEEK = ALLTRIM(M.ID_MOV)
GO TOP  && ERASMO - 03/01/2024
SEEK _SEEK
IF FOUND()

	M.ORD_DTINIINT = DTOC(CDATINT)

	_HH_INI_INTERVENTO = ALLTRIM(STR(CHH12,2,0))
	IF LEN(_HH_INI_INTERVENTO) < 2
		_HH_INI_INTERVENTO = "0" + _HH_INI_INTERVENTO 
	ENDIF
	_MM_INI_INTERVENTO = ALLTRIM(STR(CMN12,2,0))
	IF LEN(_MM_INI_INTERVENTO) < 2
		_MM_INI_INTERVENTO = "0" + _MM_INI_INTERVENTO
	ENDIF
	

	_HH_FIN_INTERVENTO = ALLTRIM(STR(CHH13,2,0))
	IF LEN(_HH_FIN_INTERVENTO) < 2
		_HH_FIN_INTERVENTO = "0" + _HH_FIN_INTERVENTO 
	ENDIF
	_MM_FIN_INTERVENTO = ALLTRIM(STR(CMN13,2,0))
	IF LEN(_MM_FIN_INTERVENTO) < 2
		_MM_FIN_INTERVENTO = "0" + _MM_FIN_INTERVENTO
	ENDIF
	
	
	IF VAL(_HH_INI_INTERVENTO) = 0		
		_HH_INI_INTERVENTO = "09" + ":" +	"00"  + ":00" 
		_HH_FIN_INTERVENTO = "10" + ":" +	"00"  + ":00" 		
	ENDIF	
	
	IF VAL(_HH_FIN_INTERVENTO) = 0	
		_HH_INI_INTERVENTO = "09" + ":" +	"00"  + ":00" 
		_HH_FIN_INTERVENTO = "10" + ":" +	"00"  + ":00" 
	ENDIF


	M.ORD_ORAINIINT  = _HH_INI_INTERVENTO + ":" +	_MM_INI_INTERVENTO 	+ ":00" 
	M.ORD_ORAFININT  = _HH_FIN_INTERVENTO + ":" +	_MM_FIN_INTERVENTO 	+ ":00" 		
	
	**=> ERASMO - INIZIO 03/01/2024
	_AGGANCIO_ASTER = M.ID_MOV
	_YES_ALL_ACTIVITIES_CLOSED = .T.
	SELECT MOVITECN
	DO WHILE .NOT. EOF()
		IF DELETED()
			SELECT MOVITECN
			SKIP +1		
			LOOP
		ENDIF
		IF ALLTRIM(_AGGANCIO_ASTER) <> ALLTRIM(ID_MOV)
			EXIT
		ENDIF
		
		IF CFLAGESE = 'S'
		ELSE
			_YES_ALL_ACTIVITIES_CLOSED = .F.
			EXIT
		ENDIF

		SELECT MOVITECN
		SKIP +1
	ENDDO
	
	SELECT VENDITE_TT
	IF !_YES_ALL_ACTIVITIES_CLOSED
		REPLACE ORD_INTCLOSE WITH .F.
		M.ORD_FATTURAT = .F.
		M.ORD_CONFERMATO = .F.
	ENDIF
	**=> ERASMO - FINE 03/01/2024
						
	SELECT VENDITE_TT
			
	=CAMBIADT(M.ORD_DTINIINT,"ORD_DTINIINT")
*!*		REPLACE  ORD_ORAINIINT   WITH  M.ORD_ORAINIINT      
*!*		REPLACE  ORD_ORAFININT   WITH  M.ORD_ORAFININT      

	IF SUBSTR(M.ORD_DTPROGR,1,2) = ''
		=CAMBIADT(M.ORD_DTINIINT,"ORD_DTPROGR") 	
	ENDIF

ELSE

	SELECT VENDITE_TT

	=CAMBIADT(M.ORD_DATORD,"ORD_DTINIINT")					
	=CAMBIADT(M.ORD_DATORD,"ORD_DTFINTNT")	
	M.ORD_ORAINIINT = "09:00:00" 
	M.ORD_ORAFININT = "10:00:00" 				
*!*		REPLACE ORD_ORAINIINT	WITH M.ORD_ORAINIINT			
*!*		REPLACE ORD_ORAFININT	WITH M.ORD_ORAFININT				

*!*		=CAMBIADT(M.ORD_DATORD,"ORD_DTPROGR") 	
*!*		REPLACE  ORD_ORAINIPRO   WITH  M.ORD_ORAINIINT      
*!*		REPLACE  ORD_ORAFINPRO   WITH  M.ORD_ORAFININT      


ENDIF 



SELECT VENDITE_TT

REPLACE ORD_CCODSCHE	WITH M.CCODSCHE						
REPLACE ORD_INASSIST	WITH .F.				
*REPLACE ORD_DAFATT		WITH .F.					
*REPLACE ORD_FATTURAT	WITH .F.					
REPLACE ORD_DAFATT		WITH M.ORD_DAFATT	&& ERASMO - 03/01/2024
REPLACE ORD_FATTURAT	WITH M.ORD_FATTURAT	&& ERASMO - 03/01/2024
REPLACE ORD_PAGALTEC	WITH .F.				

REPLACE ORD_ORAREGI		WITH M.ORD_ORAREGI		&& ERASMO - 03/01/2024
REPLACE ORD_NUMFAT		WITH M.ORD_NUMFAT		&& ERASMO - 03/01/2024
REPLACE ORD_DATFAT		WITH M.ORD_DATFAT		&& ERASMO - 03/01/2024
REPLACE ORD_CONFERMATO	WITH M.ORD_CONFERMATO	&& ERASMO - 03/01/2024
REPLACE ORD_TIPORD 		WITH M.ORD_TIPORD 		&& ERASMO - 03/01/2024
REPLACE ORD_TIPOLOGIA	WITH M.ORD_TIPOLOGIA	&& ERASMO - 03/01/2024
REPLACE ORD_CCODLIS		WITH M.ORD_CCODLIS		&& ERASMO - 03/01/2024

**=> ERASMO - INIZIO 09/01/2024
REPLACE ORD_CODLOC WITH M.ORD_CODLOC
REPLACE ORD_RAGC WITH M.ORD_RAGC
REPLACE ORD_INDC WITH M.ORD_INDC
REPLACE ORD_CAPC WITH M.ORD_CAPC
REPLACE ORD_LOCC WITH M.ORD_LOCC
REPLACE ORD_PROC WITH M.ORD_PROC
REPLACE ORD_DSNAZC WITH M.ORD_DSNAZC
**=> ERASMO - FINE 09/01/2024


SELECT SCHEDETEST
SET ORDER TO ID_CODSC  
_SEEK = ALLTRIM(M.CCODSCHE)
SEEK _SEEK
IF FOUND()
	M.ORD_ZONA = CZONAINS
ELSE
	M.ORD_ZONA = ""
ENDIF 



V_SEEK	 = 'ZON'+M.ORD_ZONA
V_CHIAVE = "CODICE"
IF SEEK_STD('PARA',V_SEEK,V_CHIAVE,'CUR_PARA')
ELSE         
	M.ORD_ZONA = M.ORD_PROVIN	&& FORZO LA PROVINCIA SE NON ESISTE LA ZONA
ENDIF 


SELECT VENDITE_TT
REPLACE  ORD_ZONA	     WITH  M.ORD_ZONA					    



		 	

IF !ExecRW("select * from VENDITE_TT where 0=1","VENDITE_TT","W")
   return(.f.)
ENDIF


SELECT(_SXXS)

RETURN .T.

ENDFUNC



**************************************************************************
FUNCTION CARICA_VENDITE_DT
**************************************************************************
LPARAMETERS _AGGANCIO_AQUARIUS,_AGGANCIO_ASTER

_SXXXS = SELECT()



*!*	               Field        Field Name                                                            Type                                                                                                   Width                           Dec                   Index   Collate                                            Nulls                               Next                               Step
*!*	                    1        ID_MOV                                                                Character                                                                                                 10                                                                                                               No
*!*	                    2        CCODSCHE                                                              Character                                                                                                 20                                                                                                               No
*!*	                    3        ID_PMCONTR                                                            Character                                                                                                 10                                                                                                               No
*!*	                    4        ID_PMKEY                                                              Character                                                                                                 10                                                                                                               No
*!*	                    5        ID_RIGO                                                               Character                                                                                                  5                                                                                                               No
*!*	                    6        CDATINT                                                               Date                                                                                                       8                                                                                                               No
*!*	                    7        CDATINGIUL                                                            Character                                                                                                  6                                                                                                               No
*!*	                    8        CNUMINT                                                               Numeric                                                                                                    7                             2                                                                                 No
*!*	                    9        CCODTEC                                                               Character                                                                                                  3                                                                                                               No
*!*	                   10        CCODPRE                                                               Character                                                                                                  3                                                                                                               No
*!*	                   11        CQTA                                                                  Numeric                                                                                                    2                                                                                                               No
*!*	                   12        CHH11                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   13        CMN11                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   14        CHH12                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   15        CMN12                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   16        CHH13                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   17        CMN13                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   18        CHH14                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   19        CMN14                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   20        CHH21                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   21        CMN21                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   22        CHH22                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   23        CMN22                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   24        CHH23                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   25        CMN23                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   26        CHH24                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   27        CMN24                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   28        CHH31                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   29        CMN31                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   30        CHH32                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   31        CMN32                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   32        CHH33                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   33        CMN33                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   34        CHH34                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   35        CMN34                                                                 Numeric                                                                                                    2                                                                                                               No
*!*	                   36        CTOTHH1                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   37        CTOTMN1                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   38        CTOTHH2                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   39        CTOTMN2                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   40        CTOTHH3                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   41        CTOTMN3                                                               Numeric                                                                                                    2                                                                                                               No
*!*	                   42        CIMPHH1                                                               Numeric                                                                                                   19                             5                                                                                 No
*!*	                   43        CIMPHH2                                                               Numeric                                                                                                   19                             5                                                                                 No
*!*	                   44        CIMPHH3                                                               Numeric                                                                                                   19                             5                                                                                 No
*!*	                   45        CQTAIMP1                                                              Numeric                                                                                                    4                                                                                                               No
*!*	                   46        CQTAIMP2                                                              Numeric                                                                                                    4                                                                                                               No
*!*	                   47        CQTAIMP3                                                              Numeric                                                                                                    4                                                                                                               No
*!*	                   48        CIVAORE                                                               Character                                                                                                  3                                                                                                               No
*!*	                   49        CIMPPRE                                                               Numeric                                                                                                   19                             5                                                                                 No
*!*	                   50        CIVAPRE                                                               Character                                                                                                  3                                                                                                               No
*!*	                   51        CRICFIS                                                               Character                                                                                                 10                                                                                                               No
*!*	                   52        CRAPLAV                                                               Character                                                                                                 10                                                                                                               No
*!*	                   53        CCODTAR                                                               Character                                                                                                  3                                                                                                               No
*!*	                   54        CFLAGFAT                                                              Character                                                                                                  1                                                                                                               No
*!*	                   55        CFLAGESE                                                              Character                                                                                                  1                                                                                                               No
*!*	                   56        CDESPRE                                                               Character                                                                                                 60                                                                                                               No
*!*	                   57        CCONVEN                                                               Character                                                                                                  8                                                                                                               No
*!*	                   58        CCONTRATTO                                                            Character                                                                                                  3                                                                                                               No
*!*	                   59        CNATOPE                                                               Character                                                                                                  2                                                                                                               No
*!*	                   60        DT_REGIST                                                             Date                                                                                                       8                                                                                                               No
*!*	                   61        ORA_REGIST                                                            Character                                                                                                  8                                                                                                               No
*!*	                   62        CRICFISRIG                                                            Character                                                                                                  3                                                                                                               No
*!*	                   63        CTOTHHFATT                                                            Numeric                                                                                                    2                                                                                                               No
*!*	                   64        CTOTMNFATT                                                            Numeric                                                                                                    2                                                                                                               No
*!*	                   65        CFLAG_DFIS                                                            Logical                                                                                                    1                                                                                                               No
*!*	                   66        COD_DFISSO                                                            Character                                                                                                  3                                                                                                               No
*!*	                   67        IMP_DFISSO                                                            Numeric                                                                                                   19                             5                                                                                 No
*!*	                   68        ID_MOV_RIGO                                                           Character                                                                                                  5                                                                                                               No
*!*	                   69        ID_CATEG                                                              Character                                                                                                  3                                                                                                               No
*!*	                   70        TIPO_STAG                                                             Character                                                                                                  3                                                                                                               No
*!*	                   71        STAG_DAL_AA                                                           Character                                                                                                  4                                                                                                               No
*!*	                   72        STAG_AL_AA                                                            Character                                                                                                  4                                                                                                               No
*!*	                   73        ID_ESERCIZIO..                                                        Character                                                                                                 11                                                                                                               No
*!*	                   74        UPD_ID_PMCON..                                                        Integer                                                                                                    4                                                                                                               No
*!*	                   75        CNOFA1                                                                Character                                                                                                250                                                                                                               No
*!*	                   76        CNOFA2                                                                Character                                                                                                250                                                                                                               No
*!*	                   77        CNOFA3                                                                Character                                                                                                250                                                                                                               No



M.ORD_SEQUE = 0
M.ORD_SEQUE2 = 0

SELECT MOVITECN
SET ORDER TO ID_TEK  
GO TOP
_SEEK = ALLTRIM(_AGGANCIO_ASTER)
SEEK _SEEK

IF FOUND()

	DO WHILE .NOT. EOF()

		IF DELETED()
			SELECT MOVITECN
			SKIP +1		
			LOOP
		ENDIF

		IF ALLTRIM(_AGGANCIO_ASTER) <> ALLTRIM(ID_MOV)
			EXIT
		ENDIF

		SELECT MOVITECN
		SCATTER MEMVAR MEMO
		
		M.CCODSCHE = CONV_CLEAR(APITOSPA(M.CCODSCHE))  && ERASMO - 03/01/2024

		M.ORD_TECNICO = M.CCODTEC
		V_SEEK	 = 'TEI'+M.ORD_TECNICO
		V_CHIAVE ="CODICE"
		IF SEEK_STD('PARA',V_SEEK,V_CHIAVE,'CUR_PARA')
		   SELECT CUR_PARA
		   M.ORD_NOME_TECN = ALLTRIM(SUBSTR(DESCRI,1,50))
		ELSE
		   M.ORD_NOME_TECN = ""
		ENDIF
		
		**=> ERASMO - INIZIO 03/01/2024
		M.LINK_DT_DC = SYS(2015)
		M.ORD_SYSCOMPONENTI = M.LINK_DT_DC
		x_codi = "DD.CCODSCHE = '" + ALLTRIM(M.CCODSCHE) + "' AND DD.ID_RIGO = '" + ALLTRIM(M.ID_RIGO) + "'"
		cSql = "select DD.*, TE.DIR_FISSO, COALESCE(PARA_DFI.PAR_COSTCAD1,0) AS COSTO_DIR_FISSO, COALESCE(PARA_TCI.DESCRI,'') AS DES_TIPO_COMPONENTE from IMPIANTI_DD AS DD " + ;
			   "LEFT OUTER JOIN IMPIANTI_TE AS TE ON DD.ID_PMKEY = TE.ID_PMKEY AND DD.ID_RIGO = TE.ID_RIGO AND DD.TIPO_COMPONENTE = TE.TIPO_COMPONENTE " + ;
			   "LEFT OUTER JOIN PARA AS PARA_DFI ON PARA_DFI.CODICE = 'DFI'+TE.DIR_FISSO " + ;
			   "LEFT OUTER JOIN PARA AS PARA_TCI ON PARA_TCI.CODICE = 'TCI'+DD.TIPO_COMPONENTE " + ;
			   "where " + x_codi + " order by ID_RIGO,TIPO_COMPONENTE"
		IF !ExecCommand(cSql,"TMP_IMPIANTI_DD")
		   RETURN .F.
		ENDIF
		SELECT TMP_IMPIANTI_DD
		GO TOP
		IF !EOF()
			__ID_PMKEY = ID_PMKEY
			__TIPO_COMPONENTE = TIPO_COMPONENTE
			__ORD_LINKCOMP = ORD_LINKCOMP			
			__CDITTACAL = CDITTACAL 
			__CMODCAL = CMODCAL 
			__CMATCAL = CMATCAL 
			__CCALCAL = CCALCAL 
			__CDAFIGARNZ = CDAFIGARNZ
			
			**=> ERASMO - INIZIO 09/01/2024
			IF EMPTY(PUB_LINKINTE)
				PUB_LINKINTE = LINKINTE
			ENDIF
			**=> ERASMO - FINE 09/01/2024
			
			IF !ExecRW("select * from VENDITE_DC where 0=1","VENDITE_DC","R")
			   return(.f.)
			ENDIF
			SELECT VENDITE_DC
			APPEND BLANK
			REPLACE DAGGANCIO  		WITH _AGGANCIO_AQUARIUS
			REPLACE LINK_DT_DC     	WITH M.LINK_DT_DC		&& LINK TRA' LA TABELLA VENDITE_DT E LA TABELLA VENDITE_DC
			REPLACE PMKEY     		WITH __ID_PMKEY
			REPLACE CCODSCHE  		WITH M.CCODSCHE
			REPLACE ID_RIGO		  	WITH M.ID_RIGO
			REPLACE TIPO_COMPONENTE	WITH __TIPO_COMPONENTE
			REPLACE NUMORD			WITH M.ORD_NUMORD
			=CAMBIADT(M.ORD_DATORD,"DATORD")
			REPLACE LINKCOMP		WITH __ORD_LINKCOMP 	&& LINK TRA' LA TABELLA IMPIANTI_DD E LA TABELLA VENDITE_DC
			REPLACE LINKCONTR		WITH ""
			IF !ExecRW("select * from VENDITE_DC where 0=1","VENDITE_DC","W")
			   return(.f.)
			ENDIF
		ENDIF
		
		SELECT MOVITECN
		
		M.ORD_ATTICLOSE = IIF(M.CFLAGESE = 'S', .T., .F.)
		M.ORD_ORAPARSEDE = PADL(ALLTRIM(STR(M.CHH11,2,0)),2,'0') + ":" + PADL(ALLTRIM(STR(M.CMN11,2,0)),2,'0') + ":00"
		M.ORD_ORAINIPRO = PADL(ALLTRIM(STR(M.CHH13,2,0)),2,'0') + ":" + PADL(ALLTRIM(STR(M.CMN13,2,0)),2,'0') + ":00"
		M.ORD_ORAFINPRO = SUBSTR(TTOC(CTOT("01/01/2024 " + M.ORD_ORAINIPRO) + (M.CTOTHH1*3600) + (M.CTOTMN1*60)),12,8)
		M.ORD_ORAINIINT = ""
		M.ORD_ORAFININT = ""
		IF M.ORD_ATTICLOSE
			M.ORD_ORAINIINT = M.ORD_ORAINIPRO
			M.ORD_ORAFININT = M.ORD_ORAFINPRO
		ENDIF
		
		M.ORD_FORFET = .T.
		M.ORD_PREZZO = M.CIMPPRE
		M.ORD_VALATT = M.CIMPPRE
		M.ORD_VALPRE = M.CIMPPRE
		M.ORD_DIRICHIAMATA = 0
		_DIRITTOFISSO = 0
		
		M.ORD_DIRIZONA = _DIRITTOFISSO
		M.ORD_ARRTOT = .F.
		
		M.ORD_ORELAV = 0
		
		_V_ORAINIPRO = "00:00:00"
		_V_ORAFINPRO = "00:00:00"
		IF !EMPTY(M.ORD_ORAINIPRO) AND !EMPTY(M.ORD_ORAFINPRO) AND ALLTRIM(M.ORD_ORAINIPRO) <> ":  :" AND ALLTRIM(M.ORD_ORAFINPRO) <> ":  :" AND M.ORD_ORAINIPRO <> "00:00:00" AND M.ORD_ORAFINPRO <> "00:00:00"
			_V_ORAINIPRO = M.ORD_ORAINIPRO 
			_V_ORAFINPRO = M.ORD_ORAFINPRO 
		ENDIF
		IF !EMPTY(M.ORD_ORAINIINT) AND !EMPTY(M.ORD_ORAFININT) AND ALLTRIM(M.ORD_ORAINIINT) <> ":  :" AND ALLTRIM(M.ORD_ORAFININT) <> ":  :" AND M.ORD_ORAINIINT <> "00:00:00" AND M.ORD_ORAFININT <> "00:00:00"
			_V_ORAINIPRO = M.ORD_ORAINIINT
			_V_ORAFINPRO = M.ORD_ORAFININT
		ENDIF
		_V_FORFET 		= M.ORD_FORFET
		_V_PREZZO		= M.ORD_PREZZO
		_V_DIRICHIAMATA	= M.ORD_DIRICHIAMATA
		_V_DIRIZONA 	= M.ORD_DIRIZONA
		_V_ARRTOT 		= M.ORD_ARRTOT
		=CALCOLA_TARIFFA_INTERVENTO(_V_FORFET,_V_ORAINIPRO,_V_ORAFINPRO,_V_PREZZO,_V_DIRICHIAMATA,_V_DIRIZONA,_V_ARRTOT)
		**=> ERASMO - FINE 03/01/2024
		
		
		IF !ExecRW("select * from VENDITE_DT where 0=1","VENDITE_DT","R")
		   return(.f.)
		ENDIF
		SELECT VENDITE_DT
		APPEND BLANK

		M.ORD_SEQUE = M.ORD_SEQUE + 10
		
		REPLACE  DAGGANCIO       WITH  _AGGANCIO_AQUARIUS
		*REPLACE  ORD_CODSYS      WITH  M.ORD_CODSYS             
		REPLACE  ORD_CODSYS      WITH  SYS(2015)  && ERASMO - 03/01/2024
		REPLACE  ORD_SEQUE       WITH  M.ORD_SEQUE            
		REPLACE  ORD_TECNICO     WITH  M.ORD_TECNICO
		REPLACE  ORD_NOME_TECN   WITH  M.ORD_NOME_TECN
		REPLACE  ORD_ATTIVITA    WITH  M.CCODPRE
		
		*M.ORD_DTPROGR = DTOC(M.CDATINT)
		*=CAMBIADT(M.ORD_DTPROGR,"ORD_DTPROGR") 
		REPLACE  ORD_ORAINIPRO   WITH  M.ORD_ORAINIPRO  	 
		REPLACE  ORD_ORAFINPRO   WITH  M.ORD_ORAFINPRO 
		REPLACE  ORD_MINPAUPRO   WITH  0
	
*!*			cSql = "SELECT SUBSTRING(CODICE,4,3) AS CODICE, LTRIM(DESCRI) AS DESCRI, PAR_COSTCAD1 AS PAR_COSTCAD1, PAR_RICCAD1 AS PAR_RICCAD1 FROM PARA WHERE CODICE LIKE 'TOR%' AND DISATTIVO = 0 AND LEN(RTRIM(CODICE)) = 6"
*!*			IF !ExecCommand(cSql,"TMP_PARA_TOR_1")
*!*			  return(.f.)
*!*			ENDIF
*!*			SELECT TMP_PARA_TOR_1
*!*			GO TOP
*!*			IF !EOF()
*!*				_TARIFFAFISSA 	= PAR_COSTCAD1
*!*				_DIRITTOFISSO	= PAR_RICCAD1  
*!*			ELSE	
*!*				_TARIFFAFISSA 	= 0
*!*				_DIRITTOFISSO	= 0  		
*!*			ENDIF
*!*			
*!*		    M.ORD_VALPRE = _TARIFFAFISSA + _DIRITTOFISSO
	
		SELECT VENDITE_DT
	
		*REPLACE  ORD_PAGAALTEC    WITH  .F.     
		
		REPLACE  ORD_PREZZO       WITH  M.ORD_VALPRE  		      
		REPLACE  ORD_PRZNET       WITH  M.ORD_VALPRE 		      
		REPLACE  ORD_VALATT       WITH  M.ORD_VALPRE   		      
		REPLACE  ORD_VALPRE       WITH  M.ORD_VALPRE            
		REPLACE  ORD_VALINC       WITH  M.ORD_VALPRE  
		
		
		M.ORD_DTINIINT = DTOC(M.CDATINT)
		        
		=CAMBIADT(M.ORD_DTINIINT,"ORD_DTINIINT")
		
*!*			_HH_INI_INTERVENTO = ALLTRIM(STR(M.CHH12,2,0))
*!*			IF LEN(_HH_INI_INTERVENTO) < 2
*!*				_HH_INI_INTERVENTO = "0" + _HH_INI_INTERVENTO 
*!*			ENDIF

*!*			_MM_INI_INTERVENTO = ALLTRIM(STR(M.CMN12,2,0))
*!*			IF LEN(_MM_INI_INTERVENTO) < 2
*!*				_MM_INI_INTERVENTO = "0" + _MM_INI_INTERVENTO
*!*			ENDIF

*!*			M.ORD_ORAINIINT = _HH_INI_INTERVENTO + ":" +	_MM_INI_INTERVENTO 	+ ":00" 
*!*			

*!*			_HH_FIN_INTERVENTO = ALLTRIM(STR(M.CHH13,2,0))
*!*			IF LEN(_HH_FIN_INTERVENTO) < 2
*!*				_HH_FIN_INTERVENTO = "0" + _HH_FIN_INTERVENTO 
*!*			ENDIF

*!*			_MM_FIN_INTERVENTO = ALLTRIM(STR(M.CMN13,2,0))
*!*			IF LEN(_MM_FIN_INTERVENTO) < 2
*!*				_MM_FIN_INTERVENTO = "0" + _MM_FIN_INTERVENTO
*!*			ENDIF
*!*			

*!*			M.ORD_ORAFININT  = _HH_FIN_INTERVENTO + ":" +	_MM_FIN_INTERVENTO 	+ ":00" 		
							
				
		
		REPLACE  ORD_ORAINIINT   WITH  M.ORD_ORAINIINT      
		REPLACE  ORD_ORAFININT   WITH  M.ORD_ORAFININT      
		REPLACE  ORD_MINPAUINT   WITH  0     
		REPLACE  ORD_RAPPORT     WITH  M.CDESPRE        
		*REPLACE  ORD_INTCLOSE	 WITH  .F.


		REPLACE  ORD_NUMORD       WITH  M.ORD_NUMORD		      
		=CAMBIADT(M.ORD_DATORD,"ORD_DATORD") 	
		
		
*!*			_HH_LAVORATE = ALLTRIM(STR(M.CTOTHH1,2,0))
*!*			IF LEN(_HH_LAVORATE) < 2
*!*				_HH_LAVORATE = "0" + _HH_LAVORATE
*!*			ENDIF

*!*			_MM_LAVORATI = ALLTRIM(STR(M.CTOTMN1,2,0))
*!*			IF LEN(_MM_LAVORATI) < 2
*!*				_MM_LAVORATI = "0" + _MM_LAVORATI
*!*			ENDIF
*!*					
*!*			M.ORD_ORELAV = VAL(_HH_LAVORATE + ',' + _MM_LAVORATI) 
		
		REPLACE  ORD_ORELAV       WITH  M.ORD_ORELAV 
		
		
*!*			_HH_PARTENZA_SEDE = ALLTRIM(STR(M.CHH11,2,0))
*!*			IF LEN(_HH_PARTENZA_SEDE) < 2
*!*				_HH_PARTENZA_SEDE = "0" + _HH_PARTENZA_SEDE
*!*			ENDIF

*!*			_MM_PARTENZA_SEDE = ALLTRIM(STR(M.CMN11,2,0))
*!*			IF LEN(_MM_PARTENZA_SEDE) < 2
*!*				_MM_PARTENZA_SEDE = "0" + _MM_PARTENZA_SEDE 
*!*			ENDIF

*!*			M.ORD_ORAPARSEDE   = _HH_PARTENZA_SEDE + ":" +	_MM_PARTENZA_SEDE + ":00" 
		
		REPLACE  ORD_ORAPARSEDE   WITH  M.ORD_ORAPARSEDE 	      

		*REPLACE  ORD_ZONA		  WITH  M.ORD_ZONA 			      
		*REPLACE  ORD_COEFFIC 	  WITH  1		      
		REPLACE  ORD_DIRIZONA  	  WITH  _DIRITTOFISSO 	      
		REPLACE  ORD_DIRICHIAMATA WITH  0	      
		REPLACE  ORD_CODDIRFIS    WITH  "" 	      
		
		**=> ERASMO - INIZIO 03/01/2024
		REPLACE ORD_ATTICLOSE WITH M.ORD_ATTICLOSE
		REPLACE ORD_SYSCOMPONENTI WITH M.ORD_SYSCOMPONENTI
		REPLACE ORD_INGARANZIA WITH .F.
		REPLACE ORD_DIRICHIAMATA WITH M.ORD_DIRICHIAMATA
		REPLACE ORD_FORFET WITH M.ORD_FORFET
		
		M.ORD_IVA = M.CIVAPRE
		**=> ERASMO - FINE 03/01/2024

		IF !ExecRW("select * from VENDITE_DT where 0=1","VENDITE_DT","W")
		   return(.f.)
		ENDIF
		
		=CREA_ARTICOLO_DA_DETTAGLIO_INTERVENTI(_AGGANCIO_AQUARIUS)
		

		SELECT MOVITECN
		SKIP +1

	ENDDO WHILE .NOT. EOF()

    =CARICA_ARTICOLI_RICAMBI(_AGGANCIO_AQUARIUS,_AGGANCIO_ASTER)
    
	=CALCOLA_TOTALE_INTERVENTO(_AGGANCIO_AQUARIUS)
	 

ENDIF


SELECT(_SXXXS)

RETURN .T.

ENDFUNC


**************************************************************************
FUNCTION CARICA_ARTICOLI_RICAMBI
**************************************************************************
LPARAMETERS _AGGANCIO_AQUARIUS,_AGGANCIO_ASTER

_SXXXXS = SELECT()

*!*	                Field        Field Name                                                            Type                                                                                                   Width                           Dec                   Index   Collate                                            Nulls                               Next                               Step
*!*	                    1        ID_MOV                                                                Character                                                                                                 10                                                                                                               No
*!*	                    2        ID_MOV_RIGO                                                           Character                                                                                                  5                                                                                                               No
*!*	                    3        CCODSCHE                                                              Character                                                                                                 20                                                                                                               No
*!*	                    4        ID_PMKEY                                                              Character                                                                                                 10                                                                                                               No
*!*	                    5        ID_RIGO                                                               Character                                                                                                  5                                                                                                               No
*!*	                    6        CDATINT                                                               Date                                                                                                       8                                                                                                               No
*!*	                    7        CDATINGIUL                                                            Character                                                                                                  6                                                                                                               No
*!*	                    8        CFLAGFAT                                                              Character                                                                                                  1                                                                                                               No
*!*	                    9        CCODART                                                               Character                                                                                                 16                                                                                                               No
*!*	                   10        CDESART                                                               Character                                                                                                 71                                                                                                               No
*!*	                   11        CCONVEN                                                               Character                                                                                                  8                                                                                                               No
*!*	                   12        CCODIVA                                                               Character                                                                                                  3                                                                                                               No
*!*	                   13        CPRZUNI                                                               Numeric                                                                                                   19                             5                                                                                 No
*!*	                   14        CQTAART                                                               Numeric                                                                                                    4                                                                                                               No
*!*	                   15        CTOTIMP                                                               Numeric                                                                                                   19                             5                                                                                 No
*!*	                   16        CCONTRATTO                                                            Character                                                                                                  3                                                                                                               No
*!*	                   17        CNATOPE                                                               Character                                                                                                  2                                                                                                               No
*!*	                   18        CTRAVMAGAZ                                                            Character                                                                                                  1                                                                                                               No
*!*	                   19        CNUMINT                                                               Numeric                                                                                                    7                             2                                                                                 No
*!*	                   20        CRAPLAV                                                               Character                                                                                                 10                                                                                                               No
*!*	                   21        CRICFIS                                                               Character                                                                                                 10                                                                                                               No
*!*	                   22        CMAG_LAV                                                              Character                                                                                                  1                                                                                                               No
*!*	                   23        CMAG_TEC                                                              Character                                                                                                  3                                                                                                               No
*!*	                   24        DT_REGIST                                                             Date                                                                                                       8                                                                                                               No
*!*	                   25        ORA_REGIST                                                            Character                                                                                                  8                                                                                                               No
*!*	                   26        CRICFISRIG                                                            Character                                                                                                  3                                                                                                               No



* -->> CREAZIONE CURSORE VUOTO
* ----------------------------
IF !EXECCOMMAND("SELECT * FROM VENDITE_DD WHERE 0=1","VENDITE_DD")
   RETURN(.F.)
ENDIF
SELECT VENDITE_DD
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_VENDITE_DD FROM ARRAY TRANSITO
INDEX ON ORD_CODSYS TAG KEY_SYS ADDITIVE    
INDEX ON ORD_SEQUEN TAG SEQUEN  ADDITIVE  



SELECT MOVIARTI
SET ORDER TO ID_RIC  

_SEEK = ALLTRIM(_AGGANCIO_ASTER)
SEEK _SEEK

IF FOUND()

	DO WHILE .NOT. EOF()

		IF DELETED()
			SELECT MOVIARTI
			SKIP +1		
			LOOP
		ENDIF

		IF ALLTRIM(_AGGANCIO_ASTER) <> ALLTRIM(ID_MOV)
			EXIT
		ENDIF

		SELECT MOVIARTI
		SCATTER MEMVAR MEMO
		
		** ACCESSO ANAGRAFICA ARTICOLO .
		M.ORD_CODART = M.CCODART
		x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "art_codpri = '" + M.ORD_CODART + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
		IF !ExecCommand(cSql,"CA_ART_PR_CURS")
		   RETURN .F.
		ENDIF
		SELECT CA_ART_PR_CURS
		GO TOP 
		IF !EOF()
		 
		 	M.ORD_CODART  = ART_CODPRI
			M.ORD_MAGA	  = ART_MAGA		 
			M.ORD_DESART  = ALLTRIM(M.CDESART)
			M.ORD_DATCON  = M.ORD_DTINIINT
			M.ORD_DES2	  = ""
			M.ORD_CLDOG   = ART_CLDOG	
			M.ORD_UM	  = ART_UNIMIS
			M.ORD_IVA	  = M.CCODIVA		&& ART_CODIVA
			M.ORD_QTAORD  = M.CQTAART
			M.ORD_PREZZO  = M.CPRZUNI		&& VALORE INTERVENTO CON IVA
			XLINEA        = ART_LINEA
			M.ORD_COORD   = ART_COORD 
			M.ORD_QTXCON  = ART_QTACON 
			M.ORD_SCORMI  = ART_SCORMI
			M.ORD_CODTAG  = ART_CODTAG    
			M.ORD_DESTAG  = ART_DESTAG    
			M.ORD_CODCOL  = ART_CODCOL    
			M.ORD_DESCOL  = ART_DESCOL    
			M.ORD_QTXCON  = ART_QTACON 
			M.ORD_CODMAT  = ART_CODMAT
			M.ORD_DESMAT  = ART_DESMAT
			M.ORD_SPESSO  = ART_SPESSO
			M.ORD_ALTEZZ  = ART_ALTEZZ
			M.ORD_LUNGHE  = ART_LUNGHE

		ELSE 

			M.ORD_MAGA	  = PUB_CODM		 
			M.ORD_DESART  = M.CDESART
			M.ORD_DATCON  = M.ORD_DTINIINT
			M.ORD_DES2	  = ""		
			M.ORD_CLDOG   = ''	
			M.ORD_UM	  = 'NR'
			M.ORD_IVA	  = '22'
			M.ORD_QTAORD  = 1		
			M.ORD_PREZZO  = M.CPRZUNI	&& VALORE INTERVENTO CON IVA
			XLINEA        = ''
			M.ORD_COORD   = ''
			M.ORD_QTXCON  = 1
			M.ORD_SCORMI  = 1
			M.ORD_CODTAG  = ''    
			M.ORD_DESTAG  = ''   
			M.ORD_CODCOL  = ''   
			M.ORD_DESCOL  = ''    
			M.ORD_QTXCON  = 1
			M.ORD_CODMAT  = ''
			M.ORD_DESMAT  = ''
			M.ORD_SPESSO  = 0
			M.ORD_ALTEZZ  = 0
			M.ORD_LUNGHE  = 0


		ENDIF

		
		M.ORD_DESART  = ALLTRIM(M.CDESART)
		M.ORD_DATCON  = M.ORD_DTINIINT
		M.ORD_DES2	  = ""
		M.ORD_IVA	  = M.CCODIVA		&& ART_CODIVA
		M.ORD_QTAORD  = M.CQTAART
*!*			M.ORD_VALORE  = M.CPRZUNI		&& VALORE INTERVENTO CON IVA


*!*			**#################################### SCORPORO IVA #######################################
*!*			X_VALOR  	 = 0
*!*			M.IVA 		 = M.ORD_IVA
*!*			DO SCORPORO_IMPOSTA WITH ABS(M.ORD_VALORE)    		&& OTTIENE L'IMPONIBILE IN X_VALOR
*!*			M.ORD_PREZZO = ROUND(X_VALOR,6) 
*!*			M.ORD_PRZNET = M.ORD_PREZZO
*!*			M.ORD_IMPOST = M.ORD_VALORE - M.ORD_PREZZO 
*!*			**#################################### SCORPORO IVA #######################################
		
		**=> ERASMO - INIZIO 03/01/2024
		M.ORD_PREZZO = M.CPRZUNI
		M.ORD_PRZNET = M.ORD_PREZZO
		M.ORD_VALORE = CALCOLA_VALORE_RIGA_DOCUMENTO(M.ORD_PRZNET,M.ORD_QTAORD)  
		**=> ERASMO - FINE 03/01/2024

		M.ORD_DATCON = RIBALTA2(M.ORD_DTPROGR)

		IF SUBSTR(M.ORD_DATCON,3,1) = '/'
		ELSE
		   M.ORD_DATCON = RIBALTA2(M.ORD_DATCON)
		ENDIF

		M.ORD_SEQUE2 = M.ORD_SEQUE2 + 10


		SELECT CU_VENDITE_DD 
		APPEND BLANK
		GATHER MEMVAR MEMO
		   
		REPLACE ID_UNIQUE 	 WITH ""
		REPLACE DAGGANCIO    WITH  _AGGANCIO_AQUARIUS
		REPLACE ORD_SEQUEN   WITH  M.ORD_SEQUE2            

		*REPLACE ORD_DETT_INT WITH  .T.			&& IMPOSTO IL FLAG PER NON GESTIRE LE RIGHE DI DETTAGLIO INTERVENTO NELLA GRIGLIA DI GESTIONE VENDITE_DD
		   
		*REPLACE ORD_CODSYS WITH M.ORD_CODSYS
		REPLACE ORD_CODSYS WITH  SYS(2015)  && ERASMO - 03/01/2024
		REPLACE ORD_CHIUSO WITH .F.
		REPLACE ORD_QTAEV  WITH 0
		 
		******************************************************************************
		REPLACE ORS_NUMORD WITH M.ORD_NUMORD
		REPLACE ORS_DATORD WITH RIBALTA2(M.ORD_DATORD)
		REPLACE ORS_MAGS   WITH M.ORD_MAGA
		REPLACE ORS_MAGD   WITH M.ORD_MAGA
		REPLACE ORS_CODCLI WITH M.ORD_CODCLI
		REPLACE ORS_RAGSOC WITH M.ORD_RAGSOC
		REPLACE ORS_CODEMI WITH ""
		REPLACE ORS_RAGEMI WITH ""
		REPLACE ORS_TIPORD WITH ""
		REPLACE ORS_DESTIN WITH ""
		REPLACE ORS_NUMORC WITH M.ORD_NUMORD
		REPLACE ORS_DATORC WITH RIBALTA2(M.ORD_DATORD)
		******************************************************************************
		  

		SELECT MOVIARTI
		SKIP +1		

	ENDDO WHILE .NOT. EOF()

	** ###################################################### AGGIORNAMENTO TABELLA VENDITE_DD #################################################### 
	SELECT CU_VENDITE_DD      
	SET ORDER TO SEQUEN
	SET FILTER TO 		 			&& SERGIO 14/06/2022 INIBIZIONE DETTAGLI TECNICI
	GO TOP

	DO WHILE .T.
	 
	   IF EOF()
	      EXIT
	   ENDIF
	   
	   IF DELETED()
	      SKIP +1
	      LOOP
	   ENDIF

	   SCATTER MEMVAR MEMO	 	 && SALVA I VECCHI VALORI
	   
	   CSQL="SELECT * FROM VENDITE_DD WHERE 1=0"
	   IF !EXECRW(CSQL,"VENDITE_DD","R")
	      RETURN(.F.)
	   ENDIF

	   SELECT VENDITE_DD
	   APPEND BLANK
	   DO VENDITE_DD
	   
	   REPLACE ORD_DETT_INT 	WITH .F.			
	   
	  
	   IF EMPTY(ORD_DATCON) .OR. ORD_DATCON = SPACE(10)
	   ELSE
	      IF SUBSTR(ORD_DATCON,3,1) = '/'
	         REPLACE ORD_DATCON WITH RIBALTA2(M.ORD_DATCON)
	      ENDIF
	   ENDIF
	   IF !EXECRW(CSQL,"VENDITE_DD","W")
	      RETURN(.F.)
	   ENDIF

	   SELECT CU_VENDITE_DD
	   SKIP +1

	ENDDO



ENDIF FOUND()




SELECT(_SXXXXS)

RETURN .T.

ENDFUNC



**************************************************************************
FUNCTION CREA_ARTICOLO_DA_DETTAGLIO_INTERVENTI
**************************************************************************
LPARAMETERS _AGGANCIO_AQUARIUS

_SXXXXZS = SELECT()


* -->> CREAZIONE CURSORE VUOTO
* ----------------------------
IF !EXECCOMMAND("SELECT * FROM VENDITE_DD WHERE 0=1","VENDITE_DD")
   RETURN(.F.)
ENDIF
SELECT VENDITE_DD
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_VENDITE_DD FROM ARRAY TRANSITO
INDEX ON ORD_CODSYS TAG KEY_SYS ADDITIVE    
INDEX ON ORD_SEQUEN TAG SEQUEN  ADDITIVE  


** ACCESSO ANAGRAFICA ARTICOLO .
M.ORD_CODART = '.'
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + M.ORD_CODART + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"CA_ART_PR_CURS")
   RETURN .F.
ENDIF
SELECT CA_ART_PR_CURS
GO TOP 
IF !EOF()
 
 	M.ORD_CODART  = ART_CODPRI
	M.ORD_MAGA	  = ART_MAGA		 
	M.ORD_DESART  = "INTERVENTO DEL " + M.ORD_DTPROGR + " DALLE ORE " + M.ORD_ORAINIPRO + " ALLE ORE " + M.ORD_ORAFINPRO 
	M.ORD_DATCON   = M.ORD_DTINIINT
	M.ORD_DES2	  = "IMPIANTO " + ALLTRIM(M.ORD_CCODSCHE) + ' Tecnico: ' + ALLTRIM(M.ORD_NOME_TECN)
	M.ORD_CLDOG   = ART_CLDOG	
	M.ORD_UM	  = ART_UNIMIS
	*M.ORD_IVA	  = ART_CODIVA
	M.ORD_QTAORD  = 1
	M.ORD_PREZZO  = M.ORD_VALPRE	&& VALORE INTERVENTO CON IVA
	XLINEA        = ART_LINEA
	M.ORD_COORD   = ART_COORD 
	M.ORD_QTXCON  = ART_QTACON 
	M.ORD_SCORMI  = ART_SCORMI
	M.ORD_CODTAG  = ART_CODTAG    
	M.ORD_DESTAG  = ART_DESTAG    
	M.ORD_CODCOL  = ART_CODCOL    
	M.ORD_DESCOL  = ART_DESCOL    
	M.ORD_QTXCON  = ART_QTACON 
	M.ORD_CODMAT  = ART_CODMAT
	M.ORD_DESMAT  = ART_DESMAT
	M.ORD_SPESSO  = ART_SPESSO
	M.ORD_ALTEZZ  = ART_ALTEZZ
	M.ORD_LUNGHE  = ART_LUNGHE

ELSE 

	M.ORD_MAGA	  = PUB_CODM		 
	M.ORD_DESART  = "INTERVENTO DEL " + M.ORD_DTPROGR + " DALLE ORE " + M.ORD_ORAINIPRO + " ALLE ORE " + M.ORD_ORAFINPRO 
	M.ORD_DATCON   = M.ORD_DTINIINT
	M.ORD_DES2	  = "IMPIANTO " + ALLTRIM(M.ORD_CCODSCHE) + ' Tecnico: ' + ALLTRIM(M.ORD_NOME_TECN)		
	M.ORD_CLDOG   = ''	
	M.ORD_UM	  = 'NR'
	*M.ORD_IVA	  = '22'
	M.ORD_QTAORD  = 1		
	M.ORD_PREZZO  = M.ORD_VALPRE	&& VALORE INTERVENTO CON IVA
	XLINEA        = ''
	M.ORD_COORD   = ''
	M.ORD_QTXCON  = 1
	M.ORD_SCORMI  = 1
	M.ORD_CODTAG  = ''    
	M.ORD_DESTAG  = ''   
	M.ORD_CODCOL  = ''   
	M.ORD_DESCOL  = ''    
	M.ORD_QTXCON  = 1
	M.ORD_CODMAT  = ''
	M.ORD_DESMAT  = ''
	M.ORD_SPESSO  = 0
	M.ORD_ALTEZZ  = 0
	M.ORD_LUNGHE  = 0


ENDIF



*!*	**#################################### SCORPORO IVA #######################################
*!*	X_VALOR  	 = 0
*!*	M.IVA 		 = M.ORD_IVA
*!*	DO SCORPORO_IMPOSTA WITH ABS(M.ORD_VALPRE)    		&& OTTIENE L'IMPONIBILE IN X_VALOR
*!*	M.ORD_PREZZO = ROUND(X_VALOR,6) 
*!*	M.ORD_IMPOST = M.ORD_VALPRE - M.ORD_PREZZO 
*!*	   
M.ORD_PRZNET = M.ORD_PREZZO
M.ORD_VALORE = M.ORD_PREZZO
*!*	**#################################### SCORPORO IVA #######################################

M.ORD_DATCON = RIBALTA2(M.ORD_DTPROGR)

IF SUBSTR(M.ORD_DATCON,3,1) = '/'
ELSE
   M.ORD_DATCON = RIBALTA2(M.ORD_DATCON)
ENDIF

M.ORD_SEQUE2 = M.ORD_SEQUE2 + 10


SELECT CU_VENDITE_DD 
APPEND BLANK
GATHER MEMVAR MEMO
   
REPLACE ID_UNIQUE 	 WITH ""
REPLACE DAGGANCIO    WITH  _AGGANCIO_AQUARIUS
REPLACE ORD_SEQUEN   WITH  M.ORD_SEQUE2            

REPLACE ORD_DETT_INT WITH  .T.			&& IMPOSTO IL FLAG PER NON GESTIRE LE RIGHE DI DETTAGLIO INTERVENTO NELLA GRIGLIA DI GESTIONE VENDITE_DD
   
*REPLACE ORD_CODSYS WITH M.ORD_CODSYS
REPLACE ORD_CODSYS WITH SYS(2015)  && ERASMO - 03/01/2024
REPLACE ORD_CHIUSO WITH .F.
REPLACE ORD_QTAEV  WITH 0
 
******************************************************************************
REPLACE ORS_NUMORD WITH M.ORD_NUMORD
REPLACE ORS_DATORD WITH RIBALTA2(M.ORD_DATORD)
REPLACE ORS_MAGS   WITH M.ORD_MAGA
REPLACE ORS_MAGD   WITH M.ORD_MAGA
REPLACE ORS_CODCLI WITH M.ORD_CODCLI
REPLACE ORS_RAGSOC WITH M.ORD_RAGSOC
REPLACE ORS_CODEMI WITH ""
REPLACE ORS_RAGEMI WITH ""
REPLACE ORS_TIPORD WITH ""
REPLACE ORS_DESTIN WITH ""
REPLACE ORS_NUMORC WITH M.ORD_NUMORD
REPLACE ORS_DATORC WITH RIBALTA2(M.ORD_DATORD)
******************************************************************************
  
SCATTER MEMVAR MEMO 

  

** ######################################################## CREA UNA RIGA DI COMMENTO VUOTA ################################################

SELECT CU_VENDITE_DD 
APPEND BLANK
  
M.ORD_SEQUE2 = M.ORD_SEQUE2 + 10

M.ORD_CODART = SPACE(16)
M.ORD_MAGA   = SPACE(06)   
M.ORD_DESART = "*** COMMENTO ***"    
M.ORD_CODICE = ""
M.ORS_CODCLI = M.ORD_CODCLI    
  
GATHER MEMVAR MEMO

  
******************************************************************************

REPLACE ID_UNIQUE 	    WITH ""
REPLACE DAGGANCIO       WITH _AGGANCIO_AQUARIUS
REPLACE ORD_SEQUEN    	WITH M.ORD_SEQUE2            
REPLACE ORD_DETT_INT 	WITH .T.			&& IMPOSTO IL FLAG PER NON GESTIRE LE RIGHE DI DETTAGLIO INTERVENTO NELLA GRIGLIA DI GESTIONE VENDITE_DD

REPLACE ORD_QTAEV  		WITH 0
REPLACE ORD_QTAORD  	WITH 0
REPLACE ORD_PREZZO  	WITH 0
REPLACE ORD_PRZNET  	WITH 0
REPLACE ORD_VALORE  	WITH 0
 
REPLACE ORS_NUMORD WITH M.ORD_NUMORD
REPLACE ORS_DATORD WITH RIBALTA2(M.ORD_DATORD)
REPLACE ORS_MAGS   WITH M.ORD_MAGA
REPLACE ORS_MAGD   WITH M.ORD_MAGA
REPLACE ORS_CODCLI WITH M.ORD_CODCLI
REPLACE ORS_RAGSOC WITH M.ORD_RAGSOC
REPLACE ORS_CODEMI WITH ""
REPLACE ORS_RAGEMI WITH ""
REPLACE ORS_TIPORD WITH ""
REPLACE ORS_DESTIN WITH ""
REPLACE ORS_NUMORC WITH M.ORD_NUMORD
REPLACE ORS_DATORC WITH RIBALTA2(M.ORD_DATORD)
******************************************************************************
 
** ###################################################### AGGIORNAMENTO TABELLA VENDITE_DD #################################################### 
SELECT CU_VENDITE_DD      
SET ORDER TO SEQUEN
SET FILTER TO 		 			&& SERGIO 14/06/2022 INIBIZIONE DETTAGLI TECNICI
GO TOP

DO WHILE .T.
 
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO	 	 && SALVA I VECCHI VALORI
   
   CSQL="SELECT * FROM VENDITE_DD WHERE 1=0"
   IF !EXECRW(CSQL,"VENDITE_DD","R")
      RETURN(.F.)
   ENDIF

   SELECT VENDITE_DD
   APPEND BLANK
   DO VENDITE_DD
   
   REPLACE ORD_DETT_INT 	WITH .T.			&& IMPOSTO IL FLAG PER NON GESTIRE LE RIGHE DI DETTAGLIO INTERVENTO NELLA GRIGLIA DI GESTIONE VENDITE_DD
   
  
   IF EMPTY(ORD_DATCON) .OR. ORD_DATCON = SPACE(10)
   ELSE
      IF SUBSTR(ORD_DATCON,3,1) = '/'
         REPLACE ORD_DATCON WITH RIBALTA2(M.ORD_DATCON)
      ENDIF
   ENDIF
   IF !EXECRW(CSQL,"VENDITE_DD","W")
      RETURN(.F.)
   ENDIF

   SELECT CU_VENDITE_DD
   SKIP +1

ENDDO




SELECT(_SXXXXZS)

RETURN .T.

ENDFUNC

**************************************************************************
FUNCTION CALCOLA_TOTALE_INTERVENTO
**************************************************************************
LPARAMETERS _AGGANCIO_AQUARIUS

_SXXXXZSW = SELECT()



	** ###################################################### RICREA IL CURSORE CON I DETAGLI #################################################### 

	* -->> CREAZIONE CURSORE VUOTO
	* ----------------------------
	IF !EXECCOMMAND("SELECT * FROM VENDITE_DD WHERE 0=1","VENDITE_DD")
	   RETURN(.F.)
	ENDIF
	SELECT VENDITE_DD
	=DEFPUB(SELECT())
	SCATTER MEMVAR MEMO BLANK
	HH=AFIELDS(TRANSITO)
	CREATE CURSOR CU_VENDITE_DD FROM ARRAY TRANSITO
	INDEX ON ORD_CODSYS TAG KEY_SYS ADDITIVE    
	INDEX ON ORD_SEQUEN TAG SEQUEN  ADDITIVE  


   *   ZAP CURSORE
   SELECT CU_VENDITE_DD
   ZAP
   x_aggan = "daggancio = '" + _AGGANCIO_AQUARIUS + "'"
   cSql="SELECT * FROM VENDITE_DD WHERE " + x_aggan
   IF !ExecCommand(cSql,"VENDITE_DD")
      return(.f.)
   ENDIF 
   SELECT VENDITE_DD
   GO TOP
   DO WHILE .T. 
      IF EOF()
         EXIT
      ENDIF
   	  IF DELETED()
  	     SKIP +1
		 LOOP
	  ENDIF
	  
  	  SELECT VENDITE_DD
  	  
  	  SCATTER MEMVAR MEMO	    && SALVA I VECCHI VALORI

 	  SELECT CU_VENDITE_DD
	  APPEND BLANK
	  GATHER MEMVAR MEMO		&& SALVA LE MODIFICHE
	  
      IF EMPTY(ORD_DATCON) .OR. ORD_DATCON = SPACE(10)
      ELSE
         IF SUBSTR(ORD_DATCON,5,1) = '/'
            REPLACE ORD_DATCON WITH RIBALTA2(M.ORD_DATCON)
         ENDIF
      ENDIF
*!*	      IF !EMPTY(IVA_ESE) 
*!*	         REPLACE ORD_IVA    WITH IVA_ESE
*!*	      ENDIF	
      
*!*	      ******************************************************************************
*!*	      REPLACE ORS_NUMORD WITH X_NUMORD
*!*	      REPLACE ORS_DATORD WITH X_DATORD
*!*	      REPLACE ORS_MAGS   WITH X_MAGS
*!*	      REPLACE ORS_MAGD   WITH X_MAGD
*!*	      REPLACE ORS_CODCLI WITH X_CODCLI
*!*	      REPLACE ORS_RAGSOC WITH X_RAGSOC
*!*	      REPLACE ORS_CODEMI WITH X_CODEMI
*!*	      REPLACE ORS_RAGEMI WITH X_RAGEMI
*!*	      REPLACE ORS_TIPORD WITH X_TIPORD
*!*	      REPLACE ORS_DESTIN WITH X_DESTIN
*!*		  REPLACE ORS_NUMORC WITH X_NUMORD
*!*		  REPLACE ORS_DATORC WITH X_DATORD      
*!*	      ******************************************************************************
      
      
      
	  SELECT VENDITE_DD
	  SKIP +1
	  
   ENDDO




	** ###################################################### RICALCOLA VALORE TOTALE DOCUMENTO #################################################### 

	M.ORD_SPBOLL = 0
	M.ORD_SPTRAS = 0
	M.T_IMPONIB = 0
	M.T_IMPOSTA = 0
	M.T_VALORE  = 0
	MATPUBX     = 0

	M.T_ENPACL  = 0
	M.T_RA      = 0
	M.T_NETTO   = 0

	SELECT CU_VENDITE_DD
	GO TOP
	
	DO CALCINR
	M.ORD_VALPRE = M.ORD_VALORE		&& IL VALORE PREVISTO E' UGUALE AL VALORE TOTALE DELL'INTERVENTO SINO A CHE IL TECNICO NON AGGIORNA VIA WEB L'INTERVENTO STESSO AGGIUNGENDO UNA RIGA DI DETTAGLIO CON I PEZZI SOSTITUITI


	V_SEEK   = _AGGANCIO_AQUARIUS
	V_CHIAVE = "TAGGANCIO"
	CSQL="SELECT * FROM VENDITE_TT WHERE " + V_CHIAVE + " = '" + V_SEEK + "'"
	IF !EXECRW(CSQL,"VENDITE_TT","R")
	   RETURN(.F.)
	ENDIF
	SELECT VENDITE_TT
	IF RECCOUNT() <> 0
	   REPLACE ORD_VALORE WITH M.T_VALORE
	   REPLACE LINKINTE WITH PUB_LINKINTE  && ERASMO - 09/01/2024
	ENDIF
	IF !EXECRW(CSQL,"VENDITE_TT","W")
	   RETURN(.F.)
	ENDIF
	 
	 


SELECT(_SXXXXZSW)

RETURN .T.

ENDFUNC