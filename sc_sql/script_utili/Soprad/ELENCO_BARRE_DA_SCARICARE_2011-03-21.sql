
-- ELENCO BARRE PRESENTI IN MAGAZZINO MA CHE IN TEORIA DOVREBBERO ESSERE GIA' STATE SCARICATE 
-- CONSIDERANDO LE TABELLE DI PRODUZIONE

SELECT SUM(QTAMQ) AS QTAMQ_TOT FROM (
SELECT MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ FROM U_MAG_GG 
               LEFT OUTER JOIN u_prd_d4
                 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
               LEFT OUTER JOIN u_prd_d5
                 ON u_prd_d5.pj_prgprd1 = u_prd_d4.pj_prgprd1
                    AND u_prd_d5.pj_prgprd2 = u_prd_d4.pj_prgprd2
                    AND u_prd_d5.pj_prgprd3 = u_prd_d4.pj_prgprd3
                    AND u_prd_d5.pj_prgprd4 = u_prd_d4.pj_prgprd4
               LEFT OUTER JOIN u_prd_pk
                 ON u_prd_pk.pj_prgprd1 = u_prd_d4.pj_prgprd1
                    AND u_prd_pk.pj_prgprd2 = u_prd_d4.pj_prgprd2
                    AND u_prd_pk.pj_prgprd3 = u_prd_d4.pj_prgprd3
                    AND u_prd_pk.pj_prgprd4 = u_prd_d4.pj_prgprd4

WHERE SUBSTRING(MAG_DATAGG,1,4) < '2011'  
--AND MAG_GIACEN > 0 
--AND MAG_NRLINT > 0 
--AND MAG_LUNGHE > 0 
AND MAG_CODMAG = 'SPA'
AND (u_prd_d5.pr5_codint <> '' 
				or
			    u_prd_pk.pr5_codint <> '')
) AS FOTTUTISSIMO_STRONZO


SELECT SUM(QTAMQ) AS QTAMQ_TOT FROM (
	SELECT MAG_CODART,MAG_ALTEZZ,MAG_LUNGHE,MAG_ALTEZZ*MAG_LUNGHE/1000 AS QTAMQ FROM U_MAG_GG 
				   LEFT OUTER JOIN u_prd_dR
					 ON u_prd_dR.prR_codint = u_mag_gg.mag_codart
				   LEFT OUTER JOIN u_prd_d5
					 ON u_prd_d5.pj_prgprd1 = u_prd_dR.pj_prgprd1
						AND u_prd_d5.pj_prgprd2 = u_prd_dR.pj_prgprd2
						AND u_prd_d5.pj_prgprd3 = u_prd_dR.pj_prgprd3
						AND u_prd_d5.pj_prgprd4 = u_prd_dR.pj_prgprdR
				   LEFT OUTER JOIN u_prd_pk
					 ON u_prd_pk.pj_prgprd1 = u_prd_dR.pj_prgprd1
						AND u_prd_pk.pj_prgprd2 = u_prd_dR.pj_prgprd2
						AND u_prd_pk.pj_prgprd3 = u_prd_dR.pj_prgprd3
						AND u_prd_pk.pj_prgprd4 = u_prd_dR.pj_prgprdR
	WHERE SUBSTRING(MAG_DATAGG,1,4) < '2011' 
--AND MAG_GIACEN > 0 
--AND MAG_NRLINT > 0 
--AND MAG_LUNGHE > 0 
	AND MAG_CODMAG = 'SPA'
	AND (u_prd_d5.pr5_codint <> '' 
					or
					u_prd_pk.pr5_codint <> '')
) AS FOTTUTISSIMO_STRONZO2

/*


SELECT mag_codmag                    AS magazzino,
       mag_codart                    AS cod_interno_barra,
       mag_altezz                    AS h,
       mag_lunghe                    AS l,
       mag_qtamq                     AS qta_mq,
	   Substring(mag_datagg,1,4),
       Substring(pj_prgprd1, 12, 10) AS nr_programma,
       Substring(pj_prgprd2, 8, 3)   AS sequenza_prod,
       Substring(pj_prgprd2, 12, 5)  AS fascia,
       pr4_progre                    AS progressivo_barra
FROM   (SELECT DISTINCT u_mag_gg.mag_codmag,
                        u_mag_gg.mag_codart,
                        u_mag_gg.mag_altezz,
                        u_mag_gg.mag_lunghe,
						u_mag_gg.mag_datagg,
						u_mag_gg.mag_qtamq,
                        u_prd_d4.pj_prgprd1,
                        u_prd_d4.pj_prgprd2,
                        u_prd_d4.pr4_progre
        FROM   u_mag_gg
               LEFT OUTER JOIN u_prd_d4
                 ON u_prd_d4.pr4_codint = u_mag_gg.mag_codart
               LEFT OUTER JOIN u_prd_d5
                 ON u_prd_d5.pj_prgprd1 = u_prd_d4.pj_prgprd1
                    AND u_prd_d5.pj_prgprd2 = u_prd_d4.pj_prgprd2
                    AND u_prd_d5.pj_prgprd3 = u_prd_d4.pj_prgprd3
                    AND u_prd_d5.pj_prgprd4 = u_prd_d4.pj_prgprd4
               LEFT OUTER JOIN u_prd_pk
                 ON u_prd_pk.pj_prgprd1 = u_prd_d4.pj_prgprd1
                    AND u_prd_pk.pj_prgprd2 = u_prd_d4.pj_prgprd2
                    AND u_prd_pk.pj_prgprd3 = u_prd_d4.pj_prgprd3
                    AND u_prd_pk.pj_prgprd4 = u_prd_d4.pj_prgprd4

        WHERE  (u_prd_d5.pr5_codint <> '' 
				or
			    u_prd_pk.pr5_codint <> '')
				and ((Substring(u_mag_gg.mag_datagg,1,4) = '2010') or (Substring(u_mag_gg.mag_datagg,1,4) = '2009'))
		) AS query_source
ORDER  BY nr_programma,
          sequenza_prod,
          fascia,
          cod_interno_barra 

*/