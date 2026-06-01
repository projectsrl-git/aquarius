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
   *CASE _V_OPZSTA = 1
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\BFOPJITA.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_BFO_DD
	GO TOP   
    *___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
    ___DATA_DOC         = STRTRAN(M.ORD_DATORD,"/","-")  && ERASMO - 06/06/2011
	_PDF_DESCRIZIONE_	= "BFO-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BFO_DD"
	_PDF_REPORT_ 		= "REPORT\BFOPJITA.FRX"
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("BFO")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	**=> ERASMO - FINE 03/02/2012
ENDIF
*!*	FINE 15/03/2007 SERGIO



RETURN


*******************
PROCEDURE RISTA_BOL
*******************


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




RELEASE SAY_TELEFO
PUBLIC SAY_TELEFO
SAY_TELEFO = ""

**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

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

**=> ERASMO - INIZIO 09/08/2010
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
**=> ERASMO - FINE 09/08/2010

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

**=> ERASMO - INIZIO 12/07/2013
IF EMPTY(M.ORD_VETTO1) AND EMPTY(M.ORD_VETTO2) AND EMPTY(M.ORD_VETTO3) AND !EMPTY(M.ORD_VETXTR)
	DESVET = ALLTRIM(M.ORD_VETXTR)
	INDVET = ""
	DESVET2 = ""
	INDVET2 = ""
	DESVET3 = ""
	INDVET3 = ""
ENDIF
**=> ERASMO - FINE 12/07/2013

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
   SAY_TELEFO   = "Tel.: "+ CLI_TELEFO  	&& SERGIO 15/12/2011
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
   SAY_TELEFO   = ""				  	&& SERGIO 15/12/2011
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
   GO TOP
   
   *DO PRG\MENUSTA1 WITH "CU_BOL_DD",.t.,.T.,"XXX","BOLPJITA","BOL000.FRX",.F.,_FILEPDF
   *REPORT FORM "REPORT\BOLPJITA.FRX" NOEJECT NOCONSOLE TO PRINTER      
   *REPORT FORM "REPORT\BOLPJITA.FRX" NOEJECT NOCONSOLE PREVIEW
   
   *** Simone - 27/01/2009 - INIZIO
   *** Per ristampare le bolle di consegna ai fornitori
   IF _V_CLIFOR = 'C'
	   YYY_PROGRAMMA = "BOLPJITA"
	   *YYY_REPORT    = "BOL000.FRX"
	   YYY_REPORT    = "BOLPJITA.FRX"  && ERASMO - 28/01/2010
   ELSE
	   YYY_PROGRAMMA = "BOLPJCTL"
	   YYY_REPORT    = "BOLPJCTL.FRX"   
   ENDIF
   *** Simone - 27/01/2009 - FINE

   YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)
   IF YYY_FILOUT <> "NNN"
      DO CASE
         *CASE _V_OPZSTA = 1
         CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
            FOR __I = 1 TO _V_NUMCOPIE
               REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
            NEXT
         CASE _V_OPZSTA = 2
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW
         CASE _V_OPZSTA = 3
            REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE PREVIEW
            FOR __I = 1 TO _V_NUMCOPIE
               REPORT FORM &YYY_FILOUT NOEJECT NOCONSOLE TO PRINTER
            NEXT            
      ENDCASE
   ENDIF
   
*!*	   **=> ERASMO - INIZIO 21/09/2009
*!*	   **************************************
*!*	   *** COMMENTATO PER SPECIFICA RICHIESTA
*!*	   **************************************
*!*	   *** STAMPA MODULO CHECK LIST DI SPEDIZIONE
*!*	   IF _V_OPZSTA = 1 .OR. _V_OPZSTA = 2 .OR. _V_OPZSTA = 3
*!*	      x_nddt = "pr5_numddt = '" + ALLTRIM(M.ORD_NUMORD) + "'"
*!*	      x_data = "pr5_datddt = '" + IIF(SUBSTR(ORD_DATORD,3,1) = '/',RIBALTA2(M.ORD_DATORD),ALLTRIM(M.ORD_DATORD)) + "'"
*!*	      x_fddt = "pr5_flgddt = 1"
*!*	      x_cond = x_nddt + " and " + x_data + " and " + x_fddt
*!*	      Csql = "select PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN,COUNT(*) AS PR5_NUMROT from u_prd_d5 where " + x_cond + ;
*!*	             " GROUP BY PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN order by  PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN"
*!*	      IF !ExecCommand(cSql,'PR5_CHK_LST')
*!*	         return(.f.)
*!*	      ENDIF
*!*	      
*!*	      SELECT PR5_CHK_LST
*!*	      INDEX ON PR5_NUMPCK+PR5_DATPCK+STR(PR5_NUMBAN,10,0) TAG I_GROUP
*!*	      
*!*	      *** AGGIUNGO AL CURSORE PER CHECK LIST DI SPEDIZIONE GLI EVENTUALI ROTOLI NON IN PRODUZIONE AGGIUNTI IN PACKING LIST
*!*	      x_nddt = "pr5_numddt = '" + ALLTRIM(M.ORD_NUMORD) + "'"
*!*	      x_data = "pr5_datddt = '" + IIF(SUBSTR(ORD_DATORD,3,1) = '/',RIBALTA2(M.ORD_DATORD),ALLTRIM(M.ORD_DATORD)) + "'"
*!*	      x_fddt = "pr5_flgddt = 1"
*!*	      x_cond = x_nddt + " and " + x_data + " and " + x_fddt
*!*	      Csql = "select PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN,COUNT(*) AS PR5_NUMROT from u_prd_pk where " + x_cond + ;
*!*	             " GROUP BY PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN order by  PR5_NUMPCK,PR5_DATPCK,PR5_NUMBAN"
*!*	      IF !ExecCommand(cSql,'AGG_CHK_LST')
*!*	         return(.f.)
*!*	      ENDIF
*!*	      SELECT AGG_CHK_LST
*!*	      GO TOP
*!*	      SCAN
*!*	         AGG_NUMPCK = PR5_NUMPCK 
*!*	         AGG_DATPCK = PR5_DATPCK 
*!*	         AGG_NUMBAN = PR5_NUMBAN 
*!*	         AGG_NUMROT = PR5_NUMROT 
*!*	         _SEEK = AGG_NUMPCK + AGG_DATPCK + STR(AGG_NUMBAN,10,0)
*!*	         SELECT PR5_CHK_LST
*!*	         SET ORDER TO I_GROUP
*!*	         SEEK _SEEK
*!*	         GO TOP
*!*	         IF EOF()
*!*	            APPEND BLANK
*!*	            REPLACE PR5_NUMPCK WITH AGG_NUMPCK
*!*	            REPLACE PR5_DATPCK WITH AGG_DATPCK
*!*	            REPLACE PR5_NUMBAN WITH AGG_NUMBAN
*!*	            REPLACE PR5_NUMROT WITH AGG_NUMROT
*!*	         ELSE
*!*	            REPLACE PR5_NUMROT WITH PR5_NUMROT + AGG_NUMROT
*!*	         ENDIF
*!*	      ENDSCAN
*!*	      
*!*	      SELECT PR5_CHK_LST
*!*	      GO TOP
*!*	      IF EOF()
*!*	      ELSE   
*!*	         KKK_REPORT = "REPORT\BOLCHKLST.FRX"
*!*	         DO CASE
*!*	            CASE _V_OPZSTA = 1
*!*	               *FOR I = 1 TO _V_NUMCOPIE
*!*	                  REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE TO PRINTER
*!*	               *NEXT
*!*	            CASE _V_OPZSTA = 2
*!*	               REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE PREVIEW
*!*	            CASE _V_OPZSTA = 3
*!*	               REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE PREVIEW
*!*	               *FOR I = 1 TO _V_NUMCOPIE
*!*	                  REPORT FORM &KKK_REPORT NOEJECT NOCONSOLE TO PRINTER
*!*	               *NEXT            
*!*	         ENDCASE
*!*	      ENDIF
*!*	   ENDIF
*!*	   **=> ERASMO - FINE 21/09/2009   

	*!*	INIZIO 15/03/2007 SERGIO
	IF PUB_CREA_FILE_PDF
		SELECT XU_BOL_DD
		GO TOP   
	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
		_PDF_DESCRIZIONE_	= "BOL-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
		_PDF_SELECT_ 		= "XU_BOL_DD"
		_PDF_REPORT_ 		= YYY_FILOUT    
		*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
		**=> ERASMO - INIZIO 03/02/2012
		_cSubDirectory = SUBDIR_FILE_PDF("BOL")
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
PROCEDURE RISTA_FAP
*******************



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
   V_NAZION = ""  

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO   
      
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
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
   ENDIF
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
   V_NAZION = ""  

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO   
      
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
     **=> LUCA - FINE 11/04/2013
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
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
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
	      V_BANAP = ALLTRIM(BAN_DESBAN) + '  ' + ALLTRIM(BAN_LOCA)  
	  ENDIF

   ENDIF
   IF ALLTRIM(V_BANCA)="."
      V_BANAP=SPACE(40)
   ENDIF
