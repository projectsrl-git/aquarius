
IF PUB_CONTOSIMILCEE
ELSE
	MESSAGEBOX("Funzione disponibile solo per piano dei conti SIMILCEE",64,"Informazione")
	RETURN .F.
ENDIF

_risp = MESSAGEBOX("Elaborare le anagrafiche clienti/fornitori per la creazione del Piano dei Conti?",4+32+256,"Attenzione")
IF _risp = 6
ELSE
	RETURN .F.
ENDIF

WAIT windows "Creazione conti contabili da anagrafica clienti/fornitori" nowait    

*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA CLIENTI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CCC=SUBSTR(LIBERA,1,4)

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   WAIT WINDOWS "Elaborazione Cliente " + ALLTRIM(CLI_CODCLI) + " (" + ALLTRIM(CLI_RAGSOC) + ")" NOWAIT

*!*		IF ALLTRIM(STR(VAL(CLI_CODCLI))) = '6055'
*!*			SET STEP ON
*!*		ENDIF

   CPA=CLI_CONPAG
   CLI=CLI_CODCLI +" " + SUBSTR(CLI_RAGSOC,1,30)

   V_ER = SOTTOGEN(CLI_NAZION)
   IF !V_ER
      CC = PUB_CC
   ELSE
      CCC= CCC
   ENDIF

   SELECT CUR_CLIENTI

   SCATTER MEMVAR MEMO

   XXX_CODCLI = CC + ALLTRIM(STR(VAL(M.CLI_CODCLI)))	&& TOGLIE GLI 0 NON SIGNIFICATIVI IN QUANTO IL CLIENTE NEL PIANO DEI CONTI E' MEMORIZZATO SENZA ZERI
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT curs_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODCLI
	  REPLACE CON_DESCR  WITH M.CLI_RAGSOC
	  REPLACE CON_TIPOCO WITH 'C'
	  REPLACE CON_POSBIL WITH 'P'
	  REPLACE CON_TIPO_CONTO WITH '1'
   ENDIF
   IF !ExecRW(cSql,"CONTI","W")
      RETURN .F.
   ENDIF

   SELECT CUR_CLIENTI
   SKIP +1

ENDDO

*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA FORNITORI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

FFF=SUBSTR(LIBERA,18,4)

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   WAIT WINDOWS "Elaborazione Fornitore " + ALLTRIM(FOR_CODCLI) + " (" + ALLTRIM(FOR_RAGSOC) + ")" NOWAIT
   
*!*		IF ALLTRIM(STR(VAL(FOR_CODCLI))) = '6055'
*!*			SET STEP ON
*!*		ENDIF

   CPA=FOR_CONPAG

	V_ER = SOTTOGEN(FOR_NAZION)
	IF !V_ER
	    FF = PUB_FF
	ELSE
	    FFF= FFF
	ENDIF

   SELECT CUR_FORNITORI


   SCATTER MEMVAR MEMO

   XXX_CODFOR = FF + ALLTRIM(STR(VAL(M.FOR_CODCLI)))	&& TOGLIE GLI 0 NON SIGNIFICATIVI IN QUANTO IL FORNITORE NEL PIANO DEI CONTI E' MEMORIZZATO SENZA ZERI
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODfor + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT curs_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODFOR
	  REPLACE CON_DESCR  WITH M.FOR_RAGSOC
	  REPLACE CON_TIPOCO WITH 'F'
	  REPLACE CON_POSBIL WITH 'P'
	  REPLACE CON_TIPO_CONTO WITH '2'	  
   ENDIF
   IF !ExecRW(cSql,"CONTI","W")
      RETURN .F.
   ENDIF

   SELECT CUR_FORNITORI
   SKIP +1

ENDDO


MESSAGEBOX("Operazione effettuata",64,"Informazione")

RETURN .T.

