DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno   = '" + PUB_ANNO + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_ordi = "ord_chiuso = '0'"
x_pron = "ord_pronto = '0'"
x_cage = "ord_codcli = '" + ALLTRIM(CLIDAL) + "'"

_REPLACE = SPACE(10)
IF EMPTY(CLIDAL) .OR. CLIDAL = SPACE(10)
   CSQL="UPDATE U_ORD_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_pron
ELSE
   CSQL="UPDATE U_ORD_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_pron + " and " + x_cage
ENDIF
IF !ExecCommand(CSQL,"U_ORD_TT")
   RETURN (.f.)
ENDIF

IF EMPTY(CLIDAL) .OR. CLIDAL = SPACE(10)
   cSql="select * from u_ord_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_pron + " order by ord_codsoc,ord_anno,ord_numord"
ELSE
   cSql="select * from u_ord_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_pron + " and " + x_cage + " order by ord_codsoc,ord_anno,ord_numord"
ENDIF

IF !ExecRW(cSql,"U_ORD_TT","R")
   return(.f.)
ENDIF
SELECT U_ORD_TT
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun ordine da elaborare",16,"Attenzione")
   RETURN
ENDIF
  
ON KEY LABEL ENTER DO CHK2
ON KEY LABEL F DO CHKR
ON KEY LABEL RIGHTMOUSE DO CHKR                                                                                                                                                                                                                                                                                        

BROWSE FIELDS SELEZIONE:10:H='SELEZIONE',ORD_CODCLI:10:H='CLIENTE', ;
   ORD_RAGSOC:35:H='RAGIONE SOCIALE',ORD_DATORD:15:H='DATA ORDINE', ; 
   ORD_NUMORD:15:H='NUM.ORDINE' TITLE "Elenco ordini estratti: INVIO=SELEZIONA/DESELEZIONA - ESC=FINE" NOMENU NOEDIT NODELETE WINDOW WSELESOC
PUSH KEY CLEAR

SELECT U_ORD_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   IF SELEZIONE <> '=>'
      SELECT U_ORD_TT
      SKIP +1
      LOOP
   ENDIF
 
   AGGA    = TAGGANCIO
   VRAGSOC = ALLTRIM(ORD_RAGSOC)
   VNUMORD = ORD_NUMORD
   VDATORD = RIBALTA2(ORD_DATORD)
  
   x_cond = "daggancio = '" + ALLTRIM(AGGA) + "'"
   Csql   = "select * from u_ord_dd where " + x_cond + " order by daggancio"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   GO TOP
  
   BROWSE FIELDS ORD_CODART:16:H='COD. ARTICOLO':R, ;
                 ORD_DESART:35:H='DESCRIZIONE':R    , ;
                 ORD_QTAORD:15:H='ORDINATO':R       , ; 
                 ORD_QTAEV :15:H='EVASO':R          , ;
                 ORD_QTADEV:15:H='DA EVADERE' TITLE 'Cliente: '+VRAGSOC+' - ordine: '+VNUMORD+' del '+vdatord NOMENU NODELETE WINDOW WSELESOC
                
   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF

   SELECT U_ORD_TT
   REPLACE ORD_PRONTO WITH .T.
  
   SKIP +1              
ENDDO

IF !ExecRW(cSql,"U_ORD_TT","W")
   return(.f.)
ENDIF

RELEASE WINDOWS WSELESOC

WAIT WINDOW "Operazione conclusa correttamente..."	

RETURN