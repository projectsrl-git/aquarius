**********************************************************************
*  RIPROTOCOLLA LE FATTURE CLIENTI 				 				     *
*																	 *
**********************************************************************

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno   = '" + PUB_ANNO + "'"

_REPLACE = SPACE(10)
CSQL="UPDATE U_FAP_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno
IF !ExecCommand(CSQL,"U_FAP_TT")
   RETURN (.f.)
ENDIF

x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"

_REPLACE = '=>'
CSQL="UPDATE U_FAP_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno + " and " + x_data
IF !ExecCommand(CSQL,"U_FAP_TT")
   RETURN (.f.)
ENDIF

x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql="select * from u_fap_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
IF !ExecRW(cSql,"U_FAP_TT","R")
   return(.f.)
ENDIF

SELECT U_FAP_TT
GO TOP
IF EOF()
   =MESSAGEBOX("Nessuna fattura da elaborare",16,"Attenzione")
   RETURN
ENDIF

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CT      = 0
CTRELAB = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   IF ALLTRIM(SELEZIONE )<> '=>'
      SELECT U_FAP_TT
      SKIP +1
      LOOP
   ENDIF

   IF EMPTY(ORD_NPROT) .OR. ORD_NPROT = SPACE(06)    && scarto fatture gia' protocollate
   ELSE
      SELECT U_FAP_TT
      SKIP +1
      LOOP
   ENDIF
  
*  IF ALLTRIM(ORD_PERIF) = 'S'          && prelevo il progressivo fattura PER FAP.AGE
   CTRELAB = CTRELAB + 1 
   =CONTATORE("Fatture Elaborate",CTRELAB)

   NPROT = SPACE(06)

   x_codi = "codice = 'NUMPRC' + '" + PUB_CODSOC + "'"
   cSql="select * from para where " + x_codi
   IF !ExecRW(cSql,"PARA","R")
      return(.f.)
   ENDIF

   SELECT PARA
   GO TOP
   IF EOF()
      RIT = MSGBOX('Parametro numero fattura non trovato','ATTENZIONE',31)
      RETURN
   ENDIF   

   V2 = VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   NPROT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))

   IF !ExecRW(cSql,"PARA","W")
      return(.f.)
   ENDIF

   SELECT U_FAP_TT
   REPLACE ORD_NPROT WITH NPROT
 
   CT = CT +1
   SKIP +1

ENDDO

IF !ExecRW(cSql,"U_FAP_TT","W")
   return(.f.)
ENDIF

=MESSAGEBOX("Fine elaborazione",64,"ATTENZIONE")

RELEASE WINDOW DISPLAY