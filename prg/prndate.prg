************************************************
*     CAMBIO DATE
************************************************
PARA _SOC,_ANNO,_DAL,_XAL,_DNEW

_XDAL = RIBALTA2(_DAL)
_XAL  = RIBALTA2(_XAL)
_DATN = RIBALTA2(_DNEW)

*1)=============================

x_soci = "mov_soc = '" + _SOC + "'"  
x_anno = "mov_anno = '" + _ANNO + "'"
x_dt1  = _XDAL
x_dt2  = _XAL
x_data = "mov_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"   
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql="select * from indice where " + x_cond + " order by mov_dtreg"
IF !ExecRW(cSql,"INDICE","R")
   return(.f.)
ENDIF
SELECT INDICE
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

   CONTA = CONTA + 1  
   WAIT WINDOWS "IINDICE: numero movimenti aggiornati :"+STR(CONTA,8,0) NOWAIT
         
   REPLACE MOV_DTREG WITH _DATN  
  
   SELECT INDICE
   SKIP +1

ENDDO

IF !ExecRW(cSql,"INDICE","W")
   return(.f.)
ENDIF

*2)=============================

x_soci = "mov_soc = '" + _SOC + "'"  
x_anno = "mov_anno = '" + _ANNO + "'"
x_dt1  = _XDAL
x_dt2  = _XAL
x_data = "mov_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"   
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql="select * from mov_cont where " + x_cond + " order by mov_dtreg"
IF !ExecRW(cSql,"MOV_CONT","R")
   return(.f.)
ENDIF
SELECT MOV_CONT
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
   
   CONTA = CONTA + 1  
   WAIT WINDOWS "MOV_CONT: numero movimenti aggiornati :"+STR(CONTA,8,0) NOWAIT
         
   REPLACE MOV_DTREG WITH _DATN
  
   SELECT MOV_CONT
   SKIP +1

ENDDO

IF !ExecRW(cSql,"MOV_CONT","W")
   return(.f.)
ENDIF

*3)=============================

x_soci = "mov_soc = '" + _SOC + "'"  
x_anno = "mov_anno = '" + _ANNO + "'"
x_dt1  = _XDAL
x_dt2  = _XAL
x_data = "mov_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"   
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql="select * from mov_cco where " + x_cond + " order by mov_dtreg"
IF !ExecRW(cSql,"MOV_CCO","R")
   return(.f.)
ENDIF
SELECT MOV_CCO
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
         
   REPLACE MOV_DTREG WITH _DATN
  
   CONTA = CONTA + 1
   WAIT WINDOWS "MOV_CCO: numero movimenti aggiornati :"+STR(CONTA,8,0) NOWAIT
    
   SELECT MOV_CCO
   SKIP +1

ENDDO

IF !ExecRW(cSql,"MOV_CCO","W")
   return(.f.)
ENDIF

*4)=============================

x_soci = "par_codsoc = '" + _SOC + "'"  
x_dt1  = _XDAL
x_dt2  = _XAL
x_data = "par_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"   
x_cond = x_soci + " and " + x_data
cSql="select * from part_cli where " + x_cond + " order by par_dtreg"
IF !ExecRW(cSql,"PART_CLI","R")
   return(.f.)
ENDIF
SELECT PART_CLI
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
           
   REPLACE PAR_DTREG WITH _DATN

   CONTA = CONTA + 1  
   WAIT WINDOWS "PART_CLI: numero movimenti aggiornati :"+STR(CONTA,8,0) NOWAIT
   
   SELECT PART_CLI
   SKIP +1
  
ENDDO

IF !ExecRW(cSql,"PART_CLI","W")
   return(.f.)
ENDIF

*5)=============================

x_soci = "par_codsoc = '" + _SOC + "'"  
x_dt1  = _XDAL
x_dt2  = _XAL
x_data = "par_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"   
x_cond = x_soci + " and " + x_data
cSql="select * from part_for where " + x_cond + " order by par_dtreg"
IF !ExecRW(cSql,"PART_FOR","R")
   return(.f.)
ENDIF
SELECT PART_FOR
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
          
   REPLACE PAR_DTREG WITH _DATN

   CONTA = CONTA + 1  
   WAIT WINDOWS "PART_FOR: numero movimenti aggiornati :"+STR(CONTA,8,0) NOWAIT
  
   SELECT PART_FOR
   SKIP +1
  
ENDDO

IF !ExecRW(cSql,"PART_FOR","W")
   return(.f.)
ENDIF

=MESSAGEBOX("Funzione terminata correttamente",62,"ATTENZIONE")