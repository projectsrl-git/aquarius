* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK
*SET STEP ON 
*!*	x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
*!*	x_anno = "ord_anno = '" + PUB_ANNO + "'"
*!*	x_cond = x_soci
*!*	IF DOC_ANNO
*!*	   x_cond = x_cond + " and " + x_anno
*!*	ENDIF

x_cond="1=1"

DO CASE

	CASE V_SCELTA=1          				&& Codice componente
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codart = "mpa_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codart
           ENDIF
        ELSE
           x_codart = "mpa_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codart
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by mpa_codart" 

	

	CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desart = "mpa_desart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desart
           ENDIF
        ELSE
           x_cage = "mpa_desart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desart
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by mpa_desart" 
  
   CASE V_SCELTA=3         				&& Ragione sociale fornitore
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "mpa_desfor like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "mpa_desfor like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_mpa_cq where " + x_cond + ;
                                                 " order by mpa_desfor" 
    
    CASE V_SCELTA=4         				&& ordine fornitore
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "MPA_NUMORF like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "MPA_NUMORF like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_mpa_cq where " + x_cond + ;
                                                 " order by MPA_NUMORF" 
                                                                                              
	
	CASE V_SCELTA=5          				&& Data ordine fornitore
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "MPA_DATORF= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "MPA_DATORF = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by MPA_DATORF" 	                                                   

CASE V_SCELTA=6          				&& Data carico magazzino
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "MPA_DTCAMA= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "MPA_DTCAMA = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by MPA_DTCAMA" 	                                                   
  
  
    CASE V_SCELTA=7         				&& num lot     
           IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "MPA_NUMLOT like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "MPA_NUMLOT like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_mpa_cq where " + x_cond + ;
                                                 " order by MPA_NUMLOT" 
            
     CASE V_SCELTA=8          				&& Data carico in CQ
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "MPA_DTCACQ = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "MPA_DTCACQ = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by MPA_DTCACQ" 	                                                   
  
   
   CASE V_SCELTA=9          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "MPA_RESPO1 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "MPA_RESPO1 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by MPA_RESPO1" 
                                                   
   CASE V_SCELTA=10          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "MPA_RESDT1 = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "MPA_RESDT1= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                  " order by MPA_RESDT1" 
                   
  CASE V_SCELTA=11          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "MPA_RESPO2 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "MPA_RESPO2 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                   " order by MPA_RESPO2" 
                                                   
   CASE V_SCELTA=12          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "MPA_RESDT2 = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "MPA_RESDT2= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                  " order by MPA_RESDT2"
                                                  
   CASE V_SCELTA=13          				&& ACCESSO PER NUMERO LOTTO INTERNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nlot = "RIGHT(RTRIM(mpa_codart),8) like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nlot 
           ENDIF
        ELSE
           x_nlot = "RIGHT(RTRIM(mpa_codart),8) like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nlot 
        ENDIF
        _ii_cSql   = "select * from u_mpa_cq where " + x_cond + ;
                                                  " order by RIGHT(RTRIM(mpa_codart),8)"
	  	
ENDCASE
RETURN



