****************************************************************************************************************
* 			                TRASFERIMENTO IN CONTABILITA GENERALE DELLE FATTURE CLIENTI       				   *
*																			 								   *
*																			 								   *
*	NOTE :																									   *
*																			 								   *
*																			 								   *
*			IDENTIFICA SE LA FATTURA/NOTA CREDITO E' RELATIVA A UN PAESE MEMBRO DELLA COMUNITA' EUROPEA (CEE)  *
*																			 								   *
*			PER LE SPESE DI TRASPORTO DEI CLIENTI EXTRA CEE GESTISCE IL CODICE IVA DI ANAGRAFICA SE DIGITATO   *
*																			 								   *
*																			 								   *
*			CONTABILIZZAZIONE DATI INTRASTAT MEMORIZZATI SULLA FATTURA 	(IN BASE A PUB_INTRASTAT)			   * EFFETTUA UN RAGRUPPAMENTO PER CONT+C.COSTO+CLASSE DOGANALE+SERVIZI INTRASTAT+.....
*																			 								   *
*																			 								   *
*			CONTABILIZZAZIONE DIRETTA DELLA FATTURA APPENA GENERATA 	(IN BASE A PUB_CONFAT)				   * IN FUNZIONE DEL FLAG PUB_CONFAT E' POSSIBILE CONTABILIZZARE LA FATTURA 
*																			 								   *
*																			 								   *
*			VEDIART = ROUTIN PER DETERMINARE IL CONTO CONTABILE DELLA CONTROPARTITA							   *
*																			 								   *
*				--CONTROPARTITE CONTABILI --																   *
*																			 								   *
*					 -DETERMINA CONTROPARTITA SU BASE PERSONALIZZAZIONE RICHIESTA 						       * NON PROSEGUE NELLA RICERCA SUCCESSIVA SE LO TROVA
*					 -DETERMINA CONTROPARTITA SU BASE PARAMETRO ATTIVITA' STUDI PROFESSIONALI			       * NON PROSEGUE NELLA RICERCA SUCCESSIVA SE LO TROVA 
*					 -DETERMINA CONTROPARTITA SU BASE TIPO OPERAZIONE									       * NON PROSEGUE NELLA RICERCA SUCCESSIVA SE LO TROVA
*					 -ACCESSO ANAGRAFICA CLIENTI														       * SE NON TROVATO PROSEGUE ALL'OPZIONE SUCCESSIVA
*					 -ACCESSO ANAGRAFICA ARTICOLI														       * SE NON TROVATO PROSEGUE ALL'OPZIONE SUCCESSIVA
*					 -ACCESSO SE RICHIESTO AL PARAMETRO LINEA / NAZIONE									       * SE NON TROVATO PROSEGUE ALL'OPZIONE SUCCESSIVA	
*					 -DETERMINA CONTROPARTITA SU BASE TIPO OPERAZIONE SOLO PER LE NOTE DI ACCREDITO 	       * SE NON TROVATO PROSEGUE ALL'OPZIONE SUCCESSIVA
*					 -DETERMINA CONTROPARTITA SE IN TESTATA FATTURA E' STATA INDICATA UNA CONTROPARTITA        * SE NON GESTITO PROSEGUE ALL'OPZIONE SUCCESSIVA
*					 -DETERMINA CONTROPARTITA SE IN DETTAGLIO FATTURA E' STATA INDICATA UNA CONTROPARTITA      * SE NON GESTITO PROSEGUE ALL'OPZIONE SUCCESSIVA
*					 -VERIFICA SU PIANO DEI CONTI ESISTENZA CONTO                                          	   *
*																			 								   *
*				--CENTRI DI COSTO --															 			   *
*																			 								   *
*					 -DETERMINA IL CENTRO DI COSTO DAL PARAMETRO CENTRO DI COSTO STANDARD SE ATTIVATO	       * DOPO AVERLO IMPOSTATO PROSEGUE SULL'OPZIONE SUCCESSIVA
*					 -DETERMINA IL CENTRO DI COSTO DA ANAGRAFICA ARTICOLI SE IL PARAMETRO E' ATTIVATO	       * DOPO AVERLO IMPOSTATO PROSEGUE SULL'OPZIONE SUCCESSIVA 
*					 -DETERMINA IL CENTRO DI COSTO DA ANAGRAFICA CLIENTI SE IL PARAMETRO E' ATTIVATO   		   * DOPO AVERLO IMPOSTATO PROSEGUE SULL'OPZIONE SUCCESSIVA  
*					 -DETERMINA IL CENTRO DI COSTO DALLE RIGHE DELLA FATTURA SE IL PARAMETRO E' ATTIVATO   	   * ULTIMA OPZIONE  
*																			 								   *
*																											   *
*																			 								   *
*			CREAZIONE AUTOMATICA DI DUE REGISTRAZIONI NEL CASO DI	 										   *
*					 ARTICOLO PUBBLICITARIO CON IVA A CARICO DEL CLIENTE (ORD_PUBBLI = 'S' PARAMETRO AOC)	   *
*																											   *
*					1) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							CLIENTE IN 					1200												   *
*							MERCE CONTO VENDITA							1000								   *
*							IVA CONTO VENDITA							200									   *
*																											   *
*					2) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							CLIENTE IN 									1000							       *
*							COSTO OMAGGI				1000												   *
*						    																				   *
*			SE PUB_OMACIO2 = .T.:                                                                              * PUB_OMACIO2 = .T. => TRASFERISCE FATTURATO CON IVA A CARICO AZIENDA (OMAGGI) CREANDO 2 REGISTRAZIONI AL POSTO DI 3 REGISTRAZIONI
*																											   *
*			    CREAZIONE AUTOMATICA DI UNA SECONDA/TERZA REGISTRAZIONE NEL CASO DI :						   *
*					 ARTICOLO IN OMAGGIO CON IVA A CARICO AZIENDA (ORD_PUBBLI = 'O' PARAMETRO AOM)	           *
*																											   *
*					1) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							CLIENTE IN 					1200												   *
*							MERCE CONTO VENDITA							1000								   *
*							IVA CONTO VENDITA							200									   *
*																											   *
*					2) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							CLIENTE IN 									1200								   *
*							COSTO OMAGGI (V_AOM)		1000												   *
*							COSTO IVA OMAGGIO (V_CIO)	 200												   *
*																											   *
*			ALTRIMENTI:																						   * PUB_OMACIO2 = .F. => TRASFERISCE FATTURATO CON IVA A CARICO AZIENDA (OMAGGI) CREANDO 3 REGISTRAZIONI
*																											   *
*			     CREAZIONE AUTOMATICA DI UNA SECONDA/TERZA REGISTRAZIONE NEL CASO DI :						   *
*					 ARTICOLO IN OMAGGIO CON IVA A CARICO AZIENDA (ORD_PUBBLI = 'O' PARAMETRO AOM)	           *
*																											   *
*					1) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							CLIENTE IN 					1200												   *
*							MERCE CONTO VENDITA							1000								   *
*							IVA CONTO VENDITA							200									   *
*																											   *
*					2) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							CLIENTE IN 									1000								   *
*							COSTO OMAGGI (V_AOM)		1000												   *
*																											   *
*					3) REGISTRAZIONE :																		   *
*														DARE			AVERE								   *
*							COSTO IVA OMAGGIO (V_CIO)	 200												   *
*							CLIENTE										200									   *
*																											   *
*			CREAZIONE AUTOMATICA DEI CENTRI DI COSTO														   *
*																											   *
*																											   *
*																											   *
*			GESTIONE DELLE NOTE DI ACCREDITO CHE LEGANO PIU' FATTURE (UNA NOTA CREDITO LEGA MAX 15 FATTYRE	   *
*																											   *
*																											   *
*			GESTIONE CONDIZIONI DI PAGAMENTO SPECIALI														   *
*																											   *
*																											   *
*			GESTIONE INCASSO FATTURA : CREA AUTOMATICAMETE LA REGISTRAZIONE  CONTABILE DI INCASSI			   *
*			CHIUDENDO LA PARTITA CLIENTE																	   *
*																											   *
*			GESTIONE ANTICIPI : CREA AUTOMATICAMETE LA REGISTRAZIONE CONTABILE DI GIROCONTO TRA CLIENTE        *
*			CONTO ANTICIPI CHIUDENDO LA PARTITA CLIENTE, QUANDO	IN FATTURA C'E' UNA RIGA CON SEGNO NEGATIVO    *
*			E CONTO CONTABILE = PUB_ANTCLI_CONTO  														       *
*																											   *
*																											   *
****************************************************************************************************************

LPARAMETERS __TFC_CONTABILIZZA_SINGOLA_FATTURA,__TFC_CODCLI,__TFC_NUMORD,__TFC_DATORD



****************************************************** VARIABILI PER LA GESTIONE DELLA PRIMA NOTA ****************************************
PUB_VARPN = .F.
PUB_ANNPN = .F.
PUB_RICPN = .F.
****************************************************** VARIABILI PER LA GESTIONE DELLA PRIMA NOTA ****************************************

RELEASE CONTO 
PUBLIC CONTO 
CONTO = ""

RELEASE FLAG_ANTICIPO_CAMBIO_SEGNO
PUBLIC FLAG_ANTICIPO_CAMBIO_SEGNO
FLAG_ANTICIPO_CAMBIO_SEGNO = .F.
RELEASE _S_ORD_NUMORD,_S_ORD_DATORD,_S_ORD_RAGSOC
PUBLIC _S_ORD_NUMORD,_S_ORD_DATORD,_S_ORD_RAGSOC
_S_ORD_NUMORD=""
_S_ORD_DATORD=""
_S_ORD_RAGSOC=""


RELEASE V_IVASPTRAS
PUBLIC V_IVASPTRAS
V_IVASPTRAS = ""

*** FABIANO 02/03/2015 - GESTIONE ANTICIPI
LOCAL _VALORE_SU_ANTICIPO   
_VALORE_SU_ANTICIPO   =0
*** FABIANO 02/03/2015 - GESTIONE ANTICIPI


**------------------------- VARIABILI INTRASTAT --------------------------**
RELEASE Z_PROVIN_DESTI_INTRA
RELEASE Z_NAZIONE_INTRA
RELEASE Z_COND_CONS_INTRA  
RELEASE __QTA_KG
RELEASE __QTA_UM  && ERASMO - 08/05/2015 - QTA IN UM
RELEASE __UNITA_SUPPL_INTRA
RELEASE Z_QTA_INTRA
RELEASE Z_UNITA_SUPPL_INTRA
RELEASE Z_PARTITA_IVA_INTRA
RELEASE Z_STATO_INTRA_PROV
RELEASE Z_IMPEUR_INTRA			
RELEASE Z_IMPVAL_INTRA			
RELEASE Z_IMPSTAT_INTRA
RELEASE Z_PESO
RELEASE Z_CLDOG  		
RELEASE Z_SERV_INTRA  
RELEASE Z_PORTO		
RELEASE Z_MEZZO  	
RELEASE INTRASTAT_PORTO
RELEASE INTRASTAT_MEZZO
RELEASE INTRASTAT_SERV_INTRA_RIGA_FATTURA
RELEASE INTRASTAT_CLDOG_RIGA_FATTURA

PUBLIC Z_PROVIN_DESTI_INTRA
PUBLIC Z_NAZIONE_INTRA
PUBLIC Z_COND_CONS_INTRA  
PUBLIC __QTA_KG
PUBLIC __QTA_UM  && ERASMO - 08/05/2015 - QTA IN UM
PUBLIC __UNITA_SUPPL_INTRA
PUBLIC Z_QTA_INTRA
PUBLIC Z_UNITA_SUPPL_INTRA
PUBLIC Z_PARTITA_IVA_INTRA
PUBLIC Z_STATO_INTRA_PROV
PUBLIC Z_IMPEUR_INTRA			
PUBLIC Z_IMPVAL_INTRA			
PUBLIC Z_IMPSTAT_INTRA
PUBLIC Z_PESO
PUBLIC Z_CLDOG  		
PUBLIC Z_SERV_INTRA  
PUBLIC Z_PORTO		
PUBLIC Z_MEZZO  	
PUBLIC INTRASTAT_PORTO
PUBLIC INTRASTAT_MEZZO
PUBLIC INTRASTAT_SERV_INTRA_RIGA_FATTURA
PUBLIC INTRASTAT_CLDOG_RIGA_FATTURA


Z_PROVIN_DESTI_INTRA = ''
Z_NAZIONE_INTRA = ''
Z_COND_CONS_INTRA  = ''
__QTA_KG = 0
__QTA_UM = 0  && ERASMO - 08/05/2015 - QTA IN UM
__UNITA_SUPPL_INTRA = 0
Z_QTA_INTRA = 0
Z_UNITA_SUPPL_INTRA = 0
Z_PARTITA_IVA_INTRA = ''
Z_STATO_INTRA_PROV = ''
Z_IMPEUR_INTRA = 0			
Z_IMPVAL_INTRA = 0			
Z_IMPSTAT_INTRA = 0
Z_PESO = 0
Z_CLDOG = ''  		
Z_SERV_INTRA = ''  
Z_PORTO = ''		
Z_MEZZO = '' 
INTRASTAT_PORTO = ''
INTRASTAT_MEZZO = ''
INTRASTAT_SERV_INTRA_RIGA_FATTURA = ''
INTRASTAT_CLDOG_RIGA_FATTURA = ''
**------------------------- VARIABILI INTRASTAT --------------------------**



RELEASE ___CCOSTO_RIGA_FATTURA
PUBLIC ___CCOSTO_RIGA_FATTURA
___CCOSTO_RIGA_FATTURA = ""

RELEASE FATSOSIVA__
PUBLIC FATSOSIVA__
FATSOSIVA__ = ''

RELEASE XCONCON,XCONDET
PUBLIC XCONCON,XCONDET
XCONCON = ''
XCONDET = ''

RELEASE _DES_ART
PUBLIC _DES_ART
_DES_ART = ''

RELEASE V_RA
PUBLIC V_RA
V_RA = 0						&& RITENUTA ACCONTO SU INCASSO FATTURE STUDI PROFESSIONALI


RELEASE CONTO_INCASSO_FAT_PRO	&& CONTO RITENUTE ACCONTO SU INCASSO FATTURE DI VENDITA
PUBLIC CONTO_INCASSO_FAT_PRO
CONTO_INCASSO_FAT_PRO = ""

RELEASE _JJ_ALRID 
PUBLIC _JJ_ALRID 
_JJ_ALRID = ''

RELEASE   _JJ_ESENZI
PUBLIC    _JJ_ESENZI
_JJ_ESENZI = .F.				&& CLIENTE NON IN ESENZIONE


RELEASE __CONTO_CONTABILE 
PUBLIC __CONTO_CONTABILE 
__CONTO_CONTABILE = ""

RELEASE V_DTSCA
PUBLIC V_DTSCA
V_DTSCA = SPACE(10)

RELEASE _BANCA_PER_INCASSO_FATTURA 
PUBLIC _BANCA_PER_INCASSO_FATTURA 
_BANCA_PER_INCASSO_FATTURA  = ""


RELEASE _SC_TIPRENDO  
PUBLIC _SC_TIPRENDO  
_SC_TIPRENDO  = ""

RELEASE __CODCLI__ 
public __CODCLI__ 
__CODCLI__    = ""
   

RELEASE Z_CONTO,Z_NATURA ,Z_CODGRU,Z_CODCCO,Z_VALORE,Z_PERCEN,Z_NDOC,Z_TOP,Z_IVA,Z_CAMBIO,Z_VALUTA,Z_PUBBLI,X_CONTOP 
PUBLIC Z_CONTO,Z_NATURA ,Z_CODGRU,Z_CODCCO,Z_VALORE,Z_PERCEN,Z_NDOC,Z_TOP,Z_IVA,Z_CAMBIO,Z_VALUTA,Z_PUBBLI,X_CONTOP 
RELEASE ___CCOSTO,V_CST   
PUBLIC ___CCOSTO,V_CST   
___CCOSTO  	= ""
X_CONTOP   	= 0
V_CST 		= ""

RELEASE BOLLATOIVA,_SEQUEN,ESISTE_OMAGGIO,ESISTE_PUBBLICITARIO,V_CONPAG  
RELEASE PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,XDESFF,V_CODCLI,_DIFVAL,_OKDIFC,_SEQUEN,ESISTE_OMAGGIO,ESISTE_PUBBLICITARIO  
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,XDESFF,V_CODCLI,_DIFVAL,_OKDIFC,_SEQUEN,ESISTE_OMAGGIO,ESISTE_PUBBLICITARIO  
XDESF    = "REGISTRAZIONE AUTOMATICA"
XDESFF   = ""
COMPENSO = 0
TIVA     = 0
CIVA     = 0
_DIFVAL  = 0
ESISTE_OMAGGIO = .F.
ESISTE_PUBBLICITARIO = .F.

PUBLIC BOLLATOIVA
PUBLIC DATA_SCAD,TOP_CONT,TOP_CONTABB
DATA_SCAD   = ""
TOP_TOP     = SPACE(03)
TOP_CONT    = ""
TOP_CONTABB = ""
_TLIN       = .F.
_TFPER      = .F.
_TFTOP      = .F.
BOLLATOIVA  = ' '

RELEASE ___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE
PUBLIC ___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE

___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE = .F.
 

RELEASE ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA
PUBLIC ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA

___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA = .F.



RELEASE _CODCOMMESSA
PUBLIC  _CODCOMMESSA
_CODCOMMESSA = ""


x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP
IF !EOF()
   _TLIN  = AZI_TLIN
   _TFPER = AZI_TFPER
   _TFTOP = AZI_TFTOP
ELSE
   WAIT WINDOW "Per cortesia codifica i parametri aziendali"
   RETURN
ENDIF

=CERCA_PARAMETRI_AZIENDALI()


IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
ELSE
	WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT
ENDIF


CREATE CURSOR W_FAT (W_CONTO C(13),W_CCOSTO C(13),W_CLDOG C(16),W_SERV_INTRA C(10),W_PORTO C(3),W_MEZZO C(3),W_DA C(1),W_IVA C(3),W_ARPU C(1), 	;
        W_IMPONI N(17,3) ,W_IMPOSTA N(17,3),W_SPINCA N(17,3),W_SPTRAS N(17,3),W_PUBBLI N(17,3),W_OMAGGIO N(17,3)  ,W_NUMDOC C(10),				;
        W_DTDOC C(10),W_QTA_INTRA N(17,3),W_UNITA_SUPPL_INTRA N(17,3), W_PESO_INTRA N(17,3))
