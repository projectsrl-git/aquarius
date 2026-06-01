**************************************************************************************
*																					 *
*     TRASFERIMENTO IN CONTABILITA GENERALE DELLE RICEVUTE BANCARIE CLIENTI          * 
*																					 *
**************************************************************************************
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)

IF !ExecCommand("select * from u_ric_dd where 0=1","u_ric_dd")
   return(.f.)
ENDIF
SELECT U_RIC_DD
RRDD=AFIELDS(RD)
CREATE CURSOR RIC_DD FROM ARRAY RD

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CREATE CURSOR W_FAT (W_CONTO C(13),W_DA C(1),W_IVA C(3), ;
        W_IMPONI N(17,3) ,W_IMPOSTA N(17,3),W_PUBBLI N(17,3)  ,W_NUMDOC C(10),W_DTDOC C(10))
        
SELECT W_FAT        
INDEX ON W_CONTO+ W_DA + W_IVA TAG DETTA
SET ORDER TO DETTA

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti clienti"
   RETURN
ENDIF
CC=SUBSTR(LIBERA,1,4)

CT      = 0
CTRELAB = 0

******************************* GESTIONE RICEVUTE BANCARIE ******************

DATREG  = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
PERDAL  = RIBALTA2(DATADAL)
PERAL   = RIBALTA2(DATAAL)
CTRELAB = 0
RELEASE XSD
PUBLIC XSD
XSD     = 0

WAIT WINDOWS "Controllo preventivo Ricevute Bancarie..." NOWAIT

RELEASE ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE,_NUMERO_FATTURA_ESISTENTE,_DATA_FATTURA_ESISTENTE,_NUMERO_REGISTRAZIONE_ESISTENTE
PUBLIC ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE,_NUMERO_FATTURA_ESISTENTE,_DATA_FATTURA_ESISTENTE,_NUMERO_REGISTRAZIONE_ESISTENTE
ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE 	= .F.
_NUMERO_FATTURA_ESISTENTE 					= ""
_DATA_FATTURA_ESISTENTE   					= ""
_NUMERO_REGISTRAZIONE_ESISTENTE				= ""

x_soci = "ric_codsoc = '" + PUB_CODSOC + "'"
x_dtda = "ric_dtfatt >= '" + PERDAL + "'"
x_dtal = "ric_dtfatt <= '" + PERAL + "'"
x_cond = x_soci + " and " + x_dtda + " and " + x_dtal
Csql = "select * from u_ric_tt where " + x_cond + " order by ric_codsoc,ric_dtfatt"
IF !ExecCommand(Csql,"CONTR_RIBA")
   return(.f.)
