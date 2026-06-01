*************************************************************************************************
*							CONVERSIONE PROVVIGIONI												
*	by MICHELA														
*	20/12/2004				 																	*
*************************************************************************************************




****** CARICAMENTO DEL CURSORE ANAGRAFICA-PERSONALE

		IF !ExecCommand("select * from U_PRV_AN ","CU_PRV_AN")
		   return
		ENDIF
		SELECT CU_PRV_AN
	

****** DEFINIZIONE DEL CURSORE STP

		IF !ExecCommand("select * from U_PRV_AN where 1=0","curs_u_prv_an")
		   return
		ENDIF

		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE DELLA PRECEDENTE LISTA DEI MOVIMENTI" NOWAIT


** CANCELLAZIONE DEI RECORD DELLA TABELLA U_PRV_AN

		cSql = "delete from U_prv_an" 	&& CANCELLA TUTTO L'ARCHIVIO PROVVIGIONALE  
		IF !ExecCommand(cSql,"U_PRV_AN")
		   return(.f.)
		ENDIF

******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE
		PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE
		Y_CAMPO = ""
		V_CAMPO = ""
		_CTR    = 0
		_PROGRE = 0
		CREATE CURSOR TRANSITO (TRA_RECORD C(200))
              


**** CARICAMENTO DEL FILE IN FORMATO TESTO

		SELECT TRANSITO  
		*SET DEFAULT TO SYS(5)+"\DA PERSONALE\"
		gcTable = GETFILE('', 'Seleziona file netti da convertire', 'Converti',0)
		IF empty(gcTable) .or. gcTable = ""
		   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
		   SET DEFAULT TO &PUB_DIR
		   RETURN
		ENDIF
		APPEND FROM '&gcTable' SDF
		GO TOP
		*SET DEFAULT TO &PUB_DIR		

