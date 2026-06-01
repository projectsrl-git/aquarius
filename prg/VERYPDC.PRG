***********************************************************************
* CONVERSIONE ARCHIVIO PIANO DEI CONTI HELIOS  --- by PROJECT s.a.s   *
***********************************************************************

PUB_PJPWD=.F.
PUB_MESS="Manutenzione archivi Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 

IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

V_RIT=MESSAGEBOX('Desideri proseguire il'+chr(13)+'controllo del piano conti anno: '+PUB_ANNO,292,'*** ATTENZIONE ***')
DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		 RETURN
ENDCASE

CREATE CURSOR CONTI_DOP ;
	(KCONTO C(13), KDESCR C(40), KDARE N(12), KAVERE N(12), KVOLTE N(8))
INDEX ON KDESCR TAG CONT_DOP 

DO FORM FORM\ATTENDI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"CUR_CONTI")
   RETURN .F.
ENDIF
SELECT CUR_CONTI
GO TOP   

CONTA = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF 
 
   XCONTO = CON_CONTO
   XDARE  = CON_IMP_D
   XAVERE = CON_IMP_A
   XDESCR = CON_DESCR
  
   SELECT CONTI_DOP
   SET ORDER TO CONT_DOP 
   SEEK XDESCR
 
   IF FOUND()
      CONTA = CONTA +1
      WAIT WINDOWS "Conti doppi "+STR(CONTA,6,0) NOWAIT  
      REPLACE    KVOLTE    WITH KVOLTE + 1
   ELSE  
      APPEND BLANK
      REPLACE    KCONTO    WITH XCONTO
      REPLACE    KDESCR    WITH XDESCR
      REPLACE    KDARE     WITH XDARE
      REPLACE    KAVERE    WITH XAVERE
      REPLACE    KVOLTE    WITH 1
   ENDIF
 
   SELECT CUR_CONTI
   SKIP +1

ENDDO

WAIT WINDOWS "Conti doppi "+STR(CONTA,6,0) NOWAIT

SELECT CONTI_DOP
GO TOP
DELETE FOR KVOLTE = 1
GO TOP

IF !EOF()
   DO PRG\MENUSTA WITH "CONTI_DOP",.T.,.T.,"XXX","PRNDOPPD","PRNDOPPD.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF

=MESSAGEBOX('Fine controllo descrizioni doppie piano dei conti',64,'*** ATTENZIONE ***')

RELEASE WINDOWS ATTENDI

RETURN