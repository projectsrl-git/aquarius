
DELETE PART_FOR 

SELECT PAR_ANNO,PAR_NUMFAT,PAR_NPART,PAR_NPROG,PAR_CODPAG,PAR_CODCLI ,PAR_NUMPRO,PAR_DTSCAD,PAR_FATT ,PAR_DESMOV ,* FROM PART_FOR ORDER BY PAR_NUMPRO DESC , PAR_NPROG 


SELECT PAR_NUMFAT,PAR_NPART,PAR_NPROG,PAR_CODPAG,PAR_CODCLI ,PAR_NUMPRO,PAR_DTSCAD,PAR_FATT ,PAR_DESMOV ,* FROM PART_FOR WHERE PAR_CODCLI = '1030000000002' ORDER BY PAR_NUMPRO , PAR_NPROG 
SELECT PAR_NPROG,PAR_CODCLI ,PAR_NUMPRO,PAR_DTSCAD,PAR_FATT ,* FROM PART_FOR WHERE PAR_NPART ='11548' ORDER BY PAR_NPROG

select * from u_cli_an where cli_codsoc = '01' and cli_codcli = '000000000' order by cli_codsoc,cli_codcli

--Soma il totale del campo par_fatt  della tabella PART_FOR mettendolo nel campo TDARE 
--per i movimenti con par_tmov = 'd' raggruppando i record per par_npart ed ordinando 
--i record per par_npart ed escludendo i record con par_nprog = 100


--Soma il totale dare ragruppando per codice cliente
SELECT par_codcli, SUM(par_fatt) AS TDARE
FROM PART_FOR
where par_nprog <> '100' and par_tmov = 'D'
GROUP BY par_codcli
ORDER BY par_codcli

--Soma il totale avere ragruppando per codice cliente
SELECT par_codcli, SUM(par_fatt) AS TAVERE
FROM PART_FOR
where par_nprog <> '100' and par_tmov = 'A'
GROUP BY par_codcli
ORDER BY par_codcli

--Soma il totale dare  
SELECT  SUM(par_fatt) AS TDARE
FROM PART_FOR
where par_nprog <> '100' and par_tmov = 'D'


--Soma il totale avere
SELECT  SUM(par_fatt) AS TAVERE
FROM PART_FOR
where par_nprog <> '100' and par_tmov = 'A'


SELECT par_codcli, SUM(par_fatt) AS par_fattd FROM PART_FOR WHERE PAR_NPROG > 100 AND PAR_TMOV = 'D'  and par_codcli = '1030000000001' group by par_codcli order by PAR_CODCLI
SELECT par_codcli, SUM(par_fatt) AS par_fatta FROM PART_FOR WHERE PAR_NPROG > 100 AND PAR_TMOV = 'A'  and par_codcli = '1030000000001' group by par_codcli order by PAR_CODCLI
