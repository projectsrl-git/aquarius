DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 15,80;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno   = '" + PUB_ANNO + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_ordi = "ord_chiuso = '0'"
x_clie = "ord_codcli = '" + ALLTRIM(CLIDAL) + "'"

_REPLACE = SPACE(10)
IF EMPTY(CLIDAL) .OR. CLIDAL = SPACE(10)
   CSQL="UPDATE U_ORD_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi
ELSE
   CSQL="UPDATE U_ORD_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_clie
ENDIF
IF !ExecCommand(CSQL,"U_ORD_TT")
   RETURN (.f.)
ENDIF

IF EMPTY(CLIDAL) .OR. CLIDAL = SPACE(10)
   cSql="select * from u_ord_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi
ELSE
   cSql="select * from u_ord_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_clie
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
ORD_NUMORD:12:H='NUM.ORDINE' TITLE "Elenco ordini estratti: INVIO=SELEZIONA/DESELEZIONA - ESC=FINE" NOMENU  NODELETE NOEDIT WINDOW WSELESOC
 
PUSH KEY CLEAR

V_EVASIONE = 0
V_EVASPARZ = 0

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
  
   x_dagg = "daggancio = '" + ALLTRIM(AGGA) + "'"
   x_comm = "ord_desart <> '*** COMMENTO ***'"
   x_cond = x_dagg + " and " + x_comm
   cSql   = "select * from u_ord_dd where " + x_cond + " order by daggancio"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   GO TOP

   BROWSE FIELDS ORD_CODART:16:H='COD. ARTICOLO':R, ;
                 ORD_DESART:35:H='DESCRIZIONE':R    , ;
                 ORD_QTAORD:10:H='ORDINATO':R       , ; 
                 ORD_QTAEV :10:H='EVASO':R          , ;
                 ORD_QTADEV:10:H='DA EVADERE' TITLE 'Cliente: '+VRAGSOC+' - ordine: '+VNUMORD+' del '+vdatord NOMENU WINDOW WSELESOC

   SELECT U_ORD_DD
   GO TOP

   V_EVASPARZ = 0
  
   DO WHILE .T.
      
      IF EOF()
         EXIT
      ENDIF
      
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
      
      V_EVASIONE = V_EVASIONE + ORD_QTADEV
      V_EVASPARZ = V_EVASPARZ + ORD_QTADEV
 
      SKIP +1  

   ENDDO                  

   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF
                
   SELECT U_ORD_TT

   IF V_EVASPARZ<>0
      REPLACE ORD_PRONTO WITH .T.
   ENDIF
  
   SKIP +1              

ENDDO

IF !ExecRW(cSql,"U_ORD_TT","W")
   return(.f.)
ENDIF

IF V_EVASIONE<>0
   OK_PROC = .T.
ELSE
   OK_PROC = .F.
ENDIF

RELEASE WINDOWS WSELESOC

RETURN