DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno   = '" + PUB_ANNO + "'"

_REPLACE = SPACE(10)
CSQL="UPDATE U_OFF_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno
IF !ExecCommand(CSQL,"U_OFF_TT")
   RETURN (.f.)
ENDIF

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno   = '" + PUB_ANNO + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_ordi = "ord_chiuso = '0'"
x_clie = "ord_codcli = '" + ALLTRIM(CLIDAL) + "'"

IF EMPTY(CLIDAL) .OR. CLIDAL = SPACE(10)
   cSql="select * from u_off_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " order by ord_codsoc,ord_anno,ord_numord"
ELSE
   cSql="select * from u_off_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_clie + " order by ord_codsoc,ord_anno,ord_numord"
ENDIF

IF !ExecRW(cSql,"U_OFF_TT","R")
   return(.f.)
ENDIF

SELECT U_OFF_TT
GO TOP
IF EOF()
   =MESSAGEBOX("Nessuna offerta da elaborare",16,"Attenzione")
   RETURN
ENDIF

ON KEY LABEL ENTER DO CHK2
ON KEY LABEL F DO CHKR
ON KEY LABEL RIGHTMOUSE DO CHKR                                                                                                                                                                                                                                                                                        

BROWSE FIELDS SELEZIONE:10:H='SELEZIONE',ORD_CODCLI:10:H='CLIENTE', ;
   ORD_RAGSOC:35:H='RAGIONE SOCIALE',ORD_DATORD:15:H='DATA ORDINE', ; 
   ORD_NUMORD:15:H='NUM.ORDINE' TITLE "Elenco offerte estratte: INVIO=SELEZIONA/DESELEZIONA - ESC=FINE" NOMENU NOEDIT NODELETE WINDOW WSELESOC
PUSH KEY CLEAR

SELECT U_OFF_TT
GO TOP

V_EVASIONE = 0
V_EVASPARZ = 0

DO WHILE .T.
  
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   IF SELEZIONE <> '=>'
      SKIP +1
      LOOP
   ENDIF

   AGGA    = TAGGANCIO
   VRAGSOC = ALLTRIM(ORD_RAGSOC)
   VNUMORD = ORD_NUMORD
   VDATORD = RIBALTA2(ORD_DATORD)
  
   x_agga = "daggancio = '" + ALLTRIM(AGGA) + "'"
   x_comm = "ord_desart != '*** COMMENTO ***'"
   x_cond = x_agga + " and " + x_comm
   Csql   = "select * from u_off_dd where " + x_cond + " order by daggancio"
   IF !ExecRW(cSql,"U_OFF_DD","R")
      return(.f.)
   ENDIF
   SELECT U_OFF_DD
   GO TOP
   
   BROWSE FIELDS ORD_CODART:16:H='COD.ARTICOLO':R, ;
                 ORD_DESART:35:H='DESCRIZIONE':R    , ;
                 ORD_QTAORD:15:H='OFFERTO':R       , ; 
                 ORD_QTAEV :15:H='IN ORDINE':R          , ;
                 ORD_QTADEV:15:H='PER ORDINE' TITLE 'Cliente: '+VRAGSOC+' - ordine: '+VNUMORD+' del '+vdatord NOMENU NODELETE WINDOW WSELESOC

   SELECT U_OFF_DD
   GO TOP

   V_EVASPARZ = 0
  
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      V_EVASIONE = V_EVASIONE + ORD_QTADEV
      V_EVASPARZ = V_EVASPARZ + ORD_QTADEV
      SKIP +1
   ENDDO

   IF !ExecRW(cSql,"U_OFF_DD","W")
      return(.f.)
   ENDIF
                
   SELECT U_OFF_TT

   IF V_EVASPARZ<>0
      REPLACE ORD_PRONTO WITH .T.
   ENDIF
  
   SKIP +1              

ENDDO

IF V_EVASIONE<>0
   OK_PROC = .T.
ELSE
   OK_PROC = .F.
ENDIF

RELEASE WINDOWS WSELESOC

IF !ExecRW(cSql,"U_OFF_TT","W")
   return(.f.)
ENDIF

RETURN