ENDIF
SELECT CONTR_RIBA
GO TOP
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT CONTR_RIBA
      SKIP +1
      LOOP
   ENDIF

   IF RIC_CGE
      SELECT CONTR_RIBA
      SKIP +1
      LOOP
   ENDIF

   IF !EMPTY(_ndistinta)
   	   IF ALLTRIM(_ndistinta) <> ALLTRIM(RIC_NUMDIS)
	      SKIP +1
    	  LOOP
	   ENDIF
   ENDIF
   
   V_CODCLI = RIC_CODCLI
  
   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
   x_cond   = x_soci + " and " + x_codi
   Csql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cur_cliente")
      return(.f.)
   ENDIF
   SELECT cur_cliente
   GO TOP
   IF !EOF()
      V_NAZION  = CLI_NAZION
   ELSE
      V_NAZION  = SPACE(03)
   ENDIF 

   V_ER=SOTTOGEN(V_NAZION)
   IF !V_ER
	  CC = PUB_CC
   ENDIF
   
   SELECT CONTR_RIBA
   
   _CONTO_	= CC+RIC_CODCLI
   _ANNO_   = SUBSTR(RIC_DTFATT,1,4)
   _DATAF_  = RIC_DTFATT
   _NUMEF_  = RIC_NFATT
   _TIOPE_  = RIC_TOP   
   _DTSCA_  = RIC_DTSCAD

   x_soci   = "INDICE.mov_soc = '" + PUB_CODSOC + "'"
   x_anno   = "INDICE.mov_anno = '" + _anno_ + "'"
   x_cont   = "INDICE.mov_conto = '" + ALLTRIM(_CONTO_) + "'"
   x_data   = "INDICE.mov_dtdoc = '" + _DATAF_ + "'"
   x_ndoc   = "INDICE.mov_nprot = '" + _NUMEF_ + "'"  
   x_top    = "INDICE.mov_top = '" + _tiope_ + "'"
   x_dtsc   = "PART_CLI.par_dtscad = '" + _DTSCA_ + "'"
   x_cond   = x_soci + " and " + x_anno + " and " + x_cont + " and " + x_data + " and " + x_ndoc + " and " + x_top + " and " + x_dtsc
   cSql     = "SELECT PART_CLI.PAR_DTSCAD,INDICE.* FROM INDICE LEFT OUTER JOIN PART_CLI ON INDICE.MOV_NUMPRO = PART_CLI.PAR_NUMPRO WHERE " + x_cond + ;
              " order by mov_soc,mov_anno,mov_conto,mov_dtreg,mov_nregis,par_dtscad"
   IF !ExecCommand(cSql,"CU_INDICE")
       return(.f.)
   ENDIF 
   SELECT CU_INDICE
   GO TOP
   IF !EOF()
      ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE = .T.
      _NUMERO_REGISTRAZIONE_ESISTENTE			= MOV_NREGIS
      _NUMERO_FATTURA_ESISTENTE					= MOV_NPROT
      _DATA_FATTURA_ESISTENTE					= MOV_DTDOC
      EXIT
   ENDIF
   
   SELECT CONTR_RIBA
   SKIP +1
   LOOP
ENDDO

IF ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE
   DO PLAYWAV WITH "BLIP.WAV" 
 		   XDESCRI="Attenzione"
   SET CLASSLIB TO "proj_lib.vcx" additive
   oForm=CreateObject("MsgErr") 
   oform.edit1.Value=""+XDESCRI+CHR(13)+;
			  "Esiste almeno una Ri.Ba. già trasferita reg.: "+ALLTRIM(_NUMERO_REGISTRAZIONE_ESISTENTE)+" - n.f. "+ALLTRIM(_NUMERO_FATTURA_ESISTENTE)+;
			  " - dt."+ribalta2(_DATA_FATTURA_ESISTENTE)+"; devi annullare le ricevute obsolete in contabilità per proseguire"
   oform.Show
   RELEASE oForm 
   RETURN
ENDIF

x_soci = "ric_codsoc = '" + PUB_CODSOC + "'"
x_data = "ric_dtfatt >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql = "select * from u_ric_tt where " + x_cond + " order by ric_codsoc,ric_dtfatt"
IF !ExecRW(Csql,"U_RIC_TT","R")
   return(.f.)
ENDIF

* VERIFICA SE LE FATTURE SONO STATE TRASFERITE IN CONTABILITA' ALTRIMENTI BLOCCA IL TRASFERIMENTO DELLE RICEVUTE
SELECT U_RIC_TT
GO TOP

___FATTURANONTRASFERITAINCGE = .F.


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF RIC_CGE
      SKIP +1
      LOOP
   ENDIF  


   IF !EMPTY(_ndistinta)
   
   	   IF ALLTRIM(_ndistinta) <> ALLTRIM(RIC_NUMDIS)
	      SKIP +1
    	  LOOP
	   ENDIF  
     
   ENDIF

   __BAN_PRES = RIC_BAPRES
   __NUM_DIST = RIC_NUMDIS
   __NUM_FATT = RIC_NFATT   
   _ESISTE_CONTO = CONTROLLO_ESISTENZA_CONTO_PRESENTAZIONE_EFFETTI(__BAN_PRES)
   IF !_ESISTE_CONTO
    	=MESSAGEBOX("Errore manca conto effetti nella banca : "+__BAN_PRES+CHR(10)+"Numero distinta : "+__NUM_DIST+CHR(10)+"Numero fattura : "+__NUM_FATT+CHR(10)+"L' EFFETTO RELATIVO NON VERRA' TRASFERITO!",48,"### ATTENZIONE ###")
    	SELECT U_RIC_TT
      	SKIP +1
   	  	LOOP
   ENDIF


   IF RIC_DTFATT > PERAL
      EXIT
   ENDIF  

   
   WGAN = TAGGANCIO

   
   x_agga = "daggancio = '" + ALLTRIM(WGAN) + "'"
   x_cond = x_agga
   Csql   = "select * from u_ric_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(Csql,"CUR_RIC_DD")
      return(.f.)
   ENDIF
   SELECT CUR_RIC_DD
   GO TOP
   
   DO WHILE .NOT. EOF()
   
		x_dt1  = RIC_DATFAT
		x_numf = RIC_FATAGE
		x_condi = "ord_datord = '" + x_dt1 + "' and '" + x_numf + "'" +" = ord_numord"
		cSql="select * from u_fat_tt where " + x_condi 

		IF !ExecCommand(cSql,"X_FAT_TT")
		   return(.f.)
		ENDIF

	    IF !EOF()
		    SELECT X_FAT_TT
		    GO top
		  
		    IF !ord_cge
		       ___FATTURANONTRASFERITAINCGE = .T.
		       EXIT
		    ENDIF
		ENDIF


        SELECT CUR_RIC_DD
        SKIP +1
     
   ENDDO WHILE .NOT. EOF()	    

      
   SELECT U_RIC_TT
   SKIP +1

ENDDO

IF ___FATTURANONTRASFERITAINCGE 

   =MESSAGEBOX("Esistono delle fatture non ancora trasferite in contabilità generale !!!",16,"Attenzione")
   =MESSAGEBOX("Procedere prima al trasferimento delle fatture , e poi con il trasferimento delle ricevute ",16,"Attenzione")

   RETURN

ENDIF


SELECT U_RIC_TT
GO TOP

IF !EOF()

	DO WHILE .T.

	   IF EOF()
	      EXIT
	   ENDIF

	   IF DELETED()
	      SKIP +1
	      LOOP
	   ENDIF
	   
	   IF RIC_CGE
	      SKIP +1
	      LOOP
	   ENDIF  

	   IF !EMPTY(_ndistinta)
	   
	   	   IF ALLTRIM(_ndistinta) <> ALLTRIM(RIC_NUMDIS)
		      SKIP +1
	    	  LOOP
		   ENDIF  
	     
	   ENDIF


	   __BAN_PRES = RIC_BAPRES
	   __NUM_DIST = RIC_NUMDIS
	   __NUM_FATT = RIC_NFATT   
	   _ESISTE_CONTO = CONTROLLO_ESISTENZA_CONTO_PRESENTAZIONE_EFFETTI(__BAN_PRES)
	   IF !_ESISTE_CONTO
	    	=MESSAGEBOX("Errore manca conto effetti nella banca : "+__BAN_PRES+CHR(10)+"Numero distinta : "+__NUM_DIST+CHR(10)+"Numero fattura : "+__NUM_FATT+CHR(10)+"L' EFFETTO RELATIVO NON VERRA' TRASFERITO!",48,"### ATTENZIONE ###")
	    	SELECT U_RIC_TT
	      	SKIP +1
	   	  	LOOP
	   ENDIF



	   IF RIC_DTFATT > PERAL
	      EXIT
	   ENDIF  

	   CTRELAB=CTRELAB+1 
	   WAIT WINDOW "Ricevute Elaborate "+STR(CTRELAB,6,0) NOWAIT

	   DO REG_NUMRPN
	   DO REG_NUMREG

	   SELECT U_RIC_TT
	   
	   WGAN = TAGGANCIO
	   RIC  = SELECT()

	   x_agga = "daggancio = '" + ALLTRIM(WGAN) + "'"
	   x_cond = x_agga
	   Csql   = "select * from u_ric_dd where " + x_cond + " order by daggancio"
	   IF !ExecCommand(Csql,"RIC_DD")
	      return(.f.)
	   ENDIF
	   SELECT RIC_DD
	   GO TOP

	   SELECT U_RIC_TT

	   DD_TOP = RIC_TOP

	   v_seek	= 'TOP' + DD_TOP
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	   ELSE
	      WAIT WINDOW "Errore manca parametro TOP"
	      RETURN
	   ENDIF

	   XXCONTO = CONTO1							&& CONTROPARTITA GENERICA RIFERITA ALLA BANCA
	*** fabiano 02/09/2015 - sposto il controllo sul conto dopo aver verificato se esiste una contropartita SPECIFICA della banca di presentazione   
	*** 					 altrimenti sono costretto a trasferire tutte le riba sullo stesso conto effetti
	*!*	   IF EMPTY(CONTO1)
	*!*	      WAIT WINDOW "Errore manca conto nel parametro TOP : "+DD_TOP
	*!*	      RETURN
	*!*	   ENDIF	
	  
	   SELECT U_RIC_TT
	  
	    _BAPRES  = RIC_BAPRES
		
		x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "ban_codban = '" + ALLTRIM(_BAPRES) + "'"
		x_cond = x_soci + " and " + x_codi
		Csql   = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
		IF !ExecCommand(cSql,"cur_banca")
		   return(.f.)
		ENDIF
		SELECT cur_banca
		GO TOP
		IF !EOF()
		    IF !EMPTY(BAN_CONRIC)
		    	*** FABIANO 23/03/2012 - GESTIONE TRATTE/CAMBIALI
		    	IF ALLTRIM(DD_TOP) <> ALLTRIM(PUB_TRATTA)
					XXCONTO  = BAN_CONRIC			&& CONTROPARTITA RIFERITA ALLA BANCA
				ENDIF
			ENDIF
		ENDIF

	*** fabiano 02/09/2015 - sposto il controllo sul conto dopo aver verificato se esiste una contropartita SPECIFICA della banca di presentazione   
	   IF EMPTY(XXCONTO)
	      WAIT WINDOW "Errore manca conto nel parametro TOP : "+DD_TOP+" o nella banca di presentazione "+ALLTRIM(_BAPRES)
	      RETURN
	   ENDIF	
	   
	   SELECT U_RIC_TT
	   
	   V_CODCLI = RIC_CODCLI
	   KCON     = CC+RIC_CODCLI
	  
	   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
	   x_codi   = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
	   x_cond   = x_soci + " and " + x_codi
	   Csql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	   IF !ExecCommand(cSql,"cur_cliente")
	      return(.f.)
	   ENDIF
	   SELECT cur_cliente
	   GO TOP
	   IF !EOF()
	      V_NAZION  = CLI_NAZION
	   ELSE
	      V_NAZION  = SPACE(03)
	   ENDIF 

	   V_ER=SOTTOGEN(V_NAZION)
	   IF !V_ER
		  CC = PUB_CC
	   ENDIF 

	   SELECT U_RIC_TT

	   *M.CONTO  = CC+RIC_CODCLI
	   M.CONTO  = CC+TRASFORMA_CODICE_CONTO_CONTABILE('CODICE_CLI_FOR',RIC_CODCLI)  && ERASMO - 11/05/2022
	   *XCON     = CC+RIC_CODCLI
	   XCON     = CC+TRASFORMA_CODICE_CONTO_CONTABILE('CODICE_CLI_FOR',RIC_CODCLI)  && ERASMO - 11/05/2022
	   M.DTD    = RIC_DTFATT
	   M.DOC    = RIC_NFATT
	   M.OLFAT  = RIC_NFATT
	   M.RAGSOC = RIC_RAGSOC
	   V_TOTALE = RIC_TRANC
	   M.NUMASS = ""
	   M.BANCA  = RIC_BACLI
	   DATA_PAGA= RIC_DTSCAD  
	   XXNOTA   = SUBSTR(RIC_RAGSOC,1,25) + " SC: " + RIBALTA2(DATA_PAGA)
	   AGENTE   = "   "      && SUBSTR(CLI_AGE,1,3)
	   XCLI_COD = RIC_CODCLI
	   XXCODAGE = "   "      
	   TOP_TOP  = RIC_TOP    
	   XVALUTA  = RIC_VALUTA
	   XCAMBIO  = RIC_CAMBIO
	   V_CONPAG = RIC_CONPAG               
	   CIVA     = "NO" 
	   TIVA     = 0
	   XNOTA    = RIC_NOTE
	   DAVD     = "A"

	   ** CREA MOVIMENTO IN AVERE SU CLIENTE  
	   DO MOVCRINC WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,.T.,M.OLFAT,XVALUTA,XCAMBIO  &&TESTATA
	   DO MOVCREAI WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO      &&INDICE
	   ** CREA MOVIMENTO IN DARE SU PORTAFOGLIO EFFETTI
	   DO MOVCRINC WITH "D",V_TOTALE,0,'NO',XXCONTO,TOP_TOP,M.DOC,M.DTD,.F.,M.OLFAT,XVALUTA,XCAMBIO   &&DETTAGLI
	   =carica_riepiloghi_contabili(XXCONTO,'',V_TOTALE,GETDCON(XXCONTO))
	   
	   SELECT U_RIC_TT

	   IF RIC_RICMAN='S'
	   		_SALVA_AGGANCIO_RIBA_MANUALE=RIC_AGGMAN
	   		DO AGGIORNA_NUMERO_PARTITA_RICEVUTE_MANUALI WITH _SALVA_AGGANCIO_RIBA_MANUALE
	   ENDIF
	  
	   REPLACE RIC_CGE WITH .T.
	   REPLACE RIC_NUMPRO WITH ALLTRIM(PN_C)	&& 2016/02/14 SERGIO : SERVE PER ANNULLARE AUTOMATICAMENTE LE RICEVUTE BANCARIE SE L'UTENTE RIPRISTINA LE FATTURE UTILIZZANDO IL TASTO DI RIPRISTINO DENTRO RIBANEW

	  
	   XSD = XSD +1
	   
	   SELECT U_RIC_TT
	   SKIP +1
	  
	ENDDO

	IF !ExecRW(Csql,"U_RIC_TT","W")
	   return(.f.)
	ENDIF


    IF XSD > 0
		IF !PUB_CONTABILIZZA_RIBA 
			MESSAGEBOX('Elaborazione completata correttamente.'+CHR(13)+'Contabilizzate nr.'+str(XSD,5,0)+' ricevute bancarie'+CHR(13)+'Numero distinta elaborata : '+ALLTRIM(_ndistinta),32,'Trasferimento ricevute bancarie')
		ELSE
			IF EMPTY(PUB_DISTINTE_CONTABILIZZATE)
				PUB_DISTINTE_CONTABILIZZATE = PUB_DISTINTE_CONTABILIZZATE + CHR(13) + CHR(13) + 'CONTABILIZZAZIONE RICEVUTE BANCARIE'+CHR(13)+CHR(13)+CHR(13)+CHR(13)+ 'Elaborazione completata correttamente,  contabilizzate nr.'+str(XSD,5,0)+'   ri.ba : distinta : '+ALLTRIM(_ndistinta)+CHR(13)
			ELSE
				PUB_DISTINTE_CONTABILIZZATE = PUB_DISTINTE_CONTABILIZZATE + + 'Elaborazione completata correttamente,  contabilizzate nr.'+str(XSD,5,0)+'   ri.ba : distinta : '+ALLTRIM(_ndistinta)+CHR(13)
			ENDIF
			
		ENDIF
	ENDIF

ENDIF

RELEASE WINDOW DISPLAY

RETURN


*************
PROCEDURE CHK
*************
PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH ' '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY 
KEYBOARD "{RIGHTARROW}+{LEFTARROW}" 
RETURN


***************************************************************************
PROCEDURE movcreai      && crea la partita primaria SU INDICE
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

IF !ExecCommand("select * from indice where 0=1","cu_indice")
   return(.f.)
ENDIF
SELECT CU_INDICE
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP 
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH XNOTA
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
IF !ExecRW('','indice','I','','CU_INDICE')
   return(.f.)
ENDIF
 
SELECT(SELE)

RETURN


***********************************************
* AGG. NUMERO DI REGISTRAZIONE  INTERNO DI PN *
***********************************************

PROCEDURE REG_NUMRPN

v_seek   = 'NUMREGPN'+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
ELSE
   RIT=MSGBOX('Numero di registrazione (NUMREGPN) interno non trovato','ATTENZIONE',31)
   RETURN
ENDIF
   
PN=VAL(SUBSTR(LIBERA,1,10))
PN=PN + 1
PN_C=STR(PN)
*  REPLACE LIBERA WITH ALLTRIM(PN_C)  
PN_C=sys(2015)
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***********************************************
* AGG. NUMERO DI REGISTRAZIONE  UTENTE        *
***********************************************

PROCEDURE REG_NUMREG

v_seek   = 'NUMREG'+PUB_ANNO+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
ELSE
   RIT=MSGBOX("Errore durante l'aggiornamento del numero di registrazione",'ATTENZIONE',31)
   RETURN
ENDIF
C_NUM=SUBSTR(LIBERA,1,10)
V_NUM=VAL(C_NUM)
T_NUM=V_NUM+1
TC_NUM=STR(T_NUM)
REPLACE LIBERA WITH ALLTRIM(TC_NUM)  
NREG=TC_NUM
X_NREG = NREG
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***************************************************************************
PROCEDURE MOVCRINC      && crea la partita primaria e il partitario clienti
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,PARTITARIO,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_ANNODO WITH SUBSTR(MOV_DTDOC,1,4)   
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP 
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH XXNOTA
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF
 
******AGGIORNA IL D.B. DEI CONTI
   
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(CON) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"conti","R")
   return(.f.)
ENDIF
SELECT conti
GO TOP
IF !EOF()
   P_IMPA= CON_IMP_A
   P_IMPD= CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ELSE
   APPEND BLANK
   REPLACE CON_SOC    WITH PUB_CODSOC
   REPLACE CON_ANNO   WITH PUB_ANNO
   REPLACE CON_CONTO  WITH CON
   REPLACE CON_DESCR  WITH M.RAGSOC
   REPLACE CON_TIPOCO WITH "C"
   REPLACE CON_POSBIL WITH "P"
   REPLACE CON_IVASN  WITH .F. 
   P_IMPA = CON_IMP_A
   P_IMPD = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ENDIF 
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

IF PARTITARIO
   DO RED_PARINC    && AGGIORNA PARTITARIO CLIENTI
ENDIF  
 
SELECT(SELE)
RETURN


************************************************************************* 
*   AGGIORNAMENTO PARTITARIO CLIENTI                                    *
************************************************************************* 
PROCEDURE RED_PARINC

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
*x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
x_codi = "cli_codcli = '" + IIF(PUB_CONTOSIMILCEE, TRC(PUB_LCL,ALLTRIM(SUBSTR(CON,RAT('.',CON,1)+1))), ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO))) + "'"  && SERGIO - 18/12/2021
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
IF !EOF()
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA 
   V_RAGSOC  = CLI_RAGSOC 
   V_CODAGE  = CLI_AGE
ELSE
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16) 
   V_RAGSOC  = "CLIENTE INESISTENTE"
   V_CODAGE  = "   "
ENDIF 

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = "101"   && FORZATURA CPA CONTANTI
ENDIF 

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
    
SELECT RIC_DD
GO TOP
   
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
      
   SCATTER MEMVAR 

   SELECT CU_PARTCLI
   APPEND BLANK
   REC_PART=RECNO()     
   REPLACE PAR_CODSOC  WITH PUB_CODSOC
   REPLACE PAR_ANNO    WITH PUB_ANNO
   REPLACE PAR_TIPODO  WITH "PAG"
   REPLACE PAR_TMOV    WITH "A"
   REPLACE PAR_CODCLI  WITH CON
   REPLACE PAR_RAGSOC  WITH V_RAGSOC
   IF SUBSTR(DATREG,3,1) = '/'
      REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)
   ELSE
      REPLACE PAR_DTREG  WITH DATREG           
   ENDIF
   IF SUBSTR(DTD,3,1) = '/'
      REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)
   ELSE
      REPLACE PAR_DTFAT  WITH DTD
   ENDIF
   
*!*	   IF SUBSTR(DATA_PAGA,3,1) = '/'
*!*	      REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_PAGA)
*!*	      REPLACE PAR_DATPAG  WITH RIBALTA2(DATA_PAGA)
*!*	   ELSE
*!*	      REPLACE PAR_DTSCAD  WITH DATA_PAGA          
*!*	      REPLACE PAR_DATPAG  WITH DATA_PAGA
*!*	   ENDIF

   REPLACE PAR_DTSCAD  WITH M.RIC_DATSCA         
   REPLACE PAR_DATPAG  WITH M.RIC_DATSCA
     
   REPLACE PAR_TIPFAT  WITH TOP
   REPLACE PAR_NPROT   WITH M.RIC_FATAGE               && NUMERO DI FATTURA AGENTE
   REPLACE PAR_TOTIM   WITH M.RIC_TOTALE
   REPLACE PAR_TIMPOS  WITH TIVA
   REPLACE PAR_FATT    WITH M.RIC_TOTALE
   REPLACE PAR_NUMFAT  WITH ALLTRIM(STR(M.RIC_NUMPAR,6,0)) &&NDOC
   REPLACE PAR_NPROG   WITH 900
   REPLACE PAR_NPART   WITH M.RIC_NUMPAR   &&VAL(NDOC)
   REPLACE PAR_CODPAG  WITH V_CONPAG
   REPLACE PAR_TEL     WITH V_TELEFO
   REPLACE PAR_IVA     WITH V_PARIVA
   REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
   REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
   REPLACE PAR_CIVA1   WITH CIVA
   REPLACE PAR_IMPO1   WITH M.RIC_TOTALE
   REPLACE PAR_IMPOS1  WITH TIVA
   REPLACE PAR_TOT1    WITH M.RIC_TOTALE
   REPLACE PAR_CIVA2   WITH "   "
   REPLACE PAR_IMPO2   WITH 0
   REPLACE PAR_IMPOS2  WITH 0
   REPLACE PAR_TOT2    WITH 0
   REPLACE PAR_CIVA3   WITH "   "
   REPLACE PAR_IMPO3   WITH 0
   REPLACE PAR_IMPOS3  WITH 0
   REPLACE PAR_TOT3    WITH 0
   REPLACE PAR_CIVA4   WITH "   "
   REPLACE PAR_IMPO4   WITH 0
   REPLACE PAR_IMPOS4  WITH 0
   REPLACE PAR_TOT4    WITH 0
   REPLACE PAR_CIVA5   WITH "   "
   REPLACE PAR_IMPO5   WITH 0
   REPLACE PAR_IMPOS5  WITH 0
   REPLACE PAR_TOT5    WITH 0
   REPLACE PAR_VALUTA WITH YVALUTA
   REPLACE PAR_CAMBIO WITH YCAMBIO
   IF SUBSTR(DTD,3,1) = '/'
      REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
   ELSE
      REPLACE PAR_DTVAL  WITH DTD
   ENDIF
   REPLACE PAR_IMPVAL WITH 0	          && VALORE IN VALUTA

   SELECT RIC_DD
   SKIP+1

