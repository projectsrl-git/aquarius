NUMPRO=TAGGANCIO

RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	


RELEASE X_VENROT
PUBLIC  X_VENROT
X_VENROT = .F.


V_RIGA1 = SPACE(20)
V_RIGA2 = SPACE(20)
V_RIGA3 = SPACE(20)

v_seek   = "DTE_R1"+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_RIGA1=ALLTRIM(DESCRI)
   V_RIGA2=ALLTRIM(LIBERA)
ENDIF

v_seek   = "DTE_R2"+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_RIGA3=ALLTRIM(LIBERA)
ENDIF


_CODNAZ = ""

RELEASE TIT1,TIT2,TIT3,TIT4,TIT5,TIT6,TIT7,TIT8,TIT9
PUBLIC  TIT1,TIT2,TIT3,TIT4,TIT5,TIT6,TIT7,TIT8,TIT9
_CODNAZ = "ITA"
TIT1="C.ART."
TIT2="DESCRIZIONE ARTICOLO"
TIT3="UM"
TIT4="QTA"            
TIT5="PREZZO"
TIT6="VALORE"
TIT7="PAG."
TIT8="DT.CONS"
TIT9="SCONTI"

ANCORA = 1

v_seek   = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+"-"+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF


SELECT CU_ORF_DD

DO STAMPAMOD

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = 'ITA'"
x_tipo = "tipo_doc = 'FO'"
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

SELECT CU_ORF_DD
GO TOP



ANCORA = 1


*** DISAMBIGUAZIONE NOME FILE PER MULTIUTENZA
_FILEPDF = "C:\ORF-n-" + TOGLI_CARATTERI_SPECIALI(ALLTRIM(V_NUMORD)) + "-del-" + STRTRAN(RIBALTA2(V_DATA),'/','-') + "-" + TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(V_RAGSOC,1,35))) + ".EXP"


*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("F",M.ORD_CODCLI,"ORF",M.TAGGANCIO,"CHECK")
	SELECT CU_ORF_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF

*DO PRG\MENUSTA1 WITH "CU_ORF_DD",.t.,.T.,"XXX","ORFPJEUR","ORFPJEUR.FRX",.F.,_FILEPDF,.T.

**=> ERASMO - INIZIO 18/02/2025
*** PERSONALIZZAZIONE DOCUMENTI
_PAR_CUSTOM_REPORT_=CERCA_REPORT_PERSONALIZZATO("ORF","F")	&& VERIFICA SE ESISTE UN REPORT PERSONALIZZATO

IF !EMPTY(ALLTRIM(_PAR_CUSTOM_REPORT_))			&& GESTIONE REPORT PERSONALIZZATO
    PUB_NON_CERCARE_IL_REPORT_USA_QUELLO_CHE_TI_DICO_IO = .T.
	DO PRG\MENUSTA1 WITH "CU_ORF_DD",.t.,.T.,"XXX","ORFPJEUR",_PAR_CUSTOM_REPORT_,.F.,_FILEPDF,.T.
	PUB_NON_CERCARE_IL_REPORT_USA_QUELLO_CHE_TI_DICO_IO = .F.
ELSE
	DO PRG\MENUSTA1 WITH "CU_ORF_DD",.t.,.T.,"XXX","ORFPJEUR","ORFPJEUR.FRX",.F.,_FILEPDF,.T.
ENDIF
**=> ERASMO - FINE 18/02/2025

SELECT CU_ORF_DD
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

**-----------------------------------**
RELEASE V_BANCLIE
PUBLIC V_BANCLIE 
V_BANCLIE = ""
RELEASE V_CODICE,V_OPE
PUBLIC V_CODICE,V_OPE
V_CODICE = ""
V_OPE = ""
RELEASE V_TEL,V_FAX   
PUBLIC V_TEL,V_FAX   
V_TEL   = SPACE(12)
V_FAX   = SPACE(12)
RELEASE M.ORD_SC4,M.ORD_SC5    
PUBLIC M.ORD_SC4,M.ORD_SC5 
M.ORD_SC4    = 0	
M.ORD_SC5    = 0	