ENDIF

** 2) ################################### GESTIONE IBAN : TENTA DI PRELEVARE IL CODICE IBAN DELLA BANCA NOSTRA DIRETTAMENTE DALL'ANAGRAFICA CLIENTE
**    ################################### SOLO PER RIMESSE DIRETTE

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
	      			'IBAN : '+ ALLTRIM(V_IBANFOR)	&& >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> IBAN BANCA NOSTRA DA ANAGRAFICA CLIENTE U_CLI_AN
	      IF EMPTY(ALLTRIM(V_CODICE_SWIFT)) 
	      ELSE
	         V_BANAP = V_BANAP + '  -  BIC/SWIFT : ' + ALLTRIM(V_CODICE_SWIFT)
	      ENDIF
	   ENDIF
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

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_FAP_DD","CODICE")  
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_FAP_DD","ALIQUOTA")  

IF !EMPTY(V_ALRID)
   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
ELSE
   V_IMPSP = V_SPESE * (PUB_ALIQ/100)  
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
   
DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE



IF PUB_CREA_FILE_PDF
	SELECT XU_FAP_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "FAP-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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

*DO STAMPAMOD
*****************************
*PROCEDURE STAMPAMOD
*****************************
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
PUBLIC V_BANSOC && LUCA 2010-12-02
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

** SERGIO 03/01/2005 INIZIO
RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0
** SERGIO 03/01/2005 FINE

*** SIMONE - 10/10/2008
RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO
*** SIMONE - 10/10/2008

*** SERGIO - 08/12/2008
_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   
*** SERGIO - 08/12/2008

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
V_BANSOC  = '' && LUCA 2010-12-02
V_NUMFAT  = SPACE(10)
V_DESCAU  = "FATTURA DI VENDITA"
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

   V_VETTO  = M.ORD_VETTO1		 
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  && ERASMO/SERGIO - 28/02/2013
 
   V_NUMORC = M.ORD_NUMORC	&& SERGIO 21/02/2007
   V_DATORC = M.ORD_DATORC	&& SERGIO 21/02/2007
   V_NUMOFC = M.ORD_NUMOFC	&& SERGIO 21/02/2007
   V_DATOFC = M.ORD_DATOFC	&& SERGIO 21/02/2007
   V_CDC	= M.ORD_CDC		&& SERGIO 21/02/2007
 
   V_NUMCOC = M.ORD_NUMCOC	&& SERGIO 05/06/2007
   V_DATCOC = M.ORD_DATCOC	&& SERGIO 05/06/2007
   
   V_MERCRE = M.ORD_MERCRE
   V_NSRIF  = M.ORD_RIFERI  && ERASMO - 31/12/2013
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

   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+V_PROVIN+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
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
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0
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

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO
   
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   
   V_VETTO  = M.ORD_VETTO1
   V_ACURA  = M.ORD_ACURA
   V_PORTO  = M.ORD_PORTO
   V_NAZION = ""  && ERASMO/SERGIO - 28/02/2013
  
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
   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+V_PROVIN+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
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
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0
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

**=> ERASMO - INIZIO 09/06/2011
RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""
**=> ERASMO - FINE 09/06/2011

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
   V_CODNAZ   		= CLI_NAZION  && ERASMO - 09/06/2011
   V_PIVA_CEE 		= CLI_IVACEE  && ERASMO - 09/06/2011
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

* INIZIO - PROJECT 15/10/03
IF V_TOP = PUB_CAUCAS
   V_DESCAU = 'FATTURA DI VENDITA'
