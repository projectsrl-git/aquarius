
PARAMETERS V_SEEK

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

TEXT TO x_select NOSHOW
	select dbo.ribalta2(ord_datord) as ord_datord_r, 
		CASE coalesce((select top 1 ord_chiuso from CONTRMDB_DD where ord_desart <> '*** COMMENTO ***' and SUBSTRING(ord_codart,1,7) <> 'POLIECO' and ord_chiuso = 0 and daggancio=TT.TAGGANCIO),1) 
			WHEN 1 THEN 'C'
			ELSE 'A'
		END	as ORD_CHIUSO_DD,
		COALESCE(SUBSTRING(para_TPO.descri,1,50),'') as DES_TIPOLOGIA,
		TT.* from CONTRMDB AS TT
		left outer join para as para_TPO on para_TPO.codice = 'TPO'+TT.ord_tipologia
	where 
ENDTEXT

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
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "ord_numord = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = x_select + x_cond + " order by ord_codsoc,ord_numord,ord_anno" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_datord,ord_numord" 

   CASE V_SCELTA=3          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_ragsoc,ord_anno,ord_numord" 
   CASE V_SCELTA=4          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cage = "ord_age = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cage
           ENDIF
        ELSE
           x_cage = "ord_age = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_cage
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_age,ord_datord,ord_numord" 
	  	
   CASE V_SCELTA=5          				&& ACCESSO PER CODICE CLIENTE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "ord_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
        ELSE
 	       V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "ord_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_codcli,ord_datord,ord_numord" 
   
   CASE V_SCELTA=6          				&& ACCESSO PER LOCALITA' DI DESTINAZIONE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dest = "ord_locc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dest 
           ENDIF
        ELSE
           x_dest = "ord_locc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dest 
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_ragsoc,ord_anno,ord_numord"
   
   CASE V_SCELTA=7          				&& ACCESSO PER CAUSALE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dest = "ord_caus like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dest 
           ENDIF
        ELSE
           x_dest = "ord_caus like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dest 
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_caus,ord_anno,ord_numord"
        
   CASE V_SCELTA=8          				&& ACCESSO PER CODICE TIPOLOGIA DOCUMENTO
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(3,ALLTRIM(V_SEEK))
              x_cdtp = "ord_tipologia = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cdtp
           ENDIF
        ELSE
              V_SEEK = TRC(3,ALLTRIM(V_SEEK))
              x_cdtp = "ord_tipologia = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cdtp
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_tipologia,ord_datord"

   CASE V_SCELTA=9          				&& ACCESSO PER DESCRIZIONE TIPOLOGIA DOCUMENTO
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dstp = "para_TPO.descri like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dstp 
           ENDIF
        ELSE
           x_dstp = "para_TPO.descri like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dstp 
        ENDIF
        _ii_cSql   = x_select + x_cond + " order by ord_codsoc,ord_tipologia,ord_datord"
		           
ENDCASE

RETURN



