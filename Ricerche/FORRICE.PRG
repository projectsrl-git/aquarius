PARAMETERS V_SEEK

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

IF _OPZ_TUTTI
ELSE
   x_tutt = "for_obsol <> 'S'"
   x_cond = x_cond + " and " + x_tutt
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "for_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_ragsoc" 
        ELSE
           x_rags = "for_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_ragsoc" 
                                                   
   CASE V_SCELTA=2                          && ACCESSO PER RAGIONE SOCIALE (CONTIENE)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "for_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_ragsoc" 
        ELSE
           x_rags = "for_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_ragsoc" 
   
   CASE V_SCELTA=3          				&& ACCESSO CODICE FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 		      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "for_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_codcli"
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "for_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_codcli"
                                                       
   CASE V_SCELTA=4          				&& ACCESSO PER PARTITA IVA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "for_pariva = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_pariva" 
        ELSE
           x_clie = "for_pariva = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_pariva" 
        
   CASE V_SCELTA=5          				&& RICERCA ALTERNATIVA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rice = "for_ricerc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rice
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_ricerc" 
        ELSE
           x_rice = "for_ricerc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rice
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_ricerc" 

   CASE V_SCELTA=6          				&& RICERCA PER LOCALITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "for_locali like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_locali" 
        ELSE
           x_loca = "for_locali like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_locali" 
                                                   
   CASE V_SCELTA=7          				&& RICERCA PER BANCA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "for_bae like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_bae" 
        ELSE
           x_loca = "for_bae like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_bae"                                                    

   CASE V_SCELTA=8          				&& RICERCA PER TIPOLOGIA DI PAGAMENTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "for_formapagamento like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_formapagamento" 
        ELSE
           x_loca = "for_formapagamento like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_formapagamento"
                                                  
                                                  
   CASE V_SCELTA=9          				&& ACCESSO PER RIFERIMENTO FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clrf = ""
              DO CERCA_FORNITORI_PER_RIFERIMENTO
              x_cond = x_cond + " and " + x_clrf
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_codcli" 
        ELSE
           x_clrf = ""
           DO CERCA_FORNITORI_PER_RIFERIMENTO
           x_cond = x_cond + " and " + x_clrf
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_codcli" 
 
   CASE V_SCELTA=10          				&& ACCESSO PER TIPOLOGIA LISTINO FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "for_lisfor like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_lisfor,for_codcli" 
        ELSE
           x_loca = "for_lisfor like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_lisfor,for_codcli"
   CASE V_SCELTA=11          				&& ACCESSO PER NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rice = "for_nazion like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rice
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_nazion" 
        ELSE
           x_rice = "for_nazion like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rice
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_nazion" 
                                                   
                                                   
   CASE V_SCELTA=12          				&& ACCESSO PER IVA CEE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rice = "for_ivacee = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_rice
           ENDIF
	       _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_ivacee,for_codcli" 
        ELSE
           x_rice = "for_ivacee = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_rice
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_ivacee,for_codcli" 

    CASE V_SCELTA=13          				&& ACCESSO PER CODICE FISCALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "for_codfis = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                      " order by for_codsoc,for_codfis" 
        ELSE
           x_clie = "for_codfis = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from u_for_an where " + x_cond + ;
                                                   " order by for_codsoc,for_codfis" 

        
ENDCASE

RETURN

***************************************
PROCEDURE CERCA_FORNITORI_PER_RIFERIMENTO
***************************************
x_clrf = ""

y_tipo = "rif_clifor = 'F'"
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
      x_clrf = "for_codcli = '" + _CDCLI_RIF + "'"
   ELSE
      x_clrf = x_clrf + " OR for_codcli = '" + _CDCLI_RIF + "'"
   ENDIF
ENDSCAN

x_clrf = "(" + x_clrf + ")"

RETURN


