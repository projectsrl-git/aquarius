--CLIENTI
SELECT 
	sum(case when MOV_TMOV='D' then MOV_IMP else 0 end) as DARE,
	sum(case when MOV_TMOV='A' then MOV_IMP else 0 end) as AVERE,
	sum(case when MOV_TMOV='D' then MOV_IMP else -1*MOV_IMP end) as SALDO
FROM MOV_CONT
WHERE MOV_CONTO = '1010200001768' and mov_anno = '2012' 



SELECT 
	sum(case when PAR_TMOV='D' then PAR_FATT else 0 end) as DARE,
	sum(case when PAR_TMOV='A' then PAR_FATT else 0 end) as AVERE,
	sum(case when PAR_TMOV='D' then PAR_FATT else -1*PAR_FATT end) as SALDO
FROM PART_CLI
WHERE PAR_NPROG <> '100' AND PAR_CODCLI='1010200001768'


--FORNITORI
SELECT 
	sum(case when MOV_TMOV='D' then MOV_IMP else 0 end) as DARE,
	sum(case when MOV_TMOV='A' then MOV_IMP else 0 end) as AVERE,
	sum(case when MOV_TMOV='D' then MOV_IMP else -1*MOV_IMP end) as SALDO
FROM MOV_CONT
WHERE MOV_CONTO = '2110200003339' and mov_anno = '2012' 

  

SELECT 
	sum(case when PAR_TMOV='D' then PAR_FATT else 0 end) as DARE,
	sum(case when PAR_TMOV='A' then PAR_FATT else 0 end) as AVERE,
	sum(case when PAR_TMOV='D' then PAR_FATT else -1*PAR_FATT end) as SALDO
FROM PART_FOR
WHERE PAR_NPROG <> '100' AND PAR_CODCLI='2110100003339'




SELECT 
      SUM(MOV_IMP) AS AVERE
FROM MOV_CONT
WHERE MOV_TMOV='A' 


SELECT 
      SUM(MOV_IMP) AS AVERE
FROM MOV_CONT
WHERE MOV_TMOV=' ' 

SELECT * FROM MOV_CONT WHERE MOV_CONTO = '1010200001768' ORDER BY MOV_NUMPRO