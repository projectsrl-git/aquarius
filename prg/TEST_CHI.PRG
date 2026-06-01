DO SETLIB

   V_GGCHI='31'            && GIORNO PER CHIUSURA
   V_MMCHI='12'            && MESE   PER CHIUSURA
   V_AACHI='2010'          && ANNO   PER CHIUSURA
   V_GGAPE='01'            && GIORNO PER APERTURA
   V_MMAPE='01'            && MESE   PER APERTURA
   V_AAAPE='2011'          && ANNO   PER APERTURA


SET STEP ON 
CONTO_CHI  = "502001"		&& BILANCIO CHIUSURA
CONTO_PEP  = "601001"       && PROFITTI E PERDITE
V_ANNO     = "2010"

x_soci  = "mov_soc = '" + PUB_CODSOC + "'"
x_anno  = "mov_anno = '" + V_ANNO  + "'"
x_conto = "mov_conto = '" + CONTO_CHI  + "'"

x_cond = x_soci + " and " + x_anno + " and " + x_conto
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(cSql,"cu_mo_conca")
   return(.f.)
ENDIF
_saldo_dare  = 0
_saldo_avere = 0
SELECT cu_mo_conca
GO TOP
DO WHILE .T.
    IF EOF()
      EXIT
    ENDIF
    IF DELETED()
      SKIP +1
      LOOP
    ENDIF
 
    IF MOV_TMOV = 'D'
		_SALDO_DARE  = _SALDO_DARE  + MOV_IMP
	ENDIF


    IF MOV_TMOV = 'A'
		_SALDO_AVERE = _SALDO_AVERE + MOV_IMP
	ENDIF



    SKIP +1
ENDDO

DD=_SALDO_DARE  

AA=_SALDO_AVERE 

DD_AA = _SALDO_DARE  - _SALDO_AVERE 

ALLORA=DD_AA 


IF _SALDO_DARE  <> _SALDO_AVERE 
	DO FANNI_CREA_REGISTRAZIONE_SU_UTILE_ESERCIZIO_PROFITTI_E_PERDITE_PER_ESERCIZIO_CHIUSO WITH CONTO_CHI,CONTO_PEP,_SALDO_DARE,_SALDO_AVERE 
ENDIF




