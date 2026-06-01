

SELECT mov_cont.*, conti.con_descr, conti.con_tipoco, COALESCE(para.libera,'') AS libera FROM mov_cont 
LEFT OUTER JOIN 
conti on conti.con_soc = 01 and conti.con_anno = mov_cont.mov_anno and 
conti.con_conto = mov_cont.mov_conto 
LEFT OUTER JOIN para on para.codice = 'TOP'+mov_cont.mov_top 
WHERE mov_soc = '01' and mov_anno = mov_anno and 
mov_dtdoc between '2023/06/01' and '2023/06/30' and 
con_tipoco in ('F') and 
SUBSTRING(libera,2,1) = 'S'
order by mov_soc,mov_anno,mov_dtdoc,mov_numpro




SELECT MOV_SEQUEN AS SEQUEN,MOV_CONTO,MOV_IVA,MOV_IMP,MOV_IMPOST,MOV_IMPVAL,* FROM MOV_CONT WHERE MOV_NUMPRO = '_6NI0ZGG0F' ORDER BY MOV_SEQUEN