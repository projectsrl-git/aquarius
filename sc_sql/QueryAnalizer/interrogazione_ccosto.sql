SELECT MOV_CCO,MOV_CONTO,MOV_IMP,MOV_TMOV,MOV_NREGIS,MOV_DTREG FROM MOV_CONT WHERE MOV_CCO = '00600' ORDER BY MOV_NREGIS,MOV_SEQUEN 
SELECT MOV_CCO,MOV_CONTO,MOV_IMP,MOV_TMOV,MOV_NREGIS,MOV_DTREG FROM MOV_CCO WHERE MOV_CCO = '00600' ORDER BY MOV_NREGIS

SELECT * FROM CCOSTO WHERE CON_CONTO = '00600'

SELECT CON_CCO,* FROM CONTI WHERE CON_CCO <> ''




--conto 00100
SELECT 
	sum(case when MOV_TMOV='D' then MOV_IMP else 0 end) as DARE,
	sum(case when MOV_TMOV='A' then MOV_IMP else 0 end) as AVERE,
	sum(case when MOV_TMOV='D' then MOV_IMP else -1*MOV_IMP end) as SALDO
FROM MOV_CONT
WHERE MOV_CONTO = '6010101' and mov_anno = '2013' and mov_cco = '00100'



--conto
SELECT 
	sum(case when MOV_TMOV='D' then MOV_IMP else 0 end) as DARE,
	sum(case when MOV_TMOV='A' then MOV_IMP else 0 end) as AVERE,
	sum(case when MOV_TMOV='D' then MOV_IMP else -1*MOV_IMP end) as SALDO
FROM MOV_CCO
WHERE MOV_COPRIM = '6010101' and mov_anno = '2013' and mov_cco = '00100'

