*************************************************************************************************
*							CONTROLLA BANCE DEL FORNITORE										*
*						 																	    *
*	Crea vettori da u_for_an																    *
*						 																	    *
*						 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la creazione "+CHR(13)+"tabella vettori da anagrafica fornitori	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


IF !ExecCommand("select * from U_FOR_AN where 1=0","cB_U_FOR_AN")
   return
ENDIF

cSql = "delete from PARA where CODICE LIKE 'VET%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF



RELEASE _key_para
PUBLIC _key_para
_key_para = 0


__CONTA = 0

x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
local_conto1 = "5050104"
x_conto1 = "for_conto1 = '" + ALLTRIM(local_conto1) + "'"

x_cond = x_soci + " and " + x_conto1  
Csql   = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF
SELECT U_FOR_AN
GO TOP
IF !EOF()

	DO WHILE .NOT.EOF()

		SCATTER MEMVAR MEMO

		=CREA_VETTORE(M.FOR_CONTO1)
        __CONTA = __CONTA  +1
        
		SELECT U_FOR_AN
		SKIP +1
	ENDDO

	IF !ExecRW('','U_FOR_AN','I','','U_FOR_AN')
	  return(.f.)
	ENDIF
		
ENDIF 

WAIT WINDOWS "NUMERO VETTORI CREATI : "+STR(__CONTA,7,0)





=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

*********************
FUNCTION CREA_VETTORE
*********************
PARA FG
SELE=SELECT()


 
_key_para = _key_para + 1
_key_parachr  = STR(_key_para,3,0)

IF LEN(ALLTRIM(_key_parachr)) = 1
	_key_parachr = "00"+ALLTRIM(_key_parachr) 
ENDIF
IF LEN(ALLTRIM(_key_parachr)) = 2
	_key_parachr = "0"+ALLTRIM(_key_parachr) 
ENDIF

_key_parach = "VET"+_key_parachr  

x_cond = "codice = '" + _key_parach + "'"
cSql = "select * from PARA where " + x_cond + " order by codice"


IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF

SELECT PARA 
GO TOP
IF EOF()
	APPEND BLANK
ENDIF


M.CODICE = _key_parach
M.DESCRI = M.FOR_RAGSOC
M.LIBERA = ""


M.NOTE   = SUBSTR(M.FOR_RAGSOC,1,50)         +CHR(13)
M.NOTE   = M.NOTE + ALLTRIM(SUBSTR(M.FOR_INDIR,1,50)) + " " + ALLTRIM(SUBSTR(M.FOR_LOCALI,1,50))+CHR(13)
M.NOTE   = M.NOTE + "N.Iscrizione Albo:                 "   + CHR(13)
M.NOTE   = M.NOTE + "Patita Iva: "+M.FOR_PARIVA             + CHR(13)
M.NOTE   = M.NOTE + "Num Telefono: "+M.FOR_TELEFO	
	

REPLACE CODICE   				WITH M.CODICE
REPLACE DESCRI   				WITH M.DESCRI
REPLACE LIBERA   				WITH M.LIBERA
REPLACE NOTE     				WITH M.NOTE


IF !ExecRW('','PARA','I','','PARA')
  return(.f.)
ENDIF	

SELECT(SELE)
RETURN




 