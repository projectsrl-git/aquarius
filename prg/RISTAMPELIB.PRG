*!*	##################################################################################################################################################
  
					**********************************************************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE PROCEDURE UTILIZZATE PER LA RISTAMPA DIRETTA DEI DOCUMENTI                            ***
					***                                                                                                                            ***
					**********************************************************************************************************************************

*!*	##################################################################################################################################################
 


*******************
PROCEDURE RISTA_BFO
*******************


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""


v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA    
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE = ""
ENDIF

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO       = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   SAY_PORTO=""
ENDIF  

v_seek	 = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_ACURA    = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   SAY_ACURA=""
ENDIF

v_seek	 = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		SAY_CAUS    = _DESCR_LINGUA    
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   SAY_CAUS=""
ENDIF    

v_seek	 = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= M.ORD_CPA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      SAY_CPA       = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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


v_seek = 'STA'+M.ORD_CODNAZ
v_chiave = 'CODICE'
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_NAZIONE = ALLTRIM(DESCRI)
ELSE
   SAY_NAZIONE = ""
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
SET FILTER TO DAGGANCIO = M.TAGGANCIO
GO TOP
SCAN
	_TMP_SERIALS = ""
	x_agga = "DAGGANCIO = '" + DAGGANCIO + "'"
	x_csys = "CODSYS = '" + ORD_CODSYS + "'"
	x_cond = x_agga + " and " + x_csys 
	cSql   = "SELECT * FROM U_BFO_SN WHERE " + x_cond + " ORDER BY SERIAL"
	IF !ExecCommand(cSql,"TMP_BFO_SN")
		return(.f.)
	ENDIF
	SELECT TMP_BFO_SN
	GO TOP
	SCAN
		_TMP_SERIALS = ALLTRIM(_TMP_SERIALS) + IIF(EMPTY(_TMP_SERIALS),'',CHR(13)) + ALLTRIM(SERIAL)
	ENDSCAN
	SELECT TMP_BFO_SN
	USE
	SELECT XU_BFO_DD
	REPLACE ORS_SERIALS WITH _TMP_SERIALS
ENDSCAN
GO TOP

ANCORA = 1 
      
M.ORD_DATORD = RIBALTA2(M.ORD_DATORD)
M.ORD_DATOR2 = RIBALTA2(M.ORD_DATOR2)   

YYY_PROGRAMMA = "BFOPJITA"
YYY_REPORT    = "BFOPJITA.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

SELECT XU_BFO_DD
GO TOP   

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)   
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER  
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW  
   CASE _V_OPZSTA = 3
      REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER  
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE


IF PUB_CREA_FILE_PDF
	SELECT XU_BFO_DD
	GO TOP   
    ___DATA_DOC         = STRTRAN(M.ORD_DATORD,"/","-")  
	_PDF_DESCRIZIONE_	= "BFO-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BFO_DD"
	_PDF_REPORT_ 		= YYY_FILOUT  
	_cSubDirectory = SUBDIR_FILE_PDF("BFO")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF



RETURN


** 08/03/2023 SERGIO INIZIO
*******************
PROCEDURE RISTA_RDC
*******************

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""


v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA    
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE = ""
ENDIF

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO       = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   SAY_PORTO=""
ENDIF  

v_seek	 = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_ACURA    = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   SAY_ACURA=""
ENDIF

v_seek	 = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		SAY_CAUS    = _DESCR_LINGUA    
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   SAY_CAUS=""
ENDIF    

v_seek	 = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= M.ORD_CPA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      SAY_CPA       = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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


v_seek = 'STA'+M.ORD_CODNAZ
v_chiave = 'CODICE'
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_NAZIONE = ALLTRIM(DESCRI)
ELSE
   SAY_NAZIONE = ""
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

V_DESDOCU = "FAX SIMILE RESO DA CLIENTE"+CHR(13)+""

SELECT XU_BFO_DD
SET FILTER TO DAGGANCIO = M.TAGGANCIO
GO TOP
SCAN
	_TMP_SERIALS = ""
	x_agga = "DAGGANCIO = '" + DAGGANCIO + "'"
	x_csys = "CODSYS = '" + ORD_CODSYS + "'"
	x_cond = x_agga + " and " + x_csys 
	cSql   = "SELECT * FROM U_BFO_SN WHERE " + x_cond + " ORDER BY SERIAL"
	IF !ExecCommand(cSql,"TMP_BFO_SN")
		return(.f.)
	ENDIF
	SELECT TMP_BFO_SN
	GO TOP
	SCAN
		_TMP_SERIALS = ALLTRIM(_TMP_SERIALS) + IIF(EMPTY(_TMP_SERIALS),'',CHR(13)) + ALLTRIM(SERIAL)
	ENDSCAN
	SELECT TMP_BFO_SN
	USE
	SELECT XU_BFO_DD
	REPLACE ORS_SERIALS WITH _TMP_SERIALS
ENDSCAN
GO TOP

ANCORA = 1 
      
M.ORD_DATORD = RIBALTA2(M.ORD_DATORD)
M.ORD_DATOR2 = RIBALTA2(M.ORD_DATOR2)   

YYY_PROGRAMMA = "RDCPJITA"
YYY_REPORT    = "RDCPJITA.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

SELECT XU_BFO_DD
GO TOP   

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)   
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER  
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW  
   CASE _V_OPZSTA = 3
      REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER  
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE
 

IF PUB_CREA_FILE_PDF
	SELECT XU_BFO_DD
	GO TOP   
    ___DATA_DOC         = STRTRAN(M.ORD_DATORD,"/","-")  
	_PDF_DESCRIZIONE_	= "RDC-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BFO_DD"
	_PDF_REPORT_ 		= YYY_FILOUT  
	_cSubDirectory = SUBDIR_FILE_PDF("RDC")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF



RETURN
** 08/03/2023 SERGIO FINE
*******************
PROCEDURE RISTA_BOL
*******************

LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF


RELEASE SAY_NAZIONE
PUBLIC SAY_NAZIONE
SAY_NAZIONE = ''

IF !EMPTY(M.ORD_CODNAZ)
	V_SEEK   = 'STA'+M.ORD_CODNAZ
	V_CHIAVE = 'CODICE'
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   SAY_NAZIONE=ALLTRIM(DESCRI)
	ENDIF
ELSE 
   SAY_NAZIONE				= ""
ENDIF 


RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""


RELEASE V_RAGSOCA,V_RAGDUEA,V_INDIRA,V_CAPA,V_LOCALIA,V_PROVINA,V_NAZIONA,V_PARIVAA,V_CODFISA,V_IVACEEA
PUBLIC V_RAGSOCA,V_RAGDUEA,V_INDIRA,V_CAPA,V_LOCALIA,V_PROVINA,V_NAZIONA,V_PARIVAA,V_CODFISA,V_IVACEEA

V_RAGSOCA  	= ""
V_RAGDUEA  	= ""
V_INDIRA   	= ""
V_CAPA     	= ""    
V_LOCALIA  	= "" 
V_PROVINA  	= ""
V_NAZIONA  	= ""
V_PARIVAA  	= ""
V_CODFISA  	= "" 
V_IVACEEA  	= ""


V_CIG	= M.ORD_CIG 
V_CUP	= M.ORD_CUP   
   

RELEASE SAY_TELEFO
PUBLIC SAY_TELEFO
SAY_TELEFO = ""

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

v_seek	 = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE  = DESCRI
   SAY_CAUS = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA  
		SAY_CAUS    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE  = ""
   SAY_CAUS = ""
ENDIF

v_seek	 = 'TPO'+M.ORD_TIPOLOGIA 
v_chiave ="codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_TIPOLOGIA = ALLTRIM(DESCRI)
ELSE
   SAY_TIPOLOGIA = ""
ENDIF

v_seek	 = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= M.ORD_CPA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      SAY_CPA       = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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


v_seek	 = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO     = DESCRI
   SAY_PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO        = _DESCR_LINGUA     
       SAY_PORTO    = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_ACURA    = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   SAY_ACURA = ""
ENDIF

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA

   IF !EMPTY(ALLTRIM(NOTE))
   	   DESVET = ALLTRIM(NOTE)			&& TUTTI I DATII ANAGRAFICI DEL TRASPORTATORE SONO NEL CAMPO NOTE
   	   INDVET = ""
   ELSE
	   DESVET = DESCRI
	   INDVET = ALLTRIM(LIBERA)
   ENDIF
 

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

IF EMPTY(M.ORD_VETTO1) AND EMPTY(M.ORD_VETTO2) AND EMPTY(M.ORD_VETTO3) AND !EMPTY(M.ORD_VETXTR)
	DESVET = ALLTRIM(M.ORD_VETXTR)
	INDVET = ""
	DESVET2 = ""
	INDVET2 = ""
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

PUB_SDS = .F. 	&& STAMPA DICITURA FINALE NELLA DDT PER LESCHEDE SICUREZZA/SDS

SELECT XU_BOL_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
GO TOP
DO WHILE .T.
    IF EOF()
      EXIT
   ENDIF
   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
   
   	 **=> SERGIO 27/11/2017 INIZIO: VERIFICO SE ESISTE IL COMMENTO RIEPILOGATIVO DELLE SCHEDE DI SICUREZZA DA CONSEGNARE PER SETTARE IL FLAG PUB_SDS
	 IF PUB_PRGAS
	   	 IF ALLTRIM(ORD_CODICE) = 'SKESDS'
	   	 	PUB_SDS = .T.
	   	 ENDIF
	 ENDIF   	 
   	 **=> SERGIO 27/11/2017 FINE
   
   	  IF STAM_NOTE("BOL",ORD_CODICE)
         SELECT XU_BOL_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP 
         LOOP
      ENDIF          	 
   
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


** 2015/07/10 SERGIO SE INDICATO NELLA DDT CONSIDERA IL CLIENTE PER FATTURAZIONE ALTERNATIVO
IF EMPTY(ALLTRIM(M.ORD_CLIFAT))
	cod_CODCLI = ALLTRIM(M.ORD_CODCLI)
ELSE
	cod_CODCLI = ALLTRIM(M.ORD_CLIFAT)
ENDIF
** 2015/07/10 SERGIO SE INDICATO NELLA DDT CONSIDERA IL CLIENTE PER FATTURAZIONE ALTERNATIVO


x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(cod_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond 
IF !ExecCommand(cSql,"u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
GO TOP
IF !EOF()
     
   DL_LINGUA    = CLI_LINGUA
     
   V_RAGSOCA  	= CLI_RAGSOCA
   V_RAGDUEA  	= CLI_RAGDUEA 
   V_INDIRA   	= CLI_INDIRA
   V_CAPA     	= CLI_CAPA    
   V_LOCALIA  	= CLI_LOCALIA 
   V_PROVINA  	= CLI_PROVINA 
   V_NAZIONA  	= CLI_NAZIONA 
   V_PARIVAA  	= CLI_PARIVAA 
   V_CODFISA  	= CLI_CODFISA 
   V_IVACEEA  	= CLI_IVACEEA   
   XX_UFFIVA 	= CLI_UFFIVA
   XX_DELDOC 	= CLI_DELDOC
   SAY_TELEFO   = "Tel.: "+ CLI_TELEFO  	
   IF EMPTY(ALLTRIM(V_RAGSOCA))
      V_RAGSOCA  	= CLI_RAGSOC
   ENDIF
   IF EMPTY(ALLTRIM(V_RAGDUEA)) 
      V_RAGDUEA  	= CLI_RAGDUE
   ENDIF
   IF EMPTY(ALLTRIM(V_INDIRA))
      V_INDIRA   	= CLI_INDIR
   ENDIF
   IF EMPTY(ALLTRIM(V_CAPA))    
      V_CAPA     	= CLI_CAP  
   ENDIF
   IF EMPTY(ALLTRIM(V_LOCALIA))
      V_LOCALIA  	= CLI_LOCALI 
   ENDIF
   IF EMPTY(ALLTRIM(V_PROVINA))
      V_PROVINA  	= CLI_PROVIN
   ENDIF
   IF EMPTY(ALLTRIM(V_NAZIONA))
      V_NAZIONA  	= CLI_NAZION
   ENDIF
   IF EMPTY(ALLTRIM(V_PARIVAA))
      V_PARIVAA  	= CLI_PARIVA
   ENDIF
   IF EMPTY(ALLTRIM(V_CODFISA))
      V_CODFISA  	= CLI_CODFIS
   ENDIF
   IF EMPTY(ALLTRIM(V_IVACEEA))  
      V_IVACEEA  	= CLI_IVACEE
   ENDIF
ELSE
   XX_UFFIVA 	= SPACE(50)
   XX_DELDOC 	= SPACE(50)
   SAY_TELEFO   = ""				  	
   V_RAGSOCA  	= ""
   V_RAGDUEA  	= ""
   V_INDIRA   	= ""
   V_CAPA     	= ""    
   V_LOCALIA  	= "" 
   V_PROVINA  	= ""
   V_NAZIONA  	= ""
   V_PARIVAA  	= ""
   V_CODFISA  	= "" 
   V_IVACEEA  	= ""
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
   REPLACE ORS_DATORD WITH M.ORD_DATORD
   REPLACE ORS_NUMORD WITH M.ORD_NUMORD
   REPLACE ORS_CODCLI WITH M.ORD_CODCLI
   GO TOP

   *** Per ristampare le bolle di consegna ai fornitori
   IF _V_CLIFOR = 'C'
	   YYY_PROGRAMMA = "BOLPJITA"
	   YYY_REPORT    = "BOLPJITA.FRX"  
   ELSE
	   YYY_PROGRAMMA = "BOLPJCTL"
	   YYY_REPORT    = "BOLPJCTL.FRX"   
   ENDIF

   YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)
   
   IF !EMPTY(_par_custom_report)
	  YYY_FILOUT = ALLTRIM(_par_custom_report)
   ENDIF
      
   
   IF YYY_FILOUT <> "NNN"
      DO CASE
         CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
            FOR __I = 1 TO _V_NUMCOPIE
               *REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
               **=> ERASMO - INIZIO 01/09/2022
               IF _V_OPZPROMPT
                  REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER PROMPT
               ELSE
                  REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
               ENDIF
               **=> ERASMO - FINE 01/09/2022
            NEXT
         CASE _V_OPZSTA = 2
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW
         CASE _V_OPZSTA = 3
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW
            FOR __I = 1 TO _V_NUMCOPIE
               *REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
               **=> ERASMO - INIZIO 01/09/2022
               IF _V_OPZPROMPT
                  REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER PROMPT
               ELSE
                  REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
               ENDIF
               **=> ERASMO - FINE 01/09/2022
            NEXT            
      ENDCASE
   ENDIF
   

	IF PUB_CREA_FILE_PDF
		SELECT XU_BOL_DD
		GO TOP   
	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
		_PDF_DESCRIZIONE_	= "BOL-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
		_PDF_SELECT_ 		= "XU_BOL_DD"
		_PDF_REPORT_ 		= YYY_FILOUT    
		_cSubDirectory = SUBDIR_FILE_PDF("BOL")
		IF !EMPTY(_cSubDirectory)
			=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
		ELSE
			=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
		ENDIF
	ENDIF


   
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


LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF


RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	


RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""
 

RELEASE ___CALCOLA_SOLO_RA
PUBLIC ___CALCOLA_SOLO_RA
___CALCOLA_SOLO_RA = .F.


RELEASE V_IVASPTRAS
PUBLIC V_IVASPTRAS
V_IVASPTRAS = ""

RELEASE V_CONSEGNATO
PUBLIC V_CONSEGNATO
V_CONSEGNATO = ""

RELEASE V_ACURA
PUBLIC V_ACURA
V_ACURA = ""

RELEASE TOT_FATT_EUR
PUBLIC  TOT_FATT_EUR
TOT_FATT_EUR = 0

RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ''
DOC_CAMBIO = ''


RELEASE V_CODNAZ,FATSOSIVA
RELEASE V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 

PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
PUBLIC V_CODNAZ,FATSOSIVA

V_NUMLEI = SPACE(10)
V_DATLEI = SPACE(10)
V_NUCONS = SPACE(10)
V_DTCONS = SPACE(10)

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

NUMPRO=TAGGANCIO
SELECT XU_FAP_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA
CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))
  
RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.
  

RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0
  
  
  
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
RELEASE V_FERIE,NOTAC,X_RIDE
  
  
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
PUBLIC V_FERIE,NOTAC,X_RIDE

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC

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
V_CPAG    = SPACE(40)
V_BANAP   = SPACE(30)
V_NUMFAT  = SPACE(10)
V_DESCAU  = "FATTURA PROFORMA"
NOTAC     = " "
X_RIDE    = " "  && ERASMO - 25/10/2017
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)

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

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0


SELECT XU_FAP_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""  

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
   *V_VETTO  = M.ORD_VETTO
   V_VETTO  = M.ORD_VETTO1  
   V_ACURA  = M.ORD_ACURA   
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP 
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO
   
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	
   
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
   
   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA   
   ___CALCOLA_SOLO_RA		= M.T_NORA 

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI  + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_ana_cl")
      return(.f.)
   ENDIF
   SELECT u_ana_cl
   GO top
   IF !EOF()
    	V_IVASPTRAS      = CLI_IVASPTRAS
	   **=> ERASMO/SERGIO - INIZIO 20/11/2023
	   IF ___CALCOLA_SOLO_RA
	     _RAPERC4     = CLI_RA4   
	   ELSE
		 IF ___NON_CALCOLA_RA_ENPACL 
		   	 _RAPERC4     = 0
		 ELSE
		     _RAPERC4     = CLI_RA4
	     ENDIF
	   ENDIF
	   **=> ERASMO/SERGIO - FINE 20/11/2023
   ELSE
   		V_IVASPTRAS      = ""
   		_RAPERC4         = 0
   ENDIF 
   
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

     DL_LINGUA  = CLI_LINGUA
  
     V_RAGDUE   = CLI_RAGDUE
    
	  
	 IF    ___CALCOLA_SOLO_RA
	 
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
   V_INTESTA    = ALLTRIM(V_INTESTA)+ALLTRIM(V_INDIRI)+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+ALLTRIM(V_PROVIN)+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0 OR !PUB_NOSTPNAZ  
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
   ENDIF
   

   
   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
   V_NAZION_CON = IIF(!EMPTY(V_NAZION_CON),ALLTRIM(V_NAZION_CON),ALLTRIM(V_NAZION))  
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
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0 OR !PUB_NOSTPNAZ  
	         V_CONSEGNATO = V_CONSEGNATO + CHR(13) + V_NAZION_CON
	      ENDIF
	   ENDIF
   ENDIF
   ** ################################################ GESTIONE DATI CONSEGNATO A ################################################ 
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
   *V_VETTO  = M.ORD_VETTO
   V_VETTO  = M.ORD_VETTO1  && ERASMO - 28/01/2015
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  

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
   ___CALCOLA_SOLO_RA		= M.T_NORA
   

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI  + "'"
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

      DL_LINGUA  = CLI_LINGUA
   
      V_RAGDUE   = CLI_RAGDUE

	 IF    ___CALCOLA_SOLO_RA
	 
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

   DL_LINGUA        = CLI_LINGUA
   V_BANFORN  		= CLI_BAEFOR
   V_IBANFOR  		= CLI_IBAFOR
   V_IBANCLI  		= CLI_CDIBAN
   V_BICSWIFT 		= CLI_BSWFOR
   V_CODICE_SWIFT 	= CLI_BSWFOR	
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

v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = DESCRI
ELSE
   V_VETTO = ""
