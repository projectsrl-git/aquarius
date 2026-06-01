**********************************************************************************
*       RINUMERA NUMERO PROTOCOLLO SU FATTURE DI ACQUISTO			             *
**********************************************************************************

ANNODAL = SUBSTR(DATADAL,7,4)
MESEDAL = SUBSTR(DATADAL,4,2)
V_ANNO	= ANNODAL
V_MESE	= MESEDAL

CONTA_REC = 0

IF (EMPTY(MESEDAL)) .OR. (EMPTY(ANNODAL))  
   RETURN
ENDIF  

RIT = MESSAGEBOX('Sei sicuro di voler rinumerare le fatture acquisto da: '+DATADAL+CHR(13)+" a: "+DATAAL+CHR(13),292,"ATTENZIONE")
IF RIT = 7
   DO CLEAR_VAR
   RETURN
ENDIF

OK_ESECLI = .F.  && ARTICOLO PUBBLICITARIO

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE
v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   RIT=MSGBOX("Errore manca parametro GEN 5 caratteri conti CLI",'ATTENZIONE',31)
   RETURN(3)
ENDIF

CCC = SUBSTR(LIBERA,01,PUB_SOTTOG-1)
FFF = SUBSTR(LIBERA,18,PUB_SOTTOG-1)

DO RINUMERA      &&  RINUMERA FATTURE DI ACQUISTO FORNITORI

=MESSAGEBOX("Fine rinumerazione bollati",62,"*** ATTENZIONE ***")
RELEASE WINDOW DISPLAY
RETURN

***********************************************************************************************
     PROCEDURE RINUMERA    
***********************************************************************************************
IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
HH=AFIELDS(TRANSIVC)
CREATE CURSOR MOV_ACQ FROM ARRAY TRANSIVC    && CREA UN CURSORE DELLE SOLE FATTURE DI ACQUISTO
INDEX ON MOV_DTREG+STR(VAL(MOV_NPROT),10,0) TAG NPRO

DATA_DA = RIBALTA2(DATADAL)
DATA_A  = RIBALTA2(DATAAL)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + ANNODAL + "'"
x_dt1  = DATA_DA
x_dt2  = DATA_A
x_data = "mov_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql = "select * from mov_cont where " + x_cond + " order by mov_dtreg"
IF !ExecRW(cSql,"MOV_CONT","R")
   RETURN .F.
ENDIF
SELECT MOV_CONT
GO TOP

CTRELAB = 0

DO WHILE .T.       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE
   
   IF EOF()
      EXIT
   ENDIF
      
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF EMPTY(MOV_NPROT) 
      SELECT MOV_CONT
      SKIP +1
      LOOP
   ENDIF

   _TOP = MOV_TOP

   v_seek	= 'TOP' + ALLTRIM(_TOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT = SUBSTR(LIBERA,2,1)
      LIB = SUBSTR(LIBERA,12,1)
   ELSE
      NOTAC = SPACE(1)
      LIB   = SPACE(1)
   ENDIF
  
   IF FAT = 'S' .OR. FAT = 'C'    && SALTA I TOP NON FATTURA
   ELSE
      SELECT MOV_CONT 
      SKIP +1
      LOOP
   ENDIF

   IF LIB = 'F'             		&& TRATTA SOLO LE FATTURE DI ACQUISTO
   ELSE
      SELECT MOV_CONT 
      SKIP +1
      LOOP
   ENDIF

   SELECT MOV_CONT

   REPLACE MOV_RECNO WITH RECNO()

   SCATTER MEMVAR MEMO	    && Salva i vecchi valori
   SELECT MOV_ACQ
   APPEND BLANK
   GATHER MEMVAR MEMO		&& Salva le modifiche

   REPLACE MOV_DTPAG  WITH SPACE(10)
  
   CTRELAB = CTRELAB + 1 
   =CONTATORE("Fatture Fornitori ",CTRELAB)

   SELECT MOV_CONT
   SKIP +1

ENDDO

IF !ExecRW(cSql,"MOV_CONT","W")
   RETURN .F.
ENDIF

* RIELABORA IL CURSORE PER TOGLIERE I MOVIMENTI NON DA GESTIRE

CT = 0

SELECT MOV_ACQ
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF VAL(MOV_NPROT) < VAL(OLD_NPR)     && SCARTA MOVIMENTI CON NUMERO PROTOCOLLO GIA' OK
      DELETE 
      SELECT MOV_ACQ
      SKIP + 1
      LOOP
   ENDIF

   SELECT MOV_ACQ
   SKIP +1
  
ENDDO  

* RIELABORA IL CURSORE PER POTER APPLICARE LA NUMERAZIONE

CT = 0

SELECT MOV_ACQ
GO TOP

_OLD_NPRO = MOV_NPROT
_NEW_NPRO = MOV_NPROT

_CONTA  = VAL(NEW_NPR)

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF VAL(MOV_NPROT) < VAL(OLD_NPR)     && SCARTA MOVIMENTI CON NUMERO PROTOCOLLO GIA' OK
      SELECT MOV_ACQ
      SKIP + 1
      LOOP
   ENDIF

   IF _NEW_NPRO <> _OLD_NPRO			&& GESTIONE ROTTURA PER NUMERO DI PROTOCOLLO DA SOSTITUIRE
  	  _OLD_NPRO = _NEW_NPRO
      _CONTA    = _CONTA+1
   ENDIF

   REPLACE MOV_DTPAG  WITH ALLTRIM(STR(_CONTA,10,0))

   SELECT MOV_ACQ
   SKIP +1
  
   _NEW_NPRO = MOV_NPROT

ENDDO  

* RIELABORA IL CURSORE PER CONTROAGGIORNARE MOV_CONT

CT = 0

SELECT MOV_ACQ
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF EMPTY(MOV_DTPAG) 	     && SCARTA MOVIMENTI NON DA AGGIORNARE
      SELECT MOV_ACQ
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO
  
   x_soci = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno = "mov_anno = '" + ANNODAL + "'"
   x_cond = x_soci + " and " + x_anno
   cSql = "select * from mov_cont where " + x_cond + " order by mov_dtreg"
   IF !ExecRW(cSql,"MOV_CONT","R")
      RETURN .F.
   ENDIF
   SELECT MOV_CONT
   GO M.MOV_RECNO  
   REPLACE MOV_NPROT WITH M.MOV_DTPAG
   IF !ExecRW(cSql,"MOV_CONT","W")
      RETURN .F.
   ENDIF
 
   x_soci = "mov_soc = '" + M.MOV_SOC + "'"
   x_anno = "mov_anno = '" + M.MOV_ANNO + "'"
   x_data = "mov_dtreg = '" + M.MOV_DTREG + "'"
   x_nume = "mov_numpro = '" + M.MOV_NUMPRO + "'"   
   x_cond = x_soci + " and " + x_anno + " and " + x_data + " and " + x_nume
   cSql = "select * from indice where " + x_cond + " order by mov_dtreg"
   IF !ExecRW(cSql,"INDICE","R")
      RETURN .F.
   ENDIF
   SELECT INDICE
   GO TOP 
   IF !EOF()
      REPLACE MOV_NPROT WITH M.MOV_DTPAG
   ENDIF
   IF !ExecRW(cSql,"INDICE","W")
      RETURN .F.
   ENDIF

   SELECT MOV_ACQ
   SKIP +1
  
ENDDO  

RETURN

************************
  PROCEDURE CLEAR_VAR
************************

MESEDAL = SPACE(2)
ANNODAL = SPACE(4)
SHOW GETS