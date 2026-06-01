V_EVASIONE = 0
V_EVASPARZ = 0

SELECT CU_PCK_TT

AGGA    = TAGGANCIO
VRAGSOC = ALLTRIM(ORD_RAGEMI)
VNUMORD = ORD_NUMORD
VDATORD = RIBALTA2(ORD_DATORD)
  
*!*	x_cond = "daggancio = '" + ALLTRIM(AGGA) + "'"
x_cond  = "daggancio = " + ALLTRIM(AGGA) 
x_cond1 = "ORD_DESART <> '" + "*** COMMENTO ***"  + "'"
Csql    = "select * from U_PCK_DD where " + x_cond  + " and " + x_cond1 + " order by daggancio"
IF !ExecRW(cSql,"U_PCK_DD","R")
   return(.f.)
ENDIF
SELECT U_PCK_DD
GO TOP

_verifica_se_proseguire = .f.

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ("*** COMMENTO ***" $ ORD_DESART)    && SCARTA I COMMENTI
      SKIP +1
      LOOP
   ENDIF

   IF (!ORD_CHIUSO .AND. ORD_QTAEV > 0)    && TRATTA RIGHE P.L. NON CHIUSE E PREPARATE PER LA SPEDIZIONE
   ELSE
      SKIP +1
      LOOP
   ENDIF

   V_MAGA  = ORS_MAGS
   V_ARTI  = ORD_CODART
   V_AGGA  = DAGGANCIO
   V_UNIQ  = ORD_UNIQUE
   V_GIACE = 0
   
   DO controlla_giacenza

   _verifica_se_proseguire = .t.

   SELECT U_PCK_DD
   REPLACE ORD_QTAORG WITH V_GIACE
   REPLACE ORD_NOTA   WITH ALLTRIM(ORD_NOTE)
   REPLACE ORD_QTADEV WITH ORD_QTAEV			&& quantita' preparata
   REPLACE ORD_QTADE2 WITH ORD_QTADEV 
   REPLACE ORS_SALCON WITH 'S'

   SKIP +1

ENDDO      
  
SELECT U_PCK_DD
GO TOP

IF _verifica_se_proseguire 
ELSE
   PUB_ERRORE=MESSAGEBOX("La packing list non è ancora stata preparata in magazzino"+CHR(13)+;
                         "nessuna quantità è stata movimentata",64,"*** ATTENZIONE ***") 
   RETURN
ENDIF

*DO FORM FORM\MENU_PCKTODDT1

SELECT U_PCK_DD
GO TOP

V_EVASPARZ = 0
  
DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF "*** COMMENTO ***" $ ORD_DESART
   ELSE
      V_EVASIONE = V_EVASIONE + ORD_QTADEV
      V_EVASPARZ = V_EVASPARZ + ORD_QTADEV
   ENDIF
    
   SKIP +1  

ENDDO                  

IF V_EVASIONE<>0
   OK_PROC = .T.
ELSE
   OK_PROC = .F.
   SELECT U_PCK_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      REPLACE ORD_QTADEV WITH 0
      SKIP +1  
   ENDDO                  
ENDIF

IF !ExecRW(cSql,"U_PCK_DD","W")
   return(.f.)
ENDIF

RETURN


****************************
PROCEDURE controlla_giacenza
****************************

** CARICA LA GIACENZA DELL'ARTICOLO --------------------------------------------------------------------*   
x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_cdma = "mag_codmag = '" + ALLTRIM(V_MAGA) + "'"
x_cdar = "mag_anaart = '" + ALLTRIM(V_ARTI) + "'"
x_data = "mag_datagg = SPACE(10)"    
x_cond = x_soci + " and " + x_cdma + " and " + x_cdar + " and " + x_data
cSql   = "select * from U_MAG_GG where " + x_cond + " order by mag_anaart"
IF !ExecCommand(cSql,"U_MAG_GG")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP
V_GIACEN = 0
V_QTAIMP = 0
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   V_GIACEN = V_GIACEN + MAG_GIACEN
   V_QTAIMP = V_QTAIMP + MAG_QTAIMP
   SKIP +1
ENDDO

x_agga = "leg_agganc = '" + V_AGGA + "'"
x_csys = "leg_syspck = leg_syspck"
x_uniq = "leg_unique = '" + ALLTRIM(V_UNIQ) + "'"
x_cond = x_agga + " and " + x_csys + " and " + x_uniq
cSql   = "select * from u_pck_le where " + x_cond
IF !ExecCommand(Csql,"U_PCK_LE")
   return(.f.)
ENDIF
SELECT U_PCK_LE
GO TOP
V_GIAIMP = 0
DO WHILE .T. 
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   V_GIAIMP = V_GIAIMP + LEG_QUANTI
   SKIP +1
ENDDO

V_GIACE = V_GIACEN - V_QTAIMP + V_GIAIMP

RETURN