***** TOGLIE I RECORD SUPERFLUI

		SELECT TRANSITO

		DELETE FOR SUBSTR(TRA_RECORD,5,15) = "T  O  T  A  L  E"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,8) = "COVERTEC"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,37,2) = "--"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,3,2) = "=="  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,2) = "=="  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,2)="Da" all
		GO TOP 
		DELETE FOR SUBSTR(TRA_RECORD,1,7)="Importi" all
		GO TOP 
		DELETE FOR SUBSTR(TRA_RECORD,2,6)="Stampa" all
		GO TOP 
		DELETE FOR SUBSTR(TRA_RECORD,1,131)=SPACE(131) all
		GO TOP 
		DELETE FOR SUBSTR(TRA_RECORD,123,8)="MATURATE"   ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,79,12)="Non maturato"   ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,79,8)="Maturato"   ALL
		GO TOP	
		DELETE FOR SUBSTR(TRA_RECORD,79,9)="Fatturato"   ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,4)=". St"   ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,11)="a del Valle"   ALL
		GO TOP

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP


		SELECT TRANSITO
		GO TOP


		DO WHILE .T.

		   IF EOF()
		      EXIT
		   ENDIF

		******** ASSEGNAZIONE VARIABILI DEL FILE DI TESTO CHE E' CONTENUTO NEL CURSORE TRANSITO

		   SELECT TRANSITO
		   
		   M.prv_codsoc = "01"						&& RICORDARSI DI AGGIUNGERE ZERI NON SIGNIFIcativi 
           IF ALLTRIM(SUBSTR(TRA_RECORD,1,6))<>"Agente"
	           M.prv_codcli =TRC(9,ALLTRIM(SUBSTR(TRA_RECORD,22,3)))
    	   ENDIF        
    	   
    	   IF ALLTRIM(SUBSTR(TRA_RECORD,1,6))=""
    			M.PRV_CODCLI=M.PRV_CODCLI
    	   ENDIF
    	   
           IF ALLTRIM(SUBSTR(TRA_RECORD,1,6))<>"Agente"
	           m.prv_ragsoc=apitospa(ALLTRIM(SUBSTR(TRA_RECORD,26,25)))
	           M.prv_datfat =ALLTRIM(SUBSTR(TRA_RECORD,1,8))
	           M.prv_dtscad =ALLTRIM(SUBSTR(TRA_RECORD,58,8))
	           IF !EMPTY(m.prv_dtscad)
					m.prv_dtscad=SUBSTR(m.prv_dtscad,1,6)+"20"+SUBSTR(m.prv_dtscad,7,2)
			   ENDIF 
	       ELSE
	        	M.prv_ragsoc="" 
	        	M.prv_datfat=""   
    	   ENDIF        
           
  		   IF !EMPTY(m.prv_datfat) AND !EMPTY(m.prv_ragsoc)
  				m.prv_datfat="20"+ribalta2(m.prv_datfat)
  		   ENDIF	
  			
           IF ALLTRIM(SUBSTR(TRA_RECORD,130,1))="-"	
           			m.prv_tipodo="-"
           ELSE
           	  		m.prv_tipodo="+"
           ENDIF 	
           	
           IF M.prv_tipodo="-"     
	       		M.prv_imponi=m.prv_tipodo+ALLTRIM(SUBSTR(TRA_RECORD,98,10))
          		m.prv_imponi=STRTRAN(prv_imponi, '.','')
	            M.prv_imponi=STRTRAN(prv_imponi,',','.') 
	       ELSE 
	       		M.prv_imponi=ALLTRIM(SUBSTR(TRA_RECORD,98,10))
	       		m.prv_imponi=STRTRAN(prv_imponi, '.','')
	            M.prv_imponi=STRTRAN(prv_imponi,',','.') 
	       ENDIF
	        
	       *m.prv_nomnat=ALLTRIM(SUBSTR(TRA_RECORD,98,9))
       		m.prv_perpro=ALLTRIM(SUBSTR(TRA_RECORD,110,5))
       		m.prv_perpro=STRTRAN(prv_perpro, '.','')
            M.prv_perpro=STRTRAN(prv_perpro,',','.') 
       		
	       IF ALLTRIM(SUBSTR(TRA_RECORD,1,6))<>"Agente" 
	          m.prv_tmov=ALLTRIM(SUBSTR(tra_record,80,1))
	          
	          
	          IF M.prv_tipodo="-"     
		       	m.prv_totpro=m.prv_tipodo+ALLTRIM(SUBSTR(TRA_RECORD,122,8))
		       	m.prv_totpro=STRTRAN(prv_totpro, '.','')
	            M.prv_totpro=STRTRAN(prv_totpro,',','.') 
	          ELSE
		       	m.prv_totpro=ALLTRIM(SUBSTR(TRA_RECORD,122,8))
		       	m.prv_totpro=STRTRAN(prv_totpro, '.','')
	            M.prv_totpro=STRTRAN(prv_totpro,',','.') 
			  ENDIF 	
			  IF m.prv_tmov="M"
	          		m.prv_matura=m.prv_imponi
	          		m.prv_pmatur=m.prv_totpro	
	          		m.prv_nonmat=0
	          		m.prv_pnonma=0	
	          ELSE 
	          		m.prv_matura=0
	          		m.prv_pmatur=0
	          		m.prv_nonmat=m.prv_imponi
	          		m.prv_pnonma=m.prv_totpro	
	          ENDIF
	       ENDIF
		   IF ALLTRIM(SUBSTR(TRA_RECORD,1,6))="Agente"
	       		m.prv_codage=ALLTRIM(SUBSTR(TRA_RECORD,10,2))
	       		m.prv_desage=ALLTRIM(SUBSTR(TRA_RECORD,13,30))
	       ENDIF
	       
	       m.prv_valuta="EUR"
	       m.prv_cambio=1
	       
		  IF ALLTRIM(SUBSTR(TRA_RECORD,68,3))="Fat"
		 	m.prv_tipfat="VEN"
		  ENDIF 	
		  
		  IF ALLTRIM(SUBSTR(TRA_RECORD,68,3))="NoA"
		 	m.prv_tipfat="699"
		  ENDIF
		   
		  IF ALLTRIM(SUBSTR(TRA_RECORD,68,3))="Ins"
		 	m.prv_tipfat="INC"
		  ENDIF
		  
		  IF ALLTRIM(SUBSTR(TRA_RECORD,68,3))="Sto"
		 	m.prv_tipfat="STO"
		  ENDIF
		  
		  M.prv_anno=ALLTRIM(SUBSTR(M.prv_datfat,1,4))
		  m.prv_mese=ALLTRIM(SUBSTR(M.prv_datfat,6,2))
		  IF ALLTRIM(SUBSTR(TRA_RECORD,1,6))<>"Agente"	
		  		M.PRV_NUMFAT=ALLTRIM(SUBSTR(TRA_RECORD,11,5))
		  ENDIF
		  
		  SELECT curs_u_prv_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		  APPEND BLANK
		  GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
											&&  ESEMPIO : REPLACE BAN_CODBAN WITH M.BAN_CODBAN		   
		   
		  _CTR = _CTR +1
		  WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

		  SELECT TRANSITO      
		  SKIP +1

		ENDDO

