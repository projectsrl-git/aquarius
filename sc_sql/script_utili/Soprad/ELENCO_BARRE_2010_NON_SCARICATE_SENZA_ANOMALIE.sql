
-- ELENCO BARRE PRESENTI IN MAGAZZINO CON CORRISPONDENZA IN PRODUZIONE ANCORA NON TAGLIATE

SELECT	MAG_CODMAG AS COD_MAGAZZINO,
		MAG_DATAGG AS DATA_CARICO,
		MAG_CODART AS COD_PRODOTTO,
		MAG_ALTEZZ AS ALTEZZA,
		MAG_LUNGHE AS LUNGHEZZA,
		MAG_GIACEN AS GIACENZA,
		NR_PROGRAMMA,
		NR_FASCIA,
		NR_BOBINA,
		NR_BARRA
FROM (

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	,SUBSTRING(u_prd_d4.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_d4.pj_prgprd2 AS NR_FASCIA
	,u_prd_d4.pj_prgprd3 AS NR_BOBINA, u_prd_d4.pj_prgprd4 AS NR_BARRA
	--,u_prd_d4.pj_prgprd1,u_prd_d4.pj_prgprd2,u_prd_d4.pj_prgprd3,u_prd_d4.pj_prgprd4
	--,D5.pj_prgprd1,D5.pj_prgprd2,D5.pj_prgprd3,D5.pj_prgprd4
	FROM U_MAG_GG 
				   INNER JOIN u_prd_d4
					 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
								where pr5_codint = '') as d5
					 ON d5.pj_prgprd1 = u_prd_d4.pj_prgprd1
						AND d5.pj_prgprd2 = u_prd_d4.pj_prgprd2
						AND d5.pj_prgprd3 = u_prd_d4.pj_prgprd3
						AND d5.pj_prgprd4 = u_prd_d4.pj_prgprd4
	WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
	AND U_MAG_GG.MAG_CODMAG = 'SPA'

	union

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	,SUBSTRING(u_prd_d4.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_d4.pj_prgprd2 AS NR_FASCIA
	,u_prd_d4.pj_prgprd3 AS NR_BOBINA, u_prd_d4.pj_prgprd4 AS NR_BARRA
	--,u_prd_d4.pj_prgprd1,u_prd_d4.pj_prgprd2,u_prd_d4.pj_prgprd3,u_prd_d4.pj_prgprd4
	--,PK.pj_prgprd1,PK.pj_prgprd2,PK.pj_prgprd3,PK.pj_prgprd4
	FROM U_MAG_GG 
				   INNER JOIN u_prd_d4
					 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
								where pr5_codint = '') as pk
					 ON pk.pj_prgprd1 = u_prd_d4.pj_prgprd1
						AND pk.pj_prgprd2 = u_prd_d4.pj_prgprd2
						AND pk.pj_prgprd3 = u_prd_d4.pj_prgprd3
						AND pk.pj_prgprd4 = u_prd_d4.pj_prgprd4

	WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
	AND U_MAG_GG.MAG_CODMAG = 'SPA'

	union

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	,SUBSTRING(u_prd_dR.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_dR.pj_prgprd2 AS NR_FASCIA
	,u_prd_dR.pj_prgprd3 AS NR_BOBINA, u_prd_dR.pj_prgprd4 AS NR_BARRA
	--,u_prd_dR.pj_prgprd1,u_prd_dR.pj_prgprd2,u_prd_dR.pj_prgprd3,u_prd_dR.pj_prgprd4
	--,D5.pj_prgprd1,D5.pj_prgprd2,D5.pj_prgprd3,D5.pj_prgprd4
	FROM U_MAG_GG 
				   INNER JOIN u_prd_dR
					 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
								where pr5_codint = '') as d5
					 ON d5.pj_prgprd1 = u_prd_dR.pj_prgprd1
						AND d5.pj_prgprd2 = u_prd_dR.pj_prgprd2
						AND d5.pj_prgprd3 = u_prd_dR.pj_prgprd3
						AND d5.pj_prgprd4 = u_prd_dR.pj_prgprdR
	WHERE MAG_DATAGG <= '2010/12/31'
	AND MAG_CODMAG = 'SPA'

	union

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	,SUBSTRING(u_prd_dR.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_dR.pj_prgprd2 AS NR_FASCIA
	,u_prd_dR.pj_prgprd3 AS NR_BOBINA, u_prd_dR.pj_prgprd4 AS NR_BARRA
	--,u_prd_dR.pj_prgprd1,u_prd_dR.pj_prgprd2,u_prd_dR.pj_prgprd3,u_prd_dR.pj_prgprd4
	--,PK.pj_prgprd1,PK.pj_prgprd2,PK.pj_prgprd3,PK.pj_prgprd4
	FROM U_MAG_GG 
				   INNER JOIN u_prd_dR
					 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
								where pr5_codint = '') as pk
					 ON pk.pj_prgprd1 = u_prd_dR.pj_prgprd1
						AND pk.pj_prgprd2 = u_prd_dR.pj_prgprd2
						AND pk.pj_prgprd3 = u_prd_dR.pj_prgprd3
						AND pk.pj_prgprd4 = u_prd_dR.pj_prgprdR
	WHERE MAG_DATAGG <= '2010/12/31'
	AND MAG_CODMAG = 'SPA'

) AS ELENCO_BARRE 

