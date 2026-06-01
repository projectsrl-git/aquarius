*******************************************************************************************
**** ERASMO 30/01/2006 ********************************************************************
*******************************************************************************************
**** LIBRERIA CONTENENTE LE PROCEDURE UTILIZZATE PER LA RISTAMPA DIRETTA DEI DOCUMENTI ****
*******************************************************************************************  

*******************
PROCEDURE RISTA_BFO
*******************
v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE = DESCRI
ELSE
   CAUSALE = ""
ENDIF

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
ELSE
   PORTO = ""
ENDIF

v_seek   = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
ENDIF

v_seek   = 'AGE'+M.ORD_AGE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   AGENTE = DESCRI
ELSE
   AGENTE = ""
ENDIF

x_cond = "pdv_codice = '" + ALLTRIM(M.ORD_CODBUN) + "'"
cSql   = "select * from u_pdv_an where " + x_cond
IF !ExecCommand(cSql,"CU_PDV_AN")
   RETURN .F.
ENDIF
SELECT CU_PDV_AN
GO TOP
IF EOF()
   say_desbun = SPACE(50)
ELSE
   say_desbun = PDV_DESCRI
ENDIF
   
********
v_seek	 = 'ASP'+M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ASPETT=SUBSTR(DESCRI,1,30)
ELSE
   SAY_ASPETT=""
ENDIF

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_VETTO=SUBSTR(DESCRI,1,30)
ELSE
   SAY_VETTO=""
ENDIF  

v_seek	 = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO=SUBSTR(DESCRI,1,30)
ELSE
   SAY_PORTO=""
ENDIF  

v_seek	 = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
ELSE
   SAY_ACURA=""
ENDIF

v_seek	 = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=SUBSTR(DESCRI,1,30)
ELSE
   SAY_CAUS=""
ENDIF    

v_seek	 = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
ELSE         
   SAY_CPA=""
ENDIF  

v_seek	 = M.ORD_CODBUN
v_chiave = "pdv_codice"
IF seek_std('u_pdv_an',v_seek,v_chiave,'CUR_PDV')
   SELECT CUR_PDV
   SAY_DESBUN   = PDV_DESCRI
ELSE
   SAY_DESBUN   = ""
ENDIF

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_codi = "con_conto = '" + ALLTRIM(M.ORD_CODCCO) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_codi
Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(Csql,"cur_ccosto")
   return(.f.)
ENDIF
SELECT cur_ccosto
IF EOF()
   SAY_DESCCO=""
ELSE
   SAY_DESCCO = CON_DESCR
ENDIF

x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
x_codi = "ban_codban = '" + M.ORD_BANCA + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
IF !ExecCommand(cSql,"CUR_PARA")
   RETURN .F.
ENDIF
SELECT CUR_PARA
GO TOP
IF EOF()
   SAY_BANCA=""
ELSE
   SAY_BANCA=SUBSTR(BAN_DESBAN,1,30)
ENDIF   
********   

V_DESDOCU = "FAX SIMILE DDT FORNITORE"+CHR(13)+"BOLLA DI CARICO"

SELECT XU_BFO_DD
*SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
SET FILTER TO DAGGANCIO = M.TAGGANCIO
GO TOP

ANCORA = 1 
      
M.ORD_DATORD = RIBALTA2(M.ORD_DATORD)
M.ORD_DATOR2 = RIBALTA2(M.ORD_DATOR2)   
   
SELECT XU_BFO_DD
GO TOP   

DO CASE
   CASE _V_OPZSTA = 1
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_BFO_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "BFO_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_BFO_DD"
	_PDF_REPORT_ 		= "REPORT\BFOPJITA.FRX"
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO



RETURN


*******************
PROCEDURE RISTA_BOL
*******************
v_seek	 = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE  = DESCRI
   SAY_CAUS = DESCRI
ELSE
   CAUSALE  = ""
   SAY_CAUS = ""
ENDIF    

v_seek	 = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO     = DESCRI
   SAY_PORTO = DESCRI
ELSE
   PORTO     = ""
   SAY_PORTO = ""
ENDIF  

v_seek	 = 'ASP'+M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ASPETT = SUBSTR(DESCRI,1,30)
ELSE
   SAY_ASPETT = ""
ENDIF

v_seek	 = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA = SUBSTR(DESCRI,1,30)
ELSE
   SAY_ACURA = ""
ENDIF

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
ENDIF  

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO2)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET2 = DESCRI
   INDVET2 = ALLTRIM(LIBERA)
ELSE
   DESVET2 = ""
   INDVET2 = ""
ENDIF  

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO3)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET3 = DESCRI
   INDVET3 = ALLTRIM(LIBERA)
ELSE
   DESVET3 = ""
   INDVET3 = ""
ENDIF  

v_seek	 = 'AGE'+M.ORD_AGE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   AGENTE = DESCRI
ELSE
   AGENTE = ""
ENDIF

** SERGIO 21/01/2005 inizio
RELEASE DPU,MOM
PUBLIC DPU,MOM

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
** SERGIO 21/01/2005 fine

SELECT XU_BOL_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   ** SERGIO 03/01/2005 INIZIO
   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
   	  IF STAM_NOTE("BOL",ORD_CODICE)
         SELECT XU_BOL_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP 
         LOOP
      ENDIF          	 
   ENDIF
   ** SERGIO 03/01/2005   FINE
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_BOL_DD")
   SELECT XU_BOL_DD
   SKIP +1
ENDDO

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

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond 
IF !ExecCommand(cSql,"u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
GO TOP
IF EOF()
   XX_UFFIVA = SPACE(50)
   XX_DELDOC = SPACE(50)
ELSE
   XX_UFFIVA = CLI_UFFIVA
   XX_DELDOC = CLI_DELDOC
ENDIF

IF !ExecCommand("select * from u_azi_an","u_azi_an")
   return
ENDIF
SELECT u_azi_an
GO TOP 
IF EOF()
   XX_INTBOL = ""
ELSE
   XX_INTBOL = AZI_INTBOL
ENDIF

SELECT XU_BOL_DD
GO TOP


IF PUB_STFAD
   DO PRG\BOLSTAM
ELSE
   SELECT XU_BOL_DD
   GO BOTTOM
   APPEND BLANK
   REPLACE DAGGANCIO WITH 'EOF'
   GO TOP
   
   *DO PRG\MENUSTA1 WITH "CU_BOL_DD",.t.,.T.,"XXX","BOLPJITA","BOL000.FRX",.F.,_FILEPDF
   *REPORT FORM "REPORT\BOLPJITA.FRX" NOEJECT NOCONSOLE TO PRINTER      
   *REPORT FORM "REPORT\BOLPJITA.FRX" NOEJECT NOCONSOLE PREVIEW
   
   YYY_PROGRAMMA = "BOLPJITA"
   YYY_REPORT    = "BOL000.FRX"
   YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)
   IF YYY_FILOUT <> "NNN"
      DO CASE
         CASE _V_OPZSTA = 1
            FOR I = 1 TO _V_NUMCOPIE
               REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
            NEXT
         CASE _V_OPZSTA = 2
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW
         CASE _V_OPZSTA = 3
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW
            FOR I = 1 TO _V_NUMCOPIE
               REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
            NEXT            
      ENDCASE
   ENDIF
   
   **=> ERASMO - INIZIO 15/05/2008
   *** STAMPA MODULO CHECK LIST DI SPEDIZIONE
   IF _V_OPZSTA = 1 .OR. _V_OPZSTA = 2 .OR. _V_OPZSTA = 3
      x_nddt = "pr5_numddt = '" + ALLTRIM(M.ORD_NUMORD) + "'"
      x_data = "pr5_datddt = '" + IIF(SUBSTR(ORD_DATORD,3,1) = '/',RIBALTA2(M.ORD_DATORD),ALLTRIM(M.ORD_DATORD)) + "'"
      x_fddt = "pr5_flgddt = 1"
      x_cond = x_nddt + " and " + x_data + " and " + x_fddt
      Csql = "select PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN,COUNT(*) AS PR5_NUMROT from u_prd_d5 where " + x_cond + ;
             " GROUP BY PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN order by  PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN"
      IF !ExecCommand(cSql,'PR5_CHK_LST')
         return(.f.)
      ENDIF
      SELECT PR5_CHK_LST
      GO TOP
      IF EOF()
      ELSE   
         KKK_REPORT = "REPORT\BOLCHKLST.FRX"
         DO CASE
            CASE _V_OPZSTA = 1
               FOR I = 1 TO _V_NUMCOPIE
                  REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE TO PRINTER
               NEXT
            CASE _V_OPZSTA = 2
               REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE PREVIEW
            CASE _V_OPZSTA = 3
               REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE PREVIEW
               FOR I = 1 TO _V_NUMCOPIE
                  REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE TO PRINTER
               NEXT            
         ENDCASE
      ENDIF
   ENDIF
   **=> ERASMO - FINE 15/05/2008

	*!*	INIZIO 15/03/2007 SERGIO
	IF PUB_CREA_FILE_PDF
		SELECT XU_BOL_DD
		GO TOP   
	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
		_PDF_DESCRIZIONE_	= "BOL_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
		_PDF_SELECT_ 		= "XU_BOL_DD"
		_PDF_REPORT_ 		= YYY_FILOUT    
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	*!*	FINE 15/03/2007 SERGIO


   
   SELECT XU_BOL_DD
   GO BOTTOM
   IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
      DELETE
   ENDIF
