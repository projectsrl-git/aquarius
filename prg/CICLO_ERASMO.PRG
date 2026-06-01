PARAMETERS V_TIPO,NUMERO_LOTTO

* V_TIPO = 1  ==> A RITROSO
* V_TIPO = 2  ==> IN AVANTI

V_LIVELL = V_LIVELL + 1

V_IND_N       = V_IND_N + 1
V_IND_X       = STR(V_IND_N,4,0)
PUB_LNO       = 4
V_IND_X       = TRC(PUB_LNO,ALLTRIM(V_IND_X))
V_NOM&V_IND_X = "U_LOT" + V_IND_X

LOCAL V_NOMECURSORE
V_NOMECURSORE = "U_LOT" + V_IND_X

x_soci = "lot_codsoc = '" + PUB_CODSOC + "'"

IF V_TIPO = 1

   V_NLOINI = NUMERO_LOTTO
   x_nlot   = "lot_nlofin = " + V_NLOINI

ELSE

   V_NLOFIN = NUMERO_LOTTO
   x_nlot   = "lot_nloini = " + V_NLOFIN

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

SCAN
   SCATTER MEMVAR
   SELECT &V_NOM&V_IND_X
   APPEND BLANK
   GATHER MEMVAR
   REPLACE LOT_LIVELL WITH V_LIVELL
ENDSCAN
                              
SELECT &V_NOM&V_IND_X

GO TOP

DO WHILE .T.

   IF EOF()
      V_LIVELL = V_LIVELL - 1
      RETURN
   ENDIF
   
   IF LOT_NLOINI = LOT_NLOFIN
      SKIP +1
      LOOP
   ENDIF

   IF V_TIPO = 1
      NUMERO_LOTTO = ALLTRIM(STR(LOT_NLOINI,10,0)) 
   ELSE
      NUMERO_LOTTO = ALLTRIM(STR(LOT_NLOFIN,10,0)) 
   ENDIF   
   
   DO PRG\CICLO_ERASMO WITH V_TIPO,NUMERO_LOTTO

   && USCITA RICORSIVITA'
   SELECT &V_NOMECURSORE
   SKIP +1
   
ENDDO