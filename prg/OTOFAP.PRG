DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
*x_anno = "ord_anno   = '" + PUB_ANNO + "'"
x_anno = "ord_anno = ord_anno"  && ERASMO - 07/02/2023
x_fsta = "ORD_FLGSTA = 1"  && ERASMO - 08/08/2016 - L'ORDINE DA SELEZIONARE DEVE ESSERE NECESSARIAMENTE PASSATO DA AGGIORNAMENTO IN APPOSITO GESTIONALE, IN QUANTO E' LI' CHE VENGONO EFFETTUATI TUTTI I CONTROLLI DEL CASO

_REPLACE = SPACE(10)
CSQL="UPDATE U_ORD_TT SET SELEZIONE = ?_REPLACE WHERE " + x_soci + " and " + x_anno + " and " + x_fsta 
IF !ExecCommand(CSQL,"U_ORD_TT")
   RETURN (.f.)
ENDIF

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
*x_anno = "ord_anno   = '" + PUB_ANNO + "'"
x_anno = "ord_anno = ord_anno"  && ERASMO - 07/02/2023
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_ordi = "ord_chiuso = '0'"
x_clie = "ord_codcli = '" + ALLTRIM(CLIDAL) + "'"

IF EMPTY(CLIDAL) .OR. CLIDAL = SPACE(10)
   cSql="select * from u_ord_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_fsta + " order by ord_codsoc,ord_anno,ord_numord"
ELSE
   cSql="select * from u_ord_tt where " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_ordi + " and " + x_fsta + " and " + x_clie + " order by ord_codsoc,ord_anno,ord_numord"
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


DO prg\browseview WITH "U_ORD_TT","Seleziona gli ordini clienti ","ORD_CODCLI:codice cliente,W:10;ORD_RAGSOC:ragione sociale,W:39;ORD_DATORD:data ordine,W:10;ORD_NUMORD:num.ordine,W:6;ORD_VALORE:importo.,W:13;"


SELECT U_ORD_TT
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
       
   IF SELEZIONE <> '==>'
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
   Csql   = "select * from u_ord_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   GO TOP

   BROWSE FIELDS ORD_CODART:16:H='COD.ARTICOLO':R, ;
                 ORD_DESART:35:H='DESCRIZIONE':R    , ;
                 ORD_QTAORD:15:H='ORDINATO':R       , ; 
                 ORD_QTAEV :15:H='EVASO':R          , ;
                 ORD_QTADEV:15:H='DA EVADERE' TITLE 'Cliente: '+VRAGSOC+' - ordine: '+VNUMORD+' del '+vdatord NOMENU NODELETE WINDOW WSELESOC

   SELECT U_ORD_DD
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

   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF
                   
   SELECT U_ORD_TT

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

IF !ExecRW(cSql,"U_ORD_TT","W")
   return(.f.)
ENDIF

RETURN