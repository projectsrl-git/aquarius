NUMPRO=TAGGANCIO
SELECT CU_FAP_DD


RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	



RELEASE ___CALCOLA_SOLO_RA
PUBLIC ___CALCOLA_SOLO_RA
___CALCOLA_SOLO_RA = .F.


RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ""
DOC_CAMBIO = 0


RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.

RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0



DO STAMPAMOD

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = 'ITA'"
x_tipo = "tipo_doc = 'OR'"
x_cond = x_soci + " and " + x_nazi + " and " + x_tipo
Csql   = "select * from lingue where " + x_cond + " order by codsoc,cod_naz,tipo_doc"
IF !ExecCommand(cSql,"CUR_LINGUE")
   return(.f.)
ENDIF
SELECT CUR_LINGUE
GO TOP
IF EOF()
   =MESSAGEBOX("Non trovo il codice nazione selezionato su"+CHR(13)+;
               "anagrafica lingue da stampare",62,"ATTENZIONE")
   SCATTER MEMVAR MEMO BLANK
ELSE
   SCATTER MEMVAR MEMO
ENDIF

SELECT CU_FAP_DD

ANCORA = 1


*** DISAMBIGUAZIONE NOME FILE PER MULTIUTENZA
_FILEPDF = "C:\FAP-n-" + TOGLI_CARATTERI_SPECIALI(ALLTRIM(V_NUMFAT)) + "-del-" + STRTRAN(RIBALTA2(V_DATA),'/','-') + "-" + TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(V_RAGSOC,1,35))) + ".EXP"


*** PERSONALIZZAZIONE DOCUMENTI
_PAR_CUSTOM_REPORT_=CERCA_REPORT_PERSONALIZZATO("FAP")	&& VERIFICA SE ESISTE UN REPORT PERSONALIZZATO

*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"FAP",M.TAGGANCIO,"CHECK")
	SELECT CU_FAP_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF
*** PERSONALIZZAZIONE DOCUMENTI


IF !EMPTY(ALLTRIM(_PAR_CUSTOM_REPORT_))			&& GESTIONE REPORT PERSONALIZZATO
    PUB_NON_CERCARE_IL_REPORT_USA_QUELLO_CHE_TI_DICO_IO = .T.
	DO PRG\MENUSTA1 WITH "CU_FAP_DD",.t.,.T.,"XXX","FAPPJEUR",_PAR_CUSTOM_REPORT_,.F.,_FILEPDF
	PUB_NON_CERCARE_IL_REPORT_USA_QUELLO_CHE_TI_DICO_IO = .F.
ELSE
	*=> Gestione stampa con e-mail 
	DO PRG\MENUSTA1 WITH "CU_FAP_DD",.t.,.T.,"XXX","FAPPJEUR","FAPPJEUR.FRX",.F.,_FILEPDF
ENDIF 




SELECT CU_FAP_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI

RETURN


*****************************
PROCEDURE STAMPAMOD
*****************************

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
  (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))


**=> ERASMO - INIZIO 30/01/2015
RELEASE V_CONSEGNATO
PUBLIC V_CONSEGNATO
V_CONSEGNATO = ""
**=> ERASMO - FINE 30/01/2015


RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""


RELEASE SAY_IVA_SPESE_TRASPORTO,V_IVASPTRAS
PUBLIC SAY_IVA_SPESE_TRASPORTO,V_IVASPTRAS
SAY_IVA_SPESE_TRASPORTO = ""
V_IVASPTRAS = ""

RELEASE V_ACURA
PUBLIC  V_ACURA
V_ACURA = ''

RELEASE V_PIVA_CEE
RELEASE V_CODNAZ,FATSOSIVA
RELEASE V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 

PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
PUBLIC V_CODNAZ,FATSOSIVA

V_NUMLEI = SPACE(10)
V_DATLEI = SPACE(10)
V_NUCONS = SPACE(10)
V_DTCONS = SPACE(10)


RELEASE V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT_EUR,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU
RELEASE V_FERIE,NOTAC,X_RIDE


PUBLIC V_PIVA_CEE
PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT_EUR,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU
PUBLIC V_FERIE,NOTAC,X_RIDE

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO


RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC


V_PIVA_CEE = ''
IS1 = 0
IS2 = 0
IS3 = 0
IS4 = 0
IS5 = 0

DS1 = SPACE(10)
DS2 = SPACE(10)
DS3 = SPACE(10)
DS4 = SPACE(10)
DS5 = SPACE(10)

V_INTESTA = ""
V_CONSEGNATO = ""  && ERASMO - 30/01/2015
V_RAGSOC  = SPACE(40)
V_INDIRI  = SPACE(40)
V_CAP     = SPACE(10)
V_LOCALI  = SPACE(30)
V_CODCLI  = SPACE(13)
V_PIVA    = SPACE(20)
V_VSRIF   = SPACE(30)
V_NSRIF   = SPACE(30)
V_PAG     = SPACE(3)
V_DATA    = SPACE(10)
V_BANCA   = SPACE(15)
V_CPAG	  = SPACE(40)
V_BANAP   = SPACE(30)
V_NUMFAT  = SPACE(10)
V_DESCAU  = "FATTURA PROFORMA"
NOTAC     = " "
X_RIDE    = " "  && ERASMO - 25/10/2017
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)


