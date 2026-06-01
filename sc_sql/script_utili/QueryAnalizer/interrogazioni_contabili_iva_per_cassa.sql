SELECT MOV_NUMPRO,* FROM MOV_CONT WHERE MOV_ANNO = '2013' AND MOV_CONTO = '2010000000502'

SELECT MOV_NUMPRO,MOV_DTDOC,MOV_NDOC,MOV_NPROT,MOV_DTORI,MOV_NDORI,MOV_IMP,* FROM MOV_CONT WHERE MOV_NUMPRO = '_3ON0ZTYDT' AND MOV_CONTO= '2010000000502'

SELECT PAR_NUMPRO,PAR_DTFAT,PAR_NUMFAT,PAR_CODCLI,PAR_FATT,* FROM PART_FOR WHERE PAR_NUMPRO = '_3ON0ZTYDT' AND PAR_CODCLI= '2010000000502' AND PAR_FATT = 840.000  

SELECT PAR_NUMPRO,PAR_DTFAT,PAR_NUMFAT,PAR_CODCLI,PAR_FATT,* FROM PART_FOR WHERE PAR_NUMPRO = '_3ON0YZKT9' AND PAR_CODCLI= '2010000000502' AND  PAR_NPROG = 100

-- ACCESSO A FATTURA ORIGINALE
SELECT PAR_NUMPRO,PAR_DTFAT,PAR_NUMFAT,PAR_CODCLI,PAR_FATT,* FROM PART_FOR WHERE PAR_NUMPRO = '_3OR0Q33VL' AND PAR_CODCLI= '2010000000502' 
SELECT PAR_NUMPRO,PAR_DTFAT,PAR_NUMFAT,PAR_CODCLI,PAR_FATT,* FROM PART_FOR WHERE PAR_NPART = '30020' AND PAR_CODCLI= '2010000000502'  AND PAR_NPROG = 100

SELECT distinct PAR_npart FROM PART_FOR WHERE PAR_NUMPRO = '_3OR0Q33VL' AND PAR_CODCLI= '2010000000502' 



SELECT ivf_codcli,ivf_dtcrea,ivf_dtfatt,ivf_numfat,ivf_codiva,ivf_aliquo,ivf_desiva,ivf_imponi,ivf_impost,ivf_totale,pin_percen,pin_imponi,pin_impost,pin_totale,* FROM C_IVF_CL
   
SELECT ivf_codcli,ivf_dtcrea,ivf_dtfatt,ivf_numfat,ivf_codiva,ivf_aliquo,ivf_desiva,ivf_imponi,ivf_impost,ivf_totale,pin_percen,pin_imponi,pin_impost,pin_totale,* FROM C_IVF_CL where ivf_codcli = '000000502' and ivf_numfat = '11' and ivf_dtfatt= '2013/01/04'
SELECT PAR_NUMPRO,PAR_DTFAT,PAR_NUMFAT,PAR_CODCLI,PAR_FATT,* FROM PART_FOR WHERE  par_codcli = '2010000000502' and par_numfat = '11' and par_dtfat= '2013/01/04' AND  PAR_NPROG = 100
select * from c_ivf_cl where ivf_codcli = '000000502' and ivf_dtfatt = '2013/01/04' and ivf_numfat = '11' order by ivf_codcli ,ivf_dtfatt,ivf_numfat

SELECT ivf_dtcrea,ivf_dtfatt,ivf_numfat,ivf_codiva,ivf_aliquo,ivf_desiva,ivf_imponi,ivf_impost,ivf_totale,* FROM U_IVF_CL WHERE IVF_ANNO = '2013' ORDER BY IVF_DTFATT,IVF_NUMFAT
SELECT ivf_dtcrea,ivf_dtfatt,ivf_numfat,ivf_codiva,ivf_aliquo,ivf_desiva,ivf_imponi,ivf_impost,ivf_totale,pin_percen,pin_imponi,pin_impost,pin_totale,* FROM C_IVF_CL WHERE IVF_ANNO = '2013'
 
DELETE FROM C_IVA_TO 
DELETE FROM C_IVF_CL

DELETE FROM U_IVA_TO WHERE ITO_ANNO = '2013' 
DELETE FROM U_IVF_CL WHERE IVF_ANNO = '2013'

 
select * from c_ivf_cl order by ivf_codcli ,ivf_dtfatt,ivf_numfat,ivf_codi

	SELECT
		ivf_codcli,
		ivf_dtfatt,
		ivf_numfat,
		sum(ivf_totale) as par_totale
	FROM c_ivf_cl
	GROUP BY ivf_codcli,ivf_dtfatt,ivf_numfat 
	ORDER BY ivf_codcli,ivf_dtfatt,ivf_numfat
	
 