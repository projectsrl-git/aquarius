
/* 
********************************************************************************************************
SCRIPT PER VALORIZZARE IL CAMPO ART_BASADE (BASE ADESIVO) SUGLI ARTICOLI DI VENDITA (art_tipart <> 'A'), 
IN RIFERIMENTO AL VECCHIO SISTEMA PER DETERMINARE LA BASE ADESIVO ACQUA, GOMMA, SOLVENTE
********************************************************************************************************
*/

UPDATE U_ART_PR SET ART_BASADE = substring(art_codpri,1,1) WHERE art_tipart <> 'A' and 
(substring(art_codpri,1,1) = 'A' OR substring(art_codpri,1,1) = 'R' OR substring(art_codpri,1,1) = 'S')

SELECT ART_CODPRI,art_tipart,ART_DESCR,* FROM U_ART_PR WHERE art_tipart <> 'A' and 
(substring(art_codpri,1,1) = 'A' OR substring(art_codpri,1,1) = 'R' OR substring(art_codpri,1,1) = 'S')
ORDER BY ART_CODPRI