SELECT W_FAT
INDEX ON ALLTRIM(W_CONTO)+ ALLTRIM(W_CCOSTO)+ ALLTRIM(W_CLDOG)+ ALLTRIM(W_SERV_INTRA)+ ALLTRIM(W_PORTO) + ALLTRIM(W_MEZZO)+ W_DA + W_IVA + W_ARPU TAG INTRA
INDEX ON ALLTRIM(W_CONTO)+ ALLTRIM(W_CCOSTO) + W_DA + W_IVA + W_ARPU TAG DETTA
INDEX ON ALLTRIM(W_ARPU)+ALLTRIM(W_CONTO)+ ALLTRIM(W_CCOSTO) + W_DA + W_IVA + W_ARPU TAG DET_PU		&& STESSO INDICE USATO FINO AD OGGI CON L'AGGIUNTA IN TESTA DELL'ARTICOLO PUBBLICITARIO
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
CC = SUBSTR(LIBERA,1,4)


IF PUB_CCOSTD							&& CENTRO DI COSTO STANDARD 
	v_seek	 = 'CST100'		
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	ELSE
	   WAIT WINDOW "Errore manca parametro CST CENTRO DI COSTO STANDARD"
	   RETURN
	ENDIF
	V_CST = SUBSTR(LIBERA,1,13)
	___CCOSTO = ""
	IF !EOF()
		IF !EMPTY(ALLTRIM(V_CST))
		   ___CCOSTO  = ALLTRIM(V_CST)
		ENDIF
	ENDIF
ENDIF


RELEASE V_CPL
PUBLIC V_CPL

v_seek	 = 'CPL'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CPL conto polieco"
   RETURN
ENDIF
V_CPL = SUBSTR(LIBERA,1,13)  && CONTO CONTABILE POLIECO PER NOTE ACCREDITO
 


v_seek	 = 'CMV'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CMV conto vendita merce"
   RETURN
ENDIF
V_CMV = SUBSTR(LIBERA,1,13)

V_CEN = ""
IF PUB_TFATT 							&& GESTIONE CONTRIBUTO ENPACL PER STUDI PROFESSIONALI
	v_seek	 = 'CEN'+PUB_CODSOC
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	ELSE
	   WAIT WINDOW "Errore manca parametro CEN conto contributo enpacl studi professionali"
	   RETURN
	ENDIF
	V_CEN = SUBSTR(LIBERA,1,13)
ENDIF

CONTO_INCASSO_FAT_PRO = ""
IF PUB_TFATT 							&& GESTIONE RITENUTA ACCONTO SU INCASSI FATTURE STUDI PROFESSIONALI
	v_seek	 = 'RAV'+PUB_CODSOC
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	ELSE
	   WAIT WINDOW "Errore manca parametro RAV conto ritenuta acconto incasso fatture studi professionali"
	   RETURN
	ENDIF
	CONTO_INCASSO_FAT_PRO = SUBSTR(LIBERA,1,13)
ENDIF

v_seek	 = 'AOM'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro AOM conto omaggi (iva a carico AZIENDA)"
   RETURN
ENDIF
V_AOM = SUBSTR(LIBERA,1,13)

v_seek	 = 'CIO'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CIO conto  costo iva omaggi (iva a carico AZIENDA)"
   RETURN
ENDIF
V_CIO = SUBSTR(LIBERA,1,13)


v_seek	 = 'AOC'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro AOC conto omaggi (iva a carico CLIENTE)"
   RETURN
ENDIF
V_AOC = SUBSTR(LIBERA,1,13)


v_seek	 = 'SIN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro SIN conto spese incasso"
   RETURN
ENDIF
CONTOSP = SUBSTR(LIBERA,1,13) && CONTO SPESE INCASSO SE NON ESISTE IN FATTURA UN'IVA AL XX%

v_seek	 = 'SPT'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro SPT conto spese trasporto"
   RETURN
ENDIF
CONTOST = SUBSTR(LIBERA,1,13) && CONTO SPESE TRASPORTO SE NON ESISTE IN FATTURA UN'IVA AL XX%



v_seek	 = 'IVA'+PUB_IVA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CON_IVA=ALLTRIM(SUBSTR(LIBERA,5,13))             && CONTO IVA CLIENTI
ELSE
   WAIT WINDOW "Errore manca conto iva generale = " + pub_iva
   RETURN
ENDIF

CT       = 0
CT_INCAS = 0
CT_FAT   = 0

CTRELAB  = 0
PERDAL   = RIBALTA2(DATADAL)
PERAL    = RIBALTA2(DATAAL)
CT       = 0
CTRELAB  = 0
FL_OK    = .T.
FL_OKCAM = .T.

RELEASE FLG_ABB
PUBLIC  FLG_ABB
FLG_ABB = .F.


* CONTROLLA SE LE FATTURE SONO STATE TUTTE PROTOCOLLATE E SE IL CAMBIO E' ATTRIBUITO
* CONTROLLA SE ESISTE ALMENO UNA FATTURA IN CONTABILIA' GENERALE : SIGNIFICA CHE SI STA' TRASFERENDO UNA FATTURA LA SECONDA VOLTA SENZA ANNULLARLA DALLA CONTABILITA' GENERALE
* CONTROLLA IL TOTALE DELLA FATTURA MEMORIZZATO SULLA TESTATA DELLA FATTURE : SE NON E' CORRETTO NON PROSEGUE IL TRASFERIMENTO


PROSEGUE_IL_TRASFERIMENTO = .T.

RELEASE _VALORE_ENPACL
PUBLIC _VALORE_ENPACL
_VALORE_ENPACL = 0
 
RELEASE ESISTE_UNA_FATTURA_CON_TOTALE_ERRATO,___VALORE_ORIGINALE_TESTATA_FATTURA 
PUBLIC  ESISTE_UNA_FATTURA_CON_TOTALE_ERRATO,___VALORE_ORIGINALE_TESTATA_FATTURA 
ESISTE_UNA_FATTURA_CON_TOTALE_ERRATO = .F.
___VALORE_ORIGINALE_TESTATA_FATTURA  = 0


CREATE CURSOR VAL_FATTURE( ;
  CODCLI_ C(10), RAGSOC_ C(35), NUMFAT_ C(06,0), DATFAT_ C(10,0), VAL_OLD N(17,2), VAL_NEW N(17,2))



RELEASE ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE,_NUMERO_FATTURA_ESISTENTE,_DATA_FATTURA_ESISTENTE,_NUMERO_REGISTRAZIONE_ESISTENTE
PUBLIC ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE,_NUMERO_FATTURA_ESISTENTE,_DATA_FATTURA_ESISTENTE,_NUMERO_REGISTRAZIONE_ESISTENTE
ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE 	= .F.
_NUMERO_FATTURA_ESISTENTE 					= ""
_DATA_FATTURA_ESISTENTE   					= ""
_NUMERO_REGISTRAZIONE_ESISTENTE				= ""


IF __TFC_CONTABILIZZA_SINGOLA_FATTURA

	x_soci  = "ORD_CODSOC = '" + PUB_CODSOC + "'"
	x_codc 	= "ord_codcli = '" + ALLTRIM(__TFC_CODCLI) + "'"
	x_numf 	= "ord_numord = '" + ALLTRIM(__TFC_NUMORD) + "'"
	x_datf 	= "ord_datord = '" + __TFC_DATORD + "'"	
	X_CGE	= " AND ORD_CGE=0 "
	x_cond  = x_soci + " and " + x_codc + " and " + x_numf + " and " + x_datf + X_CGE

ELSE

	x_soci   = "ORD_CODSOC = '" + PUB_CODSOC + "' AND ORD_CGE=0 "
	x_datada = "ord_datord >= '" + PERDAL + "'"
	x_dataa  = "ord_datord <= '" + PERAL + "'"
	X_CGE	= " AND ORD_CGE=0 "
	x_cond   = x_soci + " and " + x_datada + " and " + x_dataa + X_CGE

ENDIF

*** FABIANO 27/02/2015 - SELEZIONE DELLE FATTURE DA CONTABILIZZARE
***Csql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_datord"
CSQL = "SELECT '   ' AS SELEZIONE,* FROM U_FAT_TT WHERE " + X_COND + " ORDER BY ORD_CODSOC,ORD_DATORD,ORD_NUMORD"
IF !ExecCommand(Csql,"CONTR_FATT")
   return(.f.)
ENDIF

*** INIZIO FABIANO 27/02/2015 - SELEZIONE DELLE FATTURE DA CONTABILIZZARE
IF __TFC_CONTABILIZZA_SINGOLA_FATTURA

	*** FABIANO 27/02/2015 - SE CONTABILIZZO DIRETTAMENTE LA FATTURA LA IMPOSTO COME SELEZIONATA
	SELECT CONTR_FATT
	GO TOP
	REPLACE SELEZIONE WITH "==>" 
	
ELSE
	DO prg\browseview WITH "CONTR_FATT","Seleziona le fatture da contabilizzare","W:4;ORD_CODCLI:codice cliente,W:10;ORD_RAGSOC:ragione sociale,W:35;ORD_CAUS:causale,W:5;ORD_DATORD:data documento,W:10;ORD_NUMORD:num.documento,W:6;ORD_VALORE:importo.,W:13;"
	SELECT CONTR_FATT
	GO TOP

	IF NumeroRecordLetti = 0
		MESSAGGIO_STILE_WIN8("Trasferimento contabile :" + CHR(13) + CHR(13) +"Nessuna fattura selezionata da contabilizzare"+ CHR(13) + CHR(13) + "Fare click su OK per continuare")
		__NESSUN_TRASFERIMENTO_CONTABILE_EFFETTUATO = .T.
	    RETURN 
	ELSE
		* PER RISPOSTA SI/NO GESTIRE IL 292 
		
	   LOCAL _MESSAGGIO_DATA_REGISTRAZIONE
	   
	   IF EMPTY(DATAREG)  OR DATAREG = '  /  /    ' OR DATAREG = '    /  /  '
		  _MESSAGGIO_DATA_REGISTRAZIONE="NOTA: la data di registrazione sarà uguale alla data del documento."
	   ELSE
		  _MESSAGGIO_DATA_REGISTRAZIONE="NOTA: la data di registrazione sarà "+DATAREG+" per tutte le fatture selezionate"
	   ENDIF
		
	   IF 7= MESSAGEBOX("Trasferimento contabile :" + CHR(13) + CHR(13) +"Confermi la contabilizzazione delle Nr."+ALLTRIM(STR(NumeroRecordLetti,4,0))+" fatture selezionate?"+CHR(13)+CHR(13)+_MESSAGGIO_DATA_REGISTRAZIONE,292,'Contabilizzazione fatture clienti') 
			__NESSUN_TRASFERIMENTO_CONTABILE_EFFETTUATO = .T.
		    RETURN 
	   ENDIF
	ENDIF

ENDIF
*** FINE FABIANO 27/02/2015 - SELEZIONE DELLE FATTURE DA CONTABILIZZARE


LOCAL _FATTURE_SELEZIONATE_DA_CONTABILIZZARE 
_FATTURE_SELEZIONATE_DA_CONTABILIZZARE = ""

SELECT CONTR_FATT
GO TOP