**=> ERASMO - INIZIO 30/01/2015
V_RAGSOC_CON  	= ""
V_RAGDUE_CON  	= ""
V_INDIR_CON   	= ""
V_CAP_CON     	= ""    
V_LOCALI_CON  	= "" 
V_PROVIN_CON  	= ""
V_NAZION_CON  	= ""
V_PARIVA_CON  	= ""
V_CODFIS_CON  	= "" 
V_IVACEE_CON  	= ""
**=> ERASMO - FINE 30/01/2015


V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_FATT  = 0
TOT_FATT_EUR = 0

IMPO1     = 0
IMPO2     = 0
IMPO3     = 0
IMPO4     = 0
IMPO5     = 0

IVA1      = SPACE(3)
IVA2      = SPACE(3)
IVA3      = SPACE(3)
IVA4      = SPACE(3)
IVA5      = SPACE(3)

DIVA1     = SPACE(25)
DIVA2     = SPACE(25)
DIVA3     = SPACE(25)
DIVA4     = SPACE(25)
DIVA5     = SPACE(25)

PIVA1     = SPACE(3)
PIVA2     = SPACE(3)
PIVA3     = SPACE(3)
PIVA4     = SPACE(3)
PIVA5     = SPACE(3)

IMPOS1    = 0
IMPOS2    = 0
IMPOS3    = 0
IMPOS4    = 0
IMPOS5    = 0

PUBLIC VTOTIMP,VTOTIVA,VTOTDOC
VTOTIMP=0
VTOTIVA=0
VTOTDOC=0
MATPUB =0   && MATERIALE PUBBLICITARIO

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0


SELECT CU_FAP_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""  && ERASMO - 30/01/2015

