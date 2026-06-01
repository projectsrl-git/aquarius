PARAMETERS V_SEEK


IF EMPTY(V_SEEK)
	V_SEEK = __V_SEEK      
ENDIF


x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci


IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno               
ENDIF


DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER DESCRIZIONE CONTO (CONTENUTO)


	IF PUB_VISRIC 
	   IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	   ELSE
	      IF PUB_RICCONTDES2	      
	      	x_codi   = "con_descr like '" + ALLTRIM(V_SEEK) + "%'"
	      ELSE
	      	x_codi   = "con_descr like '%" + ALLTRIM(V_SEEK) + "%'"
	      ENDIF
	      x_cond   = x_codi
		  
		  IF DOC_ANNO
			   x_cond = x_cond + " and " + x_anno               
		  ENDIF

	   ENDIF
	   _ii_cSql = "select * from conti where " + x_cond + ;
	                                            " order by con_soc,con_anno,con_descr" 
	ELSE
       IF PUB_RICCONTDES2	      
      	 x_codi   = "con_descr like '" + ALLTRIM(V_SEEK) + "%'"
       ELSE
      	 x_codi   = "con_descr like '%" + ALLTRIM(V_SEEK) + "%'"
       ENDIF

	   x_cond   = x_codi

		  
	   IF DOC_ANNO
		   x_cond = x_cond + " and " + x_anno               
	   ENDIF

	ENDIF


ENDCASE

_ii_cSql = "select * from conti where " + x_cond + ;
                                         " order by con_soc,con_anno,con_descr" 
                                         

RETURN

