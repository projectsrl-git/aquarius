*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA FORNITORI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

FF=SUBSTR(LIBERA,18,4)

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

   CPA=for_CONPAG
   for_=for_CODCLI +" " + SUBSTR(for_RAGSOC,1,30)

   SCATTER MEMVAR MEMO
   
   XXX_CODfor = FF + SUBSTR(M.for_CODCLI,1,9)
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + _PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODfor + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP   
   IF EOF()
	  SELECT CU_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH _PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODfor
	  REPLACE CON_DESCR  WITH M.for_RAGSOC
	  REPLACE CON_TIPOCO WITH 'F'
	  REPLACE CON_POSBIL WITH 'P'
   ENDIF
   
   SELECT CUR_FORNITORI
   SKIP +1

ENDDO