v_seek	 = FAP_RECNO
v_chiave = "taggancio"
IF seek_std('u_FAP_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO
   V_NUMFAT = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP  

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   **=> ERASMO - INIZIO 30/01/2015
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   **=> ERASMO - FINE 30/01/2015
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015
   
   V_VETTO  = M.ORD_VETTO
   V_PORTO  = M.ORD_PORTO
   
   V_NUMORC = M.ORD_NUMORC	
   V_DATORC = M.ORD_DATORC	
   V_NUMOFC = M.ORD_NUMOFC	
   V_DATOFC = M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC   	
   V_NUMCOC = M.ORD_NUMCOC	
   V_DATCOC = M.ORD_DATCOC	
   
   V_MERCRE = M.ORD_MERCRE
   V_VALUTA = M.ORD_VALUTA
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = (M.ORD_DATORD)
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   V_NAZION = ""   
   V_ACURA  = M.ORD_ACURA
      
   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA
   ___CALCOLA_SOLO_RA 		= M.T_NORA
   


   
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi   
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF EOF()
   ELSE
     V_RAGDUE    = CLI_RAGDUE
     
     IF ___CALCOLA_SOLO_RA

	     _RAPERC     = CLI_RA
	     _ENPACLPERC = 0     
    

     ELSE
     
		 IF ___NON_CALCOLA_RA_ENPACL 
		   	  _RAPERC     = 0
		      _ENPACLPERC = 0   
		 ELSE
		     _RAPERC     = CLI_RA
		     _ENPACLPERC = CLI_ENPACL     
	     ENDIF

     ENDIF     
     
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF
   V_INTESTA=V_RAGSOC+CHR(13)
   IF !EMPTY(V_RAGDUE)
      V_INTESTA=V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGTRE)
      V_INTESTA=V_INTESTA+V_RAGTRE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGQUA)
      V_INTESTA=V_INTESTA+V_RAGQUA+CHR(13)
   ENDIF
   V_PROVIN = M.ORD_PROVIN
   V_INTESTA    = V_INTESTA+ALLTRIM(V_INDIRI)+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+ALLTRIM(V_PROVIN)+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      *IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0 OR !PUB_NOSTPNAZ  && ERASMO - 13/03/2015
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
   ENDIF

   **=> ERASMO - INIZIO 30/01/2015
   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
   *V_NAZION_CON = V_NAZION  && ERASMO - 13/03/2015
   V_NAZION_CON = IIF(!EMPTY(V_NAZION_CON),ALLTRIM(V_NAZION_CON),ALLTRIM(V_NAZION))  && ERASMO - 20/03/2015
   IF EMPTY(ALLTRIM(V_RAGSOC_CON))
   		V_CONSEGNATO = ""
   ELSE
	   V_CONSEGNATO = V_RAGSOC_CON+CHR(13)
	   IF !EMPTY(ALLTRIM(V_RAGDUE_CON))
	      V_CONSEGNATO = V_CONSEGNATO+V_RAGDUE_CON+CHR(13)
	   ENDIF
	   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)
	   V_CONSEGNATO = V_CONSEGNATO+V_INDIRI_CON+CHR(13)+V_CAP_CON+" "+V_LOCALI_CON+ IIF(!EMPTY(V_PROVIN_CON)," ("+V_PROVIN_CON+")","")

	   IF ALLTRIM(UPPER(V_NAZION_CON)) <> 'ITALIA' AND !EMPTY(V_NAZION_CON)
	      *IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0 OR !PUB_NOSTPNAZ  && ERASMO - 13/03/2015
	         V_CONSEGNATO = V_CONSEGNATO + CHR(13) + V_NAZION_CON
	      ENDIF
	   ENDIF
   ENDIF
   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
   **=> ERASMO - FINE 30/01/2015

ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NUMFAT = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP  
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO
   
   **=> ERASMO - INIZIO 30/01/2015
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   **=> ERASMO - FINE 30/01/2015
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015
        
   V_VETTO  = M.ORD_VETTO
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
   V_ACURA  = M.ORD_ACURA
   
   V_NUMORC = M.ORD_NUMORC	
   V_DATORC = M.ORD_DATORC	
   V_NUMOFC = M.ORD_NUMOFC	
   V_DATOFC = M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC   	
   V_NUMCOC = M.ORD_NUMCOC	
   V_DATCOC = M.ORD_DATCOC	
   
   V_MERCRE = M.ORD_MERCRE
   V_NSRIF  = M.ORD_RIFERI
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   
   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA
   ___CALCOLA_SOLO_RA 		= M.T_NORA

   
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi   
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF EOF()
   ELSE
     V_RAGDUE = CLI_RAGDUE
     
     IF ___CALCOLA_SOLO_RA 	 

		     _RAPERC     = CLI_RA
		     _ENPACLPERC = 0  
		     
	 ELSE
	 
		 IF ___NON_CALCOLA_RA_ENPACL 
		   	  _RAPERC     = 0
		      _ENPACLPERC = 0   
		 ELSE
		     _RAPERC     = CLI_RA
		     _ENPACLPERC = CLI_ENPACL     
	     ENDIF   
	     
     ENDIF
     
     
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
    ENDIF
   V_INTESTA=V_RAGSOC+CHR(13)
   IF !EMPTY(V_RAGDUE)
      V_INTESTA=V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGTRE)
      V_INTESTA=V_INTESTA+V_RAGTRE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGQUA)
      V_INTESTA=V_INTESTA+V_RAGQUA+CHR(13)
   ENDIF
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI
   V_PROVIN = M.ORD_PROVIN
   V_INTESTA    = ALLTRIM(V_INTESTA)+ALLTRIM(V_INDIRI)+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+ALLTRIM(V_PROVIN)+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      *IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0 OR !PUB_NOSTPNAZ  && ERASMO - 13/03/2015
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
   ENDIF

   **=> ERASMO - INIZIO 30/01/2015
   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
   *V_NAZION_CON = V_NAZION  && ERASMO - 13/03/2015
   V_NAZION_CON = IIF(!EMPTY(V_NAZION_CON),ALLTRIM(V_NAZION_CON),ALLTRIM(V_NAZION))  && ERASMO - 20/03/2015
   IF EMPTY(ALLTRIM(V_RAGSOC_CON))
   		V_CONSEGNATO = ""
   ELSE
	   V_CONSEGNATO = V_RAGSOC_CON+CHR(13)
	   IF !EMPTY(ALLTRIM(V_RAGDUE_CON))
	      V_CONSEGNATO = V_CONSEGNATO+V_RAGDUE_CON+CHR(13)
	   ENDIF
	   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)
	   V_CONSEGNATO = V_CONSEGNATO+V_INDIRI_CON+CHR(13)+V_CAP_CON+" "+V_LOCALI_CON+ IIF(!EMPTY(V_PROVIN_CON)," ("+V_PROVIN_CON+")","")

	   IF ALLTRIM(UPPER(V_NAZION_CON)) <> 'ITALIA' AND !EMPTY(V_NAZION_CON)
	      *IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0 OR !PUB_NOSTPNAZ  && ERASMO - 13/03/2015
	         V_CONSEGNATO = V_CONSEGNATO + CHR(13) + V_NAZION_CON
	      ENDIF
	   ENDIF
   ENDIF
   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
   **=> ERASMO - FINE 30/01/2015


ENDIF

RELEASE V_BANFORN,V_IBANCLI,V_IBANFOR,V_BICSWIFT
PUBLIC  V_BANFORN,V_IBANCLI,V_IBANFOR,V_BICSWIFT
V_BANFORN  = SPACE(05)
V_IBANCLI  = SPACE(27)
V_IBANFOR  = SPACE(27)
V_BICSWIFT = SPACE(100)

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cliente")
   return(.f.)
ENDIF
SELECT cur_cliente
GO TOP
IF !EOF()
   V_BANFORN  		= CLI_BAEFOR
   V_IBANFOR  		= CLI_IBAFOR
   V_CODICE_SWIFT 	= CLI_BSWFOR	
   V_IBANCLI  		= CLI_CDIBAN
   V_BICSWIFT 		= CLI_BSWFOR
   V_CFISC    		= CLI_CODFIS
   V_PIVA     		= CLI_PARIVA
   V_CODNAZ   		= CLI_NAZION  
   V_PIVA_CEE 		= CLI_IVACEE  
   V_ALRID    		= CLI_ALRID
   IF EMPTY(V_PIVA)
      V_PIVA  = CLI_IVACEE
   ENDIF
   IF EMPTY(V_PIVA)
      V_PIVA  = ALLTRIM(CLI_CODFIS)
   ENDIF
