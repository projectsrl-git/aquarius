-- BEST_FSC
update u_dis_dd set dis_qta=1.1 
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'BEST_FSC-%')
and dis_codart in ('01.001.0001')

update u_dis_dd set dis_qta=0.08
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'BEST_FSC-%')
and dis_codart in ('01.002.0001')

update u_dis_dd set dis_qta=2
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'BEST_FSC-%')
and dis_codart in ('01.004.0005')

delete from u_dis_dd
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'BEST_FSC-%')
and dis_codart in ('01.004.0003')

select * from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'BEST_FSC-%')
and dis_codart in ('01.001.0001','01.002.0001','01.004.0005','01.004.0003')
order by dis_gruppo,dis_codart


-- LIGHT
update u_dis_dd set dis_qta=0.087
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT-%')
and dis_codart in ('01.002.0001')

select * from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT-%')
and dis_codart in ('01.002.0001')
order by dis_gruppo,dis_codart



-- idro_p4

update u_dis_dd set dis_qta=0.1 
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4-%')
and dis_codart in ('01.002.0001')

update u_dis_dd set dis_qta=5 
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4-%')
and dis_codart in ('01.004.0005')

--- inserire 01.004.0003 a 0,25


select * from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4-%')
and dis_codart in ('01.002.0001','01.004.0005')
order by dis_gruppo,dis_codart



-- V100_P5

-- cambio colla
update u_dis_dd set dis_codart='01.002.0005' ,dis_descri='COLLA CON MELAMINA AL 22%', dis_qta=0.11
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'V100_P5-%')
and dis_codart in ('01.002.0001')

select * from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'V100_P5-%')
and dis_codart in ('01.002.0005')
order by dis_gruppo,dis_codart


-- ignifugo

-- cambio colla
update u_dis_dd set dis_codart='01.002.0001',dis_descri='COLLA UREICA' , dis_qta=0.105
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IGNIFUGO-%')
and dis_codart in ('01.002.0005')

-- qta paraffina 
update u_dis_dd set  dis_qta=1
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IGNIFUGO-%')
and dis_codart in ('01.004.0005')

-- cambio colorante
update u_dis_dd set dis_codart='01.004.0006',dis_descri='COLORE ROSA 2BA LIQUIDO (ROSSO)' , dis_qta=0.5
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IGNIFUGO-%')
and dis_codart in ('01.004.0003')

---- inserire 01.004.0001 a 95

select * from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IGNIFUGO-%')
and dis_codart in ('01.002.0005','01.004.0005','01.004.0003')
order by dis_gruppo,dis_codart



-- cleaf

-- qta colla
update u_dis_dd set  dis_qta=0.095
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart in ('01.002.0001')

-- qta paraffina

update u_dis_dd set  dis_qta=2.5
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart in ('01.004.0005')

-- cambio componente
update u_dis_dd set dis_codart='01.004.0002' ,dis_descri='SODIO METABISOLFITO BB KG 1100', dis_qta=3.5,dis_um='KG'
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart in ('01.004.0001')

-- cambio componente
update u_dis_dd set dis_codart='01.002.0002' ,dis_descri='UREA 40%', dis_qta=2.5,dis_um='KG'
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart in ('01.004.0006')

select * from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart in ('01.002.0001','01.004.0005','01.004.0002','01.002.0002')
order by dis_gruppo,dis_codart



-- aggiorna qta legno

select dis_qta,1.1*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart

update u_dis_dd set dis_qta=1.1*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT-%')
and dis_codart like '01.001.%'


select dis_qta,1.1*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT_FSC-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart

update u_dis_dd set dis_qta=1.1*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT_FSC-%')
and dis_codart like '01.001.%'


select dis_qta,1.1*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT_EPFS-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart

update u_dis_dd set dis_qta=1.1*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'LIGHT_EPFS-%')
and dis_codart like '01.001.%'


select dis_qta,1.15*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart

update u_dis_dd set dis_qta=1.15*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4-%')
and dis_codart like '01.001.%'

select dis_qta,1.15*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4_EPFS-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart

update u_dis_dd set dis_qta=1.15*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IDRO_P4_EPFS-%')
and dis_codart like '01.001.%'


select dis_qta,1.1*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'V100_P5-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart


update u_dis_dd set dis_qta=1.1*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'V100_P5-%')
and dis_codart like '01.001.%'


select dis_qta,1.1*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'V100_P5_EPFS-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart

update u_dis_dd set dis_qta=1.1*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'V100_P5_EPFS-%')
and dis_codart like '01.001.%'


select dis_qta,1.15*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IGNIFUGO-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart


update u_dis_dd set dis_qta=1.15*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'IGNIFUGO-%')
and dis_codart like '01.001.%'


select dis_qta,1.05*dis_qta,* from u_dis_dd where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart like '01.001.%'
order by dis_gruppo,dis_codart


update u_dis_dd set dis_qta=1.05*dis_qta  
where dis_gruppo in (select art_codpri from u_art_pr where art_codpri like 'CLEAF-%')
and dis_codart like '01.001.%'
















