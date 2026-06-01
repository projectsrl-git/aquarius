select * from indice where mov_anno = '2012'
SELECT * FROM MOV_CONT where mov_anno = '2012'

SELECT * FROM CONTI WHERE CON_ANNO = '2012'  ORDER BY CON_CONTO
select MOV_NPROT,MOV_NDOC,* from mov_cont where mov_anno = '2012' and mov_note like 'ELABORATO0000027726%' 
SELECT * FROM mov_cont WHERE mov_soc = '01' and mov_anno = '2012' and mov_dtreg >= '2012/01/01' and mov_dtreg <= '2012/01/31' order by mov_soc,mov_anno,mov_dtreg,mov_numpro,mov_sequen


SELECT IVA_FATNOT,* FROM U_IVA_CL WHERE IVA_ANNO = '2012' AND IVA_MESE = '01' ORDER BY IVA_NUMFAT

SELECT * FROM U_IVF_CL WHERE IVF_ANNO = '2012' AND IVF_MESE = '01' ORDER BY IVF_NUMFAT





