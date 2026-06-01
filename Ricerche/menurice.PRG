PARAMETERS V_SEEK

	DO CASE
	   CASE V_SCELTA=1                          && ACCESSO nome menu
	      _II_SEEK = ALLTRIM(V_SEEK)
	      TEXT TO _ii_cSql NOSHOW
			SELECT *
			FROM tbl_menu
			where menu LIKE ?_II_SEEK+'%'
			and ordine=1
			ORDER BY menu,label,comando
		  ENDTEXT

	   CASE V_SCELTA=2          				&& ricerca nella stringa label
	      _II_SEEK = ALLTRIM(V_SEEK)
	      TEXT TO _ii_cSql NOSHOW
			SELECT *
			FROM tbl_menu
			where label LIKE '%'+?_II_SEEK+'%'
			ORDER BY menu,label,comando
		  ENDTEXT

	   CASE V_SCELTA=3          				&& ACCESSO PER PARTITA IVA
	      _II_SEEK = ALLTRIM(V_SEEK)
	      TEXT TO _ii_cSql NOSHOW
			SELECT *
			FROM tbl_menu
			where comando LIKE '%'+?_II_SEEK+'%'
			ORDER BY menu,label,comando
		  ENDTEXT


	ENDCASE