ENDIF
* FINE - PROJECT 15/10/03


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
**    SERGIO 2011_12_13 

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
   
   *** SIMONE - 10/10/2008
   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   && CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
	   IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
	   ENDIF
   ENDIF   
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   *** SIMONE - 10/10/2008   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_FAT_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      *** SIMONE - 10/10/2008
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
      *** SIMONE - 10/10/2008       
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
 
 	*** SERGIO - 08/12/2008
	   IF ORD_PUBBLI = "O"						&& CONTA ARTICOLO OMAGGIO
		   _CNT_OMAGGI = _CNT_OMAGGI + 1		
	   ENDIF

	   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO' 	&& CALCOLO IMPONIBILE E IMPOSTA POLIECO
	 		_IMPONIBILE_POLIECO = _IMPONIBILE_POLIECO + IMPONIB
			_IMPOSTA_POLIECO    = _IMPOSTA_POLIECO    + IMPOSTA  	   
	   ENDIF
	*** SERGIO - 08/12/2008

 
   
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
   
*!*	   **=> ERASMO - INIZIO 09/01/2012
*!*	   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"
*!*		   IF ORD_PRZFIN > 0
*!*		      _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMFIN)
*!*		      IF TYPE(_cNomeCampoQta) == 'N'
*!*		      ELSE
*!*		         _cNomeCampoQta = "ORD_QTAORD"
*!*		      ENDIF
*!*		      IMPONIB = &_cNomeCampoQta * ORD_PRZFIN
*!*		      IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
*!*		      IMPO_MAGG = IMPO_MAGG + IMPONIB 
*!*		      IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
*!*		   ENDIF
*!*		   IF ORD_PRZBAR > 0
*!*		      _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMBAR)
*!*		      IF TYPE(_cNomeCampoQta) == 'N'
*!*		      ELSE
*!*		         _cNomeCampoQta = "ORD_QTAORD"
*!*		      ENDIF
*!*		      IMPONIB = &_cNomeCampoQta * ORD_PRZBAR
*!*		      IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
*!*		      IMPO_MAGG = IMPO_MAGG + IMPONIB 
*!*		      IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
*!*		   ENDIF
*!*		   IF ORD_PRZSEZ > 0
*!*		      _cNomeCampoQta = "ORD_QTA" + ALLTRIM(ORD_UMSEZ)
*!*		      IF TYPE(_cNomeCampoQta) == 'N'
*!*		      ELSE
*!*		         _cNomeCampoQta = "ORD_QTAORD"
*!*		      ENDIF
*!*		      IMPONIB = &_cNomeCampoQta * ORD_PRZSEZ
*!*		      IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
*!*		      IMPO_MAGG = IMPO_MAGG + IMPONIB 
*!*		      IMPOS_MAGG = IMPOS_MAGG + IMPOSTA 
*!*		   ENDIF
*!*	   ENDIF
*!*	   **=> ERASMO - FINE 09/01/2012

   SELECT XU_FAT_DD
   SKIP +1

ENDDO

*!*	**=> ERASMO - INIZIO 09/01/2012
*!*	IMPO_MAGG = ROUND(IMPO_MAGG,2)
*!*	IMPOS_MAGG = ROUND(IMPOS_MAGG,2)
*!*	**=> ERASMO - FINE 09/01/2012

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_FAT_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_FAT_DD","ALIQUOTA")  && ERASMO - 21/09/2011

IF !EMPTY(V_ALRID)
   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
ELSE
   *V_IMPSP = V_SPESE * (VAL(PUB_IVA)/100)
   V_IMPSP = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
ENDIF


*** SERGIO - 08/12/2008
*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
   IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
       IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
       IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
       M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
       M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
   ENDIF
*** SERGIO - 08/12/2008


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

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)


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

**=> ERASMO - INIZIO 26/03/2009
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
**=> ERASMO - FINE 26/03/2009

**=> ERASMO - INIZIO 12/11/2013
*** GESTIONE UNICO TESTO PERSONALIZZATO IN DETTAGLI ARTICOLI
IF DOCUMENTI_TXT_UNICO("C",M.ORD_CODCLI,"FAT",M.TAGGANCIO,"CHECK")
	SELECT XU_FAT_DD
	SET FILTER TO SUBSTR(daggancio,1,3) = 'EOF'
	GO TOP
ENDIF
**=> ERASMO - FINE 12/11/2013

__PROGRAMMA__    = "FATPJEUR"
__REPORTNEW__    = "FATPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))

IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

DO CASE
   *CASE _V_OPZSTA = 1 
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_FAT_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "FAT-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	*_PDF_SELECT_ 		= "XU_FAT_DD"
	_PDF_SELECT_ 		= IIF(_FLGREGOLA2,"XU_FAT_ED","XU_FAT_DD")  && ERASMO 26/03/2009
	_PDF_REPORT_ 		= __REPORT__ 
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("FAT")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	**=> ERASMO - FINE 03/02/2012
ENDIF
*!*	FINE 15/03/2007 SERGIO


**=> ERASMO - INIZIO 06/08/2010
*=> Stampa tagliando per agenti
SELECT XU_FAT_DD
IF PUB_TAGAGE
   _RISP = MESSAGEBOX("Stampare il tagliando per l'agente?",36,"Attenzione")
   IF _RISP = 6
		__PROGRAMMA__    = "TAG_AGENTI"
		__REPORTNEW__    = "TAG_AGENTI.FRX"
		__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
		   
		DO CASE
		   *CASE _V_OPZSTA = 1 
		   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
		      FOR __I = 1 TO _V_NUMCOPIE
		         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
		      NEXT
		   CASE _V_OPZSTA = 2
		      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
		   CASE _V_OPZSTA = 3
		      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
		      FOR __I = 1 TO _V_NUMCOPIE
		         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
		      NEXT            
		ENDCASE
		
		IF PUB_CREA_FILE_PDF
			SELECT XU_FAT_DD
			GO TOP   
		    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
			_PDF_DESCRIZIONE_	= "Tagliando-agente-FAT-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
			_PDF_SELECT_ 		= "XU_FAT_DD"
			*_PDF_SELECT_ 		= IIF(_FLGREGOLA2,"XU_FAT_ED","XU_FAT_DD")
			_PDF_REPORT_ 		= __REPORT__ 
			*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
			**=> ERASMO - INIZIO 03/02/2012
			_cSubDirectory = SUBDIR_FILE_PDF("FAT")
			IF !EMPTY(_cSubDirectory)
				=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
			ELSE
				=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
			ENDIF
			**=> ERASMO - FINE 03/02/2012
		ENDIF
   ENDIF
ENDIF
**=> ERASMO - FINE 06/08/2010