SELECT curs_u_prv_an
GO TOP
SELECT TRANSITO
GO TOP 
_DESCR=""
_CODPAG=""
SELECT curs_u_prv_an
GO TOP
WAIT WINDOW "Attendere prego ..." nowait


DO WHILE !EOF()
	
	IF CURS_U_PRV_AN.prv_imponi=0 AND CURS_U_PRV_AN.prv_perpro=0 AND CURS_U_PRV_AN.prv_totpro=0
		DELETE
	ENDIF 
	
	***CODICE CLIENTE
	_COD=ALLTRIM(CURS_U_PRV_AN.prv_codcli)

	IF ALLTRIM(CURS_U_PRV_AN.prv_codcli)<>"000000000" &&OR ALLTRIM(CURS_U_PRV_AN.prv_codcli)=""
		_CODICE=_COD	
		
	ENDIF 
	
    ***RAGIONE SOCIALE
    IF ALLTRIM(CURS_U_PRV_AN.prv_codcli)=""	
	ELSE	
		_RAGSOC=ALLTRIM(CURS_U_PRV_AN.prv_RAGSOC)
		IF ALLTRIM(CURS_U_PRV_AN.prv_RAGSOC)<>""
			_DESCR=_RAGSOC
		ENDIF 
	ENDIF
	
	***ANNO
	_V_ANNO=ALLTRIM(CURS_U_PRV_AN.prv_ANNO)
	IF ALLTRIM(CURS_U_PRV_AN.prv_anno)<>"" 
		_ANNO=_V_ANNO	
	ENDIF 
	
	***MESE
	_V_MESE=ALLTRIM(CURS_U_PRV_AN.prv_mese)
	IF ALLTRIM(CURS_U_PRV_AN.prv_mese)<>"" 
		_MESE=_V_MESE	
	ENDIF 
	
	***NUM. DOCUMENTO
	_NUMDOC=ALLTRIM(CURS_U_PRV_AN.prv_numfat)
	IF ALLTRIM(CURS_U_PRV_AN.prv_numfat)<>"" 
		_NDOC=_NUMDOC	
	ENDIF 
	
	
	***DATA DOCUMENTO
	_DATADOC=ALLTRIM(CURS_U_PRV_AN.prv_datfat)
	IF ALLTRIM(CURS_U_PRV_AN.prv_datfat)<>"" 
		_DATAD=_DATADOC	
	ENDIF
	
		IF !ExecCommand("SELECT * from u_cli_an where cli_codcli='" + ALLTRIM(_CODICE)+"'","u_cli_an") 
		   RETURN .f.
		ENDIF 
	    SELECT U_CLI_AN
   		GO TOP
   		IF EOF()
			IF !ExecCommand("SELECT * from u_cli_an where cli_ragsoc like '" + ALLTRIM(_DESCR)+"%'","u_cli_an") 
			   RETURN .f.
			ENDIF 
   			_CODPAG =u_cli_an.cli_conpag	
   		ELSE
			_CODPAG =u_cli_an.cli_conpag
   		ENDIF
   		
		IF !ExecCommand("SELECT * from para where codice = 'cpa" + ALLTRIM(_CODPAG)+"'","cur_para") 
		   RETURN .f.
		ENDIF 
		_DESPAG=cur_para.descri
	
	SELECT curs_u_prv_an
	REPLACE PRV_CODCLI WITH _CODICE
	REPLACE PRV_STORIC WITH "S"
	
	
 	IF ALLTRIM(CURS_U_PRV_AN.prv_codcli)=""	
	ELSE
		REPLACE PRV_RAGSOC WITH _DESCR
		REPLACE PRV_ANNO   WITH _ANNO
		REPLACE PRV_MESE   WITH _MESE
		REPLACE PRV_DATFAT WITH _DATAD
		REPLACE PRV_CODPAG WITH _CODPAG
		REPLACE PRV_DESPAG WITH _DESPAG
		REPLACE PRV_NUMFAT WITH _NDOC
	ENDIF		
	
	SELECT curs_u_prv_an
	SKIP +1

