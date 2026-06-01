************************************************
*     ANALISI DARE / AVERE MOV_CONT
************************************************
PARA _SOC,_ANNO,_DAL,_AL

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
   
   T_DARE  = 0
   T_AVERE = 0

   DO WHILE .T.
      
      IF EOF()
         EXIT
      ENDIF
      
*!*	      IF MOV_IVAOMA 			&&  SCARTA RECORD IVA OMAGGIO
*!*	        SELECT CUR_MOVCONT
*!*	        SKIP + 1
*!*	        LOOP
*!*	      ENDIF


      IF MOV_TMOV="D"
         T_DARE=T_DARE+MOV_IMP
      ELSE
         T_AVERE=T_AVERE+MOV_IMP
      ENDIF  
      
      SKIP +1  
   ENDDO  
  
   IF T_DARE-T_AVERE<>0
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

BROWSE FIELDS MOV_CONTO:20:H='CONTO',MOV_DTREG:15:H='DATA REG',MOV_NREGIS:15:H='NUM. REG.',;
MOV_NDOC:15:H='NUM. DOC.',MOV_DTDOC:15:H='DATA DOC',MOV_IMP:15:H='TOTALE' NORMAL NOMENU NOEDIT NODELETE