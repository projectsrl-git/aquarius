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

	CASE V_SCELTA=1          				&&Codice Film 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codart = "slf_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codart
           ENDIF
        ELSE
           x_codart = "slf_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codart
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by slf_codart" 

	

	CASE V_SCELTA=2          				&& Descrizione Film 
		IF PUB_VISRIC 
            IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desart = "slf_desart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desart
           ENDIF
        ELSE
           x_cage = "slf_desart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desart
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by slf_desart" 
 	
		                                                   
 CASE V_SCELTA=3         				&& num lot     
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "slf_NUMLOT like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "slf_NUMLOT like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_slf_cq where " + x_cond + ;
                                                 " order by slf_NUMLOT" 
     
 
    CASE V_SCELTA=4         				&& Ragione sociale fornitore
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "SLF_DESFOR like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "SLF_DESFOR like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_slf_cq where " + x_cond + ;
                                                 " order by SLF_DESFOR" 
                                                                          

	CASE V_SCELTA=5          				&& num lot
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "SLF_FNNULO like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "SLF_FNNULO like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by SLF_FNNULO" 
				
	CASE V_SCELTA=6          				&& Ragione sociale cliente
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "SLF_descli like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "SLF_descli like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by SLF_descli" 	                                                   
  
  
   
            
     CASE V_SCELTA=7          				&& Data carico in CQ
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "slf_DTCACQ = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "slf_DTCACQ = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by slf_DTCACQ" 	                                                   
 

   
   CASE V_SCELTA=8          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "slf_RESPO1 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "slf_RESPO1 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by slf_RESPO1" 
                                                   
   CASE V_SCELTA=9          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "slf_RESDT1 = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "slf_RESDT1= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                  " order by slf_RESDT1" 
                   
  CASE V_SCELTA=10          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "slf_RESPO2 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "slf_RESPO2 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                   " order by slf_RESPO2" 
      
                                                   
   CASE V_SCELTA=11          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "slf_RESDT2 = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "slf_RESDT2= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                  " order by slf_RESDT2" 
                                                  
   CASE V_SCELTA=12          				&& ACCESSO PER NUMERO LOTTO INTERNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nlot = "RIGHT(RTRIM(slf_codart),8) like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nlot 
           ENDIF
        ELSE
           x_nlot = "RIGHT(RTRIM(slf_codart),8) like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nlot 
        ENDIF
        _ii_cSql   = "select * from u_slf_cq where " + x_cond + ;
                                                  " order by RIGHT(RTRIM(slf_codart),8)"                                                  
	  	
ENDCASE

RETURN
		
		