ENDDO  
SELECT curs_u_prv_an
GO TOP

****** AGGIORNA TABELLA curs_u_prv_an 

		IF !ExecRW('','U_PRV_AN','I','','curs_u_prv_an')
		   return(.f.)
		ENDIF
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN

   
*********************
PROCEDURE TOGLI_PUNTI
*********************

YY      = LEN(V_CAMPO)
XX      = 1
Y_CAMPO =  ' '
DO WHILE .T.
   IF XX > YY
      EXIT
   ENDIF
   IF SUBSTR(V_CAMPO,XX,1) = '.' 
   ELSE
      Y_CAMPO = Y_CAMPO + SUBSTR(V_CAMPO,XX,1) 
   ENDIF
   XX = XX + 1
ENDDO

RETURN


**************************
PROCEDURE VERIFICA_CLIENTE
**************************

x_soci = "cli_codsoc = '" + M.CLI_CODSOC + "'"
x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
x_cond = x_soci + " and " + x_codi
cSql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecRW(cSql,"u_cli_an","R")
   return
ENDIF
SELECT u_cli_an
IF EOF()
   m.id_unique = ""
   APPEND BLANK
ENDIF
M.CLI_RAGSOC = UPPER(M.CLI_RAGSOC)
M.CLI_RAGSOC = APITOSPA(M.CLI_RAGSOC)
M.CLI_INDIR  = UPPER(M.CLI_INDIR)
M.CLI_INDIR  = APITOSPA(M.CLI_INDIR)
M.CLI_LOCALI = UPPER(M.CLI_LOCALI)
M.CLI_LOCALI = APITOSPA(M.CLI_LOCALI)
M.CLI_PROVIN = UPPER(M.CLI_PROVIN)
M.CLI_PROVIN = APITOSPA(M.CLI_PROVIN)
M.CLI_CODFIS = UPPER(M.CLI_CODFIS)
M.CLI_CODFIS = APITOSPA(M.CLI_CODFIS)

REPLACE CLI_CODSOC WITH M.CLI_CODSOC
REPLACE CLI_CODCLI WITH M.CLI_CODCLI
REPLACE CLI_RAGSOC WITH M.CLI_RAGSOC
REPLACE CLI_INDIR  WITH M.CLI_INDIR
REPLACE CLI_CAP    WITH M.CLI_CAP
REPLACE CLI_LOCALI WITH M.CLI_LOCALI
REPLACE CLI_PROVIN WITH M.CLI_PROVIN
REPLACE CLI_PARIVA WITH M.CLI_PARIVA
REPLACE CLI_CODFIS WITH M.CLI_CODFIS
REPLACE CLI_AGE    WITH M.CLI_AGE
REPLACE CLI_SC1    WITH M.CLI_SC1
REPLACE CLI_SC2    WITH M.CLI_SC2
REPLACE CLI_TELEFO WITH M.CLI_TELEFO
REPLACE CLI_TELEX  WITH M.CLI_TELEX
REPLACE CLI_FAX    WITH M.CLI_FAX
REPLACE CLI_VALUTA WITH PUB_VALU
REPLACE CLI_NAZION WITH PUB_NAZI
REPLACE CLI_DATNEW WITH RIBALTA2(DTOC(DATE()))
REPLACE CLI_DATINS WITH RIBALTA2(DTOC(DATE()))
REPLACE CLI_CONPAG WITH PUB_CPA
REPLACE CLI_CODIVA WITH PUB_IVA
REPLACE CLI_BDAL   WITH "0108"
REPLACE CLI_BAL    WITH "3108"
REPLACE CLI_GG1    WITH "1009"
REPLACE CLI_B2DAL  WITH "2012"
REPLACE CLI_B2AL   WITH "3112"
REPLACE CLI_GG2    WITH "1001"
REPLACE CLI_TIPFAT WITH "FDV"
REPLACE CLI_FLGTRA WITH .T.

IF !ExecRW(cSql,"u_cli_an","W")
   return
ENDIF



_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

RETURN