**=> ERASMO - INIZIO 26/03/2009
= _OPERAT(PUB_CODOPE)
*IF _FLGREGOLA2 .AND. _FLGREGOLA3 .AND. !PUB_RISINF
IF _FLGREGOLA2 .AND. _FLGREGOLA3 .AND. !PUB_RISINF .AND. _V_OPZRISDETTFAT  && ERASMO - 13/05/2009
   *_RISP = MESSAGEBOX("Stampare i dettagli fattura per le risorse?",36,"Attenzione")
   _RISP = 6  && ERASMO - 13/05/2009
   IF _RISP = 6
      SELECT DISTINCT ORD_CODSOG,ORD_DESSOG FROM XU_FAT_DD WHERE (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI) GROUP BY ORD_CODSOG,ORD_DESSOG INTO CURSOR CUR_SOGGETTI
      SELECT CUR_SOGGETTI
      GO TOP
      SCAN
         __SOGGETTO = ORD_CODSOG
         IF EMPTY(ALLTRIM(__SOGGETTO))
            LOOP
         ENDIF
         SELECT * FROM XU_FAT_DD WHERE (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI) .AND. ORD_CODSOG = __SOGGETTO INTO CURSOR XU_FAT_ED_STA
         SELECT XU_FAT_ED_STA
         INDEX ON ORD_SEQUEN TAG I_SEQUEN
         SET ORDER TO I_SEQUEN
         GO TOP
         **=> ERASMO - INIZIO 31/03/2009
         *** CALCOLO I TOTALI IMPOSTA E SUBTOTALE
         ___TOT_IMPOS = 0
         ___TOT_FATT  = 0
         ___ORD_VALORE= 0
         SCAN
            COD_IVA = ORD_IVA
            IMPONIB = ORD_VALORE
            DES_ART = SUBSTR(ORD_DESART,1,16)
            IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
               LOOP
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
            SELECT XU_FAT_ED_STA
            IMPOSTA = (IMPONIB * NUM_ALIQ) / 100
            ___TOT_IMPOS  = ___TOT_IMPOS  + IMPOSTA 
            ___ORD_VALORE = ___ORD_VALORE + ORD_VALORE
         ENDSCAN
         ___TOT_FATT = ___ORD_VALORE + ___TOT_IMPOS
         GO TOP

         
         IF !EOF()
            *_FILEPDF="C:\AQUARIUS_DETTAGLI_RISORSA_DA_FATTURA_CLIENTE_"+ALLTRIM(STR(DAY(DATE())))+"-"+ALLTRIM(STR(MONTH(DATE())))+"-"+ALLTRIM(STR(YEAR(DATE())))+".EXP"		
            X_DESCAU  = "Numero fattura: " + ALLTRIM(ORS_NUMORD) + "-del-" + RIBALTA2(ORS_DATORD)
            X_RISORSA = "Risorsa : " + ALLTRIM(ORD_CODSOG) + "-" + ALLTRIM(ORD_DESSOG)
            *DO PRG\MENUSTA1 WITH "XU_FAT_ED_STA",.t.,.T.,"XXX","FATPJEUR_ED","FATPJEUR_ED.FRX",.F.,_FILEPDF
            __PROGRAMMA__    = "FATPJEUR_ED"
            __REPORTNEW__    = "FATPJEUR_ED.FRX"
            __REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
            DO CASE
               *CASE _V_OPZSTA = 1 
               CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
                  FOR __I = 1 TO _V_NUMCOPIE
                     REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
                  NEXT
               CASE _V_OPZSTA = 2
                  REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
               CASE _V_OPZSTA = 3
                  REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
                  FOR __I = 1 TO _V_NUMCOPIE
                     REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
                  NEXT            
            ENDCASE
            
            IF PUB_CREA_FILE_PDF
            	SELECT XU_FAT_ED_STA
            	GO TOP   
                ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
            	_PDF_DESCRIZIONE_	= "estr-conto-risorsa-" + ALLTRIM(ORD_CODSOG) + "-FAT-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
            	_PDF_SELECT_ 		= "XU_FAT_ED_STA"
            	_PDF_REPORT_ 		= __REPORT__ 
            	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
				**=> ERASMO - INIZIO 03/02/2012
				_cSubDirectory = SUBDIR_FILE_PDF("FAT")
				IF !EMPTY(_cSubDirectory)
					=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
				ELSE
					=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
				ENDIF
				**=> ERASMO - FINE 03/02/2012
            ENDIF
         ENDIF
         SELECT XU_FAT_ED_STA
         USE
      ENDSCAN
   ENDIF
ENDIF
**=> ERASMO - FINE 26/03/2009

SELECT XU_FAT_DD
GO BOTTOM
IF 'EOF' $ DAGGANCIO
   DELETE
ENDIF

*DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI
*************************
*PROCEDURE RILA_VAR
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


**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

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
RELEASE DESPUBL,V_PORTO,V_VETTO,V_MERCRE,DPU
RELEASE V_FERIE,NOTAC


PUBLIC V_COSTTR
PUBLIC V_BANSOC && LUCA 2010-12-02
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

*** SIMONE - 10/10/2008
RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO
*** SIMONE - 10/10/2008

*** SERGIO - 08/12/2008
_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   
*** SERGIO - 08/12/2008

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

**=> ERASMO - INIZIO 09/06/2011
RELEASE V_CODNAZ,V_PIVA_CEE
PUBLIC V_CODNAZ,V_PIVA_CEE
V_CODNAZ = ""
V_PIVA_CEE = ""
**=> ERASMO - FINE 09/06/2011

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
   V_CODNAZ   		= CLI_NAZION  && ERASMO - 09/06/2011
   V_PIVA_CEE 		= CLI_IVACEE  && ERASMO - 09/06/2011
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
**    SERGIO 2011_12_13 

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
   
   *** SIMONE - 10/10/2008
   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   && CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
	   IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
	   ENDIF
   ENDIF   
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   *** SIMONE - 10/10/2008   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_FAT_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      *** SIMONE - 10/10/2008
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
      *** SIMONE - 10/10/2008       
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
 
 	*** SERGIO - 08/12/2008
	   IF ORD_PUBBLI = "O"						&& CONTA ARTICOLO OMAGGIO
		   _CNT_OMAGGI = _CNT_OMAGGI + 1		
	   ENDIF

	   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO' 	&& CALCOLO IMPONIBILE E IMPOSTA POLIECO
	 		_IMPONIBILE_POLIECO = _IMPONIBILE_POLIECO + IMPONIB
			_IMPOSTA_POLIECO    = _IMPOSTA_POLIECO    + IMPOSTA  	   
	   ENDIF
	*** SERGIO - 08/12/2008

 
   
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

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_FAT_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_FAT_DD","ALIQUOTA")  && ERASMO - 21/09/2011