RELEASE V_DESTI
PUBLIC V_DESTI
V_DESTI = ""
**-----------------------------------**


RELEASE V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
PUBLIC V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON

RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
PUBLIC X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
RELEASE X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
PUBLIC X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES



X__FAX    = ""
X__COMUNI = ""
X__OGGETT = ""
X__COMMIS = ""
X__IMBALL = ""
X__GGCONS = ""
X__DESPES = ""
X__DESCPA = ""
X__NORME1 = ""
X__NORME2 = ""

X_ASPETT  = ""
X_VETTO   = ""
X_PORTO   = ""
X_ACURA   = ""
X_CCODES  = ""

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

RELEASE V_CONSEGNATO
PUBLIC V_CONSEGNATO
V_CONSEGNATO = ""

RELEASE V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 


RELEASE V_COSTTR
RELEASE V_BANSOC 
RELEASE V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,TOT_ORDT_EUR,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
RELEASE V_VETTO2,V_VETTO3  && ERASMO - 31/08/2022
RELEASE V_FERIE,NOTAC
RELEASE DOC_VALUTA,DOC_CAMBIO

RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC


PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
PUBLIC V_COSTTR
PUBLIC V_BANSOC 
PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,TOT_ORDT_EUR,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
PUBLIC V_VETTO2,V_VETTO3  && ERASMO - 31/08/2022
PUBLIC V_FERIE,NOTAC
PUBLIC DOC_VALUTA,DOC_CAMBIO

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

**=> ERASMO - INIZIO 01/12/2025
RELEASE SAY_ASPETT
PUBLIC SAY_ASPETT
**=> ERASMO - FINE 01/12/2025

V_COSTTR = 0


RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


RELEASE _CNT_PUBBLI,_CNT_ARTICOLI
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA


_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   


V_NUMLEI = SPACE(10)
V_DATLEI = SPACE(10)
V_NUCONS = SPACE(10)
V_DTCONS = SPACE(10)

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

V_INTESTA    = ""
V_CONSEGNATO = "" 
V_RAGSOC  = SPACE(40)
V_INDIRI  = SPACE(40)
V_CAP     = SPACE(10)
V_LOCALI  = SPACE(30)
V_CODCLI  = SPACE(13)
V_PIVA    = SPACE(20)

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


V_VSRIF   = SPACE(30)
V_NSRIF   = SPACE(30)
V_PAG     = SPACE(3)
V_DATA    = SPACE(10)
V_BANCA   = SPACE(15)
V_CPAG	  = SPACE(40)
V_BANAP   = SPACE(30)
V_BANSOC  = '' 
V_NUMORD  = SPACE(10)
V_DESCAU  = "ORDINE ACQUISTO"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT   = 0
TOT_ORDT_EUR = 0

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

DIVA1     = SPACE(45)
DIVA2     = SPACE(45)
DIVA3     = SPACE(45)
DIVA4     = SPACE(45)
DIVA5     = SPACE(45)

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



SELECT CU_ORF_DD
GO TOP


DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP        = ""
V_INTESTA    = ""
V_CONSEGNATO = ""

