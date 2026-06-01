DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

_REPLACE = SPACE(10)
CSQL="UPDATE U_ORD_TT SET SELEZIONE = ?_REPLACE WHERE 1=1"
IF !ExecCommand(CSQL,"U_ORD_TT")
   RETURN (.f.)
ENDIF 

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_ordi = "ord_chiuso = '0'"
x_cond = x_soci + " and " + x_data + " and " + x_ordi

IF ALLTRIM(CLIDAL) = ""
ELSE
   x_clie = "ord_codcli = '" + ALLTRIM(CLIDAL) + "'"  
   x_cond = x_cond + " and " + x_clie
ENDIF

cSql="select * from u_ord_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
IF !ExecRW(cSql,"U_ORD_TT","R")
   return(.f.)
ENDIF
SELECT U_ORD_TT
GO TOP

ON KEY LABEL ENTER DO CHK2
ON KEY LABEL F DO CHKR
ON KEY LABEL RIGHTMOUSE DO CHKR                                                                                                                                                                                                                                                                                        

BROWSE FIELDS SELEZIONE:10:H='SELEZIONE',ORD_CODCLI:15:H='CLIENTE', ;
   ORD_RAGSOC:35:H='RAGIONE SOCIALE',ORD_DATORD:15:H='DATA ORDINE', ; 
   ORD_NUMORD:15:H='NUM.ORDINE' TITLE "Elenco ordini estratti: INVIO=SELEZIONA/DESELEZIONA - ESC=FINE" NOMENU NOEDIT NODELETE WINDOW WSELESOC
 
PUSH KEY CLEAR

V_EVASIONE = 0
V_EVASPARZ = 0

SELECT U_ORD_TT
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF SELEZIONE <> '=>'
      SELECT U_ORD_TT
      SKIP +1
      LOOP
   ENDIF

   AGGA = TAGGANCIO
  
   VRAGSOC = ALLTRIM(ORD_RAGSOC)
   VNUMORD = ORD_NUMORD
   VDATORD = ORD_DATORD
  
   x_agga = "daggancio = '" + AGGA + "'"
   x_comm = "ord_desart <> '*** COMMENTO ***'"
   x_cond = x_agga + " and " +x_comm   
   cSql = "select * from u_ord_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      RETURN .F.
   ENDIF 
   SELECT U_ORD_DD
   GO TOP

   BROWSE FIELDS ORD_CODART:16:H='COD.ARTICOLO':R, ;
                 ORD_DESART:35:H='DESCRIZIONE':R    , ;
                 ORD_QTAORD:15:H='ORDINATO':R       , ; 
                 ORD_QTAEV :15:H='EVASO'            , ;
                 ORD_QTADEV:15:H='DA EVADERE' TITLE 'Cliente: '+VRAGSOC+' - ordine: '+VNUMORD+' del '+vdatord NOMENU NODELETE WINDOW WSELESOC

   IF !ExecRW(cSql,"U_ORD_DD","W")
      RETURN .F.
   ENDIF 
                
   SELECT U_ORD_TT
   SKIP +1              

ENDDO

IF !ExecRW(cSql,"U_ORD_TT","W")
   return(.f.)
ENDIF

RELEASE WINDOWS WSELESOC

RETURN