IF !EMPTY(V_ALRID)
   V_IMPSP = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
ELSE
   *V_IMPSP = V_SPESE * (VAL(PUB_IVA)/100)
   V_IMPSP = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
ENDIF


*** SERGIO - 08/12/2008
*** SE TUTTI GLI ARTICOLI SONO OMAGGIO DEVO TOGLIERE IL POLIECO DAL TOTALE IMPONIBILE E IMPOSTA E LI SOMMA NEL TOTALE IMPONIBILE , IMPOSTA OMAGGIO
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE IN QUANTO POI IL COSTO E L'IVA SONO A CARICO DELL'AZIENDA
   IF _CNT_OMAGGI = _CNT_ARTICOLI && ARTICOLO OMAGGIO
       IMPO1  = IMPO1  - _IMPONIBILE_POLIECO 
       IMPOS1 = IMPOS1 - _IMPOSTA_POLIECO  
       M.T_OMAGGIO = M.T_OMAGGIO + _IMPONIBILE_POLIECO 
       M.I_OMAGGIO = M.I_OMAGGIO + _IMPOSTA_POLIECO  
   ENDIF
*** SERGIO - 08/12/2008


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
*** SIMONE - 10/10/2008	
*** SE TUTTI GLI ARTICOLI SONO PUBBLICITARI DEVO TOGLIERE IL POLIECO DAL TOTALE
*** QUESTA REGOLA E' APPLICATA ALLE SOLE FATTURE
IF _CNT_PUBBLI = _CNT_ARTICOLI 
	TOT_FATT = TOT_IMPO + TOT_IMPOS - MATPUB - PUB_TOTPOLIECO
ENDIF
*** SIMONE - 10/10/2008



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
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE



IF PUB_CREA_FILE_PDF
	SELECT XU_FAT_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "RFI-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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


NUMPRO=TAGGANCIO

SELECT XU_OFF_DD
**SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)


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

** SERGIO 03/01/2005 INIZIO
RELEASE M.T_OMAGGIO,M.I_OMAGGIO
PUBLIC M.T_OMAGGIO,M.I_OMAGGIO 
M.T_OMAGGIO = 0
M.I_OMAGGIO = 0
** SERGIO 03/01/2005 FINE

*** SIMONE - 10/10/2008
RELEASE _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
PUBLIC  _CNT_PUBBLI,_CNT_ARTICOLI,PUB_TOTPOLIECO 
_CNT_PUBBLI 	= 0		&& CONTATORE DI ARTICOLI PUBBLICITARI
_CNT_ARTICOLI 	= 0		&& CONTATORE DI ARTICOLI DI VENDITA
PUB_TOTPOLIECO  = 0		&& CALCOLO POLIECO
*** SIMONE - 10/10/2008