ENDIF

RETURN


*******************
PROCEDURE RISTA_FAP
*******************
NUMPRO=TAGGANCIO
SELECT XU_FAP_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA
CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))
  
PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU
PUBLIC V_FERIE,NOTAC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

**=> ERASMO - INIZIO 07/06/2007
RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
**=> ERASMO - FINE 07/06/2007

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
V_CPAG    = SPACE(40)
V_BANAP   = SPACE(30)
V_NUMFAT  = SPACE(10)
V_DESCAU  = "FATTURA PROFORMA"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_FATT  = 0

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

SELECT XU_FAP_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""

v_seek   = M.TAGGANCIO
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
   V_VETTO  = M.ORD_VETTO
   V_PORTO  = M.ORD_PORTO
   
   V_NUMORC = M.ORD_NUMORC	&& ERASMO 07/06/2007
   V_DATORC = M.ORD_DATORC	&& ERASMO 07/06/2007
   V_NUMOFC = M.ORD_NUMOFC	&& ERASMO 07/06/2007
   V_DATOFC = M.ORD_DATOFC	&& ERASMO 07/06/2007
   V_CDC	= M.ORD_CDC   	&& ERASMO 07/06/2007
   V_NUMCOC = M.ORD_NUMCOC	&& ERASMO 07/06/2007
   V_DATCOC = M.ORD_DATCOC	&& ERASMO 07/06/2007
   
   V_MERCRE = M.ORD_MERCRE
   V_VALUTA = M.ORD_VALUTA
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = (M.ORD_DATORD)
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
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
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
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
   V_VETTO  = M.ORD_VETTO
   V_PORTO  = M.ORD_PORTO
   
   V_NUMORC = M.ORD_NUMORC	&& ERASMO 07/06/2007
   V_DATORC = M.ORD_DATORC	&& ERASMO 07/06/2007
   V_NUMOFC = M.ORD_NUMOFC	&& ERASMO 07/06/2007
   V_DATOFC = M.ORD_DATOFC	&& ERASMO 07/06/2007
   V_CDC	= M.ORD_CDC   	&& ERASMO 07/06/2007
   V_NUMCOC = M.ORD_NUMCOC	&& ERASMO 07/06/2007
   V_DATCOC = M.ORD_DATCOC	&& ERASMO 07/06/2007
   
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
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
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
   V_BANFORN  = CLI_BAEFOR
   V_IBANFOR  = CLI_IBAFOR
   V_IBANCLI  = CLI_CDIBAN
   V_BICSWIFT = CLI_BSWFOR
ENDIF

v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = DESCRI
ELSE
   V_VETTO = ""
ENDIF

v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
ENDIF

**=> ERASMO - INIZIO 07/06/2007
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
**=> ERASMO - FINE 07/06/2007

v_seek   = 'FAT000'                            && CHIUSURA PER FERIE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_FERIE = ALLTRIM(DESCRI)+ ' ' +ALLTRIM(LIBERA)
ELSE
   V_FERIE = ""
ENDIF

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
   V_CFISC = CLI_CODFIS
   V_PIVA  = CLI_PARIVA
   V_ALRID = CLI_ALRID
   IF EMPTY(V_PIVA)
      V_PIVA  = CLI_IVACEE
   ENDIF
   **=> ERASMO - INIZIO 13/12/2007
   IF EMPTY(V_PIVA)
      V_PIVA  = ALLTRIM(CLI_CODFIS)
   ENDIF
   **=> ERASMO - FINE 13/12/2007
ELSE
   V_CFISC = " "
   V_PIVA  = SPACE(11)
   V_ALRID = SPACE(03)
ENDIF

v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
ELSE
   V_CPAG = SPACE(40)
   X_RIDE 	 = SPACE(01)
ENDIF

v_seek   = 'AGE'+ALLTRIM(V_CAGE)
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

v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DPU = ALLTRIM(LIBERA)
ELSE
   DPU = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
   NOTAC	= SUBSTR(LIBERA,11,1)
   TI_PX    = SUBSTR(LIBERA,11,1)
ELSE
   V_DESCAU = SPACE(40)
   NOTAC	   = " "
   TI_PX    = " "
ENDIF

IF X_RIDE = 'S'
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
                'IBAN : '+ ALLTRIM(V_IBANFOR)
      IF EMPTY(ALLTRIM(V_BICSWIFT))
      ELSE
         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_BICSWIFT)
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
      *V_BANAP = ALLTRIM(BAN_DESBAN)+' '+ALLTRIM(BAN_LOCA)+' ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
                'IBAN : '+ ALLTRIM(V_IBANCLI)
   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF
  
SELECT XU_FAP_DD
GO TOP

DO WHILE .T.
  
   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("FAP",ORD_CODICE)
         SELECT XU_FAP_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP +1
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_FAP_DD")

   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
   ENDIF

   v_seek   = 'IVA'+COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
     SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

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

   SELECT XU_FAP_DD
   SKIP +1

ENDDO

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS
IF !EMPTY(V_ALRID)
   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
ELSE
   V_IMPSP = V_SPESE * (VAL(PUB_IVA)/100)
ENDIF

NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
      ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
      ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
      ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
      ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

IF !ACCO_IVA    && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      PIVA1  = SUBSTR(LIBERA,1,03)
      DIVA1  = SUBSTR(DESCRI,1,25)
      IMPO1  = IMPO1+V_SPESE
      IMPOS1 = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_FATT    =   TOT_IMPO + TOT_IMPOS - MATPUB

*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT XU_FAP_DD
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

SELECT XU_FAP_DD
APPEND BLANK
REPLACE DAGGANCIO  WITH 'EOF'
REPLACE ORD_SEQUEN WITH 99999
  
REPLACE ORS_NUMORD WITH M.ORD_NUMORD
REPLACE ORS_DATORD WITH M.ORD_DATORD
REPLACE ORS_CODCLI WITH M.ORD_CODCLI
   
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
ELSE
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
ENDIF

SELECT XU_FAP_DD
GO TOP

V_DATASCAD = V_DATA
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA)
   
DO PERIODI

DO VAR_PERI

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

SELECT XU_FAP_DD

ANCORA = 1


__PROGRAMMA__    = "FAPPJEUR"
__REPORTNEW__    = "FAPPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
   
DO CASE
   CASE _V_OPZSTA = 1 
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_FAP_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "FAP_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_FAP_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO


SELECT XU_FAP_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*************************
*PROCEDURE RILA_VAR
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

RETURN


*******************
PROCEDURE RISTA_FAT
*******************
NUMPRO=TAGGANCIO

SELECT XU_FAT_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*DO STAMPAMOD
*****************************
*PROCEDURE STAMPAMOD
*****************************
*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

RELEASE V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU
RELEASE V_FERIE,NOTAC

PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU
PUBLIC V_FERIE,NOTAC


RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

** SERGIO 03/01/2005 INIZIO
RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0
** SERGIO 03/01/2005 FINE

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
V_DESCAU  = "FATTURA DI VENDITA"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
 
V_SPINCA  = 0
V_SPTRAS  = 0
  
TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_FATT  = 0

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

SELECT XU_FAT_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""

v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('u_fat_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO
   V_NUMFAT = M.ORD_NUMORD
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = M.ORD_VETTO
   V_PORTO  = M.ORD_PORTO
   
   V_NUMORC = M.ORD_NUMORC	&& SERGIO 21/02/2007
   V_DATORC = M.ORD_DATORC	&& SERGIO 21/02/2007
   V_NUMOFC = M.ORD_NUMOFC	&& SERGIO 21/02/2007
   V_DATOFC = M.ORD_DATOFC	&& SERGIO 21/02/2007
   V_CDC	= M.ORD_CDC		&& SERGIO 21/02/2007
 
   V_NUMCOC = M.ORD_NUMCOC	&& SERGIO 05/06/2007
   V_DATCOC = M.ORD_DATCOC	&& SERGIO 05/06/2007
   
   V_MERCRE = M.ORD_MERCRE
   V_VALUTA = M.ORD_VALUTA
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "cli_codcli = '" + V_CODCLI + "'"
   x_cond   = x_soci + " and " + x_codi   
   cSql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF EOF()
   ELSE
     V_RAGDUE   = ALLTRIM(CLI_RAGDUE)
   ENDIF
   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+" ("+V_PROVIN+")"
ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NUMFAT = M.ORD_NUMORD
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = M.ORD_VETTO
   V_PORTO  = M.ORD_PORTO
   
  
   V_NUMORC = M.ORD_NUMORC	&& SERGIO 21/02/2007
   V_DATORC = M.ORD_DATORC	&& SERGIO 21/02/2007
   V_NUMOFC = M.ORD_NUMOFC	&& SERGIO 21/02/2007
   V_DATOFC = M.ORD_DATOFC	&& SERGIO 21/02/2007
   V_CDC	= M.ORD_CDC		&& SERGIO 21/02/2007
 
   V_NUMCOC = M.ORD_NUMCOC	&& SERGIO 05/06/2007
   V_DATCOC = M.ORD_DATCOC	&& SERGIO 05/06/2007
   
   
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
   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "cli_codcli = '" + V_CODCLI + "'"
   x_cond   = x_soci + " and " + x_codi   
   cSql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF EOF()
   ELSE
      V_RAGDUE   = ALLTRIM(CLI_RAGDUE)
   ENDIF
   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+" ("+V_PROVIN+")"
ENDIF

v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = DESCRI
ELSE
   V_VETTO = ""
ENDIF

v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
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

v_seek   = 'FAT000'                            && CHIUSURA PER FERIE
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
V_IBANCLI  = SPACE(27)
V_IBANFOR  = SPACE(27)
V_BICSWIFT = SPACE(100)
X_RIDE     = " "

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
   V_BANFORN  = CLI_BAEFOR
   V_IBANFOR  = CLI_IBAFOR
   V_IBANCLI  = CLI_CDIBAN
   V_BICSWIFT = CLI_BSWFOR
   V_CFISC    = CLI_CODFIS
   V_PIVA     = CLI_PARIVA
   V_ALRID    = CLI_ALRID
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

v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
*!*	   IF 'BON' $ LIBERA
*!*	      X_RIDE = 'S'
*!*	   ELSE
*!*	      X_RIDE = 'N'
*!*	   ENDIF
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
ELSE
   V_CPAG = SPACE(40)
   X_RIDE = SPACE(01)
ENDIF

v_seek   = 'AGE'+ALLTRIM(V_CAGE)
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

v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DPU = ALLTRIM(LIBERA)
ELSE
   DPU = ""
ENDIF

** SERGIO 03/01/2005 inizio
v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF
** SERGIO 03/01/2005 fine

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
   NOTAC	   = SUBSTR(LIBERA,11,1)
   TI_PX    = SUBSTR(LIBERA,11,1)
ELSE
   V_DESCAU = SPACE(40)
   NOTAC	   = " "
   TI_PX    = " "
ENDIF

* INIZIO - RINO 15/10/03
IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'FATTURA DI VENDITA'
ENDIF
* FINE - RINO 15/10/03

IF X_RIDE = 'S'
   IF EMPTY(V_BANFORN)
      V_BANFORN = V_BANCA
   ENDIF
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
                'IBAN : '+ ALLTRIM(V_IBANFOR)
      IF EMPTY(ALLTRIM(V_BICSWIFT))
      ELSE
         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_BICSWIFT)
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
      ** 'ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
                'IBAN : '+ ALLTRIM(V_IBANCLI)
   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF
   