ENDDO

IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF




*!*	=CREA_SALDI_CF("C",CON,ALLTRIM(STR(M.RIC_NUMPAR,6,0)),"XXXXXXXXXX","CREA")


RETURN



************************************************************************* 
*   VERIFICA ESISTENZA DEL CONTO DI PRESENTAZIONE IN ANAGRAFICA BANCHE  *
************************************************************************* 
FUNCTION CONTROLLO_ESISTENZA_CONTO_PRESENTAZIONE_EFFETTI
************************************************************************* 
	PARAMETERS __CONTO_BANCA

	_swsx_ = SELECT()

    _BANCA_PRESENTAZIONE  = __CONTO_BANCA
	
	_ESISTE = .T.
	
	x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "ban_codban = '" + ALLTRIM(_BANCA_PRESENTAZIONE) + "'"
	x_cond = x_soci + " and " + x_codi
	Csql   = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
	IF !ExecCommand(cSql,"cu_ban")
	   return(.f.)
	ENDIF
	SELECT cu_ban
	GO TOP
	IF !EOF()
	    IF EMPTY(BAN_CONRIC)
	    	_ESISTE = .F.
	    ENDIF
	ELSE    		
		_ESISTE = .F.
	ENDIF
	
	SELECT(_swsx_)

RETURN _ESISTE



************************************************************************* 
PROCEDURE AGGIORNA_NUMERO_PARTITA_RICEVUTE_MANUALI
************************************************************************* 
PARAMETERS _AGGANCIO

LOCAL _NOWSEL 

_NOWSEL = SELECT()


x_agga = "DAGGANCIO = '" + ALLTRIM(_AGGANCIO) + "'"
x_cond = x_agga
Csql   = "SELECT * FROM U_RIM_DD WHERE " + x_cond 
IF !ExecCommand(Csql,"CUR_RIM_DD")
	return(.f.)
ENDIF

SELECT CUR_RIM_DD
GO TOP
   

DO WHILE !EOF()
	   
	
	_OLD_NUMPAR=RIC_NUMPAR
	_NEW_NUMPAR=RIC_NEWPAR
	
	IF _NEW_NUMPAR=0
		SELECT CUR_RIM_DD
		SKIP
		LOOP
	ENDIF

	
	cSql="UPDATE MOV_CONT SET MOV_NPART = "+ALLTRIM(STR(_NEW_NUMPAR,10,0))+" WHERE MOV_NPART ="+ALLTRIM(STR(_OLD_NUMPAR,10,0))
	IF !ExecCommand(cSql,"_TEMP")
		return(.f.)
	ENDIF
    
	cSql="UPDATE INDICE SET MOV_NPART = "+ALLTRIM(STR(_NEW_NUMPAR,10,0))+" WHERE MOV_NPART ="+ALLTRIM(STR(_OLD_NUMPAR,10,0))
	IF !ExecCommand(cSql,"_TEMP")
		return(.f.)
	ENDIF

	cSql="UPDATE PART_CLI SET PAR_NPART = "+ALLTRIM(STR(_NEW_NUMPAR,10,0))+" WHERE PAR_NPART ="+ALLTRIM(STR(_OLD_NUMPAR,10,0))
	IF !ExecCommand(cSql,"_TEMP")
		return(.f.)
	ENDIF
	   
	   
	SELECT CUR_RIM_DD
	SKIP
	 
ENDDO
   
SELECT(_NOWSEL)

RETURN
