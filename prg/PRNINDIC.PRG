*****************************************************
*     CONTROLLO CORRISPONDENZA TRA INDICE E MOV_CONT 
*     E TRA MOV_CONT E INDICE
*****************************************************
PARA _SOC,_ANNO,_DAL,_AL

*****   da indice a mov_cont   **********************************************************

_DAL = RIBALTA2(_DAL)
_AL  = RIBALTA2(_AL)

IF !ExecCommand("select * from indice where 0=1","indice")
   return(.f.)
ENDIF
SELECT INDICE
QQ=AFIELDS(PIPPO)
CREATE CURSOR WORK FROM ARRAY PIPPO

x_soci = "mov_soc = '" + _SOC + "'"
x_anno = "mov_anno = '" + _ANNO + "'"
x_dt1  = _DAL
x_dt2  = _AL
x_data = "mov_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql = "select * from indice where " + x_cond + " order by mov_dtreg"
IF !ExecCommand(cSql,"CUR_INDICE")
   RETURN .F.
ENDIF
SELECT CUR_INDICE
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
  	  SKIP +1
	  LOOP
   ENDIF

   _NUMPRO = MOV_NUMPRO
  
   x_soci = "mov_soc = '" + _SOC + "'"
   x_anno = "mov_anno = '" + _ANNO + "'"
   x_nume = "mov_numpro = '" + _NUMPRO + "'"   
   x_cond = x_soci + " and " + x_anno + " and " + x_nume
   cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(cSql,"CUR_MOVCONT")
      RETURN .F.
   ENDIF
   SELECT CUR_MOVCONT
   GO TOP  
    
   T_DARE     = 0
   T_AVERE    = 0
   OK_TROVATO = .F.

   DO WHILE .T.
      
      IF EOF()
         EXIT
      ENDIF
           
	  OK_TROVATO = .T.
      EXIT
      
      SKIP +1  
   ENDDO  
  
   IF !OK_TROVATO
      SELECT CUR_INDICE  
      SCATTER MEMVAR MEMO     
      SELECT WORK
      APPEND BLANK
      GATHER MEMVAR MEMO    
   ENDIF
  
   SELECT CUR_INDICE
   SKIP +1

ENDDO

SELECT WORK 
GO TOP

IF !EOF()
   =MESSAGEB("INDICE OK , MOV_CONT KO  !!!",16,"*** ATTENZIONE ***")    
   BROWSE FIELDS MOV_CONTO:20:H='CONTO',MOV_DTREG:15:H='DATA REG',MOV_NREGIS:15:H='NUM. REG.',;
   MOV_NDOC:15:H='NUM. DOC.',MOV_DTDOC:15:H='DATA DOC',MOV_IMP:15:H='TOTALE' NORMAL NOMENU NOEDIT NODELETE
ENDIF

*****   da mov_cont  a indice **********************************************************

IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
QQ=AFIELDS(PIPPO)
CREATE CURSOR WORK FROM ARRAY PIPPO

x_soci = "mov_soc = '" + _SOC + "'"
x_anno = "mov_anno = '" + _ANNO + "'"
x_dt1  = _DAL
x_dt2  = _AL
x_data = "mov_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_dtreg"
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
         
   _NUMPRO = MOV_NUMPRO
  
   x_soci = "mov_soc = '" + _SOC + "'"
   x_anno = "mov_anno = '" + _ANNO + "'"
   x_nume = "mov_numpro = '" + _NUMPRO + "'"   
   x_cond = x_soci + " and " + x_anno + " and " + x_nume
   cSql = "select * from indice where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(cSql,"CUR_INDICE")
      RETURN .F.
   ENDIF
   SELECT CUR_INDICE
   GO TOP  

   T_DARE     = 0
   T_AVERE    = 0
   OK_TROVATO = .F.

   DO WHILE .T.
      
      IF EOF()
         EXIT
      ENDIF
      
	  OK_TROVATO = .T.
      EXIT
      
      SKIP +1  
      
   ENDDO  
  
   IF !OK_TROVATO
      SELECT CUR_MOVCONT  
      SCATTER MEMVAR MEMO
      SELECT WORK
      APPEND BLANK
      GATHER MEMVAR MEMO    
   ENDIF
  
   SELECT CUR_MOVCONT
   SKIP +1

ENDDO

SELECT WORK 
GO TOP

IF !EOF()
   =MESSAGEB("MOV_CONT OK , INDICE KO  !!!",16,"*** ATTENZIONE ***")    
   BROWSE FIELDS MOV_CONTO:20:H='CONTO',MOV_DTREG:15:H='DATA REG',MOV_NREGIS:15:H='NUM. REG.',;
   MOV_NDOC:15:H='NUM. DOC.',MOV_DTDOC:15:H='DATA DOC',MOV_IMP:15:H='TOTALE' NORMAL NOMENU NOEDIT NODELETE
ENDIF