SELECT XU_FAT_DD
GO TOP
** SERGIO 03/01/2005 INIZIO
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0
** SERGIO 03/01/2005 FINE

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("FAT",ORD_CODICE)
         SELECT XU_FAT_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP +1
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_FAT_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
   ENDIF

   v_seek   = 'IVA'+COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   ** SERGIO 03/01/2004  INIZIO
   SELECT XU_FAT_DD

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
   
   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
      SKIP +1
   LOOP
   ENDIF
   ** SERGIO 03/01/2004  FINE

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

   SELECT XU_FAT_DD
   SKIP +1

ENDDO

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS
IF !EMPTY(V_ALRID)
   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
ELSE
   V_IMPSP = V_SPESE * (VAL(PUB_IVA)/100)
ENDIF

NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
      ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
      ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
      ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
      ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      PIVA1  = SUBSTR(LIBERA,1,03)
      DIVA1  = SUBSTR(DESCRI,1,25)
      IMPO1  = IMPO1+V_SPESE
      IMPOS1 = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_FATT    =   TOT_IMPO + TOT_IMPOS - MATPUB

*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT XU_FAT_DD
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
      M.ORD_UM	  = SPACE(02)
      M.ORD_IVA	  = SPACE(02)
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
      M.ORD_UM	  = SPACE(02)
      M.ORD_IVA	  = SPACE(02)
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

SELECT XU_FAT_DD
APPEND BLANK
REPLACE DAGGANCIO  WITH 'EOF'
REPLACE ORD_SEQUEN WITH 99999
   
REPLACE ORS_NUMORD WITH M.ORD_NUMORD
REPLACE ORS_DATORD WITH M.ORD_DATORD
REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
   
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
ELSE
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
ENDIF

SELECT XU_FAT_DD
GO TOP

V_DATASCAD = V_DATA
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA)

DO PERIODI

DO VAR_PERI

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

SELECT XU_FAT_DD
GO TOP

ANCORA = 1


__PROGRAMMA__    = "FATPJEUR"
__REPORTNEW__    = "FATPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
   
DO CASE
   CASE _V_OPZSTA = 1 
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_FAT_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "FAT_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_FAT_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO
   
SELECT XU_FAT_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*************************
*PROCEDURE RILA_VAR
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

RETURN


*******************
PROCEDURE RISTA_OFF
*******************
PUBLIC ULT_PAG
NUMPRO=TAGGANCIO

SELECT XU_OFF_DD

_CODNAZ = ""
*DO FORM FORM\INLIN00 LINKED
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

v_seek	 = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF

*DO STAMPAMOD
*!*	*****************************
*!*	PROCEDURE STAMPAMOD
*!*	*****************************

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA
CREATE CURSOR PERIODI;
  (DSCAD C(10),IMP_SCAD N(15),NUM_TRAN N(5))
 
PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB,V_RIGA1,V_RIGA2,V_RIGA3,V_DESTI
PUBLIC V_SPINCA,V_SPTRAS,V_OPE,V_UM
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE
PUBLIC V_TEL,V_FAX,V_DTCONS,V_SC1,V_SC2
PUBLIC X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2

**=> ERASMO - INIZIO 07/06/2007
RELEASE V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
PUBLIC V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
**=> ERASMO - FINE 07/06/2007

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   
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

V_INTESTA =""
V_DESTI   =""
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
V_CPAG    = SPACE(40)
V_BANAP   = SPACE(30)
V_NUMORD  = SPACE(10)
V_DESCAU  = "VENDITA"
V_CFISC   = SPACE(40)   
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_UM      = SPACE(02)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0

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

SELECT XU_OFF_DD

DAGGA = DAGGANCIO
PUBLIC V_TOP
V_TOP=''

V_INTESTA=""
V_DESTI  =""
   
*v_seek   = OFF_RECNO
v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('u_OFF_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = ORD_PORTO
   V_MERCRE = "     "
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_DTCONS = M.ORD_DTCONS
   V_VALUTA = M.ORD_VALUTA
   V_SPINCA  = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS  = M.ORD_SPTRAS   && SPESE TRASPORTO
   X__FAX    = ORD_FAX
   X__COMUNI = ORD_COMUNI
   X__OGGETT = ORD_OGGETT
   X__COMMIS = ORD_COMMIS
   X__IMBALL = ORD_IMBALL
   X__GGCONS = ORD_GGCONS
   X__DESPES = ORD_DESPES
   X__NORME1 = ORD_NORME1
   X__NORME2 = ORD_NORME2
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
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=M.ORD_RAGC+CHR(13)
      V_DESTI=V_DESTI+M.ORD_INDC+CHR(13)
      V_DESTI=V_DESTI+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
   ENDIF
   
   **=> ERASMO - INIZIO 07/06/2007
   V_CDC	= ORD_CDC
   V_NUMCOC = ORD_NUMCOC
   V_DATCOC = ORD_DATCOC
   **=> ERASMO - FINE 07/06/2007
   
ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = M.ORD_PORTO
   V_MERCRE = "    "
   V_DTCONS  = M.ORD_DTCONS
   V_NSRIF  = M.ORD_RIFERI
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA
   V_TOP    = M.ORD_CAUS
   V_SPINCA  = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS  = M.ORD_SPTRAS   && SPESE TRASPORTO
   X__FAX    = M.ORD_FAX
   X__COMUNI = M.ORD_COMUNI
   X__OGGETT = M.ORD_OGGETT
   X__COMMIS = M.ORD_COMMIS
   X__IMBALL = M.ORD_IMBALL
   X__GGCONS = M.ORD_GGCONS
   X__DESPES = M.ORD_DESPES
   X__NORME1 = M.ORD_NORME1
   X__NORME2 = M.ORD_NORME2
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
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=M.ORD_RAGC+CHR(13)
      V_DESTI=V_DESTI+M.ORD_INDC+CHR(13)
      V_DESTI=V_DESTI+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
   ENDIF
   
   **=> ERASMO - INIZIO 07/06/2007
   V_CDC	= M.ORD_CDC
   V_NUMCOC = M.ORD_NUMCOC
   V_DATCOC = M.ORD_DATCOC
   **=> ERASMO - FINE 07/06/2007
   
ENDIF

v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
ENDIF

**=> ERASMO - INIZIO 07/06/2007
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
**=> ERASMO - FINE 07/06/2007

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
   V_CFISC = CLI_CODFIS
   V_TEL   = CLI_TELEFO
   V_FAX   = CLI_FAX
   IF EMPTY(V_CAGE)
      V_CAGE   = "   "
   ENDIF
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
ELSE
   WAIT WINDOWS "Cliente inesistente"+V_CODCLI
   V_CFISC = " "
   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)
ENDIF

v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   DO CASE
      CASE _CODNAZ = "ITA"
           X__DESCPA = ITALIANO
      CASE _CODNAZ = "ING"
           X__DESCPA = INGLESE
      CASE _CODNAZ = "FRA"
           X__DESCPA = FRANCESE
      CASE _CODNAZ = "GER"
           X__DESCPA = TEDESCO
      CASE _CODNAZ = "SPA"
           X__DESCPA = SPAGNOLO
   ENDCASE
ELSE
   V_CPAG = SPACE(40)
   X__DESCPA = ""
ENDIF

v_seek   = 'AGE'+ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
ELSE
   V_DAGE = SPACE(40)
ENDIF
IF "NESSUNO" $ V_DAGE
   V_DAGE = "       "
