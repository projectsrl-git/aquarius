--select ord_valore,* from u_fat_tt where ord_numord = 758
--select ord_valore,* from u_fat_DD where DAGGANCIO = '6000002651'

--select distinct ord_iva from u_fat_dd
/*
select codice,SUBSTRING(LIBERA,1,3) from para
where codice in ('IVANI8',
'IVA41A',
'IVA20 ',
'IVA20C',
'IVA03 ',
'IVA10 ',
'IVA41 ',
'IVAI8C',
'IVANI4',
'IVA8RS')
*/

--select ord_numord,* from u_fat_tt order by ord_numord


SELECT * FROM (
SELECT 
	TT.ORD_NUMORD,
	TT.ORD_DATORD,
	TT.ORD_VALORE AS TESTA,
	TT.ORD_SPTRAS AS SPESE,
	SUM(DD.ORD_VALORE) AS SOMMAD,
	dd.ord_iva,
	SUBSTRING(PAR.LIBERA,1,3) AS ALIQ
FROM
	U_FAT_dd AS dd
	LEFT OUTER JOIN U_FAT_tt AS tt
		ON dd.dAGGANCIO = tt.tAGGANCIO 
	LEFT OUTER JOIN PARA AS PAR
		ON PAR.CODICE LIKE 'IVA' +  dd.ord_iva 

GROUP BY
	TT.ORD_NUMORD,
	TT.ORD_DATORD,
	TT.ORD_VALORE,
	TT.ORD_SPTRAS,
	dd.ord_iva,
	SUBSTRING(PAR.LIBERA,1,3)
--ORDER BY TT.ORD_NUMORD
) AS T1
WHERE TESTA != SOMMAD
and SOMMAD != 0
AND ORD_IVA = '20'



ORDER BY ORD_NUMORD



--SELECT SUBSTRING(CODICE,4,3) AS COD,SUBSTRING(LIBERA,1,3) AS ALIQ FROM PARA WHERE CODICE LIKE 'IVA%'


