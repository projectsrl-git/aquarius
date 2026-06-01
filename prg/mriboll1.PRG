DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

V_EVASIONE = 0
V_EVASPARZ = 0

SELECT CU_MRI_TT

AGGA    = TAGGANCIO
VRAGSOC = ALLTRIM(ORD_RAGSOC)
VNUMORD = ORD_NUMORD
VDATORD = RIBALTA2(ORD_DATORD)
  
x_cond = "daggancio = '" + ALLTRIM(AGGA) + "'"
Csql   = "select * from u_mri_dd where " + x_cond + " order by daggancio,ord_sequen"
IF !ExecRW(cSql,"U_MRI_DD","R")
   return(.f.)
ENDIF
SELECT U_MRI_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF (!("*** COMMENTO ***" $ ORD_DESART) .AND. !ORD_CHIUSO .AND. ORD_QTAORD > ORD_QTAEV)
   ELSE
      SKIP +1
      LOOP
   ENDIF

   V_MAGA = ORS_MAGS
   V_ARTI = ORD_CODART
 
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "mag_codmag = '" + V_MAGA + "'"
   x_arti = "mag_codart = '" + V_ARTI + "'"
   x_cond = x_soci + " and " + x_codi + " and " + x_arti
   cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecCommand(cSql,"CUR_GIACENZE")
      RETURN .F.
   ENDIF
   SELECT CUR_GIACENZE
   GO TOP   
   IF EOF()               
      V_GIACE = 0
   ELSE
      V_GIACE = MAG_GIACEN
   ENDIF

   SELECT U_MRI_DD
   REPLACE ORD_QTAORG WITH V_GIACE
   SKIP +1
ENDDO
  
SELECT U_MRI_DD
GO TOP
BROWSE FIELDS ORD_CODART:16:H='CODICE ARTICOLO':R, ;
              ORD_DESART:35:H='DESCRIZIONE':R    , ;
              ORD_QTAORD:15:H='ORDINATO':R       , ; 
              ORD_QTAEV :15:H='EVASO':R          , ;
              ORD_QTADEV:15:H='DA EVADERE'       , ;
              ORD_QTAORG:15:H='GIACENZA':R       , ;
              ORS_MAGS:6:H='MAGAZZINO':R  TITLE 'Cliente: '+VRAGSOC+' - ordine: '+VNUMORD+' del '+vdatord NOMENU NODELETE WINDOW WSELESOC

SELECT U_MRI_DD
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

IF V_EVASIONE<>0
   OK_PROC = .T.
ELSE
   OK_PROC = .F.
ENDIF

IF !ExecRW(cSql,"U_MRI_DD","W")
   return(.f.)
ENDIF

RELEASE WINDOWS WSELESOC

RETURN