ENDIF
IF ALLTRIM(V_DAGE) = "."
   V_DAGE = "       "
ENDIF

v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESPUBL = ALLTRIM(LIBERA)
ELSE
   DESPUBL = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
ELSE
   V_DESCAU = SPACE(40)
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
   V_BANAP = SPACE(40)
ELSE
   V_BANAP = ALLTRIM(BAN_DESBAN)+' '+ALLTRIM(BAN_LOCA)+' ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
ENDIF
IF ALLTRIM(V_BANCA)="."
   V_BANAP=SPACE(40)
ENDIF

SELECT XU_OFF_DD
GO TOP

CTR_REC = 0
ULT_PAG = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
   	  IF STAM_NOTE("OFF",ORD_CODICE)
         SELECT XU_OFF_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)

   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_OFF_DD")

   v_seek    = 'IVA'+COD_IVA
   v_chiave  = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

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
   CTR_REC = CTR_REC +1

   SELECT XU_OFF_DD
   SKIP +1

ENDDO

ULT_PAG = CTR_REC / 5

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS
V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek    = 'IVA'+IVA1
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
      ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF


v_seek    = 'IVA'+IVA2
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
      ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek    = 'IVA'+IVA3
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
      ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek    = 'IVA'+IVA4
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
      ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek    = 'IVA'+IVA5
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB

***==>  CREA TRANCHE 

V_DATASCAD = RIBALTA2(V_DATA)
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY)

DO PERIODI

DO VAR_PERI

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = '" + ALLTRIM(_CODNAZ) + "'"
x_tipo = "tipo_doc = 'OF'"
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

SELECT XU_OFF_DD

FLAG_PREZZO=.T.
   
ORD_DATORD = RIBALTA2(ORD_DATORD)

DO CASE
   CASE _V_OPZSTA = 1
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_OFF_DD
	GO TOP   
    *___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,1,2)+"_"+SUBSTR(M.ORD_DATORD,4,2)+"_"+SUBSTR(M.ORD_DATORD,7,4)  && ERASMO - 07/06/2007
	_PDF_DESCRIZIONE_	= "OFF_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_OFF_DD"
	_PDF_REPORT_ 		= "REPORT\OFFPJEUR.FRX"
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO

SELECT XU_OFF_DD
GO BOTTOM

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*!*	*************************
*!*	PROCEDURE RILA_VAR
*!*	*************************

RELEASE V_RIGA1
RELEASE V_RIGA2
RELEASE V_RIGA3
RELEASE V_INTESTA
RELEASE V_DESTI
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
RELEASE V_OPE
RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_ORDT

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

RELEASE V_TEL
RELEASE V_FAX
RELEASE V_DTCONS
RELEASE V_SC1
RELEASE V_SC2
RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA

RETURN


*******************
PROCEDURE RISTA_ORD
*******************
PUBLIC ULT_PAG
NUMPRO=TAGGANCIO

SELECT XU_ORD_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

_CODNAZ = ""
*DO FORM FORM\INLIN00 LINKED
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
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF

*DO STAMPAMOD
*****************************
*PROCEDURE STAMPAMOD
*****************************

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15),NUM_TRAN N(5))

PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB,V_RIGA1,V_RIGA2,V_RIGA3,V_DESTI
PUBLIC V_SPINCA,V_SPTRAS,V_OPE,V_UM
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE
PUBLIC V_TEL,V_FAX,V_DTCONS,V_SC1,V_SC2
PUBLIC X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
PUBLIC X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES

RELEASE V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE DPU,X_RIDE
PUBLIC  DPU,X_RIDE
DPU    = " "
X_RIDE = " "
 
PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

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

X_ASPETT = ""
X_VETTO  = ""
X_PORTO  = ""
X_ACURA  = ""
X_CCODES = ""

V_INTESTA=""
V_DESTI  =""
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
V_NUMORD  = SPACE(10)
V_DESCAU  = "VENDITA"
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_UM      = SPACE(02)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0

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

v_seek 	 = "DTE_R2"+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_RIGA3=ALLTRIM(LIBERA)
ENDIF

SELECT XU_ORD_DD

DAGGA = DAGGANCIO
  
PUBLIC V_TOP
V_TOP=''

V_INTESTA=""
V_DESTI  =""

*v_seek   = ORD_RECNO
v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('u_ord_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = ORD_NUMORD
   V_RAGSOC = ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ORD_INDIRI
   V_CAP    = ORD_CAP
   V_LOCALI = ORD_LOCALI
   V_CODCLI = ORD_CODCLI
   V_PIVA   = ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = ORD_PORTO
   V_MERCRE = "     "
   V_NSRIF  = ORD_RIFERI
   V_CAGE   = ORD_AGE
   V_PAG    = ORD_CPA
   V_DATA   = ORD_DATORD
   V_BANCA  = ORD_BANCA
   V_TOP    = ORD_CAUS
   V_DTCONS = ORD_DTCONS
   V_VALUTA = ORD_VALUTA
   V_SPINCA = ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = ORD_SPTRAS   && SPESE TRASPORTO
   X__FAX   = ORD_FAX
   X__COMUNI = ORD_COMUNI
   X__OGGETT = ORD_OGGETT
   X__COMMIS = ORD_COMMIS
   X__IMBALL = ORD_IMBALL
   X__GGCONS = ORD_GGCONS
   X__DESPES = ORD_DESPES
   X__NORME1 = ORD_NORME1
   X__NORME2 = ORD_NORME2
   V_PROVIN  = ORD_PROVIN
   V_INTESTA = V_RAGSOC+CHR(13)
   V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(ORD_INDC)+CHR(13)+ALLTRIM(ORD_CAPC)+" "+ALLTRIM(ORD_LOCC)+" ("+ALLTRIM(ORD_PROC)+")"
   ENDIF

   V_NUMOFC = ORD_NUMOFC	&& SERGIO 05/06/2007
   V_DATOFC = ORD_DATOFC	&& SERGIO 05/06/2007
   V_CDC	= ORD_CDC		&& SERGIO 05/06/2007
 
   V_NUMCOC = ORD_NUMCOC	&& SERGIO 05/06/2007
   V_DATCOC = ORD_DATCOC	&& SERGIO 05/06/2007


ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = M.ORD_PORTO
   V_MERCRE = "    "
   V_DTCONS  = M.ORD_DTCONS
   V_NSRIF  = M.ORD_RIFERI
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA
   V_TOP    = M.ORD_CAUS
   V_SPINCA  = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS  = M.ORD_SPTRAS   && SPESE TRASPORTO
   X__FAX    = M.ORD_FAX
   X__COMUNI = M.ORD_COMUNI
   X__OGGETT = M.ORD_OGGETT
   X__COMMIS = M.ORD_COMMIS
   X__IMBALL = M.ORD_IMBALL
   X__GGCONS = M.ORD_GGCONS
   X__DESPES = M.ORD_DESPES
   X__NORME1 = M.ORD_NORME1
   X__NORME2 = M.ORD_NORME2
   V_PROVIN  = M.ORD_PROVIN
     
   V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
   ENDIF

   V_NUMOFC = M.ORD_NUMOFC	&& SERGIO 05/06/2007
   V_DATOFC = M.ORD_DATOFC	&& SERGIO 05/06/2007
   V_CDC	= M.ORD_CDC		&& SERGIO 05/06/2007
 
   V_NUMCOC = M.ORD_NUMCOC	&& SERGIO 05/06/2007
   V_DATCOC = M.ORD_DATCOC	&& SERGIO 05/06/2007



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
   V_BANFORN  = CLI_BAEFOR
   V_IBANFOR  = CLI_IBAFOR
   V_IBANCLI  = CLI_CDIBAN
   V_BICSWIFT = CLI_BSWFOR
   V_CFISC    = CLI_CODFIS
   V_TEL      = CLI_TELEFO
   V_FAX      = CLI_FAX
   IF EMPTY(V_CAGE)
      V_CAGE  = "   "
   ENDIF
   VET_DAL[1] = CLI_BDAL
   VET_DAL[2] = CLI_B2DAL
   VET_AL[1]  = CLI_BAL
   VET_AL[2]  = CLI_B2AL
   VET_DAY[1] = CLI_GG1
   VET_DAY[2] = CLI_GG2
ELSE
   WAIT WINDOWS "Cliente inesistente"+V_CODCLI
   V_CFISC    = " "
   V_TEL      = SPACE(12)
   V_FAX      = SPACE(12)
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


v_seek 	 = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
   X_PORTO   = DESCRI
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
   X_PORTO   = ""
ENDIF

v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   DO CASE
      CASE _CODNAZ = "ITA"
           X__DESCPA = ITALIANO
      CASE _CODNAZ = "ING"
           X__DESCPA = INGLESE
      CASE _CODNAZ = "FRA"
           X__DESCPA = FRANCESE
      CASE _CODNAZ = "GER"
           X__DESCPA = TEDESCO
      CASE _CODNAZ = "SPA"
           X__DESCPA = SPAGNOLO
   ENDCASE
   *!*	   IF 'BON' $ LIBERA
   *!*	      X_RIDE = 'S'
   *!*	   ELSE
   *!*	      X_RIDE = 'N'
   *!*	   ENDIF
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
ELSE
   V_CPAG    = SPACE(40)
   X__DESCPA = ""
   X_RIDE 	 = SPACE(01)
ENDIF

v_seek 	 = 'AGE'+ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
ELSE
   V_DAGE = SPACE(40)
ENDIF
IF "NESSUNO" $ V_DAGE
   V_DAGE = "       "
ENDIF
IF ALLTRIM(V_DAGE) = "."
   V_DAGE = "       "
ENDIF

** SERGIO 21/01/2005 inizio
v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESPUBL = ALLTRIM(LIBERA)
   DPU = ALLTRIM(LIBERA)
ELSE
   DESPUBL = ""
   DPU = ""
ENDIF
** SERGIO 21/01/2005 FINE

** SERGIO 03/01/2005 inizio
v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF
** SERGIO 03/01/2005 fine

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
ELSE
   V_DESCAU = SPACE(40)
ENDIF

v_seek   = 'ASP'+M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_ASPETT=SUBSTR(DESCRI,1,30)
ELSE
   X_ASPETT=""
ENDIF

v_seek   = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_VETTO=SUBSTR(DESCRI,1,30)
ELSE
   X_VETTO=""
ENDIF

v_seek   = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_ACURA=SUBSTR(DESCRI,1,30)
ELSE
   X_ACURA=""
ENDIF

IF X_RIDE = 'S'
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
                'IBAN : '+ ALLTRIM(V_IBANFOR)
      IF EMPTY(ALLTRIM(V_BICSWIFT))
      ELSE
         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_BICSWIFT)
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
      ** 'ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
                'IBAN : '+ ALLTRIM(V_IBANCLI)
   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF
*********
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

SELECT XU_ORD_DD
GO TOP
** SERGIO 03/01/2004  INIZIO
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0
** SERGIO 03/01/2004  FINE

CTR_REC = 0
ULT_PAG = 0

DO WHILE .T.
  
   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("ORD",ORD_CODICE)
         SELECT XU_ORD_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)
    
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_ORD_DD")
   
   v_seek   = 'IVA'+COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   ** SERGIO 03/01/2004  INIZIO
   SELECT XU_ORD_DD

   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
   ENDIF

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
  
   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
      SKIP +1
      LOOP
   ENDIF
   ** SERGIO 03/01/2004  FINE
     
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

   CTR_REC = CTR_REC +1

   SELECT XU_ORD_DD
   SKIP +1

ENDDO

ULT_PAG = CTR_REC / 5

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS
V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek    = 'IVA'+IVA1
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
      ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
      ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
      ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
      ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB

***==>  CREA TRANCHE 

V_DATASCAD = RIBALTA2(V_DATA)
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY)

DO PERIODI

DO VAR_PERI

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = '" + ALLTRIM(_CODNAZ) + "'"
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

SELECT XU_ORD_DD
GO TOP
FLAG_PREZZO=.T.


__PROGRAMMA__    = "ORDPJEUR"
__REPORTNEW__    = "ORDPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
   
DO CASE
   CASE _V_OPZSTA = 1 
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE




*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORD_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORD_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_ORD_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO


SELECT XU_ORD_DD
GO BOTTOM

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*************************
*PROCEDURE RILA_VAR
*************************

RELEASE V_RIGA1
RELEASE V_RIGA2
RELEASE V_RIGA3
RELEASE V_INTESTA
RELEASE V_DESTI
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
RELEASE V_OPE
RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_ORDT

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

RELEASE V_TEL
RELEASE V_FAX
RELEASE V_DTCONS
RELEASE V_SC1
RELEASE V_SC2
RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA
RELEASE X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
** SERGIO 21/01/2005 INIZIO
RELEASE DPU
** SERGIO 21/01/2005 FINE

RETURN


*******************
PROCEDURE RISTA_ORF
*******************
PUBLIC ULT_PAG
NUMPRO = TAGGANCIO
   
SELECT XU_ORF_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
   
RELEASE DATA

_CODNAZ = ""
*DO FORM FORM\INLIN00 LINKED
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
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF

*DO STAMPAMOD
*****************************
*PROCEDURE STAMPAMOD
*****************************
*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA
CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15),NUM_TRAN N(5))


RELEASE FLAG_STAMPA_ORDINI_IN_INGLESE 
PUBLIC FLAG_STAMPA_ORDINI_IN_INGLESE 
FLAG_STAMPA_ORDINI_IN_INGLESE = .F.


RELEASE V_CPAG,NUMORD,V_DATA,RAGSOC,V_NUMORD
   
RELEASE V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG,     ;
        V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU,IVA1,IVA2,IVA3,IVA4,       ;
        IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5,V_CFISC,V_CAGE,V_DAGE,  ;
        V_VALUTA,NETTO,MATPUB,V_RIGA1,V_RIGA2,V_RIGA3,V_DESTI,V_SPINCA,V_SPTRAS,V_OPE,V_UM,DIVA1,     ;
        DIVA2,DIVA3,DIVA4,DIVA5,PIVA1,PIVA2,PIVA3,PIVA4,PIVA5,DS1,DS2,DS3,DS4,DS5IS1,IS2,IS3,IS4,IS5, ;
        DESPUBL,V_PORTO,V_VETTO,V_MERCRE,V_PAGAME,V_OGGETTO,V_TEL,V_FAX,V_DTCONS,V_SC1,V_SC2X__FAX,   ;
        X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2

PUBLIC  V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG,     ;
        V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU,IVA1,IVA2,IVA3,IVA4,       ;
        IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5,V_CFISC,V_CAGE,V_DAGE,  ;
        V_VALUTA,NETTO,MATPUB,V_RIGA1,V_RIGA2,V_RIGA3,V_DESTI,V_SPINCA,V_SPTRAS,V_OPE,V_UM,DIVA1,     ;
        DIVA2,DIVA3,DIVA4,DIVA5,PIVA1,PIVA2,PIVA3,PIVA4,PIVA5,DS1,DS2,DS3,DS4,DS5IS1,IS2,IS3,IS4,IS5, ;
        DESPUBL,V_PORTO,V_VETTO,V_MERCRE,V_PAGAME,V_OGGETTO,V_TEL,V_FAX,V_DTCONS,V_SC1,V_SC2X__FAX,   ;
        X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
        
**=> ERASMO - INIZIO 07/06/2007
RELEASE V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
PUBLIC V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
**=> ERASMO - FINE 07/06/2007

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
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

V_INTESTA = ""
V_DESTI   = ""
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
V_CPAG	 = SPACE(40)
V_BANAP   = SPACE(30)
V_NUMORD  = SPACE(10)
V_DESCAU  = "ORDINE ACQUISTO"
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_UM      = SPACE(02)
NUMORD    = ""

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0

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

V_PAGAME  = 'Condizioni di pagamento:'
   
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

SELECT XU_ORF_DD

DAGGA = DAGGANCIO

PUBLIC V_TOP,V_CODICE
V_TOP     = ''
V_CODICE  = ""
V_INTESTA = ""
V_DESTI   = ""

*v_seek	 = ORF_RECNO
v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('u_orf_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   V_CODICE = ORD_CODCLI
   V_OPE    = SUBSTR(ORD_CODOPE,1,1)
   V_NUMORD = ORD_NUMORD
   V_RAGSOC = ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ORD_INDIRI
   V_CAP    = ORD_CAP
   V_LOCALI = ORD_LOCALI
   V_CODCLI = ORD_CODCLI
   V_PIVA   = ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = ORD_PORTO
   V_MERCRE = "     "
   V_CAGE   = ORD_AGE
   V_PAG    = ORD_CPA
   V_DATA   = ORD_DATORD
   V_BANCA  = ORD_BANCA
   V_TOP    = ORD_CAUS
   V_DTCONS = ORD_DTCONS
   V_VALUTA = ORD_VALUTA
   V_SPINCA  = ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS  = ORD_SPTRAS   && SPESE TRASPORTO
   V_OGGETTO = "CONFERMA D'ORDINE N. " + ALLTRIM(V_NUMORD) + ' DEL ' + V_DATA
   V_PROVIN  = M.ORD_PROVIN
   V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(ORD_RAGC)+CHR(13)+ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
   ENDIF
   
   **=> ERASMO - INIZIO 07/06/2007
   V_CDC	= ORD_CDC
   V_NUMCOC = ORD_NUMCOC
   V_DATCOC = ORD_DATCOC
   **=> ERASMO - FINE 07/06/2007
   
ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_CODICE = M.ORD_CODCLI
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = M.ORD_PORTO
   V_MERCRE = "    "
   V_DTCONS = M.ORD_DTCONS
   V_NSRIF  = M.ORD_RIFERI
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA
   V_TOP    = M.ORD_CAUS
   V_SPINCA  = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS  = M.ORD_SPTRAS   && SPESE TRASPORTO
   V_OGGETTO = "CONFERMA D'ORDINE N. " + ALLTRIM(V_NUMORD) + ' DEL ' + V_DATA
   V_PROVIN  = M.ORD_PROVIN
   V_INTESTA = V_RAGSOC+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
   ENDIF
   
   **=> ERASMO - INIZIO 07/06/2007
   V_CDC	= M.ORD_CDC
   V_NUMCOC = M.ORD_NUMCOC
   V_DATCOC = M.ORD_DATCOC
   **=> ERASMO - FINE 07/06/2007
   
ENDIF

v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
ENDIF

**=> ERASMO - INIZIO 07/06/2007
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
**=> ERASMO - FINE 07/06/2007

*** v_seek 	 = PUB_CODSOC + ALLTRIM(V_CODCLI)
*** v_chiave = "for_codsoc+for_codcli"
*** IF seek_std('u_for_an',v_seek,v_chiave,'CUR_FORNITORE')
***   SELECT CUR_FORNITORE
x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"cur_fornitore")
   return(.f.)
ENDIF
SELECT cur_fornitore
GO TOP
IF !EOF()
   V_CFISC = FOR_CODFIS
   V_TEL   = FOR_TELEFO
   V_FAX   = FOR_FAX
   V_CAGE   = "   "
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   FLAG_STAMPA_ORDINI_IN_INGLESE = FOR_FLGTEL
ELSE
   WAIT WINDOWS "Fornitore inesistente "+V_CODCLI
   V_CFISC = " "
   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)
   FLAG_STAMPA_ORDINI_IN_INGLESE = .F.
ENDIF

v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   DO CASE
      CASE _CODNAZ = "ITA"
           X__DESCPA = ITALIANO
      CASE _CODNAZ = "ING"
           X__DESCPA = INGLESE
      CASE _CODNAZ = "FRA"
           X__DESCPA = FRANCESE
      CASE _CODNAZ = "GER"
           X__DESCPA = TEDESCO
      CASE _CODNAZ = "SPA"
           X__DESCPA = SPAGNOLO
   ENDCASE
ELSE
   V_CPAG = SPACE(40)
   X__DESCPA = ""
ENDIF

IF EMPTY(ALLTRIM(X__DESCPA))
    X__DESCPA = V_CPAG 
ENDIF

v_seek   = 'AGE'+ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
ELSE
   V_DAGE = SPACE(40)
ENDIF
IF "NESSUNO" $ V_DAGE
   V_DAGE = "       "
ENDIF
IF ALLTRIM(V_DAGE) = "."
   V_DAGE = "       "
ENDIF

v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESPUBL = ALLTRIM(LIBERA)
ELSE
   DESPUBL = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
ELSE
   V_DESCAU = SPACE(40)
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
   V_BANAP = SPACE(40)
ELSE
   V_BANAP = ALLTRIM(BAN_DESBAN)+' '+ALLTRIM(BAN_LOCA)+' ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
ENDIF

*** v_seek 	 = PUB_CODSOC + ALLTRIM(V_BANCA)
*** v_chiave = "ban_codsoc + ban_codban"
*** IF seek_std('u_ban_an',v_seek,v_chiave,'CUR_BANCA')
***    SELECT CUR_BANCA
***    V_BANAP = ALLTRIM(BAN_DESBAN)+' '+ALLTRIM(BAN_LOCA)+' ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
*** ELSE
***    V_BANAP = SPACE(40)
*** ENDIF
   
IF ALLTRIM(V_BANCA)="."
   V_BANAP=SPACE(40)
ENDIF

SELECT XU_ORF_DD
GO TOP

CTR_REC = 0
ULT_PAG = 0

DO WHILE .T.
   
   IF EOF()
       EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("ORF",ORD_CODICE)
         SELECT XU_ORF_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP
         LOOP
      ENDIF          	
   ENDIF

   IF SUBSTR(ORD_DATCON,5,1) = '/'                  && ERASMO 30/01/2006
      REPLACE ORD_DATCON WITH RIBALTA2(ORD_DATCON)
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)

   v_seek   = 'IVA'+COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

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

   CTR_REC = CTR_REC +1

   SELECT XU_ORF_DD
   SKIP +1

ENDDO

ULT_PAG = CTR_REC / 5

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS
V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
      ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
      ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
      ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
      ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

IF TOT_IMPO < 0        && SOLO MATERIALE PUBBLICITARIO
   TOT_IMPO = TOT_IMPO * -1
ENDIF

**--> ARROTONDAMENTO IVA

IMPOS1		=	ROUND((IMPOS1+.0000),2)
IMPOS2		=	ROUND((IMPOS2+.0000),2)
IMPOS3		=	ROUND((IMPOS3+.0000),2)
IMPOS4		=	ROUND((IMPOS4+.0000),2)		
IMPOS5		=	ROUND((IMPOS5+.0000),2)
TOT_IMPOS   	=   IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5
TOT_ORDT    	=   TOT_IMPO + TOT_IMPOS - MATPUB

***==>  CREA TRANCHE 
V_DATASCAD  = V_DATA
V_TUTTO     = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY)

DO PERIODI

DO VAR_PERI

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = '" + ALLTRIM(_CODNAZ) + "'"
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

SELECT XU_ORF_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   REPLACE ORD_DESCR1 WITH ORD_DESART
   REPLACE ORD_DESCR2 WITH SPACE(40)
   REPLACE ORD_DESCR3 WITH SPACE(40)
   REPLACE ORD_DESCR4 WITH SPACE(40)

   IF M.FLAG1 = .F. .AND. ;
      M.FLAG2 = .F. .AND. ;
      M.FLAG3 = .F. .AND. ;
      M.FLAG4 = .F.
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   V_DESCRI = SPACE(40)
   V_DISEGN = SPACE(25)
   V_DESEST = SPACE(40)
   V_DESART = SPACE(40)

   V_DESART = ORD_DESART
   V_DESEST = ORD_DES2

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"cur_articolo")
      return(.f.)
   ENDIF
   SELECT cur_articolo
   GO TOP
   IF !EOF()
      V_DISEGN = ART_DISEGN
      IF M.ORD_CODCLI = ART_CODF1
          V_DESCRI = ART_NOTA1
      ENDIF
      IF M.ORD_CODCLI = ART_CODF2
         V_DESCRI = ART_NOTA2
      ENDIF
      IF M.ORD_CODCLI = ART_CODF3
         V_DESCRI = ART_NOTA3
      ENDIF
   ENDIF

   SELECT XU_ORF_DD

   IF M.FLAG1 = .T.     			 && SOLO DESCRIZIONE ARTICOLO FORNITORE
      REPLACE ORD_DESCR1 WITH V_DESCRI
      REPLACE ORD_DESCR2 WITH SPACE(40)
      REPLACE ORD_DESCR3 WITH SPACE(40)
      REPLACE ORD_DESCR4 WITH SPACE(40)
   ENDIF

   IF M.FLAG2 = .T.					&& ARTICOLO MIO + ARTICOLO FORNITORE
      REPLACE ORD_DESCR1 WITH V_DESART
      REPLACE ORD_DESCR2 WITH V_DESCRI
      REPLACE ORD_DESCR3 WITH SPACE(40)
      REPLACE ORD_DESCR4 WITH SPACE(40)
   ENDIF

   IF M.FLAG3 = .T.					&& ARTICOLO MIO+ SECONDA DESCRIZIONE + ART.FORNITORE
      REPLACE ORD_DESCR1 WITH V_DESART
      REPLACE ORD_DESCR2 WITH V_DESEST
      REPLACE ORD_DESCR3 WITH V_DESCRI
      REPLACE ORD_DESCR4 WITH SPACE(40)
   ENDIF

   IF M.FLAG4 = .T.
      REPLACE ORD_DESCR1 WITH V_DESART
      REPLACE ORD_DESCR2 WITH V_DESEST
      REPLACE ORD_DESCR3 WITH V_DESCRI
      REPLACE ORD_DESCR4 WITH V_DISEGN
   ENDIF

   V_DART = ""
   IF !EMPTY(ORD_DESCR1)
      V_DART = ALLTRIM(ORD_DESCR1)
   ENDIF
   IF !EMPTY(ORD_DESCR2)
      V_DART = V_DART + CHR(13) + ALLTRIM(ORD_DESCR2)
   ENDIF
   IF !EMPTY(ORD_DESCR3)
      V_DART = V_DART + CHR(13) + ALLTRIM(ORD_DESCR3)
   ENDIF
   IF !EMPTY(ORD_DESCR4)
      V_DART = V_DART + CHR(13) + ALLTRIM(ORD_DESCR4)
   ENDIF

   * TOGLIE CHR13 INIZIALE
  
   IF SUBSTR(V_DART,1,1) = ""
      V_DART = ALLTRIM(SUBSTR(V_DART,2,200))
   ENDIF

   SELECT XU_ORF_DD
   REPLACE ORD_DESCR4 WITH V_DART
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_ORF_DD")
   
   SELECT XU_ORF_DD
   SKIP +1
 
ENDDO

SELECT XU_ORF_DD
GO TOP

PUBLIC TIT8
TIT8        = 'DT.CONS.'
FLAG_PREZZO = .T.

IF FLAG_STAMPA_ORDINI_IN_INGLESE
	__PROGRAMMA__    = "ORFPJING"
	__REPORTNEW__    = "ORFPJING.FRX"
	__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
ELSE
	__PROGRAMMA__    = "ORFPJEUR"
	__REPORTNEW__    = "ORFPJEUR.FRX"
	__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
ENDIF
   
DO CASE
   CASE _V_OPZSTA = 1 
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE



*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORF_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORF_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_ORF_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO

SELECT XU_ORF_DD
GO BOTTOM

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*************************
*PROCEDURE RILA_VAR
*************************
RELEASE V_RIGA1
RELEASE V_RIGA2
RELEASE V_RIGA3
RELEASE V_INTESTA
RELEASE V_DESTI
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
RELEASE V_OPE
RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_ORDT

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

RELEASE V_TEL
RELEASE V_FAX
RELEASE V_DTCONS
RELEASE V_SC1
RELEASE V_SC2
RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA

RETURN


*******************
PROCEDURE RISTA_ORT
*******************
PUBLIC ULT_PAG
NUMPRO=TAGGANCIO