ENDIF

 
__V_ACURA = V_ACURA
v_seek   = 'MEZ'+V_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= __V_ACURA 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       V_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   V_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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
   V_DESCAU    = DESCRI
   NOTAC	   = SUBSTR(LIBERA,11,1)
   TI_PX       = SUBSTR(LIBERA,11,1)
   FATSOSIVA   = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU = SPACE(40)
   NOTAC	   = " "
   TI_PX       = " "
   FATSOSIVA   = " "
ENDIF


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
   	  __codice_swift = BAN_SWIFT	

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
      V_BANAP = SPACE(100)
   ELSE

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
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
  
SELECT XU_FAP_DD
GO TOP

RELEASE ORD_DESART && 205/01/07 SERGIO BACONE SI PERDE LA VARIABILE 
PUBLIC ORD_DESART  && 205/01/07 SERGIO BACONE SI PERDE LA VARIABILE 
ORD_DESART = ""    && 205/01/07 SERGIO BACONE SI PERDE LA VARIABILE 

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


   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE
	   v_seek   = 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	     SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   ENDIF

   SELECT XU_FAP_DD   							&& 2015/02/23 SERGIO - ALTRO BACONE : SI PERDE LA SELECT E CALCOLA MALE IMPOSTA
   
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

   SELECT XU_FAP_DD
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


PUB_IVADEF = CERCA_IVA_DEFAULT("XU_FAP_DD","CODICE")  
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_FAP_DD","ALIQUOTA")  


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
	   PIVA1TRA					= SUBSTR(LIBERA,1,03)
	   DIVA_SPESE_TRASPORTO		= ALLTRIM(SUBSTR(DESCRI,1,80))
	   SAY_IVA_SPESE_TRASPORTO 	= DIVA_SPESE_TRASPORTO
       ALIQTRA					= SUBSTR(LIBERA,1,3)
       NUM_ALIQ 				= VAL(ALIQTRA)
	   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
		DL_TIPODES 		= 'IVA'
		DL_CODICE  		= V_IVASPTRAS
		_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	    IF !EMPTY(_DESCR_LINGUA)
	   		DIVA_SPESE_TRASPORTO		= ALLTRIM(_DESCR_LINGUA)
	   		SAY_IVA_SPESE_TRASPORTO 	= ALLTRIM(_DESCR_LINGUA)
	    ENDIF
	   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
    ELSE
       ALIQTRA					= ""
       NUM_ALIQ 				= 0
       SAY_IVA_SPESE_TRASPORTO 	= ""
	ENDIF

    V_IMPSP = V_SPESE * (NUM_ALIQ/100)

ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *


NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

NUM_ALIQ_ENPACL 	= 0

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
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

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
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
   IF IVA2 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
      ACCO_IVA = .T.
      IMPO2    = IMPO2	+ V_SPESE
      IMPOS2   = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
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
   IF IVA3 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
      ACCO_IVA = .T.
      IMPO3    = IMPO3	+ V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
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
   IF IVA4 = PUB_IVADEF AND EMPTY(V_IVASPTRAS)  
      ACCO_IVA = .T.
      IMPO4    = IMPO4	+ V_SPESE
      IMPOS4   = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
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
			    PIVA1 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA1  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO1  		= IMPO1	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS1 		= IMPOS1 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA2)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA2 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA2  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO2  		= IMPO2	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS2 		= IMPOS2 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA3)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA3 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA3  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO3  		= IMPO3	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS3 		= IMPOS3 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA4)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA4 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA4  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO4  		= IMPO4	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS4 		= IMPOS4 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA5)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA5 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA5  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO5  		= IMPO5	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS5 		= IMPOS5 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    ENDCASE
	    
	ENDIF
	
ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *


IF !ACCO_IVA    && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
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

IMPOS1		 =	ROUND((IMPOS1+.0000),2)
IMPOS2		 =	ROUND((IMPOS2+.0000),2)
IMPOS3		 =	ROUND((IMPOS3+.0000),2)
IMPOS4		 =	ROUND((IMPOS4+.0000),2)		
IMPOS5		 =	ROUND((IMPOS5+.0000),2)
TOT_IMPOS    =   IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5
TOT_FATT     =   TOT_IMPO + TOT_IMPOS - MATPUB
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
   DL_LINGUA  = ""
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&&  posticipi per tutto l'anno
   ___CLIENTE     = ""		&&  posticipi per tutto l'anno  
ELSE
   DL_LINGUA = CLI_LINGUA
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL		    && posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& posticipi per tutto l'anno   
ENDIF

SELECT XU_FAP_DD
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
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XU_FAP_DD",.F.)
	SELECT XU_FAP_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF


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
   
   
IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF
   
   
DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE



IF PUB_CREA_FILE_PDF
	SELECT XU_FAP_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "FAP-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_FAP_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("FAP")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF

SELECT XU_FAP_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

**=> ERASMO - INIZIO 30/01/2015
RELEASE V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
RELEASE V_CONSEGNATO
**=> ERASMO - FINE 30/01/2015

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

LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF

RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	


RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""

   
RELEASE ___CALCOLA_SOLO_RA
PUBLIC ___CALCOLA_SOLO_RA
___CALCOLA_SOLO_RA = .F.


RELEASE V_IVASPTRAS
PUBLIC V_IVASPTRAS
V_IVASPTRAS = ""


RELEASE TOT_FATT_EUR
PUBLIC  TOT_FATT_EUR
TOT_FATT_EUR = 0

RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ''
DOC_CAMBIO = ''


RELEASE V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
PUBLIC V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON

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


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""


NUMPRO=TAGGANCIO

SELECT XU_FAT_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

**=> ERASMO - INIZIO 22/11/2023
RELEASE T_ENPACL,T_RA,T_NETTO,T_RA4,T_IMPO_ENPACL
PUBLIC T_ENPACL,T_RA,T_NETTO,T_RA4,T_IMPO_ENPACL
T_ENPACL = 0
T_RA = 0
T_RA4 = 0
T_NETTO = 0
T_IMPORA = 0
**=> ERASMO - FINE 22/11/2023

T_IMPO_ENPACL = 0  && ERASMO - 25/06/2025

RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.


RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0


PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
RELEASE V_COSTTR
RELEASE V_BANSOC
RELEASE V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
RELEASE V_FERIE,NOTAC,NOTADEB


PUBLIC V_COSTTR
PUBLIC V_BANSOC  
PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
PUBLIC V_FERIE,NOTAC,NOTADEB



RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0

RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   

V_COSTTR = 0

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
V_NUMFAT  = SPACE(10)
V_DESCAU  = "FATTURA DI VENDITA"
NOTAC     = " "
NOTADEB	  = " " 
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_NUMLEI  = SPACE(10)
V_DATLEI  = SPACE(10)
V_NUCONS  = SPACE(10)
V_DTCONS  = SPACE(10)
 
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

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0


SELECT XU_FAT_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""

v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('u_fat_tt',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO
   V_NUMFAT = M.ORD_NUMORD
   V_NUMLEI = M.ORD_NUMLEI
   V_DATLEI = M.ORD_DATLEI
   V_NUCONS = M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

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
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
 
   V_NUMORC = M.ORD_NUMORC	
   V_DATORC = M.ORD_DATORC	
   V_NUMOFC = M.ORD_NUMOFC	
   V_DATOFC = M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC		
 
   V_NUMCOC = M.ORD_NUMCOC	
   V_DATCOC = M.ORD_DATCOC	
   
   V_MERCRE = M.ORD_MERCRE
   V_NSRIF  = M.ORD_RIFERI  
   V_VALUTA = M.ORD_VALUTA
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   V_COSTTR = M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE
   
   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA
   ___CALCOLA_SOLO_RA		= M.T_NORA 
 
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_ana_cl")
      return(.f.)
   ENDIF
   SELECT u_ana_cl
   GO top
   IF !EOF()
    	V_IVASPTRAS      = CLI_IVASPTRAS
   		_RAPERC4         = CLI_RA4			&& % RITENUTA RIVALSA INPS 4%	(NUOVA GESTIONE NO EMPACL)
   ELSE
   		V_IVASPTRAS      = ""
   		_RAPERC4         = 0				&& % RITENUTA RIVALSA INPS 4%	(NUOVA GESTIONE NO EMPACL)
   ENDIF 

   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF

	 
	 IF    ___CALCOLA_SOLO_RA
	 
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



ELSE
   
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NUMFAT = M.ORD_NUMORD
   V_NUMLEI = M.ORD_NUMLEI
   V_DATLEI = M.ORD_DATLEI
   V_NUCONS = M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS
   
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   

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
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
  
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
   V_COSTTR = M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA
   ___CALCOLA_SOLO_RA		= M.T_NORA


   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_ana_cl")
      return(.f.)
   ENDIF
   SELECT u_ana_cl
   GO top
   IF !EOF()
    	V_IVASPTRAS      = CLI_IVASPTRAS
  		_RAPERC4         = CLI_RA4			&& % RITENUTA RIVALSA INPS 4%	(NUOVA GESTIONE NO EMPACL)
   ELSE
   		V_IVASPTRAS      = ""
  		_RAPERC4         = 0				&& % RITENUTA RIVALSA INPS 4%	(NUOVA GESTIONE NO EMPACL)
   ENDIF 

   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF
     
	 IF    ___CALCOLA_SOLO_RA
	 
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


ENDIF


v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
ELSE
   V_VETTO = ""
ENDIF

__V_ACURA = V_ACURA
v_seek   = 'MEZ'+V_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= __V_ACURA 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       V_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   V_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = ALLTRIM(DESCRI)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU  = DESCRI
   NOTAC	 = SUBSTR(LIBERA,11,1)
   NOTADEB	 = SUBSTR(LIBERA,78,1) 
   TI_PX     = SUBSTR(LIBERA,11,1)
   FATSOSIVA = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU  = SPACE(40)
   NOTAC	 = " "
   NOTADEB	 = " " 
   TI_PX     = " "
   FATSOSIVA = " "
ENDIF

**=> ERASMO - INIZIO 16/01/2026
*** CARICAMENTO TABELLA DATI AGGIUNTIVI PARANEW
_FATSPLITPAYMENT = ""
x_codi = "CODICE = 'TOP" + ALLTRIM(V_TOP) + "'"
x_cond = x_codi
cSql = "select FATSPLITPAYMENT from PARANEW where " + x_cond
IF !ExecCommand(cSql,"PARANEW")
	RETURN .F.
ENDIF
SELECT PARANEW
GO TOP
IF !EOF()
	_FATSPLITPAYMENT = FATSPLITPAYMENT
ENDIF
**=> ERASMO - FINE 16/01/2026

IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'FATTURA DI VENDITA'
ENDIF


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

*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO DELLA FATTURA, PERCUI IN ANAGRAFICA CLIENTI NELLA SEZIONE FORNITORI
*!*  INSERISCO LA BANCA SU CUI IL CLIENTE DEVE PAGARE; PERTANTO MI RITROVO AD AVERE PIU' BANCHE AZIENDA A DISPOSIZIONE DEL CLIENTE
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
   
   
SELECT XU_FAT_DD
GO TOP
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


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
   
   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   && CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
	   IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
	   ENDIF
   ENDIF   
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
 
*!*	   ** SERGIO 28/10/2022 INIZIO: CALCOLO RITENUTE ACCONTO/CASSA PREVIDENZIALE
*!*	   IF PUB_RACLI
*!*	   		IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
*!*	   		ELSE
*!*				*!*	CALCOLO RA
*!*				IF _RAPERC   = 0
*!*					WAIT WINDOWS "Percentuale calcolo RA non trovata" nowait
*!*				ELSE 
*!*				    ** CALCOLO RITENUTA ACCONTO 20% SU IMPONIBILE 
*!*					M.T_RA  = ROUND((IMPONIB * _RAPERC) / 100,2)

*!*				    ** CALCOLO RITENUTA ACCONTO 4% SU IMPONIBILE 
*!*					M.T_RA4 = ROUND((IMPONIB * _RAPERC4) / 100,2)
*!*					IMPONIB   = IMPONIB  + M.T_RA4	&& IMPONIBILE + RA
*!*				ENDIF
*!*			ENDIF
*!*	   ENDIF
*!*	   ** SERGIO 28/10/2022 FINE 

	**=> ERASMO - INIZIO 22/11/2023
	IF ART_NON_CALCOLA_RA(ORD_CODART)
	ELSE
		T_IMPORA = T_IMPORA + IMPONIB
		T_IMPO_ENPACL = T_IMPO_ENPACL + IMPONIB  && ERASMO - 25/06/2025
	ENDIF
	**=> ERASMO - FINE 22/11/2023 
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_FAT_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
   ENDIF


   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE
   
	   v_seek   = 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   
   ENDIF
	
   SELECT XU_FAT_DD

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
   

   SELECT XU_FAT_DD
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

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_FAT_DD","CODICE")   
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_FAT_DD","ALIQUOTA")   


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
	   PIVA1TRA					= SUBSTR(LIBERA,1,03)
	   DIVA_SPESE_TRASPORTO		= ALLTRIM(SUBSTR(DESCRI,1,80))
	   SAY_IVA_SPESE_TRASPORTO 	= DIVA_SPESE_TRASPORTO
       ALIQTRA 					= SUBSTR(LIBERA,1,3)
       NUM_ALIQ 				= VAL(ALIQTRA)
	   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
		DL_TIPODES 		= 'IVA'
		DL_CODICE  		= V_IVASPTRAS
		_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	    IF !EMPTY(_DESCR_LINGUA)
	   		DIVA_SPESE_TRASPORTO		= ALLTRIM(_DESCR_LINGUA)
	   		SAY_IVA_SPESE_TRASPORTO 	= ALLTRIM(_DESCR_LINGUA)
	    ENDIF
	   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
    ELSE
       ALIQTRA                  = ""
       NUM_ALIQ 				= 0
       SAY_IVA_SPESE_TRASPORTO 	= ""
	ENDIF

    V_IMPSP = V_SPESE * (NUM_ALIQ/100)

ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *



*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
   IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
   IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
   M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
   M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
ENDIF



NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

NUM_ALIQ_ENPACL 	= 0

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,80))
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
*!*	      IF V_SPESE <> 0
*!*	     	 IMPO1    = IMPO1	+ V_SPESE
*!*	      ENDIF 
*!*	      IF V_IMPSP <> 0
*!*	      	IMPOS1   = IMPOS1 + V_IMPSP
*!*	      ENDIF 
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = ALLTRIM(SUBSTR(DESCRI,1,80))
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

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = ALLTRIM(SUBSTR(DESCRI,1,80))
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
      IMPO3    = IMPO3  + V_SPESE
      IMPOS3   = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = ALLTRIM(SUBSTR(DESCRI,1,80))
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

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = ALLTRIM(SUBSTR(DESCRI,1,80))
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
			    PIVA2 		= ALLTRIM(ALIQTRA)   	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA2  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO2  		= IMPO2	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS2 		= IMPOS2 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA3)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA3 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA3  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO3  		= IMPO3	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS3 		= IMPOS3 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA4)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA4 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA4  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO4  		= IMPO4	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS4 		= IMPOS4 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    	CASE EMPTY(IVA5)						&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
			    PIVA5 		= ALLTRIM(ALIQTRA)		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	    		DIVA5  		= DIVA_SPESE_TRASPORTO	&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	        	IMPO5  		= IMPO5	 + V_SPESE		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
	      		IMPOS5 		= IMPOS5 + V_IMPSP		&& ACCODO VALORI SPESE + SPESE TRASPORTO ALLA PRIMA VARIABILE LIBERA
				ACCO_IVA 	= .T.
	    ENDCASE
	    
	ENDIF
	
ENDIF
** --- 4) SE CLIENTE EXTRA CEE GESTISCE IL CODICE IVA SPESE TRASPORTO SE E' STATO CODIFICATI IN ANAGRAFICA CLIENTI ----------------------- *


IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      PIVA1  = SUBSTR(LIBERA,1,03)
      DIVA1  = ALLTRIM(SUBSTR(DESCRI,1,80))
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

IF _CNT_OMAGGI > 0	&& ERASMO - 05/11/2019
	IF TOT_IMPO < 0        && SOLO MATERIALE PUBBLICITARIO
	   TOT_IMPO = TOT_IMPO * -1
	ENDIF
ENDIF				&& ERASMO - 05/11/2019

**=> ERASMO/SERGIO - INIZIO 09/05/2018
IF ___CALCOLA_SOLO_RA
ELSE
	*!*	CALCOLO ENPACL
	IF _ENPACLPERC <> 0
		*T_ENPACL 		= ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
		T_ENPACL 		= ROUND((T_IMPO_ENPACL * _ENPACLPERC) / 100,2)  && ERASMO - 25/06/2025
		TOT_IMPO 		= TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
		IMPO1    		= IMPO1 + T_ENPACL
		_IVA_ENPACL 	= (T_ENPACL * NUM_ALIQ_ENPACL) / 100
		IMPOS1			= IMPOS1 + _IVA_ENPACL
	ENDIF
ENDIF 
**=> ERASMO/SERGIO - FINE 09/05/2018

**--> ARROTONDAMENTO IVA
IMPOS1		 =	ROUND((IMPOS1+.0000),2)
IMPOS2		 =	ROUND((IMPOS2+.0000),2)
IMPOS3		 =	ROUND((IMPOS3+.0000),2)
IMPOS4		 =	ROUND((IMPOS4+.0000),2)		
IMPOS5		 =	ROUND((IMPOS5+.0000),2)
TOT_IMPOS    =  IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5
TOT_FATT     =  TOT_IMPO + TOT_IMPOS - MATPUB
TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)

*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_FATT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
	TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)	
ENDIF

** SERGIO 28/10/2022 INIZIO
IF !PUB_RACLI
	IF ___CALCOLA_SOLO_RA

		T_ENPACL = 0

		*!*	CALCOLO FATTURA CON RA
		IF _RAPERC   <> 0
			*T_RA 			= ROUND((TOT_IMPO * _RAPERC   ) / 100,2)
			T_RA 			= ROUND((T_IMPORA * _RAPERC   ) / 100,2)  && ERASMO - 22/11/2023
			T_NETTO 		= TOT_FATT - T_RA
			TOT_FATT    	= T_NETTO 
			TOT_FATT_EUR 	= CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
		ENDIF


	ELSE

		*!*	CALCOLO RA
		IF _RAPERC   <> 0
			*_IMPONIBILE_NO_ENPACL 	= ( TOT_IMPO - T_ENPACL )
			_IMPONIBILE_NO_ENPACL 	= ( T_IMPORA - T_ENPACL )  && ERASMO - 22/11/2023
			T_RA 					= ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
			T_NETTO 				= TOT_FATT - T_RA
		ENDIF

	ENDIF 

ELSE

	**=> ERASMO - INIZIO 22/11/2023
	*!*	CALCOLO RA
	IF _RAPERC   <> 0
		T_RA 		= ROUND((T_IMPORA * _RAPERC   ) / 100,2)
		T_NETTO 	= TOT_FATT - M.T_RA
		T_RA4		= ROUND((T_IMPORA * _RAPERC4   ) / 100,2)
		TOT_IMPO	= TOT_IMPO + M.T_RA4	&& IMPONIBILE + RA
	ENDIF
	**=> ERASMO - FINE 22/11/2023

ENDIF
** SERGIO 28/10/2022 FINE



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
   DL_LINGUA = ""
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 
ELSE
   DL_LINGUA = CLI_LINGUA
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno   
ENDIF

SELECT XU_FAT_DD
GO TOP


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_FATT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS

V_DATASCAD = V_DATA

*V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)
**=> ERASMO - INIZIO 16/01/2026
*** PER CALCOLARE LE SCADENZE, IN CASO DI FATTURA SPLIT PAYMENT, TOLGO L'IMPOSTA
IF _FATSPLITPAYMENT = "S"
	__T_IMPOS = 0
ENDIF
V_TUTTO = TRANCHE("PARA",V_PAG,V_DATASCAD,__T_IMPON+__T_IMPOS,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)
**=> ERASMO - FINE 16/01/2026

