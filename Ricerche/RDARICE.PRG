
PARAMETERS V_SEEK

x_all  = "1=1"
x_anno = "SUBSTRING(DATA,1,4) = '" + PUB_ANNO + "'"
x_cond = x_all
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

*!*	*** LIMITAZIONE VISIBILITA' RICHIESTE D'ACQUISTO IN BASE ALLE AUTORIZZAZIONI UTENTE
*!*	x_cric = "CODRIC IN ('###'"
*!*	DO VEDO_UTENTI WITH ALLTRIM(PUB_CODOPE)
*!*	SELECT CVEDO_UTENTI
*!*	GO TOP
*!*	SCAN
*!*		x_cric = x_cric + ",'" + ALLTRIM(USERID) + "'"
*!*	ENDSCAN
*!*	x_cric = x_cric + ")"
*!*	x_cond = x_cond + " and " + x_cric

*!*	**=> ERASMO - INIZIO 09/12/2014
*!*	*** FILTRO LE RDA VISUALIZZABILI PER GERARCHIA DEL RICHIEDENTE O PER CENTRO DI COSTO, 
*!*	*** IN BASE ALL'IMPOSTAZIONE DEL PARAMETRO AZIENDALE "Gerarchia autorizzazioni RDA per CENTRI DI COSTO"
*!*	IF !PUB_RDACCO
*!*		x_cric = "CODRIC IN ('###'"
*!*		DO VEDO_UTENTI WITH ALLTRIM(PUB_CODOPE)
*!*		SELECT CVEDO_UTENTI
*!*		GO TOP
*!*		SCAN
*!*			x_cric = x_cric + ",'" + ALLTRIM(USERID) + "'"
*!*		ENDSCAN
*!*		x_cric = x_cric + ")"
*!*		x_cond = x_cond + " and " + x_cric
*!*	ELSE
*!*		_c_AUT_CCOSTO = ""
*!*		DO VEDO_UTENTI WITH ALLTRIM(PUB_CODOPE)
*!*		SELECT CVEDO_UTENTI
*!*		GO TOP
*!*		SCAN
*!*			IF !EMPTY(AUT_CCOSTO)
*!*				_c_AUT_CCOSTO = ALLTRIM(_c_AUT_CCOSTO) + IIF(EMPTY(_c_AUT_CCOSTO),"",",") + ALLTRIM(AUT_CCOSTO)
*!*			ENDIF
*!*		ENDSCAN
*!*		_COND_SELEZIONE = "'"+STRTRAN(_c_AUT_CCOSTO,",","','")+"'"
*!*		x_ccos = "(CCOSTOT IN (" + ALLTRIM(_COND_SELEZIONE) + ") OR CODRIC = '" + ALLTRIM(PUB_CODOPE) + "')"
*!*		x_cond = x_cond + " and " + x_ccos 
*!*	ENDIF
*!*	**=> ERASMO - FINE 09/12/2014

**=> ERASMO - INIZIO 07/01/2015
*** FILTRO LE RDA VISUALIZZABILI PER GERARCHIA DEL RICHIEDENTE O PER CENTRO DI COSTO, 
*** IN BASE ALL'IMPOSTAZIONE DEL PARAMETRO AZIENDALE "Gerarchia autorizzazioni RDA per CENTRI DI COSTO"
IF PUB_RDACCO
	_c_VIS_CCOSTO = ""
	_c_AUT_CCOSTO = ""
	DO VEDO_UTENTI WITH ALLTRIM(PUB_CODOPE)
	SELECT CVEDO_UTENTI
	GO TOP
	SCAN
		*IF !EMPTY(VIS_CCOSTO)
		IF !EMPTY(VIS_CCOSTO) AND !ISNULL(VIS_CCOSTO)  && ERASMO - 06/05/2023
			_c_VIS_CCOSTO = ALLTRIM(_c_VIS_CCOSTO) + IIF(EMPTY(_c_VIS_CCOSTO),"",",") + ALLTRIM(VIS_CCOSTO)
		ENDIF
		*IF !EMPTY(AUT_CCOSTO)
		IF !EMPTY(AUT_CCOSTO) AND !ISNULL(AUT_CCOSTO)  && ERASMO - 06/05/2023
			_c_AUT_CCOSTO = ALLTRIM(_c_AUT_CCOSTO) + IIF(EMPTY(_c_AUT_CCOSTO),"",",") + ALLTRIM(AUT_CCOSTO)
		ENDIF
	ENDSCAN
	_COND_SELEZIONE = "'"+STRTRAN(_c_VIS_CCOSTO,",","','")+"','"+STRTRAN(_c_AUT_CCOSTO,",","','")+"'"
	x_ccos = "(CCOSTOT IN (" + ALLTRIM(_COND_SELEZIONE) + ") OR CODRIC = '" + ALLTRIM(PUB_CODOPE) + "')"
	x_cond = x_cond + " and " + x_ccos 