SELECT XU_ORD_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

_CODNAZ = ""
*DO FORM FORM\INLIN00 LINKED
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
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF

*DO STAMPAMOD
*****************************
*PROCEDURE STAMPAMOD
*****************************

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA
CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15),NUM_TRAN N(5))

PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB,V_RIGA1,V_RIGA2,V_RIGA3,V_DESTI
PUBLIC V_SPINCA,V_SPTRAS,V_OPE,V_UM
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE
PUBLIC V_TEL,V_FAX,V_DTCONS,V_SC1,V_SC2
PUBLIC X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
PUBLIC X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
   
RELEASE DPU,X_RIDE
PUBLIC  DPU,X_RIDE
DPU    = " "
X_RIDE = " "
   
PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

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

X_ASPETT = ""
X_VETTO  = ""
X_PORTO  = ""
X_ACURA  = ""
X_CCODES = ""

V_INTESTA = ""
V_DESTI   = ""
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
V_NUMORD  = SPACE(10)
V_DESCAU  = "VENDITA"
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_UM      = SPACE(02)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0

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

v_seek 	 = "DTE_R2"+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_RIGA3=ALLTRIM(LIBERA)
ENDIF

SELECT XU_ORD_DD

DAGGA = DAGGANCIO
   
PUBLIC V_TOP
V_TOP=''

V_INTESTA=""
V_DESTI  =""

*v_seek   = ORD_RECNO
v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('u_ord_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = ORD_NUMORD
   V_RAGSOC = ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ORD_INDIRI
   V_CAP    = ORD_CAP
   V_LOCALI = ORD_LOCALI
   V_CODCLI = ORD_CODCLI
   V_PIVA   = ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = ORD_PORTO
   V_MERCRE = "     "
   V_NSRIF  = ORD_RIFERI
   V_CAGE   = ORD_AGE
   V_PAG    = ORD_CPA
   V_DATA   = ORD_DATORD
   V_BANCA  = ORD_BANCA
   V_TOP    = ORD_CAUS
   V_DTCONS = ORD_DTCONS
   V_VALUTA = ORD_VALUTA
   V_SPINCA = ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = ORD_SPTRAS   && SPESE TRASPORTO
   X__FAX   = ORD_FAX
   X__COMUNI = ORD_COMUNI
   X__OGGETT = ORD_OGGETT
   X__COMMIS = ORD_COMMIS
   X__IMBALL = ORD_IMBALL
   X__GGCONS = ORD_GGCONS
   X__DESPES = ORD_DESPES
   X__NORME1 = ORD_NORME1
   X__NORME2 = ORD_NORME2
   V_PROVIN  = ORD_PROVIN
   V_INTESTA = V_RAGSOC+CHR(13)
   V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(ORD_INDC)+CHR(13)+ALLTRIM(ORD_CAPC)+" "+ALLTRIM(ORD_LOCC)+" ("+ALLTRIM(ORD_PROC)+")"
   ENDIF
ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_VETTO  = "   "
   V_PORTO  = M.ORD_PORTO
   V_MERCRE = "    "
   V_DTCONS  = M.ORD_DTCONS
   V_NSRIF  = M.ORD_RIFERI
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA
   V_TOP    = M.ORD_CAUS
   V_SPINCA  = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS  = M.ORD_SPTRAS   && SPESE TRASPORTO
   X__FAX    = M.ORD_FAX
   X__COMUNI = M.ORD_COMUNI
   X__OGGETT = M.ORD_OGGETT
   X__COMMIS = M.ORD_COMMIS
   X__IMBALL = M.ORD_IMBALL
   X__GGCONS = M.ORD_GGCONS
   X__DESPES = M.ORD_DESPES
   X__NORME1 = M.ORD_NORME1
   X__NORME2 = M.ORD_NORME2
   V_PROVIN  = M.ORD_PROVIN
   V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
   ENDIF
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
   V_BANFORN  = CLI_BAEFOR
   V_IBANFOR  = CLI_IBAFOR
   V_IBANCLI  = CLI_CDIBAN
   V_BICSWIFT = CLI_BSWFOR
   V_CFISC    = CLI_CODFIS
   V_TEL      = CLI_TELEFO
   V_FAX      = CLI_FAX
   IF EMPTY(V_CAGE)
      V_CAGE  = "   "
   ENDIF
   VET_DAL[1] = CLI_BDAL
   VET_DAL[2] = CLI_B2DAL
   VET_AL[1]  = CLI_BAL
   VET_AL[2]  = CLI_B2AL
   VET_DAY[1] = CLI_GG1
   VET_DAY[2] = CLI_GG2
ELSE
   WAIT WINDOWS "Cliente inesistente"+V_CODCLI
   V_CFISC    = " "
   V_TEL      = SPACE(12)
   V_FAX      = SPACE(12)
ENDIF

v_seek 	 = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
   X_PORTO   = DESCRI
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
   X_PORTO   = ""
ENDIF

v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   DO CASE
      CASE _CODNAZ = "ITA"
           X__DESCPA = ITALIANO
      CASE _CODNAZ = "ING"
           X__DESCPA = INGLESE
      CASE _CODNAZ = "FRA"
           X__DESCPA = FRANCESE
      CASE _CODNAZ = "GER"
           X__DESCPA = TEDESCO
      CASE _CODNAZ = "SPA"
           X__DESCPA = SPAGNOLO
   ENDCASE
   *!*	   IF 'BON' $ LIBERA
   *!*	      X_RIDE = 'S'
   *!*	   ELSE
   *!*	      X_RIDE = 'N'
   *!*	   ENDIF
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
ELSE
   V_CPAG    = SPACE(40)
   X__DESCPA = ""
   X_RIDE 	 = SPACE(01)
ENDIF

v_seek 	 = 'AGE'+ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
ELSE
   V_DAGE = SPACE(40)
ENDIF
IF "NESSUNO" $ V_DAGE
   V_DAGE = "       "
ENDIF
IF ALLTRIM(V_DAGE) = "."
   V_DAGE = "       "
ENDIF

** SERGIO 21/01/2005 inizio
v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESPUBL = ALLTRIM(LIBERA)
   DPU = ALLTRIM(LIBERA)
ELSE
   DESPUBL = ""
   DPU = ""
ENDIF
** SERGIO 21/01/2005 FINE

** SERGIO 03/01/2005 inizio
v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF
** SERGIO 03/01/2005 fine

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
ELSE
   V_DESCAU = SPACE(40)
ENDIF

v_seek   = 'ASP'+M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_ASPETT=SUBSTR(DESCRI,1,30)
ELSE
   X_ASPETT=""
ENDIF

v_seek   = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_VETTO=SUBSTR(DESCRI,1,30)
ELSE
   X_VETTO=""
ENDIF

v_seek   = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_ACURA=SUBSTR(DESCRI,1,30)
ELSE
   X_ACURA=""
ENDIF

IF X_RIDE = 'S'
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
                'IBAN : '+ ALLTRIM(V_IBANFOR)
      IF EMPTY(ALLTRIM(V_BICSWIFT))
      ELSE
         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_BICSWIFT)
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
      ** 'ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
                'IBAN : '+ ALLTRIM(V_IBANCLI)
   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF
*********
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

SELECT XU_ORD_DD
GO TOP
** SERGIO 03/01/2004  INIZIO
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0
** SERGIO 03/01/2004  FINE

CTR_REC = 0
ULT_PAG = 0

DO WHILE .T.
 
   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("ORD",ORD_CODICE)
         SELECT XU_ORD_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP
         LOOP
      ENDIF          	
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)
    
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_ORD_DD")
   
   v_seek   = 'IVA'+COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   ** SERGIO 03/01/2004  INIZIO
   SELECT XU_ORD_DD

   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
   ENDIF

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
     
   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
      M.T_OMAGGIO = M.T_OMAGGIO + IMPONIB
      M.I_OMAGGIO = M.I_OMAGGIO + IMPOSTA
      SKIP +1
      LOOP
   ENDIF
   ** SERGIO 03/01/2004  FINE
     
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

   CTR_REC = CTR_REC +1

   SELECT XU_ORD_DD
   SKIP +1

ENDDO

ULT_PAG = CTR_REC / 5

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS
V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek    = 'IVA'+IVA1
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
   	  ACCO_IVA = .T.
      IMPO1    = IMPO1+V_SPESE
      IMPOS1   = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
      ACCO_IVA = .T.
      IMPO2    = IMPO2+V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
      ACCO_IVA = .T.
      IMPO3    = IMPO3+V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
      ACCO_IVA = .T.
      IMPO4    = IMPO4+V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB

***==>  CREA TRANCHE 

V_DATASCAD = RIBALTA2(V_DATA)
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY)

DO PERIODI

DO VAR_PERI

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = '" + ALLTRIM(_CODNAZ) + "'"
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

SELECT XU_ORD_DD
GO TOP
FLAG_PREZZO=.T.

DO CASE
   CASE _V_OPZSTA = 1
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORD_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORT_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_ORD_DD"
	_PDF_REPORT_ 		= "REPORT\ORDPJEUT.FRX"
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO

SELECT XU_ORD_DD
GO BOTTOM

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*************************
*PROCEDURE RILA_VAR
*************************
RELEASE V_RIGA1
RELEASE V_RIGA2
RELEASE V_RIGA3
RELEASE V_INTESTA
RELEASE V_DESTI
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
RELEASE V_OPE
RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_ORDT

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

