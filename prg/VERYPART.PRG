***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE
v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti CLI"
   RETURN
ENDIF
CC = SUBSTR(LIBERA,1,4)

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti CLI"
   RETURN
ENDIF
FF = SUBSTR(LIBERA,18,4)

*CREA CURSORE TEMPORANEO CON I TOP DA ANALIZZARE : RGO
IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
HH=AFIELDS(TRANSRGO)
CREATE CURSOR MOV_PART FROM ARRAY TRANSRGO

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_conto"
IF !ExecCommand(cSql,"CUR_MOVCONT")
   RETURN .F.
ENDIF
SELECT CUR_MOVCONT
GO TOP		

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO
 
   IF SUBSTR(M.MOV_CONTO,1,4) = CC .OR. SUBSTR(M.MOV_CONTO,1,4) = FF
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF SUBSTR(M.MOV_CONTO,1,4) = CC		
      WAIT WINDOWS "Record elaborato: "+ M.MOV_NUMPRO NOWAIT
      x_cond = "par_numpro = '" + ALLTRIM(M.MOV_NUMPRO) + "'"      
      cSql = "select * from part_cli where " + x_cond + " order by par_numpro"
      IF !ExecCommand(cSql,"MOV_TMPX")
         RETURN .F.
      ENDIF
      SELECT MOV_TMPX
      GO TOP		
	  COUNT TO _NR
	  GO TOP
	  IF _NR = 0
	     SELECT MOV_PART
	     APPEND BLANK
	     GATHER MEMVAR MEMO
	  ENDIF 
   ENDIF

   IF SUBSTR(M.MOV_CONTO,1,4) = FF      
      x_cond = "par_numpro = '" + ALLTRIM(M.MOV_NUMPRO) + "'"      
      cSql = "select * from part_for where " + x_cond + " order by par_numpro"
      IF !ExecCommand(cSql,"MOV_TMPX")
         RETURN .F.
      ENDIF
      SELECT MOV_TMPX
      GO TOP		
  	  COUNT TO _NR
	  GO TOP
	  IF _NR = 0
	     SELECT MOV_PART
	     APPEND BLANK
	     GATHER MEMVAR MEMO
      ENDIF
   ENDIF	

   SELECT CUR_MOVCONT
   SKIP +1 

ENDDO

SELECT MOV_PART
GO TOP

IF !EOF()
   DO PRG\MENUSTA WITH "MOV_PART",.T.,.T.,"XXX","MOVPART","MOVPART.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF