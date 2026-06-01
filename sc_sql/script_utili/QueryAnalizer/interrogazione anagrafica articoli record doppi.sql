SELECT * FROM U_ART_PR WHERE ART_CODPRI = 'AM 58'
         
SELECT           COUNT(*)         AS QTA, 

                        ART_CODPRI   AS CODICE

            FROM U_ART_PR

            GROUP BY ART_CODPRI

            ORDER BY QTA

 
