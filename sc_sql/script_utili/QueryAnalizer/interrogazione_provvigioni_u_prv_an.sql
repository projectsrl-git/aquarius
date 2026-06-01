select prv_npart,prv_numfat,prv_imponi,prv_perpro,prv_totpro,prv_tmov,prv_disliq,prv_storic,prv_liquid,prv_dtliqu,* from u_prv_an ORDER BY PRV_NUMFAT

--DELETE FROM U_PRV_AN WHERE  prv_datfat between '2012/01/01' and '2012/01/31' and prv_codage = '052' and prv_storic <> 'S'
--DELETE FROM U_PRV_AN WHERE  prv_datfat between '2012/02/01' and '2012/02/29' and prv_codage = '052' and prv_storic <> 'S'
--DELETE FROM U_PRV_AN

SELECT * FROM PARA WHERE CODICE = 'DLP01'
