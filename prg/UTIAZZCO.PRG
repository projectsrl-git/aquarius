**********************************************************************************
*       AZZERA I SALDI DEL PIANO DEI CONTI							             *
**********************************************************************************

RIT = MESSAGEBOX('Sei sicuro di voler azzerare i saldi relativi al piano dei conti anno : '+PUB_ANNO,292,"ATTENZIONE")
IF RIT = 7
   DO CLEAR_VAR
   RETURN
ENDIF

WAIT WINDOWS "Elaborazione in corso attendere prego ...." nowait

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"CONTI","R")
   RETURN .F.
ENDIF
SELECT CONTI
GO TOP   

REPLACE CON_SALDOI WITH 0 ;
        CON_IMP_D  WITH 0 ;
        CON_IMP_A  WITH 0  FOR CON_ANNO = PUB_ANNO

FOR H=1 TO 12

   IF H < VAL(MESEDAL) 
      LOOP
   ENDIF
  
   IF H > VAL(MESEAL) 
      LOOP
   ENDIF
   
   _CONTOD="CON_DA"+PADL(H,2,"0")
   _CONTOA="CON_AV"+PADL(H,2,"0")

   REPLACE &_CONTOD WITH 0 ;
           &_CONTOA WITH 0  FOR CON_ANNO = PUB_ANNO
  
NEXT

IF !ExecRW(cSql,"CONTI","W")
   RETURN .F.
ENDIF

=MESSAGEBOX("Fine azzeramento saldi",62,"*** ATTENZIONE ***")
RETURN