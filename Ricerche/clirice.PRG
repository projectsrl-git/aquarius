PARAMETERS V_SEEK

x_soci   = "U_CLI_AN.cli_codsoc = '" + PUB_CODSOC + "'"
*_x_cond	 = " and cli_codsoc = '" + PUB_CODSOC + "'"

* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

x_cond = x_soci
IF _OPZ_TUTTI
ELSE
   x_tutt = "cli_obsol <> 'S'"
   x_cond = x_cond + " and " + x_tutt
   **=> ERASMO - INIZIO 11/07/2016
   *** ESCLUDE I CLIENTI PER COMPENSAZIONI, PRESENTI IN U_FOR_AN.FOR_CLICEE (SE PARAMETRO AZIENDALE ATTIVATO)
   IF PUB_NOCLICEE
	   x_comp = "U_CLI_AN.CLI_CODCLI NOT IN (SELECT FOR_CLICEE FROM U_FOR_AN WHERE FOR_CLICEE<>'')"
	   x_cond = x_cond + " and " + x_comp 
   ENDIF
   **=> ERASMO - FINE 11/07/2016
ENDIF

**=> ERASMO - INIZIO 08/12/2017
*** GESTIONE OPERATORE/AGENTE: PUO' VISUALIZZARE ESCLUSIVAMENTE I SUOI CLIENTI
IF !EMPTY(PUB_AGEOPE)
	x_agop = "CLI_AGE = '" + PUB_AGEOPE + "'"
	x_cond = x_cond + " and " + x_agop
ENDIF
**=> ERASMO - FINE 08/12/2017

**=> ERASMO - INIZIO 21/06/2023
x_sele = "SELECT CLI_NAZION,CLI_RICERC,U_CLI_AN.CLI_CODCLI,CLI_RAGSOC,CLI_INDIR,CLI_LOCALI,CLI_PARIVA,CLI_IVACEE,CLI_BAEFOR,CLI_BAE,CLI_DTCLOK,CLI_CONPAG,CLI_OBSOL,CLI_ZONA,COALESCE(REGIONI.REGIONE,'') AS REGIONE, " + CHR(13) + ;
         "CLI_IDSDI, CLI_EPEC, CLI_CODDIR FROM U_CLI_AN " + CHR(13) + ;
         "LEFT OUTER JOIN PROVINCE ON PROVINCE.SIGLA = CLI_PROVIN " + CHR(13) + ;
         "LEFT OUTER JOIN REGIONI ON REGIONI.CODICE = PROVINCE.REGIONE " + CHR(13) + ;
         "LEFT OUTER JOIN U_ANA_CL ON U_ANA_CL.CLI_CODCLI = U_CLI_AN.CLI_CODCLI " + CHR(13) + ;
         "WHERE "
