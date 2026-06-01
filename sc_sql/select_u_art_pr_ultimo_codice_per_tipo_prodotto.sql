select top 1 * from u_art_pr where len(art_codpri) = 9 and art_codpri like '02007%' order by art_codpri desc
select top 1 * from u_art_an where len(art_codpri) = 9 and art_codpri like '02007%' order by art_codpri desc
select top 1 art_codpri from u_art_an where len(art_codpri) = 9 and art_codpri like '02007%' order by art_codpri desc

		
select top 1 art_codpri from u_art_an where len(art_codpri) = 9 and art_codpri like '02007%' order by art_codpri desc

select art_codpri from u_art_an where len(art_codpri) = 9 and art_codpri like '02007%' order by art_codpri 

	SELECT top 1 * from u_art_pr where len(art_codpri) = 9 and art_codpri like '02007%' order by art_codpri desc

   
SELECT * FROM U_ART_PR WHERE ART_CODPRI = '020070012'  
select * from u_art_pr where len(art_codpri) = 11 and art_codpri like '02.007%' order by art_codpri 
select * from u_art_an where len(art_codpri) = 11 and art_codpri like '02.007%' order by art_codpri 


SELECT MAG_CODART,MAG_ANAART,* FROM U_MAG_GG
SELECT MOV_CODART,MOV_ANAART,* FROM U_MAG_MO     

SELECT * from u_mag_gg WHERE len(MAG_CODART) = 9 and MAG_CODART like '01001%' order by MAG_CODART
SELECT * from u_mag_gg WHERE MAG_CODART like '01.%' order by MAG_CODART

SELECT MAG_CODART,MAG_ANAART,* FROM U_MAG_GG WHERE MAG_CODART ='010010001'
SELECT MAG_CODART,MAG_ANAART,* FROM U_MAG_GG WHERE MAG_CODART like '01.001%'

SELECT MAG_CODART,MAG_ANAART,* FROM U_MAG_GG WHERE MAG_CODART ='01.001.0001'
SELECT MOV_CODART,MOV_ANAART,* FROM U_MAG_MO WHERE MOV_CODART ='01.001.0001'
     
