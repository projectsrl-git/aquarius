DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 15,80;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

CREATE CURSOR DETTORD (AGGANC C(10),CODART C(30),DESART C(40),DATSCA C(10), NUMORD C(06),;
                       DATORD C(10),QTAORD N(10,3),QTAEVA N(10,3),QTADEV N(10,3))

IF DATADAL = SPACE(10) .OR. DATADAL = '  /  /    ' 
   DATADAL = '01/01/' + PUB_ANNO
ENDIF   
IF DATAAL = SPACE(10) .OR. DATAAL = '  /  /    ' 
   DATAAL = '31/12/' + PUB_ANNO
ENDIF   

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

IF EOF()
   OK_PROC = .F.
   RELEASE WINDOWS WSELESOC
   RETURN
ENDIF

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
   
   AGGA    = TAGGANCIO
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

   DO WHILE .T.
   
      IF EOF()
         EXIT
      ENDIF

      REPLACE ORD_QTADEV WITH 0
   
      IF ARTDAL = SPACE(16)
      ELSE
         IF ORD_CODART < ARTDAL
            SKIP +1
            LOOP
         ENDIF 
      ENDIF     

      IF ARTAL = SPACE(16)
      ELSE
         IF ORD_CODART > ARTAL
            SKIP +1
            LOOP
         ENDIF  
      ENDIF    
                             
      IF ORD_QTAORD > ORD_QTAEV
      ELSE
         REPLACE ORD_CHIUSO WITH .T.
      ENDIF
   
      IF ORD_CHIUSO = .T.
         SKIP +1
         LOOP
      ENDIF

      VDATSCA = ORD_DATCON 
      VCODART = ORD_CODART
      VDESART = ORD_DESART
      VQTAORD = ORD_QTAORD
      VQTAEVA = ORD_QTAEV
      VQTADEV = 0

      SELECT DETTORD 
      APPEND BLANK
      REPLACE AGGANC WITH AGGA
      REPLACE CODART WITH VCODART
      REPLACE DESART WITH VDESART
      REPLACE DATSCA WITH VDATSCA
      REPLACE NUMORD WITH VNUMORD
      REPLACE DATORD WITH VDATORD
      REPLACE QTAORD WITH VQTAORD
      REPLACE QTAEVA WITH VQTAEVA
      REPLACE QTADEV WITH VQTADEV
   
      SELECT U_ORD_DD
      SKIP +1

   ENDDO
   
   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF
   
   SELECT U_ORD_TT
   SKIP +1
   
ENDDO   

IF !ExecRW(cSql,"U_ORD_TT","W")
   return(.f.)
ENDIF

SELECT DETTORD
GO TOP
IF EOF()
   RELEASE WINDOWS WSELESOC
   OK_PROC = .F.
   RETURN
ENDIF

INDEX ON CODART + RIBALTA2(DATSCA) TAG I_DETTORD
SET ORDER TO I_DETTORD
GO TOP

BROWSE FIELDS CODART:16:H='COD. ARTICOLO':R, ;
              DESART:35:H='DESCRIZIONE':R    , ;
              DATSCA:12:H='DATA SCAD.':R    , ;
              NUMORD:12:H='N.ORDINE':R    , ;
              DATORD:12:H='DATA ORD.':R    , ;
              QTAORD:12:H='ORDINATO':R       , ; 
              QTAEVA:12:H='EVASO':R          , ;
              QTADEV:12:H='DA EVADERE' TITLE 'Elenco dettagli ordini cliente: '+RAGSOC NOMENU  NODELETE WINDOW WSELESOC

SELECT DETTORD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF QTADEV > 0
   ELSE
      SKIP +1
      LOOP
   ENDIF      
   
   DAGGA   = AGGANC
   VCODART = CODART
   VQTADEV = QTADEV
   VDATSCA = DATSCA

   V_EVASIONE = V_EVASIONE + QTADEV
   V_EVASPARZ = V_EVASPARZ + QTADEV
   
   x_cond = "daggancio = '" + ALLTRIM(DAGGA) + "'"
   cSql   = "select * from u_ord_dd where " + x_cond + " order by daggancio"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   GO TOP
   IF !EOF()
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ORD_CODART = VCODART .AND. ORD_DATCON = VDATSCA
            REPLACE ORD_QTADEV WITH VQTADEV
         ENDIF
         SKIP +1
      ENDDO   
   ENDIF

   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF

   x_cond = "taggancio = '" + ALLTRIM(DAGGA) + "'"
   cSql   = "select * from u_ord_tt where " + x_cond + " order by taggancio"
   IF !ExecRW(cSql,"U_ORD_TT","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_TT
   GO TOP
   IF !EOF()
      REPLACE SELEZIONE  WITH '=>'
      REPLACE ORD_PRONTO WITH .T.
   ENDIF

   IF !ExecRW(cSql,"U_ORD_TT","W")
      return(.f.)
   ENDIF
         
   SELECT DETTORD
   SKIP +1              

ENDDO

IF V_EVASIONE<>0
   OK_PROC = .T.
ELSE
   OK_PROC = .F.
ENDIF

RELEASE WINDOWS WSELESOC
RETURN