*** SERGIO - 08/12/2008
_CNT_OMAGGI 		= 0		&& CONTATORE DI ARTICOLI OMAGGIO CON IVA A CARICO AZIENDA
_IMPONIBILE_POLIECO = 0
_IMPOSTA_POLIECO    = 0   	   
*** SERGIO - 08/12/2008

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
V_BANSOC  = '' && LUCA 2010-12-02
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

   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = "" && ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)

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

   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+V_PROVIN+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
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
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0
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

   DOC_VALUTA = M.ORD_VALUTA
   DOC_CAMBIO = M.ORD_CAMBIO
   
   V_RAGSOC_CON = ALLTRIM(M.ORD_RAGC)
   V_RAGDUE_CON = "" && ALLTRIM(M.ORD_ATTENZIONE)
   V_RAGTRE_CON = ""
   V_RAGQUA_CON = ""
   V_INDIRI_CON = ALLTRIM(M.ORD_INDC)
   V_CAP_CON    = ALLTRIM(M.ORD_CAPC)
   V_LOCALI_CON = ALLTRIM(M.ORD_LOCC)
   
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
   V_INTESTA    = V_RAGSOC+CHR(13)
   IF !EMPTY(ALLTRIM(V_RAGDUE))
      V_INTESTA = V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   V_PROVIN     = ALLTRIM(M.ORD_PROVIN)
   V_INTESTA    = V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI+ IIF(!EMPTY(V_PROVIN)," ("+V_PROVIN+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = V_INTESTA + CHR(13) + V_NAZION
      ENDIF
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
	      IF OCCURS(UPPER(V_NAZION_CON),UPPER(V_CONSEGNATO)) = 0
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
**    SERGIO 2011_12_13 

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
*!*	 LUCA 2012-12-02 
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
*!*	 FINE LUCA 2012-12-02 
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
   
   *** SIMONE - 10/10/2008
   IF ALLTRIM(ORD_DESART) <> "*** COMMENTO ***"   && CONTO SOLO LE RIGHE CHE NON SONO COMMENTI
	   IF SUBSTR(ORD_CODART,1,7) <> 'POLIECO'
	   		_CNT_ARTICOLI = _CNT_ARTICOLI + 1
	   ENDIF
   ENDIF   
   IF SUBSTR(ORD_CODART,1,7) = 'POLIECO'
   		PUB_TOTPOLIECO = PUB_TOTPOLIECO + ORD_VALORE
   ENDIF   
   *** SIMONE - 10/10/2008   
   
   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("XU_OFF_DD")
   
   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
      *** SIMONE - 10/10/2008
      _CNT_PUBBLI = _CNT_PUBBLI + 1		
      *** SIMONE - 10/10/2008       
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


   SELECT XU_OFF_DD

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
V_SPESE   = V_SPINCA + V_SPTRAS

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

SELECT XU_OFF_DD
GO TOP

ANCORA = 1




__PROGRAMMA__    = "OFFPJEUR"
__REPORTNEW__    = "OFFPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))

IF !EMPTY(_par_custom_report)
	__REPORT__ = ALLTRIM(_par_custom_report)
ENDIF

DO CASE
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


IF PUB_CREA_FILE_PDF
	SELECT XU_OFF_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "PRE-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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
PROCEDURE RISTA_OFF_ORIGINALE
*******************

**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

PUBLIC ULT_PAG
NUMPRO=TAGGANCIO

SELECT XU_OFF_DD

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

v_seek	 = PUB_CODSOC
v_chiave = "azi_codsoc"
IF seek_std('u_azi_an',v_seek,v_chiave,'CUR_AZIENDA')
   SELECT CUR_AZIENDA
   V_TESTATA1 = ALLTRIM(AZI_RAGSOC)
   V_TESTATA2 = ALLTRIM(AZI_FABBR)
   V_TESTATA3 = AZI_CAP+ " "+ ALLTRIM(AZI_LOCALI)+"-"+ALLTRIM(AZI_INDIRI)+" "+ALLTRIM(AZI_PIVA)
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
   V_RAGSOC = ALLTRIM(M.ORD_RAGSOC)  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = ALLTRIM(M.ORD_INDIRI)  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
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
   IF !EMPTY(ALLTRIM(V_RAGDUE))  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
      V_INTESTA=V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   IF !EMPTY(ALLTRIM(V_RAGTRE))  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
      V_INTESTA=V_INTESTA+V_RAGTRE+CHR(13)
   ENDIF
   IF !EMPTY(ALLTRIM(V_RAGQUA))  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
      V_INTESTA=V_INTESTA+V_RAGQUA+CHR(13)
   ENDIF
   V_PROVIN = ALLTRIM(M.ORD_PROVIN)  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(ALLTRIM(M.ORD_RAGC))  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
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
  ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = V_CODCLI			&& 2010-08-04 sergio posticipi per tutto l'anno


ELSE
   DL_LINGUA  = ""
   WAIT WINDOWS "Cliente inesistente"+V_CODCLI
   V_CFISC = " "
   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
  ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 


ENDIF

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

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_OFF_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_OFF_DD","ALIQUOTA")  && ERASMO - 21/09/2011

*V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
V_IMPSP   = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
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


v_seek    = 'IVA'+IVA2
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
   IF IVA2 = PUB_IVADEF  && ERASMO - 21/09/2011
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

v_seek    = 'IVA'+IVA4
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
   IF IVA4 = PUB_IVADEF  && ERASMO - 21/09/2011
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

*!*	DO CASE
*!*	   CASE _V_OPZSTA = 1
*!*	      FOR I = 1 TO _V_NUMCOPIE
*!*	         REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE TO PRINTER
*!*	      NEXT
*!*	   CASE _V_OPZSTA = 2
*!*	      REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE PREVIEW
*!*	   CASE _V_OPZSTA = 3
*!*	      REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE PREVIEW
*!*	      FOR I = 1 TO _V_NUMCOPIE
*!*	         REPORT FORM "REPORT\OFFPJEUR.FRX" NOEJECT NOCONSOLE TO PRINTER
*!*	      NEXT            
*!*	ENDCASE

**=> ERASMO - INIZIO 19/11/2008 - MODIFICATO DAL CLIENTE
__PROGRAMMA__    = "OFFPJEUR"
__REPORTNEW__    = "OFFPJEUR.FRX"
__REPORT__       = ALLTRIM(CERCAREPO("XXX",__PROGRAMMA__,__REPORTNEW__))
   
DO CASE
   *CASE _V_OPZSTA = 1 
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE
**=> ERASMO - FINE 19/11/2008 - MODIFICATO DAL CLIENTE

*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_OFF_DD
	GO TOP   
    *___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,1,2)+"-"+SUBSTR(M.ORD_DATORD,4,2)+"-"+SUBSTR(M.ORD_DATORD,7,4)  && ERASMO - 07/06/2007
	_PDF_DESCRIZIONE_	= "OFF-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_OFF_DD"
	*_PDF_REPORT_ 		= "REPORT\OFFPJEUR.FRX"
	_PDF_REPORT_ 		= __REPORT__  && ERASMO - 19/11/2008 - MODIFICATO DAL CLIENTE
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("OFF")
	IF !EMPTY(_cSubDirectory)
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
	ELSE
		=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	ENDIF
	**=> ERASMO - FINE 03/02/2012
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
RELEASE V_NUMLEI
RELEASE V_DATLEI
RELEASE V_NUCONS
RELEASE V_DTCONS
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