=CREA_SCADENZE()


*** SE CONDIZIONE DI PAGAMENTO SPECIALE, A SECONDA DEL VALORE DI PUB_SSPORD:
*** 1 - RIGENERA IL COMMENTO CON I RIFERIMENTI ALLE SCADENZE SPECIALI
*** 2 - RIPORTA RIFERIMENTI ALLE SCADENZE SPECIALI NEI VETTORI RELATIVI ALLA GESTIONE DELLE SCADENZE
IF checkConSpe(V_PAG)
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XU_FAT_DD",.F.)
	SELECT XU_FAT_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF
**=> ERASMO - FINE 11/06/2013



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

*** GESTIONE STAMPA DETTAGLI FATTURA RIEPILOGATI IN UNA SOLA RIGA SE CODIFICATO IN APPOSITA OPZIONE COMMESSA
_FLGREGOLA2 = .F.
_FLGREGOLA3 = .F.
IF !EMPTY(ALLTRIM(M.ORD_NUMCOC)) .AND. !EMPTY(ALLTRIM(M.ORD_DATCOC))
   x_ncoc = "codice = '" + ALLTRIM(M.ORD_NUMCOC) + "'"
   x_dcoc = "d_data = '" + RIBALTA2(M.ORD_DATCOC) + "'"
   x_cond = x_ncoc + " and " + x_dcoc 
   Csql   = "select FLGREGOLA2,FLGREGOLA3 from commessa_tt where " + x_cond
   IF !ExecCommand(cSql,"FLG_COMMESSA_TT")
      return(.f.)
   ENDIF
   SELECT FLG_COMMESSA_TT
   GO TOP
   IF !EOF()
      _FLGREGOLA2 = FLGREGOLA2
      _FLGREGOLA3 = FLGREGOLA3
   ENDIF
   IF _FLGREGOLA2 
      SELECT * FROM XU_FAT_DD WHERE (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI) INTO CURSOR XU_FAT_ED READWRITE
      
      SELECT XU_FAT_ED 
      GO TOP
      SCAN
         IF ALLTRIM(DAGGANCIO) <> 'EOF'
            EXIT
         ENDIF
      ENDSCAN
      SCATTER MEMVAR MEMO
      DELETE FROM XU_FAT_ED WHERE ALLTRIM(DAGGANCIO) <> 'EOF' .AND. !EMPTY(ALLTRIM(ORD_CODSOG))
      APPEND BLANK
      DO U_FAT_DD
      REPLACE ORD_SEQUEN WITH 88888
      REPLACE ORD_CODART WITH '.'
      REPLACE ORD_DESART WITH "RIEPILOGO ATTIVITÀ SVOLTE"
      REPLACE ORD_TIPSOG WITH ''
      REPLACE ORD_CODSOG WITH ''
      REPLACE ORD_DESSOG WITH ''
      REPLACE ORD_DES2 WITH ''
      REPLACE ORD_NOTE WITH ''
      REPLACE ORD_NOTEBO WITH ''
      REPLACE ORD_PREZZO WITH TOT_IMPO
      REPLACE ORD_PRZNET WITH TOT_IMPO
      REPLACE ORD_QTAORD WITH 1
      REPLACE ORD_VALORE WITH TOT_IMPO
      REPLACE ORD_UM     WITH "NR"
      REPLACE ORD_NUMBOB WITH 0
      REPLACE ORD_ALTEZZ WITH 0
      REPLACE ORD_LUNGHE WITH 0
      REPLACE ORD_PUBBLI WITH ''
      REPLACE ORD_IVA WITH ''
      REPLACE ORD_SC1 WITH 0
      REPLACE ORD_SC2 WITH 0
      REPLACE ORD_SC3 WITH 0
   ENDIF
ENDIF
IF _FLGREGOLA2
   SELECT XU_FAT_ED
   INDEX ON ORD_SEQUEN TAG I_SEQUEN
   SET ORDER TO I_SEQUEN
   GO TOP
ELSE
   SELECT XU_FAT_DD
   GO TOP
ENDIF



*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
*IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"FAT",M.TAGGANCIO,"CHECK")
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"FAT",M.TAGGANCIO,"CHECK","XU_FAT_DD")  && ERASMO - 30/08/2017
	SELECT XU_FAT_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF


__PROGRAMMA__    = "FATPJEUR"
__REPORTNEW__    = "FATPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))


*!*	LOCAL myListener
*!*	myListener = CREATEOBJECT("MyReportListener")
*!*	myListener.ListenerType = 1  && 1 indica la modalità anteprima
*!*	myListener.AllowModalMessages = .T.  && Permette messaggi modali, se necessari
*!*	myListener.QuietMode = .F.  && Disattiva la modalità silenziosa


IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

IF !_V_CREA_FATTURE_ELETTRONICHE  && ERASMO - 28/11/2018 - IN QUESTO CASO NON DEVO STAMPARE, MA SOLO CREARE IL FILE PDF
	DO CASE
	   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4) 
	      FOR __I = 1 TO _V_NUMCOPIE
	         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
	         **=> ERASMO - INIZIO 01/09/2022
	         IF _V_OPZPROMPT
	            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
	         ELSE
	            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
	         ENDIF
	         **=> ERASMO - FINE 01/09/2022
	      NEXT
	   CASE _V_OPZSTA = 2
	      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
	      *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW OBJECT myListener  && TEST CON REPORT LISTENER
	   CASE _V_OPZSTA = 3
	      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
	      FOR __I = 1 TO _V_NUMCOPIE
	         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
	         **=> ERASMO - INIZIO 01/09/2022
	         IF _V_OPZPROMPT
	            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
	         ELSE
	            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
	         ENDIF
	         **=> ERASMO - FINE 01/09/2022
	      NEXT            
	ENDCASE
ENDIF

IF PUB_CREA_FILE_PDF
	SELECT XU_FAT_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "FAT-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	**=> ERASMO - INIZIO 24/06/2020
	IF PUB_PRDFILM
		_PDF_DESCRIZIONE_ = UPPER(SUBSTR(V_DESCAU,1,3))+"-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	ENDIF
	**=> ERASMO - FINE 24/06/2020
	_PDF_DESCRIZIONE_	= SUBSTR(_PDF_DESCRIZIONE_,1,55)  && ERASMO - 12/12/2018 - TRONCAMENTO PER LIMITE TAG <NomeAttachment> PER FATTURAZIONE ELETTRONICA
	_PDF_SELECT_ 		= IIF(_FLGREGOLA2,"XU_FAT_ED","XU_FAT_DD")  
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("FAT")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF


*=> Stampa tagliando per agenti
SELECT XU_FAT_DD
*IF PUB_TAGAGE
IF PUB_TAGAGE AND !_V_CREA_FATTURE_ELETTRONICHE  && ERASMO - 28/11/2018
   _RISP = MESSAGEBOX("Stampare il tagliando per l'agente?",36,"Attenzione")
   IF _RISP = 6
		__PROGRAMMA__    = "TAG_AGENTI"
		__REPORTNEW__    = "TAG_AGENTI.FRX"
		__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
		   
		DO CASE
		   *CASE _V_OPZSTA = 1 
		   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
		      FOR __I = 1 TO _V_NUMCOPIE
		         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
		         **=> ERASMO - INIZIO 01/09/2022
		         IF _V_OPZPROMPT
		            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
		         ELSE
		            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
		         ENDIF
		         **=> ERASMO - FINE 01/09/2022
		      NEXT
		   CASE _V_OPZSTA = 2
		      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
		   CASE _V_OPZSTA = 3
		      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
		      FOR __I = 1 TO _V_NUMCOPIE
		         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
		         **=> ERASMO - INIZIO 01/09/2022
		         IF _V_OPZPROMPT
		            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
		         ELSE
		            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
		         ENDIF
		         **=> ERASMO - FINE 01/09/2022
		      NEXT            
		ENDCASE
		
		IF PUB_CREA_FILE_PDF
			SELECT XU_FAT_DD
			GO TOP   
		    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
			_PDF_DESCRIZIONE_	= "Tagliando-agente-FAT-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
			_PDF_SELECT_ 		= "XU_FAT_DD"
			_PDF_REPORT_ 		= __REPORT__ 
			_cSubDirectory = SUBDIR_FILE_PDF("FAT")
			IF !EMPTY(_cSubDirectory)
				=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
			ELSE
				=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
			ENDIF
		ENDIF
   ENDIF
ENDIF


= _OPERAT(PUB_CODOPE)
IF _FLGREGOLA2 .AND. _FLGREGOLA3 .AND. !PUB_RISINF .AND. _V_OPZRISDETTFAT  && ERASMO - 13/05/2009
   _RISP = 6  && ERASMO - 13/05/2009
   IF _RISP = 6
*!*	      SELECT DISTINCT ORD_CODSOG,ORD_DESSOG FROM XU_FAT_DD WHERE (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI) GROUP BY ORD_CODSOG,ORD_DESSOG INTO CURSOR CUR_SOGGETTI
*!*	      SELECT CUR_SOGGETTI
*!*	      GO TOP
*!*	      SCAN
*!*	         __SOGGETTO = ORD_CODSOG
*!*	         IF EMPTY(ALLTRIM(__SOGGETTO))
*!*	            LOOP
*!*	         ENDIF
*!*	         SELECT * FROM XU_FAT_DD WHERE (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI) .AND. ORD_CODSOG = __SOGGETTO INTO CURSOR XU_FAT_ED_STA
*!*	         SELECT XU_FAT_ED_STA
*!*	         INDEX ON ORD_SEQUEN TAG I_SEQUEN
*!*	         SET ORDER TO I_SEQUEN
*!*	         GO TOP
*!*	         *** CALCOLO I TOTALI IMPOSTA E SUBTOTALE
*!*	         ___TOT_IMPOS = 0
*!*	         ___TOT_FATT  = 0
*!*	         ___ORD_VALORE= 0
*!*	         SCAN
*!*	            COD_IVA = ORD_IVA
*!*	            IMPONIB = ORD_VALORE
*!*	            DES_ART = SUBSTR(ORD_DESART,1,16)
*!*	            IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
*!*	               LOOP
*!*	            ENDIF
*!*	            v_seek   = 'IVA'+COD_IVA
*!*	            v_chiave = "codice"
*!*	            IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
*!*	               SELECT CUR_PARA
*!*	               ALIQ = SUBSTR(LIBERA,1,3)
*!*	               NUM_ALIQ = VAL(ALIQ)
*!*	            ELSE
*!*	               NUM_ALIQ = 0
*!*	            ENDIF
*!*	            SELECT XU_FAT_ED_STA
*!*	            IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
*!*	            ___TOT_IMPOS  = ___TOT_IMPOS  + IMPOSTA 
*!*	            ___ORD_VALORE = ___ORD_VALORE + ORD_VALORE
*!*	         ENDSCAN
*!*	         ___TOT_FATT = ___ORD_VALORE + ___TOT_IMPOS
*!*	         GO TOP

*!*	         
*!*	         IF !EOF()
*!*	            X_DESCAU  = "Numero fattura: " + ALLTRIM(ORS_NUMORD) + "-del-" + RIBALTA2(ORS_DATORD)
*!*	            X_RISORSA = "Risorsa : " + ALLTRIM(ORD_CODSOG) + "-" + ALLTRIM(ORD_DESSOG)
*!*	            __PROGRAMMA__    = "FATPJEUR_ED"
*!*	            __REPORTNEW__    = "FATPJEUR_ED.FRX"
*!*	            __REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
*!*	            DO CASE
*!*	               CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
*!*	                  FOR __I = 1 TO _V_NUMCOPIE
*!*	                     REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
*!*	                  NEXT
*!*	               CASE _V_OPZSTA = 2
*!*	                  REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
*!*	               CASE _V_OPZSTA = 3
*!*	                  REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
*!*	                  FOR __I = 1 TO _V_NUMCOPIE
*!*	                     REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
*!*	                  NEXT            
*!*	            ENDCASE
*!*	            
*!*	            IF PUB_CREA_FILE_PDF
*!*	            	SELECT XU_FAT_ED_STA
*!*	            	GO TOP   
*!*	                ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
*!*	            	*_PDF_DESCRIZIONE_	= "estr-conto-risorsa-" + ALLTRIM(ORD_CODSOG) + "-FAT-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
*!*	            	_PDF_DESCRIZIONE_	= "estr-conto-risorsa-" + ALLTRIM(ORD_CODSOG) + "-FAT-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC  && ERASMO - 08/01/2019 - TRONCAMENTO PER LIMITE TAG <NomeAttachment> PER FATTURAZIONE ELETTRONICA
*!*	            	_PDF_SELECT_ 		= "XU_FAT_ED_STA"
*!*	            	_PDF_REPORT_ 		= __REPORT__ 
*!*					_cSubDirectory = SUBDIR_FILE_PDF("FAT")
*!*					IF !EMPTY(_cSubDirectory)
*!*						=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
*!*					ELSE
*!*						=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
*!*					ENDIF
*!*	            ENDIF
*!*	         ENDIF
*!*	         SELECT XU_FAT_ED_STA
*!*	         USE
*!*	      ENDSCAN
      **=> ERASMO - INIZIO 21/01/2021
      SELECT *, CAST(0 AS N(19,2)) AS ORD_IMPOSTA, CAST(0 AS N(19,2)) AS ORD_TOTALE, SPACE(20) AS ORD_NUMORC, SPACE(10) AS ORD_DATORC, SPACE(150) AS ORD_RIFAMMFE FROM XU_FAT_DD ;
         WHERE ORD_CODSOG <> "" ORDER BY ORD_CODSOG INTO CURSOR XU_FAT_ED_STA READWRITE
      SELECT XU_FAT_ED_STA
      GO TOP
      SCAN
         IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
            LOOP
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
         SELECT XU_FAT_ED_STA
         REPLACE ORD_IMPOSTA WITH IMPOSTA
         REPLACE ORD_TOTALE WITH ORD_VALORE + IMPOSTA
         
         x_sysf = "ORD_SYSFAT = '" + ALLTRIM(ORD_SYSFAT) + "'"
         x_cond = x_sysf
         Csql   = "select ORD_RIFAMMFE, ORD_NUMORC, ORD_DATORC from BUDGET_CONS where " + x_cond
         IF !ExecCommand(cSql,"TMP_BUDGET_CONS")
            return(.f.)
         ENDIF
         SELECT TMP_BUDGET_CONS
         GO TOP
         IF !EOF()
         	_BC_NUMORC = ORD_NUMORC
         	_BC_DATORC = ORD_DATORC
         	_BC_RIFAMMFE = ORD_RIFAMMFE
            SELECT XU_FAT_ED_STA
            REPLACE ORD_NUMORC WITH ALLTRIM(_BC_NUMORC)
            REPLACE ORD_DATORC WITH ALLTRIM(_BC_DATORC)
            REPLACE ORD_RIFAMMFE WITH ALLTRIM(_BC_RIFAMMFE)
         ENDIF
      ENDSCAN
      SELECT XU_FAT_ED_STA
      GO TOP
      IF !EOF()
         X_DESCAU  = "Estratto conto risorse dettagli fattura n° " + ALLTRIM(ORS_NUMORD) + " del " + RIBALTA2(ORS_DATORD)         
         __PROGRAMMA__    = "FATPJEUR_ED"
         __REPORTNEW__    = "FATPJEUR_ED.FRX"
         __REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
         
            DO CASE
               CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
                  FOR __I = 1 TO _V_NUMCOPIE
                     *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
			         **=> ERASMO - INIZIO 01/09/2022
			         IF _V_OPZPROMPT
			            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
			         ELSE
			            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
			         ENDIF
			         **=> ERASMO - FINE 01/09/2022
                  NEXT
               CASE _V_OPZSTA = 2
                  REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
               CASE _V_OPZSTA = 3
                  REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
                  FOR __I = 1 TO _V_NUMCOPIE
                     *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
			         **=> ERASMO - INIZIO 01/09/2022
			         IF _V_OPZPROMPT
			            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
			         ELSE
			            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
			         ENDIF
			         **=> ERASMO - FINE 01/09/2022
                  NEXT            
            ENDCASE
            
            IF PUB_CREA_FILE_PDF
            	SELECT XU_FAT_ED_STA
            	GO TOP   
                ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
            	_PDF_DESCRIZIONE_	= "estr-conto-risorse-FAT-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC
            	_PDF_SELECT_ 		= "XU_FAT_ED_STA"
            	_PDF_REPORT_ 		= __REPORT__ 
				_cSubDirectory = SUBDIR_FILE_PDF("FAT")
				IF !EMPTY(_cSubDirectory)
					=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
				ELSE
					=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
				ENDIF
            ENDIF
      ENDIF
      SELECT XU_FAT_ED_STA
      USE
      **=> ERASMO - FINE 21/01/2021
      
   ENDIF
ENDIF

SELECT XU_FAT_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF


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
RELEASE V_NUMFAT
RELEASE V_DESCAU


RELEASE ___TOT_IMPOS
RELEASE ___TOT_FATT

PUBLIC ___TOT_IMPOS
PUBLIC ___TOT_FATT
___TOT_IMPOS = TOT_IMPOS
___TOT_FATT  = TOT_FATT


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




RETURN




*******************
PROCEDURE RISTA_RFI
*******************


RELEASE FAT_RFI
PUBLIC FAT_RFI
FAT_RFI = ''


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

NUMPRO=TAGGANCIO

SELECT XU_FAT_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.


RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0

RELEASE V_COSTTR
RELEASE V_BANSOC  
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



PUBLIC V_COSTTR
PUBLIC V_BANSOC 
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

RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0

RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   

V_COSTTR = 0

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
V_BANSOC  = '' && LUCA 2010-12-02
V_NUMFAT  = SPACE(10)
V_DESCAU  = "RICEVUTA FISCALE"
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

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0


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
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   V_COSTTR = M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA


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
   
     DL_LINGUA   = CLI_LINGUA
     
     V_RAGDUE    = ALLTRIM(CLI_RAGDUE)

	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   


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
   V_COSTTR = M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

   ___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA

   
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
     DL_LINGUA  = CLI_LINGUA
     V_RAGDUE   = ALLTRIM(CLI_RAGDUE)

	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   

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

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
   NOTAC	= SUBSTR(LIBERA,11,1)
   TI_PX    = SUBSTR(LIBERA,11,1)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU = SPACE(40)
   NOTAC	= " "
   TI_PX    = " "
ENDIF


IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'RICEVUTA FISCALE'
ENDIF



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
   	  __codice_swift = BAN_SWIFT	 

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
      V_BANAP = SPACE(100)
   ELSE

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
	  ELSE
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
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

** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO , NELLA STAMPA FATTURE  
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 
*!*	 LUCA 2012-12-02 
*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO DELLA FATTURA, PERCUI IN ANAGRAFICA CLIENTI NELLA SEZIONE FORNITORI
*!*  INSERISCO LA BANCA SU CUI IL CLIENTE DEVE PAGARE; PERTANTO MI RITROVO AD AVERE PIU' BANCHE AZIENDA A DISPOSIZIONE DEL CLIENTE
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
*!*	 FINE LUCA 2012-12-02 
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO , NELLA STAMPA FATTURE  
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 

   
   
SELECT XU_FAT_DD
GO TOP
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0



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
   
   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   && CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
	   IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
	   ENDIF
   ENDIF   
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_FAT_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
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

   SELECT XU_FAT_DD

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
 
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
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03


PUB_IVADEF = CERCA_IVA_DEFAULT("XU_FAT_DD","CODICE")   
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_FAT_DD","ALIQUOTA")  


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


*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
   IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
   IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
   M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
   M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
ENDIF

NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