**=> ERASMO - FINE 21/06/2023

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "cli_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ragsoc" 
        ELSE
           x_rags = "cli_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ragsoc" 
                                                   
   CASE V_SCELTA=2                          && ACCESSO PER RAGIONE SOCIALE (TESTO CONTENUTO)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "cli_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ragsoc" 
        ELSE
           x_rags = "cli_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ragsoc" 
   
   CASE V_SCELTA=3          				&& ACCESSO CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 		      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "U_CLI_AN.cli_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_codcli"
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "U_CLI_AN.cli_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_codcli"
                                                       
   CASE V_SCELTA=4          				&& ACCESSO PER PARTITA IVA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "cli_pariva = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_pariva" 
        ELSE
           x_clie = "cli_pariva = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_pariva" 
        
   CASE V_SCELTA=5          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cage = "cli_age = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cage
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_age,cli_codcli" 
        ELSE
           x_cage = "cli_age = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_cage
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_age,cli_codcli" 

   CASE V_SCELTA=6          				&& RICERCA ALTERNATIVA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rice = "cli_ricerc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rice
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ricerc" 
        ELSE
           x_rice = "cli_ricerc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rice
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ricerc" 
	
   CASE V_SCELTA=7          				&& RICERCA PER LOCALITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "cli_locali like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_locali" 
        ELSE
           x_loca = "cli_locali like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_locali" 
        
   CASE V_SCELTA=8          				&& RICERCA PER CODICE NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nazion = "cli_nazion = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_nazion
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_nazion,cli_codcli" 
        ELSE
           x_nazion = "cli_nazion = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_nazion
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_nazion,cli_codcli" 
 
   CASE V_SCELTA=9          				&& RICERCA PER IVA CEE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "cli_ivacee like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = x_sele + x_cond + ;
                                                      " order by U_CLI_AN.cli_codsoc,cli_ivacee" 
        ELSE
           x_loca = "cli_ivacee like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_ivacee" 
                                                   
   CASE V_SCELTA=10          				&& RICERCA PER BANCA FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "cli_baefor like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = x_sele + x_cond + ;
                                                      " order by U_CLI_AN.cli_codsoc,cli_baefor" 
        ELSE
           x_loca = "cli_baefor like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_baefor"                                                    

   CASE V_SCELTA=11          				&& RICERCA PER BANCA CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "cli_bae like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_bae" 
        ELSE
           x_loca = "cli_bae like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_bae"
                                                   
   CASE V_SCELTA=12          				&& RICERCA PER DATA BLOCCO FORNITURA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "cli_dtclok = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_data 
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_dtamgk" 
        ELSE
           x_data = "cli_dtclok = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_data 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_dtamgk"
                                                   
   CASE V_SCELTA=13          				&& RICERCA PER COD.CONDIZ. PAGAMENTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "cli_conpag = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_data 
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_conpag" 
        ELSE
           x_data = "cli_conpag = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_data 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_conpag"

   CASE V_SCELTA=14          				&& ACCESSO PER CODICE ZONA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_zona = "cli_zona = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_zona
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_zona,cli_codcli" 
        ELSE
           x_zona = "cli_zona = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_zona
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_zona,cli_codcli"                                                    
                                                   
   CASE V_SCELTA=15          				&& ACCESSO PER RIFERIMENTO CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clrf = ""
              DO CERCA_CLIENTI_PER_RIFERIMENTO
              x_cond = x_cond + " and " + x_clrf
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_codcli" 
        ELSE
           x_clrf = ""
           DO CERCA_CLIENTI_PER_RIFERIMENTO
           x_cond = x_cond + " and " + x_clrf
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_codcli" 
 
   CASE V_SCELTA=16          				&& ACCESSO PER TIPOLOGIA LISTINO AZIENDALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_zona = "cli_liscli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_zona
           ENDIF
	       _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_liscli,cli_codcli" 
        ELSE
           x_zona = "cli_liscli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_zona
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_liscli,cli_codcli" 
                                                   
    CASE V_SCELTA=17          				&& ACCESSO PER CODICE FISCALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "cli_codfis = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_codfis" 
        ELSE
           x_clie = "cli_codfis = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_CLI_AN.cli_codsoc,cli_codfis" 
        
   CASE V_SCELTA=18                          && ACCESSO PER REGIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "REGIONI.regione like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by REGIONI.regione,U_CLI_AN.cli_codsoc,cli_ragsoc" 
        ELSE
           x_rags = "REGIONI.regione like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by REGIONI.regione,U_CLI_AN.cli_codsoc,cli_ragsoc" 
        
   **=> ERASMO - INIZIO 23/01/2019
   CASE V_SCELTA=19                          && ACCESSO PER COD.DESTINATARIO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "U_ANA_CL.cli_idsdi like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_ANA_CL.cli_idsdi,U_CLI_AN.cli_codsoc,cli_ragsoc" 
        ELSE
           x_rags = "U_ANA_CL.cli_idsdi like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_ANA_CL.cli_idsdi,U_CLI_AN.cli_codsoc,cli_ragsoc" 
        
   CASE V_SCELTA=20                          && ACCESSO PER PEC E-MAIL
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "U_ANA_CL.cli_epec like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by U_ANA_CL.cli_idsdi,U_CLI_AN.cli_codsoc,cli_ragsoc" 
        ELSE
           x_rags = "U_ANA_CL.cli_epec like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by U_ANA_CL.cli_epec,U_CLI_AN.cli_codsoc,cli_ragsoc" 
   **=> ERASMO - FINE 23/01/2019
   
   **=> ERASMO - INIZIO 23/03/2023        
   CASE V_SCELTA=21                          && ACCESSO PER COD. GRUPPO (O APPLICAZIONE PRODOTTO)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "cli_apppro = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by cli_ragsoc" 
        ELSE
           x_rags = "cli_apppro = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by cli_ragsoc" 
   **=> ERASMO - FINE 23/03/2023
   
   **=> ERASMO - INIZIO 21/06/2023
   CASE V_SCELTA=22                          && ACCESSO PER COD. IMPIANTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              *x_impt = "U_CLI_AN.cli_codcli in (select CCODCLI from impianti_tt where ccodsche like '%" + ALLTRIM(V_SEEK) + "%')"
              *x_impt = "U_CLI_AN.cli_coddir like '%" + ALLTRIM(V_SEEK) + "%'"
              x_impt = "U_CLI_AN.cli_codcli in (select CCODCLI from impianti_tt where ccodsche like '%" + ALLTRIM(V_SEEK) + "%')"  && ERASMO - 20/07/2023
              x_cond = x_cond + " and " + x_impt 
           ENDIF
           _ii_cSql   = x_sele + x_cond + " order by cli_ragsoc" 
        ELSE
           *x_impt = "U_CLI_AN.cli_codcli in (select CCODCLI from impianti_tt where ccodsche like '%" + ALLTRIM(V_SEEK) + "%')"
           *x_impt = "U_CLI_AN.cli_coddir like '%" + ALLTRIM(V_SEEK) + "%'"
           x_impt = "U_CLI_AN.cli_codcli in (select CCODCLI from impianti_tt where ccodsche like '%" + ALLTRIM(V_SEEK) + "%')"  && ERASMO - 20/07/2023
           x_cond = x_cond + " and " + x_impt 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by cli_ragsoc" 
   **=> ERASMO - FINE 21/06/2023

ENDCASE

RETURN

***************************************
PROCEDURE CERCA_CLIENTI_PER_RIFERIMENTO
***************************************
y_tipo = "rif_clifor = 'C'"
y_cogn = "rif_cognom like '" + ALLTRIM(V_SEEK)+ "%'"
y_cond = y_tipo + " and " + y_cogn 
cSql = "select * from U_RIF_CF where " + y_cond + " order by rif_clifor,rif_cognom"
IF !ExecCommand(cSql,"CX_RIF_CF")
  return(.f.)
ENDIF
SELECT CX_RIF_CF
GO TOP
IF EOF()
   x_clrf = "1=0"
   RETURN
ENDIF
SCAN
   _CDCLI_RIF = ALLTRIM(RIF_CODCLI)
   IF EMPTY(ALLTRIM(x_clrf))
      x_clrf = "cli_codcli = '" + _CDCLI_RIF + "'"
   ELSE
      x_clrf = x_clrf + " OR cli_codcli = '" + _CDCLI_RIF + "'"
   ENDIF
ENDSCAN

x_clrf = "(" + x_clrf + ")"

RETURN