DO WHILE !EOF()

   IF DELETED()
      SELECT CONTR_FATT
      SKIP +1
      LOOP
   ENDIF
   
   *** INIZIO FABIANO 27/02/2015 - SELEZIONE DELLE FATTURE DA CONTABILIZZARE
   IF EMPTY(SELEZIONE)
      SELECT CONTR_FATT
      SKIP +1
      LOOP
   ENDIF
   *** FINE FABIANO 27/02/2015 - SELEZIONE DELLE FATTURE DA CONTABILIZZARE

   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF ORD_DATORD > PERAL
	      EXIT
	   ENDIF
   ENDIF

   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF AGEDAL  <> "999"
		  IF VAL(ORD_AGE) <> VAL(AGEDAL)
	 	     SELECT CONTR_FATT
	 	     SKIP +1
		     LOOP
		  ENDIF
	   ENDIF
   ENDIF

   CTRELAB = CTRELAB+1
   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE   
   	  WAIT WINDOW "Fatture Elaborate "+STR(CTRELAB,6,0) NOWAIT
   ENDIF

   IF EMPTY(ORD_NPROT)                            	&& VERIFICA N.PROTOCOLLO
  	  FL_OK = .F.
   ENDIF

	** SERGIO 2015/06/18 : RIFATTO IL CONTROLLO IN QUANTO NON GESTISCE TUTTE LE CASISTICHE

	*!*	   IF ORD_VALUTA = PUB_VALRIF
	*!*	   ELSE
	*!*	      IF ORD_CAMBIO = 0
	*!*	 		 FL_OKCAM = .F.
	*!*		  ENDIF
	*!*	   ENDIF

    ** SERGIO 2015/06/18 VERIFICA CHE ESISTA IL CAMBIO PRIMA DELLA CONTABILIZZAZIONE SE LA VALUTA E' DIVERSA DALLA VALUTA DI RIFERIMENTO
    IF ORD_VALUTA = PUB_VALRIF
    ELSE

	   IF ORD_CAMBIO = 0 OR ORD_CAMBIO = 1
	 		 FL_OKCAM = .F.
	   ENDIF
		  
	   *** PRELEVA IL CAMBIO DEL GIORNO
	   V_DATA = ORD_DATORD
	   x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
	   x_codi = "vva_codval = '" + ORD_VALUTA + "'"
	   x_data = "vva_data   = '" + V_DATA + "'"
	   x_cond = x_soci + " and " + x_codi + " and " + x_data
	   cSql = "select * from u_vva_ch where " + x_cond + " order by vva_codsoc,vva_codval,vva_data"
	   IF !ExecCommand(cSql,"CUR_CAMBIO")
	      RETURN .F.
	   ENDIF
	   SELECT CUR_CAMBIO
	   GO TOP
	   IF EOF()
	  		FL_OKCAM = .F.	&& CAMBIO NON TROVATO : NON E' POSSIBILE CONTABILIZZARE LA FATTURA
       ELSE 
       
            IF VVA_CHANGE = 0 OR VVA_CHANGE = 1
 	  			FL_OKCAM = .F.	&& CAMBIO TROVATO MA CON VALORE NON SIGNIFICATIVO (VEDI MONICA RUMI): NON E' POSSIBILE CONTABILIZZARE LA FATTURA
            ENDIF
            
	   ENDIF 

    ENDIF 
   
    SELECT CONTR_FATT
	** SERGIO 2015/06/18 : RIFATTO IL CONTROLLO IN QUANTO NON GESTISCE TUTTE LE CASISTICHE




   V_ER=SOTTOGEN(ORD_CODNAZ)
   IF !V_ER
	  CC = PUB_CC
   ENDIF


 
   SELECT CONTR_FATT
   _CONTO_	= CC+ORD_CODCLI
   _ANNO_   = SUBSTR(ORD_DATORD,1,4)
   _DATAF_  = ORD_DATORD
   _NUMEF_  = ORD_NUMORD
   _TIOPE_  = ORD_CAUS 
   
   x_soci   = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno   = "mov_anno = '" + _anno_ + "'"
   x_cont   = "mov_conto = '" + ALLTRIM(_CONTO_) + "'"
   x_dtf    = _DATAF_  
   x_ndf    = _NUMEF_  
   x_data   = "mov_dtdoc = '" + x_dtf + "'"
   x_ndoc   = "mov_nprot = '" + x_ndf + "'"  
   x_top    = "mov_top in ('" + _tiope_ + "','VEN','"+pub_fattu+"' ) "
   
   x_cond   = x_soci + " and " + x_anno + " and " + x_cont + " and " + x_data + " and " + x_ndoc + " and " + x_top
   cSql   = "SELECT * FROM INDICE WHERE " + x_cond + " order by mov_soc,mov_anno,mov_conto,mov_dtreg,mov_nregis"
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
   ENDIF


   SELECT CONTR_FATT
   ESISTE_UNA_FATTURA_CON_TOTALE_ERRATO = .F.
   AGGA 								= TAGGANCIO
   ___VALORE_ORIGINALE_TESTATA_FATTURA 	= ORD_VALORE 
   _NUMFAT								= ORD_NUMORD
   _DATFAT								= ORD_DATORD
   _CODCLI								= ORD_CODCLI
   _RAGSOC								= ORD_RAGSOC

   
   SCATTER MEMVAR MEMO 
   
   =CALCDOCGE1(AGGA,"fathookd","U_FAT_DD","U_FAT_TT",.F.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO SENZA AGGIORNARE IL DBASE

   IF ___VALORE_ORIGINALE_TESTATA_FATTURA <> M.ORD_VALORE 
   
      ESISTE_UNA_FATTURA_CON_TOTALE_ERRATO = .T.
      
      SELECT VAL_FATTURE
      APPEND BLANK 

      REPLACE VAL_OLD  WITH ___VALORE_ORIGINALE_TESTATA_FATTURA 
      REPLACE VAL_NEW  WITH M.ORD_VALORE	 						&& VALORE RICALCOLATO DELLA FATTURA
      REPLACE NUMFAT_  WITH _NUMFAT
      REPLACE DATFAT_  WITH _DATFAT
      REPLACE CODCLI_  WITH _CODCLI
      REPLACE RAGSOC_  WITH _RAGSOC
  
   ENDIF

   IF !EMPTY(_FATTURE_SELEZIONATE_DA_CONTABILIZZARE)
   		_FATTURE_SELEZIONATE_DA_CONTABILIZZARE =_FATTURE_SELEZIONATE_DA_CONTABILIZZARE +","
   ENDIF
   _FATTURE_SELEZIONATE_DA_CONTABILIZZARE = _FATTURE_SELEZIONATE_DA_CONTABILIZZARE  + "'"+ALLTRIM(_NUMFAT)+ "'"

   SELECT CONTR_FATT

   SKIP +1
   LOOP

ENDDO

IF !FL_OK

   PROSEGUE_IL_TRASFERIMENTO = .F.
   
   DO PLAYWAV WITH "BLIP.WAV" 
 		   XDESCRI="Attenzione"
   SET CLASSLIB TO "proj_lib.vcx" additive
   oForm=CreateObject("MsgErr") 
   oform.edit1.Value=""+XDESCRI+CHR(13)+;
			  "Funzione non permessa, devi protocollare le fatture"
   oform.Show
   RELEASE oForm 
   RETURN	     
   
ENDIF

IF !FL_OKCAM

   PROSEGUE_IL_TRASFERIMENTO = .F.
   
   DO PLAYWAV WITH "BLIP.WAV" 
 		   XDESCRI="Attenzione"
   SET CLASSLIB TO "proj_lib.vcx" additive
   oForm=CreateObject("MsgErr") 
   oform.edit1.Value=""+XDESCRI+CHR(13)+;
			  "Funzione non permessa devi : PRELEVARE i cambi e attribuirli automaticamente con apposita funzione della procedura CAMBI"
   oform.Show
   RELEASE oForm 
   RETURN	     

ENDIF

IF ESISTE_LA_FATTURA_IN_CONTABILITA_GENERALE

   PROSEGUE_IL_TRASFERIMENTO = .F.
   
   DO PLAYWAV WITH "BLIP.WAV" 
 		   XDESCRI="Attenzione"
   SET CLASSLIB TO "proj_lib.vcx" additive
   oForm=CreateObject("MsgErr") 
   oform.edit1.Value=""+XDESCRI+CHR(13)+;
			  "Esiste almeno una fattura già trasferita reg.: "+_NUMERO_REGISTRAZIONE_ESISTENTE+" - n.f. "+_NUMERO_FATTURA_ESISTENTE+" - dt."+ribalta2(_DATA_FATTURA_ESISTENTE)+" devi annullare le fatture obsolete "+CHR(13)+"in contabilità , per proseguire"
   oform.Show
   RELEASE oForm 
   RETURN	  

ENDIF


IF ESISTE_UNA_FATTURA_CON_TOTALE_ERRATO 

   PROSEGUE_IL_TRASFERIMENTO = .F.
   
   DO PLAYWAV WITH "BLIP.WAV" 
 		   XDESCRI="Attenzione"
   SET CLASSLIB TO "proj_lib.vcx" additive
   oForm=CreateObject("MsgErr") 
   oform.edit1.Value=""+XDESCRI+CHR(13)+CHR(13)+;
			  "Controllare , ristampare le fatture nell'elenco"+CHR(13)+" e ripetere il trasferimento"
   oform.Show
   RELEASE oForm 

   DO prg\browseview WITH "VAL_FATTURE","Elenco fatture da ristampare","CODCLI_:codice cliente,W:10;RAGSOC_:ragione sociale,W:35;DATFAT_:data documento,W:10;NUMFAT_:num.documento,W:6;",500,583,.F.
   
   RETURN	  

ENDIF

CT       = 0
CT_FAT   = 0
CTRELAB  = 0
CT_INCAS = 0

 
IF __TFC_CONTABILIZZA_SINGOLA_FATTURA

	x_soci   = "ORD_CODSOC = '" + PUB_CODSOC + "' AND ORD_CGE=0"
	x_codc   = "ord_codcli = '" + ALLTRIM(__TFC_CODCLI) + "'"
	x_numf   = "ord_numord = '" + ALLTRIM(__TFC_NUMORD) + "'"
	x_datf   = "ord_datord = '" + __TFC_DATORD + "'"	
	X_CGE	 = " AND ORD_CGE=0 "
	x_cond   = x_soci + " and " + x_codc + " and " + x_numf + " and " + x_datf + X_CGE

ELSE

	x_soci   = "ORD_CODSOC = '" + PUB_CODSOC + "' AND ORD_CGE=0"
	x_datada = "ord_datord >= '" + PERDAL + "'"
	x_dataa  = "ord_datord <= '" + PERAL + "'"
	X_CGE	 = " AND ORD_CGE=0 "
	X_SELEZIONATE = " AND ORD_NUMORD IN ("+_FATTURE_SELEZIONATE_DA_CONTABILIZZARE+") "
	x_cond   = x_soci + " and " + x_datada + " and " + x_dataa + X_CGE + X_SELEZIONATE 

ENDIF 


Csql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
IF !ExecRW(Csql,"U_FAT_TT","R")
   return(.f.)
ENDIF

** CONTROLLI ULERIORI FINALI SULLA FATTURA
IF !CONTROLLI_FINALI(__TFC_CONTABILIZZA_SINGOLA_FATTURA,__TFC_CODCLI,__TFC_NUMORD,__TFC_DATORD)
    __NESSUN_TRASFERIMENTO_CONTABILE_EFFETTUATO = .T.
	RETURN .F.
ENDIF



SELECT U_FAT_TT
GO TOP

DO WHILE !EOF()

   IF DELETED()
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF
   
   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF ORD_DATORD > PERAL
	      EXIT
	   ENDIF
   ENDIF

   IF ORD_CGE
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF

   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF AGEDAL  <> "999"
		  IF VAL(ORD_AGE) <> VAL(AGEDAL)
		     SELECT U_FAT_TT
	 	     SKIP +1
		     LOOP
		  ENDIF
	   ENDIF
   ENDIF

   CTRELAB = CTRELAB+1
   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
   		WAIT WINDOW "Fatture Elaborate"+STR(CTRELAB,6,0) NOWAIT
   ENDIF
   
   ****DATI DI TESTATA DELLA SINGOLA FATTURA ****

   V_CODCLI 				= ORD_CODCLI
   M.ORD_CODCLI				= ORD_CODCLI		&& SERGIO 2014/02/22 : BACONE !!! SE NON VALORIZZO LA VARIABILE CALCDOGEN1 ESEGUE IL CALCOLO DEL TOTALE DOCUMENTO 
   												&& SERGIO 2014/02/22 : BACONE !!! PRENDENDO COME CLIENTE L'ULTIMO CLIENTE ELABORATO IN FASE DI CONTROLLO
   V_CONPAG 				= ORD_CPA
   V_DTSCA  				= ORD_DTSCAD
   XDESF    				= ORD_RAGSOC
   XVALUTA  				= ORD_VALUTA
   XCAMBIO  				= ORD_CAMBIO
   XCONCON 					= ORD_CONCON
   
   *!*	 ______________________________ INTRASTAT ________________________________
   INTRASTAT_PORTO 			= ALLTRIM(ORD_PORTO)
   INTRASTAT_MEZZO			= ALLTRIM(ORD_ACURA)
   Z_NAZIONE_INTRA 			= ORD_CODNAZ 
   *Z_PESO					= ORD_PESO
   Z_PESO					= ORD_PESNET
   Z_STATO_INTRA_PROV 		= ""
   Z_COND_CONS_INTRA 		= "E"		&& EXW FRANCO FABBRICA
   Z_PROVIN_DESTI_INTRA 	= M.AZI_INTRA_PRODE		&& DA PARAMETRI DI SISTEMA
   
   IF !EMPTY(ORD_CODNAZ)
	  V_SEEK   = 'STA'+ORD_CODNAZ
	  V_CHIAVE = 'CODICE'
	  IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		  SELECT CUR_PARA
		  Z_STATO_INTRA_PROV 	= SUBSTR(LIBERA,1,2)
      ENDIF
   ELSE 
      Z_STATO_INTRA_PROV 		= ""
   ENDIF
   
   SELECT U_FAT_TT			
   IF !EMPTY(ORD_PORTO)
		v_seek	 = 'POR'+ORD_PORTO
		v_chiave ="codice"
		IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	    	SELECT CUR_PARA
			Z_COND_CONS_INTRA  = SUBSTR(LIBERA,1,1)    
		ELSE
	    	Z_COND_CONS_INTRA  = ""
		ENDIF
   ENDIF
   *!*	 ______________________________ INTRASTAT ________________________________

   SELECT U_FAT_TT

   __DATAF    = ORD_DATORD											
   PUB_IVADEF = CERCA_IVA_DEFAULT("CU_FAT_DD","CODICE",__DATAF)  	
   PUB_ALIQ   = CERCA_IVA_DEFAULT("CU_FAT_DD","ALIQUOTA",__DATAF)  
   
   SELECT U_FAT_TT
   IF ORD_VALUTA = PUB_VALRIF		&& PER LA STESSA VALUTA DI RIFERIMENTO (EUR) IL CAMBIO E' 1
        XCAMBIO = 1					&& FORZA IL CAMBIO = 1
   ENDIF
 
   _JJ_ESENZI = .F.					&& CLIENTE NON IN ESENZIONE
   _JJ_ALRID  = ''
   
   SELECT U_FAT_TT
   RELEASE _NAZ
   PUBLIC _NAZ
   _NAZ     = ORD_CODNAZ
   XDESFF   ="CLI:"+ALLTRIM(ORD_CODCLI)+" N.F:"+ORD_NUMORD+" DEL "+ORD_DATORD
   XDESFF   = DESCRIZIONE_AUTOMATICA(XDESFF,ALLTRIM(ORD_CODCLI),ORD_NUMORD,ORD_DATORD)  && ERASMO - 07/08/2015

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_ana_cl")
      return(.f.)
   ENDIF
   SELECT u_ana_cl
   GO top
   IF !EOF()
    	V_IVASPTRAS      = CLI_IVASPTRAS
   ELSE
   		V_IVASPTRAS      = ""
   ENDIF 


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
      
      _JJ_ALRID    					= CLI_ALRID
      _BANCA_PER_INCASSO_FATTURA 	= CLI_INCASS		&& CONTO CASSA DA CLIENTE
      
      
      Z_PARTITA_IVA_INTRA				= ALLTRIM(CLI_PARIVA)
      IF EMPTY(Z_PARTITA_IVA_INTRA)
      	 Z_PARTITA_IVA_INTRA			= ALLTRIM(CLI_IVACEE)
      ENDIF
      
      IF !EMPTY(CLI_ALRID)
         _JJ_ESENZI = .T.					&& CLIENTE IN ESENZIONE
      ELSE
         _JJ_ALRID  = PUB_IVADEF			
         _JJ_ESENZI = .F.					&& CLIENTE NON IN ESENZIONE
      ENDIF
   ELSE
      _JJ_ALRID  = PUB_IVADEF				
      _JJ_ESENZI=.F.						&& CLIENTE NON IN ESENZIONE
   ENDIF

   SELECT U_FAT_TT

   V_SEEK       			= TAGGANCIO
   SPESE         			= ORD_SPBOLL + ORD_SPTRAS
   SP_INCA       			= ORD_SPBOLL       				&& SPESE INCASSO
   SP_TRAS       			= ORD_SPTRAS       				&& SPESE TRASPORTO
   VALFAT        			= ORD_VALORE
   TOP_TOP       			= ORD_CAUS               		&& NOTE CREDITO
   TOP_CONT      			= "" 		               	 	&& CONTROPARTITA CONTABILE
   TOP_CONTABB   			= ""							&& CONTROPARTITA CONTABILE PER ABBUONO
   FLG_ABB       			= ORD_FLGABB					&& FLAG DI ABBUONO PER NOTA ACCREDITO
   _SC_TIPRENDO  			= TIPRENDO						&& CHIAVE ACCESSO ALLE SCADENZE SPECIALI
   
   
   M.T_VALORE 	 = 0
   M.T_IMPOSTA   = 0
   =CALCdocge1(V_SEEK,"fathookd","U_FAT_DD","U_FAT_TT",.F.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO SENZA AGGIORNARE IL DBASE : SONO COSTRETTO A FARE COSI L'ELABORAZIONE E' SICURAMENTE + LENTA  
  
   SELECT U_FAT_TT
   RELEASE __T_IMPON,__T_IMPOS   
   PUBLIC  __T_IMPON,__T_IMPOS   
   __T_IMPON				= M.T_VALORE - M.T_IMPOSTA		&& IMPONIBILE NUOVA GESTIONE TRANCHE
   _VALORE_ENPACL 			= M.T_ENPACL					&& CONTRIBUTO ENPACL PER STUDI PROFESSIONALI
   __T_IMPOS    			= M.T_IMPOSTA					&& IMPOSTA NUOVA GESTIONE TRANCHE
   V_RA     				= M.T_RA						&& RITENUTA ACCONTO INCASSO FATTURE STUDI PROFESSIONALI
   
   
   _CODCOMMESSA  = ORD_NUMCOC					
     
   ___FATTURA_INCASSATA = ORD_INCASS						&& SE ATTIVO IL FLAG LA FATTURA E' STATA PAGATA IMMEDIATAMENTE
   ___NUMORD			= ORD_NUMORD

   IF EMPTY(_BANCA_PER_INCASSO_FATTURA)						&& CONTO BANCA/CASSA PER INCASSO FATTURA
	   v_seek	= 'TOP' + PUB_INCCLI			
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      _BANCA_PER_INCASSO_FATTURA   = CONTO1				&& CONTO CASSA DA PARAMETRI
	   ELSE
	      WAIT WINDOW "Errore manca parametro TOP :"+PUB_INCCLI
	   ENDIF
   ENDIF

   SELECT U_FAT_TT  



	IF PUB_TFATT 					&& GESTISCO IL FLAG DELLO STUDIO PROFESSIONALE 
  
   		IF !EMPTY(ORD_CONINC)
   			_BANCA_PER_INCASSO_FATTURA = ALLTRIM(ORD_CONINC)			&& CONTO CASSA DA FATTURA
   		ELSE
	 	   v_seek	= 'TOP' + PUB_INCCLI			
		   v_chiave = "codice"
		   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		      SELECT CUR_PARA
		      _BANCA_PER_INCASSO_FATTURA   = CONTO1						&& CONTO CASSA DA PARAMETRI
		   ELSE
		      WAIT WINDOW "Errore manca parametro TOP :"+PUB_INCCLI
		   ENDIF
		   SELECT U_FAT_TT  
   		ENDIF
  
	    IF EMPTY(_BANCA_PER_INCASSO_FATTURA)			&& CONTO BANCA/CASSA PER INCASSO FATTURA
	   		=MESSAGEBOX("FATTURA INCASSATA MA MANCA IL CONTO BANCA IN ANAGRAFICA CLIENTI , FATTURA N. :"+ ___NUMORD,64,"*** INFORMAZIONE ***")
	    ENDIF
    
   ENDIF

   v_seek	= 'TOP' + TOP_TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC	      = SUBSTR(LIBERA,11,1)
      TOP_CONT    = CONTO1
      TOP_CONTABB = CONTO2
      FATSOSIVA__ = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   ELSE
      WAIT WINDOW "Errore manca parametro TOP :"+TOP_TOP
      TOP_TOP  = PUB_FATTU  && "VEN"
      NOTAC    = ""
      FATSOSIVA__ =""
   ENDIF


   v_seek	= "CPA"+V_CONPAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
	  PUB_CONDSPE = SUBSTR(LIBERA,8,1)		&& CONDIZIONI DI PAGAMENTO SPECIALI  
   ELSE
 	  V_CONPAG  = PUB_CPA   				&& FORZATURA CPA CONTANTI
   ENDIF

   SELECT U_FAT_TT
  
*!*	 IF ALLTRIM(ORD_NUMORD) = "000418"
*!*	 SET STEP ON 
*!*	 ENDIF
  
   
   V_SEEK   = TAGGANCIO

   V_TOTALE = 0
 
   SELECT W_FAT
   ZAP

   ESISTE_OMAGGIO       = .F.
   ESISTE_PUBBLICITARIO = .F.



	RELEASE VALORE_POLIECO,VALORE_PUBBLI_RICALCOLATO,IMPOSTA_POLIECO
	PUBLIC VALORE_POLIECO,VALORE_PUBBLI_RICALCOLATO,IMPOSTA_POLIECO
	VALORE_POLIECO 				= 0
	VALORE_PUBBLI_RICALCOLATO	= 0
	IMPOSTA_POLIECO				= 0

	RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
	PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
	_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
	_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
	PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

   __QTA_KG = 0			&& QTA IN KG
   __QTA_UM = 0			&& ERASMO - 08/05/2015 - QTA IN UM
   __UNITA_SUPPL_INTRA = 0 && ALTRE QTA CON DIVERSE UNITA' DI MISURA
 
 
   IF PUB_INTRASTAT		&& ____________________________________________________GESTIONE INTRASTAT
	     =INTRA_DEFINIZIONE_VARIABILI()
   ENDIF 
    
   
   x_agga = "daggancio = '" + ALLTRIM(V_SEEK) + "'"
   x_cond = x_agga
   Csql   = "select * from u_fat_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(Csql,"U_FAT_DD")
      return(.f.)
   ENDIF
   SELECT U_FAT_DD
   GO TOP

   IF !EOF()
      DO WHILE !EOF()

         **=> ERASMO/FABIANO INIZIO - 29/06/2015 - PEZZO DI CODICE ASTERISCATO IN QUANTO ALTRIMENTI NON CONVERGONO NEI BOLLATI DEI PROTOCOLLI FATTURE INTERAMENTE CON IMPORTO ZERO, CREANDO DEI BUCHI DI PROTOCOLLI
*!*	         IF ORD_VALORE = 0
*!*		        SKIP +1
*!*		        LOOP
*!*		     ENDIF
         **=> ERASMO/FABIANO FINE - 29/06/2015 - PEZZO DI CODICE ASTERISCATO IN QUANTO ALTRIMENTI NON CONVERGONO NEI BOLLATI DEI PROTOCOLLI FATTURE INTERAMENTE CON IMPORTO ZERO, CREANDO DEI BUCHI DI PROTOCOLLI
	     
 		 IF "*** COMMENTO ***" $ ORD_DESART
	        SKIP +1
	        LOOP
		 ENDIF
		 
 		 IF SUBSTR(ORD_DESART,1,3) = "***"
	        SKIP +1
	        LOOP
		 ENDIF

		 *** FABIANO 02/03/2015 - GESTIONE ANTICIPI
		 IF PUB_ANTCLI_REGAUT AND ALLTRIM(ORD_CONDET)=PUB_ANTCLI_CONTO
		 	_VALORE_SU_ANTICIPO   = ORD_VALORE+ ORD_VALORE* IVAREAL(ORD_IVA)
		 ENDIF
		 *** FABIANO 02/03/2015 - GESTIONE ANTICIPI
		 
		 
         ___CCOSTO_RIGA_FATTURA = ORD_CCODET								&& CENTRO DI COSTO DIGITATO SULLA RIGA DELLA FATTURA O PROVENIENTE DA ORDINI,DDT

		 * CONTROLLA LA GESTIONE DELLO SCONTO SCALANDO IL VALORE SCONTATO ATTRIBUENDOLO
		 * AL CONTO CONTABILE PRECEDENTE ELABORATO
		 IF SUBSTR(ORD_CODART,1,3) <> ".SC"
	        CONTO = VEDIART(ORD_CODART,ORD_DESART,ORD_CONDET)				&& MANTIENE ULTIMO CONTO
	     ENDIF

	     VALORE   = ORD_VALORE

		 
*!*			 IF ALLTRIM(ORD_UM) = 'KG'
*!*				 	__QTA_KG = __QTA_KG + ORD_QTAORD
*!*			 ELSE
*!*				 	__UNITA_SUPPL_INTRA = __UNITA_SUPPL_INTRA + ORD_QTAORD
*!*			 ENDIF
		 **=> ERASMO - INIZIO 08/05/2015
		 *** VALORIZZAZIONE QUANTITA' PER INTRASTAT
		 __QTA_UM 				= ORD_QTAORD
		 *__UNITA_SUPPL_INTRA 	= ORD_QTAORD
		 __UNITA_SUPPL_INTRA 	= 0  && ERASMO - 09/06/2015
		 **=> ERASMO - INIZIO 12/08/2015 - SU SPECIFICA RICHIESTA DEL CLIENTE
		 IF PUB_PRDISP
			 __UNITA_SUPPL_INTRA 	= ORD_QTAORD
		 ENDIF
		 **=> ERASMO - FINE 12/08/2015 - SU SPECIFICA RICHIESTA DEL CLIENTE
		 __QTA_KG 				= 0
		 x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		 x_codi = "art_codpri = '" + ALLTRIM(ORD_CODART) + "'"
		 x_cond = x_soci + " and " + x_codi
		 cSql = "select ART_PESOUM from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
		 IF !ExecCommand(cSql,"TMP_ARTICOLO")
		    RETURN .F.
		 ENDIF
		 SELECT TMP_ARTICOLO
		 GO TOP
		 IF !EOF()
		    __QTA_KG = ART_PESOUM
		 ENDIF
		 __QTA_KG = __QTA_KG * __QTA_UM
		 SELECT U_FAT_DD
		 **=> ERASMO - FINE 08/05/2015

		 
		 IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   					&& CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
			 IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
		   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
		     ENDIF
		 ENDIF 

		 IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
		   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
		 ENDIF   

		 IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'							&& CALCOLA IMPONIBILE E IMPOSTA POLIECO PER ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA ORD_PUBBLI = 'O'
		   	   VALORE_POLIECO = ORD_VALORE									&& IMPONIBILE POLIECO

			   IMPOSTA_POLIECO= VALORE_POLIECO * IVAREAL(ORD_IVA)
			   
			   ___VALUTA = ORS_VALUTA
			   IF EMPTY(___VALUTA) 
			   		___VALUTA = PUB_VALRIF
			   ENDIF
			   
			   IF ___VALUTA = "ITL" .OR.  ___VALUTA = "LIT"
			      IMPOSTA_POLIECO	=	ROUND((IMPOSTA_POLIECO+.49),0)		&& IMPOSTA POLIECO
			   ELSE
			      IMPOSTA_POLIECO	=	ROUND((IMPOSTA_POLIECO+.0000),2)	&& IMPOSTA POLIECO
			   ENDIF

   			   IF NOTAC   = "S"    && SE NOTA DI ACCREDITO E POLICO FORZA CONTO CONTABILE NOTE CREDITO
   			      
   			      IF !EMPTY(ALLTRIM(V_CPL))
   			          CONTO = ALLTRIM(V_CPL)
   			      ENDIF
   			      
   			   ENDIF

		 ENDIF


         AR_PU    = ALLTRIM(ORD_PUBBLI)

         IF AR_PU =  'O'
	           ESISTE_OMAGGIO = .T.
         ENDIF

         IF AR_PU =  'S'
	           ESISTE_PUBBLICITARIO = .T.
		      _CNT_PUBBLI = _CNT_PUBBLI + 1		
         ENDIF


	     IVA      							= ORD_IVA
		 INTRASTAT_CLDOG_RIGA_FATTURA 		= ALLTRIM(ORD_CLDOG)
	     INTRASTAT_SERV_INTRA_RIGA_FATTURA 	= ALLTRIM(ORD_SERV_INTRA) 
	     
	     V_TOTALE = V_TOTALE + VALORE

	     SELECT W_FAT	

		 IF PUB_INTRASTAT		&& ____________________________________________________GESTIONE INTRASTAT
			SET ORDER TO INTRA
		    _SEEK=ALLTRIM(CONTO) + ALLTRIM(___CCOSTO) + INTRASTAT_CLDOG_RIGA_FATTURA + INTRASTAT_SERV_INTRA_RIGA_FATTURA + INTRASTAT_PORTO + INTRASTAT_MEZZO + 'A' +IVA + AR_PU
		 ELSE					&& ____________________________________________________GESTIONE NORMALE
		    _SEEK=ALLTRIM(CONTO) + ALLTRIM(___CCOSTO) + 'A' +IVA + AR_PU
		 ENDIF
		 	     
	     							
	     SEEK _SEEK
	     IF FOUND()
 	        REPLACE W_IMPONI WITH W_IMPONI + VALORE


	        IF AR_PU = 'S' 
		       REPLACE W_PUBBLI WITH W_PUBBLI + VALORE     && ARTICOLO PUBBLICITARIO IVA A CARICO CLIENTE
		    ENDIF

	        IF AR_PU = 'O'
		       REPLACE W_OMAGGIO WITH W_OMAGGIO + VALORE   && OMAGGIO CON IVA A CARICO AZIENDA
		    ENDIF


			IF PUB_INTRASTAT					&& GESTIONE INTRASTAT
				*REPLACE W_QTA_INTRA 			WITH W_QTA_INTRA  			+ 	__QTA_KG 
				REPLACE W_QTA_INTRA 			WITH W_QTA_INTRA  			+ 	__QTA_UM  && ERASMO - 08/05/2015
				REPLACE W_PESO_INTRA 			WITH W_PESO_INTRA  			+ 	__QTA_KG  && ERASMO - 08/05/2015
   				REPLACE W_UNITA_SUPPL_INTRA		WITH W_UNITA_SUPPL_INTRA 	+ 	__UNITA_SUPPL_INTRA 
			ENDIF

	     ELSE
	        APPEND BLANK
	        REPLACE W_IMPONI WITH VALORE

	        REPLACE W_CONTO  WITH CONTO
	        REPLACE W_IVA    WITH IVA
	        REPLACE W_DA     WITH 'A'
	        REPLACE W_ARPU   WITH AR_PU
	        REPLACE W_CCOSTO WITH ___CCOSTO
	        
	        IF AR_PU = 'S' 
		       REPLACE W_PUBBLI WITH  VALORE         && ARTICOLO PUBBLICITARIO CON IVA A CARICO CLIENTE
		    ENDIF
	        
	        IF AR_PU = 'O'
		       REPLACE W_OMAGGIO WITH  VALORE        && OMAGGIO CON IVA A CARICO AZIENDA
		    ENDIF

			IF PUB_INTRASTAT					&& GESTIONE INTRASTAT
			    REPLACE W_CLDOG 				WITH INTRASTAT_CLDOG_RIGA_FATTURA
			    REPLACE W_SERV_INTRA   			WITH INTRASTAT_SERV_INTRA_RIGA_FATTURA 
			    REPLACE W_PORTO 				WITH INTRASTAT_PORTO 
			    REPLACE W_MEZZO 				WITH INTRASTAT_MEZZO 
				*REPLACE W_QTA_INTRA 			WITH __QTA_KG 
				REPLACE W_QTA_INTRA 			WITH __QTA_UM  && ERASMO - 08/05/2015
				REPLACE W_PESO_INTRA 			WITH __QTA_KG  && ERASMO - 08/05/2015
   				REPLACE W_UNITA_SUPPL_INTRA		WITH __UNITA_SUPPL_INTRA 
  			ELSE
			    REPLACE W_CLDOG 				WITH ''
			    REPLACE W_SERV_INTRA   			WITH ''
			    REPLACE W_PORTO 				WITH ''
			    REPLACE W_MEZZO 				WITH ''
				REPLACE W_QTA_INTRA 			WITH 0
				REPLACE W_PESO_INTRA 			WITH 0  && ERASMO - 08/05/2015
   				REPLACE W_UNITA_SUPPL_INTRA		WITH 0
			ENDIF
			
	     ENDIF


	     SELECT U_FAT_DD
	     SKIP +1


	  ENDDO



      IF SP_INCA > 0  								&& SPESE INCASSO
         V_TOTALE=V_TOTALE+SP_INCA
	     SELECT W_FAT
	     APPEND BLANK
	     REPLACE W_CONTO  WITH CONTOSP
         REPLACE W_CCOSTO WITH ___CCOSTO	     
	     REPLACE W_IMPONI WITH SP_INCA
	     IF !_JJ_ESENZI                             && SOLO SE NON IN ESENZIONE
		    *REPLACE W_IVA    WITH PUB_IVADEF		
		    REPLACE W_IVA    WITH IIF(PUB_NOIVASPINC, PUB_IVASPINC, PUB_IVADEF)  && ERASMO/SERGIO - 2016/02/03
		 ELSE
		    REPLACE W_IVA    WITH _JJ_ALRID
		 ENDIF			   	
	     REPLACE W_DA     WITH 'A'
	     SP_INCA    = 0
		 IF PUB_INTRASTAT						&& GESTIONE INTRASTAT
		    REPLACE W_CLDOG 		WITH INTRASTAT_CLDOG_RIGA_FATTURA
		    REPLACE W_SERV_INTRA   	WITH INTRASTAT_SERV_INTRA_RIGA_FATTURA 
		    REPLACE W_PORTO 		WITH INTRASTAT_PORTO 
		    REPLACE W_MEZZO 		WITH INTRASTAT_MEZZO  
  		 ELSE
		    REPLACE W_CLDOG 		WITH ''
		    REPLACE W_SERV_INTRA   	WITH ''
		    REPLACE W_PORTO 		WITH ''
		    REPLACE W_MEZZO 		WITH ''
		 ENDIF
		 REPLACE W_QTA_INTRA 			WITH 0
		 REPLACE W_PESO_INTRA 			WITH 0  && ERASMO - 08/05/2015
   		 REPLACE W_UNITA_SUPPL_INTRA	WITH 0
	  ENDIF


      IF SP_TRAS > 0  									&& SPESE TRASPORTO
         V_TOTALE=V_TOTALE+SP_TRAS
	     SELECT W_FAT
	     APPEND BLANK
	     REPLACE W_CONTO  WITH CONTOST
         REPLACE W_CCOSTO WITH ___CCOSTO	     
	     REPLACE W_IMPONI WITH SP_TRAS

		 IF !EMPTY(V_IVASPTRAS)							&& PER I CLIENTI EXTRA CEE GESTISCE SE DIGITATO DA UTENTE IL CODICE IVA DI ANAGRAFICA CLIENTE
		     REPLACE W_IVA    WITH V_IVASPTRAS			&& PER I CLIENTI EXTRA CEE GESTISCE SE DIGITATO DA UTENTE IL CODICE IVA DI ANAGRAFICA CLIENTE
		 ELSE
		     IF !_JJ_ESENZI                             && SOLO SE NON IN ESENZIONE
			    REPLACE W_IVA    WITH PUB_IVADEF		
			 ELSE
			    REPLACE W_IVA    WITH _JJ_ALRID
			 ENDIF			   	
		 ENDIF
		 
	     REPLACE W_DA     WITH 'A'
	     SP_TRAS    = 0
		 IF PUB_INTRASTAT						&& GESTIONE INTRASTAT
		    REPLACE W_CLDOG 		WITH INTRASTAT_CLDOG_RIGA_FATTURA
		    REPLACE W_SERV_INTRA   	WITH INTRASTAT_SERV_INTRA_RIGA_FATTURA 
		    REPLACE W_PORTO 		WITH INTRASTAT_PORTO 
		    REPLACE W_MEZZO 		WITH INTRASTAT_MEZZO  
  		 ELSE
		    REPLACE W_CLDOG 		WITH ''
		    REPLACE W_SERV_INTRA   	WITH ''
		    REPLACE W_PORTO 		WITH ''
		    REPLACE W_MEZZO 		WITH ''
		 ENDIF
		 REPLACE W_QTA_INTRA 			WITH 0
		 REPLACE W_PESO_INTRA 			WITH 0  && ERASMO - 08/05/2015
   		 REPLACE W_UNITA_SUPPL_INTRA	WITH 0
	  ENDIF	

	  IF PUB_TFATT 									&& GESTIONE CONTRIBUTO ENPACL PER STUDI PROFESSIONALI

		IF _VALORE_ENPACL > 0						&& SOLO SE ESISTE UN VALORE SIGNIFICATIVO PER ENPACL
	         
	         V_TOTALE=V_TOTALE+_VALORE_ENPACL
		     SELECT W_FAT
		     APPEND BLANK
		     REPLACE W_CONTO  WITH V_CEN
	         REPLACE W_CCOSTO WITH ___CCOSTO	     
		     REPLACE W_IMPONI WITH _VALORE_ENPACL
		     IF !_JJ_ESENZI                             && SOLO SE NON IN ESENZIONE
			    REPLACE W_IVA    WITH PUB_IVADEF		
			 ELSE
			    REPLACE W_IVA    WITH _JJ_ALRID
			 ENDIF			   	
		     REPLACE W_DA     WITH 'A'

			 IF PUB_INTRASTAT						&& GESTIONE INTRASTAT
			    REPLACE W_CLDOG 		WITH INTRASTAT_CLDOG_RIGA_FATTURA
			    REPLACE W_SERV_INTRA   	WITH INTRASTAT_SERV_INTRA_RIGA_FATTURA 
			    REPLACE W_PORTO 		WITH INTRASTAT_PORTO 
			    REPLACE W_MEZZO 		WITH INTRASTAT_MEZZO  
	  		 ELSE
			    REPLACE W_CLDOG 		WITH ''
			    REPLACE W_SERV_INTRA   	WITH ''
			    REPLACE W_PORTO 		WITH ''
			    REPLACE W_MEZZO 		WITH ''
			 ENDIF
			 REPLACE W_QTA_INTRA 			WITH 0
			 REPLACE W_PESO_INTRA 			WITH 0  && ERASMO - 08/05/2015
   			 REPLACE W_UNITA_SUPPL_INTRA	WITH 0
		ENDIF _VALORE_ENPACL > 0

      ENDIF

      *####################################CALCOLA TUTTE LE IVE############################################################################
	  TIVA = 0
	  DO CALCIVA
      *####################################CALCOLA TUTTE LE IVE############################################################################
 
 
 
 
   ELSE
	  WAIT WINDOW 'Non trovo le righe di dettaglio fattura '+ V_SEEK 	
   ENDIF

   ****SCRIVO I MOVIMENTI / SALDI / PARTITARI ***

   DO REG_NUMRPN

   DO REG_NUMREG
   
   SELECT U_FAT_TT

   V_ER=SOTTOGEN(ORD_CODNAZ)
   IF !V_ER
	  CC = PUB_CC
   ENDIF


   SELECT U_FAT_TT

   BOLLATOIVA = ORD_BOLLATOIVA			&& DETERMINA LA STAMPA SEPARATA DEL BOLLATO IVA TRA FATTURE MANUALI ED AUTOMATICHE DA DDT
   M.CONTO	  = CC+ORD_CODCLI
   
   __CODCLI__ = CC+ORD_CODCLI
  
   M.DTD	= ORD_DATORD
   M.DOC	= ORD_NPROT
   M.OLFAT	= ORD_NUMORD
   M.CCAGE  = ORD_AGE
   IF EMPTY(M.DOC)
	  M.DOC	= ORD_NUMORD
   ENDIF

   IF EMPTY(DATAREG)  OR DATAREG = '  /  /    ' OR DATAREG = '    /  /  '
	  DATREG = RIBALTA2(ORD_DATORD) && FORZA COME DATA DI REGISTRAZIONE LA DATA DI FATTURA
   ELSE
	  DATREG = DATAREG              && FORZA COME DATA DI REGISTRAZIONE LA DATA DIGITATA
   ENDIF

   M.RAGSOC=ORD_RAGSOC
   
   D_A = "D"
   IF NOTAC   = "S" 		   && NOTA CREDITO
      DAVD = "A"
      DAVA = "D"
   ELSE
      DAVD = "D"              && FATTURA
      DAVA = "A"
   ENDIF

   ** 1) CONTROLLO ________________________________________________________________________________________________
   ** >>> CONTROLLI INCROCIATI SU VALORE RICALCOLATO E TOTALE FATTURA MEMORIZZATO SU U_FAT_TT
   * CONTROLLO SU TOTALE ELABORATO E TOTALE FATTURA


   DIFF_TOT = 0



   IF ESISTE_PUBBLICITARIO OR ESISTE_OMAGGIO
   ELSE
	   IF V_TOTALE <> VALFAT				&& VALFAT VALORE TOTALE FATTURA SU U_FAT_TT V_TOTALE VALORE RICALCOLATO SUI DETTAGLI
	      DIFF_TOT = VALFAT - V_TOTALE
	      V_TOTALE = VALFAT
	   ENDIF
   ENDIF




   ** 2) CONTROLLO ________________________________________________________________________________________________
   * >>>>>>>>>> CONTROLLO DI QUADRATURA SU FATTURA IN VALUTA VALORIZZATA AL CAMBIO


   SELECT W_FAT
   GO TOP
 
   X_TOTALE = 0
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF

      _MPU =   W_IMPONI

      _VALX    = _MPU + W_IMPOSTA
      
      X_TOTALE = X_TOTALE + CAMBIO(XVALUTA,_VALX,XCAMBIO)
      SKIP +1
 	  LOOP


   ENDDO


   * CONTROLLA SE TOTALE FATTURA AL CAMBIO <> DI TOTALE FATTURA RICALCOLATO PARTENDO DAI DETTAGLI
   * PER LE SOLE FATTURE IN VALUTA

   **>>> K_TOTALE=V_TOTALE : VALORE ORIGINALE DELLA FATTURA AL CAMBIO
   **>>> X_TOTALE          : VALORE RICALCOLATO PARTENDO DAI DETTAGLI + SPESE INC/TRASP + IVA AL CAMBIO

   K_TOTALE = CAMBIO(XVALUTA,V_TOTALE,XCAMBIO)     

   _DIFVAL = 0

   IF X_TOTALE <> K_TOTALE
      _DIFVAL  = X_TOTALE - K_TOTALE    && VALORE DELLA FATTURA > DEL VALORE RICALCOLATO : DIFFERENZA NEGATIVA PER ABBASSARE IL CONTO CLIENTE
      IF XVALUTA = "ITL" .OR. XVALUTA = "LIT"   && PER LE SOLE FATTURE IN VALUTA
         _DIFVAL = 0
      ENDIF
   ENDIF


   _SEQUEN =  10
   
   *** FABIANO 02/03/2015 - GESTIONE ANTICIPI
   IF _VALORE_SU_ANTICIPO <>0
		V_TOTALE = V_TOTALE - _VALORE_SU_ANTICIPO 
   ENDIF
   *** FABIANO 02/03/2015 - GESTIONE ANTICIPI
   
   DO movcreat WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA  	&&TESTATA
   DO movcreai WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA  	&&INDICE
 


   SELECT W_FAT
   GO TOP

 
   * CONTROLLO DI QUADRATURA TRA VALORE CALCOLATO E VALORE TOTALE DEL DOCUMENTO
   FOR H=1 TO RECCOUNT()
       IF W_IMPOSTA <> 0
          REPLACE W_IMPOSTA WITH  W_IMPOSTA + DIFF_TOT
          EXIT
       ENDIF
       SKIP+1
   NEXT



   SELECT W_FAT
   IF PUB_INTRASTAT						&& GESTIONE INTRASTAT
	   SET ORDER TO INTRA		
   ELSE									&& GESTIONE NORMALE
	   SET ORDER TO DET_PU		
   ENDIF
   GO TOP


   X_TOTALE = 0



   DO WHILE !EOF()

	  Z_CONTO  = W_CONTO
	  Z_NATURA = DAVA
	  Z_CODGRU = ''
	  Z_CODCCO = W_CCOSTO
	  Z_VALORE = W_IMPONI
	  Z_PERCEN = 100
	  Z_NDOC   = M.DOC
	  Z_DTDOC  = M.DTD
	  Z_TOP    = TOP_TOP
	  Z_IVA    = W_IVA
	  Z_CAMBIO = XCAMBIO
	  Z_VALUTA = XVALUTA
	  Z_PUBBLI = W_PUBBLI

	  Z_CLDOG  				= W_CLDOG					&& INTRASTAT
      Z_SERV_INTRA  		= W_SERV_INTRA 				&& INTRASTAT
	  Z_PORTO				= W_PORTO 					&& INTRASTAT
	  Z_MEZZO  				= W_MEZZO 					&& INTRASTAT
	  *Z_QTA_INTRA 			= W_QTA_INTRA 				&& INTRASTAT
   	  *Z_UNITA_SUPPL_INTRA 	= W_UNITA_SUPPL_INTRA 		&& INTRASTAT
   	  && ERASMO - INIZIO 08/05/2015
	  Z_QTA_INTRA 			= CEILING(W_QTA_INTRA)
	  Z_PESO_INTRA 			= CEILING(W_PESO_INTRA)
   	  Z_UNITA_SUPPL_INTRA 	= CEILING(W_UNITA_SUPPL_INTRA)
   	  && ERASMO - FINE 08/05/2015
   	  
   	  
   	  *** FABIANO 02/03/2015 - GESTIONE ANTICIPI
	  IF PUB_ANTCLI_REGAUT AND W_CONTO=PUB_ANTCLI_CONTO
		SKIP
		LOOP
	  ENDIF
	  *** FABIANO 02/03/2015 - GESTIONE ANTICIPI
   	  
	  ** ----------------------------------------------------------------- CONTROPARTITA -----------------------------------------------------------------**
      OLD_DESF = XDESF
      XDESF    = "CLI:"+CERCA_CLI(ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)))+" N.F:"+M.OLFAT+" DEL "+M.DTD
      XDESF    = DESCRIZIONE_AUTOMATICA(XDESF,ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)),M.OLFAT,M.DTD)  && ERASMO - 07/08/2015
      _OKDIFC  = .T.   && GESTIONE DIFFERENZA CAMBIO
      
      FLAG_ANTICIPO_CAMBIO_SEGNO = .F.
      
 	  IF W_IMPONI < 0	  
   	  		*** FABIANO/SERGIO 26/05/2015 - GESTIONE ANTICIPI CON CAMBIO SEGNO AUTOMATICO
		
		    FLAG_ANTICIPO_CAMBIO_SEGNO = .T.
		    
	  		W_IMPONI_CAMBIO_SEGNO = W_IMPONI * -1
	  		W_IMPOSTA_CAMBIO_SEGNO = W_IMPOSTA * -1

 	  		DO movcrea WITH DAVD,W_IMPONI_CAMBIO_SEGNO,W_IMPOSTA_CAMBIO_SEGNO,W_IVA,W_CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DETTAGLI VENDITA
	  ELSE
	  
 	  		DO movcrea WITH DAVA,W_IMPONI,W_IMPOSTA,W_IVA,W_CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DETTAGLI VENDITA
		  
	  ENDIF
 

      =carica_riepiloghi_contabili(W_CONTO,'',W_IMPONI,GETDCON(W_CONTO))
	  IF !EMPTY(Z_CODCCO)
		  Z_CONTOP = X_CONTOP
		  DO CREA_CENTRI_DI_COSTO_DALLE_VENDITE WITH Z_CONTO,Z_NATURA ,Z_CODGRU,Z_CODCCO,Z_VALORE,Z_PERCEN,Z_NDOC,Z_TOP,Z_IVA,Z_CAMBIO,Z_VALUTA,Z_PUBBLI,Z_CONTOP,Z_DTDOC   
		  Z_CODCCO = ""
	  ENDIF	
	  ** ----------------------------------------------------------------- CONTROPARTITA -----------------------------------------------------------------**


	  ** ------------------------------------------------------------------- REOCORD IVA -----------------------------------------------------------------**