NUM_ALIQ_ENPACL 	= 0

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
   NUM_ALIQ_ENPACL 	= VAL(PIVA1)
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

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
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

IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
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
TOT_FATT    =   TOT_IMPO + TOT_IMPOS - MATPUB
*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_FATT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
ENDIF



*!*	CALCOLO ENPACL
IF _ENPACLPERC <> 0
	T_ENPACL = ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
	TOT_IMPO = TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
	IMPO1    = IMPO1 + T_ENPACL
	_IVA_ENPACL = (T_ENPACL * NUM_ALIQ_ENPACL) / 100
	_IVA_ENPACL	=  ROUND((_IVA_ENPACL+.0000),2)
	TOT_IMPOS   = TOT_IMPOS + _IVA_ENPACL
	IMPOS1		= IMPOS1 + _IVA_ENPACL
	TOT_FATT    = TOT_FATT  + T_ENPACL + _IVA_ENPACL && SOMMO A TOTALE DOCUMENTO IL CONTRIBUTO DEL 2% ENPACL + RELATIVA IVA
ENDIF


*!*	CALCOLO RA
IF _RAPERC   <> 0
	_IMPONIBILE_NO_ENPACL = ( TOT_IMPO - T_ENPACL )
	T_RA = ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
	T_NETTO = TOT_FATT - T_RA
ENDIF






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
   DL_LINGUA  = ""
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 
ELSE
   DL_LINGUA = CLI_LINGUA
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno   
ENDIF

SELECT XU_FAT_DD
GO TOP


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_FATT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS   

V_DATASCAD = V_DATA

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)

*!*	DO PERIODI
*!*	DO VAR_PERI

=CREA_SCADENZE()



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


__PROGRAMMA__    = "RFIPJEUR"
__REPORTNEW__    = "FATRFIS.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE



IF PUB_CREA_FILE_PDF
	SELECT XU_FAT_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "RFI-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_FAT_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("FAT")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF


SELECT XU_FAT_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

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


RELEASE ___TOT_IMPOS
RELEASE ___TOT_FATT
PUBLIC ___TOT_IMPOS
PUBLIC ___TOT_FATT
___TOT_IMPOS = TOT_IMPOS
___TOT_FATT  = TOT_FATT


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

LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF



** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'OFFERTA
RELEASE V_CLIFAT 
PUBLIC V_CLIFAT 
V_CLIFAT = "" 
** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'OFFERTA


RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	


RELEASE SAY_CPA     
PUBLIC SAY_CPA 
SAY_CPA 	= ""

RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""


RELEASE V_DESTI 
PUBLIC V_DESTI
V_DESTI = ""

RELEASE TOT_FATT_EUR
PUBLIC  TOT_FATT_EUR
TOT_FATT_EUR = 0

RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ''
DOC_CAMBIO = ''


RELEASE V_RAGSOC_CON,V_RAGDUE,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
PUBLIC V_RAGSOC_CON,V_RAGDUE,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON

V_RAGDUE        = ""
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


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

v_seek	 = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF


NUMPRO=TAGGANCIO

SELECT XU_OFF_DD


*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.


RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0


PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
RELEASE V_COSTTR
RELEASE V_BANSOC && LUCA 2010-12-02
RELEASE V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
RELEASE V_FERIE,NOTAC


PUBLIC V_COSTTR
PUBLIC V_BANSOC  
PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
PUBLIC V_FERIE,NOTAC


RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0

RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   

V_COSTTR = 0

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
V_NSRIF   = SPACE(200)
V_PAG     = SPACE(3)
V_DATA    = SPACE(10)
V_BANCA   = SPACE(15)
V_CPAG	  = SPACE(40)
V_BANAP   = SPACE(30)
V_BANSOC  = '' 
V_NUMFAT  = SPACE(10)
V_DESCAU  = "PREVENTIVO"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_NUMLEI  = SPACE(10)
V_DATLEI  = SPACE(10)
V_NUCONS  = SPACE(10)
V_DTCONS  = SPACE(10)
 
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

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0


SELECT XU_OFF_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""

v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('U_OFF_TT',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO
   V_NUMFAT = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = "" && M.ORD_DTCONS

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = "" && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'OFFERTA
   V_CLIFAT     = ORD_CLIFAT
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'OFFERTA

   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   *V_RAGDUE_CON = "" && ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)  && ERASMO - 23/02/2017
   M.ORD_ATTENZIONE = ""
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015
   

   V_VETTO  = M.ORD_VETTO1		 
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
 
   V_NUMORC = "" && M.ORD_NUMORC	
   V_DATORC = "" && M.ORD_DATORC	
   V_NUMOFC = "" && M.ORD_NUMOFC	
   V_DATOFC = "" && M.ORD_DATOFC	
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE
   
   ___NON_CALCOLA_RA_ENPACL = .T. && M.T_NORAENPA
   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF

	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF

   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   IF !EMPTY(V_CLIFAT)	
   	   =CERCA_ANAGRAFICA_CLIENTE_FATTURAZIONE(V_CLIFAT)
   ELSE

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

   ENDIF
   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI


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



ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NUMFAT = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = "" && M.ORD_DTCONS
   
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = "" && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'OFFERTA
   V_CLIFAT     = ORD_CLIFAT
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'OFFERTA
   
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   *V_RAGDUE_CON = "" && ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)  && ERASMO - 23/02/2017
   M.ORD_ATTENZIONE = ""
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015
   
   V_VETTO  = M.ORD_VETTO1
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""   
  
   V_NUMORC = "" && M.ORD_NUMORC	
   V_DATORC = "" && M.ORD_DATORC	
   V_NUMOFC = "" && M.ORD_NUMOFC	
   V_DATOFC = "" && M.ORD_DATOFC	
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

   ___NON_CALCOLA_RA_ENPACL = .T. && M.T_NORAENPA
   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF
     
	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
      ENDIF
   ENDIF

   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   IF !EMPTY(V_CLIFAT)	
   	   =CERCA_ANAGRAFICA_CLIENTE_FATTURAZIONE(V_CLIFAT)
   ELSE

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
   
   ENDIF
   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI


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


ENDIF


v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
ELSE
   V_VETTO = ""
ENDIF

__V_ACURA = V_ACURA
v_seek   = 'MEZ'+V_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= __V_ACURA 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       V_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   V_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = ALLTRIM(DESCRI)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
ENDIF


v_seek	 = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_CPA=SUBSTR(DESCRI,1,30)
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
	DL_TIPODES 		= 'COND.PAGAM'
	DL_CODICE  		= M.ORD_CPA
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	IF !EMPTY(_DESCR_LINGUA)
		SAY_CPA     = _DESCR_LINGUA    
	ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   
ELSE         
   SAY_CPA=""
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

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU  = DESCRI
   NOTAC	 = SUBSTR(LIBERA,11,1)
   TI_PX     = SUBSTR(LIBERA,11,1)
   FATSOSIVA = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU  = SPACE(40)
   NOTAC	 = " "
   TI_PX     = " "
   FATSOSIVA = " "
ENDIF


IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'PREVENTIVO'
ENDIF



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
      V_BANAP = SPACE(100)
   ELSE

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
	  ELSE
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	  ENDIF

   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF


** 2) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DIRETTAMENTE DALL'ANAGRAFICA CLIENTE
**    ################################### SOLO PER RIMESSE DIRETTE

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

** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO  
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 
*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO , PERCUI IN ANAGRAFICA CLIENTI NELLA SEZIONE FORNITORI
*!*  INSERISCO LA BANCA SU CUI IL CLIENTE DEVE PAGARE; PERTANTO MI RITROVO AD AVERE PIU' BANCHE AZIENDA A DISPOSIZIONE DEL CLIENTE
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
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO    
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 

   
   
SELECT XU_OFF_DD
GO TOP

M.T_OMAGGIO = 0
M.I_OMAGGIO = 0



DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("OFF",ORD_CODICE)
         SELECT XU_OFF_DD
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
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_OFF_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE
	   v_seek   = 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   ENDIF

   SELECT XU_OFF_DD


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
   

   SELECT XU_OFF_DD
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


PUB_IVADEF = CERCA_IVA_DEFAULT("XU_OFF_DD","CODICE")  
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_OFF_DD","ALIQUOTA")  

*!*	IF !EMPTY(V_ALRID)
*!*	   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
*!*	ELSE
*!*	    V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
*!*	ENDIF

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



*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
   IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
       IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
       IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
       M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
       M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
   ENDIF


NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

NUM_ALIQ_ENPACL 	= 0

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
   NUM_ALIQ_ENPACL 	= VAL(PIVA1)
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

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
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

IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
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
TOT_FATT    =   TOT_IMPO + TOT_IMPOS - MATPUB
TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_FATT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
	TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)	
ENDIF


*!*	CALCOLO ENPACL
IF _ENPACLPERC <> 0
	T_ENPACL = ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
	TOT_IMPO = TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
	IMPO1    = IMPO1 + T_ENPACL
	_IVA_ENPACL = (T_ENPACL * NUM_ALIQ_ENPACL) / 100
	_IVA_ENPACL	=  ROUND((_IVA_ENPACL+.0000),2)
	TOT_IMPOS   = TOT_IMPOS + _IVA_ENPACL
	IMPOS1		= IMPOS1 + _IVA_ENPACL
	TOT_FATT    = TOT_FATT  + T_ENPACL + _IVA_ENPACL && SOMMO A TOTALE DOCUMENTO IL CONTRIBUTO DEL 2% ENPACL + RELATIVA IVA
	TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
ENDIF


*!*	CALCOLO RA
IF _RAPERC   <> 0
	_IMPONIBILE_NO_ENPACL = ( TOT_IMPO - T_ENPACL )
	T_RA = ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
	T_NETTO = TOT_FATT - T_RA
ENDIF






*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT XU_OFF_DD
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

SELECT XU_OFF_DD
APPEND BLANK
REPLACE DAGGANCIO  WITH 'EOF'
REPLACE ORD_SEQUEN WITH 99999
   
*REPLACE ORS_NUMORD WITH M.ORD_NUMORD
*REPLACE ORS_DATORD WITH M.ORD_DATORD
*REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
   
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
   DL_LINGUA = ""
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 
ELSE
   DL_LINGUA = CLI_LINGUA
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno   
ENDIF

SELECT XU_OFF_DD
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
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XU_OFF_DD",.F.)
	SELECT XU_OFF_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	*REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	*REPLACE ORS_DATORD WITH M.ORD_DATORD
	*REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF



x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = 'ITA'"
*x_tipo = "tipo_doc = 'OR'"
x_tipo = "tipo_doc = 'OF'"  && ERASMO - 26/04/2018
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
GO TOP

ANCORA = 1

**=> ERASMO - INIZIO 19/01/2016
*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"OFF",M.TAGGANCIO,"CHECK")
	SELECT XU_OFF_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF
**=> ERASMO - FINE 19/01/2016

__PROGRAMMA__    = "OFFPJEUR"
__REPORTNEW__    = "OFFPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))

IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE

_FLGREGOLA2 = .F.	&& OPZIONE STAMPA RAGRUPPAMENTI PER COMMESSE
_FLGREGOLA3 = .F.	&& OPZIONE STAMPA RAGRUPPAMENTI PER COMMESSE

IF PUB_CREA_FILE_PDF
	SELECT XU_OFF_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "PRE-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= IIF(_FLGREGOLA2,"XU_OFF_ED","XU_OFF_DD")  
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("OFF")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF





SELECT XU_OFF_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

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
RELEASE V_NUMFAT
RELEASE V_DESCAU


RELEASE ___TOT_IMPOS
RELEASE ___TOT_FATT
PUBLIC ___TOT_IMPOS
PUBLIC ___TOT_FATT
___TOT_IMPOS = TOT_IMPOS
___TOT_FATT  = TOT_FATT


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



RETURN




*******************
PROCEDURE RISTA_ORD
*******************

LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF


** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'ORDINE
RELEASE V_CLIFAT 
PUBLIC V_CLIFAT 
V_CLIFAT = "" 
** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'ORDINE


RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	

**=> ERASMO - INIZIO 04/02/2026
RELEASE FATSOSIVA
PUBLIC FATSOSIVA
FATSOSIVA = ""
**=> ERASMO - FINE 04/02/2026

RELEASE V_NOTETESTATA
PUBLIC V_NOTETESTATA
V_NOTETESTATA = ""


RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""


RELEASE V_DESTI
PUBLIC V_DESTI
V_DESTI = ""


RELEASE TOT_ORDT_EUR
PUBLIC  TOT_ORDT_EUR
TOT_ORDT_EUR = 0

RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ''
DOC_CAMBIO = ''


RELEASE V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
PUBLIC V_RAGSOC_CON,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON

RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
PUBLIC X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
RELEASE X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
PUBLIC X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES
RELEASE V_TEL,V_FAX  && ERASMO - 01/09/2014
PUBLIC V_TEL,V_FAX   && ERASMO - 01/09/2014


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


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""


v_seek	 = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF


NUMPRO=TAGGANCIO

SELECT XU_ORD_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.


RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0


PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
RELEASE V_COSTTR
RELEASE V_BANSOC 
RELEASE V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
RELEASE V_FERIE,NOTAC


PUBLIC V_COSTTR
PUBLIC V_BANSOC 
PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
PUBLIC V_FERIE,NOTAC


RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


RELEASE IMPO_MAGG,IMPOS_MAGG
PUBLIC IMPO_MAGG,IMPOS_MAGG
IMPO_MAGG  = 0
IMPOS_MAGG = 0


RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   

V_COSTTR = 0

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
V_DESCAU  = "ORDINE CLIENTE"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_NUMLEI  = SPACE(10)
V_DATLEI  = SPACE(10)
V_NUCONS  = SPACE(10)
V_DTCONS  = SPACE(10)
 
V_SPINCA  = 0
V_SPTRAS  = 0
  
TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0
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

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0

**=> ERASMO - INIZIO 26/02/2019
RELEASE _FLG_PAGANT
PUBLIC _FLG_PAGANT
_FLG_PAGANT = .F.
**=> ERASMO - FINE 26/02/2019

SELECT XU_ORD_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""

v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('U_ORD_TT',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO
   V_NUMORD = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS

   ** GESTISCE CONTEMPORANEAMENTE LE NOTE VARIE E LE NOOTE DI TESTATA  **
   V_NOTETESTATA = ""
   IF !EMPTY(M.ORD_VARIE)
   	   V_NOTETESTATA = ALLTRIM(M.ORD_VARIE)  
	   IF !EMPTY(M.ORD_NOTEEV2)
	   		V_NOTETESTATA = V_NOTETESTATA + " " + ALLTRIM(M.ORD_NOTEEV2)  
	   ENDIF   
   ELSE 
       V_NOTETESTATA = ALLTRIM(M.ORD_NOTEEV2)  
   ENDIF
   ** GESTISCE CONTEMPORANEAMENTE LE NOTE VARIE E LE NOOTE DI TESTATA  **   


   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'ORDINE
   V_CLIFAT     = ORD_CLIFAT
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'ORDINE

   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ""  && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

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
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
 
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE


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

   
   *___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA
   ___NON_CALCOLA_RA_ENPACL = .T.
   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF

	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF


   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   IF !EMPTY(V_CLIFAT)	
   	   =CERCA_ANAGRAFICA_CLIENTE_FATTURAZIONE(V_CLIFAT)
   ELSE

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
  
   ENDIF    
   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI



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



ELSE
   
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NUMORD = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS
  
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'ORDINE
   V_CLIFAT     = ORD_CLIFAT
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELL'ORDINE
  
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = "" && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   ** GESTISCE CONTEMPORANEAMENTE LE NOTE VARIE E LE NOOTE DI TESTATA  **
   V_NOTETESTATA = ""
   IF !EMPTY(M.ORD_VARIE)
   	   V_NOTETESTATA = ALLTRIM(M.ORD_VARIE)  
	   IF !EMPTY(M.ORD_NOTEEV2)
	   		V_NOTETESTATA = V_NOTETESTATA + " " + ALLTRIM(M.ORD_NOTEEV2)  
	   ENDIF   
   ELSE 
       V_NOTETESTATA = ALLTRIM(M.ORD_NOTEEV2)  
   ENDIF
   ** GESTISCE CONTEMPORANEAMENTE LE NOTE VARIE E LE NOOTE DI TESTATA  **   


   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   

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
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
  
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

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


   *___NON_CALCOLA_RA_ENPACL = M.T_NORAENPA
   ___NON_CALCOLA_RA_ENPACL = .T.
   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF
     
	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF
   

   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   IF !EMPTY(V_CLIFAT)	
   	   =CERCA_ANAGRAFICA_CLIENTE_FATTURAZIONE(V_CLIFAT)
   ELSE
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
   ENDIF 
   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   
   


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


ENDIF

**=> ERASMO - INIZIO 20/11/2020
*** DATI AGGIUNTIVI U_ORD_T2
RELEASE M.ORD_FECAUS,M.ORD_RIFAMMFE
PUBLIC M.ORD_FECAUS,M.ORD_RIFAMMFE
M.ORD_FECAUS = ""
M.ORD_RIFAMMFE = ""
**=> ERASMO - INIZIO 09/01/2022
RELEASE M.ORD_RATEIZZA,M.ORD_DESRATA
PUBLIC M.ORD_RATEIZZA,M.ORD_DESRATA
M.ORD_RATEIZZA = .F.
M.ORD_DESRATA = ""
**=> ERASMO - FINE 09/01/2022
x_agga = "TAGGANCIO = '" + M.TAGGANCIO + "'"
x_cond = x_agga
cSql = "select * from U_ORD_T2 where " + x_cond
IF !ExecCommand(cSql,"U_ORD_T2")
   RETURN .F.
ENDIF
SELECT U_ORD_T2
GO TOP
IF !EOF()
	SCATTER FIELDS ORD_FECAUS,ORD_RIFAMMFE MEMVAR
	SCATTER FIELDS ORD_RATEIZZA,ORD_DESRATA MEMVAR  && ERASMO - 09/01/2022
ENDIF
**=> ERASMO - FINE 20/11/2020

v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
   X_VETTO = SUBSTR(DESCRI,1,30)
ELSE
   V_VETTO = ""
   X_VETTO = ""
ENDIF 

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
       V_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   V_ACURA=""
   X_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = ALLTRIM(DESCRI)
   X_PORTO   = ALLTRIM(DESCRI)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
   X_PORTO   = ""
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

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
   V_BANFORN  		= CLI_BAEFOR
   V_IBANFOR  		= CLI_IBAFOR
   V_CODICE_SWIFT 	= CLI_BSWFOR	
   V_IBANCLI  		= CLI_CDIBAN
   V_BICSWIFT 		= CLI_BSWFOR
   V_CFISC    		= CLI_CODFIS
   V_TEL      		= CLI_TELEFO  && ERASMO - 01/09/2014
   V_FAX      		= CLI_FAX     && ERASMO - 01/09/2014
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
   V_TEL      		= ""  && ERASMO - 01/09/2014
   V_FAX      		= ""  && ERASMO - 01/09/2014
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
   _FLG_PAGANT = SUBSTR(LIBERA,252,1)  && ERASMO - 26/02/2019 - FLAG "Pagamento anticipato S/N"
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU  = DESCRI
   NOTAC	 = SUBSTR(LIBERA,11,1)
   TI_PX     = SUBSTR(LIBERA,11,1)
   FATSOSIVA = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU  = SPACE(40)
   NOTAC	 = " "
   TI_PX     = " "
   FATSOSIVA = " "
ENDIF

IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'ORDINE CLIENTE'
ENDIF


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
      V_BANAP = SPACE(100)
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

*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO DELL'ORDINE, PERCUI IN ANAGRAFICA CLIENTI NELLA SEZIONE FORNITORI
*!*  INSERISCO LA BANCA SU CUI IL CLIENTE DEVE PAGARE; PERTANTO MI RITROVO AD AVERE PIU' BANCHE AZIENDA A DISPOSIZIONE DEL CLIENTE
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
   
   
** ####################################################  CONTROLLO INCROCIATO DATI OBBLIGATORI/CENTRI DI COSTO  ############################################   

IF PUB_CTRRISD			&& CONTROLLO INCROCIATO SUI CAMPI OBBLIGATORI ANAGRAFICI E SU CENTRO DI COSTO  
	
	RELEASE __DATI_ANAGRAFICI_OBBLIGATORI,__CAMPI_NON_CODIFICATI 
	PUBLIC __DATI_ANAGRAFICI_OBBLIGATORI,__CAMPI_NON_CODIFICATI 
	__DATI_ANAGRAFICI_OBBLIGATORI = .F.
	__CAMPI_NON_CODIFICATI = ""
	
	__CAMPI_NON_CODIFICATI=CONTROLLO_DATI_ANAGRAFICI_OBBLIGATORI('CUR_CLIENTE')
	IF __DATI_ANAGRAFICI_OBBLIGATORI 
	  	_cMsg = "ATTENZIONE" + CHR(13) + CHR(13) + "Dati anagrafici incompleti :" + CHR(13) + ALLTRIM(__CAMPI_NON_CODIFICATI) + CHR(13) + "impossibile stampare ordine " + CHR(13) + "Fare click su OK per continuare"
	  	DO MESSAGGIO_STILE_WIN8 WITH _cMsg   
	    RETURN(.F.)
	ENDIF

ENDIF

IF PUB_CTRRISD2		&& CONTROLLO INCROCIATO SUL CENTRO DI COSTO SU TUTTE LE RIGHE ORDINE
	RELEASE __CONTROLLA_ESISTENZA_CENTRO_COSTO_SU_TUTTE_LE_RIGHE
	PUBLIC __CONTROLLA_ESISTENZA_CENTRO_COSTO_SU_TUTTE_LE_RIGHE
	__CONTROLLA_ESISTENZA_CENTRO_COSTO_SU_TUTTE_LE_RIGHE = .F.
	=CONTROLLO_ESISTENZA_CENTRO_COSTO_SU_TUTTE_LE_RIGHE("XU_ORD_DD")
	IF __CONTROLLA_ESISTENZA_CENTRO_COSTO_SU_TUTTE_LE_RIGHE 
	  	_cMsg = "ATTENZIONE" + CHR(13) + CHR(13) + "Esistono righe ordine senza il centro di costo" + CHR(13) + "impossibile stampare" + CHR(13) + "Fare click su OK per continuare"
	  	DO MESSAGGIO_STILE_WIN8 WITH _cMsg   
	    RETURN(.F.)
	ENDIF 
    *ENDIF

ENDIF

** ####################################################  CONTROLLO INCROCIATO DATI OBBLIGATORI/CENTRI DI COSTO  ############################################   

   
   
SELECT XU_ORD_DD
GO TOP
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("ORD",ORD_CODICE)
         SELECT XU_ORD_DD
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
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_ORD_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE
	   v_seek   = 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   ENDIF
   
   SELECT XU_ORD_DD


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
   
   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"
	   IF ORD_PRZFIN > 0
	      _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMFIN)
	      IF TYPE(_cNomeCampoQta) == 'N'
	      ELSE
	         _cNomeCampoQta = "ORD_QTAORD"
	      ENDIF
	      IMPONIB = &_cNomeCampoQta * ORD_PRZFIN
	      IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
	      IMPO_MAGG = IMPO_MAGG + IMPONIB 
	      IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
	   ENDIF
	   IF ORD_PRZBAR > 0
	      _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMBAR)
	      IF TYPE(_cNomeCampoQta) == 'N'
	      ELSE
	         _cNomeCampoQta = "ORD_QTAORD"
	      ENDIF
	      IMPONIB = &_cNomeCampoQta * ORD_PRZBAR
	      IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
	      IMPO_MAGG = IMPO_MAGG + IMPONIB 
	      IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
	   ENDIF
	   IF ORD_PRZSEZ > 0
	      _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMSEZ)
	      IF TYPE(_cNomeCampoQta) == 'N'
	      ELSE
	         _cNomeCampoQta = "ORD_QTAORD"
	      ENDIF
	      IMPONIB = &_cNomeCampoQta * ORD_PRZSEZ
	      IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
	      IMPO_MAGG = IMPO_MAGG + IMPONIB 
	      IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
	   ENDIF
   ENDIF


   SELECT XU_ORD_DD
   SKIP +1