WHERE MAG_CODART NOT IN (

	SELECT	MAG_CODART
	FROM (

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		,SUBSTRING(u_prd_d4.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_d4.pj_prgprd2 AS NR_FASCIA
		,u_prd_d4.pj_prgprd3 AS NR_BOBINA, u_prd_d4.pj_prgprd4 AS NR_BARRA
		--,u_prd_d4.pj_prgprd1,u_prd_d4.pj_prgprd2,u_prd_d4.pj_prgprd3,u_prd_d4.pj_prgprd4
		--,D5.pj_prgprd1,D5.pj_prgprd2,D5.pj_prgprd3,D5.pj_prgprd4
		FROM U_MAG_GG 
					   INNER JOIN u_prd_d4
						 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
									where pr5_codint <> '') as d5
						 ON d5.pj_prgprd1 = u_prd_d4.pj_prgprd1
							AND d5.pj_prgprd2 = u_prd_d4.pj_prgprd2
							AND d5.pj_prgprd3 = u_prd_d4.pj_prgprd3
							AND d5.pj_prgprd4 = u_prd_d4.pj_prgprd4
		WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
		AND U_MAG_GG.MAG_CODMAG = 'SPA'

		union

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		,SUBSTRING(u_prd_d4.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_d4.pj_prgprd2 AS NR_FASCIA
		,u_prd_d4.pj_prgprd3 AS NR_BOBINA, u_prd_d4.pj_prgprd4 AS NR_BARRA
		--,u_prd_d4.pj_prgprd1,u_prd_d4.pj_prgprd2,u_prd_d4.pj_prgprd3,u_prd_d4.pj_prgprd4
		--,PK.pj_prgprd1,PK.pj_prgprd2,PK.pj_prgprd3,PK.pj_prgprd4
		FROM U_MAG_GG 
					   INNER JOIN u_prd_d4
						 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
									where pr5_codint <> '') as pk
						 ON pk.pj_prgprd1 = u_prd_d4.pj_prgprd1
							AND pk.pj_prgprd2 = u_prd_d4.pj_prgprd2
							AND pk.pj_prgprd3 = u_prd_d4.pj_prgprd3
							AND pk.pj_prgprd4 = u_prd_d4.pj_prgprd4

		WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
		AND U_MAG_GG.MAG_CODMAG = 'SPA'

		union

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		,SUBSTRING(u_prd_dR.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_dR.pj_prgprd2 AS NR_FASCIA
		,u_prd_dR.pj_prgprd3 AS NR_BOBINA, u_prd_dR.pj_prgprd4 AS NR_BARRA
		--,u_prd_dR.pj_prgprd1,u_prd_dR.pj_prgprd2,u_prd_dR.pj_prgprd3,u_prd_dR.pj_prgprd4
		--,D5.pj_prgprd1,D5.pj_prgprd2,D5.pj_prgprd3,D5.pj_prgprd4
		FROM U_MAG_GG 
					   INNER JOIN u_prd_dR
						 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
									where pr5_codint <> '') as d5
						 ON d5.pj_prgprd1 = u_prd_dR.pj_prgprd1
							AND d5.pj_prgprd2 = u_prd_dR.pj_prgprd2
							AND d5.pj_prgprd3 = u_prd_dR.pj_prgprd3
							AND d5.pj_prgprd4 = u_prd_dR.pj_prgprdR
		WHERE MAG_DATAGG <= '2010/12/31'
		AND MAG_CODMAG = 'SPA'

		union

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		,SUBSTRING(u_prd_dR.pj_prgprd1,1,21) AS NR_PROGRAMMA, u_prd_dR.pj_prgprd2 AS NR_FASCIA
		,u_prd_dR.pj_prgprd3 AS NR_BOBINA, u_prd_dR.pj_prgprd4 AS NR_BARRA
		--,u_prd_dR.pj_prgprd1,u_prd_dR.pj_prgprd2,u_prd_dR.pj_prgprd3,u_prd_dR.pj_prgprd4
		--,PK.pj_prgprd1,PK.pj_prgprd2,PK.pj_prgprd3,PK.pj_prgprd4
		FROM U_MAG_GG 
					   INNER JOIN u_prd_dR
						 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
									where pr5_codint <> '') as pk
						 ON pk.pj_prgprd1 = u_prd_dR.pj_prgprd1
							AND pk.pj_prgprd2 = u_prd_dR.pj_prgprd2
							AND pk.pj_prgprd3 = u_prd_dR.pj_prgprd3
							AND pk.pj_prgprd4 = u_prd_dR.pj_prgprdR
		WHERE MAG_DATAGG <= '2010/12/31'
		AND MAG_CODMAG = 'SPA'

	) as tmp_barre
)

