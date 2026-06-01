--Soma il totale del campo ytd_sales  della tabella titles mettendolo nel campo total  raggruppando i record per pub_id ed ordinando i record per pub_id

SELECT pub_id, SUM(ytd_sales) AS total
FROM titles
GROUP BY pub_id
ORDER BY pub_id

select * from titles order by pub_id


--Soma il totale del campo par_fatt  della tabella part_cli mettendolo nel campo TDARE 
--per i movimenti con par_tmov = 'd' raggruppando i record per par_npart ed ordinando 
--i record per par_npart ed escludendo i record con par_nprog = 100


--Soma il totale dare ragruppando per codice cliente
SELECT par_codcli, SUM(par_fatt) AS TDARE
FROM part_cli
where par_nprog <> '100' and par_tmov = 'D'
GROUP BY par_codcli
ORDER BY par_codcli

--Soma il totale avere ragruppando per codice cliente
SELECT par_codcli, SUM(par_fatt) AS TAVERE
FROM part_cli
where par_nprog <> '100' and par_tmov = 'A'
GROUP BY par_codcli
ORDER BY par_codcli

--Soma il totale dare  
SELECT  SUM(par_fatt) AS TDARE
FROM part_cli
where par_nprog <> '100' and par_tmov = 'D'


--Soma il totale avere
SELECT  SUM(par_fatt) AS TAVERE
FROM part_cli
where par_nprog <> '100' and par_tmov = 'A'




--Soma il totale del campo par_fatt  della tabella part_for mettendolo nel campo par_total raggruppando i record per par_npart ed ordinando i record per par_npart

SELECT par_npart, SUM(par_fatt) AS par_fatt
FROM part_for
GROUP BY par_npart
ORDER BY par_npart

--Soma il totale del campo par_npart, par_fatt  della tabella part_for mettendolo nel campo par_total raggruppando i record per par_npart ed ordinando i record per par_npart

SELECT par_npart,par_fatt, SUM(par_fatt) AS par_total
FROM part_for
GROUP BY par_npart,par_fatt
ORDER BY par_npart,par_fatt


SELECT CLI_NAZION 
FROM U_CLI_AN 
WHERE CLI_NAZION <> 'ITA'
GROUP BY CLI_NAZION
ORDER BY CLI_NAZION

SELECT CLI_NAZION,cli_ragsoc,cli_locali,cli_indir
FROM U_CLI_AN 
WHERE CLI_NAZION <> 'ITA'
order by cli_nazion

SELECT CLI_AGE,cli_ragsoc,cli_locali,cli_indir
FROM U_CLI_AN 
WHERE CLI_AGE = '  '
order by CLI_AGE

SELECT substring(CODICE,4,3) 
FROM PARA 
WHERE substring(CODICE,1,3) = 'STA'
GROUP BY CODICE
ORDER BY CODICE

select * from titles order by pub_id 



SELECT * FROM MOV_CONT WHERE MOV_CONTO = '0124000000510'
SELECT * FROM MOV_CONT WHERE MOV_DESMOV = 'Apertura 01/01/2005                          '
SELECT * FROM INDICE WHERE MOV_DESMOV = 'Apertura 01/01/2005                          '
SELECT * FROM PART_CLI WHERE PAR_TIPFAT = 'APE'
SELECT * FROM PART_FOR WHERE PAR_TIPFAT = 'APE'
SELECT * FROM PART_FOR WHERE PAR_DESMOV = 'Apertura di Bilancio Esercizio: 2005         '
SELECT * FROM PART_CLI WHERE PAR_DESMOV = 'Apertura di Bilancio Esercizio: 2005         '







