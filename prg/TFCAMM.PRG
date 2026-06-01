**************************************************************************************************************
*																			 								 *
*																			 								 *
* 			 		TRASFERIMENTO IN CONTABILITA GENERALE DDELLE QUOTE DI AMMORTAMENTO BENI					 *
*																			 								 *
*																											 *
**************************************************************************************************************

   
CT = 0
_CONTA_ANOMALIE  = 0
=DEF_AQUAREP()


DATADAL = RIBALTA2(DATADAL)
DATAAL = RIBALTA2(DATAAL)

x_codi = "REPLACE(ORD_DTUTIL,ORD_DTUTIL,SUBSTRING(ORD_DTUTIL,7,4)+'/'+SUBSTRING(ORD_DTUTIL,4,2)+'/'+SUBSTRING(ORD_DTUTIL,1,2)) "
X_cond1 = "BETWEEN '"+DATADAL+ "' AND '" + DATAAL +"'"
X_cond2 = "ORD_RCGE=0"
X_cond3 = "ORD_ANNO ='" + SUBSTR(DATADAL,1,4)+ "'"
x_cond = x_codi + x_cond1+' AND '+x_cond2 + ' AND '+x_cond3
cSql="SELECT * FROM U_AMM_DD WHERE " + x_cond + "ORDER BY "+ x_codi 
IF !ExecCommand(cSql,"CU_AMM_DD")
	return(.f.)
ENDIF
		
SELECT CU_AMM_DD
GO TOP




SELECT SUM(ORD_ACCANN) AS SOMMA, CAM_CATEG FROM CU_AMM_DD GROUP BY CAM_CATEG,ORD_ANNO HAVING(ORD_ANNO=PUB_ANNO) ORDER BY CAM_CATEG INTO CURSOR TRASFE
SELECT TRASFE
GO TOP




DO WHILE .NOT.EOF()

	x_categ = cam_categ
	
	x_soci = "cam_soc = '" + PUB_CODSOC + "'"
	x_anno = "CAM_categ = '" + x_categ + "'"
	x_cond = x_soci + " and " + x_anno
	Csql   = "select * from u_cam_an where " + x_cond + " order by cam_soc,cam_categ"
	IF !ExecCommand(cSql,"u_cam_an")
          WAIT WINDOW "Errore manca categoria = " + x_categ
	ENDIF

	IF !EOF()
		X_CONTO   =  CAM_CONTR
		X_CONTROP =  CAM_CONTO
	ENDIF
	
	SCATTER MEMVAR MEMO

    _ANOMALIE = .F.
	CT	= CT + 1

  	
    DO valorizza_dare		&& CONTO CATEGORIA *********************************  1° movimento
    DO valorizza_avere		&& CONTO F.DO AMM.TO********************************  2° movimento


	SELECT TRASFE
	SKIP +1

ENDDO WHILE .NOT.EOF()

DO aggiorna_U_AMM_DD

RELEASE WINDOW DISPLAY

WAIT WINDOWS 'Elaborate n. '+str(CT,5,0)+' record elaborati'+CHR(13)
WAIT WINDOWS 'Elaborazione completata ...' NOWAIT

=MESSAGEBOX("Trasferimento quote ammortamento in contabilità terminato correttamente",62,"ATTENZIONE")

RELEASE WINDOW DISPLAY

RETURN



***************************************************************************
PROCEDURE valorizza_dare      && CONTO CATEGORIA
***************************************************************************


    PUB_BLOCCA_SBLOCCA_PREVISIONALE="E"  
  
    CGE_CON				= ALLTRIM(X_CONTO)             

    *!*	PRELEVA LA DESCRIZIONE DEL CONTO CONTABILE
    
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_cont = "con_conto = '" + ALLTRIM(CGE_CON) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecCommand(cSql,"conti")
       WAIT WINDOW "Errore durante la lettura della tabella conti, codice = " + CGE_CON
	ENDIF
	SELECT conti
	GO TOP
	IF EOF()
       WAIT WINDOW "Errore manca il conto contabile = " + CGE_CON
	ENDIF
  
    
	CGE_DESCO  			= CON_DESCR


    SELECT TRASFE 
	
	CGE_TOPX			= "QAM"				&& CONTO CATEGORIA BENE
	_NPARF 				= ""   			   	&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= "CARICA"      	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= "CARICA"      	&& CREA INDICE
	_NREG				= "CARICA"			&& RICERCA IL NUMERO DI REISTRAZIONE UTENE
    _NDOC				= "CARICANREG"		&& IMPOSTA IL NUMERO DI REGISTRAZIONE

	
	CGE_COMM 			= "QUOTE DI AMMORTAMENTO "
	CGE_COM1 			= "ANNUALI"
	CGE_DA   			= SOMMA
	CGE_AV   			= 0
	CGE_IV   			= "NO"
	CGE_IMP  			= 0.00

	
	CGE_CECOS  			= SPACE(13)  
	CGE_WCCAGE 			= SPACE(3)
	CGE_KABBUO 			= 0
	CGE_XNOTE  			= SPACE(13)
	CGE_XCCLI  			= SPACE(10)
	CGE_XCFOR  			= SPACE(10)
	**CGE_DATAREG			= DTOC(DATE())