ORDER BY MAG_CODMAG,MAG_DATAGG,MAG_CODART





-- QTA TOTALE BARRE PRESENTI IN MAGAZZINO CON CORRISPONDENZA IN PRODUZIONE ANCORA NON TAGLIATE

SELECT SUM(QTAMQ) AS QTAMQ_TOT FROM (

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	FROM U_MAG_GG 
				   INNER JOIN u_prd_d4
					 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
								where pr5_codint = '') as d5
					 ON d5.pj_prgprd1 = u_prd_d4.pj_prgprd1
						AND d5.pj_prgprd2 = u_prd_d4.pj_prgprd2
						AND d5.pj_prgprd3 = u_prd_d4.pj_prgprd3
						AND d5.pj_prgprd4 = u_prd_d4.pj_prgprd4
	WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
	AND U_MAG_GG.MAG_CODMAG = 'SPA'

	union

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	FROM U_MAG_GG 
				   INNER JOIN u_prd_d4
					 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
								where pr5_codint = '') as pk
					 ON pk.pj_prgprd1 = u_prd_d4.pj_prgprd1
						AND pk.pj_prgprd2 = u_prd_d4.pj_prgprd2
						AND pk.pj_prgprd3 = u_prd_d4.pj_prgprd3
						AND pk.pj_prgprd4 = u_prd_d4.pj_prgprd4

	WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
	AND U_MAG_GG.MAG_CODMAG = 'SPA'

	union

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	FROM U_MAG_GG 
				   INNER JOIN u_prd_dR
					 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
								where pr5_codint = '') as d5
					 ON d5.pj_prgprd1 = u_prd_dR.pj_prgprd1
						AND d5.pj_prgprd2 = u_prd_dR.pj_prgprd2
						AND d5.pj_prgprd3 = u_prd_dR.pj_prgprd3
						AND d5.pj_prgprd4 = u_prd_dR.pj_prgprdR
	WHERE MAG_DATAGG <= '2010/12/31'
	AND MAG_CODMAG = 'SPA'

	union

	SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
	FROM U_MAG_GG 
				   INNER JOIN u_prd_dR
					 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
				   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
								where pr5_codint = '') as pk
					 ON pk.pj_prgprd1 = u_prd_dR.pj_prgprd1
						AND pk.pj_prgprd2 = u_prd_dR.pj_prgprd2
						AND pk.pj_prgprd3 = u_prd_dR.pj_prgprd3
						AND pk.pj_prgprd4 = u_prd_dR.pj_prgprdR
	WHERE MAG_DATAGG <= '2010/12/31'
	AND MAG_CODMAG = 'SPA'

) AS ELENCO_BARRE 

