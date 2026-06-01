PARAMETERS V_SEEK

x_soci  = "rid_codsoc = '" + PUB_CODSOC + "'"
x_banca = "rid_banca = '" + ALLTRIM(V_SEEK) + "'"
x_cond = x_soci  + " and " + x_banca 

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER CODICE BANCA
        _ii_cSql   = "select * from u_rid_an where " + x_cond + ;
                                                   " order by rid_codsoc,rid_banca" 
 
		  	
ENDCASE