*	CGE_DATAREG			= ribalta2(XDATA)
	CGE_DATAREG			= XDATA
	CGE_NPARF			= 0
			
	**CGE_DATADOC			= data_elab
	CGE_DATADOC			= XDATA
	CGE_NDOC			= CGE_NREG				
	CGE_FR				= .F.
	CGE_PESO			= 0
	CGE_TISPE			= SPACE(03)
	CGE_PORTO			= SPACE(03)
	CGE_CLDOG			= SPACE(16)
	CGE_BANCA			= "001"
*	CGE_DATASCAD		= data_elab
	CGE_DATASCAD		= ""
	CGE_CPA				= PUB_CPA
	CGE_BOLLATOIVA		= SPACE(01)

	CGE_COSATRATTA		= ""
	CGE_GRADOIMPORTANZA	= ""
	CGE_FORMAPAGAMENTO	= ""
	CGE_TIPOCONTRATTO	= ""
	CGE_CODACQ			= ""
	CGE_PRIPAGA			= ""



	CGE_XCAMBIO			= PUB_CAMBIO
	CGE_XVALUTA			= PUB_VALRIF
	CGE_XDATAVAL		= DTOC(DATE())
	CGE_XANOMAX			= SPACE(3) 
	CGE_CECO			= SPACE(10)
	CGE_SEQUEN			= 10				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "EFFETTIVA"	&& CONSIDERA LA REGISTRAZIONE COME EFFETTIVE

	=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	



RETURN



***************************************************************************
PROCEDURE valorizza_avere      && CONTO F.DO AMM.TO
***************************************************************************

    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  

   
    CGE_CON				= X_CONTROP

    SELECT TRASFE 
	
	CGE_TOPX			= "QAM"				&& CONTO F.DO AMM.TO
	_NPARF 				= ""      			&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= ""      			&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= ""      			&& CREA INDICE
	_NREG				= ""				&& MANTIENE IL NUMERO DI REGISTRAZIONE PRELEVATO IL PRECEDENZA
    _NDOC				= "CARICANREG"		&& MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

	
	CGE_COMM 			= "QUOTE DI AMMORTAMENTO " 
	CGE_COM1 			= "ANNUALI"
	CGE_DA   			= 0
	CGE_AV   			= SOMMA
	CGE_IV   			= "NO"
	CGE_IMP  			= 0.00

	
	CGE_CECOS  			= SPACE(13)  
	CGE_WCCAGE 			= SPACE(3)
	CGE_KABBUO 			= 0
	CGE_XNOTE  			= SPACE(13)
	CGE_XCCLI  			= SPACE(10)
	CGE_XCFOR  			= SPACE(10)
	**CGE_DATAREG			= DTOC(DATE())
	CGE_DATAREG			= XDATA
	CGE_NPARF			= 0


	*CGE_DATADOC			= data_elab
*	CGE_DATADOC			= ribalta2(XDATA)
	CGE_DATADOC			= XDATA
	CGE_NDOC			= CGE_NREG
	CGE_FR				= .F.
	CGE_PESO			= 0
	CGE_TISPE			= SPACE(03)
	CGE_PORTO			= SPACE(03)
	CGE_CLDOG			= SPACE(16)
	CGE_BANCA			= "001"
*	CGE_DATASCAD		= data_elab
	CGE_DATASCAD		= ""
	CGE_CPA				= PUB_CPA
	CGE_BOLLATOIVA		= SPACE(01)

	CGE_COSATRATTA		= ""
	CGE_GRADOIMPORTANZA	= ""
	CGE_FORMAPAGAMENTO	= ""
	CGE_TIPOCONTRATTO	= ""
	CGE_CODACQ			= ""
	CGE_PRIPAGA			= ""



	CGE_XCAMBIO			= PUB_CAMBIO
	CGE_XVALUTA			= PUB_VALRIF
	CGE_XDATAVAL		= DTOC(DATE())
	CGE_XANOMAX			= SPACE(3) 
	CGE_CECO			= SPACE(10)
	CGE_SEQUEN			= 20				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "EFFETTIVA"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE PREVISIONALE

    IF !_ANOMALIE
		=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	
	ENDIF

RETURN



****************************************************************************************
PROCEDURE aggiorna_U_AMM_DD     && AGGIORNA FLAG DI TRASFERITO IN CONTABILITA GENERALE
****************************************************************************************

*** AGGIORNA IL RECORD ORD_RCGE SU U_AMM_DD CON 1 PER I RECORD TRASFERITI
x_codi = "REPLACE(ORD_DTUTIL,ORD_DTUTIL,SUBSTRING(ORD_DTUTIL,7,4)+'/'+SUBSTRING(ORD_DTUTIL,4,2)+'/'+SUBSTRING(ORD_DTUTIL,1,2)) "
X_cond1 = " BETWEEN '"+DATADAL+ "' AND '" + DATAAL +"'"
X_cond2 = "ORD_RCGE=0"
X_cond3 = "ORD_ANNO ='" + SUBSTR(DATADAL,1,4)+ "'"
x_cond = x_codi + x_cond1+" AND "+x_cond2 + " AND "+x_cond3
cSql1="UPDATE U_AMM_DD SET ORD_RCGE = 1 WHERE " + x_cond 
IF !ExecCommand(cSql1,"U_AMM_DD")
	return(.f.)
ENDIF

RETURN

