DO SETLIB
SET STEP ON 

PUB_PERCENTUALE_IVA_DEFAULT  = 0
IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(PUB_IVA) + "'","cx_iva_para")
   return
ENDIF
SELECT cx_iva_para
IF reccount() <> 0
   cxxALIQ = SUBSTR(LIBERA,1,3)
   PUB_PERCENTUALE_IVA_DEFAULT = VAL(cxxALIQ)
ENDIF



_RIT = PUB_PERCENTUALE_IVA_DEFAULT 