ENDDO


IMPO_MAGG = ROUND(IMPO_MAGG,2)
IMPOS_MAGG = ROUND(IMPOS_MAGG,2)



*** SOMMA SPESE DI TRASPORTO + INCASSO
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")  
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORD_DD","ALIQUOTA")  


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

NUM_ALIQ_ENPACL 	= 0

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(DESCRI)
   NUM_ALIQ_ENPACL 	= VAL(PIVA1)
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

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = ALLTRIM(DESCRI)
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

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = ALLTRIM(DESCRI)
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

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = ALLTRIM(DESCRI)
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

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = ALLTRIM(DESCRI)
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

IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      PIVA1  = SUBSTR(LIBERA,1,03)
      DIVA1  = ALLTRIM(DESCRI)
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

TOT_IMPO	= TOT_IMPO + IMPO_MAGG 
TOT_IMPOS	= TOT_IMPOS + IMPOS_MAGG

TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB
TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)

*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA AI SOLI ORDINI
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_ORDT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
	TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)	
ENDIF



*!*	CALCOLO ENPACL
IF _ENPACLPERC <> 0
	T_ENPACL = ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
	TOT_IMPO = TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
	IMPO1    = IMPO1 + T_ENPACL
	_IVA_ENPACL = (T_ENPACL * NUM_ALIQ_ENPACL) / 100
	_IVA_ENPACL	=  ROUND((_IVA_ENPACL+.0000),2)
	TOT_IMPOS   = TOT_IMPOS + _IVA_ENPACL
	IMPOS1		= IMPOS1 + _IVA_ENPACL
	TOT_ORDT    = TOT_ORDT  + T_ENPACL + _IVA_ENPACL && SOMMO A TOTALE DOCUMENTO IL CONTRIBUTO DEL 2% ENPACL + RELATIVA IVA
	TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)
ENDIF


*!*	CALCOLO RA
IF _RAPERC   <> 0
	_IMPONIBILE_NO_ENPACL = ( TOT_IMPO - T_ENPACL )
	T_RA = ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
	T_NETTO = TOT_ORDT - T_RA
ENDIF






*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT XU_ORD_DD
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

SELECT XU_ORD_DD
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
   DL_LINGUA = ""
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 
ELSE
   DL_LINGUA = CLI_LINGUA
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno   
ENDIF

SELECT XU_ORD_DD
GO TOP


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_ORDT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS   

V_DATASCAD = V_DATA
**=> ERASMO - INIZIO 26/02/2019
*** Ricalcola scadenze pagamenti in base alla Data Consegna definita in testata ordine
IF PUB_ORDSCADTC
	V_DATASCAD = V_DTCONS
ENDIF
**=> ERASMO - FINE 26/02/2019
V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)


=CREA_SCADENZE()

**=> ERASMO - INIZIO 26/02/2019
*** SE PARAMETRO "Ricalcola scadenze pagamenti in base alla Data Consegna definita in testata ordine" E SE FLAG "Pagamento anticipato S/N" ALLORA SOVRASCRIVO LA PRIMA DATA DI SCADENZA CON LA DATA ORDINE
IF PUB_ORDSCADTC AND _FLG_PAGANT = 'S'
	SELECT PERIODI
	GO TOP
	IF !EOF()
		REPLACE DSCAD WITH RIBALTA2(M.ORD_DATORD)
	ENDIF
	DATA[1] = DSCAD	
ENDIF
**=> ERASMO - FINE 26/02/2019

*** SE CONDIZIONE DI PAGAMENTO SPECIALE, A SECONDA DEL VALORE DI PUB_SSPORD:
*** 1 - RIGENERA IL COMMENTO CON I RIFERIMENTI ALLE SCADENZE SPECIALI
*** 2 - RIPORTA RIFERIMENTI ALLE SCADENZE SPECIALI NEI VETTORI RELATIVI ALLA GESTIONE DELLE SCADENZE
IF checkConSpe(V_PAG)
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XU_ORD_DD",.F.)
	SELECT XU_ORD_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF



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

**=> SERGIO - INIZIO 30/07/2022
IF PUB_ORDRATEI			&& STAMPA NEI DETTAGLI ARTICOLO LE RATE ORDINI CLIENTI
	
	SELECT XU_ORD_DD
    DELETE FOR DAGGANCIO = 'EOF'
    
    SELECT XU_ORD_DD
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
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI
	REPLACE ORS_RAGSOC WITH M.ORD_RAGSOC
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD		
    
 	=STAMPA_ORDINI_RATEIZZATI("XU_ORD_DD")
   
	SELECT XU_ORD_DD
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
	
ENDIF
   **=> SERGIO - FINE 30/07/2022   




SELECT XU_ORD_DD
GO TOP

ANCORA = 1


*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"ORD",M.TAGGANCIO,"CHECK")
	SELECT XU_ORD_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF

__PROGRAMMA__    = "ORDPJEUR"
__REPORTNEW__    = "ORDPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))

IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE


IF PUB_CREA_FILE_PDF
	SELECT XU_ORD_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORD-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_ORD_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("ORD")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF


SELECT XU_ORD_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF


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


RELEASE ___TOT_IMPOS
RELEASE ___TOT_ORDT

PUBLIC ___TOT_IMPOS
PUBLIC ___TOT_ORDT
___TOT_IMPOS = TOT_IMPOS
___TOT_ORDT  = TOT_ORDT


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

RELEASE V_NOTETESTATA



RETURN




*******************
PROCEDURE RISTA_ORF
*******************

LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF

RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

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


RELEASE TOT_ORDT_EUR
PUBLIC  TOT_ORDT_EUR
TOT_ORDT_EUR = 0

RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ''
DOC_CAMBIO = ''


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


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""


v_seek	 = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF


NUMPRO=TAGGANCIO

SELECT XU_ORF_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))


PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
RELEASE V_COSTTR
RELEASE V_BANSOC 
RELEASE V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
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


PUBLIC V_COSTTR
PUBLIC V_BANSOC 
PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
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


RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

**=> ERASMO - INIZIO 01/12/2025
RELEASE SAY_ASPETT
PUBLIC SAY_ASPETT
**=> ERASMO - FINE 01/12/2025

RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


RELEASE IMPO_MAGG,IMPOS_MAGG
PUBLIC IMPO_MAGG,IMPOS_MAGG
IMPO_MAGG  = 0
IMPOS_MAGG = 0


RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   

V_COSTTR = 0

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
V_NUMLEI  = SPACE(10)
V_DATLEI  = SPACE(10)
V_NUCONS  = SPACE(10)
V_DTCONS  = SPACE(10)
 
V_SPINCA  = 0
V_SPTRAS  = 0
  
TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0
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


SELECT XU_ORF_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""

v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('U_ORF_TT',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO

   V_CODICE = M.ORD_CODCLI
   V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
   V_NUMORD = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = ""  && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE


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

   
   x_soci   = "FOR_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "FOR_codcli = '" + V_CODCLI + "'"
   x_cond   = x_soci + " and " + x_codi   
   cSql     = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORI")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORI
   GO TOP   
   IF EOF()
   ELSE
     
     DL_LINGUA = FOR_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(FOR_RAGDUE)
     ENDIF

     v_seek = 'STA'+ALLTRIM(FOR_NAZION)
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
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = M.ORD_DTCONS
   
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = "" && ALLTRIM(M.ORD_RAGDUE)
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

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


  
   x_soci   = "FOR_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "FOR_codcli = '" + V_CODCLI + "'"
   x_cond   = x_soci + " and " + x_codi   
   cSql     = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORI")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORI
   GO TOP   
   IF EOF()
   ELSE
     
     DL_LINGUA = FOR_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(FOR_RAGDUE)
     ENDIF
     

     v_seek = 'STA'+ALLTRIM(FOR_NAZION)
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


v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
   X_VETTO = SUBSTR(DESCRI,1,30)
ELSE
   V_VETTO = ""
   X_VETTO = ""
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
       V_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   V_ACURA=""
   X_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = ALLTRIM(DESCRI)
   X_PORTO   = ALLTRIM(DESCRI)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
   X_PORTO   = ""
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

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "FOR_codsoc+FOR_codcli"
IF seek_std('U_FOR_AN',v_seek,v_chiave,'CUR_FORNITORE')
   SELECT CUR_FORNITORE
   V_BANFORN  		= FOR_BA2
   V_IBANFOR  		= FOR_BA2IBA
   V_CODICE_SWIFT 	= FOR_BSWFOR	
   
   V_BANCLIE        = FOR_BAE
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
   
   V_BANCLIE        = ""
   V_IBANCLI  		= ""
   V_BICSWIFT 		= ""
   
   V_CODNAZ   		= ""
   V_PIVA_CEE 		= ""
   V_PIVA     		= ""
   V_CODICE_SWIFT 	= ""
   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)
ENDIF

v_seek   = 'CPA'+ALLTRIM(V_PAG)
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
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
ELSE
   V_CPAG = SPACE(40)
   X__DESCPA = ""
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

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU  = DESCRI
   NOTAC	 = SUBSTR(LIBERA,11,1)
   TI_PX     = SUBSTR(LIBERA,11,1)
   FATSOSIVA = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU  = SPACE(40)
   NOTAC	 = " "
   TI_PX     = " "
   FATSOSIVA = " "
ENDIF

IF V_TOP = PUB_CAUCAS
   V_DESCAU = "ORDINE ACQUISTO"
ENDIF


** 1) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DALLA BANCA DI APPOGGIO DEL FORNITORE 
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
      V_BANAP = SPACE(100)
   ELSE

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
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
	      			'IBAN : '+ ALLTRIM(V_IBANFOR)	&& >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> IBAN BANCA NOSTRA DA ANAGRAFICA FORNITORE U_FOR_AN
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

*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO DELL'ORDINE, PERCUI IN ANAGRAFICA FORNITORI NELLA SEZIONE FORNITORI
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
   			'IBAN : '+ ALLTRIM(BAN_IBAN)	  
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
   
   
   
SELECT XU_ORF_DD
GO TOP
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("ORF",ORD_CODICE)
         SELECT XU_ORF_DD
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
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_ORF_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
   ENDIF


   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE

	   v_seek   = 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   
   ENDIF

   SELECT XU_ORF_DD


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
   


   SELECT XU_ORF_DD
   SKIP +1

ENDDO


IMPO_MAGG = ROUND(IMPO_MAGG,2)
IMPOS_MAGG = ROUND(IMPOS_MAGG,2)


*** SOMMA SPESE DI TRASPORTO + INCASSO
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORF_DD","CODICE")   
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORF_DD","ALIQUOTA")   

*!*	IF !EMPTY(V_ALRID)
*!*	   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
*!*	ELSE
*!*	    V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
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


v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
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

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
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

IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
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

TOT_IMPO	= TOT_IMPO + IMPO_MAGG 
TOT_IMPOS	= TOT_IMPOS + IMPOS_MAGG

TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB
TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)

*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA AI SOLI ORDINI
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_ORDT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
	TOT_ORDT_EUR = CAMBIO(DOC_VALUTA,TOT_ORDT,DOC_CAMBIO)	
ENDIF




*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT XU_ORF_DD
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
      M.ORD_UM	  = SPACE(02)
      M.ORD_IVA	  = SPACE(02)
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
      M.ORD_UM	  = SPACE(02)
      M.ORD_IVA	  = SPACE(02)
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

SELECT XU_ORF_DD
APPEND BLANK
REPLACE DAGGANCIO  WITH 'EOF'
REPLACE ORD_SEQUEN WITH 99999
   
REPLACE ORS_NUMORD WITH M.ORD_NUMORD
REPLACE ORS_DATORD WITH M.ORD_DATORD
REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
   
GO TOP

***==>  CREA TRANCHE 

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
x_codi = "FOR_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"
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

SELECT XU_ORF_DD
GO TOP


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_ORDT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS   

V_DATASCAD = V_DATA

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___FORNITORE,__T_IMPON,__T_IMPOS)


=CREA_SCADENZE()


*** SE CONDIZIONE DI PAGAMENTO SPECIALE, A SECONDA DEL VALORE DI PUB_SSPORD:
*** 1 - RIGENERA IL COMMENTO CON I RIFERIMENTI ALLE SCADENZE SPECIALI
*** 2 - RIPORTA RIFERIMENTI ALLE SCADENZE SPECIALI NEI VETTORI RELATIVI ALLA GESTIONE DELLE SCADENZE
IF checkConSpe(V_PAG)
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XU_ORF_DD",.F.)
	SELECT XU_ORF_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF



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

SELECT XU_ORF_DD
GO TOP

ANCORA = 1


*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"ORF",M.TAGGANCIO,"CHECK")
	SELECT XU_ORF_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF

__PROGRAMMA__    = "ORFPJEUR"
__REPORTNEW__    = "ORFPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))

IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE


IF PUB_CREA_FILE_PDF
	SELECT XU_ORF_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORF-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_ORF_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("ORF")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF


SELECT XU_ORF_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF


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


RELEASE ___TOT_IMPOS
RELEASE ___TOT_ORDT

PUBLIC ___TOT_IMPOS
PUBLIC ___TOT_ORDT
___TOT_IMPOS = TOT_IMPOS
___TOT_ORDT  = TOT_ORDT


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



*******************
PROCEDURE RISTA_ORF_ORIGINALE
*******************

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

PUBLIC ULT_PAG
NUMPRO = TAGGANCIO
   
SELECT XU_ORF_DD
SET FILTER TO DAGGANCIO = M.TAGGANCIO  
   

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
        
RELEASE V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC
PUBLIC V_CDC,SAY_CDC,V_NUMCOC,V_DATCOC

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

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
   *FLAG_STAMPA_ORDINI_IN_INGLESE = FOR_FLGTEL
ELSE
   WAIT WINDOWS "Fornitore inesistente "+V_CODCLI
   V_CFISC = " "
   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)
   *FLAG_STAMPA_ORDINI_IN_INGLESE = .F.
ENDIF

___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
___CLIENTE     = ""			&& 2010-08-04 sergio posticipi per tutto l'anno 



v_seek   = 'CPA'+ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
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
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03



PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORF_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORF_DD","ALIQUOTA")  && ERASMO - 21/09/2011


V_IMPSP   = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
   DL_TIPODES 		= 'IVA'
   DL_CODICE  		= IVA1
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
	 DIVA1  = _DESCR_LINGUA
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA1 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA2 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA2
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA2  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA2 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA3 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA3
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA3  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA3 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA4 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA4
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA4  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA4 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA5 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA5
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA5  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA5 = PUB_IVADEF  && ERASMO - 21/09/2011
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_IMPOS   	=   IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5
TOT_ORDT    	=   TOT_IMPO + TOT_IMPOS - MATPUB

***==>  CREA TRANCHE 
RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_ORDT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS   

V_DATASCAD = V_DATA

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)


=CREA_SCADENZE()

**=> ERASMO - INIZIO 11/06/2013
*** SE CONDIZIONE DI PAGAMENTO SPECIALE, A SECONDA DEL VALORE DI PUB_SSPORD:
*** 1 - RIGENERA IL COMMENTO CON I RIFERIMENTI ALLE SCADENZE SPECIALI
*** 2 - RIPORTA RIFERIMENTI ALLE SCADENZE SPECIALI NEI VETTORI RELATIVI ALLA GESTIONE DELLE SCADENZE
IF checkConSpe(V_PAG)
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XU_ORF_DD",.F.)
	SELECT XU_ORF_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	REPLACE ORS_DATORD WITH M.ORD_DATORD
	REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF
**=> ERASMO - FINE 11/06/2013

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

SELECT XU_ORF_DD
GO TOP

DO CASE
   *CASE _V_OPZSTA = 1 
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE



*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORF_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORF-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_ORF_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("ORF")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	**=> ERASMO - FINE 03/02/2012
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

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

PUBLIC ULT_PAG
NUMPRO=TAGGANCIO

SELECT XU_ORD_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)

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
   DL_LINGUA  = CLI_LINGUA
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
  ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = V_CODCLI			&& 2010-08-04 sergio posticipi per tutto l'anno

ELSE
   WAIT WINDOWS "Cliente inesistente"+V_CODCLI
   DL_LINGUA  = ""
   V_CFISC    = " "
   V_TEL      = SPACE(12)
   V_FAX      = SPACE(12)

   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
  ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 

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
       V_PORTO      = _DESCR_LINGUA     
       X_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
   IF SUBSTR(LIBERA,10,1) = 'X'			&& RI.BA.
      X_RIDE = 'N'
   ELSE
      X_RIDE = 'S'
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       X_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
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
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03


PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORD_DD","ALIQUOTA")  && ERASMO - 21/09/2011

*!*	V_IMPSP   = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011

*!*	IF !EMPTY(V_ALRID)
*!*	   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
*!*	ELSE
*!*	    V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
*!*	ENDIF

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


NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek    = 'IVA'+IVA1
v_chiave  = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
   DL_TIPODES 		= 'IVA'
   DL_CODICE  		= IVA1
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
	 DIVA1  = _DESCR_LINGUA
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA1 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA2 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA2
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA2  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA2 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA3 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA3
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA3  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA3 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA4 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA4
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA4  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA4 = PUB_IVADEF  && ERASMO - 21/09/2011
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
   DIVA5 = ALLTRIM(SUBSTR(DESCRI,1,45))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'IVA' ---------- *
	DL_TIPODES 		= 'IVA'
	DL_CODICE  		= IVA5
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
    IF !EMPTY(_DESCR_LINGUA)
		DIVA5  = _DESCR_LINGUA
    ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ----------  'IVA' ---------- *
   IF IVA5 = PUB_IVADEF  && ERASMO - 21/09/2011
      ACCO_IVA = .T.
      IMPO5    = IMPO5+V_SPESE
      IMPOS5   = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

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
TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB

***==>  CREA TRANCHE 


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_ORDT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS   

V_DATASCAD = RIBALTA2(V_DATA)

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)

*!*	DO PERIODI
*!*	DO VAR_PERI

=CREA_SCADENZE()

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
   *CASE _V_OPZSTA = 1
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORD_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORT-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_ORD_DD"
	_PDF_REPORT_ 		= "REPORT\ORDPJEUT.FRX"
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("ORT")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	**=> ERASMO - FINE 03/02/2012
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


*!*	*******************
*!*	PROCEDURE PERIODI
*!*	*******************
*!*	CONTA_TRA = 0

*!*	** RICERCA IMPORTO TRANCHE
*!*	IS        = 0
*!*	XPAROLA   = ''

*!*	DO PAROLA

*!*	IMP_TRANK = VAL(XPAROLA)

*!*	DO WHILE .T.

*!*	   CONTA_TRA = CONTA_TRA + 1

*!*	   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
*!*	   IF CONTA_TRA > CNT
*!*	      RETURN
*!*	   ENDIF

*!*	   IF CONTA_TRA = CNT
*!*	      IMP_TRANK = IMP_TRANK + COMPENSO
*!*	   ENDIF

*!*	   ** RICERCA DATA SCADENZA
*!*	   
*!*	   XPAROLA = ''
*!*	 
*!*	   DO PAROLA
*!*	 
*!*	   DATA_SCAD=XPAROLA

*!*	   DO CREA_PERI

*!*	ENDDO

*!*	RETURN


*!*	*******************
*!*	PROCEDURE PAROLA
*!*	*******************
*!*	DO WHILE .T.
*!*	   IS     = IS + 1
*!*	   CARATT = SUBSTR(V_TUTTO,IS,1)
*!*	   IF !EMPTY(CARATT)
*!*	      XPAROLA = XPAROLA + SUBSTR(V_TUTTO,IS,1)
*!*	   ELSE
*!*	      EXIT
*!*	   ENDIF
*!*	ENDDO

*!*	RETURN


*!*	*******************
*!*	PROCEDURE CREA_PERI
*!*	*******************
*!*	** ===>>> CREA I PERIODI DI SCADENZA
*!*	SELECT PERIODI
*!*	APPEND BLANK
*!*	REPLACE IMP_SCAD  WITH IMP_TRANK
*!*	REPLACE NUM_TRAN  WITH CONTA_TRA
*!*	REPLACE DSCAD     WITH DATA_SCAD

*!*	RETURN


*!*	*******************
*!*	PROCEDURE VAR_PERI
*!*	*******************
*!*	RELEASE DATA	&& ERASMO - 21/02/2010
*!*	RELEASE IMPORTO	&& ERASMO - 21/02/2010

*!*	PUBLIC ARRAY DATA(7)
*!*	PUBLIC ARRAY IMPORTO(7)

*!*	I = 0
*!*	SELECT PERIODI
*!*	GO TOP
*!*	DO WHILE (!EOF()) .AND. (I < 7)
*!*	   I = I + 1
*!*	   DATA[I]     = DSCAD
*!*	   IMPORTO[I]  = IMP_SCAD
*!*	   SELECT PERIODI
*!*	   SKIP +1
*!*	ENDDO

*!*	I = I + 1
*!*	FOR HH = I TO 7
*!*	   DATA[HH]     = SPACE(10)
*!*	   IMPORTO[HH]  = 0
*!*	NEXT

*!*	RETURN


*******************
PROCEDURE RISTA_REC
*******************

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE = ""
ENDIF    

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO        = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
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
      *CASE _V_OPZSTA = 1
      CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
         FOR __I = 1 TO _V_NUMCOPIE
            *REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
	         **=> ERASMO - INIZIO 01/09/2022
	         IF _V_OPZPROMPT
	            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER PROMPT
	         ELSE
	            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
	         ENDIF
	         **=> ERASMO - FINE 01/09/2022
         NEXT
      CASE _V_OPZSTA = 2
         REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE PREVIEW
      CASE _V_OPZSTA = 3
         REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE PREVIEW
         FOR __I = 1 TO _V_NUMCOPIE
            *REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
	         **=> ERASMO - INIZIO 01/09/2022
	         IF _V_OPZPROMPT
	            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER PROMPT
	         ELSE
	            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
	         ENDIF
	         **=> ERASMO - FINE 01/09/2022
         NEXT            
   ENDCASE   
 
	*!*	INIZIO 15/03/2007 SERGIO
	IF PUB_CREA_FILE_PDF
		SELECT XU_BOL_DD
		GO TOP   
	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
		_PDF_DESCRIZIONE_	= "REC-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
		_PDF_SELECT_ 		= "XU_BOL_DD"
		_PDF_REPORT_ 		= "REPORT\BOLPJRES.FRX"
		*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
		**=> ERASMO - INIZIO 03/02/2012
		_cSubDirectory = SUBDIR_FILE_PDF("REC")
		IF !EMPTY(_cSubDirectory)
			=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
		ELSE
			=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
		ENDIF
		**=> ERASMO - FINE 03/02/2012
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


RELEASE DESVET2,INDVET2,DESVET3,INDVET3,SAY_VETTO,SAY_VETTO2,SAY_VETTO3,SAY_TELEFO
PUBLIC DESVET2,INDVET2,DESVET3,INDVET3,SAY_VETTO,SAY_VETTO2,SAY_VETTO3,SAY_TELEFO
DESVET2      = ""
INDVET2      = ""
DESVET3      = ""
INDVET3      = ""
SAY_VETTO    = ""
SAY_VETTO2   = ""
SAY_VETTO3   = ""
SAY_TELEFO   = ""


**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

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
   
v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   SAY_VETTO= DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
   SAY_VETTO=""
ENDIF  


v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO2)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET2 = DESCRI
   SAY_VETTO2= DESCRI   
   INDVET2 = ALLTRIM(LIBERA)
ELSE
   DESVET2 = ""
   INDVET2 = ""
   SAY_VETTO2= ""   
ENDIF  

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO3)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET3 = DESCRI
   SAY_VETTO3= DESCRI   
   INDVET3 = ALLTRIM(LIBERA)
ELSE
   DESVET3 = ""
   INDVET3 = ""
   SAY_VETTO3= ""     
ENDIF  



v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   SAY_PORTO=""
ENDIF  

v_seek   = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_ACURA    = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   SAY_ACURA=""
ENDIF

v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=ALLTRIM(SUBSTR(DESCRI,1,90))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		SAY_CAUS    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   SAY_CAUS=""
ENDIF    
   
v_seek   = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= M.ORD_CPA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      SAY_CPA       = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE = ""
ENDIF    

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO        = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   PORTO = ""
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
   DL_LINGUA  = ""
   XX_UFFIVA = SPACE(50)
   XX_DELDOC = SPACE(50)
   SAY_TELEFO   = "" 					&& SERGIO 15/12/2011
ELSE
   DL_LINGUA = CLI_LINGUA
   XX_UFFIVA = CLI_UFFIVA
   XX_DELDOC = CLI_DELDOC
   SAY_TELEFO   = "Tel.:"+ CLI_TELEFO  	&& SERGIO 15/12/2011
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

__PROGRAMMA__    = "BOLPJRESFOR"
__REPORTNEW__    = "BOLPJRESFOR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE



YYY_PROGRAMMA = "BOLPJRESFOR"
YYY_REPORT    = "BOLPJRESFOR.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "REF-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BOL_DD"
	_PDF_REPORT_ 		= YYY_FILOUT    
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("REF")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	**=> ERASMO - FINE 03/02/2012
ENDIF
*!*	FINE 15/03/2007 SERGIO




	
	
SELECT XU_BOL_DD
GO BOTTOM
IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
   DELETE
ENDIF

RETURN


************************************************************************************************
FUNCTION CREA_FILE_PDF
************************************************************************************************
PARAMETERS _pdf_select,_pdf_report,_pdf_descrizione,_pdf_sotto_directory,_pdf_fsd_main_directory

IF PCOUNT()=4
	_pdf_sotto_directory____= ALLTRIM(_pdf_sotto_directory)
ELSE 
	_pdf_sotto_directory____= ""
ENDIF

**=> ERASMO - INIZIO 01/04/2016
IF PCOUNT() >= 5
ELSE
	_pdf_fsd_main_directory = ""
ENDIF
**=> ERASMO - FINE 01/04/2016

S3S=STR(SELECT())

*!*	PRELEVA LA DIRECTORY OVE MEMORIZZARE I FILE PDF

RELEASE _DIRECTORY_PDF 
PUBLIC _DIRECTORY_PDF 

_KEY_PARA = "FSDEMAIL"
**=> ERASMO - INIZIO 01/04/2016
IF !EMPTY(_pdf_fsd_main_directory)
	_KEY_PARA = UPPER(ALLTRIM(_pdf_fsd_main_directory))
ENDIF
**=> ERASMO - FINE 01/04/2016
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
	RETURN .F.
ENDIF

* -->> creo directory se non esiste
* -------------------------------------
IF DIRECTORY(_DIRECTORY_PDF)
ELSE
	*** SE ESISTE IL VOLUME/UNITA' DI RETE ALLORA CREO LA DIRECTORY
	IF !DIRECTORY(JUSTDRIVE(_DIRECTORY_PDF))
		MESSAGEBOX("Volume o unità di rete '" + JUSTDRIVE(_DIRECTORY_PDF) + "' inesistenti" + CHR(13) + CHR(13) + ;
			"Non sarà possibile creare correttamente i files PDF",48,"Attenzione")
		RETURN .F.
	ELSE
		_COMMAND = "MKDIR &_DIRECTORY_PDF"
		&_COMMAND
	ENDIF
ENDIF

IF  !empty(_pdf_sotto_directory____)
	
	**=> ERASMO - INIZIO 22/10/2020
	IF DIRECTORY(JUSTDRIVE(_pdf_sotto_directory____))  && SE _pdf_sotto_directory____ E' UNA DIRECTORY CON PERCORSO COMPLETO
		_DIRECTORY_PDF = _pdf_sotto_directory____
	ELSE
	**=> ERASMO - FINE 22/10/2020
		
		_DIRECTORY_PDF = _DIRECTORY_PDF+"\"+_pdf_sotto_directory____
		IF DIRECTORY(_DIRECTORY_PDF)
		ELSE
		   *MKDIR &_DIRECTORY_PDF 
			_COMMAND = "MKDIR &_DIRECTORY_PDF"
			&_COMMAND
		ENDIF
	
	ENDIF
	
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
_SAVE_PUB_NOLOGO = PUB_NOLOGO
PUB_NOLOGO		 = .F.
do PRG\creapdf1 with ActiveConfig,tnFileType,txtTabella,txtReportPath,txtExportPath,exeAutomatic,txtEmailOutput,txtOggettoOutput
PUB_NOLOGO       = _SAVE_PUB_NOLOGO 
SET DEFA TO &PUB_DIR



FILE_PDF_APPENA_GENERATO = IIF(EMPTY(FILE_PDF_APPENA_GENERATO),txtExportPath,FILE_PDF_APPENA_GENERATO + " ; " + txtExportPath)  

SELECT &S3S

RETURN



************************
FUNCTION SUBDIR_FILE_PDF
************************
PARAMETERS _par_tipdoc

IF PCOUNT() = 0
	RETURN ""
ENDIF

_SAVE_SELECT=SELECT()

_cRIT = ""

*** CERCO L'EVENTUALE SOTTODIRECTORY CONFIGURATA NELL'APPOSITO PARAMETRO PER QUEL DETERMINATO TIPO DOCUMENTO
v_seek	  = 'FSD' + ALLTRIM(_par_tipdoc)
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
SELECT PARA
IF !EOF()
	IF !EMPTY(LIBERA)
		_cRIT = ALLTRIM(LIBERA)
	ENDIF
ENDIF

SELECT(_SAVE_SELECT)

RETURN _cRIT



*******************
PROCEDURE RISTA_BOF
*******************


RELEASE DESVET2,INDVET2,DESVET3,INDVET3,SAY_VETTO,SAY_VETTO2,SAY_VETTO3,SAY_TELEFO
PUBLIC DESVET2,INDVET2,DESVET3,INDVET3,SAY_VETTO,SAY_VETTO2,SAY_VETTO3,SAY_TELEFO
DESVET2      = ""
INDVET2      = ""
DESVET3      = ""
INDVET3      = ""
SAY_VETTO    = ""
SAY_VETTO2   = ""
SAY_VETTO3   = ""
SAY_TELEFO   = ""


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

**=> ERASMO - INIZIO 09/04/2024
RELEASE SAY_NAZIONE
PUBLIC SAY_NAZIONE
SAY_NAZIONE = ''

IF !EMPTY(M.ORD_CODNAZ)
	V_SEEK   = 'STA'+M.ORD_CODNAZ
	V_CHIAVE = 'CODICE'
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   SAY_NAZIONE=ALLTRIM(DESCRI)
	ENDIF
ELSE 
   SAY_NAZIONE				= ""
ENDIF 
**=> ERASMO - FINE 09/04/2024

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
   
v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   SAY_VETTO= DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
   SAY_VETTO=""
ENDIF  


v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO2)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET2 = DESCRI
   SAY_VETTO2= DESCRI   
   INDVET2 = ALLTRIM(LIBERA)
ELSE
   DESVET2 = ""
   INDVET2 = ""
   SAY_VETTO2= ""   
ENDIF  

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO3)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET3 = DESCRI
   SAY_VETTO3= DESCRI   
   INDVET3 = ALLTRIM(LIBERA)
ELSE
   DESVET3 = ""
   INDVET3 = ""
   SAY_VETTO3= ""     
ENDIF  

**=> ERASMO - INIZIO 19/09/2022
IF EMPTY(M.ORD_VETTO1) AND EMPTY(M.ORD_VETTO2) AND EMPTY(M.ORD_VETTO3) AND !EMPTY(M.ORD_VETXTR)
	DESVET = ALLTRIM(M.ORD_VETXTR)
	INDVET = ""
	DESVET2 = ""
	INDVET2 = ""
	DESVET3 = ""
	INDVET3 = ""
ENDIF
**=> ERASMO - FINE 19/09/2022

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   SAY_PORTO=""
ENDIF  

v_seek   = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_ACURA    = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   SAY_ACURA=""
ENDIF

v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=ALLTRIM(SUBSTR(DESCRI,1,90))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		SAY_CAUS    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   SAY_CAUS=""
ENDIF    
   
v_seek   = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= M.ORD_CPA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      SAY_CPA       = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE = ""
ENDIF    

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO        = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   PORTO = ""
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


**=> ERASMO - INIZIO 31/01/2013
x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select FOR_TELEFO from u_for_an where " + x_cond 
IF !ExecCommand(cSql,"u_for_an")
   return(.f.)
ENDIF
SELECT u_for_an
GO TOP
IF EOF()
   SAY_TELEFO = ""
ELSE
   SAY_TELEFO = "Tel.:" + FOR_TELEFO
ENDIF
**=> ERASMO - FINE 31/01/2013

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

__PROGRAMMA__    = "BOLXILCTLFO"
__REPORTNEW__    = "BOLXILCTLFO.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE



YYY_PROGRAMMA = "BOLXILCTLFO"
YYY_REPORT    = "BOLXILCTLFO.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)


IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "CTL-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BOL_DD"
	_PDF_REPORT_ 		= YYY_FILOUT    
	_cSubDirectory = SUBDIR_FILE_PDF("CTL")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF




	
	
SELECT XU_BOL_DD
GO BOTTOM
IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
   DELETE
ENDIF

RETURN


*******************
PROCEDURE RISTA_BCL
*******************
RELEASE DESVET2,INDVET2,DESVET3,INDVET3,SAY_VETTO,SAY_VETTO2,SAY_VETTO3,SAY_TELEFO
PUBLIC DESVET2,INDVET2,DESVET3,INDVET3,SAY_VETTO,SAY_VETTO2,SAY_VETTO3,SAY_TELEFO
DESVET2      = ""
INDVET2      = ""
DESVET3      = ""
INDVET3      = ""
SAY_VETTO    = ""
SAY_VETTO2   = ""
SAY_VETTO3   = ""
SAY_TELEFO   = ""

RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

RELEASE SAY_PORTO,SAY_ACURA,SAY_CAUS,SAY_CPA,SAY_BANCA,SAY_CCODES,SAY_ASPETT,SAY_TIPOLOGIA
PUBLIC  SAY_PORTO,SAY_ACURA,SAY_CAUS,SAY_CPA,SAY_BANCA,SAY_CCODES,SAY_ASPETT,SAY_TIPOLOGIA
SAY_PORTO    = ""
SAY_ACURA    = ""
SAY_CAUS     = ""
SAY_CPA      = ""
SAY_BANCA    = ""
SAY_CCODES   = ""
SAY_ASPETT   = ""
SAY_TIPOLOGIA = ""  && ERASMO - 06/07/2023

v_seek   = 'ASP'+M.ORD_ASPETT
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
   DESVET = DESCRI
   SAY_VETTO= DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
   SAY_VETTO=""
ENDIF  

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO2)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET2 = DESCRI
   SAY_VETTO2= DESCRI   
   INDVET2 = ALLTRIM(LIBERA)
ELSE
   DESVET2 = ""
   INDVET2 = ""
   SAY_VETTO2= ""   
