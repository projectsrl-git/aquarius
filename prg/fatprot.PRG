**********************************************************************
*  RIPROTOCOLLA LE FATTURE CLIENTI 				 				     *
**********************************************************************
x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + SUBSTR(DATADAL,7,4) + "'"
x_data = "ord_datord >= '" + RIBALTA2(DATADAL) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_data

*x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
*x_dt1  = RIBALTA2(DATADAL)
*x_dt2  = RIBALTA2(DATAAL)
*x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
*x_npro = "ord_nprot = ''"
*x_cond = x_soci + " and " + x_data + " and " + x_npro

cSql="select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
IF !ExecRW(cSql,"U_FAT_TT","R")
   return(.f.)
ENDIF

SELECT U_FAT_TT
GO TOP
IF EOF()
   =MESSAGEBOX("Nessuna fattura da elaborare",16,"Attenzione")
   RETURN
ENDIF

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CT = 0
CTRELAB = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD <= RIBALTA2(DATAAL)
   ELSE
      EXIT
   ENDIF
 
   IF EMPTY(ORD_NPROT) .OR. ORD_NPROT = SPACE(06)
   ELSE
      SKIP +1
      LOOP
   ENDIF

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

   SELECT U_FAT_TT
   REPLACE ORD_NPROT WITH NPROT
   CT = CT + 1
   SKIP + 1
   
ENDDO

IF !ExecRW(cSql,"U_FAT_TT","W")
   return(.f.)
ENDIF

=MESSAGEBOX("Fine elaborazione",64,"ATTENZIONE")

RELEASE WINDOW DISPLAY