RELEASE V_TEL
RELEASE V_FAX
RELEASE V_DTCONS
RELEASE V_SC1
RELEASE V_SC2
RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA
RELEASE X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
** SERGIO 21/01/2005 INIZIO
RELEASE DPU
** SERGIO 21/01/2005 FINE

RETURN


*******************
PROCEDURE PERIODI
*******************
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


*******************
PROCEDURE PAROLA
*******************
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


*******************
PROCEDURE CREA_PERI
*******************
** ===>>> CREA I PERIODI DI SCADENZA
SELECT PERIODI
APPEND BLANK
REPLACE IMP_SCAD  WITH IMP_TRANK
REPLACE NUM_TRAN  WITH CONTA_TRA
REPLACE DSCAD     WITH DATA_SCAD

RETURN


*******************
PROCEDURE VAR_PERI
*******************
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


*******************
PROCEDURE RISTA_REC
*******************
v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE = DESCRI
ELSE
   CAUSALE = ""
ENDIF    

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
ELSE
   PORTO = ""
ENDIF  

v_seek   = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
ENDIF  

v_seek   = 'AGE'+M.ORD_AGE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   AGENTE = DESCRI
ELSE
   AGENTE = ""
ENDIF

SELECT XU_BOL_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_BOL_DD")
   SELECT XU_BOL_DD
   SKIP +1
ENDDO

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

SELECT XU_BOL_DD
GO TOP
IF PUB_STFAD
   DO PRG\BOLSTAM
ELSE
   SELECT XU_BOL_DD
   GO BOTTOM
   APPEND BLANK
   REPLACE DAGGANCIO WITH 'EOF'
      
   REPLACE ORS_NUMORD WITH M.ORD_NUMORD
   REPLACE ORS_DATORD WITH M.ORD_DATORD
   REPLACE ORS_CODCLI WITH M.ORD_CODCLI      
      
   GO TOP
      
   DO CASE
      CASE _V_OPZSTA = 1
         FOR I = 1 TO _V_NUMCOPIE
            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
         NEXT
      CASE _V_OPZSTA = 2
         REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE PREVIEW
      CASE _V_OPZSTA = 3
         REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE PREVIEW
         FOR I = 1 TO _V_NUMCOPIE
            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
         NEXT            
   ENDCASE   
 
	*!*	INIZIO 15/03/2007 SERGIO
	IF PUB_CREA_FILE_PDF
		SELECT XU_BOL_DD
		GO TOP   
	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
		_PDF_DESCRIZIONE_	= "REC_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
		_PDF_SELECT_ 		= "XU_BOL_DD"
		_PDF_REPORT_ 		= "REPORT\BOLPJRES.FRX"
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	*!*	FINE 15/03/2007 SERGIO
 
         
   SELECT XU_BOL_DD
   GO BOTTOM
   IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
      DELETE
   ENDIF
   
ENDIF

RETURN


*******************
PROCEDURE RISTA_REF
*******************
RELEASE SAY_PORTO,SAY_ACURA,SAY_CAUS,SAY_CPA,SAY_BANCA,SAY_CCODES,SAY_ASPETT
PUBLIC  SAY_PORTO,SAY_ACURA,SAY_CAUS,SAY_CPA,SAY_BANCA,SAY_CCODES,SAY_ASPETT
SAY_PORTO    = ""
SAY_ACURA    = ""
SAY_CAUS     = ""
SAY_CPA      = ""
SAY_BANCA    = ""
SAY_CCODES   = ""
SAY_ASPETT   = ""

*--> VADO A GETTARE LE DESCRIZIONI
v_seek   = 'ASP'+M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ASPETT=SUBSTR(DESCRI,1,30)
ELSE
   SAY_ASPETT=""
ENDIF
   
v_seek   = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_VETTO=SUBSTR(DESCRI,1,30)
ELSE
   SAY_VETTO=""
ENDIF  

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO=SUBSTR(DESCRI,1,30)
ELSE
   SAY_PORTO=""
ENDIF  

v_seek   = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
ELSE
   SAY_ACURA=""
ENDIF

v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=SUBSTR(DESCRI,1,30)
ELSE
   SAY_CAUS=""
ENDIF    
   
v_seek   = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
ELSE         
   SAY_CPA=""
ENDIF  

x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
x_codi = "ban_codban = '" + M.ORD_BANCA + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
IF !ExecCommand(cSql,"CUR_PARA")
   RETURN .F.
ENDIF
SELECT CUR_PARA
GO TOP
IF EOF()
   SAY_BANCA=""
ELSE
   SAY_BANCA=SUBSTR(BAN_DESBAN,1,30)
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
   SAY_CCODES=""
ELSE
   SAY_CCODES=SUBSTR(CON_DESCR,1,30)
ENDIF   
   
v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE = DESCRI
ELSE
   CAUSALE = ""
ENDIF    

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
ELSE
   PORTO = ""
ENDIF  

v_seek   = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
ENDIF  

v_seek   = 'AGE'+M.ORD_AGE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   AGENTE = DESCRI
ELSE
   AGENTE = ""
ENDIF

** SERGIO 21/01/2005 inizio
RELEASE DPU,MOM
PUBLIC DPU,MOM

v_seek   = 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DPU = ALLTRIM(LIBERA)
ELSE
   DPU = ""
ENDIF

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF
** SERGIO 21/01/2005 fine

SELECT XU_BOL_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   ** SERGIO 03/01/2005 INIZIO
   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
   	  IF STAM_NOTE("BOL",ORD_CODICE)
         SELECT XU_BOL_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP 
         LOOP
      ENDIF          	 
   ENDIF
   ** SERGIO 03/01/2005   FINE
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_BOL_DD")
   SELECT XU_BOL_DD
   SKIP +1
ENDDO

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

SELECT XU_BOL_DD
GO TOP

SELECT XU_BOL_DD
GO BOTTOM
APPEND BLANK
REPLACE DAGGANCIO WITH 'EOF'
   
REPLACE ORS_NUMORD WITH M.ORD_NUMORD
REPLACE ORS_DATORD WITH M.ORD_DATORD
REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
   
GO TOP

DO CASE
   CASE _V_OPZSTA = 1
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\BOLPJRESFOR.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\BOLPJRESFOR.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\BOLPJRESFOR.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\BOLPJRESFOR.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE   


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"_"+SUBSTR(M.ORD_DATORD,6,2)+"_"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "REF_n_"+ALLTRIM(M.ORD_NUMORD)+" del "+___DATA_DOC+ " - "+SUBSTR(M.ORD_RAGSOC,1,5)
	_PDF_SELECT_ 		= "XU_BOL_DD"
	_PDF_REPORT_ 		= "REPORT\BOLPJRESFOR.FRX"
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF
*!*	FINE 15/03/2007 SERGIO
	
	
SELECT XU_BOL_DD
GO BOTTOM
IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
   DELETE
ENDIF

RETURN


*!*	INIZIO 15/03/2007 SERGIO
**********************
FUNCTION CREA_FILE_PDF
**********************
PARAMETERS _pdf_select,_pdf_report,_pdf_descrizione

S3S=STR(SELECT())

*!*	PRELEVA LA DIRECTORY OVE MEMORIZZARE I FILE PDF

RELEASE _DIRECTORY_PDF 
PUBLIC _DIRECTORY_PDF 

_KEY_PARA = "FSDEMAIL"
IF !EXECCOMMAND("SELECT * FROM PARA WHERE CODICE='"+_KEY_PARA+"'  ORDER BY CODICE ","CURS_PARA")
   RETURN .F.
ENDIF
IF !EOF()
	SELECT CURS_PARA
	GO TOP
	_DIRECTORY_PDF = ALLTRIM(LIBERA)
ELSE
	_DIRECTORY_PDF  = ""	
ENDIF

IF EMPTY(ALLTRIM(_DIRECTORY_PDF))
	PUB_ERRORE=MESSAGEBOX('percorso in parametro FSD mancante'+CHR(13)+'creare il parametro con chiave EMAIL',64,'*** ATTENZIONE ***')
ENDIF

IF EMPTY(ALLTRIM(_pdf_descrizione))
	PUB_ERRORE=MESSAGEBOX('MANCA IL NOME DEL FILE PDF'+CHR(13)+'DA CREARE',64,'*** ATTENZIONE ***')
	_pdf_descrizione = "DOCXXX"
ENDIF


*!*	CREA IL FILE PDF

WAIT WINDOWS "Creazione file PDF in corso attendere prego ......" NOWAIT

SET PROCEDURE TO ApiLib additive
DO declare_fun && procedura di ApiLib
_pub_dir_=sys(5)+sys(2003)
set defa to &_pub_dir_	
ActiveConfig  	 = "0"
***tnFileType   	 = "8"
tnFileType   	 = "9"
txtTabella   	 = ALLTRIM(_PDF_SELECT)
txtReportPath	 = sys(5)+sys(2003)+"\"+ALLTRIM(_PDF_REPORT)
txtExportPath	 = _DIRECTORY_PDF+"\"+ALLTRIM(_pdf_descrizione)+".pdf" 
exeAutomatic 	 = 1
txtEmailOutput   = ""
txtOggettoOutput = ""
do PRG\creapdf1 with ActiveConfig,tnFileType,txtTabella,txtReportPath,txtExportPath,exeAutomatic,txtEmailOutput,txtOggettoOutput
SET DEFA TO &PUB_DIR



SELECT &S3S

RETURN

*!*	FINE 15/03/2007 SERGIO









