v_seek	 = ORF_RECNO
v_chiave = "taggancio"
IF seek_std('U_ORF_TT',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO

   V_CODICE = M.ORD_CODCLI
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ""	&& ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO


   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015


   V_VETTO  = M.ORD_VETTO1
   V_VETTO2 = M.ORD_VETTO2  && ERASMO - 31/08/2022
   V_VETTO3 = M.ORD_VETTO3  && ERASMO - 31/08/2022
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  

   *V_NUMLEI = M.ORD_NUMLEI
   *V_DATLEI = M.ORD_DATLEI
   *V_NUCONS = M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS
    
   V_NUMORC = M.ORD_NUMORC	
   V_DATORC = M.ORD_DATORC	
   V_NUMOFC = M.ORD_NUMOFC	
   V_DATOFC = M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC		

   V_NUMCOC = M.ORD_NUMCOC	
   V_DATCOC = M.ORD_DATCOC	
   

   V_MERCRE = "" && M.ORD_MERCRE
   V_NSRIF  = M.ORD_RIFERI  
   V_VALUTA = M.ORD_VALUTA
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   
   X__FAX    = "" && M.ORD_FAX
   X__COMUNI = "" && M.ORD_COMUNI
   X__OGGETT = "" && M.ORD_OGGETT
   X__COMMIS = "" && M.ORD_COMMIS
   X__IMBALL = M.ORD_IMBALL
   X__GGCONS = "" && M.ORD_GGCONS
   X__DESPES = "" && M.ORD_DESPES
   X__NORME1 = "" && M.ORD_NORME1
   X__NORME2 = "" && M.ORD_NORME2
   V_PROVIN  = M.ORD_PROVIN

   x_soci   = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "for_codcli = '" + V_CODCLI + "'"
   x_cond   = x_soci + " and " + x_codi   
   cSql     = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORI")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORI
   GO TOP   
   IF EOF()
   ELSE
     X_VENROT    = ""
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(for_RAGDUE)
     ENDIF
     v_seek = 'STA'+ALLTRIM(for_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF
   
   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+V_PROVIN+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      *IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0 OR !PUB_NOSTPNAZ  && ERASMO - 13/03/2015
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
   ENDIF
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+IIF(!EMPTY(M.ORD_ATTENZIONE),"All'attenzione di "+ALLTRIM(M.ORD_ATTENZIONE)+CHR(13),"")+ ;
      	ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+ IIF(!EMPTY(M.ORD_PROC)," ("+ALLTRIM(M.ORD_PROC)+")","") 
   ENDIF


   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
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

ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA

   V_CODICE = M.ORD_CODCLI
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ""   && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO


   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015

   
   V_VETTO  = M.ORD_VETTO1
   V_VETTO2 = M.ORD_VETTO2  && ERASMO - 31/08/2022
   V_VETTO3 = M.ORD_VETTO3  && ERASMO - 31/08/2022
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
   
   *V_NUMLEI = M.ORD_NUMLEI
   *V_DATLEI = M.ORD_DATLEI
   *V_NUCONS = M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS
   
   V_NUMORC = M.ORD_NUMORC	
   V_DATORC = M.ORD_DATORC	
   V_NUMOFC = M.ORD_NUMOFC	
   V_DATOFC = M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC		
 
   V_NUMCOC = M.ORD_NUMCOC	
   V_DATCOC = M.ORD_DATCOC	
   

   V_MERCRE = "" && M.ORD_MERCRE
   V_NSRIF  = M.ORD_RIFERI
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO


   X__FAX    = "" && M.ORD_FAX
   X__COMUNI = "" && M.ORD_COMUNI
   X__OGGETT = "" && M.ORD_OGGETT
   X__COMMIS = "" && M.ORD_COMMIS
   X__IMBALL = M.ORD_IMBALL
   X__GGCONS = "" && M.ORD_GGCONS
   X__DESPES = "" && M.ORD_DESPES
   X__NORME1 = "" && M.ORD_NORME1
   X__NORME2 = "" && M.ORD_NORME2
   V_PROVIN  = M.ORD_PROVIN


   x_soci   = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "for_codcli = '" + V_CODCLI + "'"
   x_cond   = x_soci + " and " + x_codi   
   cSql     = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORI")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORI
   GO TOP   
   IF EOF()
   ELSE
     X_VENROT    = ""
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(for_RAGDUE)
     ENDIF

     v_seek = 'STA'+ALLTRIM(for_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF
   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+V_PROVIN+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      *IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0 OR !PUB_NOSTPNAZ  && ERASMO - 13/03/2015
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
   ENDIF
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+IIF(!EMPTY(M.ORD_ATTENZIONE),"All'attenzione di "+ALLTRIM(M.ORD_ATTENZIONE)+CHR(13),"")+ ;
      	ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+ IIF(!EMPTY(M.ORD_PROC)," ("+ALLTRIM(M.ORD_PROC)+")","")  
   ENDIF



   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
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


ENDIF


v_seek 	 = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
   X_VETTO=SUBSTR(DESCRI,1,30)
ELSE
   V_VETTO = ""
   X_VETTO=""
ENDIF

**=> ERASMO - INIZIO 31/08/2022
v_seek 	 = 'VET'+V_VETTO2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO2 = ALLTRIM(DESCRI)
ELSE
   V_VETTO3 = ""
ENDIF

v_seek 	 = 'VET'+V_VETTO3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO3 = ALLTRIM(DESCRI)
ELSE
   V_VETTO3 = ""
ENDIF
**=> ERASMO - INIZIO 31/08/2022

__V_ACURA = V_ACURA
v_seek   = 'MEZ'+V_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    V_ACURA=SUBSTR(DESCRI,1,30)
    X_ACURA=SUBSTR(DESCRI,1,30)
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
	DL_TIPODES 		= 'MEZZI.CONS'
	DL_CODICE  		= __V_ACURA 
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	IF !EMPTY(_DESCR_LINGUA)
		V_ACURA     = _DESCR_LINGUA    
	ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
    V_ACURA=""
    X_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek 	 = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_PORTO = ALLTRIM(DESCRI)
    V_PORTO   = DESCRI
    X_PORTO   = DESCRI
    * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
	DL_TIPODES 		= 'CODI.PORTO'
	DL_CODICE  		= __V_PORTO 
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	IF !EMPTY(_DESCR_LINGUA)
		SAY_PORTO   = _DESCR_LINGUA    
		V_PORTO     = _DESCR_LINGUA  
	ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
    V_PORTO   = ""
    X_PORTO   = ""
    SAY_PORTO = ""
ENDIF

**=> ERASMO - INIZIO 01/12/2025
v_seek	 = 'ASP'+M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ASPETT=SUBSTR(DESCRI,1,30)
ELSE
   SAY_ASPETT=""
ENDIF
**=> ERASMO - FINE 01/12/2025

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

RELEASE V_BANFORN,V_IBANCLI,V_IBANFOR,V_BICSWIFT,X_RIDE
PUBLIC  V_BANFORN,V_IBANCLI,V_IBANFOR,V_BICSWIFT,X_RIDE
V_BANFORN  = SPACE(05)
V_IBANCLI  = SPACE(29)
V_IBANFOR  = SPACE(29)
V_BICSWIFT = SPACE(100)
X_RIDE     = " "

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek	= PUB_CODSOC + V_CODCLI
v_chiave = "for_codsoc+for_codcli"
IF seek_std('u_for_an',v_seek,v_chiave,'CUR_FORNITORE')
 
   SELECT CUR_FORNITORE
   V_BANFORN  		= FOR_BA2
   V_IBANFOR  		= FOR_BA2IBA
   V_CODICE_SWIFT 	= FOR_BSWFOR	
 
   V_BANCLIE  		= FOR_BAE
   V_IBANCLI  		= FOR_CDIBAN
   V_BICSWIFT 		= FOR_BSWFOR

   V_PIVA     		= FOR_PARIVA
   V_CODNAZ   		= FOR_NAZION  
   V_PIVA_CEE 		= FOR_IVACEE  
   V_ALRID    		= FOR_ALRID
   IF EMPTY(V_PIVA)
      V_PIVA  = for_IVACEE
   ENDIF
   IF EMPTY(V_PIVA)
      V_PIVA  = ALLTRIM(for_CODFIS)
   ENDIF
   V_CFISC = FOR_CODFIS
   V_TEL   = FOR_TELEFO
   V_FAX   = FOR_FAX
   V_CAGE  = "   "

ELSE

   WAIT WINDOWS "Fornitore inesistente "+V_CODCLI
   V_CFISC 			= " "
   V_PIVA  			= SPACE(11)
   V_ALRID 			= SPACE(03)
   V_BANFORN  		= ""
   V_IBANFOR  		= ""
   V_BANCLIE  		= ""   
   V_IBANCLI  		= ""
   V_BICSWIFT 		= ""
   V_CODNAZ   		= ""
   V_PIVA_CEE 		= ""
   V_PIVA     		= ""
   V_CODICE_SWIFT 	= ""

   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)

ENDIF

v_seek 	 = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = ALLTRIM(DESCRI)
   X__DESCPA = ALLTRIM(DESCRI)
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= V_PAG
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
   ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
ELSE
   V_CPAG = SPACE(40)
   X__DESCPA = ""
   X_RIDE = SPACE(01)
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

v_seek 	 = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek 	 = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
   NOTAC	   = SUBSTR(LIBERA,11,1)
   FAT_RFI	   = SUBSTR(LIBERA,2,1)
   TI_PX       = SUBSTR(LIBERA,11,1)
ELSE
   V_DESCAU    = SPACE(40)
   NOTAC	   = " "
   TI_PX       = " "
   FAT_RFI	   = " "
ENDIF

IF V_TOP = PUB_CAUCAS
   V_DESCAU = "ORDINE ACQUISTO"
ENDIF

* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
DL_TIPODES 		= 'CODICE-TOP'
DL_CODICE  		= ALLTRIM(V_TOP)
_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
IF !EMPTY(_DESCR_LINGUA)
	V_DESCAU    = _DESCR_LINGUA    
ENDIF
* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *


** 1) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DALLA BANCA DI APPOGGIO DI U_BAN_AN DEL FORNITORE 
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
   	  __codice_swift = BAN_SWIFT	
	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
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
      V_BANAP = SPACE(100)
   ELSE
	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
	  ELSE
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	  ENDIF
   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF

** 2) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DIRETTAMENTE DALL'ANAGRAFICA FORNITORE