*!*		  Z_CLDOG  					= ''			&& INTRASTAT
*!*	      Z_SERV_INTRA  			= ''	 		&& INTRASTAT
*!*		  Z_PORTO					= '' 			&& INTRASTAT
*!*		  Z_MEZZO  					= '' 			&& INTRASTAT
*!*		  Z_PESO					= 0 			&& INTRASTAT
*!*		  Z_IMPEUR_INTRA			= 0 			&& INTRASTAT			
*!*		  Z_IMPVAL_INTRA			= 0 			&& INTRASTAT		
*!*		  Z_IMPSTAT_INTRA   		= 0 			&& INTRASTAT
*!*		  Z_STATO_INTRA_PROV 		= '' 			&& INTRASTAT	 	
*!*		  Z_PARTITA_IVA_INTRA		= '' 			&& INTRASTAT
*!*		  Z_QTA_INTRA 				= 0 			&& INTRASTAT
*!*		  Z_UNITA_SUPPL_INTRA 		= 0 			&& INTRASTAT	
*!*		  Z_COND_CONS_INTRA  		= '' 			&& INTRASTAT		
*!*		  Z_NAZIONE_INTRA			= '' 			&& INTRASTAT
*!*		  Z_PROVIN_DESTI_INTRA		= '' 			&& INTRASTAT
						 	
      _OKDIFC  = .F.

      
      FLAG_ANTICIPO_CAMBIO_SEGNO = .F.

	  *** FABIANO 2015/09/08 - GESTIONE CONTO SPECIFICO PER CODICE IVA
	  CONTO_IVA_SPECIFICO=CON_IVA
	  v_seek	 = 'IVA'+ALLTRIM(W_IVA)
	  v_chiave = "codice"
	  IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
			SELECT CUR_PARA
			CONTO_IVA_SPECIFICO=ALLTRIM(SUBSTR(LIBERA,5,13))             && CONTO IVA CLIENTI
	  ELSE
			WAIT WINDOW "Errore manca conto iva per codice " + ALLTRIM(W_IVA) + " - viene assegnato il conto iva predefinito "+CON_IVA
	  ENDIF
	  SELECT W_FAT
 	  *** FABIANO 2015/09/08 - GESTIONE CONTO SPECIFICO PER CODICE IVA
      
           
 	  IF W_IMPOSTA < 0	  
   	  		*** FABIANO/SERGIO 26/05/2015 - GESTIONE ANTICIPI CON CAMBIO SEGNO AUTOMATICO
   	  		      
            FLAG_ANTICIPO_CAMBIO_SEGNO = .T.
      
	  		W_IMPOSTA_CAMBIO_SEGNO = W_IMPOSTA * -1
	  		*DO movcrea WITH DAVD,W_IMPOSTA_CAMBIO_SEGNO,0,W_IVA,CON_IVA,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO			&&DET IVA
      	    DO movcrea WITH DAVD,W_IMPOSTA_CAMBIO_SEGNO,0,W_IVA,CONTO_IVA_SPECIFICO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO			&&DET IVA  *** FABIANO 2015/09/08 - GESTIONE CONTO SPECIFICO PER CODICE IVA

	  ELSE
      	   *DO movcrea WITH DAVA,W_IMPOSTA,0,W_IVA,CON_IVA,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO			&&DET IVA
      	   DO movcrea WITH DAVA,W_IMPOSTA,0,W_IVA,CONTO_IVA_SPECIFICO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO			&&DET IVA  *** FABIANO 2015/09/08 - GESTIONE CONTO SPECIFICO PER CODICE IVA
      ENDIF
      
      =carica_riepiloghi_contabili('',W_IVA,W_IMPOSTA,GETDIVA(W_IVA))
	  ** ------------------------------------------------------------------- REOCORD IVA -----------------------------------------------------------------**


      ** ARTICOLO PUBBLICITARIO CON IVA A CARICO CLIENTE : CREA SECONDA REGISTRAZIONE
	  IF W_PUBBLI <> 0
		   
		   ___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE = .T.
		   
		   DO REG_NUMRPN
		   DO REG_NUMREG
 	       
 	       SELECT W_FAT
 	       
 
		*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
		*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE

			IF _CNT_PUBBLI = _CNT_ARTICOLI 
		  		VALORE_PUBBLI_RICALCOLATO = W_PUBBLI + VALORE_POLIECO
		  	ELSE
		  	    VALORE_PUBBLI_RICALCOLATO = W_PUBBLI
		  	ENDIF

     		   
		   _SEQUEN =  10
		   

   		   DO movcreat WITH DAVA,VALORE_PUBBLI_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA  	    &&TESTATA
		   DO movcreai WITH DAVA,VALORE_PUBBLI_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA  		&&INDICE

	       OLD_DESF = XDESF
	       XDESF    = "CLI:"+CERCA_CLI(ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)))+" N.F:"+M.OLFAT+" DEL "+M.DTD
	       XDESF    = DESCRIZIONE_AUTOMATICA(XDESF,ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)),M.OLFAT,M.DTD)  && ERASMO - 07/08/2015
	       
	       DO movcrea WITH DAVD,VALORE_PUBBLI_RICALCOLATO,0,'NO',V_AOC,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,VALORE_PUBBLI_RICALCOLATO,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DET VENDITA

		
           =carica_riepiloghi_contabili(V_AOC,'',VALORE_PUBBLI_RICALCOLATO,GETDCON(V_AOC))

     
		   ___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE = .F.


      ENDIF


      ** ARTICOLO OMAGGIO CON IVA A CARICO AZIENDA : CREA SECONDA REGISTRAZIONE
	  IF W_OMAGGIO <> 0
		
		**=> ERASMO/SERGIO - INIZIO 01/04/2016
		IF PUB_OMACIO2  && Trasferisce fatturato con IVA a carico azienda (OMAGGI) creando 2 registrazioni al posto di 3 registrazioni
		
		   ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA = .T.	
		   
		   DO REG_NUMRPN
		   DO REG_NUMREG
 	       
 	       SELECT W_FAT
		   
		   _SEQUEN =  10
  
  		   VALORE_IMPONIBILE_OMAGGIO_RICALCOLATO = W_OMAGGIO + VALORE_POLIECO
  		   VALORE_PUBBLI_RICALCOLATO = W_OMAGGIO + VALORE_POLIECO
  		   
  		   VALORE_IMPOSTA_OMAGGIO_RICALCOLATO = 0
  		   IF W_IMPOSTA <> 0
  		      VALORE_IMPOSTA_OMAGGIO_RICALCOLATO = W_IMPOSTA + IMPOSTA_POLIECO
  		   ENDIF
  		   
  		   VALORE_IMPONIBILE_IMPOSTA_OMAGGIO_RICALCOLATO = VALORE_PUBBLI_RICALCOLATO + VALORE_IMPOSTA_OMAGGIO_RICALCOLATO    
  		   
		   DO movcreat WITH DAVA,VALORE_IMPONIBILE_IMPOSTA_OMAGGIO_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	    &&TESTATA
		   DO movcreai WITH DAVA,VALORE_IMPONIBILE_IMPOSTA_OMAGGIO_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA		&&INDICE
   
           =carica_riepiloghi_contabili(M.CONTO,'',VALORE_IMPONIBILE_IMPOSTA_OMAGGIO_RICALCOLATO,GETDCON(M.CONTO))
           
	       OLD_DESF = XDESF
	       XDESF    = "CLI:"+CERCA_CLI(ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)))+" N.F:"+M.OLFAT+" DEL "+M.DTD
	       XDESF    = DESCRIZIONE_AUTOMATICA(XDESF,ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)),M.OLFAT,M.DTD)
			
			 DO movcrea WITH DAVD,VALORE_PUBBLI_RICALCOLATO,0,'NO',V_AOM,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DET VENDITA
			 =carica_riepiloghi_contabili(V_AOM,'',VALORE_PUBBLI_RICALCOLATO,GETDCON(V_AOM))
			 
			 IF W_IMPOSTA <> 0
				 DO movcrea WITH DAVD,VALORE_IMPOSTA_OMAGGIO_RICALCOLATO,0,'NO',V_CIO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DET VENDITA
				 =carica_riepiloghi_contabili(V_CIO,'',VALORE_IMPOSTA_OMAGGIO_RICALCOLATO,GETDCON(V_CIO))
		     ENDIF

		   ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA = .F.
		
		
		ELSE
		**=> ERASMO/SERGIO - FINE 01/04/2016
		
		   ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA = .T.


		   DO REG_NUMRPN
		   DO REG_NUMREG
 	       
 	       SELECT W_FAT

	  		VALORE_PUBBLI_RICALCOLATO = W_OMAGGIO + VALORE_POLIECO 

		   _SEQUEN =  10

		   DO movcreat WITH DAVA,VALORE_PUBBLI_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	    &&TESTATA
		   DO movcreai WITH DAVA,VALORE_PUBBLI_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA		&&INDICE


	       OLD_DESF = XDESF
	       XDESF    = "CLI:"+CERCA_CLI(ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)))+" N.F:"+M.OLFAT+" DEL "+M.DTD
	       XDESF    = DESCRIZIONE_AUTOMATICA(XDESF,ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)),M.OLFAT,M.DTD)  && ERASMO - 07/08/2015

	       DO movcrea WITH DAVD,VALORE_PUBBLI_RICALCOLATO,0,'NO',V_AOM,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DET VENDITA

           =carica_riepiloghi_contabili(V_AOM,'',VALORE_PUBBLI_RICALCOLATO,GETDCON(V_AOM))

  
		   IF W_IMPOSTA <> 0	
		   
			   DO REG_NUMRPN
			   DO REG_NUMREG
	 	       
	 	       SELECT W_FAT
			   
			   _SEQUEN =  10

	  
	  		   VALORE_IMPOSTA_OMAGGIO_RICALCOLATO = W_IMPOSTA + IMPOSTA_POLIECO
				
			    ** ERASMO/SERGIO 01/04/2016 - NON GESTIVA IL CONTO COSTO IVA OMAGGI A CARICO AZIENDA (V_CIO)
			   DO movcreat WITH DAVD,VALORE_IMPOSTA_OMAGGIO_RICALCOLATO,0,'NO',V_CIO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	    &&TESTATA
			   DO movcreai WITH DAVD,VALORE_IMPOSTA_OMAGGIO_RICALCOLATO,0,'NO',V_CIO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA		&&INDICE
	   
	           =carica_riepiloghi_contabili(V_CIO,'',VALORE_IMPOSTA_OMAGGIO_RICALCOLATO,GETDCON(V_CIO))
	           
		       OLD_DESF = XDESF
		       XDESF    = "CLI:"+CERCA_CLI(ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)))+" N.F:"+M.OLFAT+" DEL "+M.DTD
		       XDESF    = DESCRIZIONE_AUTOMATICA(XDESF,ALLTRIM(SUBSTR(M.CONTO,PUB_SOTTOG,PUB_CONTO)),M.OLFAT,M.DTD)  && ERASMO - 07/08/2015

		         DO movcrea WITH DAVA,VALORE_IMPOSTA_OMAGGIO_RICALCOLATO,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,W_ARPU,W_PUBBLI,W_OMAGGIO,_CODCOMMESSA,Z_CODCCO   	&&DET VENDITA

		       
		   ENDIF


		   ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA = .F.
		   
		ENDIF


      ENDIF


      SELECT W_FAT
  	  SKIP +1


   ENDDO


	IF PUB_TFATT 					&& GESTISCO IL FLAG DELLO STUDIO PROFESSIONALE 
   		
   		IF NOTAC   <> "S" 		   && NOTA CREDITO

			   DO REG_NUMRPN
			   DO REG_NUMREG
			   
			   DD_AA 		= "A"
			   _TOP_ 		= PUB_INCCLI
			   __OMAGGIO 	= 0
			   __ARTPUB		= " "
			   _SEQUEN 		=  10
			   
			   DO movcrinc  WITH DD_AA,V_TOTALE,0,'NO',M.CONTO,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	&&TESTATA
			 
			   DO movcreai  WITH DD_AA,V_TOTALE,0,'NO',M.CONTO,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	&&INDICE
 			 	   
			   DD_AA = "D"   
			   _OKDIFC  = .F.
			   __PUBBLI = 0
			   
			   IF PUB_TFATT		&& GESTIONE RITENUTA ACCONTO SU INCASSI FATTURE 						
   			   		V_TOTALE_NO_RA = V_TOTALE - V_RA
   			   		IF V_TOTALE_NO_RA > 0
   			   			DO movcrea   WITH DD_AA,V_TOTALE_NO_RA,0,'NO',_BANCA_PER_INCASSO_FATTURA,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,__ARTPUB,__PUBBLI,__OMAGGIO,_CODCOMMESSA,Z_CODCCO	 &&BANC-DET IVA
   			   		ENDIF 
   			   		IF V_RA > 0
   			   			DO movcrea   WITH DD_AA,V_RA,0,'NO',CONTO_INCASSO_FAT_PRO,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,__ARTPUB,__PUBBLI,__OMAGGIO,_CODCOMMESSA,Z_CODCCO					 &&BANCA-DET IVA
  			   		ENDIF
  			   ELSE
   			   		DO movcrea   WITH DD_AA,V_TOTALE,0,'NO',_BANCA_PER_INCASSO_FATTURA,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,__ARTPUB,__PUBBLI,__OMAGGIO,_CODCOMMESSA,Z_CODCCO				 &&BANCA-DET IVA
  			   ENDIF
            
               CT_INCAS = CT_INCAS + 1
   
   		ENDIF
   
   ENDIF
   

   SELECT U_FAT_TT
   CT = CT +1
   SKIP +1