ELSE
   V_CFISC 			= " "
   V_PIVA  			= SPACE(11)
   V_ALRID 			= SPACE(03)
   V_BANFORN  		= ""
   V_IBANFOR  		= ""
   V_IBANCLI  		= ""
   V_BICSWIFT 		= ""
   V_CODNAZ   		= ""
   V_PIVA_CEE 		= ""
   V_PIVA     		= ""
   V_CODICE_SWIFT 	= ""
ENDIF

v_seek 	 = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = DESCRI
ELSE
   V_VETTO = ""
ENDIF

v_seek 	 = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_PORTO = ALLTRIM(DESCRI)
    V_PORTO   = DESCRI
    * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
	DL_TIPODES 		= 'CODI.PORTO'
	DL_CODICE  		= V_PORTO
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	IF !EMPTY(_DESCR_LINGUA)
		SAY_PORTO   = _DESCR_LINGUA    
		V_PORTO     = _DESCR_LINGUA  
	ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
    V_PORTO   = ""
    SAY_PORTO = ""
ENDIF

v_seek   = 'MEZ'+V_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    V_ACURA=SUBSTR(DESCRI,1,30)
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
	DL_TIPODES 		= 'MEZZI.CONS'
	DL_CODICE  		= V_ACURA
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	IF !EMPTY(_DESCR_LINGUA)
		V_ACURA     = _DESCR_LINGUA    
	ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
    V_ACURA=""
ENDIF


v_seek 	 = 'CDC'+V_CDC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CDC = ALLTRIM(DESCRI)
   V_CDC   = DESCRI
ELSE
   V_CDC   = ""
   SAY_CDC = ""
ENDIF

v_seek 	 = 'FAT000'                            && CHIUSURA PER FERIE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_FERIE = ALLTRIM(DESCRI)+ ' ' +ALLTRIM(LIBERA)
ELSE
   V_FERIE = ""
ENDIF


v_seek	= PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_ana_cl',v_seek,v_chiave,'CUR_ANA_CL')
   SELECT CUR_ANA_CL
   V_IVASPTRAS      = CLI_IVASPTRAS
ELSE
   V_IVASPTRAS      = ""
ENDIF


v_seek	= PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
   V_CFISC = CLI_CODFIS
   V_PIVA  = CLI_PARIVA
   V_ALRID = CLI_ALRID
   IF EMPTY(V_PIVA)
	  V_PIVA  = CLI_IVACEE
   ENDIF
   IF EMPTY(V_PIVA)
      V_PIVA  = ALLTRIM(CLI_CODFIS)
   ENDIF
ELSE
   V_CFISC = " "
   V_PIVA  = SPACE(11)
   V_ALRID = SPACE(03)
ENDIF

v_seek 	 = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= V_PAG
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
   ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
ELSE
   V_CPAG = SPACE(40)
   X_RIDE 	 = SPACE(01)
ENDIF

v_seek 	 = 'AGE'+ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
   IF "NESSUNO" $ V_DAGE
	  V_DAGE = SPACE(40)
   ENDIF
ELSE
   V_DAGE = SPACE(40)
ENDIF

v_seek 	 = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DPU = ALLTRIM(LIBERA)
ELSE
   DPU = ""
ENDIF

v_seek 	 = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU    = DESCRI
   NOTAC	   = SUBSTR(LIBERA,11,1)
   TI_PX       = SUBSTR(LIBERA,11,1)
   FATSOSIVA   = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
ELSE
   V_DESCAU = SPACE(40)
   NOTAC	   = " "
   TI_PX       = " "
   FATSOSIVA   = " "
ENDIF

* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
DL_TIPODES 		= 'CODICE-TOP'
DL_CODICE  		= ALLTRIM(V_TOP)
_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
IF !EMPTY(_DESCR_LINGUA)
	V_DESCAU    = _DESCR_LINGUA    
ENDIF
* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *


** 1) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DALLA BANCA DI APPOGGIO DEL CLIENTE 
**    ################################### SOLO PER RIMESSE DIRETTE

IF X_RIDE = 'S'
   IF EMPTY(V_BANCA)
      V_BANCA = V_BANFORN
   ENDIF   
   x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "ban_codban = '" + ALLTRIM(V_BANCA) + "'"   
   x_cond = x_soci + " and " + x_codi   
   cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
   IF !ExecCommand(cSql,"CUR_BANCA")
      RETURN .F.
   ENDIF
   SELECT CUR_BANCA
   GO TOP   
   IF EOF()
      V_BANAP = SPACE(100)
   ELSE
   	  __codice_swift = BAN_SWIFT	&& SIMONE - 21/10/2009

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
	  ELSE
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	  ENDIF

      IF EMPTY(ALLTRIM(__codice_swift)) 
      ELSE
         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(__codice_swift)
      ENDIF
   
   ENDIF