ENDIF  

v_seek	 = 'VET' + ALLTRIM(M.ORD_VETTO3)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET3 = DESCRI
   SAY_VETTO3= DESCRI   
   INDVET3 = ALLTRIM(LIBERA)
ELSE
   DESVET3 = ""
   INDVET3 = ""
   SAY_VETTO3= ""     
ENDIF

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   SAY_PORTO=""
ENDIF  

v_seek   = 'MEZ'+M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= M.ORD_ACURA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_ACURA    = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   SAY_ACURA=""
ENDIF

v_seek   = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS=ALLTRIM(SUBSTR(DESCRI,1,90))
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		SAY_CAUS    = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   SAY_CAUS=""
ENDIF    

**=> ERASMO - INIZIO 06/07/2023
v_seek	 = 'TPO'+M.ORD_TIPOLOGIA 
v_chiave ="codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_TIPOLOGIA = ALLTRIM(DESCRI)
ELSE
   SAY_TIPOLOGIA = "CONTO LAVORAZIONE"
ENDIF
**=> ERASMO - FINE 06/07/2023
   
v_seek   = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= M.ORD_CPA
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      SAY_CPA       = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE = ""
ENDIF    

v_seek   = 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PORTO = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= ALLTRIM(M.ORD_PORTO)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       PORTO        = _DESCR_LINGUA     
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   PORTO = ""
ENDIF  

v_seek   = 'AGE'+M.ORD_AGE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   AGENTE = DESCRI
ELSE
   AGENTE = ""
ENDIF

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

SELECT XU_BOL_DD
SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   
   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
   	  IF STAM_NOTE("BOL",ORD_CODICE)
         SELECT XU_BOL_DD
         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
         SKIP 
         LOOP
      ENDIF          	 
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

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select FOR_TELEFO from u_for_an where " + x_cond 
IF !ExecCommand(cSql,"u_for_an")
   return(.f.)
ENDIF
SELECT u_for_an
GO TOP
IF EOF()
   SAY_TELEFO = ""
ELSE
   SAY_TELEFO = "Tel.:" + FOR_TELEFO
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

__PROGRAMMA__    = "BOLPJITA"
__REPORTNEW__    = "BOLPJITA.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE

YYY_PROGRAMMA = "BOLPJITA"
YYY_REPORT    = "BOLPJITA.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "CTL-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BOL_DD"
	_PDF_REPORT_ 		= YYY_FILOUT
	_cSubDirectory = SUBDIR_FILE_PDF("CTL")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF
	
SELECT XU_BOL_DD
GO BOTTOM
IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
   DELETE
ENDIF

RETURN



*******************
PROCEDURE RISTA_INR
******************* 

LPARAMETERS _par_custom_report

IF PCOUNT() = 0
	_par_custom_report = ""
ENDIF

** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELLA RICHIESTA INTERVENTO
RELEASE V_CLIFAT 
PUBLIC V_CLIFAT 
V_CLIFAT = "" 
** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELLA RICHIESTA INTERVENTO


RELEASE V_VALUTA
PUBLIC V_VALUTA
V_VALUTA = PUB_VALRIF


RELEASE NUM_ALIQ	&& 2014/11/16 SERGIO - BACONE 
PUBLIC NUM_ALIQ		&& 2014/11/16 SERGIO - BACONE 
NUM_ALIQ = 0		&& 2014/11/16 SERGIO - BACONE 	


RELEASE SAY_CPA     
PUBLIC SAY_CPA 
SAY_CPA 	= ""

RELEASE V_CIG,V_CUP
PUBLIC V_CIG,V_CUP
V_CIG	= "" 
V_CUP	= ""


RELEASE V_DESTI 
PUBLIC V_DESTI
V_DESTI = ""

RELEASE TOT_FATT_EUR
PUBLIC  TOT_FATT_EUR
TOT_FATT_EUR = 0

RELEASE DOC_VALUTA,DOC_CAMBIO
PUBLIC DOC_VALUTA,DOC_CAMBIO
DOC_VALUTA = ''
DOC_CAMBIO = ''


RELEASE V_RAGSOC_CON,V_RAGDUE,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON
PUBLIC V_RAGSOC_CON,V_RAGDUE,V_RAGDUE_CON,V_INDIR_CON,V_CAP_CON,V_LOCALI_CON,V_PROVIN_CON,V_NAZION_CON,V_PARIVA_CON,V_CODFIS_CON,V_IVACEE_CON

V_RAGDUE        = ""
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


RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""

v_seek	 = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+" - "+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
   V_TESTATA4 = ALLTRIM(AZI_LIBERA)
ENDIF


NUMPRO=TAGGANCIO

**=> ERASMO - INIZIO 13/05/2024
RELEASE _FIRST_ORAPARSEDE,_FIRST_ORAINIINT,_LAST_ORAFININT,_FIRST_ORAINIPRO
PUBLIC _FIRST_ORAPARSEDE,_FIRST_ORAINIINT,_LAST_ORAFININT,_FIRST_ORAINIPRO
_FIRST_ORAPARSEDE = ""
_FIRST_ORAINIINT = ""
_LAST_ORAFININT = ""
_FIRST_ORAINIPRO = ""  && ERASMO - 20/05/2024

x_aggan = "daggancio = '" + ALLTRIM(NUMPRO) + "'"
cSql="SELECT COALESCE(MIN(ORD_ORAPARSEDE),'') AS ORD_ORAPARSEDE,COALESCE(MIN(ORD_ORAINIINT),'') AS ORD_ORAINIINT, COALESCE(MAX(ORD_ORAFININT),'') AS ORD_ORAFININT, COALESCE(MIN(ORD_ORAINIPRO),'') AS ORD_ORAINIPRO FROM VENDITE_DT WHERE " + x_aggan
IF !ExecCommand(cSql,"TMP_VENDITE_DT")
   return(.f.)
ENDIF 
SELECT TMP_VENDITE_DT
GO TOP
IF !EOF()
	_FIRST_ORAPARSEDE = IIF(ORD_ORAPARSEDE <> "00:00:00" AND ALLTRIM(ORD_ORAPARSEDE) <> ":  :",ALLTRIM(ORD_ORAPARSEDE),"")
	_FIRST_ORAINIINT = IIF(ORD_ORAINIINT <> "00:00:00" AND ALLTRIM(ORD_ORAINIINT) <> ":  :",ALLTRIM(ORD_ORAINIINT),"")
	_LAST_ORAFININT = IIF(ORD_ORAFININT <> "00:00:00" AND ALLTRIM(ORD_ORAFININT) <> ":  :",ALLTRIM(ORD_ORAFININT),"")
	_FIRST_ORAINIPRO = IIF(ORD_ORAINIPRO <> "00:00:00" AND ALLTRIM(ORD_ORAINIPRO) <> ":  :",ALLTRIM(ORD_ORAINIPRO),"")  && ERASMO - 20/05/2024
ENDIF
SELECT TMP_VENDITE_DT
USE
**=> ERASMO - FINE 13/05/2024

**=> ERASMO - INIZIO 20/05/2024
RELEASE V_COMPONENTI_ALL
PUBLIC V_COMPONENTI_ALL
V_COMPONENTI_ALL = ""

x_agga = "TT.TAGGANCIO = '" + ALLTRIM(NUMPRO) + "'"
cSql=""
cNomeCursorSql="TMP_COMPONENTI_ALL"
TEXT TO cSql NOSHOW
	SELECT * FROM (
		SELECT
			COALESCE(DC.ID_RIGO,'') AS ID_RIGO
			,COALESCE(DI.TIPO_COMPONENTE,'') AS TIPO_COMPONENTE
			,COALESCE(P_TCI.DESCRI,'') AS DES_TIPO_COMP
			,CASE DC.TIPO_COMPONENTE WHEN '002' THEN COALESCE(DI.CMODBRU,'') ELSE COALESCE(DI.CMODCAL,'') END AS MODELLO
			,CASE DC.TIPO_COMPONENTE WHEN '002' THEN COALESCE(DI.CMATBRU,'') ELSE COALESCE(DI.CMATCAL,'') END AS MATRICOLA
			,COALESCE(DI.CDITTACAL,'') AS CDITTACAL
			,COALESCE(DI.CDITTABRU,'') AS CDITTABRU
			,COALESCE(TE.POT_FOC_KW,0) AS POT_FOC_KW
		FROM VENDITE_TT AS TT
			LEFT OUTER JOIN VENDITE_DT AS DT ON DT.DAGGANCIO = TT.TAGGANCIO
			LEFT OUTER JOIN VENDITE_DC AS DC ON DC.LINK_DT_DC = DT.ORD_SYSCOMPONENTI
			LEFT OUTER JOIN IMPIANTI_DD AS DI ON DI.ORD_LINKCOMP = DC.LINKCOMP AND DI.TIPO_COMPONENTE = DC.TIPO_COMPONENTE AND DI.ID_RIGO = DC.ID_RIGO
			LEFT OUTER JOIN IMPIANTI_TE AS TE ON DI.ID_PMKEY = TE.ID_PMKEY AND DI.TIPO_COMPONENTE = TE.TIPO_COMPONENTE AND DI.ID_RIGO = TE.ID_RIGO
			LEFT OUTER JOIN PARA AS P_TCI ON P_TCI.CODICE = 'TCI'+DI.TIPO_COMPONENTE
		WHERE <<x_agga>>
	) AS MAIN
	GROUP BY
		ID_RIGO,
		TIPO_COMPONENTE,
		DES_TIPO_COMP,
		MODELLO,
		MATRICOLA,
		CDITTACAL,
		CDITTABRU,
		POT_FOC_KW
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF
SELECT TMP_COMPONENTI_ALL
GO TOP
SCAN
	IF !EMPTY(V_COMPONENTI_ALL)
		V_COMPONENTI_ALL = ALLTRIM(V_COMPONENTI_ALL) + CHR(13)
	ENDIF
	V_COMPONENTI_ALL = ALLTRIM(V_COMPONENTI_ALL) + ALLTRIM(DES_TIPO_COMP)
	IF !EMPTY(ALLTRIM(CDITTACAL)) OR !EMPTY(ALLTRIM(CDITTABRU))
		V_COMPONENTI_ALL = ALLTRIM(V_COMPONENTI_ALL) + " - Ditta: " + IIF(!EMPTY(ALLTRIM(CDITTACAL)),ALLTRIM(CDITTACAL),ALLTRIM(CDITTABRU))
	ENDIF
	IF !EMPTY(ALLTRIM(MODELLO))
		V_COMPONENTI_ALL = ALLTRIM(V_COMPONENTI_ALL) + " - Mod.: " + ALLTRIM(MODELLO)
	ENDIF
	IF !EMPTY(ALLTRIM(MATRICOLA))
		V_COMPONENTI_ALL = ALLTRIM(V_COMPONENTI_ALL) + " - Matr.: " + ALLTRIM(MATRICOLA)
	ENDIF
	IF POT_FOC_KW > 0
		V_COMPONENTI_ALL = ALLTRIM(V_COMPONENTI_ALL) + " - Pot. KW: " + ALLTRIM(STR(POT_FOC_KW,10,2))
	ENDIF
ENDSCAN
USE
**=> ERASMO - FINE 20/05/2024

**=> ERASMO - INIZIO 20/05/2024
RELEASE V_CODICI_TECNICI
PUBLIC V_CODICI_TECNICI
V_CODICI_TECNICI = ""

x_agga = "TT.TAGGANCIO = '" + ALLTRIM(NUMPRO) + "'"
cSql=""
cNomeCursorSql="TMP_TECNICI_ALL"
TEXT TO cSql NOSHOW
	SELECT * FROM (
		SELECT
			COALESCE(DT.ORD_TECNICO,'') AS TECNICO
		FROM VENDITE_TT AS TT
			LEFT OUTER JOIN VENDITE_DT AS DT ON DT.DAGGANCIO = TT.TAGGANCIO
		WHERE <<x_agga>>
	) AS MAIN
	GROUP BY
		TECNICO
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF
SELECT TMP_TECNICI_ALL
GO TOP
SCAN
	IF !EMPTY(V_CODICI_TECNICI)
		V_CODICI_TECNICI = ALLTRIM(V_CODICI_TECNICI) + "-"
	ENDIF
	V_CODICI_TECNICI = ALLTRIM(V_CODICI_TECNICI) + ALLTRIM(TECNICO)
ENDSCAN
USE
**=> ERASMO - FINE 20/05/2024

SELECT XVENDITE_DD


*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

RELEASE ___NON_CALCOLA_RA_ENPACL
PUBLIC ___NON_CALCOLA_RA_ENPACL
___NON_CALCOLA_RA_ENPACL = .F.


RELEASE _IVA_ENPACL,NUM_ALIQ_ENPACL
PUBLIC _IVA_ENPACL,NUM_ALIQ_ENPACL
_IVA_ENPACL = 0
NUM_ALIQ_ENPACL = 0


PUBLIC V_NUMLEI,V_DATLEI,V_NUCONS,V_DTCONS 
RELEASE V_COSTTR
RELEASE V_BANSOC && LUCA 2010-12-02
RELEASE V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
RELEASE V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
RELEASE IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
RELEASE V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
RELEASE V_SPINCA,V_SPTRAS
RELEASE DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
RELEASE PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
RELEASE DS1,DS2,DS3,DS4,DS5
RELEASE IS1,IS2,IS3,IS4,IS5
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
RELEASE V_FERIE,NOTAC


PUBLIC V_COSTTR
PUBLIC V_BANSOC  
PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU,V_ACURA
PUBLIC V_FERIE,NOTAC


RELEASE V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
PUBLIC V_NUMORC,V_DATORC,V_NUMOFC,V_DATOFC,V_CDC,SAY_CDC
RELEASE V_NUMCOC,V_DATCOC
PUBLIC V_NUMCOC,V_DATCOC

RELEASE SAY_PORTO
PUBLIC  SAY_PORTO

**=> ERASMO - INIZIO 31/08/2023
RELEASE V_FATLEG,V_ORD_RAPPORT_ALL
PUBLIC V_FATLEG,V_ORD_RAPPORT_ALL
V_FATLEG = ""
V_ORD_RAPPORT_ALL = ""
**=> ERASMO - FINE 31/08/2023

RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0

RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO

_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   

V_COSTTR = 0

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
V_NSRIF   = SPACE(200)
V_PAG     = SPACE(3)
V_DATA    = SPACE(10)
V_BANCA   = SPACE(15)
V_CPAG	  = SPACE(40)
V_BANAP   = SPACE(30)
V_BANSOC  = '' 
V_NUMFAT  = SPACE(10)
V_DESCAU  = "PREVENTIVO"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_NUMLEI  = SPACE(10)
V_DATLEI  = SPACE(10)
V_NUCONS  = SPACE(10)
V_DTCONS  = SPACE(10)
 
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

RELEASE _RAPERC,_ENPACLPERC
PUBLIC _RAPERC,_ENPACLPERC

_RAPERC     = 0
_ENPACLPERC = 0


SELECT XVENDITE_DD
GO TOP

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP     = ''
V_INTESTA = ""
V_CONSEGNATO = ""

v_seek   = M.TAGGANCIO
v_chiave = "taggancio"
IF seek_std('VENDITE_TT',v_seek,v_chiave,'CUR_TESTATA')
   SELECT CUR_TESTATA
   SCATTER MEMVAR MEMO
   V_NUMFAT = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = "" && M.ORD_DTCONS

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   
   
   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = "" && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELLA RICHIESTA INTERVENTO
   V_CLIFAT     = ORD_CLIFAT
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELLA RICHIESTA INTERVENTO

   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = "" && ALLTRIM(M.ORD_ATTENZIONE)
   M.ORD_ATTENZIONE = ""
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015
   

   V_VETTO  = M.ORD_VETTO1		 
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  
 
   V_NUMORC = "" && M.ORD_NUMORC	
   V_DATORC = "" && M.ORD_DATORC	
   V_NUMOFC = "" && M.ORD_NUMOFC	
   V_DATOFC = "" && M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC		
 
   V_NUMCOC = "" && M.ORD_NUMCOC	 
   V_DATCOC = "" && M.ORD_DATCOC	 
   
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE
   
   ___NON_CALCOLA_RA_ENPACL = .T. && M.T_NORAENPA
   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF

	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
   ENDIF

   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   IF !EMPTY(V_CLIFAT)	
   	   =CERCA_ANAGRAFICA_CLIENTE_FATTURAZIONE(V_CLIFAT)
   ELSE

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

   ENDIF
   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI


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



ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NUMFAT = M.ORD_NUMORD
   V_NUMLEI = "" && M.ORD_NUMLEI
   V_DATLEI = "" && M.ORD_DATLEI
   V_NUCONS = "" && M.ORD_NUCONS
   V_DTCONS = "" && M.ORD_DTCONS
   
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)
   V_RAGDUE = "" && ALLTRIM(M.ORD_RAGDUE)
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)
   V_CAP    = ALLTRIM(M.ORD_CAP)
   V_LOCALI = ALLTRIM(M.ORD_LOCALI)
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA

   V_CIG	= M.ORD_CIG 
   V_CUP	= M.ORD_CUP   

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO

   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELLA RICHIESTA INTERVENTO
   V_CLIFAT     = ORD_CLIFAT
   ** 2015/07/10 SERGIO : CLIENTE PER FATTURAZIONE ALTERNATIVA DIGITATO NELLA RICHIESTA INTERVENTO
   
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = "" && ALLTRIM(M.ORD_ATTENZIONE)
   M.ORD_ATTENZIONE = ""
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   V_PROVIN_CON = ALLTRIM(M.ORD_PROC)	&& ERASMO - 20/03/2015
   V_NAZION_CON = ALLTRIM(M.ORD_DSNAZC)	&& ERASMO - 20/03/2015
   
   V_VETTO  = M.ORD_VETTO1
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""   
  
   V_NUMORC = "" && M.ORD_NUMORC	
   V_DATORC = "" && M.ORD_DATORC	
   V_NUMOFC = "" && M.ORD_NUMOFC	
   V_DATOFC = "" && M.ORD_DATOFC	
   V_CDC	= M.ORD_CDC		
 
   V_NUMCOC = "" && M.ORD_NUMCOC	 
   V_DATCOC = "" && M.ORD_DATCOC
      
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
   V_COSTTR = 0 && M.ORD_COSTTR   && COSTO DI TRASPORTO DA ADDEBITARE ALL'AGENTE

   ___NON_CALCOLA_RA_ENPACL = .T. && M.T_NORAENPA
   
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
     
     DL_LINGUA = CLI_LINGUA
     
     IF EMPTY(ALLTRIM(V_RAGDUE))
        V_RAGDUE    = ALLTRIM(CLI_RAGDUE)
     ENDIF
     
	 IF ___NON_CALCOLA_RA_ENPACL 
	   	  _RAPERC     = 0
	      _ENPACLPERC = 0   
	 ELSE
	     _RAPERC     = CLI_RA
	     _ENPACLPERC = CLI_ENPACL     
     ENDIF   
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
      ENDIF
   ENDIF

   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI
   IF !EMPTY(V_CLIFAT)	
   	   =CERCA_ANAGRAFICA_CLIENTE_FATTURAZIONE(V_CLIFAT)
   ELSE

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
   
   ENDIF
   ** 2015/07/10 SERGIO SE DIGITATO ORD_CLIFAT PRENDE I DATI ANAGRAFICI DEL CLIENTE INDICATO ALTROMENTI PRENDE I DATI DIRETTAMENTE DALL'ANAGRAFICA CLIENTI


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


ENDIF


v_seek   = 'VET'+V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
ELSE
   V_VETTO = ""
ENDIF

