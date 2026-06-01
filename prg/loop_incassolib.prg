**************************************************************************
PROCEDURE GESTIONE_LOOPINCASSO  		 && SCARICA IL MAGAZZINO E I SALDI
**************************************************************************

IF !ExecCommand("select * from u_pdv_ca where 1=0","CU_PDV_CA")
   return(.f.)
ENDIF

Csql   = "select TOP 1 * from u_pdv_ca"
IF !ExecCommand(cSql,"U_PDV_CA")
   return(.f.)
ENDIF

SELECT u_pdv_ca
GO top
IF EOF()
   RETURN
ENDIF

x_maga = "CAS_CODMAG = '" + ALLTRIM(CAS_CODMAG) + "'"
x_prog = "CAS_PROGRE = '" + ALLTRIM(CAS_PROGRE) + "'"
x_data = "CAS_DATOPE = '" + ALLTRIM(CAS_DATOPE) + "'"
x_orao = "CAS_ORAOPE = '" + ALLTRIM(CAS_ORAOPE) + "'"
x_cond = x_maga + " and " + x_prog + " and " + x_data + " and " + x_orao 

Csql   = "select * from u_pdv_ca where " + x_cond + " order by cas_codmag,cas_progre,cas_datope,cas_oraope"
IF !ExecCommand(cSql,"U_PDV_CA")
   return(.f.)
ENDIF

SELECT U_PDV_CA
GO TOP
IF EOF()
   RETURN
ENDIF

PUB_CODCAS = '003'
SS=SELECT()
v_seek   = 'NUMNRC' + PUB_CODCAS
v_chiave = "codice"
cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   X_PROGRE = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
ELSE
   APPEND BLANK
   REPLACE CODICE WITH 'NUMNRC' + PUB_CODCAS
   V2= 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   X_PROGRE = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF
SELECT(SS)
X_DATOPE = RIBALTA2(DTOC(DATE()))
X_ORAOPE = TIME()
PUB_LNO  = 6
X_PROGRE = TRC(PUB_LNO,ALLTRIM(X_PROGRE))

SELECT U_PDV_CA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   M.ID_UNIQUE  = ""
   M.CAS_CODCAS = PUB_CODCAS
   M.CAS_PROGRE = X_PROGRE
   M.CAS_DATOPE = X_DATOPE
   M.CAS_ORAOPE = X_ORAOPE
   M.CAS_FLGTRA = .F.
   M.CAS_FLGAGG = .F.
   M.CAS_NUMAGG = 0
   M.CAS_FLGAGG = .F.
   
   SELECT CU_PDV_CA
   APPEND BLANK
   GATHER MEMVAR MEMO
   
   SELECT U_PDV_CA
   SKIP +1
   
ENDDO

IF !ExecRW('','u_pdv_ca','I','','CU_PDV_CA')
   return(.f.)
ENDIF
 
RETURN


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

***********************************************************************
* Funzione - TRC     Data: 18.03.97   Autore: Project
***********************************************************************
*
*  AGGIUNGE ZERI INIZIALI AD UN NUMERO IN FORMATO CARATTERE
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION TRC
**************************
PARA _LUN,_COD

_COD=ALLTRIM(_COD)
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

_LUN1=_LUN - LEN(_COD)
_OUT=REPLICATE('0',_LUN1)+_COD

RETURN(_OUT)