ELSE
   x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "ban_codban = '" + ALLTRIM(V_BANCA) + "'"
   x_cond = x_soci + " and " + x_codi   
   cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
   IF !ExecCommand(cSql,"CUR_BANCA")
      RETURN .F.
   ENDIF  
   SELECT CUR_BANCA
   GO TOP   
   IF EOF()
      V_BANAP = SPACE(40)
   ELSE

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
	  ELSE
	      *V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	      ** 2014/08/27 SERGIO NEL CASO NON ESISTA SULLA BANCA PRENDE IBAN PER LE RIBA DALL'ANAGRAFICA CLIENTE 
	      IF !EMPTY(V_IBANCLI)	
		      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
		      			'IBAN : '+ ALLTRIM(V_IBANCLI)	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA CLIENTI
	      ELSE 
	      	V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	      ENDIF 
	      ** 2014/08/27 SERGIO NEL CASO NON ESISTA SULLA BANCA PRENDE IBAN PER LE RIBA DALL'ANAGRAFICA CLIENTE 


	  ENDIF

   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF


** 2) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DIRETTAMENTE DALL'ANAGRAFICA CLIENTE
**    ################################### SOLO PER RIMESSE DIRETTE
**    SERGIO 2011_12_13 

*IF X_RIDE = 'S'
IF X_RIDE = 'S' AND !('IBAN' $ V_BANAP)  && ERASMO/FABIANO - 12/07/2017
	IF !EMPTY(ALLTRIM(V_BANFORN))  
	   x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
	   x_codi = "ban_codban = '" + ALLTRIM(V_BANFORN) + "'"
	   x_cond = x_soci + " and " + x_codi   
	   cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
	   IF !ExecCommand(cSql,"CUR_BANCA")
	      RETURN .F.
	   ENDIF
	   SELECT CUR_BANCA
	   GO TOP   
	   IF EOF()
	      V_BANAP = SPACE(100)
	   ELSE
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(V_IBANFOR)	&& >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> IBAN BANCA NOSTRA DA ANAGRAFICA CLIENTE U_CLI_AN
	      IF EMPTY(ALLTRIM(V_CODICE_SWIFT)) 
	      ELSE
	         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_CODICE_SWIFT)
	      ENDIF
	   ENDIF
	ENDIF
ENDIF   

**=> ERASMO - INIZIO 28/10/2024
RELEASE V_BANSOC
PUBLIC V_BANSOC
V_BANSOC = ""
V_BANCAX = V_BANFORN
x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
x_codi = "ban_codban = '" + ALLTRIM(V_BANCAX) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
IF !ExecCommand(cSql,"CUR_BANCA")
   RETURN .F.
ENDIF
SELECT CUR_BANCA
GO TOP   
IF EOF()
   V_BANSOC = ''
ELSE
   V_BANSOC = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
   			'IBAN : '+ ALLTRIM(BAN_IBAN)
ENDIF
IF ALLTRIM(V_BANSOC)="."
   V_BANSOC=''
ENDIF
**=> ERASMO - FINE 28/10/2024

SELECT CU_FAP_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("FAP",ORD_CODICE)
         SELECT CU_FAP_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP +1
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)

   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("CU_FAP_DD")

   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE
	   v_seek 	 = 'IVA'+COD_IVA
	   v_chiave  = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   ENDIF
   
   SELECT CU_FAP_DD								&& 2015/02/23 SERGIO - ALTRO BACONE : SI PERDE LA SELECT E CALCOLA MALE IMPOSTA

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
  
   ELSE

        IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
   
   ENDIF
   
   IF ((IVA1 = SPACE(3)) .OR. (IVA1 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
      IVA1   = COD_IVA
      IMPO1  = IMPO1+IMPONIB
      IMPOS1 = IMPOS1 + IMPOSTA
   ELSE
      IF ((IVA2 = SPACE(3)) .OR. (IVA2 = COD_IVA))  .AND. (DES_ART <> ('*** COMMENTO ***'))
         IVA2   = COD_IVA
         IMPO2  = IMPO2+IMPONIB
         IMPOS2 = IMPOS2 + IMPOSTA
      ELSE
         IF ((IVA3 = SPACE(3)) .OR. (IVA3 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
            IVA3   = COD_IVA
            IMPO3  = IMPO3+IMPONIB
            IMPOS3 = IMPOS3 + IMPOSTA
         ELSE
            IF ((IVA4 = SPACE(3)) .OR. (IVA4 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
               IVA4   = COD_IVA
               IMPO4  = IMPO4+IMPONIB
               IMPOS4 = IMPOS4 + IMPOSTA
            ELSE
               IF ((IVA5 = SPACE(3)) .OR. (IVA5 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
                  IVA5   = COD_IVA
                  IMPO5  = IMPO5+IMPONIB
                  IMPOS5 = IMPOS5 + IMPOSTA
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   


   SELECT CU_FAP_DD
   SKIP +1

ENDDO

*** SOMMA SPESE DI TRASPORTO + INCASSO
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03


PUB_IVADEF = CERCA_IVA_DEFAULT("CU_FAP_DD","CODICE")   
PUB_ALIQ = CERCA_IVA_DEFAULT("CU_FAP_DD","ALIQUOTA")   


** VERIFICA CHE PERCENTUALE IVA ATTRIBUIRE AL COSTO DEL TRASPORTO :
** ----------------------------------------------------------------
** --- 1) SE CLIENTE IN ESENZIONE %PERCENTUALE IVA SUL TRASPORTO E' = 0
** --- 2) SE CLIENTE CON IVA NON IMPONIBILE (OSSIA PERCENTUALE ULTIMA ALIQUOTA IVA = 0) ANCHE LA %PERCENTUALE IVA SUL TRASPORTO E' = 0
** --- 3) SE CLIENTE CON IVA IMPONIBILE LA %PERCENTUALE IVA SUL TRASPORTO E' = ALLA %PERCENTUALE IVA DI DEFAULT STANDARD (SE CI SONO DIVERSE ALIQUOTE NE CONSIDERA UNA E NON LA MEDIA)

IF !EMPTY(V_ALRID)
   	V_IMPSP = 0		 							&& --- 1) SE CLIENTE IN ESENZIONE %PERCENTUALE IVA SUL TRASPORTO E' = 0
ELSE
	IF NUM_ALIQ = PUB_ALIQ						&& PERCENTUALE DELL'ULTIMA ALIQUOTA IVA PRESENTE NEGLI ARTICOLI
   		V_IMPSP = V_SPESE * (PUB_ALIQ/100)  	&& --- 3) SE CLIENTE CON IVA IMPONIBILE LA %PERCENTUALE IVA SUL TRASPORTO E' = ALLA %PERCENTUALE IVA DI DEFAULT STANDARD 
	ELSE
   		V_IMPSP = V_SPESE * (NUM_ALIQ/100)  	&& --- 2) SE CLIENTE CON IVA NON IMPONIBILE (OSSIA PERCENTUALE ULTIMA ALIQUOTA IVA = 0) ANCHE LA %PERCENTUALE IVA SUL TRASPORTO E' = 0 
	ENDIF
ENDIF



** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *
PIVA1TRA = ""
DIVA_SPESE_TRASPORTO = ""
SAY_IVA_SPESE_TRASPORTO = ""
ALIQTRA = ""
IF !EMPTY(V_IVASPTRAS)
	v_seek 	  = 'IVA'+V_IVASPTRAS
	v_chiave  = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   PIVA1TRA	= SUBSTR(LIBERA,1,03)
	   DIVA_SPESE_TRASPORTO	= ALLTRIM(SUBSTR(DESCRI,1,80))
	   SAY_IVA_SPESE_TRASPORTO = DIVA_SPESE_TRASPORTO
       ALIQTRA 	= SUBSTR(LIBERA,1,3)
       NUM_ALIQ = VAL(ALIQTRA)
	   * -------------------------------------------------------------------------- descrizioni in lingua ----------- 'IVA' ---------- *
		DL_TIPODES 		= 'IVA'
		DL_CODICE  		= V_IVASPTRAS
		_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	    IF !EMPTY(_DESCR_LINGUA)
			DIVA_SPESE_TRASPORTO  = _DESCR_LINGUA
		    SAY_IVA_SPESE_TRASPORTO = _DESCR_LINGUA
	    ENDIF
	   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
    ELSE
       ALIQTRA  = ""
       NUM_ALIQ = 0
       SAY_IVA_SPESE_TRASPORTO = ""
	ENDIF

    V_IMPSP = V_SPESE * (NUM_ALIQ/100)

ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *


NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

NUM_ALIQ_ENPACL 	= 0

v_seek 	  = 'IVA'+IVA1
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   NUM_ALIQ_ENPACL 	= VAL(PIVA1)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA1
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA1  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA1 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
	  ACCO_IVA = .T.
      IMPO1    = IMPO1	+ V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA2
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)   
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA2
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA2  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA2 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
	  ACCO_IVA = .T.
      IMPO2    = IMPO2	+ V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA3
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA3
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA3  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA3 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
	  ACCO_IVA = .T.
      IMPO3    = IMPO3	+ V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA4
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA4
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA4  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA4 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
	  ACCO_IVA = .T.
      IMPO4    = IMPO4	+ V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA5
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA5
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA5  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA5 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
	  ACCO_IVA = .T.
      IMPO5    = IMPO5	+ V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *
IF !EMPTY(V_IVASPTRAS)

	IF V_SPESE <> 0									&& GESTIONE SOLO SE ESISTONO SPESE+SPESE DI TRASPORTO

	    DO CASE 
	    	CASE EMPTY(IVA1)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA1 		= ALLTRIM(ALIQTRA)	    && ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA1  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO1  		= IMPO1	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS1 		= IMPOS1 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA2)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA2 		= ALLTRIM(ALIQTRA)      && ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA2  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO2  		= IMPO2	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS2 		= IMPOS2 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA3)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA3 		= ALLTRIM(ALIQTRA)	    && ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA3  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO3  		= IMPO3	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS3 		= IMPOS3 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA4)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA4 		= ALLTRIM(ALIQTRA)	    && ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA4  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO4  		= IMPO4	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS4 		= IMPOS4 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA5)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA5 		= ALLTRIM(ALIQTRA)	    && ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA5  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO5  		= IMPO5	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS5 		= IMPOS5 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    ENDCASE
	    
	ENDIF
	
ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *



IF !ACCO_IVA    && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek 	  = 'IVA'+IVA1
   v_chiave  = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
       SELECT CUR_PARA
	   PIVA1  = SUBSTR(LIBERA,1,03)
	   DIVA1  = SUBSTR(DESCRI,1,25)
       IMPO1  = IMPO1+V_SPESE
	   IMPOS1 = IMPOS1 + V_IMPSP
	   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
		DL_TIPODES 		= 'IVA'
		DL_CODICE  		= IVA1
		_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	    IF !EMPTY(_DESCR_LINGUA)
			DIVA1  = _DESCR_LINGUA
	    ENDIF
	   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   ENDIF
ENDIF

TOT_IMPO = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	TOT_IMPO = TOT_IMPO + V_SPINCA  && ADESSO POSSO SOMMARE LE SPESE DI INCASSO IN QUANTO SONO ESENTI DA IVA E NON SI DEVE CALCOLARE L'IVA SULLE SPESE DI INCASSO
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03


IF TOT_IMPO < 0        && SOLO MATERIALE PUBBLICITARIO
   TOT_IMPO = TOT_IMPO * -1
ENDIF

**=> ERASMO/SERGIO - INIZIO 09/05/2018
IF ___CALCOLA_SOLO_RA
ELSE
	*!*	CALCOLO ENPACL
	IF _ENPACLPERC <> 0
		T_ENPACL 		= ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
		TOT_IMPO 		= TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
		IMPO1    		= IMPO1 + T_ENPACL
		_IVA_ENPACL 	= (T_ENPACL * NUM_ALIQ_ENPACL) / 100
		IMPOS1			= IMPOS1 + _IVA_ENPACL
	ENDIF
ENDIF 
**=> ERASMO/SERGIO - FINE 09/05/2018

**--> ARROTONDAMENTO IVA

IMPOS1		=	ROUND((IMPOS1+.0000),2)
IMPOS2		=	ROUND((IMPOS2+.0000),2)
IMPOS3		=	ROUND((IMPOS3+.0000),2)
IMPOS4		=	ROUND((IMPOS4+.0000),2)		
IMPOS5		=	ROUND((IMPOS5+.0000),2)
TOT_IMPOS   =   IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5
TOT_FATT    =   TOT_IMPO + TOT_IMPOS - MATPUB
TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)



IF ___CALCOLA_SOLO_RA

	T_ENPACL = 0

	*!*	CALCOLO FATTURA CON RA
	IF _RAPERC   <> 0
		T_RA 			= ROUND((TOT_IMPO * _RAPERC   ) / 100,2)
		T_NETTO 		= TOT_FATT - T_RA
		TOT_FATT    	= T_NETTO 
		TOT_FATT_EUR 	= CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
	ENDIF


ELSE

*!*		*!*	CALCOLO ENPACL
*!*		IF _ENPACLPERC <> 0
*!*			T_ENPACL 		= ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
*!*			TOT_IMPO 		= TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
*!*			IMPO1    		= IMPO1 + T_ENPACL
*!*			_IVA_ENPACL 	= (T_ENPACL * NUM_ALIQ_ENPACL) / 100
*!*			_IVA_ENPACL		=  ROUND((_IVA_ENPACL+.0000),2)
*!*			TOT_IMPOS   	= TOT_IMPOS + _IVA_ENPACL
*!*			IMPOS1			= IMPOS1 + _IVA_ENPACL
*!*			TOT_FATT    	= TOT_FATT  + T_ENPACL + _IVA_ENPACL && SOMMO A TOTALE DOCUMENTO IL CONTRIBUTO DEL 2% ENPACL + RELATIVA IVA
*!*			TOT_FATT_EUR 	= CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
*!*		ENDIF

	*!*	CALCOLO RA
	IF _RAPERC   <> 0
		_IMPONIBILE_NO_ENPACL 	= ( TOT_IMPO - T_ENPACL )
		T_RA 					= ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
		T_NETTO 				= TOT_FATT - T_RA
	ENDIF

ENDIF 



*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT CU_FAP_DD
      APPEND BLANK
      m.ord_codart = SPACE(16)
      M.ORD_MAGA   = SPACE(06)
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = SPACE(25)
      M.ORD_UM	   = SPACE(02)
      M.ORD_IVA	   = SPACE(02)
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = SPACE(10)
      M.ORD_PUBBLI = " "
      GATHER MEMVAR MEMO
      APPEND BLANK
      m.ord_codart = SPACE(16)
      M.ORD_MAGA   = SPACE(06)
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = SPACE(25)
      M.ORD_UM	   = SPACE(02)
      M.ORD_IVA	   = SPACE(02)
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = SPACE(10)
      M.ORD_PUBBLI = " "
      GATHER MEMVAR MEMO
      APPEND BLANK
      m.ord_codart = SPACE(16)
      M.ORD_MAGA   = SPACE(06)
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = SPACE(25)
      M.ORD_UM	   = SPACE(02)
      M.ORD_IVA	   = SPACE(02)
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = V_FERIE
      M.ORD_PUBBLI = " "
      GATHER MEMVAR MEMO
   ENDIF
ENDIF

