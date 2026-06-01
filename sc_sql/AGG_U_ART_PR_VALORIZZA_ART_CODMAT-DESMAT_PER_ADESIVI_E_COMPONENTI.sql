
/****************************************************************************************/
/*    							     				*/
/*    Aggiorna i campi ART_CODMAT, ART_DESMAT nella tabella U_ART_PR per gli   		*/
/*    articoli con categoria 'AD' (adesivi, reticolanti, catalizzatori...)		*/
/*    							     				*/
/****************************************************************************************/


UPDATE U_ART_PR 
SET ART_CODMAT = '004', ART_DESMAT = 'ADESIVI'
WHERE ART_CODCAT = 'AD'


SELECT ART_CODPRI,ART_DESCR,ART_CODMAT,ART_DESMAT,ART_CODCAT,ART_DESCAT,* 
FROM U_ART_PR 
WHERE ART_CODCAT = 'AD' ORDER BY ART_CODPRI