WHERE MAG_CODART NOT IN (

	SELECT	MAG_CODART
	FROM (

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		FROM U_MAG_GG 
					   INNER JOIN u_prd_d4
						 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
									where pr5_codint <> '') as d5
						 ON d5.pj_prgprd1 = u_prd_d4.pj_prgprd1
							AND d5.pj_prgprd2 = u_prd_d4.pj_prgprd2
							AND d5.pj_prgprd3 = u_prd_d4.pj_prgprd3
							AND d5.pj_prgprd4 = u_prd_d4.pj_prgprd4
		WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
		AND U_MAG_GG.MAG_CODMAG = 'SPA'

		union

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		FROM U_MAG_GG 
					   INNER JOIN u_prd_d4
						 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
									where pr5_codint <> '') as pk
						 ON pk.pj_prgprd1 = u_prd_d4.pj_prgprd1
							AND pk.pj_prgprd2 = u_prd_d4.pj_prgprd2
							AND pk.pj_prgprd3 = u_prd_d4.pj_prgprd3
							AND pk.pj_prgprd4 = u_prd_d4.pj_prgprd4

		WHERE U_MAG_GG.MAG_DATAGG <= '2010/12/31'
		AND U_MAG_GG.MAG_CODMAG = 'SPA'

		union

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		FROM U_MAG_GG 
					   INNER JOIN u_prd_dR
						 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_d5 
									where pr5_codint <> '') as d5
						 ON d5.pj_prgprd1 = u_prd_dR.pj_prgprd1
							AND d5.pj_prgprd2 = u_prd_dR.pj_prgprd2
							AND d5.pj_prgprd3 = u_prd_dR.pj_prgprd3
							AND d5.pj_prgprd4 = u_prd_dR.pj_prgprdR
		WHERE MAG_DATAGG <= '2010/12/31'
		AND MAG_CODMAG = 'SPA'

		union

		SELECT MAG_CODMAG,MAG_DATAGG,MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ,MAG_GIACEN
		FROM U_MAG_GG 
					   INNER JOIN u_prd_dR
						 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
					   INNER JOIN (select distinct pj_prgprd1,pj_prgprd2,pj_prgprd3,pj_prgprd4 from u_prd_pk 
									where pr5_codint <> '') as pk
						 ON pk.pj_prgprd1 = u_prd_dR.pj_prgprd1
							AND pk.pj_prgprd2 = u_prd_dR.pj_prgprd2
							AND pk.pj_prgprd3 = u_prd_dR.pj_prgprd3
							AND pk.pj_prgprd4 = u_prd_dR.pj_prgprdR
		WHERE MAG_DATAGG <= '2010/12/31'
		AND MAG_CODMAG = 'SPA'

	) as tmp_barre
)