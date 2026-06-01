SELECT u_art_pr.art_codpri,
       u_art_pr.art_descr,
       u_art_pr.art_spesso,
       u_art_pr.art_altezz,
       u_art_pr.art_lunghe,
       u_art_pr.art_ummaga
FROM   u_art_pr
       LEFT OUTER JOIN u_art_an
                    ON u_art_an.art_codsoc = u_art_pr.art_codsoc
                       AND u_art_an.art_codpri = u_art_pr.art_codpri
WHERE  u_art_pr.art_gruprd = 'XIL400-25       '
       AND ( u_art_pr.art_altezz = 0
              OR '3760 + 3760' LIKE
           '%' + Ltrim(Str(u_art_pr.art_altezz)) + '%' )
       AND ( u_art_pr.art_lunghe = 2070
              OR '2070' LIKE '%' + Ltrim(Str(u_art_pr.art_lunghe)) + '%'
              OR '' LIKE '%' + Ltrim(Str(u_art_pr.art_lunghe)) + '%' )
       AND ( u_art_an.art_tipog <> ''
             AND u_art_an.art_tipon = '' )
       AND u_art_an.art_scelta = '1'
ORDER  BY u_art_pr.art_codpri 


SELECT u_art_pr.art_codpri,
		u_art_an.art_tipon,
       u_art_pr.art_descr,
       u_art_pr.art_spesso,
       u_art_pr.art_altezz,
       u_art_pr.art_lunghe,
       u_art_pr.art_ummaga
FROM   u_art_pr
       LEFT OUTER JOIN u_art_an
                    ON u_art_an.art_codsoc = u_art_pr.art_codsoc
                       AND u_art_an.art_codpri = u_art_pr.art_codpri
WHERE u_art_pr.art_gruprd = 'XIL400-25       ' AND u_art_pr.art_altezz = 3760 AND u_art_pr.art_lunghe = 2070 
       AND ( u_art_an.art_tipog <> ''
             AND u_art_an.art_tipon = '' )


SELECT u_art_pr.art_DATINS,
		u_art_pr.art_codpri,
		u_art_an.art_scelta,
		SUBSTRING( u_art_pr.art_codpri,15,1) ,
		u_art_an.art_tipon,
       u_art_pr.art_descr,
       u_art_pr.art_spesso,
       u_art_pr.art_altezz,
       u_art_pr.art_lunghe,
       u_art_pr.art_ummaga
FROM   u_art_an
       LEFT OUTER JOIN u_art_pr
                    ON u_art_an.art_codsoc = u_art_pr.art_codsoc
                       AND u_art_an.art_codpri = u_art_pr.art_codpri
WHERE u_art_pr.ART_CODMAT='008' AND SUBSTRING( u_art_pr.art_codpri,15,1) IN ('1','2') AND u_art_an.art_scelta = ''
AND ( u_art_an.art_tipog <> '' OR u_art_an.art_tipon <> '' )

/*   QUESTA E' LA UPDATE DA LANCIARE

UPDATE U_ART_AN SET ART_SCELTA = SUBSTRING( art_codpri,15,1) 
WHERE ART_CODPRI IN (
	SELECT u_art_pr.art_codpri 
	FROM   u_art_an
		   LEFT OUTER JOIN u_art_pr
						ON u_art_an.art_codsoc = u_art_pr.art_codsoc
						   AND u_art_an.art_codpri = u_art_pr.art_codpri
	WHERE u_art_pr.ART_CODMAT='008' AND SUBSTRING( u_art_pr.art_codpri,15,1) IN ('1','2') AND u_art_an.art_scelta = ''
	AND ( u_art_an.art_tipog <> '' OR u_art_an.art_tipon <> '' )
)
*/