__V_ACURA = V_ACURA
v_seek   = 'MEZ'+V_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_ACURA=SUBSTR(DESCRI,1,30)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
   DL_TIPODES 		= 'MEZZI.CONS'
   DL_CODICE  		= __V_ACURA 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       V_ACURA      = _DESCR_LINGUA    
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'MEZZI.CONS' ---------- *
ELSE
   V_ACURA=""
ENDIF

__V_PORTO = V_PORTO
v_seek   = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = ALLTRIM(DESCRI)
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
   DL_TIPODES 		= 'CODI.PORTO'
   DL_CODICE  		= __V_PORTO 
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
       SAY_PORTO    = _DESCR_LINGUA     
       V_PORTO      = _DESCR_LINGUA  
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODI.PORTO' ---------- *
ELSE
   V_PORTO   = ""
   SAY_PORTO = ""
ENDIF

v_seek	 = 'TOP'+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CAUSALE  = DESCRI
   SAY_CAUS = DESCRI
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= M.ORD_CAUS
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		CAUSALE     = _DESCR_LINGUA  
		SAY_CAUS    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   CAUSALE  = ""
   SAY_CAUS = ""
ENDIF


v_seek	 = 'CPA'+M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_CPA=SUBSTR(DESCRI,1,30)
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
	DL_TIPODES 		= 'COND.PAGAM'
	DL_CODICE  		= M.ORD_CPA
	_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
	IF !EMPTY(_DESCR_LINGUA)
		SAY_CPA     = _DESCR_LINGUA    
	ENDIF
	* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   
ELSE         
   SAY_CPA=""
ENDIF  


v_seek	 = 'TPO'+M.ORD_TIPOLOGIA 
v_chiave ="codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
    SELECT CUR_PARA
    SAY_TIPOLOGIA = ALLTRIM(DESCRI)
ELSE
   SAY_TIPOLOGIA = ""
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

RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""

v_seek   = PUB_CODSOC + V_CODCLI
v_chiave = "cli_codsoc+cli_codcli"
IF seek_std('u_cli_an',v_seek,v_chiave,'CUR_CLIENTE')
   SELECT CUR_CLIENTE
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
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
   DL_TIPODES 		= 'COND.PAGAM'
   DL_CODICE  		= ALLTRIM(V_PAG)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
      V_CPAG        = _DESCR_LINGUA    
      X__DESCPA     = _DESCR_LINGUA 
   ENDIF
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
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

v_seek   = 'MOM000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   MOM = ALLTRIM(LIBERA)
ELSE
   MOM = ""
ENDIF

v_seek   = 'TOP'+ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU  = DESCRI
   NOTAC	 = SUBSTR(LIBERA,11,1)
   TI_PX     = SUBSTR(LIBERA,11,1)
   FATSOSIVA = SUBSTR(LIBERA,61,1)  && BOLLATO IVA IN SOSPENSIONE
   * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
   DL_TIPODES 		= 'CODICE-TOP'
   DL_CODICE  		= ALLTRIM(V_TOP)
   _DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
   IF !EMPTY(_DESCR_LINGUA)
		V_DESCAU    = _DESCR_LINGUA  
   ENDIF
  * -------------------------------------------------------------------------- descrizioni in lingua ---------- 'CODICE-TOP' ---------- *
ELSE
   V_DESCAU  = SPACE(40)
   NOTAC	 = " "
   TI_PX     = " "
   FATSOSIVA = " "
ENDIF


IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'PREVENTIVO'
ENDIF



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
      V_BANAP = SPACE(100)
   ELSE

	  IF !EMPTY(BAN_IBAN) 
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA) + CHR(13) + ;
	      			'IBAN : '+ ALLTRIM(BAN_IBAN)	&& SIMONE - 22/07/2009	&& >>>>>>>>>>>>>>>> IBAN DA ANAGRAFICA BANCHE U_BAN_AN
	  ELSE
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	  ENDIF

   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF


** 2) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DIRETTAMENTE DALL'ANAGRAFICA CLIENTE
**    ################################### SOLO PER RIMESSE DIRETTE

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

** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO  
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 
*!*  CASO IN CUI L'AZIENDA HA PIU' BANCHE SU CUI APPOGGIARE BONIFICI E RI BA
*!*  IN QUESTO CASO LA FUNZIONE GESTISCE LA VARIABILE V_BANSOC CHE EVIDENZIA I DATI DELLA BANCA E L'IBAN
*!*  SUL REPORT PERSONALIZZATO , PERCUI IN ANAGRAFICA CLIENTI NELLA SEZIONE FORNITORI
*!*  INSERISCO LA BANCA SU CUI IL CLIENTE DEVE PAGARE; PERTANTO MI RITROVO AD AVERE PIU' BANCHE AZIENDA A DISPOSIZIONE DEL CLIENTE
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
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : SONO VALIDE SOLO PER ALCUNI CLIENTI , NON LO SO LE LASCIAMO    
** ISTRUZIONI OBSOLETE 2011_12_13 SERGIO ?????????????????? : LA VARIABILE USATA E' PERO' V_BANAP 

   
   
SELECT XVENDITE_DD
GO TOP

M.T_OMAGGIO = 0
M.I_OMAGGIO = 0



DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      IF STAM_NOTE("INR",ORD_CODICE)
         SELECT XVENDITE_DD
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
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XVENDITE_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"	&& 2014/11/16 SERGIO - BACONE : LA RISTAMPA TRATTA ANCHE I COMMENTI PER CUI CI PERDIAMO L'ULTIMO NUM_ALIQ 
   												&& 2014/11/16 SERGIO - BACONE : USATO NEL CALCOLO DELL'IVA DELLE SPESE DI TRASPORTO
   ELSE
	   v_seek   = 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF
   ENDIF

   SELECT XVENDITE_DD


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

   SELECT XVENDITE_DD
   SKIP +1

ENDDO

**=> ERASMO - INIZIO 31/08/2023
SELECT XVENDITE_DD
SET FILTER TO
GO TOP
SCAN
	IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"
		
		IF M.ORD_FATTURAT
			IF !EMPTY(ALLTRIM(ORS_SYSFAT))
				x_cond = "ORS_SYSDDT = '" + ALLTRIM(ORS_SYSFAT) + "'"
				cSql = "select ORS_NUMORD,ORS_DATORD from u_fat_dd where " + x_cond + " order by daggancio desc"
				IF !ExecCommand(cSql,"TMP_FAT_DD")
				   RETURN .F.
				ENDIF
				SELECT TMP_FAT_DD
				GO TOP
				IF !EOF()
					_cFATTURA = ALLTRIM(ORS_NUMORD) + " del " + RIBALTA2(ORS_DATORD)
					IF _cFATTURA $ V_FATLEG
					ELSE
						V_FATLEG = ALLTRIM(V_FATLEG) + IIF(!EMPTY(ALLTRIM(V_FATLEG))," - ","") + _cFATTURA
					ENDIF
				ENDIF
				SELECT XVENDITE_DD
			ENDIF
		ENDIF
		
		IF !EMPTY(ALLTRIM(ORD_NOTE))
			V_ORD_RAPPORT_ALL = ALLTRIM(V_ORD_RAPPORT_ALL) + IIF(!EMPTY(ALLTRIM(V_ORD_RAPPORT_ALL)),CHR(13)+CHR(10)+"----------------"+CHR(13)+CHR(10),"") + ALLTRIM(ORD_NOTE)
		ENDIF
		
	ENDIF
ENDSCAN
**=> ERASMO - FINE 31/08/2023

**=> ERASMO - INIZIO 26/02/2025
*** SE VENDITE_DD.ORD_NOTE NON VALORIZZATO (CASO INTERVENTO ESEGUITO TRAMITE WEB APP GESTIT), VALORIZZO V_ORD_RAPPORT_ALL CON VENDITE_DD.ORD_RAPPORT
IF EMPTY(ALLTRIM(V_ORD_RAPPORT_ALL))
	x_agga = "daggancio = '" + M.TAGGANCIO + "'"
	x_cond = x_agga
	Csql = "select * from VENDITE_DT where " + x_cond + " order by ord_seque"  
	IF !ExecCommand(cSql,"U_DOC_DT")
		return(.f.)
	ENDIF
	SELECT U_DOC_DT
	GO TOP
	SCAN			
		IF !EMPTY(ALLTRIM(ORD_RAPPORT))
			V_ORD_RAPPORT_ALL = ALLTRIM(V_ORD_RAPPORT_ALL) + IIF(!EMPTY(ALLTRIM(V_ORD_RAPPORT_ALL)),CHR(13)+CHR(10)+"----------------"+CHR(13)+CHR(10),"") + ALLTRIM(ORD_RAPPORT)
		ENDIF
	ENDSCAN
ENDIF
**=> ERASMO - FINE 26/02/2025	

*** SOMMA SPESE DI TRASPORTO + INCASSO
*!*	V_SPESE   = V_SPINCA + V_SPTRAS
**=> SERGIO/ERASMO - INIZIO 2016/02/03
IF PUB_NOIVASPINC
	V_SPESE = V_SPTRAS	&& NON DEVE SOMMARE LE SPESE DI INCASSO PERCHE' SU QUELLE NON SI CALCOLANO IMPOSTE
ELSE
	V_SPESE = V_SPINCA + V_SPTRAS
ENDIF
**=> SERGIO/ERASMO - FINE 2016/02/03


PUB_IVADEF = CERCA_IVA_DEFAULT("XVENDITE_DD","CODICE")  
PUB_ALIQ = CERCA_IVA_DEFAULT("XVENDITE_DD","ALIQUOTA")  

*!*	IF !EMPTY(V_ALRID)
*!*	   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
*!*	ELSE
*!*	    V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
*!*	ENDIF

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



*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
   IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
       IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
       IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
       M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
       M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
   ENDIF


NETTO      = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

ACCO_IVA   = .F.

NUM_ALIQ_ENPACL 	= 0

v_seek   = 'IVA'+IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = ALLTRIM(SUBSTR(DESCRI,1,45))
   NUM_ALIQ_ENPACL 	= VAL(PIVA1)
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

v_seek   = 'IVA'+IVA2
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA3
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA4
v_chiave = "codice"
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

v_seek   = 'IVA'+IVA5
v_chiave = "codice"
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

IF !ACCO_IVA  && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek   = 'IVA'+IVA1
   v_chiave = "codice"
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
TOT_FATT    =   TOT_IMPO + TOT_IMPOS - MATPUB
TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_FATT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
	TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)	
ENDIF



*!*	CALCOLO ENPACL
IF _ENPACLPERC <> 0
	T_ENPACL = ROUND(( TOT_IMPO  * _ENPACLPERC ) / 100,2)
	TOT_IMPO = TOT_IMPO + T_ENPACL  && SOMMO A IMPONIBILE IL CONTRIBUTO DEL 2% ENPACL
	IMPO1    = IMPO1 + T_ENPACL
	_IVA_ENPACL = (T_ENPACL * NUM_ALIQ_ENPACL) / 100
	_IVA_ENPACL	=  ROUND((_IVA_ENPACL+.0000),2)
	TOT_IMPOS   = TOT_IMPOS + _IVA_ENPACL
	IMPOS1		= IMPOS1 + _IVA_ENPACL
	TOT_FATT    = TOT_FATT  + T_ENPACL + _IVA_ENPACL && SOMMO A TOTALE DOCUMENTO IL CONTRIBUTO DEL 2% ENPACL + RELATIVA IVA
	TOT_FATT_EUR = CAMBIO(DOC_VALUTA,TOT_FATT,DOC_CAMBIO)
ENDIF


*!*	CALCOLO RA
IF _RAPERC   <> 0
	_IMPONIBILE_NO_ENPACL = ( TOT_IMPO - T_ENPACL )
	T_RA = ROUND((_IMPONIBILE_NO_ENPACL * _RAPERC   ) / 100,2)
	T_NETTO = TOT_FATT - T_RA
ENDIF

RELEASE M.T_IMPONIB,M.T_IMPOSTA,M.ORD_VALORE
PUBLIC M.T_IMPONIB,M.T_IMPOSTA,M.ORD_VALORE
M.T_IMPONIB = TOT_IMPO 
M.T_IMPOSTA = TOT_IMPOS   
M.ORD_VALORE= TOT_FATT    


*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'
   IF !EMPTY(V_FERIE)
      SELECT XVENDITE_DD
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

**=> ERASMO - INIZIO 06/09/2023
*** AGGIUNTA RIGHE VUOTE SE INTERVENTO APERTO (MODULO PRECOMPILATO)
nRigheVuoteAggiuntive = 8  && ERASMO - 20/05/2024
**=> ERASMO - INIZIO 25/06/2024
SELECT XVENDITE_DD
GO TOP
SCAN
	IF nRigheVuoteAggiuntive > 0
	ELSE
		EXIT
	ENDIF
	nRigheVuoteAggiuntive = nRigheVuoteAggiuntive - 1
ENDSCAN
**=> ERASMO - FINE 25/06/2024
IF !M.ORD_INTCLOSE
   *FOR __I = 1 TO 5
   FOR __I = 1 TO nRigheVuoteAggiuntive  && ERASMO - 20/05/2024
      SELECT XVENDITE_DD
      APPEND BLANK
      m.ord_codart = ""
      M.ORD_MAGA   = ""
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = ""
      M.ORD_UM	   = ""
      M.ORD_IVA	   = ""
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = ""
      M.ORD_PUBBLI = ""
      GATHER MEMVAR MEMO
   NEXT
ENDIF
**=> ERASMO - FINE 06/09/2023

SELECT XVENDITE_DD
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
   DL_LINGUA = ""
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 
ELSE
   DL_LINGUA = CLI_LINGUA
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno   
ENDIF

SELECT XVENDITE_DD
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
	=SCADENZE_SPECIALI(M.TIPRENDO,.F.,.F.,.T.,"XVENDITE_DD",.F.)
	SELECT XVENDITE_DD
    DELETE FOR DAGGANCIO = 'EOF'
	APPEND BLANK
	REPLACE DAGGANCIO  WITH 'EOF'
	REPLACE ORD_SEQUEN WITH 99999
	   
	*REPLACE ORS_NUMORD WITH M.ORD_NUMORD
	*REPLACE ORS_DATORD WITH M.ORD_DATORD
	*REPLACE ORS_CODCLI WITH M.ORD_CODCLI   
ENDIF



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

SELECT XVENDITE_DD
GO TOP

ANCORA = 1

*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"INR",M.TAGGANCIO,"CHECK")
	SELECT XVENDITE_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF



IF M.ORD_CAUS = "LIC"
   *** Per ristampare lista consegna
	__PROGRAMMA__    = "LICPJITA"
	__REPORTNEW__    = "LICPJITA.FRX"
ELSE
   *** Per ristampare interventi/riparazioni
	__PROGRAMMA__    = "INRPJITA"
	__REPORTNEW__    = "INRPJITA.FRX"
ENDIF

__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))



IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         *REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         **=> ERASMO - INIZIO 01/09/2022
         IF _V_OPZPROMPT
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER PROMPT
         ELSE
            REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
         ENDIF
         **=> ERASMO - FINE 01/09/2022
      NEXT            
ENDCASE

_FLGREGOLA2 = .F.	&& OPZIONE STAMPA RAGRUPPAMENTI PER COMMESSE
_FLGREGOLA3 = .F.	&& OPZIONE STAMPA RAGRUPPAMENTI PER COMMESSE

IF PUB_CREA_FILE_PDF
	SELECT XVENDITE_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	*_PDF_DESCRIZIONE_	= "INR-n-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_NUMORD))+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_DESCRIZIONE_	= "INR-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+"-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(M.ORD_CCODSCHE))  && ERASMO - 18/10/2024
	_PDF_SELECT_ 		= "XVENDITE_DD" && IIF(_FLGREGOLA2,"XU_OFF_ED","XVENDITE_DD")  
	_PDF_REPORT_ 		= __REPORT__ 
	_cSubDirectory = SUBDIR_FILE_PDF("INR")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
ENDIF





SELECT XVENDITE_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

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
RELEASE V_NUMFAT
RELEASE V_DESCAU


RELEASE ___TOT_IMPOS
RELEASE ___TOT_FATT
PUBLIC ___TOT_IMPOS
PUBLIC ___TOT_FATT
___TOT_IMPOS = TOT_IMPOS
___TOT_FATT  = TOT_FATT


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



RETURN




*!*	DEFINE CLASS MyReportListener AS ReportListener
*!*	    SummaryPrinted = .F.

*!*	    PROCEDURE BeforeBand(nBandObjCode, nFRXRecNo)
*!*	        * Verifica se stiamo processando il Summary Band
*!*	        IF nBandObjCode = 4  && 4 indica il Summary Band
*!*	            IF _PAGENO = _PAGETOTAL AND This.SummaryPrinted = .F.
*!*	                * Imposta il flag per stampare il Summary solo una volta
*!*	                This.SummaryPrinted = .T.
*!*	                RETURN .T.  && Consente la stampa del Summary Band
*!*	            ELSE
*!*	                RETURN .F.  && Salta la stampa del Summary Band sulle altre pagine
*!*	            ENDIF
*!*	        ENDIF
*!*	    ENDPROC

*!*	    PROCEDURE Render
*!*	        LPARAMETERS nFRXRecno, nLeft, nTop, nWidth, nHeight, nObjectContinuationType, cContentsToBeRendered, GDIPlusImage
*!*			
*!*	        * Verifica che siamo sull'ultima pagina e che il Summary sia da stampare
*!*	        IF This.SummaryPrinted AND _PAGENO = _PAGETOTAL
*!*	            LOCAL nPageHeight, nSummaryHeight, nNewTop
*!*	            
*!*	            * Calcola la nuova posizione per il Summary alla base della pagina
*!*	            nPageHeight = This.GetPageHeight()
*!*	            nSummaryHeight = nHeight
*!*	            nNewTop = nPageHeight - nSummaryHeight

*!*	            * Renderizza il Summary Band in questa posizione
*!*	            DODEFAULT(nFRXRecno, nLeft, nNewTop, nWidth, nSummaryHeight, nObjectContinuationType, cContentsToBeRendered, GDIPlusImage)
*!*	        ELSE
*!*	            * Render normale per tutti gli altri band e pagine
*!*	            DODEFAULT(nFRXRecno, nLeft, nTop, nWidth, nHeight, nObjectContinuationType, cContentsToBeRendered, GDIPlusImage)
*!*	        ENDIF
*!*	    ENDPROC
*!*	ENDDEFINE

*!*	Define Class MyReportListener as ReportListener
*!*		lInSummary = .F.
*!*		*nSummaryHeight = 600 && 960th inch
*!*		nSummaryHeight = 0
*!*		nSummaryStart = NULL

*!*		Procedure BeforeBand(nBandObjCode, nFRXRecNo )
*!*			This.lInSummary = nBandObjCode = 8
*!*			This.nSummaryStart = NULL
*!*		EndProc

*!*		Procedure AfterBand(nBandObjCode, nFRXRecNo )
*!*			This.lInSummary = .F.
*!*		EndProc

*!*		Procedure render(nFRXRecNo,nLeft,nTop,nWidth,nHeight,nObjectContinuationType, cContentsToBeRendered, GDIPlusImage)
*!*			Local lnNewTop
*!*			If This.lInSummary
*!*				If IsNull(This.nSummaryStart)
*!*					This.nSummaryStart = m.nTop
*!*					This.nSummaryHeight = nHeight
*!*				EndIf
*!*				lnNewTop = m.nTop - This.nSummaryStart + This.GetPageHeight() - This.nSummaryHeight
*!*				DoDefault(nFRXRecNo, nLeft, m.lnNewTop, nWidth,nHeight,nObjectContinuationType, cContentsToBeRendered, GDIPlusImage)
*!*				NoDefault
*!*			EndIf
*!*		EndProc

*!*	EndDefine