**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

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
   V_NAZION = ""  && LUCA - 11/03/2013
   
   
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
     
     **=> LUCA - INIZIO 11/03/2013
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
     **=> LUCA - FINE 11/03/2013
   ENDIF  
   
   
   V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)
   *V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      *V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(ORD_INDC)+CHR(13)+ALLTRIM(ORD_CAPC)+" "+ALLTRIM(ORD_LOCC)+" ("+ALLTRIM(ORD_PROC)+")"
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+IIF(!EMPTY(ORD_ATTENZIONE),"All'attenzione di "+ALLTRIM(ORD_ATTENZIONE)+CHR(13),"")+ ;
      	ALLTRIM(ORD_INDC)+CHR(13)+ALLTRIM(ORD_CAPC)+" "+ALLTRIM(ORD_LOCC)+ IIF(!EMPTY(ORD_PROC)," ("+ALLTRIM(ORD_PROC)+")","") && ERASMO - 10/12/2013
   ENDIF
   
   **=> LUCA - INIZIO 11/03/2013
   V_INTESTA    = V_INTESTA+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+ IIF(!EMPTY(V_PROVIN)," ("+ALLTRIM(V_PROVIN)+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = ALLTRIM(V_INTESTA) + CHR(13) + ALLTRIM(V_NAZION)
      ENDIF
   ENDIF
   **=> LUCA - FINE 11/03/2013

   V_NUMOFC = ORD_NUMOFC	&& SERGIO 05/06/2007
   V_DATOFC = ORD_DATOFC	&& SERGIO 05/06/2007
   V_CDC	= ORD_CDC		&& SERGIO 05/06/2007
 
   V_NUMCOC = ORD_NUMCOC	&& SERGIO 05/06/2007
   V_DATCOC = ORD_DATCOC	&& SERGIO 05/06/2007


ELSE
   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA
   V_NAZION = ""  && LUCA - 11/03/2013
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
     
     **=> LUCA - INIZIO 11/03/2013
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
     **=> LUCA - FINE 11/03/2013
   ENDIF  
   
   
   *V_INTESTA = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+" ("+ALLTRIM(V_PROVIN)+")"
   IF !EMPTY(M.ORD_RAGC)
      *V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+" ("+ALLTRIM(M.ORD_PROC)+")"
      V_DESTI=ALLTRIM(M.ORD_RAGC)+CHR(13)+IIF(!EMPTY(M.ORD_ATTENZIONE),"All'attenzione di "+ALLTRIM(M.ORD_ATTENZIONE)+CHR(13),"")+ ;
      	ALLTRIM(M.ORD_INDC)+CHR(13)+ALLTRIM(M.ORD_CAPC)+" "+ALLTRIM(M.ORD_LOCC)+ IIF(!EMPTY(M.ORD_PROC)," ("+ALLTRIM(M.ORD_PROC)+")","") && ERASMO - 10/12/2013
   ENDIF
   
   **=> LUCA - INIZIO 11/03/2013
   V_INTESTA    = ALLTRIM(V_RAGSOC)+CHR(13)+ALLTRIM(V_INDIRI)+CHR(13)+ALLTRIM(V_CAP)+" "+ALLTRIM(V_LOCALI)+ IIF(!EMPTY(V_PROVIN)," ("+ALLTRIM(V_PROVIN)+")","")
   IF ALLTRIM(UPPER(V_NAZION)) <> 'ITALIA' AND !EMPTY(V_NAZION)
      IF OCCURS(UPPER(V_NAZION),UPPER(V_INTESTA)) = 0
         V_INTESTA = ALLTRIM(V_INTESTA) + CHR(13) + ALLTRIM(V_NAZION)
      ENDIF
   ENDIF
   **=> LUCA - FINE 11/03/2013

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
 
 
   **=> LUCA - INIZIO 11/03/2013
     v_seek = 'STA'+ALLTRIM(CLI_NAZION)
     v_chiave = "codice"
     IF seek_std('para',v_seek,v_chiave,'TMP_PARA')
        SELECT TMP_PARA
        V_NAZION = ALLTRIM(DESCRI)
     ENDIF
     **=> LUCA - FINE 11/03/2013

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
       SAY_PORTO    = _DESCR_LINGUA   
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

**=> ERASMO - INIZIO 09/01/2012
RELEASE IMPO_MAGG,IMPOS_MAGG
PUBLIC IMPO_MAGG,IMPOS_MAGG
IMPO_MAGG  = 0
IMPOS_MAGG = 0
**=> ERASMO - FINE 09/01/2012

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
   
   **=> ERASMO - INIZIO 09/01/2012
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
   **=> ERASMO - FINE 09/01/2012

   CTR_REC = CTR_REC +1

   SELECT XU_ORD_DD
   SKIP +1

ENDDO

ULT_PAG = CTR_REC / 5

**=> ERASMO - INIZIO 09/01/2012
IMPO_MAGG = ROUND(IMPO_MAGG,2)
IMPOS_MAGG = ROUND(IMPOS_MAGG,2)
**=> ERASMO - FINE 09/01/2012

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORD_DD","ALIQUOTA")  && ERASMO - 21/09/2011

*V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
V_IMPSP   = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
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
**=> ERASMO - INIZIO 09/01/2012
TOT_IMPO	= TOT_IMPO + IMPO_MAGG 
TOT_IMPOS	= TOT_IMPOS + IMPOS_MAGG
**=> ERASMO - FINE 09/01/2012
TOT_ORDT    =   TOT_IMPO + TOT_IMPOS - MATPUB

**=> ERASMO/LUCA/FILIPPO - INIZIO 24/01/2013
PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")
IF ALLTRIM(PUB_IVADEF) $ (ALLTRIM(IVA1)+';'+ALLTRIM(IVA2)+';'+ALLTRIM(IVA3)+';'+ALLTRIM(IVA4)+';'+ALLTRIM(IVA5))
ELSE
	TOT_IMPO = TOT_IMPO + V_SPESE
	_ESENZI = .F.
	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + V_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select CLI_ALRID from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"CUR_CLIENTE")
	   RETURN .F.
	ENDIF
	SELECT CUR_CLIENTE
	GO TOP
	IF EOF()
	   _ALRID = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")
	ELSE
	   _ALRID = CLI_ALRID
	   IF !EMPTY(CLI_ALRID)
	      _ESENZI = .T.			&& CLIENTE IN ESENZIONE
	   ELSE
	      _ALRID  = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")
	      _ESENZI = .F.			&& CLIENTE NON IN ESENZIONE
	   ENDIF
	ENDIF
	IF !_ESENZI
		TOT_IMPOS = TOT_IMPOS + V_IMPSP
	ENDIF
ENDIF
**=> ERASMO/LUCA/FILIPPO - FINE 24/01/2013



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

**=> ERASMO - INIZIO 11/06/2013
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
**=> ERASMO - FINE 11/06/2013

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
   *CASE _V_OPZSTA = 1 
   CASE (_V_OPZSTA = 1 OR _V_OPZSTA = 4)  && ERASMO 04/01/2012
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE




*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORD_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORD-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_ORD_DD"
	_PDF_REPORT_ 		= __REPORT__ 
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("ORD")
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


*******************
PROCEDURE RISTA_ORF
*******************

**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

PUBLIC ULT_PAG
NUMPRO = TAGGANCIO
   
SELECT XU_ORF_DD
*SET FILTER TO (ORS_DATORD = M.ORD_DATORD) .AND. (ORS_NUMORD = M.ORD_NUMORD) .AND. (ORS_CODCLI = M.ORD_CODCLI)
SET FILTER TO DAGGANCIO = M.TAGGANCIO  && ERASMO - 07/10/2011
   
*RELEASE DATA

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
   FLAG_STAMPA_ORDINI_IN_INGLESE = FOR_FLGTEL
ELSE
   WAIT WINDOWS "Fornitore inesistente "+V_CODCLI
   V_CFISC = " "
   V_TEL   = SPACE(12)
   V_FAX   = SPACE(12)
   FLAG_STAMPA_ORDINI_IN_INGLESE = .F.
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
V_SPESE   = V_SPINCA + V_SPTRAS

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORF_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORF_DD","ALIQUOTA")  && ERASMO - 21/09/2011

*V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
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

*!*	DO PERIODI
*!*	DO VAR_PERI

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
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE



*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORF_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORF-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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

**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

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
V_SPESE   = V_SPINCA + V_SPTRAS

PUB_IVADEF = CERCA_IVA_DEFAULT("XU_ORD_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("XU_ORD_DD","ALIQUOTA")  && ERASMO - 21/09/2011

*V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
V_IMPSP   = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
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
         REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM "REPORT\ORDPJEUT.FRX" NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE


*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_ORD_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "ORT-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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

**=> ERASMO - INIZIO 06/06/2011
RELEASE FILE_PDF_APPENA_GENERATO
PUBLIC FILE_PDF_APPENA_GENERATO
FILE_PDF_APPENA_GENERATO = ""
**=> ERASMO - FINE 06/06/2011

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
            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
         NEXT
      CASE _V_OPZSTA = 2
         REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE PREVIEW
      CASE _V_OPZSTA = 3
         REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE PREVIEW
         FOR __I = 1 TO _V_NUMCOPIE
            REPORT FORM "REPORT\BOLPJRES.FRX" NOEJECT NOCONSOLE TO PRINTER
         NEXT            
   ENDCASE   
 
	*!*	INIZIO 15/03/2007 SERGIO
	IF PUB_CREA_FILE_PDF
		SELECT XU_BOL_DD
		GO TOP   
	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
		_PDF_DESCRIZIONE_	= "REC-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE

*SERX??

*!*	*!*	INIZIO 15/03/2007 SERGIO
*!*	IF PUB_CREA_FILE_PDF
*!*		SELECT XU_BOL_DD
*!*		GO TOP   
*!*	    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
*!*		_PDF_DESCRIZIONE_	= "REF-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
*!*		_PDF_SELECT_ 		= "XU_BOL_DD"
*!*		_PDF_REPORT_ 		= "REPORT\BOLPJRESFOR.FRX"
*!*		*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
*!*		**=> ERASMO - INIZIO 03/02/2012
*!*		_cSubDirectory = SUBDIR_FILE_PDF("REF")
*!*		IF !EMPTY(_cSubDirectory)
*!*			=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_cSubDirectory)
*!*		ELSE
*!*			=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
*!*		ENDIF
*!*		**=> ERASMO - FINE 03/02/2012
*!*	ENDIF
*!*	*!*	FINE 15/03/2007 SERGIO



YYY_PROGRAMMA = "BOLPJRESFOR"
YYY_REPORT    = "BOLPJRESFOR.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "REF-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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


*!*	INIZIO 15/03/2007 SERGIO
**********************
FUNCTION CREA_FILE_PDF
**********************
PARAMETERS _pdf_select,_pdf_report,_pdf_descrizione,_pdf_sotto_directory

IF PCOUNT()=4
	_pdf_sotto_directory____= ALLTRIM(_pdf_sotto_directory)
ELSE 
	_pdf_sotto_directory____= ""
ENDIF

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
	RETURN .F.
ENDIF

**=> ERASMO - INIZIO 22/04/2012
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
		_COMMAND = "MKDIR &_V_DIRECTORY_FILE_PDF"
		&_COMMAND
	ENDIF
ENDIF
**=> ERASMO - FINE 22/04/2012

IF  !empty(_pdf_sotto_directory____)
	_DIRECTORY_PDF = _DIRECTORY_PDF+"\"+_pdf_sotto_directory____
	IF DIRECTORY(_DIRECTORY_PDF)
	ELSE
	   *MKDIR &_DIRECTORY_PDF 
		_COMMAND = "MKDIR &_DIRECTORY_PDF"
		&_COMMAND
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
do PRG\creapdf1 with ActiveConfig,tnFileType,txtTabella,txtReportPath,txtExportPath,exeAutomatic,txtEmailOutput,txtOggettoOutput
SET DEFA TO &PUB_DIR

*!*	**=> ERASMO - INIZIO 14/08/2008
*!*	RELEASE FILE_PDF_APPENA_GENERATO
*!*	PUBLIC FILE_PDF_APPENA_GENERATO
*!*	FILE_PDF_APPENA_GENERATO = txtExportPath
*!*	**=> ERASMO - FINE 14/08/2008

FILE_PDF_APPENA_GENERATO = IIF(EMPTY(FILE_PDF_APPENA_GENERATO),txtExportPath,FILE_PDF_APPENA_GENERATO + " ; " + txtExportPath)  && ERASMO - 06/06/2011

SELECT &S3S

RETURN

*!*	FINE 15/03/2007 SERGIO


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
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE

*SERX??



YYY_PROGRAMMA = "BOLXILCTLFO"
YYY_REPORT    = "BOLXILCTLFO.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

*!*	INIZIO 15/03/2007 SERGIO
IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "CTL-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
	_PDF_SELECT_ 		= "XU_BOL_DD"
	_PDF_REPORT_ 		= YYY_FILOUT    
	*=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
	**=> ERASMO - INIZIO 03/02/2012
	_cSubDirectory = SUBDIR_FILE_PDF("CTL")
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

RELEASE SAY_PORTO,SAY_ACURA,SAY_CAUS,SAY_CPA,SAY_BANCA,SAY_CCODES,SAY_ASPETT
PUBLIC  SAY_PORTO,SAY_ACURA,SAY_CAUS,SAY_CPA,SAY_BANCA,SAY_CCODES,SAY_ASPETT
SAY_PORTO    = ""
SAY_ACURA    = ""
SAY_CAUS     = ""
SAY_CPA      = ""
SAY_BANCA    = ""
SAY_CCODES   = ""
SAY_ASPETT   = ""

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
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT
   CASE _V_OPZSTA = 2
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
   CASE _V_OPZSTA = 3
      REPORT FORM &__REPORT__ NOEJECT NOCONSOLE PREVIEW
      FOR __I = 1 TO _V_NUMCOPIE
         REPORT FORM &__REPORT__ NOEJECT NOCONSOLE TO PRINTER
      NEXT            
ENDCASE

YYY_PROGRAMMA = "BOLPJITA"
YYY_REPORT    = "BOLPJITA.FRX"
YYY_FILOUT    = CERCAREPO("XXX",YYY_PROGRAMMA,YYY_REPORT)

IF PUB_CREA_FILE_PDF
	SELECT XU_BOL_DD
	GO TOP   
    ___DATA_DOC         = SUBSTR(M.ORD_DATORD,9,2)+"-"+SUBSTR(M.ORD_DATORD,6,2)+"-"+SUBSTR(M.ORD_DATORD,1,4)
	_PDF_DESCRIZIONE_	= "CTL-n-"+ALLTRIM(M.ORD_NUMORD)+"-del-"+___DATA_DOC+ "-"+TOGLI_CARATTERI_SPECIALI(ALLTRIM(SUBSTR(M.ORD_RAGSOC,1,35)))
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
