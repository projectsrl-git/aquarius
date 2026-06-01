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

   SCATTER MEMVAR MEMO
  
   DATA_SCAD=SPACE(10)

   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

   V_SEEK = SUBSTR(M.PAR_CODCLI,PUB_SOTTOG-1,10)
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_SEEK + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP
   IF !EOF()   
	  VET_DAL[1]= CLI_BDAL  
	  VET_DAL[2]= CLI_B2DAL
	  VET_AL[1] = CLI_BAL
	  VET_AL[2] = CLI_B2AL
	  VET_DAY[1]= CLI_GG1
	  VET_DAY[2]= CLI_GG2
   ELSE
	  VET_DAL[1]= "0000"      
	  VET_DAL[2]= "0000"
	  VET_AL[1] = "0000"
	  VET_AL[2] = "0000" 
	  VET_DAY[1]= "0000" 
	  VET_DAY[2]= "0000"
   ENDIF
		    
   V_CONPAG = M.PAR_CODPAG
   V_TUTTO  = TRANCHE("PARA",M.PAR_CODPAG,M.PAR_DTFAT,M.PAR_FATT,VET_DAL,VET_AL,VET_DAY,m.PAR_valuta)    

   DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
           
   SELECT PART_CLI

   IF EMPTY(M.PAR_DTSCAD) 
	  REPLACE PAR_DTSCAD WITH RIBALTA2(DATA_SCAD)
	  REPLACE PAR_DATPAG WITH RIBALTA2(DATA_SCAD)
   ELSE
	  REPLACE PAR_DATPAG WITH M.PAR_DTSCAD
   ENDIF
	
   CTR_CLFO = CTR_CLFO + 1
   WAIT WINDOWS "Movimento in elaborazione n: "+str(ctr_clfo,7,0) nowait
   
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

   SCATTER MEMVAR MEMO
  
   DATA_SCAD=SPACE(10)

   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

   VET_DAL[1]= "0000"      
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000" 
   VET_DAY[1]= "0000" 
   VET_DAY[2]= "0000"
		    
   V_CONPAG = M.PAR_CODPAG
   V_TUTTO  = TRANCHE("PARA",M.PAR_CODPAG,M.PAR_DTFAT,M.PAR_FATT,VET_DAL,VET_AL,VET_DAY,m.PAR_valuta)    

   DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
           
   SELECT PART_FOR

   IF EMPTY(M.PAR_DTSCAD) 
	  REPLACE PAR_DTSCAD WITH RIBALTA2(DATA_SCAD)
	  REPLACE PAR_DATPAG WITH RIBALTA2(DATA_SCAD)
   ELSE
	  REPLACE PAR_DATPAG WITH M.PAR_DTSCAD
   ENDIF

   CTR_CLFO = CTR_CLFO + 1
   WAIT WINDOWS "Movimento in elaborazione n: "+str(ctr_clfo,7,0) nowait
	
   SELE PART_FOR
   SKIP +1

ENDDO

IF !ExecRW(cSql,"PART_FOR","W")
   RETURN .F.
ENDIF

RETURN