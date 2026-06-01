* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
IF XXX_TIPO
   x_flag = "ord_flgtip = '1'"
ELSE
   x_flag = "ord_flgtip = '0'"
ENDIF
x_cond = x_soci + " and " + x_flag
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

**=> ERASMO - INIZIO 16/04/2025
IF _OPZ_TUTTI
ELSE
   x_tutt = "ORD_TIPOLOGIA NOT IN (SELECT SUBSTRING(CODICE,4,3) FROM PARA WHERE CODICE LIKE 'TPO%' AND CODPGO='ANNULLATO')"
   x_cond = x_cond + " and " + x_tutt
ENDIF
**=> ERASMO - FINE 16/04/2025

*_c_prfx = "select dbo.ribalta2(ord_datord) as ord_datord_r, case ord_flgcon when 1 then 'SI' else '' end as ORD_FLGCON_C, case ord_chiuso when 1 then 'CHIUSO' else '' end as ORD_CHIUSO_C, * from u_orf_tt where "  && ERASMO - 02/04/2015
_c_prfx = "select ORD_DTCONS,dbo.ribalta2(ord_datord) as ord_datord_r, case ord_flgcon when 1 then 'SI' else '' end as ORD_FLGCON_C, case ord_chiuso when 1 then 'CHIUSO' else '' end as ORD_CHIUSO_C, " + ;
	"dbo.ribalta2(ord_dtcons) as ord_dtcons_r, (select COUNT(*) from ATTACHMENTS where TIPO = 'ORF' AND IDDOCUMENTO = u_orf_tt.TAGGANCIO) as CONTA_ATCH, * from u_orf_tt where "  && ERASMO - 17/10/2022

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER NUMERO
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "ord_numord = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           *_ii_cSql = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                    " order by ord_codsoc,ord_numord,ord_anno" 
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "ord_numord = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        *_ii_cSql = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                 " order by ord_codsoc,ord_numord,ord_anno"
                                                 
		_ii_cSql = _c_prfx + x_cond + " order by ord_codsoc,ord_numord,ord_anno"  && ERASMO - 02/04/2015

   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           *_ii_cSql   = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_datord,ord_numord" 
        ELSE
           x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        *_ii_cSql   = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_datord,ord_numord" 

		_ii_cSql = _c_prfx + x_cond + " order by ord_codsoc,ord_datord,ord_numord"  && ERASMO - 02/04/2015

   CASE V_SCELTA=3          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           *_ii_cSql   = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_ragsoc,ord_numord,ord_anno" 
        ELSE
           x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        *_ii_cSql   = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_ragsoc,ord_numord,ord_anno"
		
		_ii_cSql = _c_prfx + x_cond + " order by ord_codsoc,ord_ragsoc,ord_numord,ord_anno"  && ERASMO - 02/04/2015
                                                   
   CASE V_SCELTA=4          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cage = "ord_age = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cage
           ENDIF
	       *_ii_cSql   = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_age,ord_datord" 
        ELSE
           x_cage = "ord_age = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_cage
        ENDIF
        *_ii_cSql   = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_orf_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_age,ord_numord,ord_datord"
		
		_ii_cSql = _c_prfx + x_cond + " order by ord_codsoc,ord_age,ord_numord,ord_datord"  && ERASMO - 02/04/2015

ENDCASE

RETURN

* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
_x_cond = x_soci
IF DOC_ANNO
   _x_cond = _x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER NUMERO
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_numord < U1.ord_numord"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
		   _x_cond  = _x_cond + " and ord_numord = '" + x_nor0 + "'"
		ENDIF
   		_Ordine = "ord_codsoc,ord_numord,ord_anno"

   CASE V_SCELTA=2                          && ACCESSO PER DATA
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_datord < U1.ord_datord"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = _x_cond + " and ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
        ENDIF
	    _Ordine = "ord_codsoc,ord_datord,ord_numord"

   CASE V_SCELTA=3                          && ACCESSO PER RAGIONE SOCIALE
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_ragsoc < U1.ord_ragsoc"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond	= _x_cond + " and ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
		_Ordine	= "ord_codsoc,ord_ragsoc,ord_anno"

   CASE V_SCELTA=4                          && ACCESSO PER CODICE AGENTE
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_age < U1.ord_age"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
 		   _x_cond	= _x_cond + " and ord_age = '" + ALLTRIM(V_SEEK) + "'"
        ENDIF
		_Ordine	= "ord_codsoc,ord_age,ord_datord"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "u_orf_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN



