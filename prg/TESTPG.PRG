

V_SEEK	 = 'TMP'+ALLTRIM(__TIPO_MANU)
V_CHIAVE ="CODICE"
IF SEEK_STD('PARA',V_SEEK,V_CHIAVE,'CUR_PARA')
   	SELECT CUR_PARA
	_CODICE = ALLTRIM(SUBSTR(CODICE,1,10))
	V_COD   = SUBSTR(CODICE,4,6)
 ELSE
	_CODICE = ""
	V_COD   = ""
ENDIF

*** CARICAMENTO TABELLA DATI AGGIUNTIVI PARANEW
x_codi = "CODICE = '" + _CODICE + "'"
x_cond = x_codi
cSql = "select * from PARANEW where " + x_cond
IF !ExecCommand(cSql,"PARANEW")
	RETURN .F.
ENDIF
SELECT PARANEW
IF !EOF()
	V_A   = PAR_A
	V_B   = PAR_B
	V_C   = PAR_C
	V_D   = PAR_D
	V_E   = PAR_E
	V_F   = PAR_F
	V_G   = PAR_G
	V_H   = PAR_H
ELSE
	V_A   = .F.
	V_B   = .F.
	V_C   = .F.
	V_D   = .F.
	V_E   = .F.
	V_F   = .F.
	V_G   = .F.
	V_H   = .F.
ENDIF   








X_CODI = "SUBSTRING(CODICE,1,3) = 'TMP'"
X_LIBE = "ALLTRIM(SUBSTRING(LIBERA,1,50))"
X_LIBE = "1=1"

X_COND = X_CODI + " AND " + X_LIBE
CSQL   = "SELECT * FROM PARA WHERE " + X_COND + " ORDER BY CODICE"
IF !EXECCOMMAND(CSQL,"CUR_PARAM")
   RETURN .F.
ENDIF


V_TROV   = .F.

SELECT CUR_PARAM
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   _CODICE = "TMP"+ALLTRIM(__TIPO_MANU)
   V_COD = SUBSTR(CODICE,4,6)
   V_DES = DESCRI
   V_LIB = SUBSTR(LIBERA,1,20)
   V_RAG = ALLTRIM(DTIPOMOV)