ENDDO


*** FABIANO 02/03/2015 - GESTIONE ANTICIPI
IF _VALORE_SU_ANTICIPO <>0

   DO REG_NUMRPN
   DO REG_NUMREG
   
   DD_AA 		= "A"
   _TOP_ 		= PUB_ANTCLI_TOP
   _VALORE_SU_ANTICIPO = ABS(_VALORE_SU_ANTICIPO )
   __OMAGGIO 	= 0
   __ARTPUB		= " "
   _SEQUEN 		=  10
   
   DO movcrinc  WITH DD_AA,_VALORE_SU_ANTICIPO ,0,'NO',M.CONTO,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	&&TESTATA
 
   DO movcreai  WITH DD_AA,_VALORE_SU_ANTICIPO ,0,'NO',M.CONTO,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_CODCOMMESSA	&&INDICE
 			 	   
   DD_AA = "D"   
   _OKDIFC  = .F.
   __PUBBLI = 0
   
   DO movcrea   WITH DD_AA,_VALORE_SU_ANTICIPO ,0,'NO',PUB_ANTCLI_CONTO,_TOP_,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC,__ARTPUB,__PUBBLI,__OMAGGIO,_CODCOMMESSA,Z_CODCCO				 &&BANCA-DET IVA

ENDIF
*** FABIANO 02/03/2015 - GESTIONE ANTICIPI
   	  