SELECT CU_FAP_DD
APPEND BLANK
REPLACE DAGGANCIO  WITH 'EOF'
REPLACE ORD_SEQUEN WITH 99999
GO TOP

***==>  CREA TRANCHE 

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
IF EOF()
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno    
ELSE
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL			&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno      
ENDIF

SELECT CU_FAP_DD
GO TOP

RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_FATT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS  

V_DATASCAD = V_DATA
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)

=CREA_SCADENZE()

*** SE CONDIZIONE DI PAGAMENTO SPECIALE, A SECONDA DEL VALORE DI PUB_SSPORD:
*** 1 - RIGENERA IL COMMENTO CON I RIFERIMENTI ALLE SCADENZE SPECIALI
*** 2 - RIPORTA RIFERIMENTI ALLE SCADENZE SPECIALI NEI VETTORI RELATIVI ALLA GESTIONE DELLE SCADENZE
IF checkConSpe(V_PAG)
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"CU_FAP_DD",.F.)
ENDIF

RETURN


*************************
PROCEDURE PERIODI
*************************

CONTA_TRA = 0

** RICERCA IMPORTO TRANCHE

IS        = 0
XPAROLA   = ''

DO PAROLA

IMP_TRANK = VAL(XPAROLA)

DO WHILE .T.

   CONTA_TRA = CONTA_TRA + 1

   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
   IF CONTA_TRA > CNT
      RETURN
   ENDIF

   IF CONTA_TRA = CNT
      IMP_TRANK = IMP_TRANK + COMPENSO
   ENDIF

   ** RICERCA DATA SCADENZA

   XPAROLA = ''
 
   DO PAROLA
 
   DATA_SCAD=XPAROLA

   DO CREA_PERI

ENDDO

RETURN


*************************
PROCEDURE PAROLA
*************************

DO WHILE .T.

   IS     = IS + 1
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

SELECT PERIODI
APPEND BLANK
REPLACE IMP_SCAD  WITH IMP_TRANK
REPLACE NUM_TRAN  WITH CONTA_TRA
REPLACE DSCAD     WITH DATA_SCAD

RETURN


*************************
PROCEDURE VAR_PERI
*************************

PUBLIC ARRAY DATA(7)
PUBLIC ARRAY IMPORTO(7)

I = 0
SELECT PERIODI
GO TOP

DO WHILE (!EOF()) .AND. (I < 7)

   I = I + 1

   DATA[I]     = DSCAD
   IMPORTO[I]  = IMP_SCAD

   SELECT PERIODI

   SKIP +1

ENDDO

I = I + 1

FOR HH = I TO 7

   DATA[HH]     = SPACE(10)
   IMPORTO[HH]  = 0

NEXT

RETURN


*************************
PROCEDURE CLEAR_VAR
*************************

IMPO1     = 0
IMPO2     = 0
IMPO3     = 0
IMPO4     = 0
IMPO5     = 0

IVA1      = SPACE(3)
IVA2      = SPACE(3)
IVA3      = SPACE(3)
IVA4      = SPACE(3)
IVA5      = SPACE(3)

IMPOS1    = 0
IMPOS2    = 0
IMPOS3    = 0
IMPOS4    = 0
IMPOS5    = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_FATT  = 0
TOT_FATT_EUR = 0

CREATE CURSOR PERIODI;
  (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_SPINCA  = 0
V_SPTRAS  = 0
NETTO     = 0
MATPUB    = 0

RETURN


*************************
PROCEDURE RILA_VAR
*************************

RELEASE V_INTESTA
RELEASE V_RAGSOC
RELEASE V_INDIRI
RELEASE V_CAP
RELEASE V_LOCALI
RELEASE V_CODCLI
RELEASE V_PIVA
RELEASE V_VSRIF
RELEASE V_NSRIF
RELEASE V_PAG
RELEASE V_DATA
RELEASE V_BANCA
RELEASE V_CPAG
RELEASE V_BANAP
RELEASE V_NUMFAT
RELEASE V_DESCAU

RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_FATT
RELEASE TOT_FATT_EUR


RELEASE IMPO1
RELEASE IMPO2
RELEASE IMPO3
RELEASE IMPO4
RELEASE IMPO5

RELEASE IVA1
RELEASE IVA2
RELEASE IVA3
RELEASE IVA4
RELEASE IVA5

RELEASE IMPOS1
RELEASE IMPOS2
RELEASE IMPOS3
RELEASE IMPOS4
RELEASE IMPOS5

RELEASE VTOTIMP
RELEASE VTOTIVA
RELEASE VTOTDOC

RELEASE DAGGA
RELEASE V_TOP
RELEASE V_INTESTA

RELEASE V_CFISC
RELEASE V_CAGE
RELEASE V_DAGE
RELEASE V_VALUTA
RELEASE V_SPINCA
RELEASE V_SPTRAS
RELEASE NETTO
RELEASE MATPUB
RELEASE V_FERIE
RELEASE DPU
RELEASE V_CIG,V_CUP

**=> ERASMO - INIZIO 30/01/2015
RELEASE V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
RELEASE V_CONSEGNATO
**=> ERASMO - FINE 30/01/2015


RETURN
