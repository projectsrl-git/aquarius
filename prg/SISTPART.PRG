SET PROCEDURE TO WINLIB ADDITIVE 

x_cond = "par_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from part_cli where " + x_cond + " order by par_codsoc"
IF !ExecRW(cSql,"PART_CLI","R")
   RETURN .F.
ENDIF
SELECT PART_CLI
GO TOP

CTR_CLFO = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF LEN(ALLTRIM(STR(PAR_NPART))) > 6
  	  N_PART = SUBSTR(PAR_ANNO,3,2)+ ALLTRIM(STR(PAR_NPART))
   ELSE
	  N_PART = ALLTRIM(PAR_ANNO)+ ALLTRIM(STR(PAR_NPART))
   ENDIF

   REPLACE PAR_NPART WITH VAL(N_PART)

   CTR_CLFO = CTR_CLFO + 1
   WAIT WINDOWS "Movimento in elaborazione n: "+str(ctr_clfo,7,0) nowait
    
   SCATTER MEMVAR MEMO
    
   DO SISTIND	&& AGGIORNA INDICE
   DO SISTMOV	&& AGGIORNA MOV_CONT
	
   SELE PART_CLI
   SKIP +1
	
ENDDO

IF !ExecRW(cSql,"PART_CLI","W")
   RETURN .F.
ENDIF

x_cond = "par_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from part_for where " + x_cond + " order by par_codsoc"
IF !ExecRW(cSql,"PART_FOR","R")
   RETURN .F.
ENDIF
SELECT PART_FOR
GO TOP

CTR_CLFO = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF LEN(ALLTRIM(STR(PAR_NPART))) > 6
  	  N_PART = SUBSTR(PAR_ANNO,3,2)+ ALLTRIM(STR(PAR_NPART))
   ELSE
	  N_PART = ALLTRIM(PAR_ANNO)+ ALLTRIM(STR(PAR_NPART))
   ENDIF

   REPLACE PAR_NPART WITH VAL(N_PART)
   
   CTR_CLFO = CTR_CLFO + 1
   WAIT WINDOWS "Movimento in elaborazione n: "+str(ctr_clfo,7,0) nowait

   SCATTER MEMVAR MEMO
    
   DO SISTIND	&& AGGIORNA INDICE
   DO SISTMOV	&& AGGIORNA MOV_CONT
	
   SELE PART_FOR
   SKIP +1

ENDDO

IF !ExecRW(cSql,"PART_FOR","W")
   RETURN .F.
ENDIF


*****************************
PROCEDURE SISTIND
*****************************

SS=STR(SELECT())

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + M.PAR_ANNO + "'"
x_nume = "mov_numpro = '" + M.PAR_NUMPRO + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_nume
cSql = "select * from indice where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(cSql,"INDICE","R")
   RETURN .F.
ENDIF
SELECT INDICE
GO TOP		

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
    
   REPLACE MOV_NPART WITH M.PAR_NPART
   
   SKIP +1
 
ENDDO

IF !ExecRW(cSql,"INDICE","W")
   RETURN .F.
ENDIF

SELECT &SS

RETURN

*****************************
PROCEDURE SISTMOV
*****************************

SS=STR(SELECT())

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + M.PAR_ANNO + "'"
x_nume = "mov_numpro = '" + M.PAR_NUMPRO + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_nume
cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(cSql,"MOV_CONT","R")
   RETURN .F.
ENDIF
SELECT MOV_CONT
GO TOP		

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   *IF ALLTRIM(MOV_CONTO) = ALLTRIM(M.PAR_CODCLI)
	   REPLACE MOV_NPART WITH M.PAR_NPART
   *ENDIF
   
   SKIP +1
 
ENDDO

IF !ExecRW(cSql,"MOV_CONT","W")
   RETURN .F.
ENDIF

SELECT &SS

RETURN