**************************************************************************************
*** AGGIORNA I NUMERI DI PARTITA A FRONTE DI NOTE DI ACCREDITO CHE LEGANO PIU' FATTURA

SELECT U_FAT_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF


   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF ORD_DATORD > PERAL
	      EXIT
	   ENDIF
   ENDIF

   IF ORD_CGE
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF

   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF AGEDAL  <> "999"
		  IF VAL(ORD_AGE) <> VAL(AGEDAL)
		     SELECT U_FAT_TT
	 	     SKIP +1
		     LOOP
		  ENDIF
	   ENDIF
   ENDIF


   SELECT U_FAT_TT
  

   _NUMERO_PARTITA_VECCHIA 			= ""
   _NUMERO_PARTITA_NUOVO   			= ""
   _IMPORTO_NOTA_CREDITO			= 0 

   IF !EMPTY(ORD_NPAR01)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR01 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR02)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR02 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR03)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR03 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR04)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR04 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR05)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR05 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR06)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR06 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR07)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR07 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR08)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR08 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR09)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR09 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR10)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR10 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR11)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR11 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR12)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR12 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR13)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR13 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR14)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR14 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF
   IF !EMPTY(ORD_NPAR15)
       _NUMERO_PARTITA_VECCHIA  = ORD_NPAR15 
       _NUMERO_PARTITA_NUOVO    = ORD_NPROT
       _IMPORTO_NOTA_CREDITO	= ORD_VALORE
       =CAMBIA_NUMERO_PARTITA_CLIENTE(__CODCLI__,_NUMERO_PARTITA_VECCHIA,_NUMERO_PARTITA_NUOVO,_IMPORTO_NOTA_CREDITO)
   ENDIF


   SELECT U_FAT_TT
   REPLACE ORD_CGE    WITH .T.
   IF ORD_VALUTA = PUB_VALRIF		&& PER LA STESSA VALUTA DI RIFERIMENTO (EUR) IL CAMBIO E' 1
      REPLACE ORD_CAMBIO WITH 1		&& FORZA IL CAMBIO A 1
   ENDIF
   REPLACE ORD_DATCGE WITH RIBALTA2(DTOC(DATE()))

   SKIP +1

ENDDO



IF !ExecRW(Csql,"U_FAT_TT","W")
   return(.f.)
ENDIF


RELEASE WINDOW DISPLAY


IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
	=MESSAGEB("Fattura/nota credito contabilizzata correttamente",64,"Contabilizzazione immediata fatture")
ELSE 
	_cMsg = "Trasferimento contabile :" + CHR(13) + CHR(13) + "Fatture/Note Credito contabilizzate n:"+ str(CT,5,0) + CHR(13) + "Incassi contabilizzati :" +str(CT_INCAS,5,0) + CHR(13) + CHR(13) + "Fare click su OK per continuare"
	DO MESSAGGIO_STILE_WIN8 WITH _cMsg   
ENDIF 

IF CT = 0 AND CT_INCAS = 0
	__NESSUN_TRASFERIMENTO_CONTABILE_EFFETTUATO = .T.
ELSE
	__NESSUN_TRASFERIMENTO_CONTABILE_EFFETTUATO = .F.
ENDIF

RETURN 


RELEASE WINDOW DISPLAY

PUB_CONDSPE = ""
RELEASE _SC_TIPRENDO

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
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO,NUMCOMM

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
REPLACE MOV_NDOC   	WITH NDOC
REPLACE MOV_TOP    	WITH TOP


IF SUBSTR(V_DTSCA,3,1) = '/'
	REPLACE MOV_DATSCAD	WITH RIBALTA2(V_DTSCA) 	&& DT.SCAD DA FATTURA
ELSE
    REPLACE MOV_DATSCAD	WITH V_DTSCA			&& DT.SCAD DA FATTURA
ENDIF


REPLACE MOV_NPROT  	WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  	WITH CON
REPLACE MOV_IVA    	WITH IV
REPLACE MOV_IMPOST 	WITH TAS

XDESFF = "CLI:"+ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO))+" N.F:"+ALLTRIM(NPRO)+" DEL "+DTD
XDESFF = DESCRIZIONE_AUTOMATICA(XDESFF,ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO)),NPRO,DTD)  && ERASMO - 07/08/2015

REPLACE MOV_DESMOV 	WITH XDESFF
REPLACE MOV_NUMPRO 	WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    	WITH IMP
REPLACE MOV_TMOV   	WITH DA_AV
REPLACE MOV_VALUTA 	WITH YVALUTA
REPLACE MOV_CAMBIO 	WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF

REPLACE MOV_BOLLATOIVA  WITH BOLLATOIVA
IF ESISTE_OMAGGIO 
	REPLACE MOV_IVAOMA WITH .T.
ELSE
	REPLACE MOV_IVAOMA WITH .F.
ENDIF 

REPLACE MOV_NUCOM 	WITH NUMCOMM		
REPLACE MOV_MODPAG  WITH V_CONPAG


** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE MOV_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE MOV_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE MOV_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF



IF !ExecRW('','indice','I','','CU_INDICE')
   return(.f.)
ENDIF



SELECT(SELE)
RETURN


***************************************************************************
PROCEDURE movcreat      && crea la partita primaria e il partitario clienti
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO,NUMCOMM

SELE=SELECT()

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK
REPLACE MOV_SOC    	WITH PUB_CODSOC
REPLACE MOV_ANNO   	WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS 	WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_ANNODO 	WITH SUBSTR(MOV_DTDOC,1,4)   && PROJECT 23/04/2003
REPLACE MOV_NDOC   	WITH NDOC
REPLACE MOV_TOP    	WITH TOP

IF SUBSTR(V_DTSCA,3,1) = '/'
	REPLACE MOV_DATSCAD	WITH RIBALTA2(V_DTSCA) 	&& DT.SCAD DA FATTURA
ELSE
    REPLACE MOV_DATSCAD	WITH V_DTSCA			&& DT.SCAD DA FATTURA
ENDIF


REPLACE MOV_NPROT  	WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  	WITH CON
REPLACE MOV_IVA    	WITH IV
REPLACE MOV_IMPOST 	WITH TAS

XDESFF = "CLI:"+ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO))+" N.F:"+ALLTRIM(NPRO)+" DEL "+DTD
XDESFF = DESCRIZIONE_AUTOMATICA(XDESFF,ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO)),NPRO,DTD)  && ERASMO - 07/08/2015

REPLACE MOV_DESMOV 	WITH XDESFF
REPLACE MOV_NUMPRO 	WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    	WITH IMP
REPLACE MOV_TMOV   	WITH DA_AV
REPLACE MOV_CEE    	WITH M.CCAGE
REPLACE MOV_VALUTA 	WITH YVALUTA
REPLACE MOV_CAMBIO 	WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF

REPLACE MOV_BOLLATOIVA  WITH BOLLATOIVA
REPLACE MOV_SEQUEN		WITH _SEQUEN

REPLACE MOV_NUCOM 	WITH NUMCOMM	
REPLACE MOV_MODPAG  WITH V_CONPAG

** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE MOV_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE MOV_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE MOV_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF




IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF

*******AGGIORNA IL D.B. DEI CONTI

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
   P_IMPA  = CON_IMP_A
   P_IMPD  = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH &VAR2 + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH &VAR + CAMBIO(YVALUTA,IMP,YCAMBIO)
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
   P_IMPA  = CON_IMP_A
   P_IMPD  = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
      REPLACE   CON_IMP_D   WITH P_IMPD + CAMBIO(YVALUTA,IMP,YCAMBIO)
	  REPLACE   &VAR2       WITH &VAR2 + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH &VAR + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ENDIF
ENDIF
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

DO REG_PARCLI    && AGGIORNA PARTITARIO CLIENTI

SELECT(SELE)

RETURN


**************************************
PROCEDURE movcrea                               && CREA LE CONTROPARTITE
**************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO,YOKDIFC,YARPU,YPUBBLI,YOMAGGIO,NUMCOMM,CENTRO_COSTO 

SELE=SELECT()

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF


SELECT CU_MOVCONT
APPEND BLANK
REPLACE MOV_SOC    	WITH PUB_CODSOC
REPLACE MOV_ANNO   	WITH PUB_ANNO

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


REPLACE MOV_ANNODO 	WITH SUBSTR(MOV_DTDOC,1,4)   && PROJECT 23/04/2003
REPLACE MOV_NDOC   	WITH NDOC
REPLACE MOV_TOP    	WITH TOP

IF SUBSTR(V_DTSCA,3,1) = '/'
	REPLACE MOV_DATSCAD	WITH RIBALTA2(V_DTSCA) 	&& DT.SCAD DA FATTURA
ELSE
    REPLACE MOV_DATSCAD	WITH V_DTSCA			&& DT.SCAD DA FATTURA
ENDIF


REPLACE MOV_NPROT  	WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  	WITH CON
REPLACE MOV_IVA    	WITH IV
REPLACE MOV_IMPOST 	WITH TAS
REPLACE MOV_DESMOV 	WITH XDESF
REPLACE MOV_NUMPRO 	WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    	WITH IMP

IF YVALUTA = 'EUR'
	Z_IMPEUR_INTRA  = IMP			
	Z_IMPVAL_INTRA  = 0			
	Z_IMPSTAT_INTRA = INT(IMP)
ELSE
	Z_IMPEUR_INTRA	= INT(CAMBIO(YVALUTA,IMP,YCAMBIO)) && IMPORTO IN EURO RICALCOLATO DAL VALORE IN VALUTA DAL RECORD NON CI SONO DECIMALI ????
	Z_IMPVAL_INTRA  = IMP			
	Z_IMPSTAT_INTRA = Z_IMPEUR_INTRA
ENDIF


REPLACE MOV_TMOV   	WITH DA_AV

*!*	*** INIZIO FABIANO 27/02/2015 - SE L'IMPORTO E' NEGATIVO GLI CAMBIO DI SEGNO E CAMBIO DARE IN AVERE E VICEVERSA
*!*	IF IMP<0
*!*		IF DA_AV="D" 	
*!*			REPLACE MOV_TMOV   	WITH "A"
*!*		ELSE			
*!*			REPLACE MOV_TMOV   	WITH "D"
*!*		ENDIF
*!*		REPLACE MOV_IMP    	WITH ABS(IMP)
*!*		
*!*		*** FABIANO 27/02/2015 - ANCHE L'IMPOSTA E' DA INVERTITRE
*!*		IF TAS<0
*!*			REPLACE MOV_IMPOST 	WITH ABS(TAS)
*!*		ENDIF
*!*	ENDIF
*!*	*** FINE FABIANO 27/02/2015 - SE L'IMPORTO E' NEGATIVO GLI CAMBIO DI SEGNO E CAMBIO DARE IN AVERE E VICEVERSA



REPLACE MOV_CEE    	WITH M.CCAGE
REPLACE MOV_VALUTA 	WITH YVALUTA
REPLACE MOV_CAMBIO 	WITH YCAMBIO
REPLACE MOV_CCO    	WITH CENTRO_COSTO 		&& Z_CODCCO 


IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF

REPLACE MOV_BOLLATOIVA  WITH BOLLATOIVA
_SEQUEN = _SEQUEN + 10
REPLACE MOV_SEQUEN		WITH _SEQUEN

IF YARPU = "O"										&& GESTIONE OMAGGI A CARICO AZIENDA
	REPLACE MOV_IVAOMA WITH .T.
ELSE
	REPLACE MOV_IVAOMA WITH .F.
ENDIF 

REPLACE MOV_PUBBLI WITH YPUBBLI

X_CONTOP = ALLTRIM(STR(RECNO()))               && GESTIONE PER AGGANCIO CENTRI DI COSTO IN VARIAZIONE
REPLACE MOV_CONTOP 	WITH X_CONTOP

REPLACE MOV_NUCOM 	WITH NUMCOMM	
REPLACE MOV_MODPAG  WITH V_CONPAG


** 2015/05/26 FABIANO/SERGIO GESTIONE ANTICIPI CON CAMBIO SEGNO : IN QUESTO CASO IL VALORE ERA NEGATIVO E CON QUESTO FLAG RIESCO POI A RISALIRE AL VALORE NEGATIVO SIA IN PRIMA NOTA CHE IN BOLLATO
IF   FLAG_ANTICIPO_CAMBIO_SEGNO
	REPLACE MOV_ANT_CAMB_SEGNO  WITH .T.
ELSE
	REPLACE MOV_ANT_CAMB_SEGNO  WITH .F.	&& GESTIONE NORMALE
ENDIF
** 2015/05/26 FABIANO/SERGIO GESTIONE ANTICIPI CON CAMBIO SEGNO : IN QUESTO CASO IL VALORE ERA NEGATIVO E CON QUESTO FLAG RIESCO POI A RISALIRE AL VALORE NEGATIVO SIA IN PRIMA NOTA CHE IN BOLLATO



      

IF PUB_INTRASTAT
	** --------------------------------- DATI PER LA GESTIONE INTRASTAT --------------------------------- 
	*REPLACE MOV_PESO     			WITH Z_PESO
	REPLACE MOV_PESO     			WITH Z_PESO_INTRA  && ERASMO - 08/05/2015
	REPLACE MOV_TISPE  				WITH Z_MEZZO
	REPLACE MOV_PORTO  				WITH Z_PORTO
	REPLACE MOV_CLDOG  				WITH Z_CLDOG
	REPLACE MOV_SERV_INTRA			WITH Z_SERV_INTRA				
	REPLACE MOV_IMPEUR_INTRA		WITH Z_IMPEUR_INTRA			
	REPLACE MOV_IMPVAL_INTRA		WITH Z_IMPVAL_INTRA			
	REPLACE MOV_IMPSTAT_INTRA		WITH Z_IMPSTAT_INTRA
	REPLACE MOV_STATO_INTRA_PROV	WITH Z_STATO_INTRA_PROV	 	
	REPLACE MOV_PARTITA_IVA_INTRA	WITH Z_PARTITA_IVA_INTRA
	REPLACE MOV_QTA_INTRA			WITH Z_QTA_INTRA
	REPLACE MOV_UNITA_SUPPL_INTRA	WITH Z_UNITA_SUPPL_INTRA 	
	REPLACE MOV_COND_CONS_INTRA		WITH Z_COND_CONS_INTRA  			
	REPLACE MOV_MEZZI_TRASP_INTRA	WITH Z_MEZZO					 	
	REPLACE MOV_NAZIONE_INTRA		WITH Z_NAZIONE_INTRA			
	REPLACE MOV_PROVIN_DESTI_INTRA	WITH Z_PROVIN_DESTI_INTRA					
	** --------------------------------- DATI PER LA GESTIONE INTRASTAT --------------------------------- 
ELSE
	REPLACE MOV_PESO     			WITH 0
	REPLACE MOV_TISPE  				WITH ''
	REPLACE MOV_PORTO  				WITH ''
	REPLACE MOV_CLDOG  				WITH ''
	REPLACE MOV_SERV_INTRA			WITH ''				
	REPLACE MOV_IMPEUR_INTRA		WITH 0			
	REPLACE MOV_IMPVAL_INTRA		WITH 0			
	REPLACE MOV_IMPSTAT_INTRA		WITH 0
	REPLACE MOV_STATO_INTRA_PROV	WITH ''	 	
	REPLACE MOV_PARTITA_IVA_INTRA	WITH ''
	REPLACE MOV_QTA_INTRA			WITH 0 
	REPLACE MOV_UNITA_SUPPL_INTRA	WITH 0 	
	REPLACE MOV_COND_CONS_INTRA		WITH ''  			
	REPLACE MOV_MEZZI_TRASP_INTRA	WITH ''					 	
	REPLACE MOV_NAZIONE_INTRA		WITH ''			
	REPLACE MOV_PROVIN_DESTI_INTRA	WITH ''					
ENDIF


** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE MOV_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE MOV_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE MOV_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF

SELECT CU_MOVCONT
SCATTER MEMVAR memo


IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF


IF PUB_INTRASTAT		&& ____________________________________________________GESTIONE INTRASTAT

    IF  PUB_STATO_CEE
       	PUB_PAESE_CEE  		= .T.
		PUB_NAZION          = M.MOV_NAZIONE_INTRA
		M.NAZIONE_INTRA 	= M.MOV_NAZIONE_INTRA
    ELSE
       PUB_PAESE_CEE  		= .F.
		PUB_NAZION          = M.MOV_NAZIONE_INTRA
		M.NAZIONE_INTRA 	= M.MOV_NAZIONE_INTRA
    ENDIF
    
	=INTRA_CREA_TABELLA_INTRASTAT() 

ENDIF

        
 *******AGGIORNA IL D.B. DEI CONTI
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
    P_IMPA  = CON_IMP_A
    P_IMPD  = CON_IMP_D
    MESE    = SUBSTR(DATREG,4,2)
    VAR     = "CON_AV"+MESE
    VAR2    = "CON_DA"+MESE
    * SE ESISTE DEFFERENZA DI UNA O PIU' LIRE SCALO UNA LIRA PER OGNI DETTAGLIO
    * DELLA FATTURA
    _LIRA  = 0
    IF YOKDIFC       && GESTIONE RECOR IMPONIBILE
       IF _DIFVAL < 0
          _LIRA=-1
       ELSE
          _LIRA=1
       ENDIF
       IF _DIFVAL = 0
          _LIRA=0
       ENDIF
       _DIFVAL=_DIFVAL-_LIRA
    ENDIF
    CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
    IF DA_AV = 'D'
	   REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA
	   REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA+&VAR2
	ELSE
	   REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA
	   REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA+&VAR
	ENDIF
ELSE
   WAIT WINDOW 'Conto :'+ALLTRIM(CON)+' inesistente su conti'+CHR(13)+'Variare registrazione num : '+NREG  
ENDIF
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

SELECT(SELE)
RETURN

 
*****************
PROCEDURE CALCIVA
*****************
SELECT W_FAT
GO TOP

     
DO WHILE .T.



   IF EOF()
      EXIT
   ENDIF

   VALIVA = W_IMPONI * IVAREAL(W_IVA)
   CIVA  = W_IVA
   IF XVALUTA = "ITL" .OR.  XVALUTA = "LIT"
      VALIVA	=	ROUND((VALIVA+.49),0)
   ELSE
      VALIVA	=	ROUND((VALIVA+.0000),2)
   ENDIF
   TIVA  = TIVA + VALIVA
   REPLACE    W_IMPOSTA WITH VALIVA
   V_TOTALE = V_TOTALE + VALIVA

   
   SKIP +1

ENDDO


RETURN


*****************
FUNCTION IVAREAL
*****************
PARA FG
SELE=SELECT()
RET = 0

