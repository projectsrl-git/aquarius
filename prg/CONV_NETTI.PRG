*************************************************************************************************
*							CONVERSIONE ARCHIVIO CONTENENTE LA LISTA DEI                    	*
*							PAGAMENTI DEI DIPENDENTI PROVENIENTE DALLA 							*
*	by MICHELA				PROCEDURA DI PAGHE E STIPENDI										*
*	21/07/2004				 																	*
*************************************************************************************************
PARAMETERS _anno,_mese



****** CARICAMENTO DEL CURSORE ANAGRAFICA-PERSONALE

		IF !ExecCommand("select * from U_GPE_AN ","CU_GPE_AN")
		   return
		ENDIF
		SELECT CU_GPE_AN
		INDEX ON GPE_MATRI TAG GPE_MATRI
		SET ORDER TO GPE_MATRI
		

****** DEFINIZIONE DEL CURSORE STP

		IF !ExecCommand("select * from U_GPP_MO where 1=0","curs_u_gpp_mo")
		   return
		ENDIF

		IF !ExecCommand("select * from U_GPE_AN where 1=0","curs_u_gpe_an")
		   return
		ENDIF

		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE DELLA PRECEDENTE LISTA DEI MOVIMENTI" NOWAIT


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_GPP_MO SQL

		cSql = "delete from U_GPP_MO where GPP_ANNO='"+ ALLTRIM(_ANNO)+ "' AND GPP_MESE='" + ALLTRIM(_MESE) + "'" 
		IF !ExecCommand(cSql,"U_GPP_MO")
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

  
*!*			SET DEFAULT TO SYS(5)+"\DA PERSONALE\"
*!*			gcTable = GETFILE('', 'Seleziona file netti da convertire', 'Converti',0)
*!*			IF empty(gcTable) .or. gcTable = ""
*!*			   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
*!*			   SET DEFAULT TO &PUB_DIR
*!*			   RETURN
*!*			ENDIF
*!*			

		v_seek   = 'FSD'+"006"		&& LISTA PAGAMENTOSTIPENDI PERSONALE E COMPENSI PER COLLABORATORI 
		v_chiave = 'codice'
		cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
		IF !ExecCommand(cSql,"CODICE_FSD")
		  return(.f.)
		ENDIF
		SELECT CODICE_FSD
		GO TOP
		PUB_PATH_FSD  =""
		IF !EOF()
		  PUB_PATH_FSD  = ALLTRIM(LIBERA)
		ENDIF

		gcTable=SYS(5)+ALLTRIM(PUB_PATH_FSD)
		IF !FILE(gcTable)
			MESSAGEBOX("File inesistente "+ALLTRIM(gcTable),48,"Attenzione!")
		   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
		   SET DEFAULT TO &PUB_DIR
		   RETURN
		ENDIF
		
		SELECT TRANSITO		
		APPEND FROM '&gcTable' SDF
		GO TOP
		SET DEFAULT TO &PUB_DIR		

***** TOGLIE I RECORD SUPERFLUI

		SELECT TRANSITO

		DELETE FOR SUBSTR(TRA_RECORD,5,15) = "T  O  T  A  L  E"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,8) = "COVERTEC"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,37,2) = "--"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,2,2) = "=="  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,2,14) = "Banca/Agenzia"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,4)="RETR" all
		GO TOP 
		DELETE FOR OCCURS('&', TRA_RECORD)>0 ALL
		GO TOP
		

		DELETE FOR empty(TRA_RECORD)   ALL
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
       		   		
		   M.gpp_matri = ALLTRIM(SUBSTR(TRA_RECORD,2,2))						&& RICORDARSI DI AGGIUNGERE ZERI NON SIGNIFIcativi 
           M.gpp_cognom = ALLTRIM(SUBSTR(TRA_RECORD,5,30))
           m.gpp_cognom=UPPER(m.gpp_cognom)
           m.gpp_cognom=apitospa(m.gpp_cognom)
           M.gpp_dapaga =ALLTRIM(SUBSTR(TRA_RECORD,43,20))
	       m.gpp_dapaga=STRTRAN(gpp_dapaga, '.','')
	       M.gpp_dapaga=STRTRAN(gpp_dapaga,',','.') 
		   M.gpp_anno=_anno
		   m.gpp_mese=_mese	
		   M.GPP_DTSCAD=_ANNO+"/"+_MESE+"/27"
		   
		   

		   SELECT curs_u_gpp_mo				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		   APPEND BLANK
		   GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
											&&  ESEMPIO : REPLACE BAN_CODBAN WITH M.BAN_CODBAN		   
		   
		   _CTR = _CTR +1
		   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

		   SELECT TRANSITO      
		   SKIP +1

		ENDDO

SELECT curs_u_gpp_mo
GO TOP
SELECT TRANSITO
GO TOP 
	DO WHILE .t.
			
		   IF EOF()
		      EXIT
		   ENDIF
		   XX_MATRI=ALLTRIM(SUBSTR(TRA_RECORD,2,2))
		   XX_COGNOM= ALLTRIM(SUBSTR(TRA_RECORD,5,30))
           XX_COGNOM=UPPER(XX_COGNOM)
           XX_COGNOM=apitospa(XX_COGNOM)
			IF !ExecCommand("select * from U_GPE_AN where gpe_matri='"+ALLTRIM(xx_matri)+"' and gpe_cognom='"+ALLTRIM(xx_cognom)+"'","cur_gpe_an")
			   return
			ENDIF
			SELECT cur_gpe_an
			GO top
			IF RECCOUNT()=0
			
					m.gpe_matri=XX_MATRI
					m.gpe_cognom=XX_COGNOM
					SELECT curs_u_gpe_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
			   		APPEND BLANK
			   		GATHER MEMVAR MEMO 		
			endif	
		
			
		SELECT TRANSITO
		SKIP +1
	enddo


SELECT curs_u_gpp_mo
GO TOP


****** AGGIORNA TABELLA U_GPP_MO SQL

		IF !ExecRW('','U_GPP_MO','I','','curs_u_gpp_mo')
		   return(.f.)
		ENDIF
****** AGGIORNA TABELLA U_GPE_AN SQL
	 	iF !ExecRW('','U_GPE_AN','I','','curs_u_gpe_an')
		   return(.f.)
		ENDIF
	 
*!*	=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

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