*********************************************************************************
* 			GESTIONE ESENZIONI / COMMENTI STANDARD	DA BOLLE/ORDINI/OFFERTE		*
*********************************************************************************

IF EMPTY(IVA_ESE)
   RETURN
ENDIF

IF PUB_ESIVA			&& SOLO PER IVE INDICATE
   IF !VERYIVA(IVA_ESE)
      RETURN
   ENDIF
ENDIF

*===>>  ESENZIONE IVA
x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = 'INESE'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"CUR_NOTE")
   RETURN .F.
ENDIF
SELECT CUR_NOTE
GO TOP
IF EOF()
   =MESSAGEBOX("Testo standard 'INESE' "+CHR(13)+"non presente in testi standard",16,"*** ATTENZIONE ***")
   RETURN
ELSE
   M.ORD_NOTE = not_testo
ENDIF
  
*===>   TRASFORMO DATI ESENZIONE  
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".NDESCLI.",V_CLIES)    && NUMERO DOCUMENTO ESENZIONE CLIENTE 
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".DTESCLI.",V_DTCLES)   && DATA DOCUMENTO ESENZIONE CLIENTE
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".NDESSOC.",V_NSES)  	  && NUMERO DOCUMENTO ESENZIONE SOCIETA
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".DTESSOC.",V_DTNSES)   && DATA DOCUMENTO ESENZIONE SOCIETA

SELECT CU_FAT_DD
APPEND BLANK
 
m.ord_codart = SPACE(16)
M.ORD_MAGA	 = SPACE(06)   
M.ORD_DESART = "*** COMMENTO ***"    
M.ORD_MAGA	 = SPACE(06)   
M.ORD_DES2	 = SPACE(25)
M.ORD_UM	 = SPACE(02)
M.ORD_IVA	 = SPACE(02)
M.ORD_PREZZO = 0
M.ORD_QTAORD = 0
M.ORD_PRZNET = 0
M.ORD_VALORE = 0
M.ORD_SC1    = 0
M.ORD_SC2    = 0
M.ORD_SC3    = 0	 
M.ord_pubbli = " "
M.ORD_VALCO  = 0        
 
GATHER MEMVAR MEMO

SELECT CU_FAT_DD
XXX_ORD_SEQUEN = ORD_SEQUEN + 10  
REPLACE ORD_SEQUEN WITH XXX_ORD_SEQUEN

SELECT CU_FAT_DD

RETURN