v_seek	 = 'IVA'+FG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   LIB=VAL(SUBSTR(LIBERA,1,3))
ELSE
   =MSGBOX('Iva non trovata '+FG,'ATTENZIONE',31)
   LIB=0
ENDIF

RET = LIB/100

SELECT(SELE)
RETURN(RET)


**************
PROCEDURE CHK2
**************
PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH '  '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY
KEYBOARD "{RIGHTARROW}+{LEFTARROW}"
RETURN


**************
PROCEDURE CHKR
**************
PUSH KEY CLEAR
KEYBOARD "{CTRL+W}"
POP KEY


***********************************************
* AGG. NUMERO DI REGISTRAZIONE  INTERNO DI PN *
***********************************************
PROCEDURE REG_NUMRPN
********************

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
PN   = VAL(SUBSTR(LIBERA,1,10))
PN   = PN + 1
PN_C = STR(PN)
*  REPLACE LIBERA WITH ALLTRIM(PN_C)
PN_C = sys(2015)
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
C_NUM  = SUBSTR(LIBERA,1,10)
V_NUM  = VAL(C_NUM)
T_NUM  = V_NUM+1
TC_NUM = STR(T_NUM)
REPLACE LIBERA WITH ALLTRIM(TC_NUM)
NREG   = TC_NUM
X_NREG = NREG
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***********************************************
FUNCTION VEDIART
***********************************************
*** FUNZIONE PER DECODIFICA DELLA CONTROPARTITA
PARA FG,DES_ART,_CONTO_RIGA_ARTICOLO


SELE=SELECT()

RET = ""
XCONDET = _CONTO_RIGA_ARTICOLO

IF PUB_CCOSTD							&& CENTRO DI COSTO STANDARD 
   ___CCOSTO  = ALLTRIM(V_CST)
ENDIF


IF PUB_CCOAART		&& CENTRO DI COSTO DA ANAGRAFICA ARTICOLI
	** 1.0) DETERMINA CENTRO DI COSTO  --------------------------------------------
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + ALLTRIM(FG) + "'"
	x_cond = x_soci + " and " + x_codi
	Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecCommand(cSql,"cur_articoli")
	   return(.f.)
	ENDIF
	SELECT cur_articoli
	GO TOP
	IF !EOF()
		IF !EMPTY(ALLTRIM(ART_CCO))
		   ___CCOSTO  = ALLTRIM(ART_CCO)
		ENDIF
	ENDIF
ENDIF


** 1.1) DETERMINA CONTROPARTITA SU BASE PERSONALIZZAZIONE RICHIESTA
IF _TFPER 					&& VERIFICA SE ESISTE PERSONALIZZAZIONE
   _CODA = FG
   _COCO = SPACE(13)
   =TFCGRUP()
   IF EMPTY(_COCO)
      _COCO=V_CMV
   ENDIF
   RET=ALLTRIM(_COCO)
   SELECT(SELE)
   RETURN(RET)
ENDIF


** 1.2) DETERMINA CONTROPARTITA SU BASE PARAMETRO ATTIVITA' STUDI PROFESSIONALI
IF PUB_TFATT  
   _CODA = FG
   _DES_ART = DES_ART
   _COCO = SPACE(13)
   __CONTO_CONTABILE = ""
   =TFC_ATTIVITA_STUDI_PROFESSIONALI()
   IF EMPTY(__CONTO_CONTABILE)
      _COCO=V_CMV
   ELSE
      _COCO=__CONTO_CONTABILE
   ENDIF
   RET=ALLTRIM(_COCO)
   SELECT(SELE)
   RETURN(RET)
ENDIF


** 1.3) DETERMINA CONTROPARTITA SU BASE TIPO OPERAZIONE
IF _TFTOP 	
				&& VERIFICA SE ESISTE PERSONALIZZAZIONE
   _CODA = FG
   _COCO = TOP_CONT		    && CONTROPARTITA DA PARAMETRO TOP
   IF EMPTY(_COCO)
      _COCO=V_CMV
   ENDIF
   
   RET=ALLTRIM(_COCO)

   ** GESTIONE CENTRI DI COSTO
   
	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
	x_cond = x_soci + " and " + x_codi   
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"CUR_CLIENTI")
	   RETURN .F.
	ENDIF
	SELECT CUR_CLIENTI
	GO TOP   
	IF !EOF()
	   IF PUB_CCOACLI		&& CENTRO DI COSTO DA ANAGRAFICA CLIENTI
		   IF !EMPTY(ALLTRIM(CLI_CCOST1))
	    	   ___CCOSTO  = ALLTRIM(CLI_CCOST1)
		   ENDIF 	
	   ENDIF
	ENDIF

   SELECT(SELE)
   RETURN(RET)

ENDIF

** 1.4) ACCESSO ANAGRAFICA CLIENTI 
x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
IF !EOF()
   IF !EMPTY(ALLTRIM(CLI_CONTO1))
      RET=CLI_CONTO1
   ENDIF
   IF PUB_CCOACLI		&& CENTRO DI COSTO DA ANAGRAFICA CLIENTI
	   IF !EMPTY(ALLTRIM(CLI_CCOST1))
    	   ___CCOSTO  = ALLTRIM(CLI_CCOST1)
	   ENDIF 	
   ENDIF
ENDIF


** 1.5) DETERMINA CENTRO DI COSTO DALLA RIGA FATTURA  

IF PUB_CCODET 
   IF !EMPTY(ALLTRIM(___CCOSTO_RIGA_FATTURA))
	   ___CCOSTO  = ALLTRIM(___CCOSTO_RIGA_FATTURA)
   ENDIF 
ENDIF

** 1.6) ACCESSO ANAGRAFICA ARTICOLI  
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(FG) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   _LIN = ART_LINEA
   IF EMPTY(ALLTRIM(ART_CGE))
      IF EMPTY(ALLTRIM(RET))
   	     RET = V_CMV
      ENDIF
   ELSE
      RET = ART_CGE
   ENDIF
ELSE
   IF EMPTY(ALLTRIM(RET))
      RET  = V_CMV
   ENDIF
   _LIN = "X"
ENDIF


** 1.7) ACCESSO SE RICHIESTO AL PARAMETRO LINEA / NAZIONE 
IF _TLIN && VERIFICA SE RICHIESTO
   v_seek	= 'CRA'+ALLTRIM(_LIN)+ALLTRIM(_NAZ)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      RET=ALLTRIM(LIBERA)
   ENDIF
ENDIF


** 1.8) DETERMINA CONTROPARTITA SU BASE TIPO OPERAZIONE SOLO PER LE NOTE DI ACCREDITO CLIENTE

IF TOP_TOP = PUB_NCR 			&& VERIFICA SE TOP DI NOTA DI ACCREDITO CLIENTE
   IF FLG_ABB
      _COCO = TOP_CONTABB		&& CONTROPARTITA DA PARAMETRO TOP X ABBUONO
      IF EMPTY(ALLTRIM(_COCO))
         _COCO = TOP_CONT		&& CONTROPARTITA DA PARAMETRO TOP
      ENDIF
   ELSE
      _COCO = TOP_CONT			&& CONTROPARTITA DA PARAMETRO TOP
   ENDIF
   IF EMPTY(ALLTRIM(_COCO))
      _COCO=V_CMV
   ENDIF
   

   RET=ALLTRIM(_COCO)

ENDIF


** 1.9) ATTRIBUISCE LA CONTROPARTITA SE INDICATA SULLA TESTATA FATTURA 

IF !EMPTY(ALLTRIM(XCONCON))
	RET=ALLTRIM(XCONCON)
ENDIF

** 1.10) ACCESSO SE RICHIESTO AL PARAMETRO PAESE / GRUPPO MERCEOLOGICO INDUSTRIALE 

IF PUB_TPAEGRU	 
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + ALLTRIM(FG) + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select ART_CODGMI from U_ART_AN where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecCommand(cSql,"CA_ART_AN_cu")
	   RETURN .F.
	ENDIF
	SELECT CA_ART_AN_cu
	GO TOP 
	IF !EOF()
		__GRUPPO_MERCEOLOGICO_INDUSTRIALE	= ART_CODGMI
	ELSE 
		__GRUPPO_MERCEOLOGICO_INDUSTRIALE	= ""			 
	ENDIF
    PUB_PAESE   = CERCA_TIPOLOGIA_PAESE_E_NAZIONE_INTRASTAT(ALLTRIM(_NAZ))
	_CCONDET 	= CERCA_CONTO_CONTABILE_VENDITE_IN_TABELLA_PAESE_GRUPPO_MERCEOLOGICO_INDUSTRIALE(PUB_PAESE,__GRUPPO_MERCEOLOGICO_INDUSTRIALE)
	IF !EMPTY(_CCONDET)
		RET=ALLTRIM(_CCONDET)
	ENDIF
ENDIF


** 1.11) ATTRIBUISCE LA CONTROPARTITA SE INDICATA SUL DETTAGLIO FATTURA 

IF !EMPTY(ALLTRIM(XCONDET))
	RET=ALLTRIM(XCONDET)
ENDIF


** 1.12) VERIFICA SU PIANO DEI CONTI ESISTENZA CONTO : SI DA PER SCONTATO CHE IL CONTO AUTOMATICO DI DEFAULT ESISTA SU CONTI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(RET) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"cur_conti")
   return(.f.)
ENDIF
SELECT cur_conti
GO TOP
IF EOF()
   RET = V_CMV
ENDIF

IF EMPTY(RET)
   RET = V_CMV
ENDIF

SELECT(SELE)

RETURN(RET)


*************************************************************************
*   AGGIORNAMENTO PARTITARIO CLIENTI                                    *
*************************************************************************
PROCEDURE REG_PARCLI
********************


x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
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
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
ELSE
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16)
   V_RAGSOC  = "CLIENTE INESISTENTE"
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
ENDIF

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
ENDIF

*!*	IF NOTAC  = "S"       && FORZATURA CPA CONTANTI SE NOTA CREDITO
*!*	   V_CONPAG  = PUB_CPA
*!*	ENDIF

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF

SELECT CU_PARTCLI
APPEND BLANK
REC_PART=RECNO()
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO

IF NOTAC  = "S"  && NOTA CREDITO
   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH "A"
ELSE
   REPLACE PAR_TIPODO  WITH "FAT"
   REPLACE PAR_TMOV    WITH "D"
ENDIF

IF    ___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE 

   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH "A"

ENDIF

IF    ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA 

   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH "A"

ENDIF


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
REPLACE PAR_TIPFAT  WITH TOP
REPLACE PAR_NPROT   WITH NPRO               && NUMERO DI FATTURA AGENTE
REPLACE PAR_TOTIM   WITH IMP - TIVA
REPLACE PAR_TIMPOS  WITH TIVA
REPLACE PAR_FATT    WITH IMP
REPLACE PAR_NUMFAT  WITH NDOC
REPLACE PAR_NPROG   WITH 100
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH IMP - TIVA
REPLACE PAR_IMPOS1  WITH TIVA
REPLACE PAR_TOT1    WITH IMP
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


IF SUBSTR(V_DTSCA,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(V_DTSCA) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH V_DTSCA           && DT.SCAD DA FATTURA
ENDIF

REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP	          && VALORE IN VALUTA


** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE PAR_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE PAR_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE PAR_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF


IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF


IF PUB_CONDSPE <> "S"
	DO REG_SCAD      			&& GESTIONE SCADENZIARIO CLIENTI
ELSE
	DO REG_SCAD_SPECIALI      	&& GESTIONE CONDIZIONI DI PAGAMENTO SPECIALI
ENDIF



RETURN



*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI                                      *
*************************************************************************
PROCEDURE REG_SCAD_SPECIALI
***************************


	v_SEEK = _SC_TIPRENDO
	IF seek_std('SCADENZE',v_seek,'TIPRENDO','CUR_SCADENZE')
	  SELECT CUR_SCADENZE
	ELSE
	  DO REG_SCAD      			&& CONDIZIONI SPECIALI NON TROVATE : GESTIONE SCADENZIARIO CLIENTI 
	  RETURN
	ENDIF


	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
	x_cond = x_soci + " and " + x_codi   
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"CUR_CLIENTI")
	   RETURN .F.
	ENDIF
	SELECT CUR_CLIENTI
	GO TOP   
	DATA_SCAD=SPACE(10)
	IF !EOF()
	   V_TELEFO  = CLI_TELEFO
	   V_PARIVA  = CLI_PARIVA
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= CLI_BDAL
	   VET_DAL[2]= CLI_B2DAL
	   VET_AL[1] = CLI_BAL
	   VET_AL[2] = CLI_B2AL
	   VET_DAY[1]= CLI_GG1
	   VET_DAY[2]= CLI_GG2
	   v_seek	= "CPA"+V_CONPAG
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	   ELSE
	      V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
	   ENDIF
	ENDIF

    CONTA_TRA = 0
  	SELECT CUR_SCADENZE
  	INDEX ON RIBALTA2(ORD_DTSCAD) TAG ORD_DTSCAD
    SET ORDER TO ORD_DTSCAD
	GO top
	  
	DO WHILE !EOF()
	  
	    IF ALLTRIM(TIPRENDO)!=ALLTRIM(_SC_TIPRENDO)
	      EXIT
	    ENDIF
	     
	    CONTA_TRA = CONTA_TRA + 1
	     
	    _TRANCH	   =ORD_TRANCH
	    _DTSCAD	   =ORD_DTSCAD
	    _RIBA	   =ORD_RIBA
	    _DESSCAD   =ALLTRIM(ORD_DESCRI)


		IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
		   return(.f.)
		ENDIF
		
		SELECT CU_PARTCLI
		APPEND BLANK
		REPLACE PAR_CODSOC  WITH PUB_CODSOC
		REPLACE PAR_ANNO    WITH PUB_ANNO
		IF NOTAC  = "S"
		   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
		   REPLACE PAR_TMOV    WITH  "A"
		ELSE
		   REPLACE PAR_TIPODO  WITH "FAT"
		   REPLACE PAR_TMOV    WITH  "D"
		ENDIF

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
		REPLACE PAR_TIPFAT  WITH TOP
		REPLACE PAR_TOTIM   WITH 0
		REPLACE PAR_TIMPOS  WITH 0
		REPLACE PAR_FATT    WITH _TRANCH
		REPLACE PAR_NPROT   WITH NPRO              && NUMERO DI FATTURA AGENTE
		REPLACE PAR_NUMFAT  WITH NDOC
		XPRG = CONTA_TRA * 100
		REPLACE PAR_NPROG   WITH XPRG + 100
		REPLACE PAR_NPART   WITH VAL(NDOC)
		REPLACE PAR_CODPAG  WITH V_CONPAG
		REPLACE PAR_TEL     WITH V_TELEFO
		REPLACE PAR_IVA     WITH V_PARIVA
		REPLACE PAR_NREG    WITH ALLTRIM(NREG)
		REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)
		REPLACE PAR_CIVA1   WITH CIVA
		REPLACE PAR_IMPO1   WITH _TRANCH
		REPLACE PAR_IMPOS1  WITH TIVA
		REPLACE PAR_TOT1    WITH _TRANCH
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
		
        REPLACE PAR_DESMOV  WITH ALLTRIM(_DESSCAD)  

		IF SUBSTR(_DTSCAD,3,1) = '/'
		   REPLACE PAR_DTSCAD  WITH RIBALTA2(_DTSCAD) && DT.SCAD DA FATTURA
		ELSE
		   REPLACE PAR_DTSCAD  WITH _DTSCAD           && DT.SCAD DA FATTURA
		ENDIF

		REPLACE PAR_VALUTA WITH YVALUTA
		REPLACE PAR_CAMBIO WITH YCAMBIO
		IF SUBSTR(DTD,3,1) = '/'
		   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
		ELSE
		   REPLACE PAR_DTVAL  WITH DTD
		ENDIF
		
		REPLACE PAR_IMPVAL WITH _TRANCH          && VALORE IN VALUTA


	
		** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
		REPLACE PAR_STATO_CEE	WITH "" 
		IF  PUB_STATO_CEE
			REPLACE PAR_STATO_CEE	WITH "CEE"
		ELSE
			IF PUB_STATO_EXTRA_CEE
				REPLACE PAR_STATO_CEE	WITH "EXT" 
			ENDIF
		ENDIF



		
		IF !ExecRW('','part_cli','I','','CU_PARTCLI')
		   return(.f.)
		ENDIF


	    SELECT CUR_SCADENZE
	    SKIP
	  
	ENDDO


RETURN


