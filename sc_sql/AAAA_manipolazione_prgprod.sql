SELECT * FROM U_PRD_D1 ORDER BY PR1_NUMPRG DESC

SELECT  pr2_fascia,* FROM U_PRD_D2 
WHERE PJ_PRGPRD1 = 'PIANO_PROD_00061_2009_2O90ZAY0I'
/*
update u_prd_d2 set pr2_fascia = '1850', pr2_numbob = 2
WHERE PJ_PRGPRD1 = 'PIANO_PROD_00061_2009_2O90ZAY0I'
*/


select pr3_altezz,* from u_prd_d3 
where pj_prgprd1 = 'PIANO_PROD_00061_2009_2O90ZAY0I'
/*
delete from u_prd_d3 where pj_prgprd1='PIANO_PROD_00061_2009_2O90ZAY0I' and pj_prgprd2='FASCIA_001_01830' and pj_prgprd3='BOBINA_00003'
delete from u_prd_d4 where pj_prgprd1='PIANO_PROD_00061_2009_2O90ZAY0I' and pj_prgprd2='FASCIA_001_01830' and pj_prgprd3='BOBINA_00003'
delete from u_prd_d5 where pj_prgprd1='PIANO_PROD_00061_2009_2O90ZAY0I' and pj_prgprd2='FASCIA_001_01830' and pj_prgprd3='BOBINA_00003'

update u_prd_d3 set pr3_altezz = '1850'
where pj_prgprd1 = 'PIANO_PROD_00061_2009_2O90ZAY0I'
*/


select pr4_scarto,pr4_altezz,* from u_prd_d4 
where pj_prgprd1 = 'PIANO_PROD_00061_2009_2O90ZAY0I' and pr4_scarto <> 0 order by pj_prgprd3,pj_prgprd4
/*
update u_prd_d4 set pr4_scarto = '86', pr4_altezz = '1850'
where pj_prgprd1 = 'PIANO_PROD_00061_2009_2O90ZAY0I' and pr4_scarto <> 0
*/


select pr5_progre,pr5_altezz,pj_prgprd4,* from u_prd_d5 
where pj_prgprd1 = 'PIANO_PROD_00061_2009_2O90ZAY0I' order by pr5_progre,pr5_altezz
