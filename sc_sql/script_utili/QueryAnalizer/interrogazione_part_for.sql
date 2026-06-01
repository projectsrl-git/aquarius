
SELECT * FROM PARA WHERE SUBSTRING(CODICE,1,3) = 'TOP' and DESCRI LIKE '%PAG.ricevuta banc%'
SELECT * FROM PARA WHERE SUBSTRING(CODICE,1,3) = 'TOP' and DESCRI LIKE '%PAG.ricevuta bancaria%'  

SELECT * FROM PARA WHERE SUBSTRING(CODICE,1,3) = 'TOP' and DESCRI = 'Fattura'

select * from part_for where par_anno = '2011' order by par_numpro,par_nprog

select par_npart,par_numfat,par_tmov,par_tipfat,par_fatt,* from part_for  order by par_numpro,par_nprog

SELECT MOV_NUMPRO,MOV_SEQUEN,MOV_CONTO,MOV_DTDOC,MOV_NDOC,MOV_IMP,* FROM MOV_CONT WHERE MOV_CONTO = '1010200000001'  AND MOV_DTDOC = '2011/04/04' AND MOV_NDOC = '1003'     ORDER BY MOV_NUMPRO

select * from u_cli_an where cli_codsoc = '01' and cli_codcli = '00000001' order by cli_codsoc,cli_codcli

SELECT 
      SUM(MOV_IMP) AS DARE
FROM MOV_CONT
WHERE MOV_TMOV='D' 


SELECT 
      SUM(MOV_IMP) AS AVERE
FROM MOV_CONT
WHERE MOV_TMOV='A' 

SELECT 
      SUM(MOV_IMP) AS AVERE
FROM MOV_CONT
WHERE MOV_TMOV=' ' 

SELECT * FROM MOV_CONT WHERE MOV_CONTO = '' ORDER BY MOV_NUMPRO