*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI                                      *
*************************************************************************
PROCEDURE REG_SCAD_SPECIALI_INCAS
*********************************


	v_SEEK = _SC_TIPRENDO
	IF seek_std('SCADENZE',v_seek,'TIPRENDO','CUR_SCADENZE')
	  SELECT CUR_SCADENZE
	ELSE
	  DO REG_SCAD      			&& CONDIZIONI SPECIALI NON TROVATE : GESTIONE SCADENZIARIO CLIENTI 
	  RETURN
	ENDIF


	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
	x_cond = x_soci + " and " + x_codi   
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"CUR_CLIENTI")
	   RETURN .F.
	ENDIF
	SELECT CUR_CLIENTI
	GO TOP   
	DATA_SCAD=SPACE(10)
	IF !EOF()
	   V_TELEFO  = CLI_TELEFO
	   V_PARIVA  = CLI_PARIVA
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= CLI_BDAL
	   VET_DAL[2]= CLI_B2DAL
	   VET_AL[1] = CLI_BAL
	   VET_AL[2] = CLI_B2AL
	   VET_DAY[1]= CLI_GG1
	   VET_DAY[2]= CLI_GG2
	   v_seek	= "CPA"+V_CONPAG
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	   ELSE
	      V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
	   ENDIF
	ENDIF

    CONTA_TRA = 0
  	SELECT CUR_SCADENZE
  	INDEX ON RIBALTA2(ORD_DTSCAD) TAG ORD_DTSCAD
    SET ORDER TO ORD_DTSCAD
	GO top
	  
	DO WHILE !EOF()
	  
	    IF ALLTRIM(TIPRENDO)!=ALLTRIM(_SC_TIPRENDO)
	      EXIT
	    ENDIF
	     
	    CONTA_TRA = CONTA_TRA + 1
	     
	    _TRANCH	   =ORD_TRANCH
	    _DTSCAD	   =ORD_DTSCAD
	    _RIBA	   =ORD_RIBA
	    _DESSCAD   =ALLTRIM(ORD_DESCRI)


		IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
		   return(.f.)
		ENDIF
		
		SELECT CU_PARTCLI
		APPEND BLANK
		REPLACE PAR_CODSOC  WITH PUB_CODSOC
		REPLACE PAR_ANNO    WITH PUB_ANNO
		REPLACE PAR_TIPODO  WITH "PAG"
		REPLACE PAR_TMOV    WITH  "A"

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
		REPLACE PAR_TIPFAT  WITH TOP
		REPLACE PAR_TOTIM   WITH 0
		REPLACE PAR_TIMPOS  WITH 0
		REPLACE PAR_FATT    WITH _TRANCH
		REPLACE PAR_NPROT   WITH NPRO              && NUMERO DI FATTURA AGENTE
		REPLACE PAR_NUMFAT  WITH NDOC
		XPRG = CONTA_TRA * 100
		REPLACE PAR_NPROG   WITH XPRG + 100
		REPLACE PAR_NPART   WITH VAL(NDOC)
		REPLACE PAR_CODPAG  WITH V_CONPAG
		REPLACE PAR_TEL     WITH V_TELEFO
		REPLACE PAR_IVA     WITH V_PARIVA
		REPLACE PAR_NREG    WITH ALLTRIM(NREG)
		REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)
		REPLACE PAR_CIVA1   WITH CIVA
		REPLACE PAR_IMPO1   WITH _TRANCH
		REPLACE PAR_IMPOS1  WITH TIVA
		REPLACE PAR_TOT1    WITH _TRANCH
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
		
        REPLACE PAR_DESMOV  WITH ALLTRIM(_DESSCAD)  

		IF SUBSTR(_DTSCAD,3,1) = '/'
		   REPLACE PAR_DTSCAD  WITH RIBALTA2(_DTSCAD) && DT.SCAD DA FATTURA
		ELSE
		   REPLACE PAR_DTSCAD  WITH _DTSCAD           && DT.SCAD DA FATTURA
		ENDIF

		REPLACE PAR_VALUTA WITH YVALUTA
		REPLACE PAR_CAMBIO WITH YCAMBIO
		IF SUBSTR(DTD,3,1) = '/'
		   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
		ELSE
		   REPLACE PAR_DTVAL  WITH DTD
		ENDIF
		
		REPLACE PAR_IMPVAL WITH _TRANCH          && VALORE IN VALUTA


		** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
		REPLACE PAR_STATO_CEE	WITH "" 
		IF  PUB_STATO_CEE
			REPLACE PAR_STATO_CEE	WITH "CEE"
		ELSE
			IF PUB_STATO_EXTRA_CEE
				REPLACE PAR_STATO_CEE	WITH "EXT" 
			ENDIF
		ENDIF



		
		IF !ExecRW('','part_cli','I','','CU_PARTCLI')
		   return(.f.)
		ENDIF


	    SELECT CUR_SCADENZE
	    SKIP
	  
	ENDDO


RETURN

*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI                                      *
*************************************************************************
PROCEDURE REG_SCAD
******************

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
DATA_SCAD=SPACE(10)
IF !EOF()
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2

   ___INCASS	  = CLI_INCASS
   ___FLAG_POSALL = CLI_POSALL					&& posticipi per tutto l'anno
   ___CLIENTE     = SUBSTR(CON,PUB_SOTTOG,9)	&& posticipi per tutto l'anno


   v_seek	= "CPA"+V_CONPAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
      V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
   ENDIF

   V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(DTD),IMP,VET_DAL,VET_AL,VET_DAY,YVALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)    && posticipi per tutto l'anno

   DO PERIODI     && CREA I PERIODI DI SCADENZA


ENDIF

RETURN

*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI                                      *
*************************************************************************
PROCEDURE REG_SCAD_INCAS
************************

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
DATA_SCAD=SPACE(10)
IF !EOF()
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   
   ___INCASS	  = CLI_INCASS
   ___FLAG_POSALL = CLI_POSALL					&& posticipi per tutto l'anno
   ___CLIENTE     = SUBSTR(CON,PUB_SOTTOG,9)	&& posticipi per tutto l'anno
  
    
   v_seek	= "CPA"+V_CONPAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
      V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
   ENDIF
   
   V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(DTD),IMP,VET_DAL,VET_AL,VET_DAY,YVALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)    && posticipi per tutto l'anno
  
   DO PERIODI_INCAS     && CREA I PERIODI DI SCADENZA
   
ENDIF

RETURN



*************************
PROCEDURE PERIODI
*************************

SELECT CU_TRANK
GO TOP
DO WHILE .NOT. EOF()


    DATA_SCAD = TK_DSCAD
	IMP_TRANK = TK_IMP_SCAD 
	
	DO CREA_PERI
	
	SELECT CU_TRANK
	SKIP +1

ENDDO

RETURN


*************************
PROCEDURE PERIODI_INCAS
*************************

SELECT CU_TRANK
GO TOP
DO WHILE .NOT. EOF()


    DATA_SCAD = TK_DSCAD
	IMP_TRANK = TK_IMP_SCAD 
	
	DO CREA_PERI_INCAS
	
	SELECT CU_TRANK
	SKIP +1

ENDDO

RETURN


*************************
PROCEDURE PAROLA
*************************
DO WHILE .T.
   IS=IS + 1
   IF IS > LEN(ALLTRIM(V_TUTTO))
      EXIT
   ENDIF
   CARATT = SUBSTR(V_TUTTO,IS,1)
   IF !EMPTY(CARATT)
      XPAROLA = XPAROLA + SUBSTR(V_TUTTO,IS,1)
   ELSE
      EXIT
   ENDIF
ENDDO

RETURN


*************************
PROCEDURE CREA_PERI
*************************
** ===>>> CREA I PERIODI DI SCADENZA

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
IF NOTAC  = "S"
   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH  "A"
ELSE
   REPLACE PAR_TIPODO  WITH "FAT"
   REPLACE PAR_TMOV    WITH  "D"
ENDIF

IF    ___STO_CREANDO_LA_SECONDA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_CLIENTE 

   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH "A"

ENDIF

IF    ___STO_CREANDO_LA_SECONDA_TERZA_REGISTRAZIONE_PER_OMAGGIO_CON_IVA_A_CARICO_AZIENDA 

   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH "A"

ENDIF


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
REPLACE PAR_TIPFAT  WITH TOP
REPLACE PAR_TOTIM   WITH 0
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH IMP_TRANK
REPLACE PAR_NPROT   WITH NPRO              && NUMERO DI FATTURA AGENTE
REPLACE PAR_NUMFAT  WITH NDOC
XPRG = CONTA_TRA * 100
REPLACE PAR_NPROG   WITH XPRG + 100
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH IMP - TIVA
REPLACE PAR_IMPOS1  WITH TIVA
REPLACE PAR_TOT1    WITH IMP
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

IF SUBSTR(DATA_SCAD,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_SCAD) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH DATA_SCAD           && DT.SCAD DA FATTURA
ENDIF

REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP_TRANK          && VALORE IN VALUTA



** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE PAR_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE PAR_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE PAR_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF



IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF

RETURN

*************************
PROCEDURE CREA_PERI_INCAS
*************************
** ===>>> CREA I PERIODI DI SCADENZA A FRONTE DI UN INCASSO DIRETTO DELLA FATTURA

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
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
REPLACE PAR_TIPFAT  WITH TOP
REPLACE PAR_TOTIM   WITH 0
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH IMP_TRANK
REPLACE PAR_NPROT   WITH NPRO              && NUMERO DI FATTURA AGENTE
REPLACE PAR_NUMFAT  WITH NDOC
XPRG = CONTA_TRA * 100
REPLACE PAR_NPROG   WITH XPRG + 100
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH IMP - TIVA
REPLACE PAR_IMPOS1  WITH TIVA
REPLACE PAR_TOT1    WITH IMP
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

IF SUBSTR(DATA_SCAD,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_SCAD) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH DATA_SCAD           && DT.SCAD DA FATTURA
ENDIF

REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP_TRANK          && VALORE IN VALUTA

** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE PAR_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE PAR_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE PAR_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF


IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF

RETURN

************************
FUNCTION TFCGRUP				&& OTTIENE LA CONTROPARTITA SU OZIONE PERSONALIZZAZIONE
************************

SXXS=STR(SELECT())

V_ER=SOTTOGEN(_NAZ)    && PRELEVA IL GRUPPO
IF !V_ER
   CC = PUB_CC
ENDIF

DO CASE
   CASE CC = "1011"	&& CLIENTE ITALIA
        DO PRNITALI
   CASE CC = "1012"	&& CLIENTE CEE
        DO PRNCOCEE
   CASE CC = "1013"	&& CLIENTE EXTRACEE
        DO PRNEXTRA
ENDCASE

SELECT &SXXS
RETURN

*****************************************
FUNCTION TFC_ATTIVITA_STUDI_PROFESSIONALI
*****************************************

SXXS=STR(SELECT())

DO PRN_DECODIFICA_ATTIVITA_STUDI_PROFESSIONALI

SELECT &SXXS

RETURN


***************************************************************************
PROCEDURE movcrinc     && crea la partita primaria e il partitario clienti
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO,NUMCOMM 

SELE=SELECT()

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK
REPLACE MOV_SOC    	WITH PUB_CODSOC
REPLACE MOV_ANNO   	WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS 	WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_ANNODO 	WITH SUBSTR(MOV_DTDOC,1,4)   && PROJECT 23/04/2003
REPLACE MOV_NDOC   	WITH NDOC
REPLACE MOV_TOP    	WITH TOP

IF SUBSTR(V_DTSCA,3,1) = '/'
	REPLACE MOV_DATSCAD	WITH RIBALTA2(V_DTSCA) 	&& DT.SCAD DA FATTURA
ELSE
    REPLACE MOV_DATSCAD	WITH V_DTSCA			&& DT.SCAD DA FATTURA
ENDIF


REPLACE MOV_NPROT  	WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  	WITH CON
REPLACE MOV_IVA    	WITH IV
REPLACE MOV_IMPOST 	WITH TAS

XDESFF = "CLI:"+ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO))+" N.F:"+ALLTRIM(NPRO)+" DEL "+DTD
XDESFF = DESCRIZIONE_AUTOMATICA(XDESFF,ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO)),NPRO,DTD)  && ERASMO - 07/08/2015

REPLACE MOV_DESMOV 	WITH XDESFF
REPLACE MOV_NUMPRO 	WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    	WITH IMP
REPLACE MOV_TMOV   	WITH DA_AV
REPLACE MOV_CEE    	WITH M.CCAGE
REPLACE MOV_VALUTA 	WITH YVALUTA
REPLACE MOV_CAMBIO 	WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF

REPLACE MOV_BOLLATOIVA  WITH BOLLATOIVA
REPLACE MOV_SEQUEN		WITH _SEQUEN

REPLACE MOV_NUCOM 	WITH NUMCOMM 	

** CONTROLLA SE IL CLIENTE E' MEMBRO DELLA COMUNITA' EUROPEA , NEL CASO NON LO SIA DISABILITA IL FLAG **
REPLACE MOV_STATO_CEE	WITH "" 
IF  PUB_STATO_CEE
	REPLACE MOV_STATO_CEE	WITH "CEE"
ELSE
	IF PUB_STATO_EXTRA_CEE
		REPLACE MOV_STATO_CEE	WITH "EXT" 
	ENDIF
ENDIF


IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF

*******AGGIORNA IL D.B. DEI CONTI

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
   P_IMPA  = CON_IMP_A
   P_IMPD  = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH &VAR2 + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH &VAR + CAMBIO(YVALUTA,IMP,YCAMBIO)
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
   P_IMPA  = CON_IMP_A
   P_IMPD  = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
      REPLACE   CON_IMP_D   WITH P_IMPD + CAMBIO(YVALUTA,IMP,YCAMBIO)
	  REPLACE   &VAR2       WITH &VAR2 + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH &VAR + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ENDIF
ENDIF
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

DO RED_PARINC    && AGGIORNA PARTITARIO CLIENTI

SELECT(SELE)

RETURN




************************************************************************* 
*   AGGIORNAMENTO PARTITARIO CLIENTI                                    *
************************************************************************* 
PROCEDURE RED_PARINC



x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
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
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
ELSE
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16)
   V_RAGSOC  = "CLIENTE INESISTENTE"
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
ENDIF

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
ENDIF

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF


IF PUB_CONDSPE <> "S"
	DO REG_SCAD_INCAS      				&& GESTIONE SCADENZIARIO CLIENTI A FRONTE DI UN INCASSO CLIENTI
ELSE
	DO REG_SCAD_SPECIALI_INCAS      	&& GESTIONE CONDIZIONI DI PAGAMENTO SPECIALI A FRONTE DI UN INCASSO CLIENTI
ENDIF


RETURN



*****************************************
PROCEDURE CONTROLLI_FINALI
*****************************************
LPARAMETERS __TFC_CONTABILIZZA_SINGOLA_FATTURA,__TFC_CODCLI,__TFC_NUMORD,__TFC_DATORD


LOCAL ___ESISTONO_ARTICOLI_CON_OMAGGIO_SIA_CON_IVA_A_CARICO_AZIENDA_CHE_A_CARICO_CLIENTE 
LOCAL ___ESISTONO_ARTICOLI_MISTI_CON_OMAGGIO_E_PUBBLICITARIO

___ESISTONO_ARTICOLI_CON_OMAGGIO_SIA_CON_IVA_A_CARICO_AZIENDA_CHE_A_CARICO_CLIENTE = .F.
___ESISTONO_ARTICOLI_MISTI_CON_OMAGGIO_E_PUBBLICITARIO = .F.


SELECT U_FAT_TT
GO TOP 

DO WHILE !EOF()

   IF DELETED()
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF
   
   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF ORD_DATORD > PERAL
	      EXIT
	   ENDIF
   ENDIF

   IF ORD_CGE
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF

   IF __TFC_CONTABILIZZA_SINGOLA_FATTURA
   ELSE
	   IF AGEDAL  <> "999"
		  IF VAL(ORD_AGE) <> VAL(AGEDAL)
		     SELECT U_FAT_TT
	 	     SKIP +1
		     LOOP
		  ENDIF
	   ENDIF
   ENDIF

   _S_ORD_NUMORD = ALLTRIM(ORD_NUMORD)
   _S_ORD_DATORD = RIBALTA2(ORD_DATORD)
   _S_ORD_RAGSOC = ALLTRIM(ORD_RAGSOC)
   

   ___ESISTONO_ARTICOLI_CON_OMAGGIO_SIA_CON_IVA_A_CARICO_AZIENDA_CHE_A_CARICO_CLIENTE = .F.
   ___ESISTONO_ARTICOLI_MISTI_CON_OMAGGIO_E_PUBBLICITARIO = .F.


   _CNT_ART_NO_OMAGGI 	= 0		&& CONTATORE DI ARTICOLI CHE HANNO ORD_PUBBLI = 'BLANK'
   _CT_PUBBLI = 0 
   _CT_OMAGGI = 0

 
   SELECT U_FAT_TT
   V_SEEK   = TAGGANCIO

   x_agga = "daggancio = '" + ALLTRIM(V_SEEK) + "'"
   x_cond = x_agga
   Csql   = "select * from u_fat_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(Csql,"CTR_U_FAT_DD")
      return(.f.)
   ENDIF
   SELECT CTR_U_FAT_DD
   GO TOP
   DO WHILE !EOF()
    
 	 IF "*** COMMENTO ***" $ ORD_DESART
        SELECT CTR_U_FAT_DD
        SKIP +1
        LOOP
	 ENDIF
	 
 	 IF SUBSTR(ORD_DESART,1,3) = "***"
        SKIP +1
        LOOP
	 ENDIF


	 IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	 	IF UPPER(ORD_PUBBLI) <> "S" AND UPPER(ORD_PUBBLI) <> "O"
	 		_CNT_ART_NO_OMAGGI = _CNT_ART_NO_OMAGGI + 1
	 	ENDIF
	 ENDIF

	 IF ORD_PUBBLI = "S"
	    _CT_PUBBLI = _CT_PUBBLI + 1 
	 ENDIF
	   
     IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
	  	_CT_OMAGGI = _CT_OMAGGI + 1
      	SELECT CTR_U_FAT_DD
      	SKIP +1
      	LOOP
     ENDIF
   

     SELECT CTR_U_FAT_DD
     SKIP +1
         
   ENDDO WHILE !EOF()


	IF _CT_PUBBLI > 0 AND _CT_OMAGGI > 0
	   ___ESISTONO_ARTICOLI_CON_OMAGGIO_SIA_CON_IVA_A_CARICO_AZIENDA_CHE_A_CARICO_CLIENTE = .T.
	ENDIF



	IF _CNT_ART_NO_OMAGGI > 0 AND (_CT_PUBBLI > 0 OR _CT_OMAGGI > 0)
	   ___ESISTONO_ARTICOLI_MISTI_CON_OMAGGIO_E_PUBBLICITARIO = .T.
	ENDIF

     
   IF ___ESISTONO_ARTICOLI_CON_OMAGGIO_SIA_CON_IVA_A_CARICO_AZIENDA_CHE_A_CARICO_CLIENTE 
		MESSAGEBOX("Fattura Nr."+_S_ORD_NUMORD+" del "+_S_ORD_DATORD+" - Cliente:"+_S_ORD_RAGSOC+;
			" - La fattura contiene una gestione mista di"+CHR(13)+"OMAGGI con iva a carico CLIENTE/AZIENDA"+CHR(13)+"Impossibile confermare l'aggiornamento",64,"*** ATTENZIONE ***") 
	 	RETURN (.F.)
   ENDIF 

   IF ___ESISTONO_ARTICOLI_MISTI_CON_OMAGGIO_E_PUBBLICITARIO 
		MESSAGEBOX("Fattura Nr."+_S_ORD_NUMORD+" del "+_S_ORD_DATORD+" - Cliente:"+_S_ORD_RAGSOC+;
		" - La fattura contiene una gestione mista di:"+CHR(13)+"- OMAGGI con iva a carico CLIENTE/AZIENDA"+CHR(13)+"- Articoli STADARD (SENZA OMAGGI)"+CHR(13)+"Impossibile confermare l'aggiornamento",64,"*** ATTENZIONE ***") 
	 	RETURN (.F.)
   ENDIF 


   SELECT U_FAT_TT
   SKIP +1

ENDDO


RETURN .T.


***********************************************
FUNCTION DESCRIZIONE_AUTOMATICA
***********************************************
LPARAMETERS _par_descr_standard,_par_codcli,_par_numfat,_par_datfat

DO CASE

	CASE PUB_PRDISP  && AZIENDA PRODUZIONE DISPOSITIVI MEDICALI
		_RIT = ALLTRIM(CERCA_CLI(ALLTRIM(_par_codcli),15)) + " N.F:" + ALLTRIM(_par_numfat) + " DEL " + IIF(SUBSTR(_par_datfat,3,1)='/',_par_datfat,RIBALTA2(_par_datfat))
		
	OTHERWISE
		_RIT = ALLTRIM(_par_descr_standard)

ENDCASE

RETURN _RIT

ENDFUNC