ELSE	
	x_cric = "CODRIC IN ('###'"
	DO VEDO_UTENTI WITH ALLTRIM(PUB_CODOPE)
	SELECT CVEDO_UTENTI
	GO TOP
	SCAN
		x_cric = x_cric + ",'" + ALLTRIM(USERID) + "'"
	ENDSCAN
	x_cric = x_cric + ")"
	x_cond = x_cond + " and " + x_cric
ENDIF
**=> ERASMO - FINE 07/01/2015

x_sele = "SELECT CASE DATA WHEN '' THEN '' ELSE ISNULL(SUBSTRING(DATA,9,2)+'/'+SUBSTRING(DATA,6,2)+'/'+SUBSTRING(DATA,1,4),'') END AS R_DATA, " + ;
         "SUBSTRING(DESRIC,1,30) as SUBSTR_DESRIC, " + ;
         "CASE FLGORF WHEN 1 THEN '  SI  ' WHEN 0 THEN '      ' ELSE '      ' END AS D_FLGORF, " + ;
         "CASE FLGVIS1 WHEN 1 THEN '      SI      ' WHEN 0 THEN '              ' ELSE '              ' END AS D_FLGVIS1, " + ;
         "' '+ESIVIS1+' ' AS  STR_ESIVIS1, " + ;
         "SUBSTRING(MOTVIS1,1,30) as SUBSTR_MOTVIS1, " + ;
         "CASE FLGVIS2 WHEN 1 THEN '      SI      ' WHEN 0 THEN '              ' ELSE '              ' END AS D_FLGVIS2, " + ;
         "' '+ESIVIS2+' ' AS  STR_ESIVIS2, " + ;
         "SUBSTRING(MOTVIS2,1,30) as SUBSTR_MOTVIS2, " + ;
         "CASE FLGVIS3 WHEN 1 THEN '      SI      ' WHEN 0 THEN '              ' ELSE '              ' END AS D_FLGVIS3, " + ;
         "' '+ESIVIS3+' ' AS  STR_ESIVIS3, " + ;
         "SUBSTRING(MOTVIS3,1,30) as SUBSTR_MOTVIS3, " + ;
         "COALESCE(PARA_ARE.DESCRI,'') as DES_AREAMAG, " + ;
         "RDA_TT.* FROM RDA_TT LEFT OUTER JOIN PARA AS PARA_ARE ON PARA_ARE.CODICE = 'ARE'+RDA_TT.AREAMAG "

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER NUMERO
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
           x_nord = "NUMERO = '" + TRC(6,ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = x_sele + " WHERE " + x_cond + " order by NUMERO" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
           x_data = "DATA = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = x_sele + " WHERE " + x_cond + " order by DATA" 

   CASE V_SCELTA=3          				&& ACCESSO PER DESCRIZIONE RICHIEDENTE
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
           x_dric = "DESRIC like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dric
        ENDIF
        _ii_cSql = x_sele + " WHERE " + x_cond + " order by DESRIC" 

ENDCASE

RETURN