IF X_RIDE = 'S'

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
	      			'IBAN : '+ ALLTRIM(V_IBANFOR)	&& >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> IBAN BANCA NOSTRA DA ANAGRAFICA FORNITORE u_for_an
	      IF EMPTY(ALLTRIM(V_CODICE_SWIFT)) 
	      ELSE
	         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_CODICE_SWIFT)
	      ENDIF
	   ENDIF
	ENDIF

ELSE

	IF !EMPTY(ALLTRIM(V_BANCLIE))  
	   x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
	   x_codi = "ban_codban = '" + ALLTRIM(V_BANCLIE) + "'"
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
	      			'IBAN : '+ ALLTRIM(V_IBANCLI)	&& >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> IBAN BANCA PER RICEVUTE BANCARIE DEL FORNITORE 
	      IF EMPTY(ALLTRIM(V_CODICE_SWIFT)) 
	      ELSE
	         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_CODICE_SWIFT)
	      ENDIF
	   ENDIF
	ENDIF

ENDIF   

** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO , NELLA STAMPA ORDINI  
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 

*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO DELL'ORDINE, PERCUI IN ANAGRAFICA CLIENTI NELLA SEZIONE FORNITORI
*!*  INSERISCO LA BANCA SU CUI IL FORNITORE DEVE PAGARE; PERTANTO MI RITROVO AD AVERE PIU' BANCHE AZIENDA A DISPOSIZIONE DEL FORNITORE

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
   			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009      
