PARAMETERS V_TIPO

* V_TIPO = 1  ==> A RITROSO
* V_TIPO = 2  ==> IN AVANTI

IF lot_nloini = lot_nlofin
   && SELEZIONO L'ULTIMO CURSORE VALIDO ANCORA DA SCORRERE
   IF VAL(SUBSTR(V_LAST_VALID_CUR,6,3)) > 1
	  SELECT &V_LAST_VALID_CUR
	  V_LIVELL = LOT_LIVELL
      RETURN
   ELSE
      RETURN
   ENDIF
ENDIF



V_IND_N       = V_IND_N + 1
V_IND_X       = STR(V_IND_N,3,0)
PUB_LNO       = 3
V_IND_X       = TRC(PUB_LNO,ALLTRIM(V_IND_X))
V_NOM&V_IND_X = "U_LOT" + V_IND_X


x_soci = "lot_codsoc = '" + PUB_CODSOC + "'"

IF V_TIPO = 1

   V_NLOINI = lot_nloini
   x_nlot   = "lot_nlofin = " + STR(V_NLOINI,10,0)

ELSE

   V_NLOFIN = lot_nlofin
   x_nlot   = "lot_nloini = " + STR(V_NLOFIN,10,0)

ENDIF

x_cond = x_soci + " and " + x_nlot
cSql   = "select * from u_lot_ri where " + x_cond

IF !ExecCommand(cSql,"U_LOT_CC")
   return(.f.)
ENDIF

CREATE CURSOR &V_NOM&V_IND_X (LOT_CODSOC C(2),  LOT_NLOINI N(10,0), LOT_DATOPE C(10), ;
                              LOT_ORAOPE C(8),  LOT_MAGSCA C(6),    LOT_MAGCAR C(6),  ;
                              LOT_CODCAU C(10),  LOT_NLOFIN N(10,0), LOT_CODMAT C(5),  ;
                              LOT_DESMAT C(60), LOT_LIVELL N(2,0))
SELECT U_LOT_CC
GO TOP

V_LIVELL = V_LIVELL + 1  &&FASE ASCENDENTE LIVELLO PROCEDURA RICORSIVA

SCAN
   SCATTER MEMVAR
   SELECT &V_NOM&V_IND_X
   APPEND BLANK
   GATHER MEMVAR
   REPLACE LOT_LIVELL WITH V_LIVELL
ENDSCAN
                              
SELECT &V_NOM&V_IND_X

IF RECCOUNT()> 1 .AND. lot_nloini != lot_nlofin
   V_LAST_VALID_CUR = V_NOM&V_IND_X
ENDIF

GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
      
   DO PRG\CICLO WITH V_TIPO
   
   IF EOF()  
      V_INDICE_ATTUALE = VAL(SUBSTR(V_LAST_VALID_CUR,6,3))
      V_INDICE_ATTUALE = V_INDICE_ATTUALE - 1
      V_INDICE_ATT_STR = STR(V_INDICE_ATTUALE,3,0)
      PUB_LNO          = 3
      V_INDICE_ATT_STR = TRC(PUB_LNO,ALLTRIM(V_INDICE_ATT_STR))
      V_LAST_VALID_CUR = "U_LOT" + V_INDICE_ATT_STR
	  IF VAL(SUBSTR(V_LAST_VALID_CUR,6,3)) > 1
	     SELECT &V_LAST_VALID_CUR
	     V_LIVELL = LOT_LIVELL
	     IF EOF()
            EXIT
         ENDIF
	  ELSE
         EXIT
      ENDIF
   ENDIF
   
   SKIP +1
   
ENDDO


RETURN