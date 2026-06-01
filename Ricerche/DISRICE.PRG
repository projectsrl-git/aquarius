* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

PUB_VISRIC = .F.  && FORZATURA PER PROBLEMA IMPAGINAZIONE

DO CASE

	CASE V_SCELTA=1								  && ACCESSO PER CODICE
		  IF PUB_VISRIC 
			  IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
			  ELSE
				  x_codi	= "dit_gruppo like '" + ALLTRIM(V_SEEK) + "%'"
				  x_cond	= x_cond + " and " + x_codi
			  ENDIF
		  ELSE
			  x_codi	= "dit_gruppo like '" + ALLTRIM(V_SEEK) + "%'"
			  x_cond	= x_cond + " and " + x_codi
		  ENDIF
		  _ii_cSql = "select * from u_dis_tt where " + x_cond + ;
																 " order by dit_codsoc,dit_gruppo"

	CASE V_SCELTA=2								  && ACCESSO PER DESCRIZIONE 
		  IF PUB_VISRIC 
			  IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
			  ELSE
				  x_codi	= "dit_descri like '" + ALLTRIM(V_SEEK) + "%'"
				  x_cond	= x_cond + " and " + x_codi
			  ENDIF
		  ELSE
			  x_codi	= "dit_descri like '" + ALLTRIM(V_SEEK) + "%'"
			  x_cond	= x_cond + " and " + x_codi
		  ENDIF
		  _ii_cSql = "select * from u_dis_tt where " + x_cond + ;
																 " order by dit_codsoc,dit_descri"
																 
	**=> ERASMO - INIZIO 03/06/2013	
	CASE V_SCELTA=3								  && ACCESSO PER COMPONENTE
		  IF PUB_VISRIC 
			  IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
			  ELSE
				  x_codi	= "taggancio in (select daggancio from u_dis_dd where dis_codart = '" + ALLTRIM(V_SEEK) + "')"
				  x_cond	= x_cond + " and " + x_codi
			  ENDIF
		  ELSE
			  x_codi	= "taggancio in (select daggancio from u_dis_dd where dis_codart = '" + ALLTRIM(V_SEEK) + "')"
			  x_cond	= x_cond + " and " + x_codi
		  ENDIF
		  _ii_cSql = "select * from u_dis_tt where " + x_cond + ;
																 " order by dit_codsoc,dit_gruppo"
	**=> ERASMO - FINE 03/06/2013

ENDCASE

RETURN