ENDIF
IF ALLTRIM(V_BANSOC)="."
   V_BANSOC=''
ENDIF




x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_codi = "con_conto = '" + ALLTRIM(M.ORD_CCOSTO) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_codi
Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(Csql,"cur_ccosto")
   return(.f.)
ENDIF
SELECT cur_ccosto
IF EOF()
   X_CCODES=""
ELSE
   X_CCODES=SUBSTR(CON_DESCR,1,30)
ENDIF



SELECT CU_ORF_DD
GO TOP
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("ORF",ORD_CODICE)
         SELECT CU_ORF_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP +1
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)

   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   && CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
	   IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
	   ENDIF
   ENDIF   

   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("CU_ORF_DD")

   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
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

   SELECT CU_ORF_DD

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE

        IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

   ENDIF
   
   IF ORD_PUBBLI = "O"						&& CONTA ARTICOLO OMAGGIO
	   _CNT_OMAGGI = _CNT_OMAGGI + 1		
   ENDIF

   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO' 	&& CALCOLO IMPONIBILE E IMPOSTA POLIECO
 		_IMPONIBILE_POLIECO = _IMPONIBILE_POLIECO + IMPONIB
		_IMPOSTA_POLIECO    = _IMPOSTA_POLIECO    + IMPOSTA  	   
   ENDIF

   
   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
      SKIP +1
      LOOP
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


   

   SELECT CU_ORF_DD
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


