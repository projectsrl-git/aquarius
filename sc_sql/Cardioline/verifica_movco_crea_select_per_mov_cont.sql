
SELECT 
      SUM(MOV_IMP*MOV_CAMBIO) AS DARE
FROM MOV_CONT
WHERE MOV_TMOV='D' 


SELECT 
      SUM(MOV_IMP*MOV_CAMBIO) AS AVERE
FROM MOV_CONT
WHERE MOV_TMOV='A' 

SELECT * FROM MOV_CONT


SELECT 
      SUM(eimporto) AS DARE
FROM CARD_MOVCO
WHERE segno='D' and substring(DATAREG,1,6)='201301' 
--and SOLOANA_SN <> 'S'
and SOSPESO_SN <> 'S'
and SIMULAZ_SN <> 'S'
and TEMPORA_SN <> 'S'
--and SCADENZ_SN <> 'S'



SELECT 
      SUM(eimporto) AS AVERE
FROM CARD_MOVCO
WHERE segno='A' and substring(DATAREG,1,6)='201301' and SOLOANA_SN = 'N'
--and SOLOANA_SN <> 'S'
and SOSPESO_SN <> 'S'
and SIMULAZ_SN <> 'S'
and TEMPORA_SN <> 'S'
--and SCADENZ_SN <> 'S'




SELECT NUMERO, SUM(DARE) AS DARE,  SUM(AVERE) AS AVERE,  SUM(DARE-AVERE) AS SALDO FROM (
SELECT *, DARE -AVERE AS SALDO FROM (
SELECT 
     NUMERO,
	 case when segno='D' then eimporto else 0 end as dare,
	 case when segno='A' then eimporto else 0 end as avere
FROM CARD_MOVCO
WHERE substring(DATAREG,1,6)='201301' 
and SOSPESO_SN <> 'S'
and SIMULAZ_SN <> 'S'
and TEMPORA_SN <> 'S') AS T1 ) AS T2 GROUP BY NUMERO
ORDER BY NUMERO


SELECT SUM(DARE) AS DARE,  SUM(AVERE) AS AVERE FROM (
SELECT *, DARE -AVERE AS SALDO FROM (
SELECT 
     NUMERO,
	 case when segno='D' then eimporto else 0 end as dare,
	 case when segno='A' then eimporto else 0 end as avere
FROM CARD_MOVCO
WHERE substring(DATAREG,1,6)='201301' 
and SOSPESO_SN <> 'S'
and SIMULAZ_SN <> 'S'
and TEMPORA_SN <> 'S') AS T1 ) AS T2 

