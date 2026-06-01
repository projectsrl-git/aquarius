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

	CASE V_SCELTA=1          				&&Codice Film Nudo
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codart = "mpf_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codart
           ENDIF
        ELSE
           x_codart = "mpf_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codart
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_codart" 

	

	CASE V_SCELTA=2          				&& Descrizione Film Nudo
		IF PUB_VISRIC 
            IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desart = "mpf_desart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desart
           ENDIF
        ELSE
           x_cage = "mpf_desart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desart
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_desart" 
  
   CASE V_SCELTA=3         				&& Ragione sociale fornitore
       IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "mpf_desfor like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "mpf_desfor like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_mpf_cq where " + x_cond + ;
                                                 " order by mpf_desfor" 
    
    CASE V_SCELTA=4         				&& ordine fornitore
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "mpf_NUMORF like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "mpf_NUMORF like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_mpf_cq where " + x_cond + ;
                                                 " order by mpf_NUMORF" 
                                                                                              
	
	CASE V_SCELTA=5          				&& Data ordine fornitore
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "mpf_DATORF= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "mpf_DATORF = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_DATORF" 	                                                   

CASE V_SCELTA=6          				&& Data carico magazzino
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "mpf_DTCAMA= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "mpf_DTCAMA = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_DTCAMA" 	                                                   
  
  
    CASE V_SCELTA=7         				&& num lot     
           IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "mpf_NUMLOT like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "mpf_NUMLOT like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_mpf_cq where " + x_cond + ;
                                                 " order by mpf_NUMLOT" 
            
     CASE V_SCELTA=8          				&& Data carico in CQ
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "mpf_DTCACQ = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "mpf_DTCACQ = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_DTCACQ" 	                                                   
  
   
   CASE V_SCELTA=9          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "mpf_RESPO1 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "mpf_RESPO1 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_RESPO1" 
                                                   
   CASE V_SCELTA=10          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "mpf_RESDT1 = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "mpf_RESDT1= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                  " order by mpf_RESDT1" 
                   
  CASE V_SCELTA=11          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "mpf_RESPO2 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "mpf_RESPO2 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                   " order by mpf_RESPO2" 
                                                   
   CASE V_SCELTA=12          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "mpf_RESDT2 = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "mpf_RESDT2= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_mpf_cq where " + x_cond + ;
                                                  " order by mpf_RESDT2" 
                                                  
   CASE V_SCELTA=13          				&& ACCESSO PER NUMERO LOTTO INTERNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nlot = "RIGHT(RTRIM(mpf_codart),8) like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nlot 
           ENDIF
        ELSE
           x_nlot = "RIGHT(RTRIM(mpf_codart),8) like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nlot 
        ENDIF
        _ii_cSql  = "select * from u_mpf_cq where " + x_cond + ;
                                                  " order by RIGHT(RTRIM(mpf_codart),8)"
                                                  
   CASE V_SCELTA=14          				&& ACCESSO PER SPESSORE FILM NUDO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_spes = "mpf_spesso = " + ALLTRIM(V_SEEK)
              x_cond = x_cond + " and " + x_spes
           ENDIF
        ELSE
           x_spes = "mpf_spesso = " + ALLTRIM(V_SEEK)
           x_cond = x_cond + " and " + x_spes
        ENDIF
        _ii_cSql  = "select * from u_mpf_cq where " + x_cond + ;
                                                  " order by mpf_spesso"
                                                  
   CASE V_SCELTA=15          				&& ACCESSO PER ALTEZZA FILM NUDO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_alte = "mpf_altezz = " + ALLTRIM(V_SEEK)
              x_cond = x_cond + " and " + x_alte
           ENDIF
        ELSE
           x_alte = "mpf_altezz = " + ALLTRIM(V_SEEK)
           x_cond = x_cond + " and " + x_alte
        ENDIF
        _ii_cSql  = "select * from u_mpf_cq where " + x_cond + ;
                                                  " order by mpf_altezz"                                                  
	  	
ENDCASE
RETURN