PUB_IVADEF = CERCA_IVA_DEFAULT("CU_ORF_DD","CODICE")  
PUB_ALIQ = CERCA_IVA_DEFAULT("CU_ORF_DD","ALIQUOTA")  

*!*	IF !EMPTY(V_ALRID)
*!*	   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
*!*	ELSE
*!*	   V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
*!*	ENDIF

** VERIFICA CHE PERCENTUALE IVA ATTRIBUIRE AL COSTO DEL TRASPORTO :
** ----------------------------------------------------------------
** --- 1) SE FORNITORE IN ESENZIONE %PERCENTUALE IVA SUL TRASPORTO E' = 0
** --- 2) SE FORNITORE CON IVA NON IMPONIBILE (OSSIA PERCENTUALE ULTIMA ALIQUOTA IVA = 0) ANCHE LA %PERCENTUALE IVA SUL TRASPORTO E' = 0
** --- 3) SE FORNITORE CON IVA IMPONIBILE LA %PERCENTUALE IVA SUL TRASPORTO E' = ALLA %PERCENTUALE IVA DI DEFAULT STANDARD (SE CI SONO DIVERSE ALIQUOTE NE CONSIDERA UNA E NON LA MEDIA)

IF !EMPTY(V_ALRID)
   	V_IMPSP = 0		 							&& --- 1) SE FORNITORE IN ESENZIONE %PERCENTUALE IVA SUL TRASPORTO E' = 0
ELSE
	IF NUM_ALIQ = PUB_ALIQ						&& PERCENTUALE DELL'ULTIMA ALIQUOTA IVA PRESENTE NEGLI ARTICOLI
   		V_IMPSP = V_SPESE * (PUB_ALIQ/100)  	&& --- 3) SE FORNITORE CON IVA IMPONIBILE LA %PERCENTUALE IVA SUL TRASPORTO E' = ALLA %PERCENTUALE IVA DI DEFAULT STANDARD 
	ELSE
   		V_IMPSP = V_SPESE * (NUM_ALIQ/100)  	&& --- 2) SE FORNITORE CON IVA NON IMPONIBILE (OSSIA PERCENTUALE ULTIMA ALIQUOTA IVA = 0) ANCHE LA %PERCENTUALE IVA SUL TRASPORTO E' = 0 
	ENDIF
ENDIF


*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA AI SOLI ORDINI IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
   IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
       IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
       IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
       M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
       M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
   ENDIF



NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

v_seek 	  = 'IVA'+IVA1
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 			= SUBSTR(LIBERA,1,03)
   DIVA1 			= ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA1
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA1  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA1 = PUB_IVADEF  
	  ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA2
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA2
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA2  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA2 = PUB_IVADEF  
	  ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA3
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA3
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA3  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA3 = PUB_IVADEF  
	  ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA4
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA4
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA4  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA4 = PUB_IVADEF  
	  ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek 	  = 'IVA'+IVA5
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA5
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA5  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA5 = PUB_IVADEF  
	  ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

