*******************
PROCEDURE RISTA_CTL
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
   SAY_CAUS=ALLTRIM(SUBSTR(DESCRI,1,90))
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
   XX_UFFIVA = SPACE(50)
   XX_DELDOC = SPACE(50)
   SAY_TELEFO   = "" 					&& SERGIO 15/12/2011
ELSE
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
