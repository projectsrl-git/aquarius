*************************************************************************************************
*							    CONVERSIONE ANAGRAFICA BANCHE  		  							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2017 : Impresind					 													*
*************************************************************************************************


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "IMP"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'IMP' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH

RIT = MESSAGEBOX("Conversione anagrafica banche da DBF: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF



CREATE CURSOR curs_BANCHE (BAN_CODABI  C(10),   BAN_CODCAB  C(10),   BAN_CODBAN  C(10),   BAN_DESBAN  C(100),   BAN_INDIR   C(100),   BAN_CAP     C(10), ;
					   BAN_LOCA    C(100))


****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from U_BAN_AN where 1=0","curs_U_BAN_AN")
   return
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0

				

CREATE CURSOR IMPORTADBF ( ;
	bacodban	C(100), ;
	bacodabi	C(100), ;
	bacodcab	C(100), ;
	badesban	C(100), ;
	baindiri	C(100), ;
	ba___cap	C(100), ;
	balocali	C(100), ;
	baprovin	C(100))
	

_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
&_COMMAND




***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

_CTR_ELA = 0
_TOT_COUNT = 0

SELECT IMPORTADBF
GO TOP 


DO WHILE !EOF()

	WAIT WINDOWS "Conversione anagrafica banche " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
		
    IF DELETED()
       SELECT IMPORTADBF  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(BACODBAN)) = "BACODBAN"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTADBF  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR memo 
  
    M.BAN_CODSOC  = PUB_CODSOC
	M.BAN_CODABI  = CONV_CLEAR(APITOSPA(ALLTRIM(m.bacodabi)))
	M.BAN_CODCAB  = CONV_CLEAR(APITOSPA(ALLTRIM(m.bacodcab)))
	M.BAN_CODBAN  = M.BAN_CODABI + M.BAN_CODCAB
    M.DESCRI 	  = ALLTRIM(APITOSPA(ALLTRIM(m.badesban)))	
	M.BAN_DESBAN  = CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 	
	M.BAN_INDIR   = CONV_CLEAR(APITOSPA(ALLTRIM(m.baindiri)))
	M.BAN_CAP     = CONV_CLEAR(APITOSPA(ALLTRIM(m.ba___cap)))
    M.BAN_LOCA    = CONV_CLEAR(APITOSPA(ALLTRIM(m.balocali)))
    M.BAN_PROVIN  = CONV_CLEAR(APITOSPA(ALLTRIM(m.baprovin)))
    M.BAN_DATINS  = __DATINS 
	*M.BAN_NOTE1   = CONV_CLEAR(APITOSPA(ALLTRIM(m.badesfil)))
	
 

    _CTR_ELA = _CTR_ELA +1
   	

	cSql = "select * from U_BAN_AN where BAN_CODBAN = '"+ALLTRIM(M.BAN_CODBAN)+"'"
	IF !ExecCommand(cSql,"___temp_u_ban_an")
	   RETURN .F.
	ENDIF
	SELECT ___temp_u_ban_an
	GO TOP
	IF EOF()
	ELSE
       SELECT IMPORTADBF   && scarto il record in quanto esistente
       SKIP +1
       LOOP
    ENDIF       

	SELECT curs_BANCHE 
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					

	

	SELECT curs_U_BAN_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTADBF
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA U_BAN_AN SQL
IF !ExecRW('','U_BAN_AN','I','','curs_U_BAN_AN')
   return(.f.)
ENDIF
	 

SELECT curs_BANCHE 
GO TOP
COPY TO ANABAN_INE SDF


	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE"+CHR(13)+"N.RECORD ELABORATI :"+STR(_CTR_ELA,6,0)+CHR(13)+"N.RECORD SCRITTI :"+STR(_CTR,6,0),62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 