IF !ACCO_IVA    && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek 	  = 'IVA'+IVA1
   v_chiave  = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
       SELECT CUR_PARA
	   PIVA1  = SUBSTR(LIBERA,1,03)
	   DIVA1  = ALLTRIM(SUBSTR(DESCRI,1,45))
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

**--> ARROTONDAMENTO IVA

IMPOS1		=	ROUND((IMPOS1+.0000),2)
IMPOS2		=	ROUND((IMPOS2+.0000),2)
IMPOS3		=	ROUND((IMPOS3+.0000),2)
IMPOS4		=	ROUND((IMPOS4+.0000),2)		
IMPOS5		=	ROUND((IMPOS5+.0000),2)
TOT_IMPOS   =   IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5


TOT_ORDT     =   TOT_IMPO + TOT_IMPOS - MATPUB
TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)
*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_ORDT = TOT_IMPO + TOT_IMPOS - MATPUB 
	TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)
ENDIF






*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT CU_ORF_DD
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
      M.ORD_SC4    = 0	
      M.ORD_SC5    = 0	
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
      M.ORD_SC4    = 0	
      M.ORD_SC5    = 0	
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
      M.ORD_SC4    = 0	
      M.ORD_SC5    = 0	
      M.ORD_NOTE   = V_FERIE
      M.ORD_PUBBLI = " "
      GATHER MEMVAR MEMO
   ENDIF
ENDIF

SELECT CU_ORF_DD
APPEND BLANK
REPLACE DAGGANCIO  WITH 'EOF'
REPLACE ORD_SEQUEN WITH 99999
GO TOP

***==>  CREA TRANCHE 

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP   
IF EOF()
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
  ___FLAG_POSALL = .F.		&& posticipi per tutto l'anno
  ___FORNITORE     = ""		&& posticipi per tutto l'anno 
ELSE
   VET_DAL[1]= for_BDAL
   VET_DAL[2]= for_B2DAL
   VET_AL[1] = for_BAL
   VET_AL[2] = for_B2AL
   VET_DAY[1]= for_GG1
   VET_DAY[2]= for_GG2
  ___FLAG_POSALL = .F.				&& posticipi per tutto l'anno
  ___FORNITORE   = M.ORD_CODCLI		&& posticipi per tutto l'anno
ENDIF

SELECT CU_ORF_DD
GO TOP



V_DATASCAD 		= V_DATA
V_COSTTR  		= PUB_COSTOTR 

RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_ORDT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS   

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___FORNITORE,__T_IMPON,__T_IMPOS)


=CREA_SCADENZE()

*** SE CONDIZIONE DI PAGAMENTO SPECIALE, A SECONDA DEL VALORE DI PUB_SSPORD:
*** 1 - RIGENERA IL COMMENTO CON I RIFERIMENTI ALLE SCADENZE SPECIALI
*** 2 - RIPORTA RIFERIMENTI ALLE SCADENZE SPECIALI NEI VETTORI RELATIVI ALLA GESTIONE DELLE SCADENZE
IF checkConSpe(V_PAG)
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"CU_ORF_DD",.F.)
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
TOT_ORDT  = 0
TOT_ORDT_EUR = 0

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

RELEASE V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
RELEASE V_CONSEGNATO

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
RELEASE V_NUMORD
RELEASE V_DESCAU

RELEASE V_NUMLEI
RELEASE V_DATLEI
RELEASE V_NUCONS
RELEASE V_DTCONS

RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_ORDT
RELEASE TOT_ORDT_EUR

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
RELEASE V_DESTI
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

RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA
RELEASE X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
RELEASE V_VETTO2,V_VETTO3  && ERASMO - 31/08/2022

RELEASE V_TEL  
RELEASE V_FAX 
RELEASE V_BANCLIE

RETURN
